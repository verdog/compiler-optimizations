#include "basicblock.h"

uint BasicBlock::nextOrder = 0;

bool operator<(const BasicBlock &a, const BasicBlock &b) {
  return a.debugName < b.debugName;
}

bool operator==(const BasicBlock &a, const BasicBlock &b) {
  return a.debugName == b.debugName && a.order == b.order &&
         a.after == b.after && a.before == b.before &&
         a.instructions == b.instructions;
}

bool operator!=(const BasicBlock &a, const BasicBlock &b) {
  return !(a.debugName == b.debugName);
}

BasicBlock::BasicBlock(std::string str)
    : debugName(str), order(BasicBlock::nextOrder++) {}

Instruction &BasicBlock::findInstruction(Instruction findInst) {
  for (auto &inst : instructions) {
    if (inst == findInst) {
      return inst;
    }
  }

  throw "couldn't find instruction in block";
}