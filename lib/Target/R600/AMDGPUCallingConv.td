//===---- AMDCallingConv.td - Calling Conventions for Radeon GPUs ---------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This describes the calling conventions for the AMD Radeon GPUs.
//
//===----------------------------------------------------------------------===//

// Inversion of CCIfInReg
class CCIfNotInReg<CCAction A> : CCIf<"!ArgFlags.isInReg()", A> {}

// Calling convention for SI
def CC_SI : CallingConv<[

  CCIfInReg<CCIfType<[f32, i32] , CCAssignToReg<[
    SGPR0, SGPR1, SGPR2, SGPR3, SGPR4, SGPR5, SGPR6, SGPR7,
    SGPR8, SGPR9, SGPR10, SGPR11, SGPR12, SGPR13, SGPR14, SGPR15,
    SGPR16
  ]>>>,

  CCIfInReg<CCIfType<[i64] , CCAssignToRegWithShadow<
    [ SGPR0, SGPR2, SGPR4, SGPR6, SGPR8, SGPR10, SGPR12, SGPR14 ],
    [ SGPR1, SGPR3, SGPR5, SGPR7, SGPR9, SGPR11, SGPR13, SGPR15 ]
  >>>,

  CCIfNotInReg<CCIfType<[f32, i32] , CCAssignToReg<[
    VGPR0, VGPR1, VGPR2, VGPR3, VGPR4, VGPR5, VGPR6, VGPR7,
    VGPR8, VGPR9, VGPR10, VGPR11, VGPR12, VGPR13, VGPR14, VGPR15,
    VGPR16, VGPR17, VGPR18, VGPR19, VGPR20, VGPR21, VGPR22, VGPR23,
    VGPR24, VGPR25, VGPR26, VGPR27, VGPR28, VGPR29, VGPR30, VGPR31
  ]>>>,

  CCIfByVal<CCIfType<[i64] , CCAssignToRegWithShadow<
    [ SGPR0, SGPR2, SGPR4, SGPR6, SGPR8, SGPR10, SGPR12, SGPR14 ],
    [ SGPR1, SGPR3, SGPR5, SGPR7, SGPR9, SGPR11, SGPR13, SGPR15 ]
  >>>

]>;

// Calling convention for compute kernels
def CC_AMDGPU_Kernel : CallingConv<[
  CCCustom<"allocateStack">
]>;

def CC_AMDGPU : CallingConv<[
  CCIf<"State.getTarget().getSubtarget<AMDGPUSubtarget>().getGeneration() >= "
       "AMDGPUSubtarget::SOUTHERN_ISLANDS && "
       "State.getMachineFunction().getInfo<SIMachineFunctionInfo>()->"#
       "ShaderType == ShaderType::COMPUTE", CCDelegateTo<CC_AMDGPU_Kernel>>,
  CCIf<"State.getTarget().getSubtarget<AMDGPUSubtarget>().getGeneration() < "
       "AMDGPUSubtarget::SOUTHERN_ISLANDS && "
       "State.getMachineFunction().getInfo<R600MachineFunctionInfo>()->"
       "ShaderType == ShaderType::COMPUTE", CCDelegateTo<CC_AMDGPU_Kernel>>,
  CCIf<"State.getTarget().getSubtarget<AMDGPUSubtarget>()"#
       ".getGeneration() >= AMDGPUSubtarget::SOUTHERN_ISLANDS", CCDelegateTo<CC_SI>>
]>;
