#include <algorithm>

#include "lvnpass.h"

IlocProgram LVNPass::applyToProgram(IlocProgram program) {
  IlocProgram optimizedProgram = program;

  std::cerr << "performing local value numbering\n";

  optimizedProgram.clearProcedures();

  for (IlocProcedure proc : program.getProcedures()) {
    std::vector<BasicBlock> newBlocks = applyLVNtoBlocks(proc.orderedBlocks());
    proc.clearBlocks();
    proc.addBlocks(newBlocks);
    optimizedProgram.addProcedure(proc);
  }

  return optimizedProgram;
}

std::vector<BasicBlock>
LVNPass::applyLVNtoBlocks(std::vector<BasicBlock> blocks) {
  for (auto &block : blocks) {
    // std::cerr << "\n\n";
    resetTables();
    for (auto &inst : block.instructions) {
      // skip instructions with zero lvalue or more than 1 lvalue
      // such as nop, output, and call
      if (inst.operation.lvalues.size() == 1) {
        applySubsume(inst);
        Value lvalue = inst.operation.lvalues.front();
        // build expression
        Expression expr;
        if (inst.operation.rvalues.size() > 0) {
          expr.rValueOne = valNum(inst.operation.rvalues[0].getName());
        }
        if (inst.operation.rvalues.size() > 1) {
          expr.rValueTwo = valNum(inst.operation.rvalues[1].getName());
        }
        expr.opcode = inst.operation.opcode;

        if (inst.operation.category == Operation::Category::loadimmediate) {
          // insert into expression table if not already in there
          if (expressionTable.find(expr) == expressionTable.end()) {
            // put into expression table
            expressionTable.insert({expr, lvalue.getName()});

            // handle loadI
            uint num = valNum(inst.operation.rvalues.front().getName());
            setValNum(lvalue, num);
          } else {
            // it's already there
            inst.markAsDeleted();
          }
        } else if (inst.operation.category == Operation::Category::memory) {
          // handle move
          // maker sure it's i2i or f2f
          if (inst.operation.opcode == ilocParser::I2I ||
              inst.operation.opcode == ilocParser::F2F) {
            // handle it
            uint num = valNum(inst.operation.rvalues.front().getName());
            removeSubsume(lvalue);
            setValNum(lvalue, num);
            if (constantTable.find(num) != constantTable.end()) {
              // change to load i
              inst.changeToLoadI(constantTable.at(num));
              // std::cerr << "(changed) ";
            } else {
              subsume(lvalue, inst.operation.rvalues.front().getName());
            }
          }
        } else {
          // handle other expressions
          if (constantTable.find(expr.rValueOne) != constantTable.end() and
              constantTable.find(expr.rValueTwo) != constantTable.end()) {
            // both rvalues are constant
            // result of r1 op r2
            int res;

            try {
              res = calculateConstantOp(expr, inst);
              inst.changeToLoadI(res);
              // std::cerr << "(changed) ";
              removeSubsume(lvalue);
              setValNum(lvalue, valNum(std::to_string(res)));
            } catch (LVNPass::ConstantPropagationError &e) {
              // just don't propagate
            }
          } else {
            // check for existence
            if (expressionTable.find(expr) != expressionTable.end()) {
              // it's in there
              std::string newLValue = expressionTable.at(expr);
              uint number = valNum(newLValue);
              inst.changeToMove(newLValue);
              // std::cerr << "(changed) ";
              removeSubsume(lvalue);
              setValNum(lvalue, number);
              subsume(lvalue, newLValue);
            } else {
              // not available
              propagateConstants(inst);

              if (inst.operation.opcode != ilocParser::IREAD &&
                  inst.operation.opcode != ilocParser::FREAD) {
                // don't insert reads into the expression table. they are an
                // operation with no rvalues so once one read happens, the
                // expression table to include READ -1, -1, which will trigger
                // improper changeToMoves
                expressionTable.insert({expr, lvalue.getName()});
              }
              setValNum(lvalue, valNum(lvalue.getName()));
            }
          }
        }
      }
      // debug
      // std::cerr << inst.fullText() << "\n";
    }
  }

  return blocks;
}

void LVNPass::subsume(Value l, std::string name) {
  symbolTable.at(name).subsumes.push_back(l.getName());
  symbolTable.at(l.getName()).subsumedBy = name;
}

void LVNPass::applySubsume(Instruction &inst) {
  for (auto &v : inst.operation.rvalues) {
    if (symbolTable.find(v.getName()) != symbolTable.end()) {
      std::string subdBy = symbolTable.at(v.getName()).subsumedBy;
      if (subdBy != "") {
        v.setName(subdBy);
      }
    }
  }
}

void LVNPass::removeSubsume(Value lvalue) {
  if (symbolTable.find(lvalue.getName()) != symbolTable.end()) {
    std::vector<std::string> subsList =
        symbolTable.at(lvalue.getName()).subsumes;
    for (auto subs : subsList) {
      symbolTable.at(subs).subsumedBy = "";
    }
    symbolTable.at(lvalue.getName()).subsumes.clear();
  }
}

uint LVNPass::valNum(std::string name) {
  if (symbolTable.find(name) != symbolTable.end()) {
    return symbolTable.at(name).number;
  } else {
    // handle constants

    // https://stackoverflow.com/a/37864920
    bool isConstant =
        (name.find_first_not_of("-0123456789") == std::string::npos);

    if (isConstant == true) {
      // add it to the constant table
      constantTable.insert({nextID, std::stoi(name)});
    }

    // we've determined it's not there, create it
    symbolTable.insert({name, {nextID, "", {}}});

    // increment nextID
    nextID++;

    return symbolTable.at(name).number;
  }
}

void LVNPass::setValNum(Value val, uint number) {
  // create symbol if it's not there
  valNum(val.getName());
  symbolTable.at(val.getName()).number = number;
}

int LVNPass::calculateConstantOp(Expression e, Instruction inst) const {
  int res;

  switch (inst.operation.opcode) {
  case ilocParser::ADD: {
    res = constantTable.at(e.rValueOne) + constantTable.at(e.rValueTwo);
    break;
  }
  case ilocParser::SUB: {
    res = constantTable.at(e.rValueOne) - constantTable.at(e.rValueTwo);
    break;
  }
  case ilocParser::MULT: {
    res = constantTable.at(e.rValueOne) * constantTable.at(e.rValueTwo);
    break;
  }
  case ilocParser::DIV: {
    if (constantTable.at(e.rValueTwo) == 0) {
      throw LVNPass::ConstantPropagationError();
    }
    res = constantTable.at(e.rValueOne) / constantTable.at(e.rValueTwo);
    break;
  }
  case ilocParser::MOD: {
    if (constantTable.at(e.rValueTwo) == 0) {
      throw LVNPass::ConstantPropagationError();
    }
    res = constantTable.at(e.rValueOne) % constantTable.at(e.rValueTwo);
    break;
  }
  case ilocParser::COMP: {
    int left = constantTable.at(e.rValueOne);
    int right = constantTable.at(e.rValueTwo);
    if (left < right)
      res = 1;
    if (left == right)
      res = 0;
    if (left > right)
      res = 2;
    break;
  }
  case ilocParser::CMP_EQ: {
    if (constantTable.at(e.rValueOne) == constantTable.at(e.rValueTwo)) {
      res = -1;
    } else {
      res = 0;
    }
    break;
  }
  case ilocParser::CMP_NE: {
    if (constantTable.at(e.rValueOne) != constantTable.at(e.rValueTwo)) {
      res = -1;
    } else {
      res = 0;
    }
    break;
  }
  case ilocParser::CMP_LT: {
    if (constantTable.at(e.rValueOne) < constantTable.at(e.rValueTwo)) {
      res = -1;
    } else {
      res = 0;
    }
    break;
  }
  case ilocParser::CMP_GT: {
    if (constantTable.at(e.rValueOne) > constantTable.at(e.rValueTwo)) {
      res = -1;
    } else {
      res = 0;
    }
    break;
  }
  case ilocParser::CMP_LE: {
    if (constantTable.at(e.rValueOne) <= constantTable.at(e.rValueTwo)) {
      res = -1;
    } else {
      res = 0;
    }
    break;
  }
  case ilocParser::CMP_GE: {
    if (constantTable.at(e.rValueOne) >= constantTable.at(e.rValueTwo)) {
      res = -1;
    } else {
      res = 0;
    }
    break;
  }
  default: {
    std::cerr << "Unhandled operation when calculating result of a constant "
                 "operation.\n";
    throw "unhandled operation";
    break;
  }
  }

  return res;
}

void LVNPass::propagateConstants(Instruction &inst) {
  if (inst.operation.rvalues.size() >= 2) {
    // swap order if operation is commutative
    if (isConstant(inst.operation.rvalues[0])) {
      if (inst.operation.opcode == ilocParser::ADD or
          inst.operation.opcode == ilocParser::MULT) {
        swapRValues(inst);
      }
    }

    Value &rightVal = inst.operation.rvalues[1];
    std::string rightValText = rightVal.getName();
    uint rightValNum = valNum(rightVal.getName());

    if (isConstant(rightVal)) {
      switch (inst.operation.opcode) {
      case ilocParser::ADD: {
        // change to add immediate
        inst.operation.opcode = ilocParser::ADDI;
        rightVal.setName(std::to_string(constantTable.at(rightValNum)));
        rightVal.setType(Value::Type::number);
        break;
      }
      case ilocParser::SUB: {
        // change to sub immediate
        inst.operation.opcode = ilocParser::SUBI;
        rightVal.setName(std::to_string(constantTable.at(rightValNum)));
        rightVal.setType(Value::Type::number);
        break;
      }
      case ilocParser::MULT: {
        // change to multiply immediate
        inst.operation.opcode = ilocParser::MULTI;
        rightVal.setName(std::to_string(constantTable.at(rightValNum)));
        rightVal.setType(Value::Type::number);
        break;
      }
      case ilocParser::LSHIFT: {
        // change to left shift immediate
        inst.operation.opcode = ilocParser::LSHIFTI;
        rightVal.setName(std::to_string(constantTable.at(rightValNum)));
        rightVal.setType(Value::Type::number);
        break;
      }
      case ilocParser::RSHIFTI: {
        // change to add immediate
        inst.operation.opcode = ilocParser::RSHIFTI;
        rightVal.setName(std::to_string(constantTable.at(rightValNum)));
        rightVal.setType(Value::Type::number);
        break;
      }
      default: {
        // do nothing
        break;
      }
      }
    }
  }
}

void LVNPass::swapRValues(Instruction &inst) {
  if (inst.operation.rvalues.size() != 2) {
    std::cerr << "Tried to swap rvalues on an instruction with total rvalues "
                 "not equal to two.\n";
    throw "Can't swap that!";
  }

  Value rValue1 = inst.operation.rvalues[0];
  Value rValue2 = inst.operation.rvalues[1];

  inst.operation.rvalues.clear();

  inst.operation.rvalues.push_back(rValue2);
  inst.operation.rvalues.push_back(rValue1);
}

bool LVNPass::isConstant(const Value &v) {
  uint valnum = valNum(v.getName());
  return (constantTable.find(valnum) != constantTable.end());
}

void LVNPass::resetTables() {
  constantTable.clear();
  expressionTable.clear();
  symbolTable.clear();
}

LVNPass::ConstantPropagationError::ConstantPropagationError()
    : std::runtime_error("Error in constant propagation (divide by zero?)") {}
