#include <memory>

#include "valueoccurance.h"

struct SSAInfo {
  std::unordered_map<Value, std::shared_ptr<ValueOccurance>> definitionsMap;
  std::unordered_map<Value, std::vector<std::shared_ptr<ValueOccurance>>>
      usesMap;
};
