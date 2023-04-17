module  {
  func @stencil_3d27pt_box(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) attributes {hardware = "sw", llvm.emit_c_interface, std.stencil_program} {
    %c0 = constant 0 : index
    %c8 = constant 8 : index
    %c4 = constant 4 : index
    %c2 = constant 2 : index
    %c1 = constant 1 : index
    scf.parallel (%arg2, %arg3, %arg4) = (%c0, %c0, %c0) to (%c8, %c4, %c2) step (%c1, %c1, %c1) {
      %c128 = constant 128 : index
      %0 = muli %arg4, %c128 : index
      %1 = addi %0, %c1 : index
      %c129 = constant 129 : index
      %2 = addi %0, %c129 : index
      %c16 = constant 16 : index
      scf.for %arg5 = %1 to %2 step %c16 {
        %c64 = constant 64 : index
        %3 = muli %arg3, %c64 : index
        %4 = addi %3, %c1 : index
        %c65 = constant 65 : index
        %5 = addi %3, %c65 : index
        scf.for %arg6 = %4 to %5 step %c16 {
          %c32 = constant 32 : index
          %6 = muli %arg2, %c32 : index
          %7 = addi %6, %c1 : index
          %c33 = constant 33 : index
          %8 = addi %6, %c33 : index
          scf.for %arg7 = %7 to %8 step %c16 {
            %9 = memref.alloc() {readOrWrite = "write", swdma_bsize = 16 : i64, swdma_cnt = 256 : i64, swdma_stride = 242 : i64, swdma_zDim = 16 : i64} : memref<16x16x16xf64, 3>
            %10 = memref.alloc() {readOrWrite = "read", swdma_bsize = 18 : i64, swdma_cnt = 324 : i64, swdma_stride = i64 : i64, swdma_zDim = 18 : i64} : memref<18x18x18xf64, 3>
            gpu.barrier
            scf.for %arg8 = %c0 to %c16 step %c1 {
              scf.for %arg9 = %c0 to %c16 step %c1 {
                scf.for %arg10 = %c0 to %c16 step %c1 {
                  %cst = constant 1.000000e-01 : f64
                  %11 = memref.load %10[%arg8, %arg9, %arg10] : memref<18x18x18xf64, 3>
                  %12 = mulf %cst, %11 : f64
                  %cst_0 = constant 2.000000e-01 : f64
                  %13 = addi %arg10, %c1 : index
                  %14 = memref.load %10[%arg8, %arg9, %13] : memref<18x18x18xf64, 3>
                  %15 = mulf %cst_0, %14 : f64
                  %16 = addf %12, %15 : f64
                  %cst_1 = constant 3.000000e-01 : f64
                  %17 = addi %arg10, %c2 : index
                  %18 = memref.load %10[%arg8, %arg9, %17] : memref<18x18x18xf64, 3>
                  %19 = mulf %cst_1, %18 : f64
                  %20 = addf %16, %19 : f64
                  %cst_2 = constant 4.000000e-01 : f64
                  %21 = addi %arg9, %c1 : index
                  %22 = memref.load %10[%arg8, %21, %arg10] : memref<18x18x18xf64, 3>
                  %23 = mulf %cst_2, %22 : f64
                  %24 = addf %20, %23 : f64
                  %cst_3 = constant 5.000000e-01 : f64
                  %25 = memref.load %10[%arg8, %21, %13] : memref<18x18x18xf64, 3>
                  %26 = mulf %cst_3, %25 : f64
                  %27 = addf %24, %26 : f64
                  %cst_4 = constant 6.000000e-01 : f64
                  %28 = memref.load %10[%arg8, %21, %17] : memref<18x18x18xf64, 3>
                  %29 = mulf %cst_4, %28 : f64
                  %30 = addf %27, %29 : f64
                  %cst_5 = constant 0.69999999999999996 : f64
                  %31 = addi %arg9, %c2 : index
                  %32 = memref.load %10[%arg8, %31, %arg10] : memref<18x18x18xf64, 3>
                  %33 = mulf %cst_5, %32 : f64
                  %34 = addf %30, %33 : f64
                  %cst_6 = constant 8.000000e-01 : f64
                  %35 = memref.load %10[%arg8, %31, %13] : memref<18x18x18xf64, 3>
                  %36 = mulf %cst_6, %35 : f64
                  %37 = addf %34, %36 : f64
                  %cst_7 = constant 9.000000e-01 : f64
                  %38 = memref.load %10[%arg8, %31, %17] : memref<18x18x18xf64, 3>
                  %39 = mulf %cst_7, %38 : f64
                  %40 = addf %37, %39 : f64
                  %41 = addi %arg8, %c1 : index
                  %42 = memref.load %10[%41, %arg9, %arg10] : memref<18x18x18xf64, 3>
                  %43 = mulf %cst, %42 : f64
                  %44 = addf %40, %43 : f64
                  %45 = memref.load %10[%41, %arg9, %13] : memref<18x18x18xf64, 3>
                  %46 = mulf %cst_0, %45 : f64
                  %47 = addf %44, %46 : f64
                  %48 = memref.load %10[%41, %arg9, %17] : memref<18x18x18xf64, 3>
                  %49 = mulf %cst_1, %48 : f64
                  %50 = addf %47, %49 : f64
                  %51 = memref.load %10[%41, %21, %arg10] : memref<18x18x18xf64, 3>
                  %52 = mulf %cst_2, %51 : f64
                  %53 = addf %50, %52 : f64
                  %54 = memref.load %10[%41, %21, %13] : memref<18x18x18xf64, 3>
                  %55 = mulf %cst_3, %54 : f64
                  %56 = addf %53, %55 : f64
                  %57 = memref.load %10[%41, %21, %17] : memref<18x18x18xf64, 3>
                  %58 = mulf %cst_4, %57 : f64
                  %59 = addf %56, %58 : f64
                  %60 = memref.load %10[%41, %31, %arg10] : memref<18x18x18xf64, 3>
                  %61 = mulf %cst_5, %60 : f64
                  %62 = addf %59, %61 : f64
                  %63 = memref.load %10[%41, %31, %13] : memref<18x18x18xf64, 3>
                  %64 = mulf %cst_6, %63 : f64
                  %65 = addf %62, %64 : f64
                  %66 = memref.load %10[%41, %31, %17] : memref<18x18x18xf64, 3>
                  %67 = mulf %cst_7, %66 : f64
                  %68 = addf %65, %67 : f64
                  %69 = addi %arg8, %c2 : index
                  %70 = memref.load %10[%69, %arg9, %arg10] : memref<18x18x18xf64, 3>
                  %71 = mulf %cst, %70 : f64
                  %72 = addf %68, %71 : f64
                  %73 = memref.load %10[%69, %arg9, %13] : memref<18x18x18xf64, 3>
                  %74 = mulf %cst_0, %73 : f64
                  %75 = addf %72, %74 : f64
                  %76 = memref.load %10[%69, %arg9, %17] : memref<18x18x18xf64, 3>
                  %77 = mulf %cst_1, %76 : f64
                  %78 = addf %75, %77 : f64
                  %79 = memref.load %10[%69, %21, %arg10] : memref<18x18x18xf64, 3>
                  %80 = mulf %cst_2, %79 : f64
                  %81 = addf %78, %80 : f64
                  %82 = memref.load %10[%69, %21, %13] : memref<18x18x18xf64, 3>
                  %83 = mulf %cst_3, %82 : f64
                  %84 = addf %81, %83 : f64
                  %85 = memref.load %10[%69, %21, %17] : memref<18x18x18xf64, 3>
                  %86 = mulf %cst_4, %85 : f64
                  %87 = addf %84, %86 : f64
                  %88 = memref.load %10[%69, %31, %arg10] : memref<18x18x18xf64, 3>
                  %89 = mulf %cst_5, %88 : f64
                  %90 = addf %87, %89 : f64
                  %91 = memref.load %10[%69, %31, %13] : memref<18x18x18xf64, 3>
                  %92 = mulf %cst_6, %91 : f64
                  %93 = addf %90, %92 : f64
                  %94 = memref.load %10[%69, %31, %17] : memref<18x18x18xf64, 3>
                  %95 = mulf %cst_7, %94 : f64
                  %96 = addf %93, %95 : f64
                  memref.store %96, %9[%arg8, %arg9, %arg10] : memref<16x16x16xf64, 3>
                }
              }
            }
            gpu.barrier
          }
        }
      }
      scf.yield
    }
    return
  }
  func @stencil_3d27pt_box_iteration(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) attributes {llvm.emit_c_interface, std.stencil_iteration} {
    %c0 = constant 0 : index
    %c1 = constant 1 : index
    scf.for %arg2 = %c0 to %c1 step %c1 {
      call @stencil_3d27pt_box(%arg0, %arg1) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
      call @stencil_3d27pt_box(%arg1, %arg0) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
    }
    return
  }
}
