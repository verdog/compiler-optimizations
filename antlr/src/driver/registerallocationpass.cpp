#include "registerallocationpass.h"

#include "interferencegraph.h"
#include "liverangespass.h"
#include "livevariableanalysispass.h"
#include "ssapass.h"

IlocProgram RegisterAllocationPass::applyToProgram(IlocProgram prog) {
  bool dirtyProg = true;
  unsigned int iterations = 0;
  std::unordered_map<std::string, std::set<LiveRange>> spilledSetMap;

  // initialize
  for (auto proc : prog.getProcedures()) {
    _dirtyMap[proc.getFrame().name] = true;
    spilledSetMap.insert({proc.getFrame().name, {}});
    _graphMap.insert({proc.getFrame().name, InterferenceGraph()});
  }

  _offsetMap.clear();

  LiveRangesPass lrpass;
  prog = lrpass.applyToProgram(prog);

  while (dirtyProg == true) {
    dirtyProg = false;
    iterations++;

    LiveVariableAnalysisPass<HardValueSet> lvapass;
    prog = lvapass.applyToProgram(prog);
    lvapass.dump();

    for (auto &proc : prog.getProceduresReference()) {
      if (_dirtyMap.at(proc.getFrame().name) == true) {
        InterferenceGraph &igraph = _graphMap.at(proc.getFrame().name);

        // create interference graph
        igraph.createFromLiveRanges(lrpass, proc, lvapass,
                                    spilledSetMap.at(proc.getFrame().name));

        // process graph
        colorGraph(igraph, 12);

        igraph.dump();

        // spill
        bool dirtyProc = spillRegisters(proc, igraph, lrpass,
                                        spilledSetMap.at(proc.getFrame().name));

        _dirtyMap.at(proc.getFrame().name) = dirtyProc;

        if (dirtyProc == true) {
          dirtyProg = true;
        }
      }
    }
  }

  // convert values to mapped colors
  for (auto &proc : prog.getProceduresReference()) {
    remapNames(proc, _graphMap.at(proc.getFrame().name),
               lrpass.getLiveRanges(proc));
  }

  std::cerr << iterations << " register alloc iterations.\n";

  return prog;
}

void RegisterAllocationPass::colorGraph(InterferenceGraph &igraph,
                                        unsigned int k) {
  std::stack<InterferenceGraphNode> stack;

  // fill up stack
  while (igraph.empty() == false) {
    InterferenceGraphNode cheapestNode;

    if (igraph.minDegree() < k - 4) {
      cheapestNode = igraph.getAnyNodeWithDegree(igraph.minDegree());
    } else {
      cheapestNode = igraph.getLowestSpillcostNode();
    }

    igraph.removeNode(cheapestNode);
    stack.push(cheapestNode);
  }

  // try to color
  while (stack.empty() == false) {
    InterferenceGraphNode node = stack.top();
    stack.pop();
    igraph.addNode(node);
    igraph.colorNode(node, k);
  }
}

bool RegisterAllocationPass::spillRegisters(IlocProcedure &proc,
                                            InterferenceGraph &igraph,
                                            LiveRangesPass lrpass,
                                            std::set<LiveRange> &spilledSet) {

  std::set<LiveRange> rangesSet = lrpass.getLiveRanges(proc);
  bool spilled = false;

  // spill function arguments
  BasicBlock &entryBlock = proc.getBlockReference("entry");

  for (auto argValue : proc.getFrame().arguments) {
    // lookup range value is in
    LiveRange argRange = lrpass.getRangeWithValue(argValue, rangesSet);
    InterferenceGraphNode node = igraph.getNode(argRange.name);

    if (node.color == InterferenceGraphColor::uncolored) {
      // spill here
      // find instruction in question in the copied vector
      auto instCopyPos = entryBlock.instructions.begin();

      if (instCopyPos == entryBlock.instructions.end()) {
        throw "didn't find the instruction...";
      }

      // create store instruction
      createStoreAIInst(argValue, argRange, proc, entryBlock.instructions,
                        instCopyPos);

      // if we spill arguments, since they're passed by reference, we need to
      // re-load them before returning
      BasicBlock exitBlock = proc.getBlock(proc.getExitBlockName());

      for (auto predBlockName : exitBlock.before) {
        createLoadAIInst(
            argValue, argRange, proc,
            proc.getBlockReference(predBlockName).instructions,
            --proc.getBlockReference(predBlockName).instructions.end());
      }

      // remember that we spilled
      spilledSet.insert(argRange);

      // we spilled, will have to do another iteration
      spilled = true;
    }
  }

  for (auto blockCopy : proc.orderedBlocks()) {
    BasicBlock &block = proc.getBlockReference(blockCopy.debugName);

    // make a copy of the instructions so we can safely edit it while iterating
    std::vector<Instruction> newInstructions = block.instructions;

    for (auto inst : block.instructions) {
      if (inst.isDeleted() == true)
        continue;

      // don't store immediately after a load
      if (inst.operation.opcode == ilocParser::LOADAI)
        continue;

      // spill definitions - store after def
      if (inst.operation.lvalues.size() > 0) {
        Value lval = inst.operation.lvalues.front();
        if (lval.getType() == Value::Type::virtualReg) {
          // lookup range lvalue is in
          LiveRange lvalRange = lrpass.getRangeWithValue(lval, rangesSet);
          InterferenceGraphNode node = igraph.getNode(lvalRange.name);

          if (node.color == InterferenceGraphColor::uncolored) {
            // spill here
            // find instruction in question in the copied vector
            auto instCopyPos =
                std::find(newInstructions.begin(), newInstructions.end(), inst);

            if (instCopyPos == newInstructions.end()) {
              throw "didn't find the instruction...";
            }

            // we need to insert after the instruction
            instCopyPos++;

            // create instruction
            createStoreAIInst(lval, lvalRange, proc, newInstructions,
                              instCopyPos);

            // remember that we spilled
            spilledSet.insert(lvalRange);

            // we spilled, will have to do another iteration
            spilled = true;
          }
        }
      }
    }

    // set new instructions
    block.instructions = newInstructions;
  }

  // load before use
  for (auto blockCopy : proc.orderedBlocks()) {
    BasicBlock &block = proc.getBlockReference(blockCopy.debugName);

    // make a copy of the instructions so we can safely edit it while
    // iterating
    std::vector<Instruction> newInstructions = block.instructions;

    for (auto inst : block.instructions) {
      if (inst.isDeleted() == true)
        continue;

      // don't load immediately before a store
      if (inst.operation.opcode == ilocParser::STOREAI)
        continue;

      // spill uses - load before use
      for (auto rval : inst.operation.rvalues) {
        if (rval.getType() == Value::Type::virtualReg) {
          // lookup range rval is in
          LiveRange rvalRange = lrpass.getRangeWithValue(rval, rangesSet);
          InterferenceGraphNode node = igraph.getNode(rvalRange.name);

          if (node.color == InterferenceGraphColor::uncolored) {
            // spill here
            // find instruction in question in the copied vector
            auto instCopyPos =
                std::find(newInstructions.begin(), newInstructions.end(), inst);

            if (instCopyPos == newInstructions.end()) {
              throw "didn't find the instruction...";
            }

            // create instruction
            createLoadAIInst(rval, rvalRange, proc, newInstructions,
                             instCopyPos);
          }
        }
      }
    }

    // set new instructions
    block.instructions = newInstructions;
  }

  return spilled;
}

void RegisterAllocationPass::createStoreAIInst(
    Value value, LiveRange lvalRange, IlocProcedure &proc,
    std::vector<Instruction> &list, std::vector<Instruction>::iterator pos) {

  // see if we already have an offset for the value
  std::unordered_map<LiveRange, unsigned int> &offsetMap =
      _offsetMap[proc.getFrame().name];

  unsigned int offset;
  if (offsetMap.find(lvalRange) == offsetMap.end()) {
    // not found
    offset = std::stoi(proc.getFrame().number) + 4;
    offsetMap.insert({lvalRange, offset});

    // update frame instruction
    proc.getFrameReference().number = std::to_string(offset);
  } else {
    // found
    offset = offsetMap.at(lvalRange);
  }

  // create the storeai instruction
  Operation op(ilocParser::STOREAI);
  Value rval = value;
  Value lval =
      Value("%vr0", Value::Type::virtualReg, Value::Behavior::expression);
  lval.setSubscript("0");
  Value offsetValue = Value("-" + std::to_string(offset), Value::Type::number,
                            Value::Behavior::expression);

  op.rvalues.push_back(rval);
  op.rvalues.push_back(lval);
  op.rvalues.push_back(offsetValue);
  op.arrow = "=>";

  // insert it
  list.insert(pos, Instruction(op));
}

void RegisterAllocationPass::createLoadAIInst(
    Value value, LiveRange valueRange, IlocProcedure &proc,
    std::vector<Instruction> &list, std::vector<Instruction>::iterator pos) {

  // get offset
  unsigned int offset = _offsetMap.at(proc.getFrame().name).at(valueRange);

  // create the loadai instruction
  Operation op(ilocParser::LOADAI);
  Value lval = value;
  Value rval =
      Value("%vr0", Value::Type::virtualReg, Value::Behavior::expression);
  rval.setSubscript("0");
  Value offsetValue = Value("-" + std::to_string(offset), Value::Type::number,
                            Value::Behavior::expression);

  op.rvalues.push_back(rval);
  op.rvalues.push_back(offsetValue);
  op.lvalues.push_back(lval);
  op.arrow = "=>";

  // insert it
  list.insert(pos, Instruction(op));
}

void RegisterAllocationPass::remapNames(IlocProcedure &proc,
                                        InterferenceGraph graph,
                                        std::set<LiveRange> liveRanges) {
  LiveRangesPass utilLRPass;

  // map arguments
  for (auto &arg : proc.getFrameReference().arguments) {
    if (arg.getType() == Value::Type::virtualReg) {
      LiveRange liveRange = utilLRPass.getRangeWithValue(arg, liveRanges);
      InterferenceGraphNode node = graph.getNode(liveRange.name);

      arg.setSubscript(arg.getFullText());
      arg.setName("%vr" + std::to_string(node.color));
    }
  }

  // map instructions
  for (auto blockCopy : proc.orderedBlocks()) {
    BasicBlock &block = proc.getBlockReference(blockCopy.debugName);

    for (auto &inst : block.instructions) {
      if (inst.isDeleted()) {
        continue;
      }

      for (auto &lval : inst.operation.lvalues) {
        if (lval.getType() == Value::Type::virtualReg) {
          LiveRange liveRange = utilLRPass.getRangeWithValue(lval, liveRanges);
          InterferenceGraphNode node = graph.getNode(liveRange.name);

          lval.setSubscript(lval.getFullText());
          lval.setName("%vr" + std::to_string(node.color));
        }
      }

      for (auto &rval : inst.operation.rvalues) {
        if (rval.getType() == Value::Type::virtualReg) {
          LiveRange liveRange = utilLRPass.getRangeWithValue(rval, liveRanges);
          InterferenceGraphNode node = graph.getNode(liveRange.name);

          rval.setSubscript(rval.getFullText());
          rval.setName("%vr" + std::to_string(node.color));
        }
      }
    }
  }
}