#include "interferencegraph.h"

bool operator==(const InterferenceGraphNode &a,
                const InterferenceGraphNode &b) {
  return a.name == b.name;
}

bool operator<(const InterferenceGraphNode &a, const InterferenceGraphNode &b) {
  return a.name < b.name;
}

InterferenceGraphNode::InterferenceGraphNode() : spillCost{0} {}

InterferenceGraphNode::InterferenceGraphNode(std::string _name)
    : spillCost{0}, name{_name} {}

int InterferenceGraphNode::getDegree() { return edges.size(); }

////////////////////////////////////////////////////////////////////////////////

void InterferenceGraph::createFromLiveRanges(LiveRangesPass lrpass,
                                             IlocProcedure proc,
                                             LiveVariableAnalysisPass lvapass) {

  _graphMap.clear();

  std::set<LiveRange> set = lrpass.getLiveRanges(proc);

  // initialize nodes
  for (auto lr : set) {
    addNode(lr.name);
  }

  // connect nodes
  for (auto block : proc.orderedBlocks()) {
    std::unordered_set<Value> live = lvapass.getBlockSets(proc, block).out;

    for (auto it = block.instructions.rbegin(); it != block.instructions.rend();
         it++) {
      Instruction inst = *it;

      // skip deleted
      if (inst.isDeleted())
        continue;

      // lvalue interferes with anything in live
      if (inst.operation.lvalues.size() == 1 and
          inst.operation.lvalues.front().getType() == Value::Type::virtualReg) {

        Value lval = inst.operation.lvalues.front();
        LiveRange lvalLiveRange = lrpass.getRangeWithValue(lval, set);

        for (auto value : live) {
          connectNodes(lrpass.getRangeWithValue(value, set).name,
                       lvalLiveRange.name);
        }

        live.erase(lval);
      }

      // add rvalues to live
      for (auto rval : inst.operation.rvalues) {
        if (rval.getType() == Value::Type::virtualReg) {
          live.insert(rval);
        }
      }
    }
  }

  // calculate spill costs
  for (auto &pair : _graphMap) {
    InterferenceGraphNode &node = pair.second;
    LiveRange lr = lrpass.getRangeWithName(node.name, set);

    // get number of uses for live range
    unsigned int uses = 0;
    for (auto val : lr.registers) {
      if (proc.getSSAInfo().usesMap.find(val) !=
          proc.getSSAInfo().usesMap.end()) {
        uses += proc.getSSAInfo().usesMap.at(val).size();
      } else {
        // no uses. can happen with special registers.
      }
    }

    if (node.edges.size() > 0) {
      node.spillCost =
          static_cast<float>(uses) / static_cast<float>(node.edges.size());
    } else {
      // no edges, very high spill cost
      node.spillCost = 100;
    }
  }
}

void InterferenceGraph::addNode(InterferenceGraphNode node) {
  if (_graphMap.find(node.name) != _graphMap.end()) {
    throw "tried to add a node that was already in the graph.\n";
  }

  _graphMap.insert({node.name, node});

  // connect any saved edges
  for (auto edge : node.edges) {
    connectNodes(node, edge);
  }
}

InterferenceGraphNode InterferenceGraph::getNode(std::string name) {
  return _graphMap.at(name);
}

void InterferenceGraph::removeNode(InterferenceGraphNode node) {
  // disconnect any edges
  for (auto edge : _graphMap.at(node.name).edges) {
    _graphMap.at(edge.name).edges.erase(node);
  }

  _graphMap.erase(node.name);

  // remove any edges that now point to nothing
  for (auto edge : node.edges) {
    disconnectNodes(node, edge);
  }
}

void InterferenceGraph::connectNodes(InterferenceGraphNode a,
                                     InterferenceGraphNode b) {
  if (a.name == b.name)
    return;

  _graphMap.at(a.name).edges.insert(b);
  _graphMap.at(b.name).edges.insert(a);
}

void InterferenceGraph::disconnectNodes(InterferenceGraphNode a,
                                        InterferenceGraphNode b) {
  if (a.name == b.name)
    return;

  _graphMap.at(a.name).edges.erase(b);
  _graphMap.at(b.name).edges.erase(a);
}

void InterferenceGraph::test() {
  std::cerr << "InterferenceGraph::test()\n";

  // create 4 nodes
  addNode(InterferenceGraphNode("a"));
  addNode(InterferenceGraphNode("b"));
  addNode(InterferenceGraphNode("c"));
  addNode(InterferenceGraphNode("d"));

  try {
    addNode(InterferenceGraphNode("d"));
    std::cerr << "uh oh, no error was thrown upon inserting duplicate node.\n";
  } catch (...) {
    std::cerr << "an error occured upon insterting a duplicate node, as it "
                 "should have.\n";
  }

  // connect a to b
  connectNodes(InterferenceGraphNode("a"), InterferenceGraphNode("b"));

  // connect c to d
  connectNodes(InterferenceGraphNode("c"), InterferenceGraphNode("d"));

  // connect d to b
  connectNodes(InterferenceGraphNode("d"), InterferenceGraphNode("b"));

  // get a
  std::cerr << "node a has " << getNode("a").edges.size()
            << " edges. (should be 1)\n";
  // get b
  std::cerr << "node b has " << getNode("b").edges.size()
            << " edges. (should be 2)\n";
  // get c
  std::cerr << "node c has " << getNode("c").edges.size()
            << " edges. (should be 1)\n";
  // get d
  std::cerr << "node d has " << getNode("d").edges.size()
            << " edges. (should be 2)\n";

  // remove b
  removeNode(InterferenceGraphNode("b"));

  // get a again
  std::cerr << "node a has " << getNode("a").edges.size()
            << " edges. (should be 0)\n";
  // get d again
  std::cerr << "node d has " << getNode("d").edges.size()
            << " edges. (should be 1)\n";

  // disconnect c from d
  disconnectNodes(InterferenceGraphNode("c"), InterferenceGraphNode("d"));

  // get c again
  std::cerr << "node c has " << getNode("c").edges.size()
            << " edges. (should be 0)\n";
  // get d
  std::cerr << "node d has " << getNode("d").edges.size()
            << " edges. (should be 0)\n";

  _graphMap.clear();

  // test removing nodes with edges and re-adding them
  std::string a = "a";
  std::string b = "b";
  std::string c = "c";

  addNode(a);
  addNode(b);
  addNode(c);

  connectNodes(a, b);
  connectNodes(b, c);

  std::cerr << "node b has " << getNode("b").edges.size()
            << " edges. (should be 2)\n";

  InterferenceGraphNode bNode = getNode("b");
  removeNode(b);

  std::cerr << "node a has " << getNode("a").edges.size()
            << " edges. (should be 0)\n";

  std::cerr << "node c has " << getNode("c").edges.size()
            << " edges. (should be 0)\n";

  addNode(bNode);
  std::cerr << "node a has " << getNode("a").edges.size()
            << " edges. (should be 1)\n";

  std::cerr << "node b has " << getNode("b").edges.size()
            << " edges. (should be 2)\n";

  std::cerr << "node c has " << getNode("c").edges.size()
            << " edges. (should be 1)\n";
}

void InterferenceGraph::dump() {
  for (auto pair : _graphMap) {
    std::cerr << pair.first << " (" << pair.second.spillCost
              << "): " << std::endl;
    for (auto edge : pair.second.edges) {
      std::cerr << "   " << edge.name << std::endl;
    }
  }
}