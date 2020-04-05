#pragma once

#include <vector>

#include "ilocBaseVisitor.h"

#include "basicblock.h"
#include "ilocprocedure.h"
#include "ilocprogram.h"
#include "instruction.h"

class IlocProgramVisitor : public ilocBaseVisitor {
public:
  IlocProgram extractProgram(ilocParser::ProgramContext *ctx);

private:
  antlrcpp::Any visitProgram(ilocParser::ProgramContext *ctx) override;
  antlrcpp::Any visitData(ilocParser::DataContext *ctx) override;
  antlrcpp::Any visitPseudoOp(ilocParser::PseudoOpContext *ctx) override;
  antlrcpp::Any visitProcedures(ilocParser::ProceduresContext *ctx) override;
  antlrcpp::Any visitProcedure(ilocParser::ProcedureContext *ctx) override;
  antlrcpp::Any
  visitFrameInstruction(ilocParser::FrameInstructionContext *ctx) override;
  antlrcpp::Any
  visitIlocInstruction(ilocParser::IlocInstructionContext *ctx) override;
  antlrcpp::Any visitOperation(ilocParser::OperationContext *ctx) override;
  antlrcpp::Any
  visitOperationList(ilocParser::OperationListContext *ctx) override;

  // symbols that seperate rvalues and lvalues per instruction
  const std::set<uint> valueBoundaries = {ilocParser::ARROW,
                                          ilocParser::ASSIGN};
};
