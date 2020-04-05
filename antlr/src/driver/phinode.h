#pragma once

#include <unordered_map>

#include "value.h"

class BasicBlock;

class PhiNode {
public:
  PhiNode(Value value);
  Value getLValue() const;
  void setLValue(Value lvalue);
  Value getRValue(BasicBlock pred) const;
  void replaceRValue(BasicBlock pred, Value value);
  std::unordered_map<std::string, Value> getRValueMap() const;
  void addRValue(BasicBlock block, Value value);
  bool isDeleted() const;
  void markAsDeleted();

private:
  bool _deleted;
  Value _lValue;
  std::unordered_map<std::string, Value> _rValueMap;
};

namespace std {
template <> struct hash<PhiNode> {
  std::size_t operator()(const PhiNode &p) const noexcept {
    return std::hash<Value>{}(p.getLValue());
  }
};
} // namespace std

bool operator==(const PhiNode &a, const PhiNode &b);
