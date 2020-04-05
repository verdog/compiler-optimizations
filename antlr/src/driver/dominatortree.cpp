#include "dominatortree.h"

DominatorTree::DominatorTree(BasicBlock block) : _block{block} {}

void DominatorTree::setBasicBlock(BasicBlock block) { _block = block; }

BasicBlock DominatorTree::getBasicBlock() const { return _block; }

bool DominatorTree::hasBlockByName(std::string name) {
  if (_block.debugName == name)
    return true;

  for (auto node : _children) {
    if (node.hasBlockByName(name)) {
      return true;
    }
  }

  return false;
}

DominatorTree DominatorTree::findNodeByBlockname(std::string name) {
  if (_block.debugName == name)
    return *this;

  for (auto node : _children) {
    try {
      return node.findNodeByBlockname(name);
    } catch (...) {
      // couldn't find it in that child, try the next
    }
  }

  throw "Couldn't find block by name " + name + " in tree.\n";
}

DominatorTree DominatorTree::findParentOf(std::string name) {
  for (auto node : _children) {
    if (node.getBasicBlock().debugName == name) {
      return *this;
    }
  }

  for (auto node : _children) {
    try {
      return node.findParentOf(name);
    } catch (...) {
      // couldn't find it in that child, try the next
    }
  }

  throw "Couldn't find parent of block by name " + name + " in tree.\n";
}

void DominatorTree::addChild(DominatorTree node) { _children.push_back(node); }

void DominatorTree::replaceChild(DominatorTree old, DominatorTree fresh) {
  auto target = std::find(_children.begin(), _children.end(), old);

  if (target == _children.end()) {
    std::cerr << "Searched for child in replaceChild but found nothing.\n";
    throw "Searched for child in replaceChild but found nothing.\n";
  } else {
    // found it
    *target = fresh;
  }
}

void DominatorTree::clearChildren() { _children.clear(); }

std::vector<DominatorTree> DominatorTree::getChildren() const {
  return _children;
}

bool DominatorTree::dominates(BasicBlock block) const {
  if (_block == block)
    return true;

  for (auto node : _children) {
    if (node.dominates(block)) {
      return true;
    }
  }

  return false;
}

bool DominatorTree::strictlyDominates(BasicBlock block) const {
  return (_block != block && dominates(block));
}

std::vector<BasicBlock>
DominatorTree::buildListPreorder(std::vector<BasicBlock> list) {
  list.push_back(_block);
  for (auto c : _children) {
    list = c.buildListPreorder(list);
  }
  return list;
}

void DominatorTree::printPreorder(unsigned int depth) {
  std::cerr << std::string(depth * 2, '-') + " " << _block.debugName
            << std::endl;
  for (auto child : _children) {
    child.printPreorder(depth + 1);
  }
}

bool operator==(const DominatorTree &a, const DominatorTree &b) {
  return a.getBasicBlock() == b.getBasicBlock() &&
         a.getChildren() == b.getChildren();
}
