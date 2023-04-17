module  {
  func @stencil_3d27pt_box(%arg0: !stencil.field<258x258x258xf64>, %arg1: !stencil.field<258x258x258xf64>) attributes {stencil.program} {
    %0 = stencil.apply (%arg2 = %arg0 : !stencil.field<258x258x258xf64>)->!stencil.field<258x258x258xf64> {
      %cst = constant 1.000000e-01 : f64
      %1 = stencil.access %arg2 [-1, -1, -1] : (!stencil.field<258x258x258xf64>) -> f64
      %2 = mulf %cst, %1 : f64
      %cst_0 = constant 2.000000e-01 : f64
      %3 = stencil.access %arg2 [-1, -1, 0] : (!stencil.field<258x258x258xf64>) -> f64
      %4 = mulf %cst_0, %3 : f64
      %5 = addf %2, %4 : f64
      %cst_1 = constant 3.000000e-01 : f64
      %6 = stencil.access %arg2 [-1, -1, 1] : (!stencil.field<258x258x258xf64>) -> f64
      %7 = mulf %cst_1, %6 : f64
      %8 = addf %5, %7 : f64
      %cst_2 = constant 4.000000e-01 : f64
      %9 = stencil.access %arg2 [-1, 0, -1] : (!stencil.field<258x258x258xf64>) -> f64
      %10 = mulf %cst_2, %9 : f64
      %11 = addf %8, %10 : f64
      %cst_3 = constant 5.000000e-01 : f64
      %12 = stencil.access %arg2 [-1, 0, 0] : (!stencil.field<258x258x258xf64>) -> f64
      %13 = mulf %cst_3, %12 : f64
      %14 = addf %11, %13 : f64
      %cst_4 = constant 6.000000e-01 : f64
      %15 = stencil.access %arg2 [-1, 0, 1] : (!stencil.field<258x258x258xf64>) -> f64
      %16 = mulf %cst_4, %15 : f64
      %17 = addf %14, %16 : f64
      %cst_5 = constant 0.69999999999999996 : f64
      %18 = stencil.access %arg2 [-1, 1, -1] : (!stencil.field<258x258x258xf64>) -> f64
      %19 = mulf %cst_5, %18 : f64
      %20 = addf %17, %19 : f64
      %cst_6 = constant 8.000000e-01 : f64
      %21 = stencil.access %arg2 [-1, 1, 0] : (!stencil.field<258x258x258xf64>) -> f64
      %22 = mulf %cst_6, %21 : f64
      %23 = addf %20, %22 : f64
      %cst_7 = constant 9.000000e-01 : f64
      %24 = stencil.access %arg2 [-1, 1, 1] : (!stencil.field<258x258x258xf64>) -> f64
      %25 = mulf %cst_7, %24 : f64
      %26 = addf %23, %25 : f64
      %cst_8 = constant 1.000000e-01 : f64
      %27 = stencil.access %arg2 [0, -1, -1] : (!stencil.field<258x258x258xf64>) -> f64
      %28 = mulf %cst_8, %27 : f64
      %29 = addf %26, %28 : f64
      %cst_9 = constant 2.000000e-01 : f64
      %30 = stencil.access %arg2 [0, -1, 0] : (!stencil.field<258x258x258xf64>) -> f64
      %31 = mulf %cst_9, %30 : f64
      %32 = addf %29, %31 : f64
      %cst_10 = constant 3.000000e-01 : f64
      %33 = stencil.access %arg2 [0, -1, 1] : (!stencil.field<258x258x258xf64>) -> f64
      %34 = mulf %cst_10, %33 : f64
      %35 = addf %32, %34 : f64
      %cst_11 = constant 4.000000e-01 : f64
      %36 = stencil.access %arg2 [0, 0, -1] : (!stencil.field<258x258x258xf64>) -> f64
      %37 = mulf %cst_11, %36 : f64
      %38 = addf %35, %37 : f64
      %cst_12 = constant 5.000000e-01 : f64
      %39 = stencil.access %arg2 [0, 0, 0] : (!stencil.field<258x258x258xf64>) -> f64
      %40 = mulf %cst_12, %39 : f64
      %41 = addf %38, %40 : f64
      %cst_13 = constant 6.000000e-01 : f64
      %42 = stencil.access %arg2 [0, 0, 1] : (!stencil.field<258x258x258xf64>) -> f64
      %43 = mulf %cst_13, %42 : f64
      %44 = addf %41, %43 : f64
      %cst_14 = constant 0.69999999999999996 : f64
      %45 = stencil.access %arg2 [0, 1, -1] : (!stencil.field<258x258x258xf64>) -> f64
      %46 = mulf %cst_14, %45 : f64
      %47 = addf %44, %46 : f64
      %cst_15 = constant 8.000000e-01 : f64
      %48 = stencil.access %arg2 [0, 1, 0] : (!stencil.field<258x258x258xf64>) -> f64
      %49 = mulf %cst_15, %48 : f64
      %50 = addf %47, %49 : f64
      %cst_16 = constant 9.000000e-01 : f64
      %51 = stencil.access %arg2 [0, 1, 1] : (!stencil.field<258x258x258xf64>) -> f64
      %52 = mulf %cst_16, %51 : f64
      %53 = addf %50, %52 : f64
      %cst_17 = constant 1.000000e-01 : f64
      %54 = stencil.access %arg2 [1, -1, -1] : (!stencil.field<258x258x258xf64>) -> f64
      %55 = mulf %cst_17, %54 : f64
      %56 = addf %53, %55 : f64
      %cst_18 = constant 2.000000e-01 : f64
      %57 = stencil.access %arg2 [1, -1, 0] : (!stencil.field<258x258x258xf64>) -> f64
      %58 = mulf %cst_18, %57 : f64
      %59 = addf %56, %58 : f64
      %cst_19 = constant 3.000000e-01 : f64
      %60 = stencil.access %arg2 [1, -1, 1] : (!stencil.field<258x258x258xf64>) -> f64
      %61 = mulf %cst_19, %60 : f64
      %62 = addf %59, %61 : f64
      %cst_20 = constant 4.000000e-01 : f64
      %63 = stencil.access %arg2 [1, 0, -1] : (!stencil.field<258x258x258xf64>) -> f64
      %64 = mulf %cst_20, %63 : f64
      %65 = addf %62, %64 : f64
      %cst_21 = constant 5.000000e-01 : f64
      %66 = stencil.access %arg2 [1, 0, 0] : (!stencil.field<258x258x258xf64>) -> f64
      %67 = mulf %cst_21, %66 : f64
      %68 = addf %65, %67 : f64
      %cst_22 = constant 6.000000e-01 : f64
      %69 = stencil.access %arg2 [1, 0, 1] : (!stencil.field<258x258x258xf64>) -> f64
      %70 = mulf %cst_22, %69 : f64
      %71 = addf %68, %70 : f64
      %cst_23 = constant 0.69999999999999996 : f64
      %72 = stencil.access %arg2 [1, 1, -1] : (!stencil.field<258x258x258xf64>) -> f64
      %73 = mulf %cst_23, %72 : f64
      %74 = addf %71, %73 : f64
      %cst_24 = constant 8.000000e-01 : f64
      %75 = stencil.access %arg2 [1, 1, 0] : (!stencil.field<258x258x258xf64>) -> f64
      %76 = mulf %cst_24, %75 : f64
      %77 = addf %74, %76 : f64
      %cst_25 = constant 9.000000e-01 : f64
      %78 = stencil.access %arg2 [1, 1, 1] : (!stencil.field<258x258x258xf64>) -> f64
      %79 = mulf %cst_25, %78 : f64
      %80 = addf %77, %79 : f64
      %81 = stencil.store %80 : (f64) -> !stencil.result<f64>
      stencil.return %81 : !stencil.result<f64>
    } in ([1, 1, 1] : [257, 257, 257]) tile([4, 8, 64]) cacheAt(2)
    stencil.copy %0 to %arg1([1, 1, 1] : [257, 257, 257]) : !stencil.field<258x258x258xf64> to !stencil.field<258x258x258xf64>
    return
  }
  func @stencil_3d27pt_box_iteration(%arg0: !stencil.field<258x258x258xf64>, %arg1: !stencil.field<258x258x258xf64>) attributes {stencil.iteration} {
    stencil.iteration stencil_3d27pt_box ((%arg0 : !stencil.field<258x258x258xf64>, %arg1 : !stencil.field<258x258x258xf64>), (%arg1 : !stencil.field<258x258x258xf64>, %arg0 : !stencil.field<258x258x258xf64>), 1, [8, 4, 4], ([1, 1, 1]:[1, 1, 1]))
    return
  }
}
