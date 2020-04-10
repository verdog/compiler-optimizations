#include "registerallocationpass.h"

#include "interferencegraph.h"
#include "liverangespass.h"
#include "livevariableanalysispass.h"

IlocProgram RegisterAllocationPass::applyToProgram(IlocProgram prog) {
  LiveRangesPass lrpass;
  prog = lrpass.applyToProgram(prog);

  LiveVariableAnalysisPass lvapass;
  prog = lvapass.applyToProgram(prog);

  for (auto &proc : prog.getProceduresReference()) {
    InterferenceGraph igraph;

    // create interference graph
    igraph.createFromLiveRanges(lrpass, proc, lvapass);

    // process graph
    colorGraph(igraph, 6);

    igraph.dump();
  }

  return prog;
}

void RegisterAllocationPass::colorGraph(InterferenceGraph &igraph,
                                        unsigned int k) {
  std::stack<InterferenceGraphNode> stack;

  // fill up stack
  while (igraph.empty() == false) {
    InterferenceGraphNode cheapestNode;

    if (igraph.minDegree() < k) {
      cheapestNode = igraph.getAnyNodeWithDegree(igraph.minDegree());
    } else {
      cheapestNode = igraph.getLowestSpillcostNode();
    }

    igraph.removeNode(cheapestNode);
    stack.push(cheapestNode);
  }

  // try to color
  while (stack.empty() == false) {
    InterferenceGraphNode node = stack.top();
    stack.pop();
    igraph.addNode(node);
    igraph.colorNode(node, k);
  }
}