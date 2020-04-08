#pragma once

#include "pass.h"

class RegisterAllocationPass : public Pass {
public:
  IlocProgram applyToProgram(IlocProgram prog);
};