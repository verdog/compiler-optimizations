#include "dominancefrontiers.h"

DominanceFrontiers::DominanceFrontiers(DominatorTree tree,
                                       DominanceFrontiers::Mode mode)
    : _root{tree}, _mode{mode} {
  buildDominanceFrontiers(tree);
}

std::set<BasicBlock>
DominanceFrontiers::getDominanceFrontier(BasicBlock block) const {
  return _frontiersMap.at(block);
}

void DominanceFrontiers::buildDominanceFrontiers(DominatorTree tree) {
  for (auto node : tree.getChildren()) {
    buildDominanceFrontiers(node);
  }

  // initialize
  _frontiersMap.insert({tree.getBasicBlock(), {}});

  for (auto child : tree.getChildren()) {
    // propagate
    for (auto block : _frontiersMap.at(child.getBasicBlock())) {
      if (!tree.strictlyDominates(block)) {
        _frontiersMap.at(tree.getBasicBlock()).insert(block);
      }
    }
  }

  // add new blocks
  std::vector<std::string> blockList;
  if (_mode == Mode::dominator)
    blockList = tree.getBasicBlock().after;
  else
    blockList = tree.getBasicBlock().before;

  for (auto blockName : blockList) {
    if (!tree.hasBlockByName(blockName) ||
        blockName == tree.getBasicBlock().debugName) {
      BasicBlock block = _root.findNodeByBlockname(blockName).getBasicBlock();
      _frontiersMap.at(tree.getBasicBlock()).insert(block);
    }
  }
}

DominanceFrontiers::Mode DominanceFrontiers::getMode() { return _mode; }

void DominanceFrontiers::dump() const {
  // debug output
  for (auto pair : _frontiersMap) {
    std::cerr << "dominance frontier for " << pair.first.debugName << ":\n";
    for (auto block : _frontiersMap.at(pair.first)) {
      std::cerr << "   " << block.debugName << std::endl;
    }
  }
}
