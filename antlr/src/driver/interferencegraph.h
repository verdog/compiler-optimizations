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
  void createFromLiveRanges(LiveRangesPass lrpass, IlocProcedure proc,
                            LiveVariableAnalysisPass lvapass);

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
