module  {
  func @stencil_3d27pt_box(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) attributes {llvm.emit_c_interface} {
    %c0 = constant 0 : index
    %c4 = constant 4 : index
    %c8 = constant 8 : index
    %c1 = constant 1 : index
    scf.parallel (%arg2, %arg3, %arg4) = (%c0, %c0, %c0) to (%c4, %c8, %c1) step (%c1, %c1, %c1) {
      scf.parallel (%arg5, %arg6, %arg7) = (%c0, %c0, %c0) to (%c1, %c1, %c8) step (%c1, %c1, %c1) {
        %c64 = constant 64 : index
        %0 = muli %arg2, %c64 : index
        %1 = muli %arg5, %c64 : index
        %2 = addi %0, %1 : index
        %3 = addi %2, %c1 : index
        %c65 = constant 65 : index
        %4 = addi %2, %c65 : index
        scf.for %arg8 = %3 to %4 step %c1 {
          %c32 = constant 32 : index
          %5 = muli %arg3, %c32 : index
          %6 = muli %arg6, %c32 : index
          %7 = addi %5, %6 : index
          %8 = addi %7, %c1 : index
          %c33 = constant 33 : index
          %9 = addi %7, %c33 : index
          scf.for %arg9 = %8 to %9 step %c1 {
            %c256 = constant 256 : index
            %10 = muli %arg4, %c256 : index
            %11 = muli %arg7, %c32 : index
            %12 = addi %10, %11 : index
            %13 = addi %12, %c1 : index
            %14 = addi %12, %c33 : index
            scf.for %arg10 = %13 to %14 step %c1 {
              %cst = constant 1.000000e-01 : f64
              %c-1 = constant -1 : index
              %15 = addi %arg8, %c-1 : index
              %16 = addi %arg9, %c-1 : index
              %17 = addi %arg10, %c-1 : index
              %18 = memref.load %arg0[%15, %16, %17] : memref<258x258x258xf64>
              %19 = mulf %cst, %18 : f64
              %cst_0 = constant 2.000000e-01 : f64
              %20 = memref.load %arg0[%15, %16, %arg10] : memref<258x258x258xf64>
              %21 = mulf %cst_0, %20 : f64
              %22 = addf %19, %21 : f64
              %cst_1 = constant 3.000000e-01 : f64
              %23 = addi %arg10, %c1 : index
              %24 = memref.load %arg0[%15, %16, %23] : memref<258x258x258xf64>
              %25 = mulf %cst_1, %24 : f64
              %26 = addf %22, %25 : f64
              %cst_2 = constant 4.000000e-01 : f64
              %27 = memref.load %arg0[%15, %arg9, %17] : memref<258x258x258xf64>
              %28 = mulf %cst_2, %27 : f64
              %29 = addf %26, %28 : f64
              %cst_3 = constant 5.000000e-01 : f64
              %30 = memref.load %arg0[%15, %arg9, %arg10] : memref<258x258x258xf64>
              %31 = mulf %cst_3, %30 : f64
              %32 = addf %29, %31 : f64
              %cst_4 = constant 6.000000e-01 : f64
              %33 = memref.load %arg0[%15, %arg9, %23] : memref<258x258x258xf64>
              %34 = mulf %cst_4, %33 : f64
              %35 = addf %32, %34 : f64
              %cst_5 = constant 0.69999999999999996 : f64
              %36 = addi %arg9, %c1 : index
              %37 = memref.load %arg0[%15, %36, %17] : memref<258x258x258xf64>
              %38 = mulf %cst_5, %37 : f64
              %39 = addf %35, %38 : f64
              %cst_6 = constant 8.000000e-01 : f64
              %40 = memref.load %arg0[%15, %36, %arg10] : memref<258x258x258xf64>
              %41 = mulf %cst_6, %40 : f64
              %42 = addf %39, %41 : f64
              %cst_7 = constant 9.000000e-01 : f64
              %43 = memref.load %arg0[%15, %36, %23] : memref<258x258x258xf64>
              %44 = mulf %cst_7, %43 : f64
              %45 = addf %42, %44 : f64
              %46 = memref.load %arg0[%arg8, %16, %17] : memref<258x258x258xf64>
              %47 = mulf %cst, %46 : f64
              %48 = addf %45, %47 : f64
              %49 = memref.load %arg0[%arg8, %16, %arg10] : memref<258x258x258xf64>
              %50 = mulf %cst_0, %49 : f64
              %51 = addf %48, %50 : f64
              %52 = memref.load %arg0[%arg8, %16, %23] : memref<258x258x258xf64>
              %53 = mulf %cst_1, %52 : f64
              %54 = addf %51, %53 : f64
              %55 = memref.load %arg0[%arg8, %arg9, %17] : memref<258x258x258xf64>
              %56 = mulf %cst_2, %55 : f64
              %57 = addf %54, %56 : f64
              %58 = memref.load %arg0[%arg8, %arg9, %arg10] : memref<258x258x258xf64>
              %59 = mulf %cst_3, %58 : f64
              %60 = addf %57, %59 : f64
              %61 = memref.load %arg0[%arg8, %arg9, %23] : memref<258x258x258xf64>
              %62 = mulf %cst_4, %61 : f64
              %63 = addf %60, %62 : f64
              %64 = memref.load %arg0[%arg8, %36, %17] : memref<258x258x258xf64>
              %65 = mulf %cst_5, %64 : f64
              %66 = addf %63, %65 : f64
              %67 = memref.load %arg0[%arg8, %36, %arg10] : memref<258x258x258xf64>
              %68 = mulf %cst_6, %67 : f64
              %69 = addf %66, %68 : f64
              %70 = memref.load %arg0[%arg8, %36, %23] : memref<258x258x258xf64>
              %71 = mulf %cst_7, %70 : f64
              %72 = addf %69, %71 : f64
              %73 = addi %arg8, %c1 : index
              %74 = memref.load %arg0[%73, %16, %17] : memref<258x258x258xf64>
              %75 = mulf %cst, %74 : f64
              %76 = addf %72, %75 : f64
              %77 = memref.load %arg0[%73, %16, %arg10] : memref<258x258x258xf64>
              %78 = mulf %cst_0, %77 : f64
              %79 = addf %76, %78 : f64
              %80 = memref.load %arg0[%73, %16, %23] : memref<258x258x258xf64>
              %81 = mulf %cst_1, %80 : f64
              %82 = addf %79, %81 : f64
              %83 = memref.load %arg0[%73, %arg9, %17] : memref<258x258x258xf64>
              %84 = mulf %cst_2, %83 : f64
              %85 = addf %82, %84 : f64
              %86 = memref.load %arg0[%73, %arg9, %arg10] : memref<258x258x258xf64>
              %87 = mulf %cst_3, %86 : f64
              %88 = addf %85, %87 : f64
              %89 = memref.load %arg0[%73, %arg9, %23] : memref<258x258x258xf64>
              %90 = mulf %cst_4, %89 : f64
              %91 = addf %88, %90 : f64
              %92 = memref.load %arg0[%73, %36, %17] : memref<258x258x258xf64>
              %93 = mulf %cst_5, %92 : f64
              %94 = addf %91, %93 : f64
              %95 = memref.load %arg0[%73, %36, %arg10] : memref<258x258x258xf64>
              %96 = mulf %cst_6, %95 : f64
              %97 = addf %94, %96 : f64
              %98 = memref.load %arg0[%73, %36, %23] : memref<258x258x258xf64>
              %99 = mulf %cst_7, %98 : f64
              %100 = addf %97, %99 : f64
              memref.store %100, %arg1[%arg8, %arg9, %arg10] : memref<258x258x258xf64>
            }
          }
        }
        scf.yield
      } {mapping = [{bound = affine_map<(d0) -> (d0)>, map = affine_map<(d0) -> (d0)>, processor = 3 : i64}, {bound = affine_map<(d0) -> (d0)>, map = affine_map<(d0) -> (d0)>, processor = 4 : i64}, {bound = affine_map<(d0) -> (d0)>, map = affine_map<(d0) -> (d0)>, processor = 5 : i64}]}
      scf.yield
    } {mapping = [{bound = affine_map<(d0) -> (d0)>, map = affine_map<(d0) -> (d0)>, processor = 0 : i64}, {bound = affine_map<(d0) -> (d0)>, map = affine_map<(d0) -> (d0)>, processor = 1 : i64}, {bound = affine_map<(d0) -> (d0)>, map = affine_map<(d0) -> (d0)>, processor = 2 : i64}]}
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
