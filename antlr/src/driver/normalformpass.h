#pragma once

#include "pass.h"

class NormalFormPass : public Pass {
public:
  IlocProgram applyToProgram(IlocProgram prog);

private:
};
