#pragma once

#include "dominancefrontiers.h"
#include "dominatortreepass.h"
#include "expression.h"
#include "pass.h"
#include "value.h"
#include "valueoccurance.h"

class SSAPass : public Pass {
public:
  SSAPass();
  IlocProgram applyToProgram(IlocProgram prog);

private:
  DominatorTreePass DTreePass;
  DominatorTreePass PDTreePass;
  std::set<BasicBlock> iteratedDominanceFrontier(Value variable,
                                                 IlocProcedure proc);

  void placePhiNodes(IlocProgram &prog, IlocProcedure &proc);

  void renameInit(IlocProcedure &proc);
  void rename(BasicBlock &block, IlocProcedure &proc);
  Value pushNewName(Value val);
  Value popNameStack(Value val);
  std::string newSubscript(Value val);
  std::unordered_map<std::string, std::stack<Value>> nameStackMap;
  std::unordered_map<std::string, unsigned int> nextNameMap;

  std::vector<
      std::unordered_map<Value, Operation, ValueNameHash, ValueNameEqual>>
      seenExpressionsMapStack;
  void startBlock();
  void endBlock();
  bool haveSeen(Value lval, Operation op);
  void recordSeen(Value lval, Operation op);
};
