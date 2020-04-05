#include "phinode.h"
#include "basicblock.h"

PhiNode::PhiNode(Value value) : _lValue(value), _deleted{false} {}

Value PhiNode::getLValue() const { return _lValue; }

void PhiNode::setLValue(Value lvalue) { _lValue = lvalue; }

Value PhiNode::getRValue(BasicBlock pred) const {
  return _rValueMap.at(pred.debugName);
}

void PhiNode::replaceRValue(BasicBlock pred, Value value) {
  _rValueMap.at(pred.debugName) = value;
}

std::unordered_map<std::string, Value> PhiNode::getRValueMap() const {
  return _rValueMap;
}

void PhiNode::addRValue(BasicBlock block, Value value) {
  _rValueMap.insert({block.debugName, value});
}

bool operator==(const PhiNode &a, const PhiNode &b) {
  return a.getLValue() == b.getLValue();
}

bool PhiNode::isDeleted() const { return _deleted; }

void PhiNode::markAsDeleted() { _deleted = true; }
