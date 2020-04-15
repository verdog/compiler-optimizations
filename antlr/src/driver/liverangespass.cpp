#include <algorithm>

#include "interferencegraph.h"
#include "liverangespass.h"
#include "livevariableanalysispass.h"
#include "usesanddefinitionspass.h"

bool operator==(const LiveRange &a, const LiveRange &b) {
  return a.name == b.name && a.registers == b.registers;
}

bool operator<(const LiveRange &a, const LiveRange &b) {
  return a.name < b.name;
}

LiveRange::LiveRange(Value v) {
  name = v.getFullText();
  registers.insert(v);
}

void LiveRange::assimilateRanges(std::set<LiveRange> ranges) {
  for (auto lr : ranges) {
    registers.insert(lr.registers.begin(), lr.registers.end());
  }
}

////////////////////////////////////////////////////////////////////////////////

IlocProgram LiveRangesPass::applyToProgram(IlocProgram prog) {
  if (!prog.isSSA()) {
    throw "can't operate on non-ssa program!";
  }

  UsesAndDefinitionsPass udpass;
  prog = udpass.applyToProgram(prog);

  _rangesMap.clear();

  for (auto proc : prog.getProcedures()) {
    _rangesMap.insert({proc, computeLiveRanges(proc)});
  }

  return prog;
}

std::set<LiveRange> LiveRangesPass::getLiveRanges(IlocProcedure proc) {
  if (_rangesMap.find(proc) == _rangesMap.end()) {
    computeLiveRanges(proc);
  }

  return _rangesMap.at(proc);
}

std::set<LiveRange> LiveRangesPass::computeLiveRanges(IlocProcedure proc) {
  std::set<LiveRange> rangesSet;

  // initialize each register into its own live range
  for (auto pair : proc.getSSAInfo().definitionsMap) {
    rangesSet.insert(LiveRange(pair.first));
  }

  for (auto block : proc.orderedBlocks()) {
    // merge live ranges at phi nodes
    for (auto phi : block.phinodes) {
      if (phi.isDeleted())
        continue;

      // merge rvalue ranges
      for (auto pair : phi.getRValueMap()) {
        // add rvalue live range to merge set
        Value rval = pair.second;
        mergeLiveRangesWithValues(phi.getLValue(), rval, rangesSet);
      }
    }

    // function calls merge the live ranges of their arguments with their
    // corresponding lvalues because of call by reference
    for (auto inst : block.instructions) {
      if (inst.isDeleted()) {
        continue;
      }

      if (inst.operation.opcode == ilocParser::CALL ||
          inst.operation.opcode == ilocParser::ICALL ||
          inst.operation.opcode == ilocParser::FCALL) {

        int lValueIndex = 0;
        if (inst.operation.opcode == ilocParser::ICALL ||
            inst.operation.opcode == ilocParser::FCALL) {
          // functions with return values have one extra lvalue
          lValueIndex++;
        }

        // merge arguments with their definitions
        for (auto rval : inst.operation.rvalues) {
          // skip the function name
          if (rval.getType() == Value::Type::label)
            continue;

          mergeLiveRangesWithValues(rval, inst.operation.lvalues[lValueIndex],
                                    rangesSet);
          lValueIndex++;
        }
      }
    }
  }

  // debug output
  for (auto lr : rangesSet) {
    std::cerr << "found " << lr.name << std::endl;
    std::cerr << "    ";
    for (auto val : lr.registers) {
      std::cerr << val.getFullText() << ", ";
    }
    std::cerr << std::endl;
  }

  return rangesSet;
}

LiveRange LiveRangesPass::getRangeWithValue(Value val,
                                            std::set<LiveRange> rangesSet) {
  return *std::find_if(rangesSet.begin(), rangesSet.end(), [&](LiveRange l) {
    for (auto innerValue : l.registers) {
      if (innerValue.getFullText() == val.getFullText())
        return true;
    }
    return false;
  });
}

LiveRange LiveRangesPass::getRangeWithName(std::string name,
                                           std::set<LiveRange> rangesSet) {
  return *std::find_if(rangesSet.begin(), rangesSet.end(), [&](LiveRange l) {
    for (auto innerValue : l.registers) {
      if (innerValue.getFullText() == name)
        return true;
    }
    return false;
  });
}

void LiveRangesPass::mergeLiveRangesWithValues(Value to, Value from,
                                               std::set<LiveRange> &set) {
  // get live range associated with lvalue
  LiveRange toRange = getRangeWithValue(to, set);

  // create a set of ranges that we will merge with the lvalue range
  std::set<LiveRange> toMerge;

  // save rvalues to merge set
  LiveRange fromRange = getRangeWithValue(from, set);
  toMerge.insert(fromRange);

  // erase ranges in toMerge from master set
  for (auto mergingRange : toMerge) {
    set.erase(mergingRange);
  }

  // remove range before modification
  set.erase(toRange);

  // merge
  toRange.assimilateRanges(toMerge);

  // save
  set.insert(toRange);
}