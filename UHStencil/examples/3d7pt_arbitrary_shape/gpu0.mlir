module  {
  func @stencil_3d7pt(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) attributes {llvm.emit_c_interface} {
    %c256 = constant 256 : index
    %c0 = constant 0 : index
    %c2322 = constant 2322 : index
    %c66564 = constant 66564 : index
    %c774 = constant 774 : index
    %c0_0 = constant 0 : index
    %c0_1 = constant 0 : index
    %0 = memref.alloc() : memref<258x258x258xf64>
    %c0_2 = constant 0 : index
    %c256_3 = constant 256 : index
    %1 = subi %c256_3, %c0_2 : index
    %c1 = constant 1 : index
    %c0_4 = constant 0 : index
    %c256_5 = constant 256 : index
    %2 = subi %c256_5, %c0_4 : index
    %c1_6 = constant 1 : index
    %c1_7 = constant 1 : index
    gpu.launch blocks(%arg2, %arg3, %arg4) in (%arg8 = %1, %arg9 = %c1_7, %arg10 = %c1_7) threads(%arg5, %arg6, %arg7) in (%arg11 = %2, %arg12 = %c1_7, %arg13 = %c1_7) {
      %3 = addi %c0_2, %arg2 : index
      %4 = addi %c0_4, %arg5 : index
      %5 = memref.alloc() : memref<3x3x258xf64, 3>
      %6 = memref.alloc() : memref<1xi32>
      %c0_8 = constant 0 : index
      memref.dma_start %arg0[%3, %4, %c0_8], %5[%c0_0, %c0_0, %c0_0], %c2322, %6[%c0_0], %c66564, %c774 : memref<258x258x258xf64>, memref<3x3x258xf64, 3>, memref<1xi32>
      memref.dma_wait %6[%c0_0], %c2322 : memref<1xi32>
      %7 = memref.alloc() : memref<1x1x256xf64, 3>
      %8 = memref.alloc() : memref<1xi32>
      affine.for %arg14 = 0 to 256 {
        %cst = constant 1.000000e-01 : f64
        %c2 = constant 2 : index
        %9 = addi %3, %c2 : index
        %c2_10 = constant 2 : index
        %c0_11 = constant 0 : index
        %10 = memref.load %5[%c2_10, %c0_11, %arg14] : memref<3x3x258xf64, 3>
        %11 = mulf %cst, %10 : f64
        %cst_12 = constant 2.000000e-01 : f64
        %c1_13 = constant 1 : index
        %12 = addi %3, %c1_13 : index
        %c1_14 = constant 1 : index
        %c0_15 = constant 0 : index
        %13 = memref.load %5[%c1_14, %c0_15, %arg14] : memref<3x3x258xf64, 3>
        %14 = mulf %cst_12, %13 : f64
        %15 = addf %11, %14 : f64
        %cst_16 = constant 3.000000e-01 : f64
        %c0_17 = constant 0 : index
        %c0_18 = constant 0 : index
        %16 = memref.load %5[%c0_17, %c0_18, %arg14] : memref<3x3x258xf64, 3>
        %17 = mulf %cst_16, %16 : f64
        %18 = addf %15, %17 : f64
        %cst_19 = constant 4.000000e-01 : f64
        %c1_20 = constant 1 : index
        %19 = addi %arg14, %c1_20 : index
        %c0_21 = constant 0 : index
        %c0_22 = constant 0 : index
        %c1_23 = constant 1 : index
        %20 = addi %arg14, %c1_23 : index
        %21 = memref.load %5[%c0_21, %c0_22, %20] : memref<3x3x258xf64, 3>
        %22 = mulf %cst_19, %21 : f64
        %23 = addf %18, %22 : f64
        %cst_24 = constant 5.000000e-01 : f64
        %c2_25 = constant 2 : index
        %24 = addi %arg14, %c2_25 : index
        %c0_26 = constant 0 : index
        %c0_27 = constant 0 : index
        %c2_28 = constant 2 : index
        %25 = addi %arg14, %c2_28 : index
        %26 = memref.load %5[%c0_26, %c0_27, %25] : memref<3x3x258xf64, 3>
        %27 = mulf %cst_24, %26 : f64
        %28 = addf %23, %27 : f64
        %cst_29 = constant 6.000000e-01 : f64
        %c1_30 = constant 1 : index
        %29 = addi %4, %c1_30 : index
        %c0_31 = constant 0 : index
        %c1_32 = constant 1 : index
        %30 = memref.load %5[%c0_31, %c1_32, %arg14] : memref<3x3x258xf64, 3>
        %31 = mulf %cst_29, %30 : f64
        %32 = addf %28, %31 : f64
        %cst_33 = constant 0.69999999999999996 : f64
        %c2_34 = constant 2 : index
        %33 = addi %4, %c2_34 : index
        %c0_35 = constant 0 : index
        %c2_36 = constant 2 : index
        %34 = memref.load %5[%c0_35, %c2_36, %arg14] : memref<3x3x258xf64, 3>
        %35 = mulf %cst_33, %34 : f64
        %36 = addf %32, %35 : f64
        %c0_37 = constant 0 : index
        %c0_38 = constant 0 : index
        memref.store %36, %7[%c0_37, %c0_38, %arg14] : memref<1x1x256xf64, 3>
      }
      %c0_9 = constant 0 : index
      memref.dma_start %7[%c0, %c0, %c0], %arg1[%3, %4, %c0_9], %c256, %8[%c0] : memref<1x1x256xf64, 3>, memref<258x258x258xf64>, memref<1xi32>
      memref.dma_wait %8[%c0], %c256 : memref<1xi32>
      memref.dealloc %8 : memref<1xi32>
      memref.dealloc %7 : memref<1x1x256xf64, 3>
      memref.dealloc %6 : memref<1xi32>
      memref.dealloc %5 : memref<3x3x258xf64, 3>
      gpu.terminator
    }
    return
  }
  func @stencil_3d7pt_iteration(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) attributes {llvm.emit_c_interface} {
    %c0 = constant 0 : index
    %c0_0 = constant 0 : index
    %c10 = constant 10 : index
    %c1 = constant 1 : index
    br ^bb1(%c0_0 : index)
  ^bb1(%0: index):  // 2 preds: ^bb0, ^bb2
    %1 = cmpi slt, %0, %c10 : index
    cond_br %1, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    call @stencil_3d7pt(%arg0, %arg1) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
    call @stencil_3d7pt(%arg1, %arg0) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
    %2 = addi %0, %c1 : index
    br ^bb1(%2 : index)
  ^bb3:  // pred: ^bb1
    return
  }
}
