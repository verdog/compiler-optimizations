#pragma once

#include <map>
#include <set>
#include <string>

#include "liverangespass.h"
#include "livevariableanalysispass.h"

enum InterferenceGraphColor {
  uncolored = -1,
  vr0,
  vr1,
  vr2,
  vr3,
  red,
  red_orange,
  orange,
  orange_yellow,
  yellow,
  yellow_green,
  green,
  green_blue,
  blue,
  indigo,
  violet,
  white,
  black
};

struct InterferenceGraphNode {
  InterferenceGraphNode();
  InterferenceGraphNode(std::string name);
  int getDegree();
  float getSpillCost();

  std::string name;
  unsigned int uses;
  std::set<InterferenceGraphNode> edges;
  InterferenceGraphColor color;
  bool infiniteCost;
};

bool operator==(const InterferenceGraphNode &a, const InterferenceGraphNode &b);
bool operator<(const InterferenceGraphNode &a, const InterferenceGraphNode &b);

////////////////////////////////////////////////////////////////////////////////

class InterferenceGraph {
public:
  template <typename SetType>
  void createFromLiveRanges(LiveRangesPass lrpass, IlocProcedure proc,
                            LiveVariableAnalysisPass<SetType> lvapass,
                            std::set<LiveRange> infinites);

  void addNode(InterferenceGraphNode node);
  InterferenceGraphNode getNode(std::string name);
  void removeNode(InterferenceGraphNode node);
  void connectNodes(InterferenceGraphNode a, InterferenceGraphNode b);
  void disconnectNodes(InterferenceGraphNode a, InterferenceGraphNode b);
  bool empty();
  unsigned int minDegree();
  unsigned int maxDegree();
  InterferenceGraphNode getAnyNodeWithDegree(unsigned int degree);
  InterferenceGraphNode getLowestSpillcostNode();
  bool colorNode(InterferenceGraphNode node, unsigned int max);

  void test();
  void dump();

private:
  std::map<std::string, InterferenceGraphNode> _graphMap;
};

////////////////////////////////////////////////////////////////////////////////

template <typename SetType>
void InterferenceGraph::createFromLiveRanges(
    LiveRangesPass lrpass, IlocProcedure proc,
    LiveVariableAnalysisPass<SetType> lvapass, std::set<LiveRange> infinites) {

  _graphMap.clear();

  std::set<LiveRange> set = lrpass.getLiveRanges(proc);

  // initialize nodes
  for (auto lr : set) {
    addNode(lr.name);
  }

  // connect nodes
  for (auto block : proc.orderedBlocks()) {
    std::unordered_set<Value> live = lvapass.getBlockSets(proc, block).out;

    // special case: if arguments haven't been spilled, they are always live
    // because of call by reference.
    // spilling them will preserve their call by reference properties by loading
    // them back into their registers before a return, so if they have been
    // spilled, we don't have to consider them live in register allocation.
    for (auto argValue : proc.getFrame().arguments) {
      LiveRange argLiveRange = lrpass.getRangeWithValue(argValue, set);
      if (infinites.find(argLiveRange) == infinites.end()) {
        live.insert(argValue);
      }
    }

    for (auto it = block.instructions.rbegin(); it != block.instructions.rend();
         it++) {
      Instruction inst = *it;

      // skip deleted
      if (inst.isDeleted())
        continue;

      // lvalues interfere with anything in live
      for (auto lval : inst.operation.lvalues) {
        if (lval.getType() == Value::Type::virtualReg) {
          LiveRange lvalLiveRange = lrpass.getRangeWithValue(lval, set);

          for (auto liveValue : live) {
            connectNodes(lrpass.getRangeWithValue(liveValue, set).name,
                         lvalLiveRange.name);
          }

          live.erase(lval);
        }
      }

      // add rvalues to live
      for (auto rval : inst.operation.rvalues) {
        if (rval.getType() == Value::Type::virtualReg) {
          live.insert(rval);
        }
      }
    }
  }

  // arguments interfere with each other
  for (auto argVal1 : proc.getFrame().arguments) {
    for (auto argVal2 : proc.getFrame().arguments) {
      connectNodes(lrpass.getRangeWithValue(argVal1, set).name,
                   lrpass.getRangeWithValue(argVal2, set).name);
    }
  }

  // record number of uses for spill costs
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

    node.uses = uses;

    // set infinites
    if (infinites.find(lr) != infinites.end()) {
      node.infiniteCost = true;
    }
  }
}