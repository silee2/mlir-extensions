// Copyright 2022 Intel Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include "mlir-extensions/Conversion/linalg_reduction_to_parallel_loop.hpp"

#include <mlir/Conversion/AsyncToLLVM/AsyncToLLVM.h>
#include <mlir/Conversion/GPUCommon/GPUCommonPass.h>
#include <mlir/Conversion/LLVMCommon/ConversionTarget.h>
#include <mlir/Conversion/LLVMCommon/Pattern.h>
#include <mlir/Dialect/Func/IR/FuncOps.h>
#include <mlir/Dialect/Func/Transforms/FuncConversions.h>
#include <mlir/Dialect/GPU/Passes.h>
#include <mlir/Dialect/LLVMIR/LLVMDialect.h>

// Expose the passes to the outside world

std::unique_ptr<mlir::Pass> gpu_runtime::createGPUToLLVMPass() {
  return std::make_unique<GPUToLLVMPass>();
}
