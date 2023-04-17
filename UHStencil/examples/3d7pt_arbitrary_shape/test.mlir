module attributes {gpu.container_module}  {
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
    gpu.launch_func  @stencil_3d7pt_kernel::@stencil_3d7pt_kernel blocks in (%1, %2, %c1_6) threads in (%3, %c1_6, %c1_6) args(%arg0 : memref<258x258x258xf64>, %arg1 : memref<258x258x258xf64>)
    return
  }
  gpu.module @stencil_3d7pt_kernel {
    gpu.func @stencil_3d7pt_kernel(%arg0: memref<258x258x258xf64> {gpu.test_promote_workgroup}, %arg1: memref<258x258x258xf64>) workgroup(%buffer: memref<258xf64, 3>) attributes {gpu.kernel} {
      %0 = "gpu.block_id"() {dimension = "x"} : () -> index
      %1 = "gpu.block_id"() {dimension = "y"} : () -> index
      %2 = "gpu.block_id"() {dimension = "z"} : () -> index
      %3 = "gpu.thread_id"() {dimension = "x"} : () -> index
      %4 = "gpu.thread_id"() {dimension = "y"} : () -> index
      %5 = "gpu.thread_id"() {dimension = "z"} : () -> index
      %6 = "gpu.grid_dim"() {dimension = "x"} : () -> index
      %7 = "gpu.grid_dim"() {dimension = "y"} : () -> index
      %8 = "gpu.grid_dim"() {dimension = "z"} : () -> index
      %9 = "gpu.block_dim"() {dimension = "x"} : () -> index
      %10 = "gpu.block_dim"() {dimension = "y"} : () -> index
      %11 = "gpu.block_dim"() {dimension = "z"} : () -> index
      br ^bb1
    ^bb1:  // pred: ^bb0
      %c0 = constant 0 : index
      %c0_0 = constant 0 : index
      %c0_1 = constant 0 : index
      %12 = addi %c0, %0 : index
      %13 = addi %c0_0, %1 : index
      %14 = addi %c0_1, %3 : index
      %cst = constant 1.000000e-01 : f64
      %c2 = constant 2 : index
      %15 = addi %12, %c2 : index
      %16 = memref.load %arg0[%15, %13, %14] : memref<258x258x258xf64>
      %17 = mulf %cst, %16 : f64
      %cst_2 = constant 2.000000e-01 : f64
      %c1 = constant 1 : index
      %18 = addi %12, %c1 : index
      %19 = memref.load %arg0[%18, %13, %14] : memref<258x258x258xf64>
      %20 = mulf %cst_2, %19 : f64
      %21 = addf %17, %20 : f64
      %cst_3 = constant 3.000000e-01 : f64
      %22 = memref.load %arg0[%12, %13, %14] : memref<258x258x258xf64>
      %23 = mulf %cst_3, %22 : f64
      %24 = addf %21, %23 : f64
      %cst_4 = constant 4.000000e-01 : f64
      %c1_5 = constant 1 : index
      %25 = addi %14, %c1_5 : index
      %26 = memref.load %arg0[%12, %13, %25] : memref<258x258x258xf64>
      %27 = mulf %cst_4, %26 : f64
      %28 = addf %24, %27 : f64
      %cst_6 = constant 5.000000e-01 : f64
      %c2_7 = constant 2 : index
      %29 = addi %14, %c2_7 : index
      %30 = memref.load %arg0[%12, %13, %29] : memref<258x258x258xf64>
      %31 = mulf %cst_6, %30 : f64
      %32 = addf %28, %31 : f64
      %cst_8 = constant 6.000000e-01 : f64
      %c1_9 = constant 1 : index
      %33 = addi %13, %c1_9 : index
      %34 = memref.load %arg0[%12, %33, %14] : memref<258x258x258xf64>
      %35 = mulf %cst_8, %34 : f64
      %36 = addf %32, %35 : f64
      %cst_10 = constant 0.69999999999999996 : f64
      %c2_11 = constant 2 : index
      %37 = addi %13, %c2_11 : index
      %38 = memref.load %arg0[%12, %37, %14] : memref<258x258x258xf64>
      %39 = mulf %cst_10, %38 : f64
      %40 = addf %36, %39 : f64
      memref.store %40, %arg1[%12, %13, %14] : memref<258x258x258xf64>
      gpu.return
    }
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
