#include "frame.h"

bool operator==(const Frame &a, const Frame &b) {
  return a.name == b.name && a.arguments == b.arguments;
}