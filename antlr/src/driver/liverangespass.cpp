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

  for (auto proc : prog.getProcedures()) {
    _rangesMap.clear();
    _rangesMap.insert({proc, computeLiveRanges(proc)});
  }

  return prog;
}

std::set<LiveRange> LiveRangesPass::getLiveRange(IlocProcedure proc) {
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

  // create live ranges from phi nodes
  for (auto block : proc.orderedBlocks()) {
    for (auto phi : block.phinodes) {
      if (phi.isDeleted())
        continue;

      // get live range associated with lvalue
      LiveRange range =
          *std::find_if(rangesSet.begin(), rangesSet.end(), [&](LiveRange l) {
            return l.name == phi.getLValue().getFullText();
          });

      // remove it for modification
      rangesSet.erase(range);

      // merge with rvalues
      for (auto pair : phi.getRValueMap()) {
        Value rval = pair.second;

        LiveRange rvalRange =
            *std::find_if(rangesSet.begin(), rangesSet.end(), [&](LiveRange l) {
              return l.name == rval.getFullText();
            });

        range.assimilateRanges({rvalRange});

        // remove from set
        rangesSet.erase(rvalRange);
      }

      // save
      rangesSet.insert(range);
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
