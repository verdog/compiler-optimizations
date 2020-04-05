#pragma once

#include <set>
#include <string>
#include <vector>

#include "ilocParser.h"

#include "value.h"

class Operation {
public:
  Operation(uint opcode);
  void recategorize();
  Value::Behavior generateBehavior();
  void fixValues();

  enum class Category {
    unknown,
    expression,
    memory,
    loadimmediate,
    branch,
    io,
    test,
    nop
  };

  uint opcode;
  Category category;
  std::string arrow;
  std::vector<Value> lvalues;
  std::vector<Value> rvalues;

private:
};

class Instruction {
public:
  Instruction(Operation o);
  std::string label;
  std::string containingBlockName;
  Operation operation;

  bool isDeleted() const;
  void changeToLoadI(int rvalue);
  void changeToMove(std::string rvalue);
  void markAsDeleted();
  bool hasPossibleSideEffects() const;

private:
  bool deleted;
};

namespace std {
template <> struct hash<Operation> {
  std::size_t operator()(const Operation &o) const noexcept {
    std::size_t h1 = std::hash<unsigned int>{}(o.opcode);
    // https://stackoverflow.com/questions/20511347/a-good-hash-function-for-a-vector
    std::size_t h2 = o.rvalues.size();
    for (auto r : o.rvalues) {
      h2 ^= std::hash<Value>{}(r) + 0x9e3779b9 + (h2 << 6) + (h2 >> 2);
    }
    std::size_t h3 = o.lvalues.size();
    for (auto l : o.lvalues) {
      h3 ^= std::hash<Value>{}(l) + 0x9e3779b9 + (h3 << 6) + (h3 >> 2);
    }
    return (h1 << 32) ^ (h2 << 16) ^ h3;
  }
};

template <> struct hash<Instruction> {
  std::size_t operator()(const Instruction &i) const noexcept {
    std::size_t h1 = std::hash<std::string>{}(i.label);
    std::size_t h2 = std::hash<bool>{}(i.isDeleted());
    std::size_t h3 = std::hash<Operation>{}(i.operation);

    return (h1 << 32) ^ (h2 << 16) ^ h3;
  }
};
} // namespace std

bool operator==(const Instruction &a, const Instruction &b);
bool operator==(const Operation &a, const Operation &b);