#include "ilocprocedure.h"

bool operator==(const IlocProcedure &a, const IlocProcedure &b) {
  return a.getFrame().name == b.getFrame().name;
};

Frame IlocProcedure::getFrame() const { return frame; }
Frame &IlocProcedure::getFrameReference() { return frame; }

void IlocProcedure::setFrame(Frame newFrame) { frame = newFrame; }

void IlocProcedure::addBlock(std::string name, BasicBlock block) {
  blocks.insert({name, block});
}

void IlocProcedure::addBlocks(BlockStructure newBlocks) {
  blocks.insert(newBlocks.begin(), newBlocks.end());
}

void IlocProcedure::addBlocks(std::vector<BasicBlock> newBlocks) {
  for (auto block : newBlocks) {
    blocks.insert({block.debugName, block});
  }
}

IlocProcedure::BlockStructure IlocProcedure::getBlocks() const {
  return blocks;
}

BasicBlock IlocProcedure::getBlock(std::string name) const {
  return blocks.at(name);
}

BasicBlock &IlocProcedure::getBlockReference(std::string name) {
  return blocks.at(name);
}

void IlocProcedure::clearBlocks() { blocks.clear(); }

std::vector<BasicBlock> IlocProcedure::orderedBlocks() const {
  std::vector<BasicBlock> r;

  // extract to list and sort it by order number
  for (auto pair : blocks) {
    r.push_back(pair.second);
  }
  std::sort(r.begin(), r.end(), [](const BasicBlock &a, const BasicBlock &b) {
    return a.order < b.order;
  });

  return r;
}

std::unordered_set<Value, ValueNameHash, ValueNameEqual>
IlocProcedure::getAllVariableNames() const {
  // compute fresh
  std::unordered_set<Value, ValueNameHash, ValueNameEqual> variables;
  for (auto block : orderedBlocks()) {
    for (auto inst : block.instructions) {
      for (auto value : inst.operation.lvalues) {
        if (value.getType() == Value::Type::virtualReg) {
          variables.insert(value);
        }
      }
    }
  }

  // arguments
  for (auto arg : frame.arguments) {
    variables.insert(arg);
  }

  // special use registers
  variables.insert(
      Value("%vr0", Value::Type::virtualReg, Value::Behavior::memory));
  variables.insert(
      Value("%vr1", Value::Type::virtualReg, Value::Behavior::memory));
  variables.insert(
      Value("%vr2", Value::Type::virtualReg, Value::Behavior::memory));
  variables.insert(
      Value("%vr3", Value::Type::virtualReg, Value::Behavior::memory));

  return variables;
}

SSAInfo IlocProcedure::getSSAInfo() const { return _ssainfo; }

SSAInfo &IlocProcedure::getSSAInfoReference() { return _ssainfo; }

void IlocProcedure::setExitBlockName(std::string name) {
  _exitBlockName = name;
}
std::string IlocProcedure::getExitBlockName() const { return _exitBlockName; }
