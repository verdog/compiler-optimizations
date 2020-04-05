#include <string>

#include "antlr4-runtime.h"

#include "instruction.h"

std::set<uint> expressionCategory = {
    ilocParser::ADD, ilocParser::SUB, ilocParser::MULT, ilocParser::LSHIFT,
    ilocParser::RSHIFT, ilocParser::MOD, ilocParser::AND, ilocParser::OR,
    ilocParser::NOT, ilocParser::ADDI, ilocParser::SUBI, ilocParser::MULTI,
    ilocParser::LSHIFTI, ilocParser::RSHIFTI,

    // float
    ilocParser::FADD, ilocParser::FSUB, ilocParser::FMULT, ilocParser::FDIV,

    // comparisons
    ilocParser::CMP_LT, ilocParser::CMP_LE, ilocParser::CMP_GT,
    ilocParser::CMP_GE, ilocParser::CMP_EQ, ilocParser::CMP_NE,
    ilocParser::COMP, ilocParser::FCOMP,

    // conversions
    ilocParser::F2I, ilocParser::I2F,

    // functions
    ilocParser::CALL, ilocParser::ICALL, ilocParser::FCALL};

std::set<uint> testCategory = {ilocParser::TESTEQ, ilocParser::TESTNE,
                               ilocParser::TESTGT, ilocParser::TESTGE,
                               ilocParser::TESTLT, ilocParser::TESTLE};

std::set<uint> memoryCategory = {
    ilocParser::I2I,      ilocParser::F2F,     ilocParser::LOAD,
    ilocParser::LOADAI,   ilocParser::LOADAO,  ilocParser::STORE,
    ilocParser::STOREAI,  ilocParser::STOREAO, ilocParser::FLOAD,
    ilocParser::FLOADAI,  ilocParser::FLOADAO, ilocParser::FSTORE,
    ilocParser::FSTOREAI, ilocParser::FSTOREAO};

std::set<uint> loadImmediateCategory = {
    ilocParser::LOADI,
};

std::set<uint> branchCategory = {
    ilocParser::JUMPI,  ilocParser::JUMP,   ilocParser::CBR,
    ilocParser::CBRNE,  ilocParser::CBR_LT, ilocParser::CBR_LE,
    ilocParser::CBR_GT, ilocParser::CBR_GE, ilocParser::CBR_EQ,
    ilocParser::CBR_NE, ilocParser::RET,    ilocParser::IRET,
    ilocParser::FRET};

std::set<uint> ioCategory = {ilocParser::FREAD, ilocParser::IREAD,
                             ilocParser::FWRITE, ilocParser::IWRITE,
                             ilocParser::SWRITE};

std::set<uint> sideEffectCategory = {
    ilocParser::CALL,     ilocParser::ICALL,    ilocParser::FCALL,
    ilocParser::RET,      ilocParser::IRET,     ilocParser::FRET,
    ilocParser::LOADAI,   ilocParser::LOADAO,   ilocParser::STORE,
    ilocParser::STOREAI,  ilocParser::STOREAO,  ilocParser::FLOAD,
    ilocParser::FLOADAI,  ilocParser::FLOADAO,  ilocParser::FSTORE,
    ilocParser::FSTOREAI, ilocParser::FSTOREAO, ilocParser::JUMPI,
    ilocParser::JUMP,     ilocParser::FREAD,    ilocParser::IREAD,
    ilocParser::FWRITE,   ilocParser::IWRITE,   ilocParser::SWRITE};

Operation::Operation(uint _opcode) : opcode(_opcode) { recategorize(); }

void Operation::recategorize() {
  // categorize based on opcode
  if (expressionCategory.find(opcode) != expressionCategory.end()) {
    // it's an expression
    category = Category::expression;
  } else if (memoryCategory.find(opcode) != memoryCategory.end()) {
    // it's a memory operation
    category = Category::memory;
  } else if (loadImmediateCategory.find(opcode) !=
             loadImmediateCategory.end()) {
    // it's a load immediate
    category = Category::loadimmediate;
  } else if (branchCategory.find(opcode) != branchCategory.end()) {
    // it's a branch
    category = Category::branch;
  } else if (ioCategory.find(opcode) != ioCategory.end()) {
    // it's an io operation
    category = Category::io;
  } else if (testCategory.find(opcode) != testCategory.end()) {
    // it's a test
    category = Category::test;
  } else if (opcode == ilocParser::NOP) {
    // it's a nop
    category = Category::nop;
  } else {
    // i don't know!
    throw "Unknown opcode when trying to categorize: " + std::to_string(opcode);
  }
}

Value::Behavior Operation::generateBehavior() {
  if (category == Operation::Category::memory) {
    return Value::Behavior::memory;
  } else if (category == Operation::Category::expression ||
             category == Operation::Category::loadimmediate) {
    return Value::Behavior::expression;
  } else {
    return Value::Behavior::unknown;
  }
}

void Operation::fixValues() {
  // if a store operation, the "lvalue" should really betreated like an rvalue,
  // since store does not store into %vrx, but MEMORY(%vrx)

  if (opcode == ilocParser::STORE || opcode == ilocParser::STOREAI ||
      opcode == ilocParser::STOREAO) {
    for (auto lval : lvalues) {
      lvalues.pop_back();
      rvalues.push_back(lval);
    }
  }
}

Instruction::Instruction(Operation o) : operation(o), deleted(false) {}

std::unordered_map<Operation::Category, std::string> catMap = {
    {Operation::Category::nop, "NOP"},
    {Operation::Category::expression, "EXPRESSION"},
    {Operation::Category::memory, "MEMORY"},
    {Operation::Category::loadimmediate, "LOADI"},
    {Operation::Category::io, "IO"},
    {Operation::Category::branch, "BRANCH"},
    {Operation::Category::unknown, "UNKNOWN"}};

void Instruction::changeToLoadI(int rvalue) {
  operation.opcode = ilocParser::LOADI;
  operation.rvalues.clear();
  operation.rvalues.push_back(Value(std::to_string(rvalue), Value::Type::number,
                                    Value::Behavior::unknown));
  operation.recategorize();
}

void Instruction::changeToMove(std::string rvalue) {
  operation.opcode = ilocParser::I2I;
  operation.arrow = "=>";
  operation.rvalues.clear();
  operation.rvalues.push_back(
      Value(rvalue, Value::Type::virtualReg, Value::Behavior::unknown));
  operation.recategorize();
}

void Instruction::markAsDeleted() { deleted = true; }

bool Instruction::isDeleted() const { return deleted; }

bool Instruction::hasPossibleSideEffects() const {
  return (sideEffectCategory.count(operation.opcode) != 0);
}

bool operator==(const Instruction &a, const Instruction &b) {
  return a.label == b.label && a.isDeleted() == b.isDeleted() &&
         a.operation == b.operation;
}

bool operator==(const Operation &a, const Operation &b) {
  return a.opcode == b.opcode && a.category == b.category &&
         a.lvalues == b.lvalues && a.rvalues == b.rvalues;
}
