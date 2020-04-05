#pragma once

#include "dominancefrontiers.h"
#include "dominatortreepass.h"
#include "pass.h"
#include "valueoccurance.h"

class DeadCodeEliminationPass : public Pass {
public:
  DeadCodeEliminationPass();
  IlocProgram applyToProgram(IlocProgram prog);

private:
  void eliminateDeadCode(IlocProcedure &proc);
  std::vector<Value> getRValuesFrom(const Instruction &inst);
  std::vector<Value> getRValuesFrom(const PhiNode &phi);
  std::string getContainingBlockName(const Instruction &inst,
                                     const IlocProcedure &proc);
  std::string getContainingBlockName(const PhiNode &phi,
                                     const IlocProcedure &proc);
  void addDefinitionOfRValue(Value r, const IlocProcedure &proc);
  void addBranchesToBlock(const BasicBlock &block,
                          const DominanceFrontiers &PDF);

  DominatorTreePass PDTreePass;
  std::vector<Instruction> _instWorklist;
  std::vector<PhiNode> _phiWorkList;
  std::unordered_set<Instruction> _instVisited;
  std::unordered_set<Instruction> _instNecessary;
  std::unordered_set<PhiNode> _phiVisited;
  std::unordered_set<PhiNode> _phiNecessary;
};
