#pragma once

#include <map>
#include <set>
#include <string>

#include "liverangespass.h"
#include "livevariableanalysispass.h"

enum InteferenceGraphColor { red, orange, yellow, green, blue, indigo, violet };

struct InterferenceGraphNode {
  InterferenceGraphNode();
  InterferenceGraphNode(std::string name);
  int getDegree();
  std::string name;
  std::set<InterferenceGraphNode> edges;
  int spillCost;
};

bool operator==(const InterferenceGraphNode &a, const InterferenceGraphNode &b);
bool operator<(const InterferenceGraphNode &a, const InterferenceGraphNode &b);

////////////////////////////////////////////////////////////////////////////////

class InterferenceGraph {
public:
  void createFromLiveRangesSet(std::set<LiveRange> set, IlocProcedure proc,
                               LiveVariableAnalysisPass lvapass);

  void addNode(InterferenceGraphNode node);
  InterferenceGraphNode getNode(std::string name);
  void removeNode(InterferenceGraphNode node);
  void connectNodes(InterferenceGraphNode a, InterferenceGraphNode b);
  void disconnectNodes(InterferenceGraphNode a, InterferenceGraphNode b);

  void test();
  void dump();

private:
  std::map<std::string, InterferenceGraphNode> _graphMap;
};
