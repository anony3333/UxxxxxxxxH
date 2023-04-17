module attributes {gpu.container_module}  {
  func @stencil_3d27pt_box(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) attributes {llvm.emit_c_interface} {
    %cst = constant 9.000000e-01 : f64
    %cst_0 = constant 8.000000e-01 : f64
    %cst_1 = constant 0.69999999999999996 : f64
    %cst_2 = constant 6.000000e-01 : f64
    %cst_3 = constant 5.000000e-01 : f64
    %cst_4 = constant 4.000000e-01 : f64
    %cst_5 = constant 3.000000e-01 : f64
    %cst_6 = constant 2.000000e-01 : f64
    %c-1 = constant -1 : index
    %cst_7 = constant 1.000000e-01 : f64
    %c256 = constant 256 : index
    %c33 = constant 33 : index
    %c32 = constant 32 : index
    %c65 = constant 65 : index
    %c64 = constant 64 : index
    %c1 = constant 1 : index
    %c8 = constant 8 : index
    %c4 = constant 4 : index
    gpu.launch_func  @stencil_3d27pt_box_kernel::@stencil_3d27pt_box_kernel blocks in (%c4, %c8, %c1) threads in (%c1, %c1, %c8) args(%arg0 : memref<258x258x258xf64>, %arg1 : memref<258x258x258xf64>)
    return
  }
  gpu.module @stencil_3d27pt_box_kernel {
    gpu.func @stencil_3d27pt_box_kernel(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) kernel {
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
      %c64 = constant 64 : index
      %c1 = constant 1 : index
      %c65 = constant 65 : index
      %c32 = constant 32 : index
      %c33 = constant 33 : index
      %c256 = constant 256 : index
      %c-1 = constant -1 : index
      %cst = constant 1.000000e-01 : f64
      %cst_0 = constant 2.000000e-01 : f64
      %cst_1 = constant 3.000000e-01 : f64
      %cst_2 = constant 4.000000e-01 : f64
      %cst_3 = constant 5.000000e-01 : f64
      %cst_4 = constant 6.000000e-01 : f64
      %cst_5 = constant 0.69999999999999996 : f64
      %cst_6 = constant 8.000000e-01 : f64
      %cst_7 = constant 9.000000e-01 : f64
      %12 = muli %0, %c64 : index
      %13 = muli %3, %c64 : index
      %14 = addi %12, %13 : index
      %15 = addi %14, %c1 : index
      %16 = addi %14, %c65 : index
      br ^bb2(%15 : index)
    ^bb2(%17: index):  // 2 preds: ^bb1, ^bb9
      %18 = cmpi slt, %17, %16 : index
      cond_br %18, ^bb3, ^bb10
    ^bb3:  // pred: ^bb2
      %19 = muli %1, %c32 : index
      %20 = muli %4, %c32 : index
      %21 = addi %19, %20 : index
      %22 = addi %21, %c1 : index
      %23 = addi %21, %c33 : index
      br ^bb4(%22 : index)
    ^bb4(%24: index):  // 2 preds: ^bb3, ^bb8
      %25 = cmpi slt, %24, %23 : index
      cond_br %25, ^bb5, ^bb9
    ^bb5:  // pred: ^bb4
      %26 = muli %2, %c256 : index
      %27 = muli %5, %c32 : index
      %28 = addi %26, %27 : index
      %29 = addi %28, %c1 : index
      %30 = addi %28, %c33 : index
      br ^bb6(%29 : index)
    ^bb6(%31: index):  // 2 preds: ^bb5, ^bb7
      %32 = cmpi slt, %31, %30 : index
      cond_br %32, ^bb7, ^bb8
    ^bb7:  // pred: ^bb6
      %33 = addi %17, %c-1 : index
      %34 = addi %24, %c-1 : index
      %35 = addi %31, %c-1 : index
      %36 = memref.load %arg0[%33, %34, %35] : memref<258x258x258xf64>
      %37 = mulf %cst, %36 : f64
      %38 = memref.load %arg0[%33, %34, %31] : memref<258x258x258xf64>
      %39 = mulf %cst_0, %38 : f64
      %40 = addf %37, %39 : f64
      %41 = addi %31, %c1 : index
      %42 = memref.load %arg0[%33, %34, %41] : memref<258x258x258xf64>
      %43 = mulf %cst_1, %42 : f64
      %44 = addf %40, %43 : f64
      %45 = memref.load %arg0[%33, %24, %35] : memref<258x258x258xf64>
      %46 = mulf %cst_2, %45 : f64
      %47 = addf %44, %46 : f64
      %48 = memref.load %arg0[%33, %24, %31] : memref<258x258x258xf64>
      %49 = mulf %cst_3, %48 : f64
      %50 = addf %47, %49 : f64
      %51 = memref.load %arg0[%33, %24, %41] : memref<258x258x258xf64>
      %52 = mulf %cst_4, %51 : f64
      %53 = addf %50, %52 : f64
      %54 = addi %24, %c1 : index
      %55 = memref.load %arg0[%33, %54, %35] : memref<258x258x258xf64>
      %56 = mulf %cst_5, %55 : f64
      %57 = addf %53, %56 : f64
      %58 = memref.load %arg0[%33, %54, %31] : memref<258x258x258xf64>
      %59 = mulf %cst_6, %58 : f64
      %60 = addf %57, %59 : f64
      %61 = memref.load %arg0[%33, %54, %41] : memref<258x258x258xf64>
      %62 = mulf %cst_7, %61 : f64
      %63 = addf %60, %62 : f64
      %64 = memref.load %arg0[%17, %34, %35] : memref<258x258x258xf64>
      %65 = mulf %cst, %64 : f64
      %66 = addf %63, %65 : f64
      %67 = memref.load %arg0[%17, %34, %31] : memref<258x258x258xf64>
      %68 = mulf %cst_0, %67 : f64
      %69 = addf %66, %68 : f64
      %70 = memref.load %arg0[%17, %34, %41] : memref<258x258x258xf64>
      %71 = mulf %cst_1, %70 : f64
      %72 = addf %69, %71 : f64
      %73 = memref.load %arg0[%17, %24, %35] : memref<258x258x258xf64>
      %74 = mulf %cst_2, %73 : f64
      %75 = addf %72, %74 : f64
      %76 = memref.load %arg0[%17, %24, %31] : memref<258x258x258xf64>
      %77 = mulf %cst_3, %76 : f64
      %78 = addf %75, %77 : f64
      %79 = memref.load %arg0[%17, %24, %41] : memref<258x258x258xf64>
      %80 = mulf %cst_4, %79 : f64
      %81 = addf %78, %80 : f64
      %82 = memref.load %arg0[%17, %54, %35] : memref<258x258x258xf64>
      %83 = mulf %cst_5, %82 : f64
      %84 = addf %81, %83 : f64
      %85 = memref.load %arg0[%17, %54, %31] : memref<258x258x258xf64>
      %86 = mulf %cst_6, %85 : f64
      %87 = addf %84, %86 : f64
      %88 = memref.load %arg0[%17, %54, %41] : memref<258x258x258xf64>
      %89 = mulf %cst_7, %88 : f64
      %90 = addf %87, %89 : f64
      %91 = addi %17, %c1 : index
      %92 = memref.load %arg0[%91, %34, %35] : memref<258x258x258xf64>
      %93 = mulf %cst, %92 : f64
      %94 = addf %90, %93 : f64
      %95 = memref.load %arg0[%91, %34, %31] : memref<258x258x258xf64>
      %96 = mulf %cst_0, %95 : f64
      %97 = addf %94, %96 : f64
      %98 = memref.load %arg0[%91, %34, %41] : memref<258x258x258xf64>
      %99 = mulf %cst_1, %98 : f64
      %100 = addf %97, %99 : f64
      %101 = memref.load %arg0[%91, %24, %35] : memref<258x258x258xf64>
      %102 = mulf %cst_2, %101 : f64
      %103 = addf %100, %102 : f64
      %104 = memref.load %arg0[%91, %24, %31] : memref<258x258x258xf64>
      %105 = mulf %cst_3, %104 : f64
      %106 = addf %103, %105 : f64
      %107 = memref.load %arg0[%91, %24, %41] : memref<258x258x258xf64>
      %108 = mulf %cst_4, %107 : f64
      %109 = addf %106, %108 : f64
      %110 = memref.load %arg0[%91, %54, %35] : memref<258x258x258xf64>
      %111 = mulf %cst_5, %110 : f64
      %112 = addf %109, %111 : f64
      %113 = memref.load %arg0[%91, %54, %31] : memref<258x258x258xf64>
      %114 = mulf %cst_6, %113 : f64
      %115 = addf %112, %114 : f64
      %116 = memref.load %arg0[%91, %54, %41] : memref<258x258x258xf64>
      %117 = mulf %cst_7, %116 : f64
      %118 = addf %115, %117 : f64
      memref.store %118, %arg1[%17, %24, %31] : memref<258x258x258xf64>
      %119 = addi %31, %c1 : index
      br ^bb6(%119 : index)
    ^bb8:  // pred: ^bb6
      %120 = addi %24, %c1 : index
      br ^bb4(%120 : index)
    ^bb9:  // pred: ^bb4
      %121 = addi %17, %c1 : index
      br ^bb2(%121 : index)
    ^bb10:  // pred: ^bb2
      gpu.return
    }
  }
  func @stencil_3d27pt_box_iteration(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) attributes {llvm.emit_c_interface} {
    call @stencil_3d27pt_box(%arg0, %arg1) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
    call @stencil_3d27pt_box(%arg1, %arg0) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
    return
  }
}
