#pragma once

#include "basicblock.h"
#include "instruction.h"
#include "phinode.h"

class ValueOccurance {
public:
  enum class Tag { phinode, instruction, predefined };
  const Tag tag;
  const std::string containingBlock;

  virtual ~ValueOccurance() = default;

protected:
  ValueOccurance(Tag t, BasicBlock block);

private:
};

class PhiNodeValueOccurance : public ValueOccurance {
public:
  PhiNodeValueOccurance(PhiNode phi, BasicBlock block);
  const PhiNode phinode;
};

class InstructionValueOccurance : public ValueOccurance {
public:
  InstructionValueOccurance(Instruction inst, BasicBlock block);
  const Instruction inst;
};

class PredefinedValueOccurance : public ValueOccurance {
public:
  PredefinedValueOccurance(Value val, BasicBlock block);
  const Value val;
};

namespace std {
template <> struct hash<PhiNodeValueOccurance> {
  std::size_t operator()(const PhiNodeValueOccurance &p) const noexcept {
    return std::hash<Value>{}(p.phinode.getLValue());
  }
};
template <> struct hash<InstructionValueOccurance> {
  std::size_t operator()(const InstructionValueOccurance &i) const noexcept {
    std::size_t h1 = std::hash<std::string>{}(i.inst.label);
    std::size_t h2 = std::hash<bool>{}(i.inst.isDeleted());
    std::size_t h3 = std::hash<Operation>{}(i.inst.operation);

    return (h1 << 32) ^ (h2 << 16) ^ h3;
  }
};
} // namespace std
