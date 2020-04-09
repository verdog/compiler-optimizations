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
    igraph.createFromLiveRangesSet(lrpass.getLiveRanges(proc), proc, lvapass);

    igraph.dump();

    // process graph
  }

  return prog;
}
