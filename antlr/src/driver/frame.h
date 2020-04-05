#pragma once

#include <string>

#include "value.h"

class Frame {
public:
  std::string name;
  std::string number;
  std::vector<Value> arguments;

private:
};

bool operator==(const Frame &a, const Frame &b);
