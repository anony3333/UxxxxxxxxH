module attributes {gpu.container_module}  {
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
    gpu.launch_func  @stencil_3d7pt_kernel::@stencil_3d7pt_kernel blocks in (%1, %c1_3, %c1_3) threads in (%2, %c1_3, %c1_3) args(%arg0 : memref<10x10x10xf64>, %arg1 : memref<10x10x10xf64>)
    return
  }
  gpu.module @stencil_3d7pt_kernel {
    gpu.func @stencil_3d7pt_kernel(%arg0: memref<10x10x10xf64> {gpu.test_promote_workgroup}, %arg1: memref<10x10x10xf64>) kernel {
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
      %12 = addi %c0, %0 : index
      %13 = addi %c0_0, %3 : index
      affine.for %arg2 = 0 to 8 {
        %cst = constant 1.000000e-01 : f64
        %c2 = constant 2 : index
        %14 = addi %12, %c2 : index
        %15 = memref.load %arg0[%14, %13, %arg2] : memref<10x10x10xf64>
        %16 = mulf %cst, %15 : f64
        %cst_1 = constant 2.000000e-01 : f64
        %c1 = constant 1 : index
        %17 = addi %12, %c1 : index
        %18 = memref.load %arg0[%17, %13, %arg2] : memref<10x10x10xf64>
        %19 = mulf %cst_1, %18 : f64
        %20 = addf %16, %19 : f64
        %cst_2 = constant 3.000000e-01 : f64
        %21 = memref.load %arg0[%12, %13, %arg2] : memref<10x10x10xf64>
        %22 = mulf %cst_2, %21 : f64
        %23 = addf %20, %22 : f64
        %cst_3 = constant 4.000000e-01 : f64
        %c1_4 = constant 1 : index
        %24 = addi %arg2, %c1_4 : index
        %25 = memref.load %arg0[%12, %13, %24] : memref<10x10x10xf64>
        %26 = mulf %cst_3, %25 : f64
        %27 = addf %23, %26 : f64
        %cst_5 = constant 5.000000e-01 : f64
        %c2_6 = constant 2 : index
        %28 = addi %arg2, %c2_6 : index
        %29 = memref.load %arg0[%12, %13, %28] : memref<10x10x10xf64>
        %30 = mulf %cst_5, %29 : f64
        %31 = addf %27, %30 : f64
        %cst_7 = constant 6.000000e-01 : f64
        %c1_8 = constant 1 : index
        %32 = addi %13, %c1_8 : index
        %33 = memref.load %arg0[%12, %32, %arg2] : memref<10x10x10xf64>
        %34 = mulf %cst_7, %33 : f64
        %35 = addf %31, %34 : f64
        %cst_9 = constant 0.69999999999999996 : f64
        %c2_10 = constant 2 : index
        %36 = addi %13, %c2_10 : index
        %37 = memref.load %arg0[%12, %36, %arg2] : memref<10x10x10xf64>
        %38 = mulf %cst_9, %37 : f64
        %39 = addf %35, %38 : f64
        memref.store %39, %arg1[%12, %13, %arg2] : memref<10x10x10xf64>
      }
      gpu.return
    }
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

