#pragma once

#include "dominatortree.h"

class DominanceFrontiers {
public:
  enum class Mode { dominator, postdominator };
  DominanceFrontiers(DominatorTree tree, Mode mode = Mode::dominator);
  std::set<BasicBlock> getDominanceFrontier(BasicBlock block) const;
  Mode getMode();

  void dump() const;

private:
  void buildDominanceFrontiers(DominatorTree tree);
  std::unordered_map<BasicBlock, std::set<BasicBlock>> _frontiersMap;

  DominatorTree _root;
  Mode _mode;
};
