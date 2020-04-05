#include "expression.h"

bool operator==(const Expression &a, const Expression &b) {
  return a.rValueOne == b.rValueOne && a.rValueTwo == b.rValueTwo &&
         a.opcode == b.opcode;
}

bool operator==(const ValueExpression &a, const ValueExpression &b) {
  return a.rValueOne == b.rValueOne && a.rValueTwo == b.rValueTwo &&
         a.opcode == b.opcode;
}
