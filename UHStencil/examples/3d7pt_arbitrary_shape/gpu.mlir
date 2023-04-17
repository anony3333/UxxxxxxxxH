module  {
  func @stencil_3d7pt(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) attributes {llvm.emit_c_interface} {
    %0 = memref.alloc() : memref<258x258x258xf64>
    %c0 = constant 0 : index
    %c256 = constant 256 : index
    %1 = subi %c256, %c0 : index
    %c1 = constant 1 : index
    %c0_0 = constant 0 : index
    %c256_1 = constant 256 : index
    %2 = subi %c256_1, %c0_0 : index
    %c1_2 = constant 1 : index
    %c0_3 = constant 0 : index
    %c256_4 = constant 256 : index
    %3 = subi %c256_4, %c0_3 : index
    %c1_5 = constant 1 : index
    %c1_6 = constant 1 : index
    gpu.launch blocks(%arg2, %arg3, %arg4) in (%arg8 = %1, %arg9 = %2, %arg10 = %c1_6) threads(%arg5, %arg6, %arg7) in (%arg11 = %3, %arg12 = %c1_6, %arg13 = %c1_6) {
      %4 = addi %c0, %arg2 : index
      %5 = addi %c0_0, %arg3 : index
      %6 = addi %c0_3, %arg5 : index
      %cst = constant 1.000000e-01 : f64
      %c2 = constant 2 : index
      %7 = addi %4, %c2 : index
      %8 = memref.load %arg0[%7, %5, %6] : memref<258x258x258xf64>
      %9 = mulf %cst, %8 : f64
      %cst_7 = constant 2.000000e-01 : f64
      %c1_8 = constant 1 : index
      %10 = addi %4, %c1_8 : index
      %11 = memref.load %arg0[%10, %5, %6] : memref<258x258x258xf64>
      %12 = mulf %cst_7, %11 : f64
      %13 = addf %9, %12 : f64
      %cst_9 = constant 3.000000e-01 : f64
      %14 = memref.load %arg0[%4, %5, %6] : memref<258x258x258xf64>
      %15 = mulf %cst_9, %14 : f64
      %16 = addf %13, %15 : f64
      %cst_10 = constant 4.000000e-01 : f64
      %c1_11 = constant 1 : index
      %17 = addi %6, %c1_11 : index
      %18 = memref.load %arg0[%4, %5, %17] : memref<258x258x258xf64>
      %19 = mulf %cst_10, %18 : f64
      %20 = addf %16, %19 : f64
      %cst_12 = constant 5.000000e-01 : f64
      %c2_13 = constant 2 : index
      %21 = addi %6, %c2_13 : index
      %22 = memref.load %arg0[%4, %5, %21] : memref<258x258x258xf64>
      %23 = mulf %cst_12, %22 : f64
      %24 = addf %20, %23 : f64
      %cst_14 = constant 6.000000e-01 : f64
      %c1_15 = constant 1 : index
      %25 = addi %5, %c1_15 : index
      %26 = memref.load %arg0[%4, %25, %6] : memref<258x258x258xf64>
      %27 = mulf %cst_14, %26 : f64
      %28 = addf %24, %27 : f64
      %cst_16 = constant 0.69999999999999996 : f64
      %c2_17 = constant 2 : index
      %29 = addi %5, %c2_17 : index
      %30 = memref.load %arg0[%4, %29, %6] : memref<258x258x258xf64>
      %31 = mulf %cst_16, %30 : f64
      %32 = addf %28, %31 : f64
      memref.store %32, %arg1[%4, %5, %6] : memref<258x258x258xf64>
      gpu.terminator
    }
    return
  }
  func @stencil_3d7pt_iteration(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) attributes {llvm.emit_c_interface} {
    %c0 = constant 0 : index
    %c10 = constant 10 : index
    %c1 = constant 1 : index
    br ^bb1(%c0 : index)
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
