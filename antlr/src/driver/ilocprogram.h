#pragma once

#include <string>
#include <vector>

#include "ilocprocedure.h"

class IlocProgram {
public:
  IlocProgram();
  void addPseudoOp(std::string pseudoOp);
  void addPseudoOps(std::vector<std::string> PseudoOps);
  std::vector<std::string> getPseudoOps() const;
  void addProcedure(IlocProcedure proc);
  void addProcedures(std::vector<IlocProcedure> procedures);
  std::vector<IlocProcedure> getProcedures() const;
  std::vector<IlocProcedure> &getProceduresReference();
  void clearProcedures();
  bool isSSA();
  void setIsSSA(bool is);

private:
  std::vector<std::string> pseudoOps;
  std::vector<IlocProcedure> procedures;
  bool _is_ssa;
};
