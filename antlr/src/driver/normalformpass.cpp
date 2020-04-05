#include "normalformpass.h"

IlocProgram NormalFormPass::applyToProgram(IlocProgram prog) {
  // direct translation of phi nodes to predecessors
  for (auto &proc : prog.getProceduresReference()) {
    for (auto blockCopy : proc.orderedBlocks()) {
      auto &block = proc.getBlockReference(blockCopy.debugName);
      for (auto &phi : block.phinodes) {
        for (auto pair : phi.getRValueMap()) {
          std::string blockName = pair.first;
          Value rvalue = pair.second;

          if (!phi.isDeleted() &&
              phi.getLValue().getName() != rvalue.getName()) {
            auto &predBlock = proc.getBlockReference(blockName);
            // create instruction
            Operation op(ilocParser::I2I);
            op.arrow = "=>";
            op.lvalues.push_back(phi.getLValue());
            op.rvalues.push_back(rvalue);
            Instruction inst(op);

            // remember last instruction
            Instruction last = predBlock.instructions.back();

            if (last.operation.category == Operation::Category::branch) {
              predBlock.instructions.pop_back();
            }

            // add instruction
            predBlock.instructions.push_back(inst);

            if (last.operation.category == Operation::Category::branch) {
              // add last instruction back
              predBlock.instructions.push_back(last);
            }
          }
        }
      }
    }
  }

  return prog;
}
