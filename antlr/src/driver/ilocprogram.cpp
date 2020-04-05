#include "ilocprogram.h"

IlocProgram::IlocProgram() : _is_ssa(false) {}

void IlocProgram::addPseudoOp(std::string pseudoOp) {
  pseudoOps.push_back(pseudoOp);
}

void IlocProgram::addPseudoOps(std::vector<std::string> newPseudoOps) {
  pseudoOps.insert(pseudoOps.end(), newPseudoOps.begin(), newPseudoOps.end());
}

std::vector<std::string> IlocProgram::getPseudoOps() const { return pseudoOps; }

void IlocProgram::addProcedure(IlocProcedure proc) {
  procedures.push_back(proc);
}

void IlocProgram::addProcedures(std::vector<IlocProcedure> newProcedures) {
  procedures.insert(procedures.end(), newProcedures.begin(),
                    newProcedures.end());
}

std::vector<IlocProcedure> IlocProgram::getProcedures() const {
  return procedures;
}

std::vector<IlocProcedure> &IlocProgram::getProceduresReference() {
  return procedures;
}

void IlocProgram::clearProcedures() { procedures.clear(); }

bool IlocProgram::isSSA() { return _is_ssa; }

void IlocProgram::setIsSSA(bool is) { _is_ssa = is; }
