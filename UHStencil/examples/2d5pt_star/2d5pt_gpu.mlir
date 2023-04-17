module attributes {gpu.container_module}  {
  func @stencil_2d5pt(%arg0: memref<8194x8194xf64>, %arg1: memref<8194x8194xf64>) attributes {hardware = "gpu", llvm.emit_c_interface} {
    %c16 = constant 16 : index
    %c32 = constant 32 : index
    %c1 = constant 1 : index
    gpu.launch_func  @stencil_2d5pt_kernel::@stencil_2d5pt_kernel blocks in (%c1, %c32, %c32) threads in (%c1, %c16, %c16) args(%arg0 : memref<8194x8194xf64>, %arg1 : memref<8194x8194xf64>)
    return
  }
  gpu.module @stencil_2d5pt_kernel {
    gpu.func @stencil_2d5pt_kernel(%arg0: memref<8194x8194xf64>, %arg1: memref<8194x8194xf64>) workgroup(%arg2 : memref<32x64xf64, 3>, %arg3 : memref<34x66xf64, 3>) kernel {
      %0 = "gpu.block_id"() {dimension = "y"} : () -> index
      %1 = "gpu.block_id"() {dimension = "z"} : () -> index
      %2 = "gpu.thread_id"() {dimension = "y"} : () -> index
      %3 = "gpu.thread_id"() {dimension = "z"} : () -> index
      br ^bb1
    ^bb1:  // pred: ^bb0
      %c256 = constant 256 : index
      %c1 = constant 1 : index
      %c257 = constant 257 : index
      %c-1 = constant -1 : index
      %c66 = constant 66 : index
      %c16 = constant 16 : index
      %c34 = constant 34 : index
      %cst = constant 1.000000e-01 : f64
      %c2 = constant 2 : index
      %cst_0 = constant 2.000000e-01 : f64
      %cst_1 = constant 3.000000e-01 : f64
      %cst_2 = constant 4.000000e-01 : f64
      %cst_3 = constant 5.000000e-01 : f64
      %c0 = constant 0 : index
      %c4 = constant 4 : index
      %c64 = constant 64 : index
      %c32 = constant 32 : index
      %4 = muli %1, %c256 : index
      %5 = addi %4, %3 : index
      %6 = addi %5, %c1 : index
      %7 = addi %5, %c257 : index
      scf.for %arg4 = %6 to %7 step %c32 {
        %8 = muli %0, %c256 : index
        %9 = addi %8, %2 : index
        %10 = addi %9, %c1 : index
        %11 = addi %9, %c257 : index
        scf.for %arg5 = %10 to %11 step %c64 {
          scf.for %arg6 = %3 to %c34 step %c16 {
            scf.for %arg7 = %2 to %c66 step %c16 {
              %12 = addi %arg6, %arg4 : index
              %13 = muli %3, %c-1 : index
              %14 = addi %12, %13 : index
              %15 = addi %14, %c-1 : index
              %16 = addi %arg7, %arg5 : index
              %17 = muli %2, %c-1 : index
              %18 = addi %16, %17 : index
              %19 = addi %18, %c-1 : index
              %20 = memref.load %arg0[%15, %19] : memref<8194x8194xf64>
              memref.store %20, %arg3[%arg6, %arg7] : memref<34x66xf64, 3>
            }
          }
          gpu.barrier
          scf.for %arg6 = %c0 to %c2 step %c1 {
            scf.for %arg7 = %c0 to %c4 step %c1 {
              %12 = muli %arg6, %c16 : index
              %13 = muli %arg7, %c16 : index
              %14 = addi %3, %12 : index
              %15 = addi %2, %13 : index
              %16 = addi %15, %c1 : index
              %17 = memref.load %arg3[%14, %16] : memref<34x66xf64, 3>
              %18 = mulf %cst, %17 : f64
              %19 = addi %14, %c2 : index
              %20 = memref.load %arg3[%19, %16] : memref<34x66xf64, 3>
              %21 = mulf %cst_0, %20 : f64
              %22 = addf %18, %21 : f64
              %23 = addi %14, %c1 : index
              %24 = memref.load %arg3[%23, %16] : memref<34x66xf64, 3>
              %25 = mulf %cst_1, %24 : f64
              %26 = addf %22, %25 : f64
              %27 = addi %15, %c2 : index
              %28 = memref.load %arg3[%23, %27] : memref<34x66xf64, 3>
              %29 = mulf %cst_2, %28 : f64
              %30 = addf %26, %29 : f64
              %31 = memref.load %arg3[%23, %15] : memref<34x66xf64, 3>
              %32 = mulf %cst_3, %31 : f64
              %33 = addf %30, %32 : f64
              memref.store %33, %arg2[%14, %15] : memref<32x64xf64, 3>
            }
          }
          gpu.barrier
          scf.for %arg6 = %3 to %c32 step %c16 {
            scf.for %arg7 = %2 to %c64 step %c16 {
              %12 = memref.load %arg2[%arg6, %arg7] : memref<32x64xf64, 3>
              %13 = addi %arg6, %arg4 : index
              %14 = muli %3, %c-1 : index
              %15 = addi %13, %14 : index
              %16 = addi %arg7, %arg5 : index
              %17 = muli %2, %c-1 : index
              %18 = addi %16, %17 : index
              memref.store %12, %arg1[%15, %18] : memref<8194x8194xf64>
            }
          }
        }
      }
      gpu.return
    }
  }
  func @stencil_2d5pt_iteration(%arg0: memref<8194x8194xf64>, %arg1: memref<8194x8194xf64>) attributes {llvm.emit_c_interface} {
    %c1 = constant 1 : index
    %c10 = constant 10 : index
    %c0 = constant 0 : index
    scf.for %arg2 = %c0 to %c10 step %c1 {
      call @stencil_2d5pt(%arg0, %arg1) : (memref<8194x8194xf64>, memref<8194x8194xf64>) -> ()
      call @stencil_2d5pt(%arg1, %arg0) : (memref<8194x8194xf64>, memref<8194x8194xf64>) -> ()
    }
    return
  }
}
