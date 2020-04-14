#include "registerallocationpass.h"

#include "interferencegraph.h"
#include "liverangespass.h"
#include "livevariableanalysispass.h"
#include "ssapass.h"

IlocProgram RegisterAllocationPass::applyToProgram(IlocProgram prog) {
  bool dirtyProg = true;
  unsigned int iterations = 0;
  std::unordered_map<std::string, std::set<LiveRange>> spilledSetMap;

  // initialize dirty map and spilled map
  for (auto proc : prog.getProcedures()) {
    _dirtyMap[proc.getFrame().name] = true;
    spilledSetMap.insert({proc.getFrame().name, {}});
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
        InterferenceGraph igraph;

        // create interference graph
        igraph.createFromLiveRanges(lrpass, proc, lvapass,
                                    spilledSetMap.at(proc.getFrame().name));

        // process graph
        colorGraph(igraph, 8);

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

      // create instruction
      createStoreAIInst(argValue, argRange, proc, entryBlock.instructions,
                        instCopyPos);

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

    // // check phi nodes
    // for (auto phi : block.phinodes) {
    //   if (phi.isDeleted() == true)
    //     continue;

    //   Value lval = phi.getLValue();
    //   // lookup range lvalue is in
    //   LiveRange lvalRange = lrpass.getRangeWithValue(lval, rangesSet);
    //   InterferenceGraphNode node = igraph.getNode(lvalRange.name);

    //   if (node.color == InterferenceGraphColor::uncolored) {
    //     // spill here
    //     auto instCopyPos = newInstructions.begin();

    //     if ((*instCopyPos).label != "") {
    //       // don't insert before a label
    //       instCopyPos++;
    //     }

    //     // create instruction
    //     createStoreAIInst(lval, lvalRange, proc, newInstructions,
    //     instCopyPos);

    //     // we spilled, will have to do another iteration
    //     spilled = true;
    //   }
    // }

    for (auto inst : block.instructions) {
      if (inst.isDeleted() == true)
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

            // we need to insert after the instruction
            instCopyPos++;

            if (instCopyPos == newInstructions.end()) {
              throw "didn't find the instruction...";
            }

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
