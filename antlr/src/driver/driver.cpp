#include <iostream>

#include "antlr4-runtime.h"

#include "ilocLexer.h"
#include "ilocParser.h"

#include "codeemitter.h"
#include "deadcodeeliminationpass.h"
#include "ilocprogram.h"
#include "ilocprogramvisitor.h"
#include "liverangespass.h"
#include "lvnpass.h"
#include "normalformpass.h"
#include "optrenamepass.h"
#include "registerbehaviorpass.h"
#include "removedeletedpass.h"
#include "ssapass.h"

int usage(int argc, const char *argv[]) {
  if (argc != 2) {
    std::cerr << "Usage: ./driver <iloc_file>" << std::endl;
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
  OptRenamePass optpass;
  RemoveDeletedPass remdelpass;
  DeadCodeEliminationPass deadcodepass;
  NormalFormPass normpass;
  LiveRangesPass liverangepass;

  program = regpass.applyToProgram(program);
  program = lvnpass.applyToProgram(program);
  program = ssapass.applyToProgram(program);
  // program = optpass.applyToProgram(program);
  program = deadcodepass.applyToProgram(program);
  // program = normpass.applyToProgram(program);
  program = liverangepass.applyToProgram(program);

  emitter.emitDebug(program);
  emitter.emit(program);

  return 0;
}
