#pragma once

#include <cstddef>
#include <functional>

#include "instruction.h"
#include "value.h"

class Expression {
public:
  Expression() {
    rValueOne = 0;
    rValueTwo = 0;
    opcode = -1;
  }

  unsigned int rValueOne;
  unsigned int rValueTwo;
  size_t opcode;
};

class ValueExpression {
public:
  ValueExpression() = delete;
  ValueExpression(const Instruction &i)
      : rValueOne("__NULL__", Value::Type::unknown, Value::Behavior::unknown),
        rValueTwo("__NULL__", Value::Type::unknown, Value::Behavior::unknown) {
    if (i.operation.rvalues.size() == 1) {
      rValueOne = i.operation.rvalues.front();
    } else if (i.operation.rvalues.size() == 2) {
      rValueOne = i.operation.rvalues[0];
      rValueTwo = i.operation.rvalues[1];
    }
    opcode = i.operation.opcode;
  }

  Value rValueOne;
  Value rValueTwo;
  size_t opcode;
};

bool operator==(const Expression &a, const Expression &b);
bool operator==(const ValueExpression &a, const ValueExpression &b);

namespace std {
template <> struct hash<Expression> {
  std::size_t operator()(const Expression &e) const noexcept {
    std::size_t h1 = std::hash<unsigned int>{}(e.rValueOne);
    std::size_t h2 = std::hash<unsigned int>{}(e.rValueTwo);
    std::size_t h3 = std::hash<size_t>{}(e.opcode);
    return (h1 << 32) | (h2 << 16) | h3;
  }
};

template <> struct hash<ValueExpression> {
  std::size_t operator()(const ValueExpression &e) const noexcept {
    std::size_t h1 = std::hash<Value>{}(e.rValueOne);
    std::size_t h2 = std::hash<Value>{}(e.rValueTwo);
    std::size_t h3 = std::hash<size_t>{}(e.opcode);
    return (h1 << 32) ^ (h2 << 16) ^ h3;
  }
};
} // namespace std
