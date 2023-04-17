module  {
  func @stencil_3d27pt_box(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) attributes {llvm.emit_c_interface} {
    %c0 = constant 0 : index
    %c8 = constant 8 : index
    %c1 = constant 1 : index
    scf.parallel (%arg2, %arg3) = (%c0, %c0) to (%c8, %c8) step (%c1, %c1) {
      %c32 = constant 32 : index
      %0 = muli %arg2, %c32 : index
      %1 = addi %0, %c1 : index
      %c33 = constant 33 : index
      %2 = addi %0, %c33 : index
      scf.for %arg4 = %1 to %2 step %c1 {
        %3 = muli %arg3, %c32 : index
        %4 = addi %3, %c1 : index
        %5 = addi %3, %c33 : index
        scf.for %arg5 = %4 to %5 step %c1 {
          %c257 = constant 257 : index
          scf.for %arg6 = %c1 to %c257 step %c1 {
            %cst = constant 1.000000e-01 : f64
            %c-1 = constant -1 : index
            %6 = addi %arg4, %c-1 : index
            %7 = addi %arg5, %c-1 : index
            %8 = addi %arg6, %c-1 : index
            %9 = memref.load %arg0[%6, %7, %8] : memref<258x258x258xf64>
            %10 = mulf %cst, %9 : f64
            %cst_0 = constant 2.000000e-01 : f64
            %11 = memref.load %arg0[%6, %7, %arg6] : memref<258x258x258xf64>
            %12 = mulf %cst_0, %11 : f64
            %13 = addf %10, %12 : f64
            %cst_1 = constant 3.000000e-01 : f64
            %14 = addi %arg6, %c1 : index
            %15 = memref.load %arg0[%6, %7, %14] : memref<258x258x258xf64>
            %16 = mulf %cst_1, %15 : f64
            %17 = addf %13, %16 : f64
            %cst_2 = constant 4.000000e-01 : f64
            %18 = memref.load %arg0[%6, %arg5, %8] : memref<258x258x258xf64>
            %19 = mulf %cst_2, %18 : f64
            %20 = addf %17, %19 : f64
            %cst_3 = constant 5.000000e-01 : f64
            %21 = memref.load %arg0[%6, %arg5, %arg6] : memref<258x258x258xf64>
            %22 = mulf %cst_3, %21 : f64
            %23 = addf %20, %22 : f64
            %cst_4 = constant 6.000000e-01 : f64
            %24 = memref.load %arg0[%6, %arg5, %14] : memref<258x258x258xf64>
            %25 = mulf %cst_4, %24 : f64
            %26 = addf %23, %25 : f64
            %cst_5 = constant 0.69999999999999996 : f64
            %27 = addi %arg5, %c1 : index
            %28 = memref.load %arg0[%6, %27, %8] : memref<258x258x258xf64>
            %29 = mulf %cst_5, %28 : f64
            %30 = addf %26, %29 : f64
            %cst_6 = constant 8.000000e-01 : f64
            %31 = memref.load %arg0[%6, %27, %arg6] : memref<258x258x258xf64>
            %32 = mulf %cst_6, %31 : f64
            %33 = addf %30, %32 : f64
            %cst_7 = constant 9.000000e-01 : f64
            %34 = memref.load %arg0[%6, %27, %14] : memref<258x258x258xf64>
            %35 = mulf %cst_7, %34 : f64
            %36 = addf %33, %35 : f64
            %37 = memref.load %arg0[%arg4, %7, %8] : memref<258x258x258xf64>
            %38 = mulf %cst, %37 : f64
            %39 = addf %36, %38 : f64
            %40 = memref.load %arg0[%arg4, %7, %arg6] : memref<258x258x258xf64>
            %41 = mulf %cst_0, %40 : f64
            %42 = addf %39, %41 : f64
            %43 = memref.load %arg0[%arg4, %7, %14] : memref<258x258x258xf64>
            %44 = mulf %cst_1, %43 : f64
            %45 = addf %42, %44 : f64
            %46 = memref.load %arg0[%arg4, %arg5, %8] : memref<258x258x258xf64>
            %47 = mulf %cst_2, %46 : f64
            %48 = addf %45, %47 : f64
            %49 = memref.load %arg0[%arg4, %arg5, %arg6] : memref<258x258x258xf64>
            %50 = mulf %cst_3, %49 : f64
            %51 = addf %48, %50 : f64
            %52 = memref.load %arg0[%arg4, %arg5, %14] : memref<258x258x258xf64>
            %53 = mulf %cst_4, %52 : f64
            %54 = addf %51, %53 : f64
            %55 = memref.load %arg0[%arg4, %27, %8] : memref<258x258x258xf64>
            %56 = mulf %cst_5, %55 : f64
            %57 = addf %54, %56 : f64
            %58 = memref.load %arg0[%arg4, %27, %arg6] : memref<258x258x258xf64>
            %59 = mulf %cst_6, %58 : f64
            %60 = addf %57, %59 : f64
            %61 = memref.load %arg0[%arg4, %27, %14] : memref<258x258x258xf64>
            %62 = mulf %cst_7, %61 : f64
            %63 = addf %60, %62 : f64
            %64 = addi %arg4, %c1 : index
            %65 = memref.load %arg0[%64, %7, %8] : memref<258x258x258xf64>
            %66 = mulf %cst, %65 : f64
            %67 = addf %63, %66 : f64
            %68 = memref.load %arg0[%64, %7, %arg6] : memref<258x258x258xf64>
            %69 = mulf %cst_0, %68 : f64
            %70 = addf %67, %69 : f64
            %71 = memref.load %arg0[%64, %7, %14] : memref<258x258x258xf64>
            %72 = mulf %cst_1, %71 : f64
            %73 = addf %70, %72 : f64
            %74 = memref.load %arg0[%64, %arg5, %8] : memref<258x258x258xf64>
            %75 = mulf %cst_2, %74 : f64
            %76 = addf %73, %75 : f64
            %77 = memref.load %arg0[%64, %arg5, %arg6] : memref<258x258x258xf64>
            %78 = mulf %cst_3, %77 : f64
            %79 = addf %76, %78 : f64
            %80 = memref.load %arg0[%64, %arg5, %14] : memref<258x258x258xf64>
            %81 = mulf %cst_4, %80 : f64
            %82 = addf %79, %81 : f64
            %83 = memref.load %arg0[%64, %27, %8] : memref<258x258x258xf64>
            %84 = mulf %cst_5, %83 : f64
            %85 = addf %82, %84 : f64
            %86 = memref.load %arg0[%64, %27, %arg6] : memref<258x258x258xf64>
            %87 = mulf %cst_6, %86 : f64
            %88 = addf %85, %87 : f64
            %89 = memref.load %arg0[%64, %27, %14] : memref<258x258x258xf64>
            %90 = mulf %cst_7, %89 : f64
            %91 = addf %88, %90 : f64
            memref.store %91, %arg1[%arg4, %arg5, %arg6] : memref<258x258x258xf64>
          }
        }
      }
      scf.yield
    }
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
