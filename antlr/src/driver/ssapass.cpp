#include <memory>

#include "dominancefrontiers.h"
#include "dominatortreepass.h"
#include "livevariableanalysispass.h"
#include "ssapass.h"

SSAPass::SSAPass() : PDTreePass(DominatorTreePass::Mode::postdominator) {}

IlocProgram SSAPass::applyToProgram(IlocProgram prog) {
  DTreePass.applyToProgram(prog);
  PDTreePass.applyToProgram(prog);

  for (auto &proc : prog.getProceduresReference()) {
    placePhiNodes(prog, proc);
    renameInit(proc);
    rename(proc.getBlockReference("entry"), proc);
  }

  prog.setIsSSA(true);

  return prog;
}

void SSAPass::placePhiNodes(IlocProgram &prog, IlocProcedure &proc) {
  LiveVariableAnalysisPass<SoftValueSet> LVAPass;
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
      DataFlowSets<SoftValueSet> sets = LVAPass.getBlockSets(proc, block);
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

std::set<BasicBlock> SSAPass::iteratedDominanceFrontier(Value variable,
                                                        IlocProcedure proc) {
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

void SSAPass::renameInit(IlocProcedure &proc) {
  // initialize namestack
  nameStackMap.clear();
  nextNameMap.clear();

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

  // initialize seen expressions map
  seenExpressionsMapStack.clear();
}

void SSAPass::rename(BasicBlock &block, IlocProcedure &proc) {
  // define phi nodes
  for (auto phi : block.phinodes) {
    if (phi.isDeleted() == true)
      continue;

    pushNewName(phi.getLValue());
  }

  startBlock();

  // rename rvalues and define lvalues
  for (auto &inst : block.instructions) {
    if (inst.isDeleted() == true)
      continue;

    for (auto &rvalue : inst.operation.rvalues) {
      if (rvalue.getType() == Value::Type::virtualReg) {
        rvalue = nameStackMap.at(rvalue.getName()).top();
      }
    }

    if (inst.operation.category != Operation::Category::branch) {
      if (inst.operation.lvalues.size() == 1) {
        Value lvalue = inst.operation.lvalues.front();

        // record seen lvalue
        if (haveSeen(lvalue, inst.operation)) {
          // we've already seen this definition of the lvalue, so it can be
          // deleted
          if ((inst.operation.category == Operation::Category::expression ||
               inst.operation.category == Operation::Category::loadimmediate) &&
              lvalue.getBehavior() == Value::Behavior::expression) {
            inst.markAsDeleted();
          } else {
            // since we didn't do anything, we need to push a new name
            pushNewName(lvalue);
            recordSeen(lvalue, inst.operation);
          }
        } else {
          // we haven't seen it, save it for later and push new name
          pushNewName(lvalue);
          recordSeen(lvalue, inst.operation);
        }
      } else {
        // we have multiple lvalues, best we can do is record new definitions
        // for each
        for (auto lval : inst.operation.lvalues) {
          pushNewName(lval);
        }
      }
    }
  }

  // connect phi nodes
  for (auto succName : block.after) {
    BasicBlock &successor = proc.getBlockReference(succName);
    for (auto &phi : successor.phinodes) {
      if (phi.isDeleted() == true)
        continue;

      phi.replaceRValue(block,
                        nameStackMap.at(phi.getLValue().getName()).top());
    }
  }

  // recurse
  for (auto child : DTreePass.getDominatorTree(proc)
                        .findNodeByBlockname(block.debugName)
                        .getChildren()) {
    BasicBlock &next = proc.getBlockReference(child.getBasicBlock().debugName);
    rename(next, proc);
  }

  // rename lvalues
  for (auto it = block.instructions.rbegin(); it != block.instructions.rend();
       ++it) {
    auto &inst = *it;

    if (inst.isDeleted())
      continue;

    if (inst.operation.category != Operation::Category::branch &&
        inst.operation.category != Operation::Category::nop) {
      for (auto &lval : inst.operation.lvalues) {
        Value newValue = popNameStack(lval);
        lval = newValue;
      }
    }
  }

  endBlock();

  // rename phi nodes
  for (auto &phi : block.phinodes) {
    if (phi.isDeleted() == true)
      continue;

    phi.setLValue(popNameStack(phi.getLValue()));
  }
}

Value SSAPass::pushNewName(Value val) {
  Value newVal = val;
  newVal.setSubscript(newSubscript(val));
  nameStackMap.at(newVal.getName()).push(newVal);

  return newVal;
}

Value SSAPass::popNameStack(Value val) {
  Value r = nameStackMap.at(val.getName()).top();
  nameStackMap.at(val.getName()).pop();
  return r;
}

std::string SSAPass::newSubscript(Value val) {
  std::string name = std::to_string(nextNameMap[val.getName()]);
  nextNameMap[val.getName()]++;
  return name;
}

void SSAPass::startBlock() {
  // push empty map onto stack
  seenExpressionsMapStack.push_back({});
}

void SSAPass::endBlock() {
  // pop a map
  seenExpressionsMapStack.pop_back();
}

bool SSAPass::haveSeen(Value lval, Operation op) {
  for (auto it = seenExpressionsMapStack.rbegin();
       it != seenExpressionsMapStack.rend(); ++it) {
    auto &map = *it;

    if (map.find(lval) != map.end()) {
      // found the lval, but is it the operation?

      Operation foundOp = map.at(lval);

      if (op.opcode != foundOp.opcode)
        return false;

      if (op.rvalues != foundOp.rvalues)
        return false;

      // passed all the checks
      return true;
    }
  }

  return false;
}

void SSAPass::recordSeen(Value lval, Operation op) {
  seenExpressionsMapStack.back().insert({lval, op});
}
