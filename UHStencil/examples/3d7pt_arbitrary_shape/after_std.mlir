// -----// IR Dump After StencilToStdPass //----- //
module  {
  func @stencil_3d7pt(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) {
    %0 = memref.alloc() : memref<258x258x258xf64>
    affine.for %arg2 = 0 to 256 {
      affine.for %arg3 = 0 to 256 {
        affine.for %arg4 = 0 to 256 {
          %cst = constant 1.000000e-01 : f64
          %1 = affine.load %arg0[%arg2 + 2, %arg3, %arg4] : memref<258x258x258xf64>
          %2 = mulf %cst, %1 : f64
          %cst_0 = constant 2.000000e-01 : f64
          %3 = affine.load %arg0[%arg2 + 1, %arg3, %arg4] : memref<258x258x258xf64>
          %4 = mulf %cst_0, %3 : f64
          %5 = addf %2, %4 : f64
          %cst_1 = constant 3.000000e-01 : f64
          %6 = affine.load %arg0[%arg2, %arg3, %arg4] : memref<258x258x258xf64>
          %7 = mulf %cst_1, %6 : f64
          %8 = addf %5, %7 : f64
          %cst_2 = constant 4.000000e-01 : f64
          %9 = affine.load %arg0[%arg2, %arg3, %arg4 + 1] : memref<258x258x258xf64>
          %10 = mulf %cst_2, %9 : f64
          %11 = addf %8, %10 : f64
          %cst_3 = constant 5.000000e-01 : f64
          %12 = affine.load %arg0[%arg2, %arg3, %arg4 + 2] : memref<258x258x258xf64>
          %13 = mulf %cst_3, %12 : f64
          %14 = addf %11, %13 : f64
          %cst_4 = constant 6.000000e-01 : f64
          %15 = affine.load %arg0[%arg2, %arg3 + 1, %arg4] : memref<258x258x258xf64>
          %16 = mulf %cst_4, %15 : f64
          %17 = addf %14, %16 : f64
          %cst_5 = constant 0.69999999999999996 : f64
          %18 = affine.load %arg0[%arg2, %arg3 + 2, %arg4] : memref<258x258x258xf64>
          %19 = mulf %cst_5, %18 : f64
          %20 = addf %17, %19 : f64
          affine.store %20, %arg1[%arg2, %arg3, %arg4] : memref<258x258x258xf64>
        }
      }
    }
    return
  }
  func @stencil_3d7pt_iteration(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) {
    %c0 = constant 0 : index
    %c10 = constant 10 : index
    %c1 = constant 1 : index
    scf.for %arg2 = %c0 to %c10 step %c1 {
      call @stencil_3d7pt(%arg0, %arg1) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
      call @stencil_3d7pt(%arg1, %arg0) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
    }
    return
  }
}
