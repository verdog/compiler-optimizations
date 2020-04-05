#pragma once

#include <string>

#include "ilocParser.h"

class Value {
public:
  enum class Type { unknown, virtualReg, number, label };
  enum class Behavior { unknown, memory, expression, mixedexpression };

  Value() = delete;
  Value(std::string text, Type type, Behavior beh);

  Type getType() const;
  void setBehavior(Value::Behavior b);
  Behavior getBehavior() const;
  std::string getName() const;
  std::string getSubscript() const;
  std::string getFullText() const;
  void setName(std::string name);
  void setSubscript(std::string sub);

  void setType(Type t);

private:
  Type type;
  Behavior behavior;
  std::string name;
  std::string subscript;
};

struct ValueNameHash {
  std::size_t operator()(const Value &v) const noexcept {
    return std::hash<std::string>{}(v.getName());
  }
};

struct ValueNameEqual {
  std::size_t operator()(const Value &a, const Value &b) const noexcept {
    return a.getName() == b.getName();
  }
};

namespace std {
template <> struct hash<Value> {
  std::size_t operator()(const Value &v) const noexcept {
    return std::hash<std::string>{}(v.getFullText());
  }
};
} // namespace std

bool operator==(const Value &a, const Value &b);
bool operator!=(const Value &a, const Value &b);
