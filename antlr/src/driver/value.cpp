#include "value.h"

Value::Value(std::string _name, Type _type, Behavior _beh)
    : type(_type), behavior(_beh), name(_name) {}

std::string Value::getName() const { return name; }
std::string Value::getSubscript() const { return subscript; }
Value::Type Value::getType() const { return type; }
void Value::setBehavior(Value::Behavior b) { behavior = b; }
Value::Behavior Value::getBehavior() const { return behavior; }
std::string Value::getFullText() const {
  if (type == Type::virtualReg) {
    return getName() + "_" + getSubscript();
  } else {
    return getName();
  }
}

void Value::setName(std::string newname) { name = newname; }
void Value::setSubscript(std::string sub) { subscript = sub; }
void Value::setType(Value::Type t) { type = t; }

bool operator==(const Value &a, const Value &b) {
  return a.getFullText() == b.getFullText() && a.getType() == b.getType();
}

bool operator!=(const Value &a, const Value &b) { return !(a == b); }
