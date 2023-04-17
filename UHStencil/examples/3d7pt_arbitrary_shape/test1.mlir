module  {
  func @stencil_3d7pt(%arg0: memref<10x10x10xf64>, %arg1: memref<10x10x10xf64>) attributes {llvm.emit_c_interface} {
    %0 = memref.alloc() : memref<10x10x10xf64>
    %c0 = constant 0 : index
    %c8 = constant 8 : index
    %1 = subi %c8, %c0 : index
    %c1 = constant 1 : index
    %c0_0 = constant 0 : index
    %c8_1 = constant 8 : index
    %2 = subi %c8_1, %c0_0 : index
    %c1_2 = constant 1 : index
    %c1_3 = constant 1 : index
    gpu.launch blocks(%arg2, %arg3, %arg4) in (%arg8 = %1, %arg9 = %c1_3, %arg10 = %c1_3) threads(%arg5, %arg6, %arg7) in (%arg11 = %2, %arg12 = %c1_3, %arg13 = %c1_3) {
      %3 = addi %c0, %arg2 : index
      %4 = addi %c0_0, %arg5 : index
      affine.for %arg14 = 0 to 8 {
        %cst = constant 1.000000e-01 : f64
        %c2 = constant 2 : index
        %5 = addi %3, %c2 : index
        %6 = memref.load %arg0[%5, %4, %arg14] : memref<10x10x10xf64>
        %7 = mulf %cst, %6 : f64
        %cst_4 = constant 2.000000e-01 : f64
        %c1_5 = constant 1 : index
        %8 = addi %3, %c1_5 : index
        %9 = memref.load %arg0[%8, %4, %arg14] : memref<10x10x10xf64>
        %10 = mulf %cst_4, %9 : f64
        %11 = addf %7, %10 : f64
        %cst_6 = constant 3.000000e-01 : f64
        %12 = memref.load %arg0[%3, %4, %arg14] : memref<10x10x10xf64>
        %13 = mulf %cst_6, %12 : f64
        %14 = addf %11, %13 : f64
        %cst_7 = constant 4.000000e-01 : f64
        %c1_8 = constant 1 : index
        %15 = addi %arg14, %c1_8 : index
        %16 = memref.load %arg0[%3, %4, %15] : memref<10x10x10xf64>
        %17 = mulf %cst_7, %16 : f64
        %18 = addf %14, %17 : f64
        %cst_9 = constant 5.000000e-01 : f64
        %c2_10 = constant 2 : index
        %19 = addi %arg14, %c2_10 : index
        %20 = memref.load %arg0[%3, %4, %19] : memref<10x10x10xf64>
        %21 = mulf %cst_9, %20 : f64
        %22 = addf %18, %21 : f64
        %cst_11 = constant 6.000000e-01 : f64
        %c1_12 = constant 1 : index
        %23 = addi %4, %c1_12 : index
        %24 = memref.load %arg0[%3, %23, %arg14] : memref<10x10x10xf64>
        %25 = mulf %cst_11, %24 : f64
        %26 = addf %22, %25 : f64
        %cst_13 = constant 0.69999999999999996 : f64
        %c2_14 = constant 2 : index
        %27 = addi %4, %c2_14 : index
        %28 = memref.load %arg0[%3, %27, %arg14] : memref<10x10x10xf64>
        %29 = mulf %cst_13, %28 : f64
        %30 = addf %26, %29 : f64
        memref.store %30, %arg1[%3, %4, %arg14] : memref<10x10x10xf64>
      }
      gpu.terminator
    }
    return
  }
  func @stencil_3d7pt_iteration(%arg0: memref<10x10x10xf64>, %arg1: memref<10x10x10xf64>) attributes {llvm.emit_c_interface} {
    %c0 = constant 0 : index
    %c10 = constant 10 : index
    %c1 = constant 1 : index
    br ^bb1(%c0 : index)
  ^bb1(%0: index):  // 2 preds: ^bb0, ^bb2
    %1 = cmpi slt, %0, %c10 : index
    cond_br %1, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    call @stencil_3d7pt(%arg0, %arg1) : (memref<10x10x10xf64>, memref<10x10x10xf64>) -> ()
    call @stencil_3d7pt(%arg1, %arg0) : (memref<10x10x10xf64>, memref<10x10x10xf64>) -> ()
    %2 = addi %0, %c1 : index
    br ^bb1(%2 : index)
  ^bb3:  // pred: ^bb1
    return
  }
}
