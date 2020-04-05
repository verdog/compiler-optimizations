#include <sstream>

#include "codeemitter.h"

CodeEmitter::CodeEmitter(antlr4::dfa::Vocabulary _vocab) : vocab(_vocab) {}

void CodeEmitter::emit(const IlocProgram &program) {
  for (auto psop : program.getPseudoOps()) {
    std::cout << tab << psop << std::endl;
  }

  for (const auto &proc : program.getProcedures()) {
    std::cout << tab << text(proc.getFrame()) << std::endl;
    for (const auto &block : proc.orderedBlocks()) {
      std::cout << text(block) << std::endl;
    }
  }
}

void CodeEmitter::emitDebug(const IlocProgram &program) {
  for (auto psop : program.getPseudoOps()) {
    std::cerr << tab << psop << std::endl;
  }

  for (const auto &proc : program.getProcedures()) {
    std::cerr << tab << debugText(proc.getFrame()) << std::endl;
    for (const auto &block : proc.orderedBlocks()) {
      std::cerr << debugText(block) << std::endl;
    }
  }
}

std::string CodeEmitter::text(const Instruction &inst) const {
  std::string text;

  if (inst.operation.opcode == ilocParser::STORE ||
      inst.operation.opcode == ilocParser::STOREAI ||
      inst.operation.opcode == ilocParser::STOREAO) {
    return storeInstText(inst);
  }

  // show deleted
  if (inst.isDeleted() == true) {
    text += "(deleted)";
  }

  if (inst.label != "") {
    text += inst.label + ": ";
  } else {
    text += tab;
  }

  // vocabulary returns name with quotes, trim them
  std::string opName = vocab.getDisplayName(inst.operation.opcode);
  opName = opName.substr(1, opName.length() - 2);
  text += opName;

  std::string spacer = " ";
  for (auto v : inst.operation.rvalues) {
    text += spacer + v.getName();
    spacer = ", ";
  }

  if (inst.operation.lvalues.size() > 0) {
    text += " " + inst.operation.arrow;
    for (auto v : inst.operation.lvalues) {
      text += " " + v.getName();
    }
  }

  return text;
}

std::string CodeEmitter::debugText(const Instruction &inst) const {
  std::string text;

  // show deleted
  if (inst.isDeleted() == true) {
    text += "(deleted)";
  }

  if (inst.label != "") {
    text += inst.label + ": ";
  } else {
    text += tab;
  }

  // vocabulary returns name with quotes, trim them
  std::string opName = vocab.getDisplayName(inst.operation.opcode);
  opName = opName.substr(1, opName.length() - 2);
  text += opName;

  std::string spacer = " ";
  for (auto v : inst.operation.rvalues) {
    text += spacer + v.getFullText();
    spacer = ", ";
  }

  if (inst.operation.lvalues.size() > 0) {
    text += " " + inst.operation.arrow;
    for (auto v : inst.operation.lvalues) {
      text += " " + v.getFullText();
    }
  }

  return text;
}

std::string CodeEmitter::text(const BasicBlock &bblock) const {
  std::stringstream ss;

  // if (bblock.debugName != "") {
  //   ss << bblock.debugName << std::endl;
  // }

  for (auto inst : bblock.instructions) {
    if (inst.isDeleted() != true) {
      ss << text(inst) << std::endl;
    }
  }

  return ss.str();
}

std::string CodeEmitter::debugText(const BasicBlock &bblock) const {
  std::stringstream ss;

  // if (bblock.debugName != "") {
  //   ss << bblock.debugName << std::endl;
  // }

  bool haveEmittedPhi = false;
  bool canEmitPhi;
  if (bblock.instructions.front().label != "") {
    canEmitPhi = false;
  } else {
    canEmitPhi = true;
  }

  for (auto inst : bblock.instructions) {
    if (canEmitPhi == true && haveEmittedPhi == false) {
      for (auto phi : bblock.phinodes) {
        ss << debugText(phi);
      }
      haveEmittedPhi = true;
    }
    ss << debugText(inst) << std::endl;

    canEmitPhi = true;
  }

  return ss.str();
}

std::string CodeEmitter::debugText(const PhiNode &phi) const {
  std::stringstream ss;

  // show deleted
  if (phi.isDeleted() == true) {
    ss << "(deleted)";
  }

  ss << "   "
     << "(phi): " << phi.getLValue().getFullText() << " ";

  std::string spacer = "";
  ss << "(";
  for (auto pair : phi.getRValueMap()) {
    ss << spacer << pair.first << "->" << pair.second.getFullText();
    spacer = ", ";
  }
  ss << ")";

  ss << std::endl;

  return ss.str();
}

std::string CodeEmitter::debugText(const Frame &frame) const {
  std::stringstream ss;

  ss << ".frame ";
  ss << frame.name << ", ";
  ss << frame.number;

  for (auto arg : frame.arguments) {
    ss << ", " << arg.getFullText();
  }

  return ss.str();
}

std::string CodeEmitter::text(const Frame &frame) const {
  std::stringstream ss;

  ss << ".frame ";
  ss << frame.name << ", ";
  ss << frame.number;

  for (auto arg : frame.arguments) {
    ss << ", " << arg.getName();
  }

  return ss.str();
}

std::string CodeEmitter::storeInstText(const Instruction &inst) const {
  // store instructions are tricky. they don't really have any "lvalues", but
  // must be printed as if they do.

  std::string text = tab;

  // show deleted
  if (inst.isDeleted() == true) {
    text += "(deleted)";
  }

  // vocabulary returns name with quotes, trim them
  std::string opName = vocab.getDisplayName(inst.operation.opcode);
  opName = opName.substr(1, opName.length() - 2);
  text += opName;

  std::string spacer = " ";

  for (int i = 0; i < inst.operation.rvalues.size(); i++) {
    auto v = inst.operation.rvalues[i];
    if (i == 0) {
      text += spacer + v.getName() + " " + inst.operation.arrow;
    } else {
      text += spacer + v.getName();
      spacer = ", ";
    }
  }

  return text;
}
