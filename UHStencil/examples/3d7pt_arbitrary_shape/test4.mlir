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
    gpu.func @stencil_3d7pt_kernel(%arg0: memref<10x10x10xf64>, %arg1: memref<10x10x10xf64>) workgroup(%arg2 : memref<10x10x10xf64, 3>) kernel {
      %c0 = constant 0 : index
      %c1 = constant 1 : index
      %c0_0 = constant 0 : index
      %c10 = constant 10 : index
      %c1_1 = constant 1 : index
      %c10_2 = constant 10 : index
      %c2 = constant 2 : index
      %c10_3 = constant 10 : index
      %0 = "gpu.thread_id"() {dimension = "x"} : () -> index
      %1 = "gpu.block_dim"() {dimension = "x"} : () -> index
      %2 = "gpu.thread_id"() {dimension = "y"} : () -> index
      %3 = "gpu.block_dim"() {dimension = "y"} : () -> index
      %4 = "gpu.thread_id"() {dimension = "z"} : () -> index
      %5 = "gpu.block_dim"() {dimension = "z"} : () -> index
      %6 = muli %4, %c1 : index
      %7 = addi %6, %c0 : index
      %8 = muli %5, %c1 : index
      br ^bb1(%7 : index)
    ^bb1(%9: index):  // 2 preds: ^bb0, ^bb8
      %10 = cmpi slt, %9, %c10 : index
      cond_br %10, ^bb2, ^bb9
    ^bb2:  // pred: ^bb1
      %11 = muli %2, %c1 : index
      %12 = addi %11, %c0 : index
      %13 = muli %3, %c1 : index
      br ^bb3(%12 : index)
    ^bb3(%14: index):  // 2 preds: ^bb2, ^bb7
      %15 = cmpi slt, %14, %c10_2 : index
      cond_br %15, ^bb4, ^bb8
    ^bb4:  // pred: ^bb3
      %16 = muli %0, %c1 : index
      %17 = addi %16, %c0 : index
      %18 = muli %1, %c1 : index
      br ^bb5(%17 : index)
    ^bb5(%19: index):  // 2 preds: ^bb4, ^bb6
      %20 = cmpi slt, %19, %c10_3 : index
      cond_br %20, ^bb6, ^bb7
    ^bb6:  // pred: ^bb5
      %21 = memref.load %arg0[%9, %14, %19] : memref<10x10x10xf64>
      memref.store %21, %arg2[%9, %14, %19] : memref<10x10x10xf64, 3>
      %22 = addi %19, %18 : index
      br ^bb5(%22 : index)
    ^bb7:  // pred: ^bb5
      %23 = addi %14, %13 : index
      br ^bb3(%23 : index)
    ^bb8:  // pred: ^bb3
      %24 = addi %9, %8 : index
      br ^bb1(%24 : index)
    ^bb9:  // pred: ^bb1
      gpu.barrier
      %25 = "gpu.block_id"() {dimension = "x"} : () -> index
      %26 = "gpu.block_id"() {dimension = "y"} : () -> index
      %27 = "gpu.block_id"() {dimension = "z"} : () -> index
      %28 = "gpu.thread_id"() {dimension = "x"} : () -> index
      %29 = "gpu.thread_id"() {dimension = "y"} : () -> index
      %30 = "gpu.thread_id"() {dimension = "z"} : () -> index
      %31 = "gpu.grid_dim"() {dimension = "x"} : () -> index
      %32 = "gpu.grid_dim"() {dimension = "y"} : () -> index
      %33 = "gpu.grid_dim"() {dimension = "z"} : () -> index
      %34 = "gpu.block_dim"() {dimension = "x"} : () -> index
      %35 = "gpu.block_dim"() {dimension = "y"} : () -> index
      %36 = "gpu.block_dim"() {dimension = "z"} : () -> index
      gpu.barrier
      %c0_4 = constant 0 : index
      %c1_5 = constant 1 : index
      %c0_6 = constant 0 : index
      %c10_7 = constant 10 : index
      %c1_8 = constant 1 : index
      %c10_9 = constant 10 : index
      %c2_10 = constant 2 : index
      %c10_11 = constant 10 : index
      %37 = "gpu.thread_id"() {dimension = "x"} : () -> index
      %38 = "gpu.block_dim"() {dimension = "x"} : () -> index
      %39 = "gpu.thread_id"() {dimension = "y"} : () -> index
      %40 = "gpu.block_dim"() {dimension = "y"} : () -> index
      %41 = "gpu.thread_id"() {dimension = "z"} : () -> index
      %42 = "gpu.block_dim"() {dimension = "z"} : () -> index
      %43 = muli %41, %c1_5 : index
      %44 = addi %43, %c0_4 : index
      %45 = muli %42, %c1_5 : index
      br ^bb10(%44 : index)
    ^bb10(%46: index):  // 2 preds: ^bb9, ^bb17
      %47 = cmpi slt, %46, %c10_7 : index
      cond_br %47, ^bb11, ^bb18
    ^bb11:  // pred: ^bb10
      %48 = muli %39, %c1_5 : index
      %49 = addi %48, %c0_4 : index
      %50 = muli %40, %c1_5 : index
      br ^bb12(%49 : index)
    ^bb12(%51: index):  // 2 preds: ^bb11, ^bb16
      %52 = cmpi slt, %51, %c10_9 : index
      cond_br %52, ^bb13, ^bb17
    ^bb13:  // pred: ^bb12
      %53 = muli %37, %c1_5 : index
      %54 = addi %53, %c0_4 : index
      %55 = muli %38, %c1_5 : index
      br ^bb14(%54 : index)
    ^bb14(%56: index):  // 2 preds: ^bb13, ^bb15
      %57 = cmpi slt, %56, %c10_11 : index
      cond_br %57, ^bb15, ^bb16
    ^bb15:  // pred: ^bb14
      %58 = memref.load %arg2[%46, %51, %56] : memref<10x10x10xf64, 3>
      memref.store %58, %arg0[%46, %51, %56] : memref<10x10x10xf64>
      %59 = addi %56, %55 : index
      br ^bb14(%59 : index)
    ^bb16:  // pred: ^bb14
      %60 = addi %51, %50 : index
      br ^bb12(%60 : index)
    ^bb17:  // pred: ^bb12
      %61 = addi %46, %45 : index
      br ^bb10(%61 : index)
    ^bb18:  // pred: ^bb10
      br ^bb19
    ^bb19:  // pred: ^bb18
      %c0_12 = constant 0 : index
      %c0_13 = constant 0 : index
      %62 = addi %c0_12, %25 : index
      %63 = addi %c0_13, %28 : index
      %c0_14 = constant 0 : index
      %c8 = constant 8 : index
      %c1_15 = constant 1 : index
      br ^bb20(%c0_14 : index)
    ^bb20(%64: index):  // 2 preds: ^bb19, ^bb21
      %65 = cmpi slt, %64, %c8 : index
      cond_br %65, ^bb21, ^bb22
    ^bb21:  // pred: ^bb20
      %cst = constant 1.000000e-01 : f64
      %c2_16 = constant 2 : index
      %66 = addi %62, %c2_16 : index
      %67 = memref.load %arg2[%66, %63, %64] : memref<10x10x10xf64, 3>
      %68 = mulf %cst, %67 : f64
      %cst_17 = constant 2.000000e-01 : f64
      %c1_18 = constant 1 : index
      %69 = addi %62, %c1_18 : index
      %70 = memref.load %arg2[%69, %63, %64] : memref<10x10x10xf64, 3>
      %71 = mulf %cst_17, %70 : f64
      %72 = addf %68, %71 : f64
      %cst_19 = constant 3.000000e-01 : f64
      %73 = memref.load %arg2[%62, %63, %64] : memref<10x10x10xf64, 3>
      %74 = mulf %cst_19, %73 : f64
      %75 = addf %72, %74 : f64
      %cst_20 = constant 4.000000e-01 : f64
      %c1_21 = constant 1 : index
      %76 = addi %64, %c1_21 : index
      %77 = memref.load %arg2[%62, %63, %76] : memref<10x10x10xf64, 3>
      %78 = mulf %cst_20, %77 : f64
      %79 = addf %75, %78 : f64
      %cst_22 = constant 5.000000e-01 : f64
      %c2_23 = constant 2 : index
      %80 = addi %64, %c2_23 : index
      %81 = memref.load %arg2[%62, %63, %80] : memref<10x10x10xf64, 3>
      %82 = mulf %cst_22, %81 : f64
      %83 = addf %79, %82 : f64
      %cst_24 = constant 6.000000e-01 : f64
      %c1_25 = constant 1 : index
      %84 = addi %63, %c1_25 : index
      %85 = memref.load %arg2[%62, %84, %64] : memref<10x10x10xf64, 3>
      %86 = mulf %cst_24, %85 : f64
      %87 = addf %83, %86 : f64
      %cst_26 = constant 0.69999999999999996 : f64
      %c2_27 = constant 2 : index
      %88 = addi %63, %c2_27 : index
      %89 = memref.load %arg2[%62, %88, %64] : memref<10x10x10xf64, 3>
      %90 = mulf %cst_26, %89 : f64
      %91 = addf %87, %90 : f64
      memref.store %91, %arg1[%62, %63, %64] : memref<10x10x10xf64>
      %92 = addi %64, %c1_15 : index
      br ^bb20(%92 : index)
    ^bb22:  // pred: ^bb20
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

