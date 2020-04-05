#include "removedeletedpass.h"

IlocProgram RemoveDeletedPass::applyToProgram(IlocProgram program) {
  IlocProgram newProgram = program;

  newProgram.clearProcedures();

  for (IlocProcedure proc : program.getProcedures()) {
    IlocProcedure newProc = proc;
    newProc.clearBlocks();
    for (BasicBlock block : proc.orderedBlocks()) {
      BasicBlock newBlock = block;
      newBlock.instructions.clear();
      for (Instruction inst : block.instructions) {
        if (inst.isDeleted() != true) {
          newBlock.instructions.push_back(inst);
        }
      }
      newProc.addBlock(newBlock.debugName, newBlock);
    }
    newProgram.addProcedure(newProc);
  }

  return newProgram;
}
