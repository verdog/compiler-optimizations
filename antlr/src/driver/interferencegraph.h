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
};

bool operator==(const InterferenceGraphNode &a, const InterferenceGraphNode &b);
bool operator<(const InterferenceGraphNode &a, const InterferenceGraphNode &b);

////////////////////////////////////////////////////////////////////////////////

class InterferenceGraph {
public:
  template <typename SetType>
  void createFromLiveRanges(LiveRangesPass lrpass, IlocProcedure proc,
                            LiveVariableAnalysisPass<SetType> lvapass);

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
    LiveVariableAnalysisPass<SetType> lvapass) {

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
  }
}