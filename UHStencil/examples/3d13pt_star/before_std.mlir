// -----// IR Dump Before StencilToStdPass //----- //
module  {
  func @stencil_3d13pt_star(%arg0: !stencil.field<260x260x260xf64>, %arg1: !stencil.field<260x260x260xf64>) attributes {stencil.program} {
    %0 = stencil.apply (%arg2 = %arg0 : !stencil.field<260x260x260xf64>)->!stencil.field<260x260x260xf64> {
      %cst = constant 1.000000e-01 : f64
      %1 = stencil.access %arg2 [-2, 0, 0] : (!stencil.field<260x260x260xf64>) -> f64
      %2 = mulf %cst, %1 : f64
      %cst_0 = constant 2.000000e-01 : f64
      %3 = stencil.access %arg2 [-1, 0, 0] : (!stencil.field<260x260x260xf64>) -> f64
      %4 = mulf %cst_0, %3 : f64
      %5 = addf %2, %4 : f64
      %cst_1 = constant 3.000000e-01 : f64
      %6 = stencil.access %arg2 [1, 0, 0] : (!stencil.field<260x260x260xf64>) -> f64
      %7 = mulf %cst_1, %6 : f64
      %8 = addf %5, %7 : f64
      %cst_2 = constant 4.000000e-01 : f64
      %9 = stencil.access %arg2 [2, 0, 0] : (!stencil.field<260x260x260xf64>) -> f64
      %10 = mulf %cst_2, %9 : f64
      %11 = addf %8, %10 : f64
      %cst_3 = constant 5.000000e-01 : f64
      %12 = stencil.access %arg2 [0, -2, 0] : (!stencil.field<260x260x260xf64>) -> f64
      %13 = mulf %cst_3, %12 : f64
      %14 = addf %11, %13 : f64
      %cst_4 = constant 6.000000e-01 : f64
      %15 = stencil.access %arg2 [0, -1, 0] : (!stencil.field<260x260x260xf64>) -> f64
      %16 = mulf %cst_4, %15 : f64
      %17 = addf %14, %16 : f64
      %cst_5 = constant 0.69999999999999996 : f64
      %18 = stencil.access %arg2 [0, 1, 0] : (!stencil.field<260x260x260xf64>) -> f64
      %19 = mulf %cst_5, %18 : f64
      %20 = addf %17, %19 : f64
      %cst_6 = constant 8.000000e-01 : f64
      %21 = stencil.access %arg2 [0, 2, 0] : (!stencil.field<260x260x260xf64>) -> f64
      %22 = mulf %cst_6, %21 : f64
      %23 = addf %20, %22 : f64
      %cst_7 = constant 9.000000e-01 : f64
      %24 = stencil.access %arg2 [0, 0, -2] : (!stencil.field<260x260x260xf64>) -> f64
      %25 = mulf %cst_7, %24 : f64
      %26 = addf %23, %25 : f64
      %cst_8 = constant 1.000000e+00 : f64
      %27 = stencil.access %arg2 [0, 0, -1] : (!stencil.field<260x260x260xf64>) -> f64
      %28 = mulf %cst_8, %27 : f64
      %29 = addf %26, %28 : f64
      %cst_9 = constant 1.100000e+00 : f64
      %30 = stencil.access %arg2 [0, 0, 1] : (!stencil.field<260x260x260xf64>) -> f64
      %31 = mulf %cst_9, %30 : f64
      %32 = addf %29, %31 : f64
      %cst_10 = constant 1.200000e+00 : f64
      %33 = stencil.access %arg2 [0, 0, 2] : (!stencil.field<260x260x260xf64>) -> f64
      %34 = mulf %cst_10, %33 : f64
      %35 = addf %32, %34 : f64
      %cst_11 = constant 1.300000e+00 : f64
      %36 = stencil.access %arg2 [0, 0, 0] : (!stencil.field<260x260x260xf64>) -> f64
      %37 = mulf %cst_11, %36 : f64
      %38 = addf %35, %37 : f64
      %39 = stencil.store %38 : (f64) -> !stencil.result<f64>
      stencil.return %39 : !stencil.result<f64>
    } in ([2, 2, 2] : [258, 258, 258]) tile([2, 8, 64]) cacheAt(2)
    stencil.copy %0 to %arg1([2, 2, 2] : [258, 258, 258]) : !stencil.field<260x260x260xf64> to !stencil.field<260x260x260xf64>
    return
  }
  func @stencil_3d13pt_star_iteration(%arg0: !stencil.field<260x260x260xf64>, %arg1: !stencil.field<260x260x260xf64>) attributes {stencil.iteration} {
    stencil.iteration stencil_3d13pt_star ((%arg0 : !stencil.field<260x260x260xf64>, %arg1 : !stencil.field<260x260x260xf64>), (%arg1 : !stencil.field<260x260x260xf64>, %arg0 : !stencil.field<260x260x260xf64>), 10, [8, 4, 4], ([2, 2, 2]:[2, 2, 2]))
    return
  }
}


module  {
  func @stencil_3d13pt_star(%arg0: memref<260x260x260xf64>, %arg1: memref<260x260x260xf64>) {
    %0 = memref.alloc() : memref<260x260x260xf64>
    affine.for %arg2 = 2 to 258 {
      affine.for %arg3 = 2 to 258 {
        affine.for %arg4 = 2 to 258 {
          %cst = constant 1.000000e-01 : f64
          %1 = affine.load %arg0[%arg2 - 2, %arg3, %arg4] : memref<260x260x260xf64>
          %2 = mulf %cst, %1 : f64
          %cst_0 = constant 2.000000e-01 : f64
          %3 = affine.load %arg0[%arg2 - 1, %arg3, %arg4] : memref<260x260x260xf64>
          %4 = mulf %cst_0, %3 : f64
          %5 = addf %2, %4 : f64
          %cst_1 = constant 3.000000e-01 : f64
          %6 = affine.load %arg0[%arg2 + 1, %arg3, %arg4] : memref<260x260x260xf64>
          %7 = mulf %cst_1, %6 : f64
          %8 = addf %5, %7 : f64
          %cst_2 = constant 4.000000e-01 : f64
          %9 = affine.load %arg0[%arg2 + 2, %arg3, %arg4] : memref<260x260x260xf64>
          %10 = mulf %cst_2, %9 : f64
          %11 = addf %8, %10 : f64
          %cst_3 = constant 5.000000e-01 : f64
          %12 = affine.load %arg0[%arg2, %arg3 - 2, %arg4] : memref<260x260x260xf64>
          %13 = mulf %cst_3, %12 : f64
          %14 = addf %11, %13 : f64
          %cst_4 = constant 6.000000e-01 : f64
          %15 = affine.load %arg0[%arg2, %arg3 - 1, %arg4] : memref<260x260x260xf64>
          %16 = mulf %cst_4, %15 : f64
          %17 = addf %14, %16 : f64
          %cst_5 = constant 0.69999999999999996 : f64
          %18 = affine.load %arg0[%arg2, %arg3 + 1, %arg4] : memref<260x260x260xf64>
          %19 = mulf %cst_5, %18 : f64
          %20 = addf %17, %19 : f64
          %cst_6 = constant 8.000000e-01 : f64
          %21 = affine.load %arg0[%arg2, %arg3 + 2, %arg4] : memref<260x260x260xf64>
          %22 = mulf %cst_6, %21 : f64
          %23 = addf %20, %22 : f64
          %cst_7 = constant 9.000000e-01 : f64
          %24 = affine.load %arg0[%arg2, %arg3, %arg4 - 2] : memref<260x260x260xf64>
          %25 = mulf %cst_7, %24 : f64
          %26 = addf %23, %25 : f64
          %cst_8 = constant 1.000000e+00 : f64
          %27 = affine.load %arg0[%arg2, %arg3, %arg4 - 1] : memref<260x260x260xf64>
          %28 = mulf %cst_8, %27 : f64
          %29 = addf %26, %28 : f64
          %cst_9 = constant 1.100000e+00 : f64
          %30 = affine.load %arg0[%arg2, %arg3, %arg4 + 1] : memref<260x260x260xf64>
          %31 = mulf %cst_9, %30 : f64
          %32 = addf %29, %31 : f64
          %cst_10 = constant 1.200000e+00 : f64
          %33 = affine.load %arg0[%arg2, %arg3, %arg4 + 2] : memref<260x260x260xf64>
          %34 = mulf %cst_10, %33 : f64
          %35 = addf %32, %34 : f64
          %cst_11 = constant 1.300000e+00 : f64
          %36 = affine.load %arg0[%arg2, %arg3, %arg4] : memref<260x260x260xf64>
          %37 = mulf %cst_11, %36 : f64
          %38 = addf %35, %37 : f64
          affine.store %38, %arg1[%arg2, %arg3, %arg4] : memref<260x260x260xf64>
        }
      }
    }
    return
  }
  func @stencil_3d13pt_star_iteration(%arg0: memref<260x260x260xf64>, %arg1: memref<260x260x260xf64>) {
    %c0 = constant 0 : index
    %c10 = constant 10 : index
    %c1 = constant 1 : index
    scf.for %arg2 = %c0 to %c10 step %c1 {
      call @stencil_3d13pt_star(%arg0, %arg1) : (memref<260x260x260xf64>, memref<260x260x260xf64>) -> ()
      call @stencil_3d13pt_star(%arg1, %arg0) : (memref<260x260x260xf64>, memref<260x260x260xf64>) -> ()
    }
    return
  }
}
