#include "valueoccurance.h"

ValueOccurance::ValueOccurance(Tag t, BasicBlock block)
    : tag{t}, containingBlock{block.debugName} {}

PhiNodeValueOccurance::PhiNodeValueOccurance(PhiNode phi, BasicBlock block)
    : ValueOccurance(ValueOccurance::Tag::phinode, block), phinode{phi} {}

InstructionValueOccurance::InstructionValueOccurance(Instruction instr,
                                                     BasicBlock block)
    : ValueOccurance(ValueOccurance::Tag::instruction, block), inst{instr} {}

PredefinedValueOccurance::PredefinedValueOccurance(Value value,
                                                   BasicBlock block)
    : ValueOccurance(ValueOccurance::Tag::predefined, block), val{value} {}
