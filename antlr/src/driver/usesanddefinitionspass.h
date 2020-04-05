#pragma once

#include "pass.h"

class UsesAndDefinitionsPass : public Pass {
public:
  IlocProgram applyToProgram(IlocProgram proc);

private:
  void calculateSSAInfo(IlocProcedure &proc);
};