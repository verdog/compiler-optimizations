#pragma once

#include <vector>

#include "basicblock.h"

class DominatorTree {
public:
  DominatorTree() = default;
  DominatorTree(BasicBlock block);
  void setBasicBlock(BasicBlock block);
  BasicBlock getBasicBlock() const;

  bool hasBlockByName(std::string name);
  DominatorTree findNodeByBlockname(std::string name);
  DominatorTree findParentOf(std::string name);

  void addChild(DominatorTree node);
  void replaceChild(DominatorTree old, DominatorTree fresh);
  void clearChildren();
  std::vector<DominatorTree> getChildren() const;

  bool dominates(BasicBlock block) const;
  bool strictlyDominates(BasicBlock block) const;

  std::vector<BasicBlock>
  buildListPreorder(std::vector<BasicBlock> list = std::vector<BasicBlock>());
  void printPreorder(unsigned int depth = 0);

private:
  BasicBlock _block;
  std::vector<DominatorTree> _children;
};

bool operator==(const DominatorTree &a, const DominatorTree &b);
