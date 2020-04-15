#include "usesanddefinitionspass.h"

IlocProgram UsesAndDefinitionsPass::applyToProgram(IlocProgram prog) {
  for (auto &proc : prog.getProceduresReference()) {
    proc.getSSAInfoReference().definitionsMap.clear();
    proc.getSSAInfoReference().usesMap.clear();
    calculateSSAInfo(proc);
  }

  return prog;
};

void UsesAndDefinitionsPass::calculateSSAInfo(IlocProcedure &proc) {
  auto &defMap = proc.getSSAInfoReference().definitionsMap;
  auto &usesMap = proc.getSSAInfoReference().usesMap;

  defMap.clear();
  usesMap.clear();

  // special registers
  Value vr0 = Value("%vr0", Value::Type::virtualReg, Value::Behavior::memory);
  vr0.setSubscript("0");
  Value vr1 = Value("%vr1", Value::Type::virtualReg, Value::Behavior::memory);
  vr1.setSubscript("0");
  Value vr2 = Value("%vr2", Value::Type::virtualReg, Value::Behavior::memory);
  vr2.setSubscript("0");
  Value vr3 = Value("%vr3", Value::Type::virtualReg, Value::Behavior::memory);
  vr3.setSubscript("0");

  defMap.insert({vr0, std::make_shared<PredefinedValueOccurance>(
                          vr0, proc.getBlock("entry"))});
  defMap.insert({vr1, std::make_shared<PredefinedValueOccurance>(
                          vr1, proc.getBlock("entry"))});
  defMap.insert({vr2, std::make_shared<PredefinedValueOccurance>(
                          vr2, proc.getBlock("entry"))});
  defMap.insert({vr3, std::make_shared<PredefinedValueOccurance>(
                          vr3, proc.getBlock("entry"))});

  // arguments
  for (auto value : proc.getFrame().arguments) {
    value.setSubscript("0");
    defMap.insert({value, std::make_shared<PredefinedValueOccurance>(
                              value, proc.getBlock("entry"))});
  }

  for (auto blockCopy : proc.orderedBlocks()) {
    BasicBlock &block = proc.getBlockReference(blockCopy.debugName);

    // instructions
    for (auto inst : block.instructions) {
      // skip deleted
      if (inst.isDeleted()) {
        continue;
      }

      // uses
      for (auto rval : inst.operation.rvalues) {
        if (rval.getType() == Value::Type::virtualReg) {
          usesMap[rval].push_back(
              std::make_shared<InstructionValueOccurance>(inst, block));
        }
      }

      // definitions
      for (auto lval : inst.operation.lvalues) {
        if (lval.getType() == Value::Type::virtualReg) {
          if (defMap.find(lval) == defMap.end()) {
            defMap.insert({lval, std::make_shared<InstructionValueOccurance>(
                                     inst, block)});
          }
        }
      }
    }

    // phi nodes
    for (auto phi : block.phinodes) {
      // skip deleted
      if (phi.isDeleted()) {
        continue;
      }

      // uses
      for (auto pair : phi.getRValueMap()) {
        Value rval = pair.second;
        if (rval.getType() == Value::Type::virtualReg) {
          usesMap[rval].push_back(
              std::make_shared<PhiNodeValueOccurance>(phi, block));
        }
      }

      // definitions
      Value lval = phi.getLValue();
      defMap.insert(
          {lval, std::make_shared<PhiNodeValueOccurance>(phi, block)});
    }
  }
}
