//====-- Z80Subtarget.h - Define Subtarget for the Z80 ---------*- C++ -*--===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file declares the Z80 specific subclass of TargetSubtargetInfo.
//
//===----------------------------------------------------------------------===//

#ifndef Z80SUBTARGET_H
#define Z80SUBTARGET_H

#include "llvm/Target/TargetSubtargetInfo.h"
#include "llvm/IR/DataLayout.h"
#include "Z80SelectionDAGInfo.h"

#define GET_SUBTARGETINFO_HEADER
#include "Z80GenSubtargetInfo.inc"

namespace llvm {
  class StringRef;
  class Z80TargetMachine;

  class Z80Subtarget : public Z80GenSubtargetInfo {
  public:
    const DataLayout DL;  // Calculates type size & alignment
    const Z80TargetMachine * TM;
    const Z80SelectionDAGInfo TSInfo;
    // This constructor initializes the data members to match that
    // of the specified triple.
    //
    Z80Subtarget(const std::string &TT, const std::string &CPU, const std::string &FS,
                 const Z80TargetMachine * TM);
    virtual ~Z80Subtarget() {}

    virtual const DataLayout *getDataLayout() const { return &(this->DL); }
    virtual const TargetRegisterInfo *getRegisterInfo() const;
    virtual const TargetInstrInfo *getInstrInfo() const;
    virtual const TargetFrameLowering *getFrameLowering() const;
    virtual const TargetLowering *getTargetLowering() const;
    virtual const TargetSelectionDAGInfo *getSelectionDAGInfo() const;

    // ParseSubtargetFeature - Parses features string setting specified
    // subtarget options. Definition of function is auto generated by tblgen.
    void ParseSubtargetFeatures(StringRef CPU, StringRef FS);
  }; // end class Z80Subtarget
} // end namespace llvm

#endif
