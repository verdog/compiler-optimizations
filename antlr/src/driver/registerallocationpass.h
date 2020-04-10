#pragma once

#include "interferencegraph.h"
#include "pass.h"

class RegisterAllocationPass : public Pass {
public:
  IlocProgram applyToProgram(IlocProgram prog);

private:
  void colorGraph(InterferenceGraph &igraph, unsigned int k);
};
