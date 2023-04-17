module  {
  func @stencil_3d27pt_box(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) attributes {llvm.emit_c_interface} {
    %cst = constant 1.000000e-01 : f64
    %cst_0 = constant 2.000000e-01 : f64
    %cst_1 = constant 3.000000e-01 : f64
    %cst_2 = constant 4.000000e-01 : f64
    %cst_3 = constant 5.000000e-01 : f64
    %cst_4 = constant 6.000000e-01 : f64
    %cst_5 = constant 0.69999999999999996 : f64
    %cst_6 = constant 8.000000e-01 : f64
    %cst_7 = constant 9.000000e-01 : f64
    affine.parallel (%arg2, %arg3, %arg4, %arg5, %arg6, %arg7) = (0, 0, 0, 0, 0, 0) to (4, 4, 4, 8, 8, 8) {
      affine.for %arg8 = affine_map<(d0, d1) -> (d0 * 64 + d1 * 8)>(%arg2, %arg5) to affine_map<(d0, d1) -> (d0 * 64 + d1 * 8 + 8)>(%arg2, %arg5) {
        %0 = affine.apply affine_map<(d0) -> (d0 + 1)>(%arg8)
        affine.for %arg9 = affine_map<(d0, d1) -> (d0 * 64 + d1 * 8)>(%arg3, %arg6) to affine_map<(d0, d1) -> (d0 * 64 + d1 * 8 + 8)>(%arg3, %arg6) {
          %1 = affine.apply affine_map<(d0) -> (d0 + 1)>(%arg9)
          affine.for %arg10 = affine_map<(d0, d1) -> (d0 * 64 + d1 * 8)>(%arg4, %arg7) to affine_map<(d0, d1) -> (d0 * 64 + d1 * 8 + 8)>(%arg4, %arg7) {
            %2 = affine.apply affine_map<(d0) -> (d0 + 1)>(%arg10)
            %3 = affine.load %arg0[%0 - 1, %1 - 1, %2 - 1] : memref<258x258x258xf64>
            %4 = mulf %cst, %3 : f64
            %5 = affine.load %arg0[%0 - 1, %1 - 1, %2] : memref<258x258x258xf64>
            %6 = mulf %cst_0, %5 : f64
            %7 = addf %4, %6 : f64
            %8 = affine.load %arg0[%0 - 1, %1 - 1, %2 + 1] : memref<258x258x258xf64>
            %9 = mulf %cst_1, %8 : f64
            %10 = addf %7, %9 : f64
            %11 = affine.load %arg0[%0 - 1, %1, %2 - 1] : memref<258x258x258xf64>
            %12 = mulf %cst_2, %11 : f64
            %13 = addf %10, %12 : f64
            %14 = affine.load %arg0[%0 - 1, %1, %2] : memref<258x258x258xf64>
            %15 = mulf %cst_3, %14 : f64
            %16 = addf %13, %15 : f64
            %17 = affine.load %arg0[%0 - 1, %1, %2 + 1] : memref<258x258x258xf64>
            %18 = mulf %cst_4, %17 : f64
            %19 = addf %16, %18 : f64
            %20 = affine.load %arg0[%0 - 1, %1 + 1, %2 - 1] : memref<258x258x258xf64>
            %21 = mulf %cst_5, %20 : f64
            %22 = addf %19, %21 : f64
            %23 = affine.load %arg0[%0 - 1, %1 + 1, %2] : memref<258x258x258xf64>
            %24 = mulf %cst_6, %23 : f64
            %25 = addf %22, %24 : f64
            %26 = affine.load %arg0[%0 - 1, %1 + 1, %2 + 1] : memref<258x258x258xf64>
            %27 = mulf %cst_7, %26 : f64
            %28 = addf %25, %27 : f64
            %29 = affine.load %arg0[%0, %1 - 1, %2 - 1] : memref<258x258x258xf64>
            %30 = mulf %cst, %29 : f64
            %31 = addf %28, %30 : f64
            %32 = affine.load %arg0[%0, %1 - 1, %2] : memref<258x258x258xf64>
            %33 = mulf %cst_0, %32 : f64
            %34 = addf %31, %33 : f64
            %35 = affine.load %arg0[%0, %1 - 1, %2 + 1] : memref<258x258x258xf64>
            %36 = mulf %cst_1, %35 : f64
            %37 = addf %34, %36 : f64
            %38 = affine.load %arg0[%0, %1, %2 - 1] : memref<258x258x258xf64>
            %39 = mulf %cst_2, %38 : f64
            %40 = addf %37, %39 : f64
            %41 = affine.load %arg0[%0, %1, %2] : memref<258x258x258xf64>
            %42 = mulf %cst_3, %41 : f64
            %43 = addf %40, %42 : f64
            %44 = affine.load %arg0[%0, %1, %2 + 1] : memref<258x258x258xf64>
            %45 = mulf %cst_4, %44 : f64
            %46 = addf %43, %45 : f64
            %47 = affine.load %arg0[%0, %1 + 1, %2 - 1] : memref<258x258x258xf64>
            %48 = mulf %cst_5, %47 : f64
            %49 = addf %46, %48 : f64
            %50 = affine.load %arg0[%0, %1 + 1, %2] : memref<258x258x258xf64>
            %51 = mulf %cst_6, %50 : f64
            %52 = addf %49, %51 : f64
            %53 = affine.load %arg0[%0, %1 + 1, %2 + 1] : memref<258x258x258xf64>
            %54 = mulf %cst_7, %53 : f64
            %55 = addf %52, %54 : f64
            %56 = affine.load %arg0[%0 + 1, %1 - 1, %2 - 1] : memref<258x258x258xf64>
            %57 = mulf %cst, %56 : f64
            %58 = addf %55, %57 : f64
            %59 = affine.load %arg0[%0 + 1, %1 - 1, %2] : memref<258x258x258xf64>
            %60 = mulf %cst_0, %59 : f64
            %61 = addf %58, %60 : f64
            %62 = affine.load %arg0[%0 + 1, %1 - 1, %2 + 1] : memref<258x258x258xf64>
            %63 = mulf %cst_1, %62 : f64
            %64 = addf %61, %63 : f64
            %65 = affine.load %arg0[%0 + 1, %1, %2 - 1] : memref<258x258x258xf64>
            %66 = mulf %cst_2, %65 : f64
            %67 = addf %64, %66 : f64
            %68 = affine.load %arg0[%0 + 1, %1, %2] : memref<258x258x258xf64>
            %69 = mulf %cst_3, %68 : f64
            %70 = addf %67, %69 : f64
            %71 = affine.load %arg0[%0 + 1, %1, %2 + 1] : memref<258x258x258xf64>
            %72 = mulf %cst_4, %71 : f64
            %73 = addf %70, %72 : f64
            %74 = affine.load %arg0[%0 + 1, %1 + 1, %2 - 1] : memref<258x258x258xf64>
            %75 = mulf %cst_5, %74 : f64
            %76 = addf %73, %75 : f64
            %77 = affine.load %arg0[%0 + 1, %1 + 1, %2] : memref<258x258x258xf64>
            %78 = mulf %cst_6, %77 : f64
            %79 = addf %76, %78 : f64
            %80 = affine.load %arg0[%0 + 1, %1 + 1, %2 + 1] : memref<258x258x258xf64>
            %81 = mulf %cst_7, %80 : f64
            %82 = addf %79, %81 : f64
            affine.store %82, %arg1[%0, %1, %2] : memref<258x258x258xf64>
          }
        }
      }
    }
    return
  }
  func @stencil_3d27pt_box_iteration(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) attributes {llvm.emit_c_interface} {
    call @stencil_3d27pt_box(%arg0, %arg1) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
    call @stencil_3d27pt_box(%arg1, %arg0) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
    return
  }
}
