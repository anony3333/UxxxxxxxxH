#include <mlir/Dialect/Affine/IR/AffineOps.h>
#include <mlir/Dialect/Affine/IR/AffineValueMap.h>
#include <mlir/Dialect/Affine/Utils.h>
#include <mlir/Transforms/LoopUtils.h>
#include <mlir/Transforms/Utils.h>
#include <mlir/Transforms/GreedyPatternRewriteDriver.h>
#include <mlir/Dialect/GPU/GPUDialect.h>
#include <mlir/Dialect/GPU/MemoryPromotion.h>
#include <mlir/Dialect/GPU/ParallelLoopMapper.h>
#include <mlir/Dialect/SCF/SCF.h>
#include <mlir/Dialect/StandardOps/IR/Ops.h>
#include <mlir/Dialect/MemRef/IR/MemRef.h>
// #include <mlir/Dialect/Arithmetic/IR/Arithmetic.h>
#include <mlir/IR/BlockAndValueMapping.h>
#include <mlir/IR/Builders.h>
#include <mlir/IR/ImplicitLocOpBuilder.h>
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
#include <mlir/Analysis/Utils.h>
#include <llvm/ADT/DenseMap.h>
#include <llvm/ADT/ArrayRef.h>
#include <llvm/ADT/None.h>
#include <llvm/ADT/STLExtras.h>
#include <llvm/ADT/MapVector.h>
#include <llvm/ADT/iterator_range.h>
#include <llvm/Support/ErrorHandling.h>
#include <llvm/Support/raw_ostream.h>
#include <cstdint>
#include <functional>
#include <iterator>

#include "Dialect/SW/SWOps.h"
#include "Dialect/SW/SWDialect.h"
#include "Dialect/SW/SWTypes.h"

#include "Conversion/UHAffineToParallel/UHAffineToParallel.h"
#include "Conversion/UHAffineToParallel/Passes.h"

#include "Conversion/UnifiedHardware/UnifiedHardware.h"

#include "PassDetail.h"

#include <iostream>

using namespace mlir;
using namespace mlir::gpu;
using OpListType = llvm::iplist<Operation>;


LogicalResult applyUHAffineToParallel(UnifiedHardware* uh, OpBuilder builder,
                                    std::vector<AffineForOp> loops) {
        auto loc = loops[0]->getLoc();
        OpBuilder::InsertionGuard guard(builder);
        builder.setInsertionPointAfter(loops[0]);

        // AffineForOp tmpForOp = builder.create<AffineForOp>(loc, 0, 1, 1);

        AffineParallelOp AffinePloop;
        auto funcOp = loops[0]->getParentOfType<FuncOp>();
        auto indexTy = IndexType::get(funcOp.getContext());

        auto& uhLevels = uh->levels;
        for (size_t i = 0; i < loops.size() && i < uhLevels.size(); i ++) {

            unsigned numDim = uhLevels[i] -> num_dimension;
            SmallVector<AffineMap> lbMaps(numDim, builder.getConstantAffineMap(0));
            SmallVector<AffineMap> ubMaps(numDim, builder.getConstantAffineMap(1));
            
            // std::cout << lbMap.getNumInputs() << std::endl;
            ValueRange lbArgs; // ValueRange is a vector of value
            ValueRange ubArgs;
            SmallVector<int64_t> steps(numDim, 1);
            // int64_t step = 1;
            AffinePloop = builder.create<AffineParallelOp>(loc,
                    llvm::None, llvm::None,
                    lbMaps, lbArgs,
                    ubMaps, ubArgs,
                    steps
                    );

            AffinePloop->setAttr("parallelTag", 
                                StringAttr::get(funcOp->getContext(), uhLevels[i]->label));
            AffinePloop->setAttr("num_dimension", 
                                IntegerAttr::get(indexTy, uhLevels[i]->num_dimension));
            
            builder.setInsertionPointToStart(AffinePloop.getBody());
            
        }

        // tmpForOp should not be created inside affinePloop
        // builder.setInsertionPointAfter(loops[0]);

        // getBody() returns a Block*
        AffinePloop.getBody()->getOperations().splice(
            AffinePloop.getBody()->begin(), loops[0]->getBlock()->getOperations(), 
            loops[0]);     

        // tmpForOp.erase();

        return success();
    }


// assume:
// 1. constant loop
// 2. loop can be perfectly divided by tileSize
void updateAffineForContiguous(OpBuilder builder, AffineForOp forOp, unsigned tileSize,
                                Value outer_iv) {
    // original range
    Optional<uint64_t> mayBeConstantCount = getConstantTripCount(forOp);
    assert(mayBeConstantCount && "assume the loop being constant");
    uint64_t largestDiv = mayBeConstantCount.getValue();

    // new range
    uint64_t loopLength = largestDiv / tileSize;
    assert(tileSize * loopLength == largestDiv && "assume the loop can be perfectly tiled");

    { // set the lower bound
        // AffineExpr dimExpr = builder.getAffineDimExpr(/*position=*/0);
        AffineMap origMap = forOp.getLowerBoundMap();
        AffineExpr origExpr = origMap.getResult(0);
        // expr for the new iv
        AffineExpr ivExpr = builder.getAffineDimExpr(/*pos=*/origMap.getNumDims());

        // i is the dim_th ploop induction var
        // newLb = origLb + loopLen * i
        AffineMap newLbMap = AffineMap::get(origMap.getNumDims() + 1, 0,
                                            origExpr + loopLength * ivExpr);
        SmallVector<Value> newOperands = forOp.getLowerBoundOperands();
        newOperands.push_back(outer_iv);

        forOp.setLowerBound(newOperands, newLbMap);
    }

    // set the upper bound
    if (mayBeConstantCount && mayBeConstantCount.getValue() < loopLength)
    {
        // Trip count is less than the tile size: upper bound is lower bound +
        // trip count * stepSize.
        AffineMap newUbMap = builder.getShiftedAffineMap(forOp.getLowerBoundMap(),
                                        mayBeConstantCount.getValue() * forOp.getStep());
        // get the dimth iv
        SmallVector<Value> newOperands(forOp.getLowerBoundOperands());
        forOp.setUpperBound(newOperands, newUbMap);
    }
    else if (largestDiv % tileSize == 0)
    {
        // newUb = start_i + loopLen
        //       = newLb + loopLen
        AffineMap newLbMap = forOp.getLowerBoundMap();
        AffineExpr lbExpr = newLbMap.getResult(0);

        AffineMap newUbMap = AffineMap::get(newLbMap.getNumDims(), 0,
                                            lbExpr + loopLength);
        // append the dimth iv for the new input operand
        SmallVector<Value> newOperands = forOp.getUpperBoundOperands();
        newOperands.push_back(outer_iv);
        forOp.setUpperBound(newOperands, newUbMap);
    }
}

void updateAffineForStrided(OpBuilder builder, AffineForOp forOp, unsigned tileSize,
                            Value outer_iv) {
    // original range
    int64_t largestDiv = getLargestDivisorOfTripCount(forOp);
    // new range
    int64_t loopLength = largestDiv / tileSize;
    assert(tileSize * loopLength == largestDiv && "assume the loop can be perfectly tiled");

    // strided

    // AffineMap lbMap = builder.getConstantAffineMap(0);
    // AffineMap ubMap = builder.getConstantAffineMap(loopLength);

    // forOp.setLowerBound({}, lbMap);
    // forOp.setUpperBound({}, ubMap);
    forOp.setStep(forOp.getStep() * tileSize);

    { // set the lower bound
        // AffineExpr dimExpr = builder.getAffineDimExpr(/*position=*/0);
        AffineMap origMap = forOp.getLowerBoundMap();
        AffineExpr origExpr = origMap.getResult(0);
        // expr for the new iv
        AffineExpr ivExpr = builder.getAffineDimExpr(/*pos=*/origMap.getNumDims());

        // i is the dim_th ploop induction var
        // newLb = origLb + i
        AffineMap newLbMap = AffineMap::get(origMap.getNumDims() + 1, 0,
                                            origExpr + ivExpr);
        SmallVector<Value> newOperands = forOp.getLowerBoundOperands();
        newOperands.push_back(outer_iv);

        forOp.setLowerBound(newOperands, newLbMap);
    }
    { // set the upper bound
        // newUb = start_i + loopLen * tileSize
        //       = newLb + loopLen * tileSize
        AffineMap newLbMap = forOp.getLowerBoundMap();
        AffineExpr lbExpr = newLbMap.getResult(0);

        AffineMap newUbMap = AffineMap::get(newLbMap.getNumDims(), 0,
                                            lbExpr + loopLength * tileSize);
        // append the dimth iv for the new input operand
        SmallVector<Value> newOperands = forOp.getUpperBoundOperands();
        newOperands.push_back(outer_iv);
        forOp.setUpperBound(newOperands, newUbMap);
    }

    // // Operation* old_apply = &*forOp.getBody(0)->getOperations().begin();
    // AffineExpr d0 = builder.getAffineDimExpr(0);
    // AffineExpr d1 = builder.getAffineDimExpr(1);
    // AffineMap ivMap = AffineMap::get(2, 0, (d0 * tileSize + d1) * loopLength);

    // builder.setInsertionPointToStart(forOp.getBody(0));
    // auto iv = forOp.getInductionVar();
    // Value newArg = builder.create<AffineApplyOp>(forOp->getLoc(), ivMap, 
    //                     SmallVector<Value, 2>{outer_iv, iv});
    
    // // iv.replaceAllUsesWith(newArg);
    // // for (auto op : ops) {
    // //     (&*op)->replaceUsesOfWith(iv, newArg);
    // // }
    // Block::OpListType& ops = forOp.getBody(0)->getOperations();
    // auto it_end = ops.end();
    // it_end --;
    // auto it_begin = ops.begin();
    // // while (*it_begin != newArg) {
    // //     it_begin ++;
    // // }
    // // it_begin ++;
    // while (it_begin != it_end) {
    //     (&*it_begin) -> replaceUsesOfWith(iv, newArg);
    //     (&*it_begin) -> walk([&](Operation* op){
    //         op -> replaceUsesOfWith(iv, newArg);
    //     });
    //     it_begin ++;
    // }
    
}

//============================================================================//
// UHTilingAffineFor pass
//============================================================================//

struct UHTilingAffineForPass : public UHTilingAffineForPassBase<UHTilingAffineForPass> {
    void runOnFunction() override;
};

LogicalResult applyUHTilingAffineFor(UnifiedHardware* uh, OpBuilder builder,
                            std::vector<AffineForOp> loops, 
                            SmallVector<std::vector<unsigned>, 3> tileSizes) {
        // assert(loops.size() >= tileSizes.size());

        auto funcOp = loops[0]->getParentOfType<FuncOp>();
        auto indexTy = IndexType::get(funcOp.getContext());

        for (auto loop : loops) {
            AffineMap lbMap = loop.getLowerBoundMap();
            assert(lbMap.isSingleConstant());
            int64_t lb = lbMap.getSingleConstantResult();
            loop->setAttr("domain_lower_bound", IntegerAttr::get(indexTy, lb));
        }
        
        auto loc = loops[0]->getLoc();
        OpBuilder::InsertionGuard guard(builder);
        builder.setInsertionPointAfter(loops[0]);

        AffineForOp newFor;

        for (auto it : llvm::zip(uh->levels, tileSizes)) {
            auto& lev = std::get<0>(it);
            auto& tileSize = std::get<1>(it);
            // int tile_dim = std::min(lev->num_dimension, tileSize.size());
            for (int dim = (int)tileSize.size() - 1; dim >= 0; dim --) {
                newFor = builder.create<AffineForOp>(loc, 0, tileSize[dim], 1);
                
                newFor->setAttr("parallelTag", 
                                StringAttr::get(funcOp->getContext(), lev->label));
                newFor->setAttr("dim", 
                                IntegerAttr::get(indexTy, dim));
                
                loops[dim]->setAttr("dim_" + lev->label, 
                                IntegerAttr::get(indexTy, dim));
                loops[dim]->setAttr("thread_loop", builder.getUnitAttr());
            
                builder.setInsertionPointToStart(newFor.getBody(0));

                Value outer_iv = newFor.getInductionVar();

                if (uh->name == "gpu" && lev->label == "block")
                    // strided tiling
                    updateAffineForStrided(builder, loops[dim], tileSize[dim], outer_iv);
                else
                    // contiguous tiling
                    updateAffineForContiguous(builder, loops[dim], tileSize[dim], outer_iv);
            }
            for (int dim = tileSize.size(); dim < lev->num_dimension; dim ++) {
                newFor = builder.create<AffineForOp>(loc, 0, 1, 1);
                
                newFor->setAttr("parallelTag", 
                                StringAttr::get(funcOp->getContext(), lev->label));
                newFor->setAttr("dim", 
                                IntegerAttr::get(indexTy, dim));
                builder.setInsertionPointToStart(newFor.getBody(0));
            }
        }

        auto it = newFor.getBody(0)->end();
        it --;
        loops[0]->moveBefore(newFor.getBody(0), it);


        return success();
    }

void UHTilingAffineForPass::runOnFunction() {

    FuncOp funcOp = getFunction();
    std::vector<AffineForOp> loops;
    funcOp.walk<WalkOrder::PreOrder>([&](AffineForOp loop) {
        if (loop->hasAttr("stencil_main_loop"))
            loops.push_back(loop);
    });
    
    // TODO: get unified hardware from json file
    UH::instantial();
    UnifiedHardware* uh;
    if (hardware == "gpu") uh = UH::_gpu;
    else if (hardware == "sw") uh = UH::_sw;
    else {
        llvm::errs() << "Now only gpu and sw are supported.\n";
        return;
    }

    // parallel tiling
    SmallVector<std::vector<unsigned>, 3> tileSizes;
    if (tile_sizes_l0.size())
        tileSizes.push_back(tile_sizes_l0);
    if (tile_sizes_l1.size())
        tileSizes.push_back(tile_sizes_l1);
    if (tile_sizes_l2.size())
        tileSizes.push_back(tile_sizes_l2);

    OpBuilder builder(funcOp.getContext());
    if (loops.size() > 0) {
        if (failed(applyUHTilingAffineFor(uh, builder, loops, tileSizes))) {
            signalPassFailure();
        } else {
            funcOp.getOperation()->setAttr("hardware", 
                StringAttr::get(funcOp->getContext(), hardware));
        }
    }
    
}

std::unique_ptr<Pass> mlir::createUHTilingAffineForPass() {
    return std::make_unique<UHTilingAffineForPass>();
}


// ============================================================================//
// UHTilingToParallel pass
// ============================================================================//

struct UHTilingToParallelPass : public UHTilingToParallelPassBase<UHTilingToParallelPass> {
    void runOnFunction() override;
};

/**
 * @brief tile the inner loops and set the parallel op
 * Example:
 * 
 * // Before
 * parallel () {
 *   parallel () {
 *      for i = (0) to (M) step (1) {
 *          for j = (0) to (N) step (1) {
 *              for k = (0) to (Q) step (1) {
 *                  ... // do the computation
 *              }
 *          }     
 *      }
 *   } // with block level tag
 * } // with grid level tag
 * 
 * // Intermediate
 * parallel (i1, j1, k1) = (0, 0, 0) to (GI, GJ, GK) step (1, 1, 1) {
 *      parallel () = () {
 * 
 *          // loopLen_i1 = M / GI
 *          // start_i = i1 * loopLen_i1
 *          for i = (start_i) to (start_i + loopLen_i1) step (1) {
 * 
 *              // loopLen_j1 = N / GJ
 *              // start_j = j1 * loopLen_j1
 *              for j = (start_j) to (start_j + loopLen_j1) step (1) {
 * 
 *                  // loopLen_k1 = Q / GK
 *                  // start_k = k1 * loopLen_k1
 *                  for k = (start_k) to (start_k + loopLen_k1) step (1) {
 * 
 *                      ... // do the computation                 
 *                  }
 *              }
 *          }
 *      }
 * }
 * 
 * // After
 * parallel (i1, j1, k1) = (0, 0, 0) to (GI, GJ, GK) step (1, 1, 1) {
 *      parallel (i2, j2, k2) = (0, 0, 0) to (BI, BJ, BK) step (1, 1, 1) {
 * 
 *          // loopLen_i1 = M / GI
 *          // loopLen_i2 = loopLen_i1 / BI
 *          // start_i = i1 * loopLen_i1 + i2 * loopLen_i2
 *          for i = (start_i) to (start_i + loopLen_i2) step (1) {
 * 
 *              // loopLen_j1 = N / GJ
 *              // loopLen_j2 = loopLen_j1 / BJ
 *              // start_j = j1 * loopLen_j1 + j2 * loopLen_j2
 *              for j = (start_j) to (start_j + loopLen_j2) step (1) {
 * 
 *                  // loopLen_k1 = Q / GK
 *                  // loopLen_k2 = loopLen_k1 / BK
 *                  // start_k = k1 * loopLen_k1 + k2 * loopLen_k2
 *                  for k = (start_k) to (start_k + loopLen_k2) step (1) {
 * 
 *                      ... // do the computation                 
 *                  }
 *              }
 *          }
 *      }
 * }
 */


LogicalResult applyUHTilingToParallel(SmallVector<std::vector<unsigned>, 3>& tileSizes,
                                    std::vector<AffineParallelOp> pLoops,
                                    std::vector<AffineForOp> innerLoops,
                                    OpBuilder builder) {

        auto loc = pLoops[0].getLoc();
        // create the constant values and place them out of the parallel ops
        // auto funcOp = pLoops[0]->getParentOfType<FuncOp>();
        // builder.setInsertionPointAfter(&*(funcOp.getBody().front().begin()));
        // for (auto& vec : tileSizes) {
        //     for (auto val : vec) {
        //         builder.create<ConstantIndexOp>(loc, val);
        //     }
        // }
        AffineParallelOp innerPar;

        for (size_t i = 0; i < pLoops.size(); i ++) {
            auto& tileSize = tileSizes[i];
            unsigned numDim = pLoops[i]->getAttr("num_dimension").cast<IntegerAttr>().getInt();

            SmallVector<AffineMap> lbMaps(numDim, builder.getConstantAffineMap(0));
            SmallVector<AffineMap> ubMaps;

            SmallVector<Value> lowerBoundOperands;
            SmallVector<Value> upperBoundOperands;
            SmallVector<int64_t> steps(numDim, 1);
            
            // SmallVector<AffineExpr, 8> lbExprs;
            // SmallVector<AffineExpr, 8> ubExprs;
            // auto zeroExpr = builder.getAffineConstantExpr(0);

            for (unsigned dim = 0; dim < numDim; dim ++) {
                // auto lb = builder.create<ConstantIndexOp>(loc, 0);
                // auto ub = builder.create<ConstantIndexOp>(loc, tileSize[dim]);
                // // auto step = builder.create<ConstantIndexOp>(loc, 1);
                // lowerBoundOperands.push_back(lb);
                // upperBoundOperands.push_back(ub);
                ubMaps.push_back(builder.getConstantAffineMap(tileSize[dim]));
                
                // lbExprs.push_back(zeroExpr);

                // AffineExpr ubExpr = builder.getAffineConstantExpr(tileSize[dim]);
                // ubExprs.push_back(ubExpr);

                // BlockArgument iv = pLoops[i].getBody()->getArgument(dim);
                // // AffineExpr lbExpr = zeroExpr;
                // auto expr = zeroExpr + builder.getAffineDimExpr(numDim) * tileSize[dim];
                // auto map = AffineMap::get(numDim + 1, /*symbolCount=*/0, expr);

            }
            // pLoops[i].setSteps(steps);
            // AffineMap newLbMap = AffineMap::get(0, 0, lbExprs, pLoops[i].getContext());
            // pLoops[i].setLowerBounds({}, newLbMap);
            // AffineMap newUbMap = AffineMap::get(numDim, 0, ubExprs, pLoops[i].getContext());
            // pLoops[i].setUpperBounds(upperBoundOperands, newUbMap);

            // SmallVector<int32_t> lbGroups, ubGroups;
            // lbGroups.reserve(1);

            // fullyComposeAffineMapAndOperands(&lbMap, &lowerBoundOperands);
            // fullyComposeAffineMapAndOperands(&ubMap, &upperBoundOperands);

            // Set the bounds of parallel op
            // pLoops[i].setLowerBounds(lowerBoundOperands, lbMap);
            // pLoops[i].setUpperBounds(upperBoundOperands, ubMap);
            // pLoops[i].setSteps(steps);


            // std::cout << i << std::endl;
            builder.setInsertionPointAfter(pLoops[i]);
            AffineParallelOp newPLoop = builder.create<AffineParallelOp> (loc,
                                llvm::None, llvm::None,
                                lbMaps, lowerBoundOperands,
                                ubMaps, upperBoundOperands,
                                steps
                                );
            newPLoop->setAttr("parallelTag", pLoops[i]->getAttr("parallelTag"));
            newPLoop->setAttr("num_dimension", pLoops[i]->getAttr("num_dimension"));
            newPLoop.region().takeBody(pLoops[i].region());
            
            pLoops[i].erase();
            innerPar = newPLoop;

            auto ploop_ivs = newPLoop.getIVs();
            // update the bounds of the inner for loop
            for (size_t dim = 0; dim < numDim; dim ++) {
                
                AffineForOp& forOp = innerLoops[dim];


                // // strided tiling
                // auto orig_step = forOp.getStep();
                // forOp.setStep(tileSize[dim] * orig_step); 

                // intra-tile
                // step are the same as original forOp
                // original range
                updateAffineForContiguous(builder, forOp, tileSize[dim], ploop_ivs[dim]);
            }
        }

        innerPar->setAttr("inner parallel", builder.getUnitAttr());

        return success();
    }

void UHTilingToParallelPass::runOnFunction() {


    FuncOp funcOp = getFunction();
    std::vector<AffineForOp> loops;
    funcOp.walk<WalkOrder::PreOrder>([&](AffineForOp loop) {
        loops.push_back(loop);
    });
    // UnifiedHardware* uh = new UnifiedHardware();
    // get_UH(uh);
    UH::instantial();
    UnifiedHardware* uh;
    if (hardware == "gpu") uh = UH::_gpu;
    else if (hardware == "sw") uh = UH::_sw;
    else {
        llvm::errs() << "Now only gpu and sw are supported.\n";
        return;
    }
    OpBuilder builder(funcOp.getContext());
    if (loops.size() > 0) {
        if (failed(applyUHAffineToParallel(uh, builder, loops))) {
            signalPassFailure();
        }
    }

    /******************* tiling **********************/
    // for testing
    SmallVector<std::vector<unsigned>, 3> tileSizes;
    /* { {4,4,4}, // grid size
        {8,8,8}  // block size
    }; */
    if (tile_sizes_l0.size())
        tileSizes.push_back(tile_sizes_l0);
    if (tile_sizes_l1.size())
        tileSizes.push_back(tile_sizes_l1);
    if (tile_sizes_l2.size())
        tileSizes.push_back(tile_sizes_l2);

    // FuncOp funcOp = getFunction();
    // collect inner for loops
    std::vector<AffineForOp> innerLoops;
    funcOp.walk<WalkOrder::PreOrder>([&](AffineForOp loop) {
        innerLoops.push_back(loop);
    });
    // collect parallel loops
    std::vector<AffineParallelOp> pLoops;
    funcOp.walk<WalkOrder::PreOrder>([&](AffineParallelOp ploop) {
        if (ploop->hasAttr("parallelTag")) {
            pLoops.push_back(ploop);
        }
    });

    if (pLoops.size() > 0) {
        // OpBuilder builder(funcOp.getContext());
        if (failed(applyUHTilingToParallel(tileSizes, pLoops, innerLoops, builder))) {
            return signalPassFailure();
        } else {
            funcOp.getOperation()->setAttr("hardware",
                StringAttr::get(funcOp->getContext(), hardware));
        }
    }

    // Parallel loop mapping to gpu
    // for (Region &region : funcOp->getRegions())
    //   greedilyMapParallelSCFToGPU(region);
}

std::unique_ptr<Pass> mlir::createUHTilingToParallelPass() {
    return std::make_unique<UHTilingToParallelPass>();
}


//============================================================================//
// uh affine parallelize pass
//============================================================================//

LogicalResult applyCollapseAffineParallel(OpBuilder builder,
                                    SmallVector<AffineParallelOp, 3>& loops) {
        auto loc = loops[0]->getLoc();
        OpBuilder::InsertionGuard guard(builder);
        builder.setInsertionPointAfter(loops[0]);


        // AffineParallelOp AffinePloop;
        // auto funcOp = loops[0]->getParentOfType<FuncOp>();
        // auto indexTy = IndexType::get(funcOp.getContext());

        SmallVector<AffineMap> lbMaps;
        SmallVector<AffineMap> ubMaps;

        // assume the parallel ops having no operands and the maps being constant
        SmallVector<Value> lowerBoundOperands; // empty
        SmallVector<Value> upperBoundOperands;
        SmallVector<int64_t> steps;

        SmallVector<BlockArgument> ivs;

        for (auto& loop : loops) {
            // AffineValueMap  lbsValueMap = loop.getLowerBoundsValueMap();
            // AffineValueMap  ubsValueMap = loop.getUpperBoundsValueMap();
            // lbMaps.push_back(lbsValueMap.getAffineMap());
            // ubMaps.push_back(ubsValueMap.getAffineMap());
            for (size_t i = 0; i < loop.getNumDims(); i ++) {
                // lbMaps.push_back(loop.getLowerBoundMap(i));
                lbMaps.push_back(AffineMap::get(0, 0, loop.getLowerBoundMap(i).getResult(0)));
                // ubMaps.push_back(loop.getUpperBoundMap(i));
                ubMaps.push_back(AffineMap::get(0, 0, loop.getUpperBoundMap(i).getResult(0)));
            }
            // steps.emplace(loop.getSteps());
            for (auto& stp : loop.getSteps()) {
                steps.push_back(stp);
            }
            for (auto& iv : loop.getBody()->getArguments()) {
                ivs.push_back(iv);
            }
        }

        AffineParallelOp newPLoop = builder.create<AffineParallelOp> (loc,
                                llvm::None, llvm::None,
                                lbMaps, lowerBoundOperands,
                                ubMaps, upperBoundOperands,
                                steps
                                );
        
        // for (auto& [iv1, iv2] : llvm::zip(ivs, newPLoop.getResults())) {
        //     iv1->replaceAllUsesWith(iv2);
        // }

        // newPLoop.getBody()->getOperations().splice(
        //     newPLoop.getBody()->begin(), loops.back()->getBlock()->getOperations());

        // newPLoop.getLoopBody().takeBody(loops.back().getLoopBody());
        auto it = newPLoop.getBody()->end();
        it --;

        // wierd bug when moving ops
        // so I do it hackly here
        // only one op needed to be moved, an affine.for
        // Operation* nested_for_loops = &*ops.begin();
        //nested_for_loops->remove();
        // Operation clonedOp = builder.cloneWithoutRegions(nested_for_loops);
        // Operation* clonedOp = nested_for_loops->clone();
        // clonedOp->moveBefore(newPLoop.getBody(), it);
        

        // SmallVector<Operation> vec;
        Block::OpListType& ops_ = loops.back().getBody()->getOperations();
        OpListType::iterator opit_end = ops_.end();
        opit_end --;
        // for (OpListType::iterator opit = ops_.begin(); opit != opit_end; opit ++) {
        //     vec.push_back(*opit);
        // }
        // for (auto& op : vec) {
        //     // op->erase();
        //     op->moveBefore(newPLoop.getBody(), it);
        // }
        Block* block = newPLoop.getBody();
        // Setup the argument mapper
        BlockAndValueMapping mapper;
        for (size_t i = 0; i < ivs.size(); i ++) {
            // builder.replaceUsesOfBlockArgument(ivs[i], block->getArgument(i));
            mapper.map(ivs[i], block->getArgument(i));
        }
        // builder.setInsertionPointBefore(*it);
        for (OpListType::iterator opit = ops_.begin(); opit != opit_end; opit ++) {
            Operation* clonedOp = builder.clone(*opit, mapper);
            clonedOp -> moveBefore(block, it);
        }

        loops[0].erase();

        return success();
    }


struct UHAffineParallelizePass : public UHAffineParallelizePassBase<UHAffineParallelizePass> {
    
    void runOnFunction() override;
};

void UHAffineParallelizePass::runOnFunction() {

    FuncOp funcOp = getFunction();

    // collect affine.for loops to parallelize
    DenseMap<StringRef, SmallVector<AffineForOp, 6>> tagToLoops;
    funcOp.walk<WalkOrder::PreOrder>([&](AffineForOp loop) {
        if (loop->hasAttr("parallelTag")) {
            StringRef parLevel = loop->getAttr("parallelTag").cast<StringAttr>().getValue();
            if (tagToLoops.find(parLevel) != tagToLoops.end()) {
                tagToLoops[parLevel].push_back(loop);
            }
            else {
                tagToLoops[parLevel] = {loop};
            }
        }
    });
    SmallVector<SmallVector<AffineParallelOp, 3>, 2> ploopsPerLevel;
    Operation* cur = funcOp.getOperation();
    // parallelize each level
    for (auto [tag, loops] : tagToLoops) {
        for (auto loop : loops) {
            (void)affineParallelize(loop, {});
        }
        SmallVector<AffineParallelOp, 3> ploops;
        // assume only 1 region
        cur->getRegion(0).walk<WalkOrder::PreOrder>([&](AffineParallelOp loop) {
            ploops.push_back(loop);
        });
        // std::cout << "ploops.size() = " << ploops.size() << std::endl;
        ploopsPerLevel.push_back(ploops);
        // the loops are nested
        cur = ploops.back().getOperation();
        // cur = &*ploops.back().getBody()->getOperations().begin(); 
    }
    OpBuilder builder(funcOp.getContext());
    mlir::RewritePatternSet rpl(getOperation()->getContext());

    for (auto it = ploopsPerLevel.rbegin(); it != ploopsPerLevel.rend(); it ++) {
        if (failed(applyCollapseAffineParallel(builder, *it))) {
            signalPassFailure();
        }
    }
}

std::unique_ptr<Pass> mlir::createUHAffineParallelizePass() {
    return std::make_unique<UHAffineParallelizePass>();
}



//============================================================================//
// Affine Inner Loop tiling pass
//============================================================================//
namespace {
struct AffineInnerTilingPass : public AffineInnerTilingPassBase<AffineInnerTilingPass> {
    
    void runOnFunction() override;
};


// void moveLoopBody(AffineForOp src, AffineForOp dest) {
//     auto &ops = src.getBody()->getOperations();
//     dest.getBody()->getOperations().splice(dest.getBody()->begin(), 
//                         ops, ops.begin(), std::prev(ops.end()));
// }

/// example:
/// inner_tile = {2, 4, 8}
/// ******************
/// original loops -->
/// for i0 to i1 step 1
///     for j0 to j1 step 1
///         for k0 to k1 step 1
/// *******************
/// tiled loops -->
/// for i0 to i1 step 2
///     for j0 to j1 step 4
///         for k0 to k1 step 8
///             for 0 to 2 step 1
///                 for 0 to 4 step 1
///                     for 0 to 8 step 1


LogicalResult applyAffineInnerTiling(OpBuilder builder,
                                    std::vector<unsigned> inner_tile,
                                    std::vector<AffineForOp> loops) {
        assert(loops.size() >= inner_tile.size() && 
                "the number of loops is less than inner_tile dimensions");
        auto loc = loops.back()->getLoc();

        // AffineForOp tmpLoop = builder.create<AffineForOp>(loc, 0, 1, 1);
        // moveLoopBody(loops.back(), tmpLoop);
        // Operation* topLoop = loops[0].getOperation();
        AffineForOp innerMostLoop;
        SmallVector<AffineForOp, 3> inners;
        AffineForOp tmpLoop = loops.back();
        
        std::vector<Operation*> ops_part;
        { // collect ops inside innermost loop
            Block::OpListType& ops = tmpLoop.getBody()->getOperations();
            OpListType::iterator opit_end = ops.end();
            opit_end --;
            
            for (OpListType::iterator opit = ops.begin(); opit != opit_end; opit ++) {
                // (&*opit) -> moveBefore(newFor.getBody(0), iter);
                ops_part.push_back(&*opit);
            }
        }
        for (int i = 0; i < (int)inner_tile.size(); i ++) {
            builder.setInsertionPointToStart(tmpLoop.getBody(0));
            AffineForOp newFor = builder.create<AffineForOp>(
                    loops.back()->getLoc(), 0, inner_tile[i], 1);
            // newFor.getBody()->getOperations().splice(
            //     newFor.getBody()->begin(), topLoop->getBlock()->getOperations(),
            //     topLoop);
            // move body
            tmpLoop = newFor;
            inners.push_back(newFor);
            // topLoop = newFor.getOperation();
        }
        // moveLoopBody(loops.back(), innerMostLoop);
        {
            auto iter = tmpLoop.getBody(0)->end();
            iter --;
            for (Operation* op : ops_part) {
                op->moveBefore(tmpLoop.getBody(0), iter);
                iter = tmpLoop.getBody(0)->end();
                iter --;
            }
        }
        // update steps of the outer loops
        // update arguments of the inner block
        // loc = innerMostLoop.getLoc();
        
        builder.setInsertionPointToStart(tmpLoop.getBody(0)); // affine apply
        for (size_t i = 0, idx = loops.size() - inner_tile.size(); 
                i < inner_tile.size(); i ++, idx ++) {

            int64_t outerLoopStep = loops[idx].getStep();
            // update outer loop step
            loops[idx].setStep(inner_tile[i] * outerLoopStep); 
            SmallVector<Value, 2> mpOperands{
                loops[idx].getInductionVar(),
                inners[i].getInductionVar()};

            AffineExpr d0 = builder.getAffineDimExpr(0);
            AffineExpr d1 = builder.getAffineDimExpr(1);
            // newArg = threadIdx.x + innerloop_iv * blockSize_x
            AffineMap argMap = AffineMap::get(2, 0, d0 + d1 * outerLoopStep); // strided
            Value newArg = builder.create<AffineApplyOp>(loc, argMap, mpOperands);

            // loops[idx].getInductionVar().replaceAllUsesWith(newArg);
            for (Operation* op : ops_part) {
                op->replaceUsesOfWith(loops[idx].getInductionVar(), newArg);
            }
        }
        for (auto loop : inners) {
            loop->setAttr("inner_tile", builder.getUnitAttr());
        }
        loops.back()->setAttr("thread_inner_loop", builder.getUnitAttr());
 
        return success();
}

void AffineInnerTilingPass::runOnFunction() {

    std::vector<unsigned> inner_tile = tile_sizes;

    FuncOp funcOp = getFunction();
    std::vector<AffineForOp> loops;
    funcOp.walk<WalkOrder::PreOrder>([&](AffineForOp loop) {
        loops.push_back(loop);
    });
    
    OpBuilder builder(funcOp.getContext());

    if (loops.size() > 0) {
        if (failed(applyAffineInnerTiling(builder, inner_tile, loops))) {
            signalPassFailure();
        }
    }
    
}
} // namespace

std::unique_ptr<Pass> mlir::createAffineInnerTilingPass() {
    return std::make_unique<AffineInnerTilingPass>();
}


// memref 
// mem list
//============================================================================//
// shared memory copy pass
//============================================================================//

/// Returns the textual name of a GPU dimension.
static StringRef getDimName(unsigned dim) {
  if (dim == 0)
    return "x";
  if (dim == 1)
    return "y";
  if (dim == 2)
    return "z";

  llvm_unreachable("dimension ID overflow");
}

/// Emits the (imperfect) loop nest performing the copy between "from" and "to"
/// values using the bounds derived from the "from" value. Emits at least
/// GPUDialect::getNumWorkgroupDimensions() loops, completing the nest with
/// single-iteration loops. Maps the innermost loops to thread dimensions, in
/// reverse order to enable access coalescing in the innermost loop.
static void insertCopyLoops(ImplicitLocOpBuilder &b, Value from, Value to) {
  auto memRefType = from.getType().cast<MemRefType>();
  auto rank = memRefType.getRank();

  SmallVector<Value, 4> lbs, ubs, steps;
  Value zero = b.create<ConstantIndexOp>(0);
  Value one = b.create<ConstantIndexOp>(1);

  // Make sure we have enough loops to use all thread dimensions, these trivial
  // loops should be outermost and therefore inserted first.
  if (rank < GPUDialect::getNumWorkgroupDimensions()) {
    unsigned extraLoops = GPUDialect::getNumWorkgroupDimensions() - rank;
    lbs.resize(extraLoops, zero);
    ubs.resize(extraLoops, one);
    steps.resize(extraLoops, one);
  }

  // Add existing bounds.
  lbs.append(rank, zero);
  ubs.reserve(lbs.size());
  steps.reserve(lbs.size());
  for (auto idx = 0; idx < rank; ++idx) {
    ubs.push_back(
        b.createOrFold<memref::DimOp>(from, b.create<ConstantIndexOp>(idx)));
    steps.push_back(one);
  }

  // Obtain thread identifiers and block sizes, necessary to map to them.
  auto indexType = b.getIndexType();
  SmallVector<Value, 3> threadIds, blockDims;
  for (unsigned i = 0; i < 3; ++i) {
    auto dimName = b.getStringAttr(getDimName(i));
    threadIds.push_back(b.create<gpu::ThreadIdOp>(indexType, dimName));
    blockDims.push_back(b.create<gpu::BlockDimOp>(indexType, dimName));
  }

  // Produce the loop nest with copies.
  SmallVector<Value, 8> ivs(lbs.size());
  mlir::scf::buildLoopNest(
      b, b.getLoc(), lbs, ubs, steps,
      [&](OpBuilder &b, Location loc, ValueRange loopIvs) {
        ivs.assign(loopIvs.begin(), loopIvs.end());
        auto activeIvs = llvm::makeArrayRef(ivs).take_back(rank);
        Value loaded = b.create<memref::LoadOp>(loc, from, activeIvs);
        b.create<memref::StoreOp>(loc, loaded, to, activeIvs);
      });

  // Map the innermost loops to threads in reverse order.
  for (auto en :
       llvm::enumerate(llvm::reverse(llvm::makeArrayRef(ivs).take_back(
           GPUDialect::getNumWorkgroupDimensions())))) {
    Value v = en.value();
    auto loop = cast<scf::ForOp>(v.getParentRegion()->getParentOp());
    mapLoopToProcessorIds(loop, {threadIds[en.index()]},
                          {blockDims[en.index()]});
  }
}

/// Emits the loop nests performing the copy to the designated location in the
/// beginning of the region, and from the designated location immediately before
/// the terminator of the first block of the region. The region is expected to
/// have one block. This boils down to the following structure
///
///   ^bb(...):
///     <loop-bound-computation>
///     for %arg0 = ... to ... step ... {
///       ...
///         for %argN = <thread-id-x> to ... step <block-dim-x> {
///           %0 = load %from[%arg0, ..., %argN]
///           store %0, %to[%arg0, ..., %argN]
///         }
///       ...
///     }
///     gpu.barrier
///     <... original body ...>
///     gpu.barrier
///     for %arg0 = ... to ... step ... {
///       ...
///         for %argN = <thread-id-x> to ... step <block-dim-x> {
///           %1 = load %to[%arg0, ..., %argN]
///           store %1, %from[%arg0, ..., %argN]
///         }
///       ...
///     }
///
/// Inserts the barriers unconditionally since different threads may be copying
/// values and reading them. An analysis would be required to eliminate barriers
/// in case where value is only used by the thread that copies it. Both copies
/// are inserted unconditionally, an analysis would be required to only copy
/// live-in and live-out values when necessary. This copies the entire memref
/// pointed to by "from". In case a smaller block would be sufficient, the
/// caller can create a subview of the memref and promote it instead.
static void insertCopies(Region &region, Location loc, Value from, Value to) {
  auto fromType = from.getType().cast<MemRefType>();
  auto toType = to.getType().cast<MemRefType>();
  (void)fromType;
  (void)toType;
  assert(fromType.getShape() == toType.getShape());
  assert(fromType.getRank() != 0);
  // assert(llvm::hasSingleElement(region) &&
        //  "unstructured control flow not supported");

  auto b = ImplicitLocOpBuilder::atBlockBegin(loc, &region.front());
  insertCopyLoops(b, from, to);
  b.create<gpu::BarrierOp>();

  b.setInsertionPoint(&region.front().back());
  b.create<gpu::BarrierOp>();
  insertCopyLoops(b, to, from);
}

namespace {
struct FastMemCopyPass : public FastMemCopyPassBase<FastMemCopyPass> {
    
    void runOnFunction() override;
    LogicalResult runOnBlock(Block *block, DenseSet<Operation *> &copyNests);
};

/// Generate copies for this block. The block is partitioned into separate
/// ranges: each range is either a sequence of one or more operations starting
/// and ending with an affine load or store op, or just an affine.forop (which
/// could have other affine for op's nested within).
LogicalResult
FastMemCopyPass::runOnBlock(Block *block,
                                DenseSet<Operation *> &copyNests) {
  if (block->empty())
    return success();

  uint64_t fastMemCapacityBytes =
      fastMemoryCapacity != std::numeric_limits<uint64_t>::max()
          ? fastMemoryCapacity * 1024
          : fastMemoryCapacity;
  AffineCopyOptions copyOptions = {/*generateDMA=*/true, slowMemorySpace,
                                   fastMemorySpace, 0,
                                   fastMemCapacityBytes};

  // Every affine.forop in the block starts and ends a block range for copying;
  // in addition, a contiguous sequence of operations starting with a
  // load/store op but not including any copy nests themselves is also
  // identified as a copy block range. Straightline code (a contiguous chunk of
  // operations excluding AffineForOp's) are always assumed to not exhaust
  // memory. As a result, this approach is conservative in some cases at the
  // moment; we do a check later and report an error with location info.
  // TODO: An 'affine.if' operation is being treated similar to an
  // operation. 'affine.if''s could have 'affine.for's in them;
  // treat them separately.

  // Get to the first load, store, or for op (that is not a copy nest itself).
  auto curBegin =
      std::find_if(block->begin(), block->end(), [&](Operation &op) {
        return isa<AffineLoadOp, AffineStoreOp, AffineForOp>(op) &&
               copyNests.count(&op) == 0;
      });

  // Create [begin, end) ranges.
  auto it = curBegin;
  while (it != block->end()) {
    AffineForOp forOp;
    // If you hit a non-copy for loop, we will split there.
    if ((forOp = dyn_cast<AffineForOp>(&*it)) && copyNests.count(forOp) == 0) {
      // Perform the copying up unti this 'for' op first.
      affineDataCopyGenerate(/*begin=*/curBegin, /*end=*/it, copyOptions,
                             /*filterMemRef=*/llvm::None, copyNests);

      // Returns true if the footprint is known to exceed capacity.
    //   auto exceedsCapacity = [&](AffineForOp forOp) {
    //     Optional<int64_t> footprint =
    //         getMemoryFootprintBytes(forOp,
    //                                 /*memorySpace=*/0);
    //     return (footprint.hasValue() &&
    //             static_cast<uint64_t>(footprint.getValue()) >
    //                 fastMemCapacityBytes);
    //   };

      // If the memory footprint of the 'affine.for' loop is higher than fast
      // memory capacity (when provided), we recurse to copy at an inner level
      // until we find a depth at which footprint fits in fast mem capacity. If
      // the footprint can't be calculated, we assume for now it fits. Recurse
      // inside if footprint for 'forOp' exceeds capacity, or when
      // skipNonUnitStrideLoops is set and the step size is not one.
      //bool recurseInner = skipNonUnitStrideLoops ? forOp.getStep() != 1
      //                                           : exceedsCapacity(forOp);
      bool recurseInner = false; //exceedsCapacity(forOp);
      if (recurseInner) {
        // We'll recurse and do the copies at an inner level for 'forInst'.
        // Recurse onto the body of this loop.
        (void)runOnBlock(forOp.getBody(), copyNests);
      } else {
        // We have enough capacity, i.e., copies will be computed for the
        // portion of the block until 'it', and for 'it', which is 'forOp'. Note
        // that for the latter, the copies are placed just before this loop (for
        // incoming copies) and right after (for outgoing ones).

        // Inner loop copies have their own scope - we don't thus update
        // consumed capacity. The footprint check above guarantees this inner
        // loop's footprint fits.
        affineDataCopyGenerate(/*begin=*/it, /*end=*/std::next(it), copyOptions,
                               /*filterMemRef=*/llvm::None, copyNests);
      }
      // Get to the next load or store op after 'forOp'.
      curBegin = std::find_if(std::next(it), block->end(), [&](Operation &op) {
        return isa<AffineLoadOp, AffineStoreOp, AffineForOp>(op) &&
               copyNests.count(&op) == 0;
      });
      it = curBegin;
    } else {
      assert(copyNests.count(&*it) == 0 &&
             "all copy nests generated should have been skipped above");
      // We simply include this op in the current range and continue for more.
      ++it;
    }
  }

  // Generate the copy for the final block range.
  if (curBegin != block->end()) {
    // Can't be a terminator because it would have been skipped above.
    assert(!curBegin->hasTrait<OpTrait::IsTerminator>() &&
           "can't be a terminator");
    // Exclude the affine.yield - hence, the std::prev.
    affineDataCopyGenerate(/*begin=*/curBegin, /*end=*/std::prev(block->end()),
                           copyOptions, /*filterMemRef=*/llvm::None, copyNests);
  }

  return success();
}


// for sw: ... --> inner_tiling (considering ldm) 
//             --> generate dma copy 
//             --> inner_tiling (considering cache)
void FastMemCopyPass::runOnFunction() {

    FuncOp f = getFunction();
    OpBuilder topBuilder(f.getBody());
    // zeroIndex = topBuilder.create<ConstantIndexOp>(f.getLoc(), 0);

    // Nests that are copy-in's or copy-out's; the root AffineForOps of those
    // nests are stored herein.
    DenseSet<Operation *> copyNests;

    // Clear recorded copy nests.
    copyNests.clear();

    f.walk<WalkOrder::PreOrder>([&](AffineForOp loop) {
            if (loop->hasAttr("thread_inner_loop")) {
                (void)runOnBlock(&loop.getLoopBody().front(), copyNests);
            }
        });

    // Promote any single iteration loops in the copy nests and collect
    // load/stores to simplify.
    SmallVector<Operation *, 4> copyOps;
    for (Operation *nest : copyNests) {
        // With a post order walk, the erasure of loops does not affect
        // continuation of the walk or the collection of load/store ops.
        nest->walk([&](Operation *op) {
        if (auto forOp = dyn_cast<AffineForOp>(op))
            (void)promoteIfSingleIteration(forOp);
        else if (isa<AffineLoadOp, AffineStoreOp>(op))
            copyOps.push_back(op);
        });
    }
    // Promoting single iteration loops could lead to simplification of
    // contained load's/store's, and the latter could anyway also be
    // canonicalized.
    RewritePatternSet patterns(&getContext());
    AffineLoadOp::getCanonicalizationPatterns(patterns, &getContext());
    AffineStoreOp::getCanonicalizationPatterns(patterns, &getContext());
    FrozenRewritePatternSet frozenPatterns(std::move(patterns));
    (void)applyOpPatternsAndFold(copyOps, frozenPatterns, /*strict=*/true);

    // tile innner loops again
    std::vector<AffineForOp> orig_inner_loops;
    f.walk<WalkOrder::PreOrder>([&](AffineForOp inner_loop) {
            if (inner_loop->hasAttr("inner_tile")) {
                orig_inner_loops.push_back(inner_loop);
            }
        });
    
    if (inner_tile.size() > 0 && orig_inner_loops.size() > 0) {
        (void)applyAffineInnerTiling(topBuilder, inner_tile, orig_inner_loops);
    }
}
} // namespace

std::unique_ptr<Pass> mlir::createFastMemCopyPass() {
    return std::make_unique<FastMemCopyPass>();
}

//============================================================================//
// UH memory mapping pass
//============================================================================//
struct tile_state {
    // unsigned dimension;
    // map of uh level to outer loop for this dimension
    DenseMap<StringRef, AffineForOp> outerLoops;
    DenseMap<StringRef, unsigned> outerLoopSizes;
    AffineForOp mainLoop;
    unsigned num_tile;
};

void getTileState(FuncOp f, unsigned dim, tile_state& state, StringRef hw) {
    
    StringRef inner_dim = hw == "gpu" ? "dim_block" : "dim_cpe";
    f.walk<WalkOrder::PreOrder>([&](AffineForOp loop) {
        if (loop->hasAttr("dim") &&
            loop->getAttr("dim").cast<IntegerAttr>().getInt() == dim) {
            StringRef parallelTag = 
                loop->getAttr("parallelTag").cast<StringAttr>().getValue();
            state.outerLoops[parallelTag] = loop;

            Optional<uint64_t> mayBeConstantCount = getConstantTripCount(loop);
            assert(mayBeConstantCount && "assume the loop being constant");
            state.outerLoopSizes[parallelTag] = mayBeConstantCount.getValue();
        }
        if (loop->hasAttr("thread_loop") && 
            loop->getAttr(inner_dim).cast<IntegerAttr>().getInt() == dim) {
            Optional<uint64_t> mayBeConstantCount = getConstantTripCount(loop);
            assert(mayBeConstantCount && "assume the loop being constant");
            state.num_tile = mayBeConstantCount.getValue();
            state.mainLoop = loop;
        }
    });
}

// static LogicalResult replaceMemRefUses(Value oldMemRef, Value newMemRef, AffineMap indexRemap, 
//         ArrayRef<Value> extraOperands, ArrayRef<Value> extraIndices, 
//         Operation *domInstFilter, Operation *postDomInstFilter) {
//     unsigned newMemRefRank = newMemRef.getType().cast<MemRefType>().getRank();
//     unsigned oldMemRefRank = oldMemRef.getType().cast<MemRefType>().getRank();
//     if (indexRemap) {
//         assert(indexRemap.getNumInputs() == oldMemRefRank + extraOperands.size());
//         assert(indexRemap.getNumResults() + extraIndices.size() == newMemRefRank);
//     }
//     // Assert same elemental type.
//     assert(oldMemRef.getType().cast<MemRefType>().getElementType() ==
//             newMemRef.getType().cast<MemRefType>().getElementType());
    
//     DenseSet<Operation*> opsToReplace;
//     for (auto *op : oldMemRef.getUsers()) {

//     }
// }

void insertDataCopyLoops_single(OpBuilder builder, AffineForOp bodyLoop, Value slowMemref, 
        unsigned num_dim, unsigned halo, UnifiedHardware* uh, bool isInput,
        MemRefType fastMemRefType,
        std::vector<tile_state>& tile_states, std::vector<unsigned>& inner_tile_size) {
    auto loc = bodyLoop.getLoc();

    builder.setInsertionPointToStart(bodyLoop.getBody(0));
    Value fastMemref = 
        builder.create<memref::AllocOp>(loc, fastMemRefType).getResult();
    gpu::BarrierOp barrier;
    if (isInput == false) {
        builder = OpBuilder::atBlockTerminator(bodyLoop.getBody());
        barrier = builder.create<gpu::BarrierOp>(loc);
    }

    Operation *domInstFilter;
    Operation *postDomInstFilter;

    if (uh->name == "gpu") {

        SmallVector<Value, 4> memIndices;
        SmallVector<AffineExpr, 6> memOffsetExprs;
        SmallVector<Value, 6> memOffsetOperands;
        AffineForOp topCopyLoop;
    
        for (unsigned i = 0; i < num_dim; i ++) {
            AffineMap lbMap = AffineMap::getMultiDimIdentityMap(1, builder.getContext());
    
            // ub = tile_size_x * blockSize_x + 2 * Halo
            unsigned blockSize = tile_states[i].outerLoopSizes["block"];
            unsigned ubVal = inner_tile_size[i] * blockSize + 2 * halo;
            AffineMap ubMap = AffineMap::getConstantMap(ubVal, builder.getContext());
            SmallVector<Value, 1> lbOperands{tile_states[i].outerLoops["block"].getInductionVar()};
            SmallVector<Value, 0> ubOperands;
            AffineForOp copyLoop = builder.create<AffineForOp>(loc, 
                lbOperands, lbMap,
                ubOperands, ubMap, /*step=*/blockSize
                );
            if (i == 0) {
                topCopyLoop = copyLoop;
            }
            // indices for fast mem
            memIndices.push_back(copyLoop.getInductionVar());
            // int64_t domainLb = tile_states[i].mainLoop
                            // ->getAttr("domain_lower_bound").cast<IntegerAttr>().getInt();
            // for global mem
            AffineExpr offsetExpr = builder.getAffineDimExpr(3 * i) // copy loop iv
                            + builder.getAffineDimExpr(3 * i + 1)   // main loop iv
                            - builder.getAffineDimExpr(3 * i + 2)   // threadIdx
                            - halo;
            memOffsetExprs.push_back(offsetExpr);
            memOffsetOperands.push_back(copyLoop.getInductionVar());
            memOffsetOperands.push_back(tile_states[i].mainLoop.getInductionVar());
            memOffsetOperands.push_back(tile_states[i].outerLoops["block"].getInductionVar());

            builder.setInsertionPointToStart(copyLoop.getBody(0));
        }
    
        if (isInput) {
            AffineMap slowMemMap = AffineMap::get(3 * num_dim, 0, memOffsetExprs, builder.getContext());
            Value load = builder.create<AffineLoadOp>(loc, slowMemref, slowMemMap, memOffsetOperands);
            builder.create<AffineStoreOp>(loc, load, fastMemref, memIndices);
            builder.setInsertionPointAfter(topCopyLoop.getOperation());
            barrier = builder.create<gpu::BarrierOp>(loc);
            domInstFilter = barrier.getOperation();
            postDomInstFilter = bodyLoop.getBody()->getTerminator();
        }
        else {
            AffineMap slowMemMap = AffineMap::get(3 * num_dim, 0, memOffsetExprs, builder.getContext());
            Value load = builder.create<AffineLoadOp>(loc, fastMemref, memIndices);
            
            builder.create<AffineStoreOp>(loc, load, slowMemref, slowMemMap, memOffsetOperands);
            domInstFilter = &*bodyLoop.getBody(0)->begin();
            postDomInstFilter = barrier.getOperation();
        }
    }


    SmallVector<AffineExpr, 3> remapExprs;
    SmallVector<Value, 3> extraOperands;
    for (unsigned i = 0; i < num_dim; i ++) {
        AffineExpr offset = builder.getAffineDimExpr(i * 2) 
                        - builder.getAffineDimExpr(i * 2 + 1)
                        - halo; // offset
        AffineExpr dimExpr = builder.getAffineDimExpr(num_dim * 2 + i); // oldMemRefOperands
        remapExprs.push_back(dimExpr - offset); // for inputMemref
        extraOperands.push_back(tile_states[i].mainLoop.getInductionVar()); // offset operands
        extraOperands.push_back(tile_states[i].outerLoops["block"].getInductionVar()); // offset operands
    }
    // order of remap inputs: extraOperands + oldMemRefOperands + symbolOperands(empty here)
    AffineMap indexRemap = AffineMap::get(num_dim * 3, 0, remapExprs, builder.getContext());
    (void)replaceAllMemRefUsesWith(slowMemref, fastMemref,
                            /*extraIndices=*/{}, indexRemap,
                            /*extraOperands=*/extraOperands,
                            /*symbolOperands=*/{},
                            /*domInstFilter=*/domInstFilter,
                            /*postDomInstFilter=*/postDomInstFilter);
    
}

// insert fast memref alloc op 
// attach information for generating sw dma memcpy
// insert barrier op to mark insertion point of sw dma op
void insertDataCopy_swdma(OpBuilder builder, AffineForOp bodyLoop, Value slowMemref, 
        unsigned num_dim, unsigned halo, bool isInput, MemRefType fastMemRefType,
        std::vector<tile_state>& tile_states, std::vector<unsigned>& inner_tile_size) {
    auto loc = bodyLoop.getLoc();
    auto integerTy = IntegerType::get(bodyLoop->getContext(), 64);

    // input buffer
    
    builder.setInsertionPointToStart(bodyLoop.getBody(0));
    memref::AllocOp fastMemrefAlloc = 
            builder.create<memref::AllocOp>(loc, fastMemRefType);
    Value fastMemref = fastMemrefAlloc.getResult();

    if (isInput) {
        fastMemrefAlloc->setAttr("readOrWrite", 
                    StringAttr::get(bodyLoop->getContext(), "read"));
        fastMemrefAlloc->setAttr("halo", IntegerAttr::get(integerTy, halo));
    } else {
        fastMemrefAlloc->setAttr("readOrWrite", 
                    StringAttr::get(bodyLoop->getContext(), "write"));
    }
    int64_t zDim = (fastMemRefType.getRank() == 3) ? fastMemRefType.getShape()[0] : 1;
    fastMemrefAlloc->setAttr("swdma_zDim", IntegerAttr::get(integerTy, zDim));
    int64_t cnt = 1;
    unsigned iter = 0;
    if (fastMemRefType.getRank() == 3) {
        iter = 1;
    }
    for (; iter < fastMemRefType.getRank(); iter ++) {
        cnt *= fastMemRefType.getShape()[iter];
    }
    fastMemrefAlloc->setAttr("swdma_cnt", IntegerAttr::get(integerTy, cnt));
    int64_t bsize = fastMemRefType.getShape().back();
    fastMemrefAlloc->setAttr("swdma_bsize", IntegerAttr::get(integerTy, bsize));
    int64_t stride = slowMemref.getType().dyn_cast<MemRefType>().getShape().back() - bsize;
    fastMemrefAlloc->setAttr("swdma_stride", IntegerAttr::get(integerTy, stride));

    SmallVector<Value, 3> indexArray;
    if (!isInput) {
        builder = OpBuilder::atBlockTerminator(bodyLoop.getBody());
    }
    // indexArray
    for (unsigned i = 0; i < fastMemRefType.getRank(); i ++) {
        AffineExpr offset = builder.getAffineDimExpr(0) - halo; // offset 
        AffineMap offsetMap = AffineMap::get(1, 0, offset, builder.getContext()); // offsetMap
        SmallVector<Value, 1> offsetOperands{tile_states[i].mainLoop.getInductionVar()};
        Value idx = builder.create<AffineApplyOp>(loc, offsetMap, offsetOperands);
        indexArray.push_back(idx);
    }
        
    Operation *domInstFilter;   // start point for updating memref index
    Operation *postDomInstFilter;   // end point for updating memref index
    if (isInput) {
            /// illegal copy op, it should be processed when lowering to sw
            // auto cpyOp = builder.create<memref::CopyOp>(loc, /*src=*/fastMemref, /*tgt*/fastMemref);
            /// sw memcpy op require sw::MemRef as operands
            // auto cpyOp = builder.create<sw::MemcpyToLDMOp>(loc, slowMemref, fastMemref, indexArray, 
            //             builder.getI64IntegerAttr(zDim), 
            //             builder.getI64IntegerAttr(cnt), 
            //             builder.getI64IntegerAttr(stride), 
            //             builder.getI64IntegerAttr(bsize));
            auto barrier = builder.create<gpu::BarrierOp>(loc); // a tag for create sw memcpy
            barrier->setAttr("cache", StringAttr::get(bodyLoop->getContext(), "read"));
            barrier->setAttr("readOrWrite", 
                        StringAttr::get(bodyLoop->getContext(), "read"));
            domInstFilter = barrier.getOperation();
            // domInstFilter = std::next(cpyOp.getOperation());
            postDomInstFilter = bodyLoop.getBody()->getTerminator();
    } else {
            auto barrier = builder.create<gpu::BarrierOp>(loc); // a tag for create sw memcpy
            barrier->setAttr("cache", StringAttr::get(bodyLoop->getContext(), "write"));
            barrier->setAttr("readOrWrite", 
                        StringAttr::get(bodyLoop->getContext(), "write"));
            /// illegal copy op, it should be processed when lowering to sw
            // auto cpyOp = builder.create<memref::CopyOp>(loc, /*src=*/fastMemref, /*tgt*/fastMemref);
            // auto cpyOp = builder.create<sw::MemcpyToMEMOp>(loc, fastMemref, slowMemref, indexArray, 
            //             builder.getI64IntegerAttr(zDim), 
            //             builder.getI64IntegerAttr(cnt), 
            //             builder.getI64IntegerAttr(stride), 
            //             builder.getI64IntegerAttr(bsize));
            domInstFilter = &*bodyLoop.getBody(0)->begin();
            // postDomInstFilter = std::prev(cpyOp.getOperation());
            postDomInstFilter = barrier.getOperation();
    }
    
    SmallVector<AffineExpr, 3> remapExprs;
    SmallVector<Value, 3> extraOperands;
    for (unsigned i = 0; i < num_dim; i ++) {
        AffineExpr offset = builder.getAffineDimExpr(i) - halo; // offset
        AffineExpr dimExpr = builder.getAffineDimExpr(num_dim + i); // oldMemRefOperands
        remapExprs.push_back(dimExpr - offset); // for inputMemref
        extraOperands.push_back(tile_states[i].mainLoop.getInductionVar()); // offset operands
    }
    // order of remap inputs: extraOperands + oldMemRefOperands + symbolOperands(empty here)
    AffineMap indexRemap = AffineMap::get(num_dim * 2, 0, remapExprs, builder.getContext());
    (void)replaceAllMemRefUsesWith(slowMemref, fastMemref,
                            /*extraIndices=*/{}, indexRemap,
                            /*extraOperands=*/extraOperands,
                            /*symbolOperands=*/{},
                            /*domInstFilter=*/domInstFilter,
                            /*postDomInstFilter=*/postDomInstFilter);
}

void insertDataCopyLoops(OpBuilder builder, AffineForOp bodyLoop, Value inputMemref, 
        Value outputMemref, unsigned num_dim, unsigned halo, UnifiedHardware* uh,
        MemRefType fastInputMemRefType, MemRefType fastOutputMemRefType, 
        std::vector<tile_state>& tile_states, std::vector<unsigned>& inner_tile_size) {
    auto loc = bodyLoop.getLoc();

    builder.setInsertionPointToStart(bodyLoop.getBody(0));
    Value fastInput = 
        builder.create<memref::AllocOp>(loc, fastInputMemRefType).getResult();
    Value fastOutput = 
        builder.create<memref::AllocOp>(loc, fastOutputMemRefType).getResult();
    
    Operation *domInstFilter;
    Operation *postDomInstFilter;

    if (uh->name == "gpu") {

        SmallVector<Value, 4> memIndices;
        SmallVector<AffineExpr, 6> memOffsetExprs;
        SmallVector<Value, 6> memOffsetOperands;
        AffineForOp topCopyLoop;
    
        for (unsigned i = 0; i < num_dim; i ++) {
            AffineMap lbMap = AffineMap::getMultiDimIdentityMap(1, builder.getContext());
    
            // ub = tile_size_x * blockSize_x + 2 * Halo
            unsigned blockSize = tile_states[i].outerLoopSizes["block"];
            unsigned ubVal = inner_tile_size[i] * blockSize + 2 * halo;
            AffineMap ubMap = AffineMap::getConstantMap(ubVal, builder.getContext());
            SmallVector<Value, 1> lbOperands{tile_states[i].outerLoops["block"].getInductionVar()};
            SmallVector<Value, 0> ubOperands;
            AffineForOp copyLoop = builder.create<AffineForOp>(loc, 
                lbOperands, lbMap,
                ubOperands, ubMap, /*step=*/blockSize
                );
            if (i == 0) {
                topCopyLoop = copyLoop;
            }
            // indices for fast mem
            memIndices.push_back(copyLoop.getInductionVar());
            // for global mem
            AffineExpr offsetExpr = builder.getAffineDimExpr(3 * i)
                            + builder.getAffineDimExpr(3 * i + 1)
                            - builder.getAffineDimExpr(3 * i + 2)
                            - halo;
            memOffsetExprs.push_back(offsetExpr);
            memOffsetOperands.push_back(copyLoop.getInductionVar());
            memOffsetOperands.push_back(tile_states[i].mainLoop.getInductionVar());
            memOffsetOperands.push_back(tile_states[i].outerLoops["block"].getInductionVar());

            builder.setInsertionPointToStart(copyLoop.getBody(0));
        }
    
        AffineMap inputMemMap = AffineMap::get(3 * num_dim, 0, memOffsetExprs, builder.getContext());
        Value load = builder.create<AffineLoadOp>(loc, inputMemref, inputMemMap, memOffsetOperands);
        builder.create<AffineStoreOp>(loc, load, fastInput, memIndices);
        builder.setInsertionPointAfter(topCopyLoop.getOperation());
        auto barrier = builder.create<gpu::BarrierOp>(loc);
        domInstFilter = barrier.getOperation();
    }

    // store
    builder = OpBuilder::atBlockTerminator(bodyLoop.getBody());
    
    if (uh->name == "gpu") {
        auto barrier = builder.create<gpu::BarrierOp>(loc);
        postDomInstFilter = barrier.getOperation();
        SmallVector<Value, 4> memIndices;
        SmallVector<AffineExpr, 6> memOffsetExprs;
        SmallVector<Value, 6> memOffsetOperands;

        for (unsigned i = 0; i < num_dim; i ++) {
            AffineMap lbMap = AffineMap::getMultiDimIdentityMap(1, builder.getContext());
    
            // ub = tile_size_x * blockSize_x
            unsigned blockSize = tile_states[i].outerLoopSizes["block"];
            unsigned ubVal = inner_tile_size[i] * blockSize;
            AffineMap ubMap = AffineMap::getConstantMap(ubVal, builder.getContext());
            SmallVector<Value, 1> lbOperands{tile_states[i].outerLoops["block"].getInductionVar()};
            SmallVector<Value, 0> ubOperands;
            AffineForOp copyLoop = builder.create<AffineForOp>(loc, 
                lbOperands, lbMap,
                ubOperands, ubMap, /*step=*/blockSize
                );
            
            // indices for fast mem
            memIndices.push_back(copyLoop.getInductionVar());
            // for global mem
            AffineExpr offsetExpr = builder.getAffineDimExpr(3 * i)
                            + builder.getAffineDimExpr(3 * i + 1)
                            - builder.getAffineDimExpr(3 * i + 2);
            memOffsetExprs.push_back(offsetExpr);
            memOffsetOperands.push_back(copyLoop.getInductionVar());
            memOffsetOperands.push_back(tile_states[i].mainLoop.getInductionVar());
            memOffsetOperands.push_back(tile_states[i].outerLoops["block"].getInductionVar());
            builder.setInsertionPointToStart(copyLoop.getBody(0));
        }
        AffineMap outputMemMap = AffineMap::get(3 * num_dim, 0, memOffsetExprs, builder.getContext());
        Value load = builder.create<AffineLoadOp>(loc, fastOutput, memIndices);
            
        builder.create<AffineStoreOp>(loc, load, outputMemref, outputMemMap, memOffsetOperands);
    }
    
    SmallVector<AffineExpr, 3> remapExprs;
    SmallVector<Value, 3> extraOperands;
    for (unsigned i = 0; i < num_dim; i ++) {
        AffineExpr offset = builder.getAffineDimExpr(i * 2) 
                        - builder.getAffineDimExpr(i * 2 + 1); // offset
        AffineExpr dimExpr = builder.getAffineDimExpr(num_dim * 2 + i); // oldMemRefOperands
        remapExprs.push_back(dimExpr - offset + halo); // for inputMemref
        extraOperands.push_back(tile_states[i].mainLoop.getInductionVar()); // offset operands
        extraOperands.push_back(tile_states[i].outerLoops["block"].getInductionVar()); // offset operands
    }
    // order of remap inputs: extraOperands + oldMemRefOperands + symbolOperands(empty here)
    AffineMap indexRemap = AffineMap::get(num_dim * 3, 0, remapExprs, builder.getContext());
    (void)replaceAllMemRefUsesWith(inputMemref, fastInput,
                            /*extraIndices=*/{}, indexRemap,
                            /*extraOperands=*/extraOperands,
                            /*symbolOperands=*/{},
                            /*domInstFilter=*/domInstFilter,
                            /*postDomInstFilter=*/postDomInstFilter);
    remapExprs.clear();
    remapExprs.reserve(num_dim);
    for (unsigned i = 0; i < num_dim; i ++) {
        AffineExpr offset = builder.getAffineDimExpr(i * 2)
                        - builder.getAffineDimExpr(i * 2 + 1); // offset
        AffineExpr dimExpr = builder.getAffineDimExpr(num_dim * 2 + i); // oldMemRefOperands
        remapExprs.push_back(dimExpr - offset);
    }
    indexRemap = AffineMap::get(num_dim * 3, 0, remapExprs, builder.getContext());
    (void)replaceAllMemRefUsesWith(outputMemref, fastOutput,
                            /*extraIndices=*/{}, indexRemap,
                            /*extraOperands=*/extraOperands,
                            /*symbolOperands=*/{},
                            /*domInstFilter=*/domInstFilter,
                            /*postDomInstFilter=*/postDomInstFilter);
}

struct UHMemMappingPass : public UHMemMappingPassBase<UHMemMappingPass> {
    
    void runOnFunction() override;
    // LogicalResult runOnBlock(Block *block, DenseSet<Operation *> &copyNests);
};

// 1. get memref list
// 2. determine mem space for each memref in each uh level
// 3. insert data copy loops
void UHMemMappingPass::runOnFunction() {
    FuncOp f = getFunction();
    OpBuilder builder(f.getBody());

    if (f->hasAttr("hardware") == false) return;
    StringRef hw = f->getAttr("hardware").cast<StringAttr>().getValue();

    SmallVector<Value, 2> memList;
    for (unsigned i = 0, e = f.getNumArguments(); i < e; ++i) {
        Value arg = f.getArgument(i);
        auto type = arg.getType().dyn_cast<MemRefType>();
        if (type && type.hasStaticShape()) {
            memList.push_back(arg);
        }
    }
    // determine mem space

    std::vector<unsigned> inner_tile_size = inner_tile; // from option

    std::vector<AffineForOp> loops;
    f.walk<WalkOrder::PreOrder>([&](AffineForOp loop) {
        loops.push_back(loop);
    });

    if (loops.size() > 0) {
        if (failed(applyAffineInnerTiling(builder, inner_tile_size, loops))) {
            signalPassFailure();
        }
    }

    unsigned halo = 1; // todo: inference from input dsl/mlir
    // find lower bound
    f.walk<WalkOrder::PreOrder>([&](AffineForOp loop) {
        if (loop->hasAttr("thread_inner_loop")) {
            halo = loop->getAttr("domain_lower_bound").cast<IntegerAttr>().getInt();
        }
    });

    assert(memList.size() == 2 &&
            "there should be two memref, one for stencil input, one for output");
    Value input = memList[0]; // todo: automatically recognize input and output memref
    Value output = memList[1];

    unsigned num_dimension = input.getType().dyn_cast<MemRefType>().getRank();

    SmallVector<int64_t, 3> fastInputMemRefShape;
    SmallVector<int64_t, 3> fastOutputMemRefShape;
    StringRef memLevel = "block"; // shared memory level // todo: where to get 
    std::vector<tile_state> tile_states;
    tile_states.resize(num_dimension);
    for (unsigned i = 0; i < num_dimension; i ++) {
        getTileState(f, i, tile_states[i], hw);
        if (hw == "gpu") {
            fastInputMemRefShape.push_back(
                inner_tile_size[i] * tile_states[i].outerLoopSizes[memLevel] + 2 * halo);
            fastOutputMemRefShape.push_back(
                inner_tile_size[i] * tile_states[i].outerLoopSizes[memLevel]);
        } else {
            fastInputMemRefShape.push_back(inner_tile_size[i] + 2 * halo);
            fastOutputMemRefShape.push_back(inner_tile_size[i]);
        }
    }

    MemRefType fastInputMemRefType = MemRefType::get(
        fastInputMemRefShape,
        input.getType().dyn_cast<MemRefType>().getElementType(),
        builder.getMultiDimIdentityMap(num_dimension), // layout
        /*memSpace=*/3u
    );
    MemRefType fastOutputMemRefType = MemRefType::get(
        fastOutputMemRefShape,
        output.getType().dyn_cast<MemRefType>().getElementType(),
        builder.getMultiDimIdentityMap(num_dimension), // layout
        /*memSpace=*/3u
    );

    // find the region to insert copy loops
    f.walk<WalkOrder::PreOrder>([&](AffineForOp loop) {
        if (loop->hasAttr("thread_inner_loop")) {
            if (hw == "gpu") {
                UnifiedHardware* uh = UH::_gpu;
                // (void)insertDataCopyLoops(builder, loop, input, output, 
                //     num_dimension, halo, uh, fastInputMemRefType,
                //     fastOutputMemRefType, tile_states, inner_tile_size);
                // input
                insertDataCopyLoops_single(builder, loop, input, num_dimension,
                        halo, uh, /*isInput=*/true, fastInputMemRefType, tile_states,
                        inner_tile_size);
                if (input_only == false) {
                    insertDataCopyLoops_single(builder, loop, output, num_dimension,
                        0, uh, false, fastOutputMemRefType, tile_states,
                        inner_tile_size);
                }
            } else {
                // input
                insertDataCopy_swdma(builder, loop, input, num_dimension,
                        halo, /*isInput=*/true, fastInputMemRefType, tile_states,
                        inner_tile_size);
                if (input_only == false) {
                    insertDataCopy_swdma(builder, loop, output, num_dimension,
                            0, false, fastOutputMemRefType, tile_states,
                            inner_tile_size);
                }
            }
        }
    });

    if (tile_by_cache.size()) {
        std::vector<unsigned> tile_cache_sizes = tile_by_cache;
        std::vector<AffineForOp> inner_loops;
        f.walk<WalkOrder::PreOrder>([&](AffineForOp loop) {
            if (loop->hasAttr("inner_tile")) {
                inner_loops.push_back(loop);
            } 
        });
        if (failed(applyAffineInnerTiling(builder, tile_cache_sizes, inner_loops))) {
            signalPassFailure();
        }
    }
}

std::unique_ptr<Pass> mlir::createUHMemMappingPass() {
    return std::make_unique<UHMemMappingPass>();
}
