#include <mlir/Dialect/Affine/IR/AffineOps.h>
#include <mlir/Dialect/GPU/GPUDialect.h>
#include <mlir/Dialect/GPU/ParallelLoopMapper.h>
#include <mlir/Dialect/SCF/SCF.h>
#include <mlir/Dialect/StandardOps/IR/Ops.h>
#include <mlir/Dialect/MemRef/IR/MemRef.h>
// #include <mlir/Dialect/Arithmetic/IR/Arithmetic.h>
#include <mlir/IR/BlockAndValueMapping.h>
#include <mlir/IR/Builders.h>
#include <mlir/IR/BuiltinOps.h>
#include <mlir/IR/MLIRContext.h>
#include <mlir/IR/PatternMatch.h>
#include <mlir/IR/TypeRange.h>
#include <mlir/IR/UseDefLists.h>
#include <mlir/IR/Value.h>
#include <mlir/IR/Visitors.h>
#include <mlir/Pass/Pass.h>
#include <mlir/Support/LLVM.h>
#include <mlir/Support/LogicalResult.h>
#include <mlir/Transforms/DialectConversion.h>
#include <mlir/Analysis/LoopAnalysis.h>
#include <llvm/ADT/ArrayRef.h>
#include <llvm/ADT/None.h>
#include <llvm/ADT/STLExtras.h>
#include <llvm/ADT/iterator_range.h>
#include <llvm/Support/ErrorHandling.h>
#include <llvm/Support/raw_ostream.h>
#include <cstdint>
#include <functional>
#include <iterator>

#include "Conversion/LoopsToGPU/GPUParallelLoopMapping.h"
#include "Conversion/LoopsToGPU/Passes.h"

#include "PassDetail.h"

#include <iostream>

using namespace mlir;

namespace {
/// Simple pass for testing the mapping of parallel loops to hardware ids using
/// a greedy mapping strategy.
class GPUParallelLoopMappingPass
    : public PassWrapper<GPUParallelLoopMappingPass,
                         OperationPass<FuncOp>> {
  StringRef getArgument() const final {
    return "uh-gpu-parallel-loop-mapping";
  }
  StringRef getDescription() const final {
    return "maps all parallel loops to gpu hardware ids.";
  }
  void runOnOperation() override {
    Operation *op = getOperation();
    for (Region &region : op->getRegions())
      greedilyMapParallelSCFToGPU(region);
  }
};
} // namespace


std::unique_ptr<Pass> mlir::createGPUParallelLoopMappingPass() {
    return std::make_unique<GPUParallelLoopMappingPass>();
}

namespace {

void applyPromoteWorkGroupMemory(gpu::GPUFuncOp op, SmallVector<Value, 2>& memlist, 
    SmallVector<memref::AllocOp, 2> alcOps) {
  for (auto& mem : memlist) {
    MemRefType type = mem.getType().dyn_cast<MemRefType>();
    // Get the type of the buffer in the workgroup memory.
    // int workgroupMemoryAddressSpace = gpu::GPUDialect::getWorkgroupAddressSpace();
    // auto bufferType = MemRefType::get(type.getShape(), type.getElementType(), {},
    //                                   workgroupMemoryAddressSpace);

    Value attribution = op.addWorkgroupAttribution(type);

    // Replace the uses first since only the original uses are currently present.
    // Then insert the copies.
    mem.replaceAllUsesWith(attribution);
    
  }
  for (auto& alc : alcOps) {
    alc.erase();
  }
}

class UHPromoteWorkgroupMemoryPass
    : public PassWrapper<UHPromoteWorkgroupMemoryPass,
                         OperationPass<gpu::GPUFuncOp>> {
  StringRef getArgument() const final {
    return "uh-promote-workgroup-memory";
  }
  StringRef getDescription() const final {
    return "promote workgroup memref alloc to gpu.func workgroup attribute.";
  }
  void runOnOperation() override;
};

void UHPromoteWorkgroupMemoryPass::runOnOperation() {
  gpu::GPUFuncOp op = getOperation();
  // FuncOp f = getFunction();
  SmallVector<Value, 2> memlist;
  SmallVector<memref::AllocOp, 2> alcOps;
  
  op.walk<WalkOrder::PreOrder>([&](memref::AllocOp alc) {
      MemRefType type = alc.getResult().getType().dyn_cast<MemRefType>();
      // Convert deprecated integer-like memory space to Attribute.
      Attribute workgroupMemorySpaceAttr = IntegerAttr::get(
          IntegerType::get(op.getContext(), 64), gpu::GPUDialect::getWorkgroupAddressSpace());
      if (type.getMemorySpace() == workgroupMemorySpaceAttr) {
        memlist.push_back(alc.getResult());
        alcOps.push_back(alc);
      }
    });
  if (memlist.size() > 0)
    applyPromoteWorkGroupMemory(op, memlist, alcOps);
}
} // namespace


std::unique_ptr<Pass> mlir::createUHPromoteWorkgroupMemoryPass() {
    return std::make_unique<UHPromoteWorkgroupMemoryPass>();
}