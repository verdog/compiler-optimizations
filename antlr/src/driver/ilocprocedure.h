#pragma once

#include <string>
#include <unordered_map>

#include "basicblock.h"
#include "frame.h"
#include "ssainfo.h"

class IlocProcedure {
public:
  using BlockStructure = std::unordered_map<std::string, BasicBlock>;
  Frame getFrame() const;
  Frame &getFrameReference();
  void setFrame(Frame frame);
  void addBlock(std::string name, BasicBlock block);
  void addBlocks(BlockStructure newBlocks);
  void addBlocks(std::vector<BasicBlock> newBlocks);
  BasicBlock getBlock(std::string name) const;
  BasicBlock &getBlockReference(std::string name);
  BlockStructure getBlocks() const;
  void clearBlocks();
  std::vector<BasicBlock> orderedBlocks() const;
  std::unordered_set<Value, ValueNameHash, ValueNameEqual>
  getAllVariableNames() const;
  SSAInfo getSSAInfo() const;
  SSAInfo &getSSAInfoReference();
  void setExitBlockName(std::string name);
  std::string getExitBlockName() const;

private:
  Frame frame;
  BlockStructure blocks;
  std::string _exitBlockName;
  SSAInfo _ssainfo;
};

namespace std {
template <> struct hash<IlocProcedure> {
  std::size_t operator()(const IlocProcedure &p) const noexcept {
    return std::hash<std::string>{}(p.getFrame().name);
  }
};
} // namespace std

bool operator==(const IlocProcedure &a, const IlocProcedure &b);
