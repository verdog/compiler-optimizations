#pragma once

#include "pass.h"

struct LiveRange {
  explicit LiveRange(Value v);
  void assimilateRanges(std::set<LiveRange> ranges);
  std::string name;
  std::set<Value> registers;
};

bool operator==(const LiveRange &a, const LiveRange &b);
bool operator<(const LiveRange &a, const LiveRange &b);

namespace std {
template <> struct hash<LiveRange> {
  std::size_t operator()(const LiveRange &lr) const noexcept {
    return std::hash<std::string>{}(lr.name);
  }
};

} // namespace std

class LiveRangesPass : public Pass {
public:
  IlocProgram applyToProgram(IlocProgram prog);
  std::set<LiveRange> getLiveRange(IlocProcedure proc);

private:
  std::set<LiveRange> computeLiveRanges(IlocProcedure proc);

  std::unordered_map<IlocProcedure, std::set<LiveRange>> _rangesMap;
};
