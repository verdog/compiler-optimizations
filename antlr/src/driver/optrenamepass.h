#pragma once

#include "dominancefrontiers.h"
#include "dominatortreepass.h"
#include "expression.h"
#include "pass.h"
#include "value.h"
#include "valueoccurance.h"

class OptRenamePass : public Pass {
public:
  OptRenamePass();
  IlocProgram applyToProgram(IlocProgram prog);

private:
  DominatorTreePass DTreePass;
  DominatorTreePass PDTreePass;
  std::set<BasicBlock> iteratedDominanceFrontier(Value variable,
                                                 IlocProcedure proc);

  void placePhiNodes(IlocProgram &prog, IlocProcedure &proc);

  void optRenameInit(IlocProcedure &proc);
  void optRename(BasicBlock &block, IlocProcedure &proc);
  Value pushNewName(Value val);
  Value popNameStack(Value val);
  std::string newSubscript(Value val);
  std::unordered_map<std::string, std::stack<Value>> nameStackMap;
  std::unordered_map<std::string, unsigned int> nextNameMap;

  void startBlock();
  void endBlock();
  bool isAvailable(ValueExpression e);
  void addAvailable(ValueExpression e, Value l);
  std::pair<ValueExpression, Value>
  getTopAvailableExpression(ValueExpression e);

  std::vector<std::unordered_map<ValueExpression, Value>>
      availableExpressionStack;
};
