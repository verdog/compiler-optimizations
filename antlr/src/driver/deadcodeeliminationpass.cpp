#include "deadcodeeliminationpass.h"
#include "dominancefrontiers.h"
#include "dominatortreepass.h"
#include "usesanddefinitionspass.h"

DeadCodeEliminationPass::DeadCodeEliminationPass()
    : PDTreePass(DominatorTreePass::Mode::postdominator) {}

IlocProgram DeadCodeEliminationPass::applyToProgram(IlocProgram prog) {
  std::cerr << "eliminating dead code\n";
  UsesAndDefinitionsPass ssaInfoPass;
  prog = ssaInfoPass.applyToProgram(prog);
  PDTreePass.applyToProgram(prog);

  for (auto &proc : prog.getProceduresReference()) {
    eliminateDeadCode(proc);
  }

  return prog;
}

void DeadCodeEliminationPass::eliminateDeadCode(IlocProcedure &proc) {
  // initialize
  _instWorklist.clear();
  _instNecessary.clear();
  _instVisited.clear();
  _phiWorkList.clear();
  _phiVisited.clear();
  _phiNecessary.clear();

  // put side effect instructions in the work list
  for (auto blockCopy : proc.orderedBlocks()) {
    BasicBlock &block = proc.getBlockReference(blockCopy.debugName);
    for (auto &inst : block.instructions) {
      if (inst.hasPossibleSideEffects()) {
        if (std::find(_instWorklist.begin(), _instWorklist.end(), inst) ==
            _instWorklist.end()) {
          _instWorklist.push_back(inst);
        }
        _instNecessary.insert(inst);
      }
    }
  }

  DominanceFrontiers PDFrontiers(PDTreePass.getDominatorTree(proc),
                                 DominanceFrontiers::Mode::postdominator);
  // PDFrontiers.dump();

  // do work
  while (_instWorklist.empty() != true || _phiWorkList.empty() != true) {
    // do instructions
    while (_instWorklist.empty() != true) {
      // take
      Instruction instCopy = *_instWorklist.begin();
      _instWorklist.erase(_instWorklist.begin());
      _instVisited.insert(instCopy);

      BasicBlock block = proc.getBlock(getContainingBlockName(instCopy, proc));

      // branches to necessary instructions are necessary
      addBranchesToBlock(block, PDFrontiers);

      // definitions of necessary rvalues are necessary
      for (auto rvalue : getRValuesFrom(instCopy)) {
        addDefinitionOfRValue(rvalue, proc);
      }
    }

    // do phinodes
    while (_phiWorkList.empty() != true) {
      // take
      PhiNode phiCopy = *_phiWorkList.begin();
      _phiWorkList.erase(_phiWorkList.begin());
      _phiVisited.insert(phiCopy);

      BasicBlock block = proc.getBlock(getContainingBlockName(phiCopy, proc));

      // contidtional branches to necessary instructions are necessary
      addBranchesToBlock(block, PDFrontiers);

      // definitions of necessary rvalues are necessary
      for (auto rvalue : getRValuesFrom(phiCopy)) {
        addDefinitionOfRValue(rvalue, proc);
      }
    }
  }

  // remove unecessary
  for (auto blockCopy : proc.orderedBlocks()) {
    BasicBlock &block = proc.getBlockReference(blockCopy.debugName);

    // instructions
    for (auto &inst : block.instructions) {
      if (_instNecessary.find(inst) == _instNecessary.end()) {
        // unecessary. is it a conditional branch?
        if (inst.operation.category == Operation::Category::branch &&
            inst.operation.opcode != ilocParser::JUMP &&
            inst.operation.opcode != ilocParser::JUMPI) {
          Value lval = inst.operation.lvalues.front();
          DominatorTree tree = PDTreePass.getDominatorTree(proc);
          std::string newName = PDTreePass.getDominatorTree(proc)
                                    .findParentOf(block.debugName)
                                    .getBasicBlock()
                                    .debugName;

          Operation newOp(ilocParser::JUMPI);
          newOp.arrow = "->";
          newOp.lvalues.push_back(
              Value(newName, Value::Type::label, Value::Behavior::unknown));
          inst.operation = newOp;
        } else if (inst.label == "") {
          // delete everything that isn't the start of a block
          inst.markAsDeleted();
        }
      }
    }

    // phi nodes
    for (auto &phi : block.phinodes) {
      if (_phiNecessary.find(phi) == _phiNecessary.end()) {
        phi.markAsDeleted();
      }
    }
  }
}

std::vector<Value>
DeadCodeEliminationPass::getRValuesFrom(const Instruction &inst) {
  return inst.operation.rvalues;
}

std::vector<Value> DeadCodeEliminationPass::getRValuesFrom(const PhiNode &phi) {
  std::vector<Value> r;
  for (auto pair : phi.getRValueMap()) {
    r.push_back(pair.second);
  }
  return r;
}

std::string
DeadCodeEliminationPass::getContainingBlockName(const Instruction &inst,
                                                const IlocProcedure &proc) {
  return inst.containingBlockName;
}

std::string
DeadCodeEliminationPass::getContainingBlockName(const PhiNode &phi,
                                                const IlocProcedure &proc) {
  for (auto block : proc.orderedBlocks()) {
    for (auto lookphi : block.phinodes) {
      if (phi == lookphi)
        return block.debugName;
    }
  }

  throw "uh oh";
  return "not good";
}

void DeadCodeEliminationPass::addDefinitionOfRValue(Value r,
                                                    const IlocProcedure &proc) {
  if (r.getType() == Value::Type::virtualReg) {
    // the definition is necessary
    std::shared_ptr<ValueOccurance> definition =
        proc.getSSAInfo().definitionsMap.at(r);

    auto phidef = std::dynamic_pointer_cast<PhiNodeValueOccurance>(definition);
    auto instdef =
        std::dynamic_pointer_cast<InstructionValueOccurance>(definition);

    if (instdef != nullptr) {
      // it's defined as an rvalue in an instruction
      Instruction inst = instdef->inst;
      if (_instNecessary.find(inst) == _instNecessary.end()) {
        _instNecessary.insert(inst);
        if (_instVisited.find(inst) == _instVisited.end()) {
          _instWorklist.push_back(inst);
        }
      }
    } else if (phidef != nullptr) {
      // it's defined by a phi node
      PhiNode phi = phidef->phinode;
      if (_phiNecessary.find(phi) == _phiNecessary.find(phi)) {
        _phiNecessary.insert(phi);
        if (_phiVisited.find(phi) == _phiVisited.end()) {
          _phiWorkList.push_back(phi);
        }
      }
    }
  }
}

void DeadCodeEliminationPass::addBranchesToBlock(
    const BasicBlock &block, const DominanceFrontiers &PDF) {
  // condinitional branches to necessary instructions are necessary
  for (auto controlDepBlock : PDF.getDominanceFrontier(block)) {
    Instruction lastInst = controlDepBlock.instructions.back();
    Operation::Category opCat = lastInst.operation.category;
    unsigned int opCode = lastInst.operation.opcode;

    if (opCat == Operation::Category::branch && opCode != ilocParser::JUMP &&
        opCode != ilocParser::JUMPI) {
      // we have a conditional branch. does it branch to me?
      // in other words, am i in that blocks successors?
      if (std::find(controlDepBlock.after.begin(), controlDepBlock.after.end(),
                    lastInst.operation.lvalues.front().getFullText()) !=
          controlDepBlock.after.end()) {
        _instNecessary.insert(lastInst);
        if (_instVisited.find(lastInst) == _instVisited.end()) {
          _instWorklist.push_back(lastInst);
        }
      }
    }
  }
}
