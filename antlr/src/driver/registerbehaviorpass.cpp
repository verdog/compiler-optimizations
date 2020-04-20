#include "registerbehaviorpass.h"

IlocProgram RegisterBehaviorPass::applyToProgram(IlocProgram prog) {
  _DTreePass.applyToProgram(prog);

  std::cerr << "determining register behaviors\n";

  for (auto &proc : prog.getProceduresReference()) {
    _knownBehaviorMap.clear();
    setRegisterBehaviors(proc, proc.getBlockReference("entry"));
  }

  return prog;
}

void RegisterBehaviorPass::setRegisterBehaviors(IlocProcedure &proc,
                                                BasicBlock &block) {
  // postorder
  for (auto child : _DTreePass.getDominatorTree(proc)
                        .findNodeByBlockname(block.debugName)
                        .getChildren()) {
    BasicBlock &next = proc.getBlockReference(child.getBasicBlock().debugName);
    setRegisterBehaviors(proc, next);
  }

  for (auto blockCopy : proc.orderedBlocks()) {
    auto &block = proc.getBlockReference(blockCopy.debugName);

    for (auto &inst : block.instructions) {
      if (inst.operation.category == Operation::Category::memory) {
        for (auto &lval : inst.operation.lvalues) {
          lval.setBehavior(Value::Behavior::memory);
          _knownBehaviorMap[lval] = Value::Behavior::memory;
        }
      }

      if (inst.operation.category == Operation::Category::loadimmediate) {
        Value &lval = inst.operation.lvalues.front();
        lval.setBehavior(Value::Behavior::expression);
        _knownBehaviorMap[lval] = Value::Behavior::expression;
      }

      if (inst.operation.category == Operation::Category::expression) {
        Value::Behavior newBeh = Value::Behavior::expression;

        for (auto &rval : inst.operation.rvalues) {
          if (_knownBehaviorMap[rval] == Value::Behavior::memory)
            newBeh = Value::Behavior::mixedexpression;
        }

        for (auto &lval : inst.operation.lvalues) {
          lval.setBehavior(newBeh);
          _knownBehaviorMap[lval] = newBeh;
        }
      }
    }
  }
}
