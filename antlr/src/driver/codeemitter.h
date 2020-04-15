#pragma once

#include "antlr4-runtime.h"

#include "ilocprogram.h"
#include "phinode.h"

class CodeEmitter {
public:
  CodeEmitter(antlr4::dfa::Vocabulary vocab);
  void emit(const IlocProgram &program);
  void emitDebug(const IlocProgram &program);

  std::string text(const Instruction &inst) const;
  std::string text(const BasicBlock &bblock) const;
  std::string text(const PhiNode &phi) const;
  std::string text(const Frame &frame) const;

  std::string debugText(const Instruction &inst) const;
  std::string debugText(const BasicBlock &bblock) const;
  std::string debugText(const PhiNode &phi) const;
  std::string debugText(const Frame &frame) const;

  std::string storeInstText(const Instruction &inst) const;
  std::string callInstText(const Instruction &inst) const;

private:
  antlr4::dfa::Vocabulary vocab;
  std::string tab = "   ";
};
