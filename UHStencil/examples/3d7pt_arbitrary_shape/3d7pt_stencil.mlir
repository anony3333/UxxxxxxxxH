// -----// IR Dump Before StencilToStdPass //----- //
module  {
  func @stencil_3d7pt(%arg0: !stencil.field<258x258x258xf64>, %arg1: !stencil.field<258x258x258xf64>) attributes {stencil.program} {
    %0 = stencil.apply (%arg2 = %arg0 : !stencil.field<258x258x258xf64>)->!stencil.field<258x258x258xf64> {
      %cst = constant 1.000000e-01 : f64
      %1 = stencil.access %arg2 [2, 0, 0] : (!stencil.field<258x258x258xf64>) -> f64
      %2 = mulf %cst, %1 : f64
      %cst_0 = constant 2.000000e-01 : f64
      %3 = stencil.access %arg2 [1, 0, 0] : (!stencil.field<258x258x258xf64>) -> f64
      %4 = mulf %cst_0, %3 : f64
      %5 = addf %2, %4 : f64
      %cst_1 = constant 3.000000e-01 : f64
      %6 = stencil.access %arg2 [0, 0, 0] : (!stencil.field<258x258x258xf64>) -> f64
      %7 = mulf %cst_1, %6 : f64
      %8 = addf %5, %7 : f64
      %cst_2 = constant 4.000000e-01 : f64
      %9 = stencil.access %arg2 [0, 0, 1] : (!stencil.field<258x258x258xf64>) -> f64
      %10 = mulf %cst_2, %9 : f64
      %11 = addf %8, %10 : f64
      %cst_3 = constant 5.000000e-01 : f64
      %12 = stencil.access %arg2 [0, 0, 2] : (!stencil.field<258x258x258xf64>) -> f64
      %13 = mulf %cst_3, %12 : f64
      %14 = addf %11, %13 : f64
      %cst_4 = constant 6.000000e-01 : f64
      %15 = stencil.access %arg2 [0, 1, 0] : (!stencil.field<258x258x258xf64>) -> f64
      %16 = mulf %cst_4, %15 : f64
      %17 = addf %14, %16 : f64
      %cst_5 = constant 0.69999999999999996 : f64
      %18 = stencil.access %arg2 [0, 2, 0] : (!stencil.field<258x258x258xf64>) -> f64
      %19 = mulf %cst_5, %18 : f64
      %20 = addf %17, %19 : f64
      %21 = stencil.store %20 : (f64) -> !stencil.result<f64>
      stencil.return %21 : !stencil.result<f64>
    } in ([0, 0, 0] : [256, 256, 256]) tile([2, 8, 4]) cacheAt(2)
    stencil.copy %0 to %arg1([0, 0, 0] : [256, 256, 256]) : !stencil.field<258x258x258xf64> to !stencil.field<258x258x258xf64>
    return
  }
  func @stencil_3d7pt_iteration(%arg0: !stencil.field<258x258x258xf64>, %arg1: !stencil.field<258x258x258xf64>) attributes {stencil.iteration} {
    stencil.iteration stencil_3d7pt ((%arg0 : !stencil.field<258x258x258xf64>, %arg1 : !stencil.field<258x258x258xf64>), (%arg1 : !stencil.field<258x258x258xf64>, %arg0 : !stencil.field<258x258x258xf64>), 10, [8, 4, 4], ([0, 0, 0]:[2, 2, 2]))
    return
  }
}
