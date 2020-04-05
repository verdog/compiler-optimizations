#pragma once

#include "dominatortreepass.h"
#include "pass.h"

class RegisterBehaviorPass : public Pass {
public:
  IlocProgram applyToProgram(IlocProgram prog);

private:
  void setRegisterBehaviors(IlocProcedure &proc, BasicBlock &block);
  DominatorTreePass _DTreePass;
  std::unordered_map<Value, Value::Behavior, ValueNameHash, ValueNameEqual>
      _knownBehaviorMap;
};