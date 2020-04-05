#pragma once

#include <vector>

#include "instruction.h"
#include "phinode.h"

class BasicBlock {
public:
  BasicBlock() = default;
  explicit BasicBlock(std::string name);
  Instruction &findInstruction(Instruction inst);

  std::vector<PhiNode> phinodes;
  std::vector<std::string> before;
  std::vector<std::string> after;
  std::vector<Instruction> instructions;
  std::string debugName;
  uint order;

  static uint nextOrder;

private:
};

bool operator<(const BasicBlock &a, const BasicBlock &b);
bool operator==(const BasicBlock &a, const BasicBlock &b);
bool operator!=(const BasicBlock &a, const BasicBlock &b);

namespace std {
template <> struct hash<BasicBlock> {
  std::size_t operator()(const BasicBlock &b) const noexcept {
    return std::hash<std::string>{}(b.debugName);
  }
};
} // namespace std
