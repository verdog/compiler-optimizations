#pragma once

#include <unordered_map>
#include <vector>

#include "dominatortree.h"
#include "ilocprocedure.h"
#include "pass.h"

class DominatorTreePass : public Pass {
public:
  enum class Mode { dominator, postdominator };
  DominatorTreePass(Mode mode = Mode::dominator);
  IlocProgram applyToProgram(IlocProgram prog);
  DominatorTree getDominatorTree(IlocProcedure proc);

private:
  std::unordered_map<BasicBlock, std::set<BasicBlock>>
  getDominatorsMap(IlocProcedure proc);
  DominatorTree buildTreeFromDominatorsMap(
      std::unordered_map<BasicBlock, std::set<BasicBlock>> map,
      const IlocProcedure &proc);
  DominatorTree buildTreeFromProcedure(IlocProcedure proc);
  std::unordered_map<IlocProcedure, DominatorTree> dominatorTreeMap;

  const Mode _mode;
};
