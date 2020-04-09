#pragma once

#include <set>

#include "pass.h"
#include "value.h"

struct DataFlowSets {
  std::unordered_set<Value> in;
  std::unordered_set<Value> gen;
  std::unordered_set<Value> not_prsv;
  std::unordered_set<Value> out;
};

class LiveVariableAnalysisPass : public Pass {
  friend bool operator==(const LiveVariableAnalysisPass &a,
                         const LiveVariableAnalysisPass &b);

public:
  IlocProgram applyToProgram(IlocProgram prog);
  DataFlowSets getBlockSets(IlocProcedure proc, BasicBlock block);
  void dump() const;

private:
  void analizeProcedure(IlocProcedure proc);
  void computeSets(IlocProcedure proc, BasicBlock block);

  unsigned int _iterations;

  std::unordered_map<IlocProcedure,
                     std::unordered_map<BasicBlock, DataFlowSets>>
      _setsMap;
};

bool operator==(const LiveVariableAnalysisPass &a,
                const LiveVariableAnalysisPass &b);
bool operator!=(const LiveVariableAnalysisPass &a,
                const LiveVariableAnalysisPass &b);
bool operator==(const DataFlowSets &a, const DataFlowSets &b);
bool operator!=(const DataFlowSets &a, const DataFlowSets &b);
