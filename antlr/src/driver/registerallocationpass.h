#pragma once

#include "interferencegraph.h"
#include "pass.h"

class RegisterAllocationPass : public Pass {
public:
  IlocProgram applyToProgram(IlocProgram prog);

private:
  void colorGraph(InterferenceGraph &igraph, unsigned int k);
  bool spillRegisters(IlocProcedure &proc, InterferenceGraph &igraph,
                      LiveRangesPass lrpass, std::set<LiveRange> &spilledSet);
  void createStoreAIInst(Value value, LiveRange valueRange, IlocProcedure &proc,
                         std::vector<Instruction> &list,
                         std::vector<Instruction>::iterator pos);
  void createLoadAIInst(Value value, LiveRange valueRange, IlocProcedure &proc,
                        std::vector<Instruction> &list,
                        std::vector<Instruction>::iterator pos);
  std::unordered_map<std::string, std::unordered_map<LiveRange, unsigned int>>
      _offsetMap;
  std::unordered_map<std::string, bool> _dirtyMap;
};
