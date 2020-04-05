#pragma once

#include <string>
#include <unordered_map>
#include <vector>

#include "basicblock.h"
#include "expression.h"
#include "instruction.h"
#include "pass.h"

class LVNPass : public Pass {
public:
  IlocProgram applyToProgram(IlocProgram program) override;

private:
  std::vector<BasicBlock> applyLVNtoBlocks(std::vector<BasicBlock> blocks);
  int calculateConstantOp(Expression e, Instruction i) const;
  void resetTables();
  void subsume(Value l, std::string name);
  void applySubsume(Instruction &inst);
  void removeSubsume(Value lvalue);
  void propagateConstants(Instruction &inst);
  uint valNum(std::string name);
  void setValNum(Value val, uint number);
  bool isConstant(const Value &v);
  void swapRValues(Instruction &inst);
  uint nextID = 1;

  std::unordered_map<uint, int> constantTable;
  std::unordered_map<Expression, std::string> expressionTable;
  struct SymbolTableEntry {
    uint number;
    std::string subsumedBy;
    std::vector<std::string> subsumes;
  };
  std::unordered_map<std::string, SymbolTableEntry> symbolTable;

  class ConstantPropagationError : public std::runtime_error {
  public:
    ConstantPropagationError();
  };
};
