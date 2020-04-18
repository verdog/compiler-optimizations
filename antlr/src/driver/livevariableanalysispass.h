#pragma once

#include <set>

#include "pass.h"
#include "value.h"

using SoftValueSet = std::unordered_set<Value, ValueNameHash, ValueNameEqual>;
using HardValueSet = std::unordered_set<Value>;

template <typename SetType> struct DataFlowSets {
  SetType in;
  SetType gen;
  SetType not_prsv;
  SetType out;
};

template <typename SetType> class LiveVariableAnalysisPass : public Pass {
  template <typename T>
  friend bool operator==(const LiveVariableAnalysisPass<T> &a,
                         const LiveVariableAnalysisPass<T> &b);

public:
  IlocProgram applyToProgram(IlocProgram prog);
  DataFlowSets<SetType> getBlockSets(IlocProcedure proc, BasicBlock block);
  void dump() const;

private:
  void analizeProcedure(IlocProcedure proc);
  void computeSets(IlocProcedure proc, BasicBlock block);

  unsigned int _iterations;

  std::unordered_map<IlocProcedure,
                     std::unordered_map<BasicBlock, DataFlowSets<SetType>>>
      _setsMap;
};

template <typename T>
bool operator==(const LiveVariableAnalysisPass<T> &a,
                const LiveVariableAnalysisPass<T> &b);
template <typename T>
bool operator!=(const LiveVariableAnalysisPass<T> &a,
                const LiveVariableAnalysisPass<T> &b);

template <typename T>
bool operator==(const DataFlowSets<T> &a, const DataFlowSets<T> &b);
template <typename T>
bool operator!=(const DataFlowSets<T> &a, const DataFlowSets<T> &b);

////////////////////////////////////////////////////////////////////////////////

template <typename SetType>
bool operator==(const LiveVariableAnalysisPass<SetType> &a,
                const LiveVariableAnalysisPass<SetType> &b) {
  return a._setsMap == b._setsMap;
}

template <typename SetType>
bool operator!=(const LiveVariableAnalysisPass<SetType> &a,
                const LiveVariableAnalysisPass<SetType> &b) {
  return !(a == b);
}

template <typename SetType>
bool operator==(const DataFlowSets<SetType> &a,
                const DataFlowSets<SetType> &b) {
  return a.gen == b.gen && a.in == b.in && a.out == b.out &&
         a.not_prsv == b.not_prsv;
}

template <typename SetType>
bool operator!=(const DataFlowSets<SetType> &a,
                const DataFlowSets<SetType> &b) {
  return !(a == b);
}

template <typename SetType>
IlocProgram
LiveVariableAnalysisPass<SetType>::applyToProgram(IlocProgram prog) {
  _setsMap.clear();
  for (auto proc : prog.getProcedures()) {
    analizeProcedure(proc);
  }

  return prog;
}

template <typename SetType>
DataFlowSets<SetType>
LiveVariableAnalysisPass<SetType>::getBlockSets(IlocProcedure proc,
                                                BasicBlock block) {
  if (_setsMap.find(proc) == _setsMap.end()) {
    analizeProcedure(proc);
  }

  if (_setsMap.at(proc).find(block) == _setsMap.at(proc).end()) {
    analizeProcedure(proc);
  }

  return _setsMap.at(proc).at(block);
}

template <typename SetType>
void LiveVariableAnalysisPass<SetType>::analizeProcedure(IlocProcedure proc) {
  // visit each node
  std::stack<BasicBlock> workStack;
  std::stack<BasicBlock> visitStack;
  std::unordered_set<BasicBlock> visited;

  visitStack.push(proc.getBlock("entry"));
  workStack.push(proc.getBlock("entry"));

  // build workstack depth first
  while (!visitStack.empty()) {
    BasicBlock block = visitStack.top();
    visitStack.pop();
    visited.insert(block);

    for (auto successorBlockName : block.after) {
      BasicBlock successorBlock = proc.getBlock(successorBlockName);
      if (visited.find(successorBlock) == visited.end()) {
        // block hasn't been visited
        workStack.push(successorBlock);
        visitStack.push(successorBlock);
      }
    }
  }

  // process blocks
  bool dirty = true;
  _iterations = 0; // for debug purposes

  while (dirty == true) {
    dirty = false;
    _iterations++;
    std::stack<BasicBlock> currentStack = workStack;
    while (!currentStack.empty()) {
      BasicBlock block = currentStack.top();
      currentStack.pop();

      DataFlowSets<SetType> oldset = _setsMap[proc][block];
      computeSets(proc, block);
      DataFlowSets<SetType> newset = _setsMap[proc][block];

      if (oldset.in != newset.in || oldset.out != newset.out)
        dirty = true;
    }
  }
}

template <typename SetType>
void LiveVariableAnalysisPass<SetType>::computeSets(IlocProcedure proc,
                                                    BasicBlock block) {
  DataFlowSets<SetType> &currentSet = _setsMap.at(proc).at(block);

  currentSet.gen.clear();
  currentSet.not_prsv.clear();

  // local info
  for (auto inst : block.instructions) {
    if (inst.isDeleted())
      continue;

    for (auto rvalue : inst.operation.rvalues) {
      if (rvalue.getType() == Value::Type::virtualReg &&
          currentSet.not_prsv.find(rvalue) == currentSet.not_prsv.end()) {
        currentSet.gen.insert(rvalue);
      }
    }
    for (auto lvalue : inst.operation.lvalues) {
      if (lvalue.getType() == Value::Type::virtualReg) {
        currentSet.not_prsv.insert(lvalue);
      }
    }
  }

  // out
  currentSet.out.clear();
  for (auto blockName : block.after) {
    BasicBlock successor = proc.getBlock(blockName);
    for (auto value : _setsMap[proc][successor].in) {
      _setsMap[proc][block].out.insert(value);
    }
  }

  // since iloc is pass by reference, we need to assume that function arguments
  // are always live (could be used outside of the function)
  // for (auto arg : proc.getFrame().arguments) {
  //   _setsMap[proc][block].out.insert(arg);
  // }

  // in
  currentSet.in = currentSet.gen;
  for (auto value : currentSet.out) {
    if (currentSet.not_prsv.find(value) == currentSet.not_prsv.end()) {
      currentSet.in.insert(value);
    }
  }
}

template <typename SetType>
void LiveVariableAnalysisPass<SetType>::dump() const {
  // debug output
  for (auto table : _setsMap) {
    auto proc = table.first;
    for (auto pair : table.second) {
      auto block = pair.first;
      std::cerr << "live variable analysis for " << block.debugName << " in "
                << proc.getFrame().name << ":\n";
      DataFlowSets<SetType> sets = pair.second;
      std::cerr << "IN:\n";
      for (auto value : sets.in) {
        std::cerr << "   " << value.getFullText() << std::endl;
      }
      std::cerr << "OUT:\n";
      for (auto value : sets.out) {
        std::cerr << "   " << value.getFullText() << std::endl;
      }
    }
  }
  std::cerr << _iterations << " iterations\n";
}
