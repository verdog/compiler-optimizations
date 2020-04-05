#pragma once

#include "ilocprogram.h"

class Pass {
public:
  virtual IlocProgram applyToProgram(IlocProgram program) = 0;

private:
};
