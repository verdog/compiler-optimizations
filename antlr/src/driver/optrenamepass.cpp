#include <memory>

#include "dominancefrontiers.h"
#include "dominatortreepass.h"
#include "livevariableanalysispass.h"
#include "normalformpass.h"
#include "optrenamepass.h"
#include "removedeletedpass.h"

OptRenamePass::OptRenamePass()
    : PDTreePass(DominatorTreePass::Mode::postdominator) {}

IlocProgram OptRenamePass::applyToProgram(IlocProgram prog) {
  LiveVariableAnalysisPass LVApass;
  LVApass.applyToProgram(prog);
  DTreePass.applyToProgram(prog);
  PDTreePass.applyToProgram(prog);

  for (auto &proc : prog.getProceduresReference()) {
    placePhiNodes(prog, proc);
    optRenameInit(proc);
    optRename(proc.getBlockReference("entry"), proc);
  }

  prog.setIsSSA(true);

  return prog;
}

void OptRenamePass::placePhiNodes(IlocProgram &prog, IlocProcedure &proc) {
  LiveVariableAnalysisPass LVAPass;
  LVAPass.applyToProgram(prog);

  // clear phi nodes (in case we're running a second time)
  for (auto blockCopy : proc.orderedBlocks()) {
    auto &block = proc.getBlockReference(blockCopy.debugName);
    block.phinodes.clear();
  }

  // insert phi nodes
  for (auto var : proc.getAllVariableNames()) {
    std::set<BasicBlock> iterDomFront = iteratedDominanceFrontier(var, proc);
    for (auto block : iterDomFront) {
      DataFlowSets sets = LVAPass.getBlockSets(proc, block);
      if (sets.in.find(var) != sets.in.end()) {
        PhiNode phi(var);
        for (auto pred : block.before) {
          phi.addRValue(proc.getBlock(pred), var);
        }
        proc.getBlockReference(block.debugName).phinodes.push_back(phi);
      }
    }
  }
}

std::set<BasicBlock>
OptRenamePass::iteratedDominanceFrontier(Value variable, IlocProcedure proc) {
  // construct S: (entry U every block with a definition of variable)
  std::set<BasicBlock> work;
  work.insert(proc.getBlock("entry"));
  for (auto block : proc.orderedBlocks()) {
    bool found = false;
    for (auto inst : block.instructions) {
      for (auto value : inst.operation.lvalues) {
        if (value.getName() == variable.getName()) {
          work.insert(block);
          found = true;
          break;
        }
      }
      if (found == true)
        break;
    }
  }

  DominanceFrontiers frontiers(DTreePass.getDominatorTree(proc));
  std::set<BasicBlock> iteratedDF;

  while (!work.empty()) {
    BasicBlock block = *work.begin();
    work.erase(block);

    for (auto blockInFrontier : frontiers.getDominanceFrontier(block)) {
      if (iteratedDF.find(blockInFrontier) == iteratedDF.end()) {
        // not in the set
        iteratedDF.insert(blockInFrontier);
        work.insert(blockInFrontier);
      }
    }
  }

  // debug output
  // std::cerr << "iterated dominance frontier of " << variable.getName() <<
  // ":\n"; for (auto block : iteratedDF) {
  //   std::cerr << "   " << block.debugName << std::endl;
  // }

  return iteratedDF;
}

void OptRenamePass::optRenameInit(IlocProcedure &proc) {
  // initialize namestack
  nameStackMap.clear();
  nextNameMap.clear();
  availableExpressionStack.clear();

  for (auto var : proc.getAllVariableNames()) {
    nameStackMap.insert({var.getName(), std::stack<Value>()});
  }

  // initialize argument register stacks
  for (auto &arg : proc.getFrameReference().arguments) {
    arg.setSubscript(newSubscript(arg));
    nameStackMap.at(arg.getName()).push(arg);
  }

  // initialize special register stacks
  Value zeroValue =
      Value("%vr0", Value::Type::virtualReg, Value::Behavior::memory);
  zeroValue.setSubscript(newSubscript(zeroValue));
  nameStackMap.at("%vr0").push(zeroValue);

  Value oneValue =
      Value("%vr1", Value::Type::virtualReg, Value::Behavior::memory);
  oneValue.setSubscript(newSubscript(oneValue));
  nameStackMap.at("%vr1").push(oneValue);

  Value twoValue =
      Value("%vr2", Value::Type::virtualReg, Value::Behavior::memory);
  twoValue.setSubscript(newSubscript(twoValue));
  nameStackMap.at("%vr2").push(twoValue);
}

void OptRenamePass::optRename(BasicBlock &block, IlocProcedure &proc) {
  for (auto phi : block.phinodes) {
    Value newName = pushNewName(phi.getLValue());
  }

  startBlock();

  for (auto &inst : block.instructions) {
    for (auto &rvalue : inst.operation.rvalues) {
      if (rvalue.getType() == Value::Type::virtualReg) {
        rvalue = nameStackMap.at(rvalue.getName()).top();
      }
    }
    if (inst.operation.category != Operation::Category::branch) {
      if (inst.operation.lvalues.size() > 1) {
        std::cerr << "Can't handle multiple lvalues in rename.\n";
        throw "Can't handle multiple lvalues in rename.\n";
      }
      if (inst.operation.lvalues.size() == 1) {
        ValueExpression thisExp(inst);
        if (inst.operation.category != Operation::Category::io &&
            inst.operation.category != Operation::Category::memory &&
            isAvailable(thisExp)) {
          nameStackMap.at(inst.operation.lvalues.front().getName())
              .push(getTopAvailableExpression(thisExp).second);
          inst.markAsDeleted();
        } else {
          pushNewName(inst.operation.lvalues.front());
          addAvailable(
              thisExp,
              nameStackMap.at(inst.operation.lvalues.front().getName()).top());
        }
      }
    }
  }

  for (auto succName : block.after) {
    BasicBlock &successor = proc.getBlockReference(succName);
    for (auto &phi : successor.phinodes) {
      phi.replaceRValue(block,
                        nameStackMap.at(phi.getLValue().getName()).top());
    }
  }

  // recurse
  for (auto child : DTreePass.getDominatorTree(proc)
                        .findNodeByBlockname(block.debugName)
                        .getChildren()) {
    BasicBlock &next = proc.getBlockReference(child.getBasicBlock().debugName);
    optRename(next, proc);
  }

  // rename lvalues
  for (auto it = block.instructions.rbegin(); it != block.instructions.rend();
       ++it) {
    auto &inst = *it;

    if (inst.operation.category != Operation::Category::branch &&
        inst.operation.category != Operation::Category::nop) {
      if (inst.operation.lvalues.size() > 1) {
        std::cerr << "Can't handle multiple lvalues in rename.\n";
        throw "Can't handle multiple lvalues in rename.\n";
      }

      if (inst.operation.lvalues.size() == 1) {
        Value newValue = popNameStack(inst.operation.lvalues.front());
        inst.operation.lvalues.front() = newValue;
      }
    }
  }

  for (auto &phi : block.phinodes) {
    phi.setLValue(popNameStack(phi.getLValue()));
  }

  endBlock();
}

Value OptRenamePass::pushNewName(Value val) {
  Value newVal = val;
  newVal.setSubscript(newSubscript(val));
  nameStackMap.at(newVal.getName()).push(newVal);

  return newVal;
}

Value OptRenamePass::popNameStack(Value val) {
  Value r = nameStackMap.at(val.getName()).top();
  nameStackMap.at(val.getName()).pop();
  return r;
}

std::string OptRenamePass::newSubscript(Value val) {
  std::string name = std::to_string(nextNameMap[val.getName()]);
  nextNameMap[val.getName()]++;
  return name;
}

void OptRenamePass::startBlock() {
  availableExpressionStack.push_back(
      std::unordered_map<ValueExpression, Value>());
}

void OptRenamePass::endBlock() { availableExpressionStack.pop_back(); }

bool OptRenamePass::isAvailable(ValueExpression e) {
  for (auto it = availableExpressionStack.rbegin();
       it != availableExpressionStack.rend(); ++it) {
    const auto &map = *it;
    if (map.find(e) != map.end()) {
      return true;
    }
  }

  return false;
}

void OptRenamePass::addAvailable(ValueExpression e, Value l) {
  availableExpressionStack.back().insert({e, l});
}

std::pair<ValueExpression, Value>
OptRenamePass::getTopAvailableExpression(ValueExpression e) {
  for (auto it = availableExpressionStack.rbegin();
       it != availableExpressionStack.rend(); ++it) {
    const auto &map = *it;
    if (map.find(e) != map.end()) {
      return {e, map.at(e)};
    }
  }

  throw "Whoops";
}
