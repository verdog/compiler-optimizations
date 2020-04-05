#pragma once

#include "pass.h"

class RemoveDeletedPass : public Pass {
public:
  IlocProgram applyToProgram(IlocProgram program) override;

private:
};
