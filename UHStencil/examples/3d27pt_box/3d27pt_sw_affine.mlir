module  {
  func @stencil_3d27pt_box(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) attributes {llvm.emit_c_interface} {
    affine.parallel (%arg2, %arg3) = (0, 0) to (8, 8) {
      affine.for %arg4 = affine_map<(d0) -> (d0 * 32 + 1)>(%arg2) to affine_map<(d0) -> (d0 * 32 + 33)>(%arg2) {
        affine.for %arg5 = affine_map<(d0) -> (d0 * 32 + 1)>(%arg3) to affine_map<(d0) -> (d0 * 32 + 33)>(%arg3) {
          affine.for %arg6 = 1 to 257 {
            %cst = constant 1.000000e-01 : f64
            %0 = affine.load %arg0[%arg4 - 1, %arg5 - 1, %arg6 - 1] : memref<258x258x258xf64>
            %1 = mulf %cst, %0 : f64
            %cst_0 = constant 2.000000e-01 : f64
            %2 = affine.load %arg0[%arg4 - 1, %arg5 - 1, %arg6] : memref<258x258x258xf64>
            %3 = mulf %cst_0, %2 : f64
            %4 = addf %1, %3 : f64
            %cst_1 = constant 3.000000e-01 : f64
            %5 = affine.load %arg0[%arg4 - 1, %arg5 - 1, %arg6 + 1] : memref<258x258x258xf64>
            %6 = mulf %cst_1, %5 : f64
            %7 = addf %4, %6 : f64
            %cst_2 = constant 4.000000e-01 : f64
            %8 = affine.load %arg0[%arg4 - 1, %arg5, %arg6 - 1] : memref<258x258x258xf64>
            %9 = mulf %cst_2, %8 : f64
            %10 = addf %7, %9 : f64
            %cst_3 = constant 5.000000e-01 : f64
            %11 = affine.load %arg0[%arg4 - 1, %arg5, %arg6] : memref<258x258x258xf64>
            %12 = mulf %cst_3, %11 : f64
            %13 = addf %10, %12 : f64
            %cst_4 = constant 6.000000e-01 : f64
            %14 = affine.load %arg0[%arg4 - 1, %arg5, %arg6 + 1] : memref<258x258x258xf64>
            %15 = mulf %cst_4, %14 : f64
            %16 = addf %13, %15 : f64
            %cst_5 = constant 0.69999999999999996 : f64
            %17 = affine.load %arg0[%arg4 - 1, %arg5 + 1, %arg6 - 1] : memref<258x258x258xf64>
            %18 = mulf %cst_5, %17 : f64
            %19 = addf %16, %18 : f64
            %cst_6 = constant 8.000000e-01 : f64
            %20 = affine.load %arg0[%arg4 - 1, %arg5 + 1, %arg6] : memref<258x258x258xf64>
            %21 = mulf %cst_6, %20 : f64
            %22 = addf %19, %21 : f64
            %cst_7 = constant 9.000000e-01 : f64
            %23 = affine.load %arg0[%arg4 - 1, %arg5 + 1, %arg6 + 1] : memref<258x258x258xf64>
            %24 = mulf %cst_7, %23 : f64
            %25 = addf %22, %24 : f64
            %26 = affine.load %arg0[%arg4, %arg5 - 1, %arg6 - 1] : memref<258x258x258xf64>
            %27 = mulf %cst, %26 : f64
            %28 = addf %25, %27 : f64
            %29 = affine.load %arg0[%arg4, %arg5 - 1, %arg6] : memref<258x258x258xf64>
            %30 = mulf %cst_0, %29 : f64
            %31 = addf %28, %30 : f64
            %32 = affine.load %arg0[%arg4, %arg5 - 1, %arg6 + 1] : memref<258x258x258xf64>
            %33 = mulf %cst_1, %32 : f64
            %34 = addf %31, %33 : f64
            %35 = affine.load %arg0[%arg4, %arg5, %arg6 - 1] : memref<258x258x258xf64>
            %36 = mulf %cst_2, %35 : f64
            %37 = addf %34, %36 : f64
            %38 = affine.load %arg0[%arg4, %arg5, %arg6] : memref<258x258x258xf64>
            %39 = mulf %cst_3, %38 : f64
            %40 = addf %37, %39 : f64
            %41 = affine.load %arg0[%arg4, %arg5, %arg6 + 1] : memref<258x258x258xf64>
            %42 = mulf %cst_4, %41 : f64
            %43 = addf %40, %42 : f64
            %44 = affine.load %arg0[%arg4, %arg5 + 1, %arg6 - 1] : memref<258x258x258xf64>
            %45 = mulf %cst_5, %44 : f64
            %46 = addf %43, %45 : f64
            %47 = affine.load %arg0[%arg4, %arg5 + 1, %arg6] : memref<258x258x258xf64>
            %48 = mulf %cst_6, %47 : f64
            %49 = addf %46, %48 : f64
            %50 = affine.load %arg0[%arg4, %arg5 + 1, %arg6 + 1] : memref<258x258x258xf64>
            %51 = mulf %cst_7, %50 : f64
            %52 = addf %49, %51 : f64
            %53 = affine.load %arg0[%arg4 + 1, %arg5 - 1, %arg6 - 1] : memref<258x258x258xf64>
            %54 = mulf %cst, %53 : f64
            %55 = addf %52, %54 : f64
            %56 = affine.load %arg0[%arg4 + 1, %arg5 - 1, %arg6] : memref<258x258x258xf64>
            %57 = mulf %cst_0, %56 : f64
            %58 = addf %55, %57 : f64
            %59 = affine.load %arg0[%arg4 + 1, %arg5 - 1, %arg6 + 1] : memref<258x258x258xf64>
            %60 = mulf %cst_1, %59 : f64
            %61 = addf %58, %60 : f64
            %62 = affine.load %arg0[%arg4 + 1, %arg5, %arg6 - 1] : memref<258x258x258xf64>
            %63 = mulf %cst_2, %62 : f64
            %64 = addf %61, %63 : f64
            %65 = affine.load %arg0[%arg4 + 1, %arg5, %arg6] : memref<258x258x258xf64>
            %66 = mulf %cst_3, %65 : f64
            %67 = addf %64, %66 : f64
            %68 = affine.load %arg0[%arg4 + 1, %arg5, %arg6 + 1] : memref<258x258x258xf64>
            %69 = mulf %cst_4, %68 : f64
            %70 = addf %67, %69 : f64
            %71 = affine.load %arg0[%arg4 + 1, %arg5 + 1, %arg6 - 1] : memref<258x258x258xf64>
            %72 = mulf %cst_5, %71 : f64
            %73 = addf %70, %72 : f64
            %74 = affine.load %arg0[%arg4 + 1, %arg5 + 1, %arg6] : memref<258x258x258xf64>
            %75 = mulf %cst_6, %74 : f64
            %76 = addf %73, %75 : f64
            %77 = affine.load %arg0[%arg4 + 1, %arg5 + 1, %arg6 + 1] : memref<258x258x258xf64>
            %78 = mulf %cst_7, %77 : f64
            %79 = addf %76, %78 : f64
            affine.store %79, %arg1[%arg4, %arg5, %arg6] : memref<258x258x258xf64>
          }
        }
      }
    } {num_dimension = 2 : index, parallelTag = "cpe"}
    return
  }
  func @stencil_3d27pt_box_iteration(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) attributes {llvm.emit_c_interface} {
    %c0 = constant 0 : index
    %c1 = constant 1 : index
    scf.for %arg2 = %c0 to %c1 step %c1 {
      call @stencil_3d27pt_box(%arg0, %arg1) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
      call @stencil_3d27pt_box(%arg1, %arg0) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
    }
    return
  }
}
// ####### AccessOpLowering #######
// ####### AccessOpLowering #######
// ####### AccessOpLowering #######
// ####### AccessOpLowering #######
// ####### AccessOpLowering #######
// ####### AccessOpLowering #######
// ####### AccessOpLowering #######
// ####### AccessOpLowering #######
// ####### AccessOpLowering #######
// ####### AccessOpLowering #######
// ####### AccessOpLowering #######
// ####### AccessOpLowering #######
// ####### AccessOpLowering #######
// ####### AccessOpLowering #######
// ####### AccessOpLowering #######
// ####### AccessOpLowering #######
// ####### AccessOpLowering #######
// ####### AccessOpLowering #######
// ####### AccessOpLowering #######
// ####### AccessOpLowering #######
// ####### AccessOpLowering #######
// ####### AccessOpLowering #######
// ####### AccessOpLowering #######
// ####### AccessOpLowering #######
// ####### AccessOpLowering #######
// ####### AccessOpLowering #######
// ####### AccessOpLowering #######
// ####### StoreOpLowering #######
