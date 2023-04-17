#map0 = affine_map<()[s0, s1] -> (s0 * s1)>
#map1 = affine_map<()[s0, s1] -> (s0 + s1)>
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
      %6 = affine.apply #map0()[%4, %c1]
      %7 = affine.apply #map1()[%6, %c0]
      %8 = affine.apply #map0()[%5, %c1]
      scf.for %arg3 = %7 to %c10 step %8 {
        %32 = affine.apply #map0()[%2, %c1]
        %33 = affine.apply #map1()[%32, %c0]
        %34 = affine.apply #map0()[%3, %c1]
        scf.for %arg4 = %33 to %c10_2 step %34 {
          %35 = affine.apply #map0()[%0, %c1]
          %36 = affine.apply #map1()[%35, %c0]
          %37 = affine.apply #map0()[%1, %c1]
          scf.for %arg5 = %36 to %c10_3 step %37 {
            %38 = memref.load %arg0[%arg3, %arg4, %arg5] : memref<10x10x10xf64>
            memref.store %38, %arg2[%arg3, %arg4, %arg5] : memref<10x10x10xf64, 3>
          }
        }
      }
      gpu.barrier
      %9 = "gpu.block_id"() {dimension = "x"} : () -> index
      %10 = "gpu.block_id"() {dimension = "y"} : () -> index
      %11 = "gpu.block_id"() {dimension = "z"} : () -> index
      %12 = "gpu.thread_id"() {dimension = "x"} : () -> index
      %13 = "gpu.thread_id"() {dimension = "y"} : () -> index
      %14 = "gpu.thread_id"() {dimension = "z"} : () -> index
      %15 = "gpu.grid_dim"() {dimension = "x"} : () -> index
      %16 = "gpu.grid_dim"() {dimension = "y"} : () -> index
      %17 = "gpu.grid_dim"() {dimension = "z"} : () -> index
      %18 = "gpu.block_dim"() {dimension = "x"} : () -> index
      %19 = "gpu.block_dim"() {dimension = "y"} : () -> index
      %20 = "gpu.block_dim"() {dimension = "z"} : () -> index
      gpu.barrier
      %c0_4 = constant 0 : index
      %c1_5 = constant 1 : index
      %c0_6 = constant 0 : index
      %c10_7 = constant 10 : index
      %c1_8 = constant 1 : index
      %c10_9 = constant 10 : index
      %c2_10 = constant 2 : index
      %c10_11 = constant 10 : index
      %21 = "gpu.thread_id"() {dimension = "x"} : () -> index
      %22 = "gpu.block_dim"() {dimension = "x"} : () -> index
      %23 = "gpu.thread_id"() {dimension = "y"} : () -> index
      %24 = "gpu.block_dim"() {dimension = "y"} : () -> index
      %25 = "gpu.thread_id"() {dimension = "z"} : () -> index
      %26 = "gpu.block_dim"() {dimension = "z"} : () -> index
      %27 = affine.apply #map0()[%25, %c1_5]
      %28 = affine.apply #map1()[%27, %c0_4]
      %29 = affine.apply #map0()[%26, %c1_5]
      scf.for %arg3 = %28 to %c10_7 step %29 {
        %32 = affine.apply #map0()[%23, %c1_5]
        %33 = affine.apply #map1()[%32, %c0_4]
        %34 = affine.apply #map0()[%24, %c1_5]
        scf.for %arg4 = %33 to %c10_9 step %34 {
          %35 = affine.apply #map0()[%21, %c1_5]
          %36 = affine.apply #map1()[%35, %c0_4]
          %37 = affine.apply #map0()[%22, %c1_5]
          scf.for %arg5 = %36 to %c10_11 step %37 {
            %38 = memref.load %arg2[%arg3, %arg4, %arg5] : memref<10x10x10xf64, 3>
            memref.store %38, %arg0[%arg3, %arg4, %arg5] : memref<10x10x10xf64>
          }
        }
      }
      br ^bb1
    ^bb1:  // pred: ^bb0
      %c0_12 = constant 0 : index
      %c0_13 = constant 0 : index
      %30 = addi %c0_12, %9 : index
      %31 = addi %c0_13, %12 : index
      affine.for %arg3 = 0 to 8 {
        %cst = constant 1.000000e-01 : f64
        %c2_14 = constant 2 : index
        %32 = addi %30, %c2_14 : index
        %33 = memref.load %arg2[%32, %31, %arg3] : memref<10x10x10xf64, 3>
        %34 = mulf %cst, %33 : f64
        %cst_15 = constant 2.000000e-01 : f64
        %c1_16 = constant 1 : index
        %35 = addi %30, %c1_16 : index
        %36 = memref.load %arg2[%35, %31, %arg3] : memref<10x10x10xf64, 3>
        %37 = mulf %cst_15, %36 : f64
        %38 = addf %34, %37 : f64
        %cst_17 = constant 3.000000e-01 : f64
        %39 = memref.load %arg2[%30, %31, %arg3] : memref<10x10x10xf64, 3>
        %40 = mulf %cst_17, %39 : f64
        %41 = addf %38, %40 : f64
        %cst_18 = constant 4.000000e-01 : f64
        %c1_19 = constant 1 : index
        %42 = addi %arg3, %c1_19 : index
        %43 = memref.load %arg2[%30, %31, %42] : memref<10x10x10xf64, 3>
        %44 = mulf %cst_18, %43 : f64
        %45 = addf %41, %44 : f64
        %cst_20 = constant 5.000000e-01 : f64
        %c2_21 = constant 2 : index
        %46 = addi %arg3, %c2_21 : index
        %47 = memref.load %arg2[%30, %31, %46] : memref<10x10x10xf64, 3>
        %48 = mulf %cst_20, %47 : f64
        %49 = addf %45, %48 : f64
        %cst_22 = constant 6.000000e-01 : f64
        %c1_23 = constant 1 : index
        %50 = addi %31, %c1_23 : index
        %51 = memref.load %arg2[%30, %50, %arg3] : memref<10x10x10xf64, 3>
        %52 = mulf %cst_22, %51 : f64
        %53 = addf %49, %52 : f64
        %cst_24 = constant 0.69999999999999996 : f64
        %c2_25 = constant 2 : index
        %54 = addi %31, %c2_25 : index
        %55 = memref.load %arg2[%30, %54, %arg3] : memref<10x10x10xf64, 3>
        %56 = mulf %cst_24, %55 : f64
        %57 = addf %53, %56 : f64
        memref.store %57, %arg1[%30, %31, %arg3] : memref<10x10x10xf64>
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

