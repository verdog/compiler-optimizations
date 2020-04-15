#include <algorithm>

#include <set>
#include <unordered_map>

#include "dominatortreepass.h"

DominatorTreePass::DominatorTreePass(Mode mode) : _mode(mode) {}

IlocProgram DominatorTreePass::applyToProgram(IlocProgram prog) {
  dominatorTreeMap.clear();
  for (auto proc : prog.getProcedures()) {
    DominatorTree tree = buildTreeFromProcedure(proc);

    // debug output
    if (_mode == Mode::dominator) {
      std::cerr << "Dominator tree: (" << proc.getFrame().name << ")\n";
    } else if (_mode == Mode::postdominator) {
      std::cerr << "Postdominator tree: (" << proc.getFrame().name << ")\n";
    }
    tree.printPreorder();

    dominatorTreeMap.insert({proc, tree});
  }

  return prog;
}

DominatorTree DominatorTreePass::getDominatorTree(IlocProcedure proc) {
  if (dominatorTreeMap.find(proc) == dominatorTreeMap.end()) {
    // not cached, build from scratch
    DominatorTree tree = buildTreeFromProcedure(proc);
    dominatorTreeMap.insert({proc, tree});
  }

  return dominatorTreeMap.at(proc);
}

std::unordered_map<BasicBlock, std::set<BasicBlock>>
DominatorTreePass::getDominatorsMap(IlocProcedure proc) {
  // block -> set of dominators of that block
  std::unordered_map<BasicBlock, std::set<BasicBlock>> dominatorsMap;

  // create set containing all blocks
  std::set<BasicBlock> allBlocks;
  for (auto block : proc.orderedBlocks()) {
    allBlocks.insert(block);
  }

  // initialize
  std::string rootName;
  if (_mode == Mode::dominator) {
    rootName = "entry";
  } else if (_mode == Mode::postdominator) {
    rootName = proc.getExitBlockName();
  } else {
    throw "unknown mode?";
  }

  for (auto block : proc.orderedBlocks()) {
    if (block.debugName == rootName) {
      // root
      dominatorsMap.insert({block, std::set<BasicBlock>({block})});
    } else {
      // non-root
      dominatorsMap.insert({block, allBlocks});
    }
  }

  // calculate dominators
  bool dirty = true;
  while (dirty == true) {
    dirty = false;
    for (auto block : proc.orderedBlocks()) {
      // skip the entry block
      if (block.debugName != rootName) {
        std::set<BasicBlock> setA = allBlocks;
        std::set<BasicBlock> setB = allBlocks;
        std::set<BasicBlock> intResult;

        if (_mode == Mode::dominator) {
          // compute intersection of dominators of predecessors
          for (auto predName : block.before) {
            intResult.clear();
            setB = dominatorsMap.at(proc.getBlock(predName));
            std::set_intersection(setA.begin(), setA.end(), setB.begin(),
                                  setB.end(),
                                  std::inserter(intResult, intResult.begin()));
            setA = intResult;
          }
        } else if (_mode == Mode::postdominator) {
          // compute intersection of dominators of successors
          for (auto succName : block.after) {
            intResult.clear();
            setB = dominatorsMap.at(proc.getBlock(succName));
            std::set_intersection(setA.begin(), setA.end(), setB.begin(),
                                  setB.end(),
                                  std::inserter(intResult, intResult.begin()));
            setA = intResult;
          }
        }

        // add self
        intResult.insert(block);

        // check for any changes
        if (dominatorsMap.at(block) != intResult) {
          dirty = true;
        }

        // save results
        dominatorsMap.at(block) = intResult;
      }
    }
  }

  // debug output
  for (auto block : proc.orderedBlocks()) {
    std::cerr << "Dominators for " << block.debugName << std::endl;
    for (auto dom : dominatorsMap.at(block)) {
      std::cerr << "   " << dom.debugName << std::endl;
    }
  }

  return dominatorsMap;
}

DominatorTree DominatorTreePass::buildTreeFromDominatorsMap(
    std::unordered_map<BasicBlock, std::set<BasicBlock>> map,
    const IlocProcedure &proc) {
  // create a tree node for each block
  std::unordered_map<BasicBlock, DominatorTree> nodeMap;
  for (auto pair : map) {
    BasicBlock block = pair.first;
    nodeMap.insert({block, DominatorTree(block)});
  }

  // link nodes to copies of their children
  for (auto pair : map) {
    BasicBlock block = pair.first;

    DominatorTree treeNode = nodeMap.at(block);
    DominatorTree parentNode;

    // find dominator with most dominators itself
    unsigned int most = 0;
    BasicBlock blockWithMost;
    for (auto dominator : map.at(block)) {
      // don't consider the dominator set of ourselves
      if (dominator.debugName != block.debugName) {
        std::set<BasicBlock> dominators = map.at(dominator);

        if (dominators.size() > most) {
          most = dominators.size();
          blockWithMost = dominator;
        }
      }
    }

    // add child to node in map
    if (most != 0) {
      parentNode = nodeMap.at(blockWithMost);
      parentNode.addChild(block);
      nodeMap.at(blockWithMost) = parentNode;
    } else {
      // we're dealing with the entry node, do nothing
    }
  }

  // at this point, the nodes are properly linked up individually, but because
  // of the processing order, some of them are linked to copies of previous
  // versions of their children. for example, the root node is might have a
  // child called ".L0", but later in the process .L0 got children of its own.
  // these children are only reflected in the "real" .L0 in the nodemap and not
  // applied to the copy of .L0 stored as a child of root.
  //
  // in short, the information to build the tree is present, but in name only.
  // now we have to properly build the tree so that it contains versions of the
  // blocks that are "real" (currently stored in nodemap)
  //
  // this is done by building a work stack of the tree in depth first order.
  // after that we process the stack, essentially traversing the tree in
  // postorder. for each block, we look up the block in the nodemap, and replace
  // the node's children with the correct children which are stored in the
  // nodemap. this connects up all the nodes properly.

  // find root block
  BasicBlock rootBlock;
  std::string rootName;
  if (_mode == Mode::dominator) {
    rootName = "entry";
  } else if (_mode == Mode::postdominator) {
    rootName = proc.getExitBlockName();
  }

  for (auto pair : map) {
    if (pair.first.debugName == rootName) {
      rootBlock = pair.first;
      break;
    }
  }

  std::stack<DominatorTree> workStack;
  std::stack<DominatorTree> visitStack;
  DominatorTree root = nodeMap.at(rootBlock);

  visitStack.push(root);
  workStack.push(root);

  // build workstack depth first
  while (!visitStack.empty()) {
    DominatorTree node = visitStack.top();
    visitStack.pop();

    for (auto child : node.getChildren()) {
      workStack.push(nodeMap.at(child.getBasicBlock()));
      visitStack.push(nodeMap.at(child.getBasicBlock()));
    }
  }

  // rebuild tree
  while (!workStack.empty()) {
    DominatorTree node = nodeMap.at(workStack.top().getBasicBlock());
    workStack.pop();

    for (auto child : node.getChildren()) {
      node.replaceChild(child, nodeMap.at(child.getBasicBlock()));
    }

    nodeMap.at(node.getBasicBlock()) = node;
  }

  // re-fetch properly connected root
  root = nodeMap.at(rootBlock);

  // debug output
  // root.printPreorder();

  return root;
}

DominatorTree DominatorTreePass::buildTreeFromProcedure(IlocProcedure proc) {
  if (proc.getBlocks().size() != 1) {
    // get dominators map
    std::unordered_map<BasicBlock, std::set<BasicBlock>> dominatorsMap =
        getDominatorsMap(proc);

    // get tree from map
    return buildTreeFromDominatorsMap(dominatorsMap, proc);
  } else {
    // single block procedure tree is just the block
    return DominatorTree(proc.getBlock("entry"));
  }
}
