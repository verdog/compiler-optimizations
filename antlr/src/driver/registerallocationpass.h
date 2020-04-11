#pragma once

#include "interferencegraph.h"
#include "pass.h"

class RegisterAllocationPass : public Pass {
public:
  IlocProgram applyToProgram(IlocProgram prog);

private:
  void colorGraph(InterferenceGraph &igraph, unsigned int k);
  bool spillRegisters(IlocProcedure &proc, InterferenceGraph &igraph,
                      LiveRangesPass lrpass);
  void createStoreAIInst(Value value, IlocProcedure &proc,
                         std::vector<Instruction> &list,
                         std::vector<Instruction>::iterator pos);
  void createLoadAIInst(Value value, IlocProcedure &proc,
                        std::vector<Instruction> &list,
                        std::vector<Instruction>::iterator pos);
  std::unordered_map<std::string, std::unordered_map<Value, unsigned int>>
      _offsetMap;
};
