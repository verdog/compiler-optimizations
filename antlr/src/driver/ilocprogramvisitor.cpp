#include <algorithm>
#include <iostream>
#include <set>
#include <unordered_map>

#include "antlr4-runtime.h"
#include "ilocParser.h"

#include "basicblock.h"
#include "frame.h"
#include "ilocprogramvisitor.h"
#include "lvnpass.h"

IlocProgram
IlocProgramVisitor::extractProgram(ilocParser::ProgramContext *ctx) {
  return visitProgram(ctx).as<IlocProgram>();
}

antlrcpp::Any
IlocProgramVisitor::visitProgram(ilocParser::ProgramContext *ctx) {
  IlocProgram me;

  if (ctx->data()) {
    auto psuedoOps = visitData(ctx->data()).as<std::vector<std::string>>();
    me.addPseudoOp(".data");
    me.addPseudoOps(psuedoOps);
  }

  me.addPseudoOp(".text");

  auto procedures = visitProcedures(ctx->procedures());

  me.addProcedures(procedures.as<std::vector<IlocProcedure>>());

  return me;
}

antlrcpp::Any IlocProgramVisitor::visitData(ilocParser::DataContext *ctx) {
  std::vector<std::string> psuedoOps;

  for (auto psop : ctx->pseudoOp()) {
    psuedoOps.push_back(visitPseudoOp(psop).as<std::string>());
  }

  return psuedoOps;
}

antlrcpp::Any
IlocProgramVisitor::visitPseudoOp(ilocParser::PseudoOpContext *ctx) {
  std::string text;

  for (auto c : ctx->children) {
    text += c->getText() + " ";
  }

  // chop off last space
  return text.substr(0, text.length() - 1);
}

antlrcpp::Any
IlocProgramVisitor::visitProcedures(ilocParser::ProceduresContext *ctx) {
  std::vector<IlocProcedure> us;

  for (auto proc : ctx->procedure()) {
    // get procedure
    auto me = visitProcedure(proc).as<IlocProcedure>();
    us.push_back(me);
  }

  return us;
}

antlrcpp::Any
IlocProgramVisitor::visitProcedure(ilocParser::ProcedureContext *ctx) {
  std::vector<Instruction> instructions;
  IlocProcedure me;

  // get frame information
  auto frame = visitFrameInstruction(ctx->frameInstruction()).as<Frame>();
  me.setFrame(frame);

  // build list of instructions
  for (auto inst_ctx : ctx->ilocInstruction()) {
    Instruction inst = visitIlocInstruction(inst_ctx).as<Instruction>();
    instructions.push_back(inst);
  }

  // turn instructions into basic blocks
  std::unordered_map<std::string, BasicBlock> blocks;
  std::vector<std::pair<std::string, std::string>> toLink;
  std::string currentBlockName = "entry";
  blocks.emplace(currentBlockName, BasicBlock(currentBlockName));
  uint nextKey = 0;
  std::pair<std::string, std::string> pendingLink = {"", ""};

  for (auto inst : instructions) {
    // make new block on labels
    if (inst.label != "") {
      // link to block we're about to make
      toLink.push_back({currentBlockName, inst.label});

      // create block
      currentBlockName = inst.label;
      blocks.emplace(currentBlockName, BasicBlock(currentBlockName));
    }

    // connect anything pending
    if (pendingLink.first != "") {
      toLink.push_back({pendingLink.first, currentBlockName});
      pendingLink = {"", ""};
    }

    // record instruction
    inst.containingBlockName = currentBlockName;
    blocks.at(currentBlockName).instructions.push_back(inst);

    // make new block after branches
    if (inst.operation.category == Operation::Category::branch) {
      // link to lvalues
      for (auto val : inst.operation.lvalues) {
        toLink.push_back({currentBlockName, val.getName()});
      }

      // create pending link to link up to fall-through block
      pendingLink.first = currentBlockName;

      // create block
      currentBlockName = "unamed" + std::to_string(nextKey++);
      blocks.emplace(currentBlockName, BasicBlock(currentBlockName));
    }
  }

  // remove any blocks of zero length. these get created either when the last
  // instruction is a branch (including a return) or a block is created after
  // a branch, but the branch is immediately followed by a labeled instruction
  std::vector<std::string> toErase;
  for (auto pair : blocks) {
    if (pair.second.instructions.size() == 0) {
      toErase.push_back(pair.first);
    }
  }
  for (auto blk : toErase) {
    blocks.erase(blk);
  }

  // std::cerr << "Created " << blocks.size() << " basic blocks." << std::endl;

  // find the exit block
  if (blocks.size() > 1) {
    bool found_exit = false;
    std::string oldName;
    for (auto &pair : blocks) {
      auto &block = pair.second;
      if (block.instructions.back().operation.opcode == ilocParser::RET) {
        // found an exit node
        if (found_exit == true) {
          // we already have an exit node?
          throw "we already have an exit node?";
        }

        found_exit = true;

        // set exit block
        me.setExitBlockName(block.debugName);

        // optimization: break after finding the exit block
        // not doing this yet in case we find weird cases with multiple exit
        // blocks

        // break;
      }
    }
  }

  // link up basic blocks by looking at our saved list
  for (auto pair : toLink) {
    // it's possible that some of the blocks saved in link pairs got deleted
    if (blocks.find(pair.first) != blocks.end() and
        blocks.find(pair.second) != blocks.end()) {
      blocks.at(pair.first).after.push_back(pair.second);
      blocks.at(pair.second).before.push_back(pair.first);
    }
  }

  // debug print
  // for (auto pair : blocks) {
  //     std::cerr << pair.second.toString();
  //     std::cerr << "before:";
  //     for (auto name : pair.second.before) {
  //         std::cerr << " " << name;
  //     }
  //     std::cerr << std::endl;

  //     std::cerr << "after:";
  //     for (auto name : pair.second.after) {
  //         std::cerr << " " << name;
  //     }
  //     std::cerr << std::endl << std::endl;
  // }

  me.addBlocks(blocks);
  return me;
}

antlrcpp::Any IlocProgramVisitor::visitFrameInstruction(
    ilocParser::FrameInstructionContext *ctx) {
  Frame me;

  me.name = ctx->LABEL()->getText();

  me.number = ctx->NUMBER()->getText();

  for (auto arg : ctx->virtualReg()) {
    me.arguments.emplace_back(arg->getText(), Value::Type::virtualReg,
                              Value::Behavior::expression);
  }

  return me;
}

antlrcpp::Any IlocProgramVisitor::visitIlocInstruction(
    ilocParser::IlocInstructionContext *ctx) {
  // record opcode
  if (!ctx->operation()) {
    throw("No operation in instruction?");
  }

  Operation myOperation = visitOperation(ctx->operation()).as<Operation>();

  if (ctx->operationList()) {
    visitOperationList(ctx->operationList());
  }

  Instruction me(myOperation);

  // record label
  if (ctx->LABEL() != nullptr) {
    me.label = ctx->LABEL()->getText();
  }

  // debug
  // std::cerr << " - Instruction: " << me.fullText() << std::endl;

  return me;
}

antlrcpp::Any
IlocProgramVisitor::visitOperation(ilocParser::OperationContext *ctx) {
  // for each operation:
  //   record:
  //     + opcode
  //     + lvalues*
  //     + rvalues*
  //     + operation type (expression | memory | branch | nop?)

  // get opcode
  auto *opcode = dynamic_cast<antlr4::tree::TerminalNode *>(ctx->children[0]);
  if (!opcode) {
    throw("Couldn't find opcode");
  }

  Operation me(opcode->getSymbol()->getType());

  // get rvalues and lvalues
  std::vector<Value> *targetList = &me.rvalues; // we start by reading rvalues
  for (auto *c : ctx->children) {
    // handle terminals
    auto *term = dynamic_cast<antlr4::tree::TerminalNode *>(c);
    if (term != nullptr) {
      auto type = term->getSymbol()->getType();
      if (type == ilocParser::NUMBER) {
        // a number
        targetList->emplace_back(term->getText(), Value::Type::number,
                                 Value::Behavior::expression);
      } else if (type == ilocParser::LABEL) {
        // a label
        targetList->emplace_back(term->getText(), Value::Type::label,
                                 Value::Behavior::unknown);
      } else if (valueBoundaries.find(type) != valueBoundaries.end()) {
        // we found an arrow/assign/call, now we're looking at lvalues
        targetList = &me.lvalues;
        me.arrow = c->getText();
      }
    }

    // check if the child is an imediate value
    auto *imval = dynamic_cast<ilocParser::ImmediateValContext *>(c);
    if (imval != nullptr) {
      if (imval->NUMBER()) {
        targetList->emplace_back(imval->getText(), Value::Type::number,
                                 Value::Behavior::expression);
      } else if (imval->LABEL()) {
        targetList->emplace_back(imval->getText(), Value::Type::label,
                                 Value::Behavior::unknown);
      }
    }

    // check if the child is a virtualreg
    auto *vreg = dynamic_cast<ilocParser::VirtualRegContext *>(c);
    if (vreg != nullptr) {
      targetList->emplace_back(vreg->getText(), Value::Type::virtualReg,
                               me.generateBehavior());
    }
  }

  me.fixValues();

  return me;
}

antlrcpp::Any
IlocProgramVisitor::visitOperationList(ilocParser::OperationListContext *ctx) {
  std::cerr << "  !!! UNHANDLED OPERATIONLIST !!!\n";
  return visitChildren(ctx);
}
