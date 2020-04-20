#include <iostream>

#include "antlr4-runtime.h"

#include "ilocLexer.h"
#include "ilocParser.h"

#include "codeemitter.h"
#include "deadcodeeliminationpass.h"
#include "ilocprogram.h"
#include "ilocprogramvisitor.h"
#include "lvnpass.h"
#include "normalformpass.h"
#include "optrenamepass.h"
#include "registerallocationpass.h"
#include "registerbehaviorpass.h"
#include "removedeletedpass.h"
#include "ssapass.h"

int usage(int argc, const char *argv[]) {
  if (argc < 2) {
    std::cerr << "Usage: ./driver <iloc_file> <passes: {l: lvn, s: "
                 "ssa, d: dead code, r:reg alloc}>"
              << std::endl;
    return 1;
  }

  return 0;
}

int main(int argc, const char *argv[]) {
  // check for proper usage
  int r;
  r = usage(argc, argv);
  if (r != 0) {
    return r;
  }

  std::string passes;
  if (argc < 3)
    passes = "lsdr";
  else
    passes = argv[2];

  // open the file
  std::ifstream filestream;
  filestream.open(argv[1]);

  // get a parser
  antlr4::ANTLRInputStream input(filestream);
  ilocLexer lexer(&input);
  antlr4::CommonTokenStream tokens(&lexer);
  ilocParser parser(&tokens);

  // get parse tree
  ilocParser::ProgramContext *tree = parser.program();

  // visit
  IlocProgramVisitor visitor;

  IlocProgram program = visitor.extractProgram(tree);

  CodeEmitter emitter(parser.getVocabulary());

  RegisterBehaviorPass regpass;
  LVNPass lvnpass;
  SSAPass ssapass;
  DeadCodeEliminationPass deadcodepass;
  RegisterAllocationPass regallocpass;

  program = regpass.applyToProgram(program);

  for (auto chr : passes) {
    switch (chr) {
    case 'l':
      program = lvnpass.applyToProgram(program);
      break;

    case 's':
      program = ssapass.applyToProgram(program);
      break;

    case 'd':
      program = deadcodepass.applyToProgram(program);
      break;

    case 'r':
      program = regallocpass.applyToProgram(program);
      break;

    default:
      break;
    }
  }

  // emitter.emitDebug(program);
  emitter.emit(program);

  return 0;
}
