module  {
  func @stencil_2d5pt(%arg0: memref<8194x8194xf64>, %arg1: memref<8194x8194xf64>) attributes {hardware = "gpu", llvm.emit_c_interface} {
    affine.parallel (%arg2, %arg3, %arg4) = (0, 0, 0) to (1, 32, 32) {
      affine.parallel (%arg5, %arg6, %arg7) = (0, 0, 0) to (1, 16, 16) {
        affine.for %arg8 = affine_map<(d0, d1) -> (d0 * 256 + d1 + 1)>(%arg4, %arg7) to affine_map<(d0, d1) -> (d0 * 256 + d1 + 257)>(%arg4, %arg7) step 32 {
          affine.for %arg9 = affine_map<(d0, d1) -> (d0 * 256 + d1 + 1)>(%arg3, %arg6) to affine_map<(d0, d1) -> (d0 * 256 + d1 + 257)>(%arg3, %arg6) step 64 {
            %0 = memref.alloc() : memref<32x64xf64, 3>
            %1 = memref.alloc() : memref<34x66xf64, 3>
            affine.for %arg10 = affine_map<(d0) -> (d0)>(%arg7) to 34 step 16 {
              affine.for %arg11 = affine_map<(d0) -> (d0)>(%arg6) to 66 step 16 {
                %2 = affine.load %arg0[%arg10 + %arg8 - %arg7 - 1, %arg11 + %arg9 - %arg6 - 1] : memref<8194x8194xf64>
                affine.store %2, %1[%arg10, %arg11] : memref<34x66xf64, 3>
              }
            }
            gpu.barrier
            affine.for %arg10 = 0 to 2 {
              affine.for %arg11 = 0 to 4 {
                %2 = affine.apply affine_map<(d0, d1) -> (d0 + d1 * 16)>(%arg8, %arg10)
                %3 = affine.apply affine_map<(d0, d1) -> (d0 + d1 * 16)>(%arg9, %arg11)
                %cst = constant 1.000000e-01 : f64
                %4 = affine.load %1[%arg7 + %arg10 * 16, %arg6 + %arg11 * 16 + 1] : memref<34x66xf64, 3>
                %5 = mulf %cst, %4 : f64
                %cst_0 = constant 2.000000e-01 : f64
                %6 = affine.load %1[%arg7 + %arg10 * 16 + 2, %arg6 + %arg11 * 16 + 1] : memref<34x66xf64, 3>
                %7 = mulf %cst_0, %6 : f64
                %8 = addf %5, %7 : f64
                %cst_1 = constant 3.000000e-01 : f64
                %9 = affine.load %1[%arg7 + %arg10 * 16 + 1, %arg6 + %arg11 * 16 + 1] : memref<34x66xf64, 3>
                %10 = mulf %cst_1, %9 : f64
                %11 = addf %8, %10 : f64
                %cst_2 = constant 4.000000e-01 : f64
                %12 = affine.load %1[%arg7 + %arg10 * 16 + 1, %arg6 + %arg11 * 16 + 2] : memref<34x66xf64, 3>
                %13 = mulf %cst_2, %12 : f64
                %14 = addf %11, %13 : f64
                %cst_3 = constant 5.000000e-01 : f64
                %15 = affine.load %1[%arg7 + %arg10 * 16 + 1, %arg6 + %arg11 * 16] : memref<34x66xf64, 3>
                %16 = mulf %cst_3, %15 : f64
                %17 = addf %14, %16 : f64
                affine.store %17, %0[%arg7 + %arg10 * 16, %arg6 + %arg11 * 16] : memref<32x64xf64, 3>
              } {inner_tile}
            } {inner_tile}
            gpu.barrier
            affine.for %arg10 = affine_map<(d0) -> (d0)>(%arg7) to 32 step 16 {
              affine.for %arg11 = affine_map<(d0) -> (d0)>(%arg6) to 64 step 16 {
                %2 = affine.load %0[%arg10, %arg11] : memref<32x64xf64, 3>
                affine.store %2, %arg1[%arg10 + %arg8 - %arg7, %arg11 + %arg9 - %arg6] : memref<8194x8194xf64>
              }
            }
          } {dim_block = 1 : index, dim_grid = 1 : index, domain_lower_bound = 1 : index, stencil_main_loop, thread_inner_loop, thread_loop}
        } {dim_block = 0 : index, dim_grid = 0 : index, domain_lower_bound = 1 : index, stencil_main_loop, thread_loop}
      }
    }
    return
  }
  func @stencil_2d5pt_iteration(%arg0: memref<8194x8194xf64>, %arg1: memref<8194x8194xf64>) attributes {llvm.emit_c_interface} {
    %c0 = constant 0 : index
    %c10 = constant 10 : index
    %c1 = constant 1 : index
    scf.for %arg2 = %c0 to %c10 step %c1 {
      call @stencil_2d5pt(%arg0, %arg1) : (memref<8194x8194xf64>, memref<8194x8194xf64>) -> ()
      call @stencil_2d5pt(%arg1, %arg0) : (memref<8194x8194xf64>, memref<8194x8194xf64>) -> ()
    }
    return
  }
}
