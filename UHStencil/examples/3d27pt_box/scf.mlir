// -----// IR Dump After StencilToStdPass //----- //
module  {
  func @stencil_3d27pt_box(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) attributes {llvm.emit_c_interface} {
    %0 = memref.alloc() : memref<258x258x258xf64>
    affine.for %arg2 = 1 to 257 {
      affine.for %arg3 = 1 to 257 {
        affine.for %arg4 = 1 to 257 {
          %cst = constant 1.000000e-01 : f64
          %1 = affine.load %arg0[%arg2 - 1, %arg3 - 1, %arg4 - 1] : memref<258x258x258xf64>
          %2 = mulf %cst, %1 : f64
          %cst_0 = constant 2.000000e-01 : f64
          %3 = affine.load %arg0[%arg2 - 1, %arg3 - 1, %arg4] : memref<258x258x258xf64>
          %4 = mulf %cst_0, %3 : f64
          %5 = addf %2, %4 : f64
          %cst_1 = constant 3.000000e-01 : f64
          %6 = affine.load %arg0[%arg2 - 1, %arg3 - 1, %arg4 + 1] : memref<258x258x258xf64>
          %7 = mulf %cst_1, %6 : f64
          %8 = addf %5, %7 : f64
          %cst_2 = constant 4.000000e-01 : f64
          %9 = affine.load %arg0[%arg2 - 1, %arg3, %arg4 - 1] : memref<258x258x258xf64>
          %10 = mulf %cst_2, %9 : f64
          %11 = addf %8, %10 : f64
          %cst_3 = constant 5.000000e-01 : f64
          %12 = affine.load %arg0[%arg2 - 1, %arg3, %arg4] : memref<258x258x258xf64>
          %13 = mulf %cst_3, %12 : f64
          %14 = addf %11, %13 : f64
          %cst_4 = constant 6.000000e-01 : f64
          %15 = affine.load %arg0[%arg2 - 1, %arg3, %arg4 + 1] : memref<258x258x258xf64>
          %16 = mulf %cst_4, %15 : f64
          %17 = addf %14, %16 : f64
          %cst_5 = constant 0.69999999999999996 : f64
          %18 = affine.load %arg0[%arg2 - 1, %arg3 + 1, %arg4 - 1] : memref<258x258x258xf64>
          %19 = mulf %cst_5, %18 : f64
          %20 = addf %17, %19 : f64
          %cst_6 = constant 8.000000e-01 : f64
          %21 = affine.load %arg0[%arg2 - 1, %arg3 + 1, %arg4] : memref<258x258x258xf64>
          %22 = mulf %cst_6, %21 : f64
          %23 = addf %20, %22 : f64
          %cst_7 = constant 9.000000e-01 : f64
          %24 = affine.load %arg0[%arg2 - 1, %arg3 + 1, %arg4 + 1] : memref<258x258x258xf64>
          %25 = mulf %cst_7, %24 : f64
          %26 = addf %23, %25 : f64
          %cst_8 = constant 1.000000e-01 : f64
          %27 = affine.load %arg0[%arg2, %arg3 - 1, %arg4 - 1] : memref<258x258x258xf64>
          %28 = mulf %cst_8, %27 : f64
          %29 = addf %26, %28 : f64
          %cst_9 = constant 2.000000e-01 : f64
          %30 = affine.load %arg0[%arg2, %arg3 - 1, %arg4] : memref<258x258x258xf64>
          %31 = mulf %cst_9, %30 : f64
          %32 = addf %29, %31 : f64
          %cst_10 = constant 3.000000e-01 : f64
          %33 = affine.load %arg0[%arg2, %arg3 - 1, %arg4 + 1] : memref<258x258x258xf64>
          %34 = mulf %cst_10, %33 : f64
          %35 = addf %32, %34 : f64
          %cst_11 = constant 4.000000e-01 : f64
          %36 = affine.load %arg0[%arg2, %arg3, %arg4 - 1] : memref<258x258x258xf64>
          %37 = mulf %cst_11, %36 : f64
          %38 = addf %35, %37 : f64
          %cst_12 = constant 5.000000e-01 : f64
          %39 = affine.load %arg0[%arg2, %arg3, %arg4] : memref<258x258x258xf64>
          %40 = mulf %cst_12, %39 : f64
          %41 = addf %38, %40 : f64
          %cst_13 = constant 6.000000e-01 : f64
          %42 = affine.load %arg0[%arg2, %arg3, %arg4 + 1] : memref<258x258x258xf64>
          %43 = mulf %cst_13, %42 : f64
          %44 = addf %41, %43 : f64
          %cst_14 = constant 0.69999999999999996 : f64
          %45 = affine.load %arg0[%arg2, %arg3 + 1, %arg4 - 1] : memref<258x258x258xf64>
          %46 = mulf %cst_14, %45 : f64
          %47 = addf %44, %46 : f64
          %cst_15 = constant 8.000000e-01 : f64
          %48 = affine.load %arg0[%arg2, %arg3 + 1, %arg4] : memref<258x258x258xf64>
          %49 = mulf %cst_15, %48 : f64
          %50 = addf %47, %49 : f64
          %cst_16 = constant 9.000000e-01 : f64
          %51 = affine.load %arg0[%arg2, %arg3 + 1, %arg4 + 1] : memref<258x258x258xf64>
          %52 = mulf %cst_16, %51 : f64
          %53 = addf %50, %52 : f64
          %cst_17 = constant 1.000000e-01 : f64
          %54 = affine.load %arg0[%arg2 + 1, %arg3 - 1, %arg4 - 1] : memref<258x258x258xf64>
          %55 = mulf %cst_17, %54 : f64
          %56 = addf %53, %55 : f64
          %cst_18 = constant 2.000000e-01 : f64
          %57 = affine.load %arg0[%arg2 + 1, %arg3 - 1, %arg4] : memref<258x258x258xf64>
          %58 = mulf %cst_18, %57 : f64
          %59 = addf %56, %58 : f64
          %cst_19 = constant 3.000000e-01 : f64
          %60 = affine.load %arg0[%arg2 + 1, %arg3 - 1, %arg4 + 1] : memref<258x258x258xf64>
          %61 = mulf %cst_19, %60 : f64
          %62 = addf %59, %61 : f64
          %cst_20 = constant 4.000000e-01 : f64
          %63 = affine.load %arg0[%arg2 + 1, %arg3, %arg4 - 1] : memref<258x258x258xf64>
          %64 = mulf %cst_20, %63 : f64
          %65 = addf %62, %64 : f64
          %cst_21 = constant 5.000000e-01 : f64
          %66 = affine.load %arg0[%arg2 + 1, %arg3, %arg4] : memref<258x258x258xf64>
          %67 = mulf %cst_21, %66 : f64
          %68 = addf %65, %67 : f64
          %cst_22 = constant 6.000000e-01 : f64
          %69 = affine.load %arg0[%arg2 + 1, %arg3, %arg4 + 1] : memref<258x258x258xf64>
          %70 = mulf %cst_22, %69 : f64
          %71 = addf %68, %70 : f64
          %cst_23 = constant 0.69999999999999996 : f64
          %72 = affine.load %arg0[%arg2 + 1, %arg3 + 1, %arg4 - 1] : memref<258x258x258xf64>
          %73 = mulf %cst_23, %72 : f64
          %74 = addf %71, %73 : f64
          %cst_24 = constant 8.000000e-01 : f64
          %75 = affine.load %arg0[%arg2 + 1, %arg3 + 1, %arg4] : memref<258x258x258xf64>
          %76 = mulf %cst_24, %75 : f64
          %77 = addf %74, %76 : f64
          %cst_25 = constant 9.000000e-01 : f64
          %78 = affine.load %arg0[%arg2 + 1, %arg3 + 1, %arg4 + 1] : memref<258x258x258xf64>
          %79 = mulf %cst_25, %78 : f64
          %80 = addf %77, %79 : f64
          affine.store %80, %arg1[%arg2, %arg3, %arg4] : memref<258x258x258xf64>
        }
      }
    }
    return
  }
  func @stencil_3d27pt_box_iteration(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) attributes {llvm.emit_c_interface} {
    %c0 = constant 0 : index
    %c1 = constant 1 : index
    %c1_0 = constant 1 : index
    scf.for %arg2 = %c0 to %c1 step %c1_0 {
      call @stencil_3d27pt_box(%arg0, %arg1) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
      call @stencil_3d27pt_box(%arg1, %arg0) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
    }
    return
  }
}


// -----// IR Dump After Canonicalizer //----- //
func @stencil_3d27pt_box_iteration(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) attributes {llvm.emit_c_interface} {
  call @stencil_3d27pt_box(%arg0, %arg1) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
  call @stencil_3d27pt_box(%arg1, %arg0) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
  return
}

// -----// IR Dump After UHAffineToParallelPass //----- //
func @stencil_3d27pt_box_iteration(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) attributes {llvm.emit_c_interface} {
  call @stencil_3d27pt_box(%arg0, %arg1) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
  call @stencil_3d27pt_box(%arg1, %arg0) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
  return
}

// -----// IR Dump After Canonicalizer //----- //
func @stencil_3d27pt_box_iteration(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) attributes {llvm.emit_c_interface} {
  call @stencil_3d27pt_box(%arg0, %arg1) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
  call @stencil_3d27pt_box(%arg1, %arg0) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
  return
}

// -----// IR Dump After UHTilingToParallelPass //----- //
func @stencil_3d27pt_box_iteration(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) attributes {llvm.emit_c_interface} {
  call @stencil_3d27pt_box(%arg0, %arg1) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
  call @stencil_3d27pt_box(%arg1, %arg0) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
  return
}

// -----// IR Dump After AffineInnerTilingPass //----- //
func @stencil_3d27pt_box_iteration(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) attributes {llvm.emit_c_interface} {
  call @stencil_3d27pt_box(%arg0, %arg1) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
  call @stencil_3d27pt_box(%arg1, %arg0) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
  return
}

// -----// IR Dump After CollapseAffineParallelPass //----- //
func @stencil_3d27pt_box_iteration(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) attributes {llvm.emit_c_interface} {
  call @stencil_3d27pt_box(%arg0, %arg1) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
  call @stencil_3d27pt_box(%arg1, %arg0) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
  return
}

// -----// IR Dump After Canonicalizer //----- //
func @stencil_3d27pt_box(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) attributes {llvm.emit_c_interface} {
  %cst = constant 9.000000e-01 : f64
  %cst_0 = constant 8.000000e-01 : f64
  %cst_1 = constant 0.69999999999999996 : f64
  %cst_2 = constant 6.000000e-01 : f64
  %cst_3 = constant 5.000000e-01 : f64
  %cst_4 = constant 4.000000e-01 : f64
  %cst_5 = constant 3.000000e-01 : f64
  %cst_6 = constant 2.000000e-01 : f64
  %cst_7 = constant 1.000000e-01 : f64
  affine.for %arg2 = 1 to 257 {
    affine.for %arg3 = 1 to 257 {
      affine.for %arg4 = 1 to 257 {
        %0 = affine.load %arg0[%arg2 - 1, %arg3 - 1, %arg4 - 1] : memref<258x258x258xf64>
        %1 = mulf %cst_7, %0 : f64
        %2 = affine.load %arg0[%arg2 - 1, %arg3 - 1, %arg4] : memref<258x258x258xf64>
        %3 = mulf %cst_6, %2 : f64
        %4 = addf %1, %3 : f64
        %5 = affine.load %arg0[%arg2 - 1, %arg3 - 1, %arg4 + 1] : memref<258x258x258xf64>
        %6 = mulf %cst_5, %5 : f64
        %7 = addf %4, %6 : f64
        %8 = affine.load %arg0[%arg2 - 1, %arg3, %arg4 - 1] : memref<258x258x258xf64>
        %9 = mulf %cst_4, %8 : f64
        %10 = addf %7, %9 : f64
        %11 = affine.load %arg0[%arg2 - 1, %arg3, %arg4] : memref<258x258x258xf64>
        %12 = mulf %cst_3, %11 : f64
        %13 = addf %10, %12 : f64
        %14 = affine.load %arg0[%arg2 - 1, %arg3, %arg4 + 1] : memref<258x258x258xf64>
        %15 = mulf %cst_2, %14 : f64
        %16 = addf %13, %15 : f64
        %17 = affine.load %arg0[%arg2 - 1, %arg3 + 1, %arg4 - 1] : memref<258x258x258xf64>
        %18 = mulf %cst_1, %17 : f64
        %19 = addf %16, %18 : f64
        %20 = affine.load %arg0[%arg2 - 1, %arg3 + 1, %arg4] : memref<258x258x258xf64>
        %21 = mulf %cst_0, %20 : f64
        %22 = addf %19, %21 : f64
        %23 = affine.load %arg0[%arg2 - 1, %arg3 + 1, %arg4 + 1] : memref<258x258x258xf64>
        %24 = mulf %cst, %23 : f64
        %25 = addf %22, %24 : f64
        %26 = affine.load %arg0[%arg2, %arg3 - 1, %arg4 - 1] : memref<258x258x258xf64>
        %27 = mulf %cst_7, %26 : f64
        %28 = addf %25, %27 : f64
        %29 = affine.load %arg0[%arg2, %arg3 - 1, %arg4] : memref<258x258x258xf64>
        %30 = mulf %cst_6, %29 : f64
        %31 = addf %28, %30 : f64
        %32 = affine.load %arg0[%arg2, %arg3 - 1, %arg4 + 1] : memref<258x258x258xf64>
        %33 = mulf %cst_5, %32 : f64
        %34 = addf %31, %33 : f64
        %35 = affine.load %arg0[%arg2, %arg3, %arg4 - 1] : memref<258x258x258xf64>
        %36 = mulf %cst_4, %35 : f64
        %37 = addf %34, %36 : f64
        %38 = affine.load %arg0[%arg2, %arg3, %arg4] : memref<258x258x258xf64>
        %39 = mulf %cst_3, %38 : f64
        %40 = addf %37, %39 : f64
        %41 = affine.load %arg0[%arg2, %arg3, %arg4 + 1] : memref<258x258x258xf64>
        %42 = mulf %cst_2, %41 : f64
        %43 = addf %40, %42 : f64
        %44 = affine.load %arg0[%arg2, %arg3 + 1, %arg4 - 1] : memref<258x258x258xf64>
        %45 = mulf %cst_1, %44 : f64
        %46 = addf %43, %45 : f64
        %47 = affine.load %arg0[%arg2, %arg3 + 1, %arg4] : memref<258x258x258xf64>
        %48 = mulf %cst_0, %47 : f64
        %49 = addf %46, %48 : f64
        %50 = affine.load %arg0[%arg2, %arg3 + 1, %arg4 + 1] : memref<258x258x258xf64>
        %51 = mulf %cst, %50 : f64
        %52 = addf %49, %51 : f64
        %53 = affine.load %arg0[%arg2 + 1, %arg3 - 1, %arg4 - 1] : memref<258x258x258xf64>
        %54 = mulf %cst_7, %53 : f64
        %55 = addf %52, %54 : f64
        %56 = affine.load %arg0[%arg2 + 1, %arg3 - 1, %arg4] : memref<258x258x258xf64>
        %57 = mulf %cst_6, %56 : f64
        %58 = addf %55, %57 : f64
        %59 = affine.load %arg0[%arg2 + 1, %arg3 - 1, %arg4 + 1] : memref<258x258x258xf64>
        %60 = mulf %cst_5, %59 : f64
        %61 = addf %58, %60 : f64
        %62 = affine.load %arg0[%arg2 + 1, %arg3, %arg4 - 1] : memref<258x258x258xf64>
        %63 = mulf %cst_4, %62 : f64
        %64 = addf %61, %63 : f64
        %65 = affine.load %arg0[%arg2 + 1, %arg3, %arg4] : memref<258x258x258xf64>
        %66 = mulf %cst_3, %65 : f64
        %67 = addf %64, %66 : f64
        %68 = affine.load %arg0[%arg2 + 1, %arg3, %arg4 + 1] : memref<258x258x258xf64>
        %69 = mulf %cst_2, %68 : f64
        %70 = addf %67, %69 : f64
        %71 = affine.load %arg0[%arg2 + 1, %arg3 + 1, %arg4 - 1] : memref<258x258x258xf64>
        %72 = mulf %cst_1, %71 : f64
        %73 = addf %70, %72 : f64
        %74 = affine.load %arg0[%arg2 + 1, %arg3 + 1, %arg4] : memref<258x258x258xf64>
        %75 = mulf %cst_0, %74 : f64
        %76 = addf %73, %75 : f64
        %77 = affine.load %arg0[%arg2 + 1, %arg3 + 1, %arg4 + 1] : memref<258x258x258xf64>
        %78 = mulf %cst, %77 : f64
        %79 = addf %76, %78 : f64
        affine.store %79, %arg1[%arg2, %arg3, %arg4] : memref<258x258x258xf64>
      }
    }
  }
  return
}

// -----// IR Dump After UHAffineToParallelPass //----- //
func @stencil_3d27pt_box(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) attributes {llvm.emit_c_interface} {
  %cst = constant 9.000000e-01 : f64
  %cst_0 = constant 8.000000e-01 : f64
  %cst_1 = constant 0.69999999999999996 : f64
  %cst_2 = constant 6.000000e-01 : f64
  %cst_3 = constant 5.000000e-01 : f64
  %cst_4 = constant 4.000000e-01 : f64
  %cst_5 = constant 3.000000e-01 : f64
  %cst_6 = constant 2.000000e-01 : f64
  %cst_7 = constant 1.000000e-01 : f64
  affine.parallel (%arg2, %arg3, %arg4) = (0, 0, 0) to (8, 8, 8) {
    affine.parallel (%arg5, %arg6, %arg7) = (0, 0, 0) to (8, 8, 8) {
      affine.for %arg8 = 1 to 257 {
        affine.for %arg9 = 1 to 257 {
          affine.for %arg10 = 1 to 257 {
            %0 = affine.load %arg0[%arg8 - 1, %arg9 - 1, %arg10 - 1] : memref<258x258x258xf64>
            %1 = mulf %cst_7, %0 : f64
            %2 = affine.load %arg0[%arg8 - 1, %arg9 - 1, %arg10] : memref<258x258x258xf64>
            %3 = mulf %cst_6, %2 : f64
            %4 = addf %1, %3 : f64
            %5 = affine.load %arg0[%arg8 - 1, %arg9 - 1, %arg10 + 1] : memref<258x258x258xf64>
            %6 = mulf %cst_5, %5 : f64
            %7 = addf %4, %6 : f64
            %8 = affine.load %arg0[%arg8 - 1, %arg9, %arg10 - 1] : memref<258x258x258xf64>
            %9 = mulf %cst_4, %8 : f64
            %10 = addf %7, %9 : f64
            %11 = affine.load %arg0[%arg8 - 1, %arg9, %arg10] : memref<258x258x258xf64>
            %12 = mulf %cst_3, %11 : f64
            %13 = addf %10, %12 : f64
            %14 = affine.load %arg0[%arg8 - 1, %arg9, %arg10 + 1] : memref<258x258x258xf64>
            %15 = mulf %cst_2, %14 : f64
            %16 = addf %13, %15 : f64
            %17 = affine.load %arg0[%arg8 - 1, %arg9 + 1, %arg10 - 1] : memref<258x258x258xf64>
            %18 = mulf %cst_1, %17 : f64
            %19 = addf %16, %18 : f64
            %20 = affine.load %arg0[%arg8 - 1, %arg9 + 1, %arg10] : memref<258x258x258xf64>
            %21 = mulf %cst_0, %20 : f64
            %22 = addf %19, %21 : f64
            %23 = affine.load %arg0[%arg8 - 1, %arg9 + 1, %arg10 + 1] : memref<258x258x258xf64>
            %24 = mulf %cst, %23 : f64
            %25 = addf %22, %24 : f64
            %26 = affine.load %arg0[%arg8, %arg9 - 1, %arg10 - 1] : memref<258x258x258xf64>
            %27 = mulf %cst_7, %26 : f64
            %28 = addf %25, %27 : f64
            %29 = affine.load %arg0[%arg8, %arg9 - 1, %arg10] : memref<258x258x258xf64>
            %30 = mulf %cst_6, %29 : f64
            %31 = addf %28, %30 : f64
            %32 = affine.load %arg0[%arg8, %arg9 - 1, %arg10 + 1] : memref<258x258x258xf64>
            %33 = mulf %cst_5, %32 : f64
            %34 = addf %31, %33 : f64
            %35 = affine.load %arg0[%arg8, %arg9, %arg10 - 1] : memref<258x258x258xf64>
            %36 = mulf %cst_4, %35 : f64
            %37 = addf %34, %36 : f64
            %38 = affine.load %arg0[%arg8, %arg9, %arg10] : memref<258x258x258xf64>
            %39 = mulf %cst_3, %38 : f64
            %40 = addf %37, %39 : f64
            %41 = affine.load %arg0[%arg8, %arg9, %arg10 + 1] : memref<258x258x258xf64>
            %42 = mulf %cst_2, %41 : f64
            %43 = addf %40, %42 : f64
            %44 = affine.load %arg0[%arg8, %arg9 + 1, %arg10 - 1] : memref<258x258x258xf64>
            %45 = mulf %cst_1, %44 : f64
            %46 = addf %43, %45 : f64
            %47 = affine.load %arg0[%arg8, %arg9 + 1, %arg10] : memref<258x258x258xf64>
            %48 = mulf %cst_0, %47 : f64
            %49 = addf %46, %48 : f64
            %50 = affine.load %arg0[%arg8, %arg9 + 1, %arg10 + 1] : memref<258x258x258xf64>
            %51 = mulf %cst, %50 : f64
            %52 = addf %49, %51 : f64
            %53 = affine.load %arg0[%arg8 + 1, %arg9 - 1, %arg10 - 1] : memref<258x258x258xf64>
            %54 = mulf %cst_7, %53 : f64
            %55 = addf %52, %54 : f64
            %56 = affine.load %arg0[%arg8 + 1, %arg9 - 1, %arg10] : memref<258x258x258xf64>
            %57 = mulf %cst_6, %56 : f64
            %58 = addf %55, %57 : f64
            %59 = affine.load %arg0[%arg8 + 1, %arg9 - 1, %arg10 + 1] : memref<258x258x258xf64>
            %60 = mulf %cst_5, %59 : f64
            %61 = addf %58, %60 : f64
            %62 = affine.load %arg0[%arg8 + 1, %arg9, %arg10 - 1] : memref<258x258x258xf64>
            %63 = mulf %cst_4, %62 : f64
            %64 = addf %61, %63 : f64
            %65 = affine.load %arg0[%arg8 + 1, %arg9, %arg10] : memref<258x258x258xf64>
            %66 = mulf %cst_3, %65 : f64
            %67 = addf %64, %66 : f64
            %68 = affine.load %arg0[%arg8 + 1, %arg9, %arg10 + 1] : memref<258x258x258xf64>
            %69 = mulf %cst_2, %68 : f64
            %70 = addf %67, %69 : f64
            %71 = affine.load %arg0[%arg8 + 1, %arg9 + 1, %arg10 - 1] : memref<258x258x258xf64>
            %72 = mulf %cst_1, %71 : f64
            %73 = addf %70, %72 : f64
            %74 = affine.load %arg0[%arg8 + 1, %arg9 + 1, %arg10] : memref<258x258x258xf64>
            %75 = mulf %cst_0, %74 : f64
            %76 = addf %73, %75 : f64
            %77 = affine.load %arg0[%arg8 + 1, %arg9 + 1, %arg10 + 1] : memref<258x258x258xf64>
            %78 = mulf %cst, %77 : f64
            %79 = addf %76, %78 : f64
            affine.store %79, %arg1[%arg8, %arg9, %arg10] : memref<258x258x258xf64>
          }
        }
      }
    } {num_dimension = 3 : index, parallelTag = "block"}
  } {num_dimension = 3 : index, parallelTag = "grid"}
  return
}

// -----// IR Dump After Canonicalizer //----- //
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
  affine.parallel (%arg2, %arg3, %arg4) = (0, 0, 0) to (8, 8, 8) {
    affine.parallel (%arg5, %arg6, %arg7) = (0, 0, 0) to (8, 8, 8) {
      affine.for %arg8 = 1 to 257 {
        affine.for %arg9 = 1 to 257 {
          affine.for %arg10 = 1 to 257 {
            %0 = affine.load %arg0[%arg8 - 1, %arg9 - 1, %arg10 - 1] : memref<258x258x258xf64>
            %1 = mulf %cst, %0 : f64
            %2 = affine.load %arg0[%arg8 - 1, %arg9 - 1, %arg10] : memref<258x258x258xf64>
            %3 = mulf %cst_0, %2 : f64
            %4 = addf %1, %3 : f64
            %5 = affine.load %arg0[%arg8 - 1, %arg9 - 1, %arg10 + 1] : memref<258x258x258xf64>
            %6 = mulf %cst_1, %5 : f64
            %7 = addf %4, %6 : f64
            %8 = affine.load %arg0[%arg8 - 1, %arg9, %arg10 - 1] : memref<258x258x258xf64>
            %9 = mulf %cst_2, %8 : f64
            %10 = addf %7, %9 : f64
            %11 = affine.load %arg0[%arg8 - 1, %arg9, %arg10] : memref<258x258x258xf64>
            %12 = mulf %cst_3, %11 : f64
            %13 = addf %10, %12 : f64
            %14 = affine.load %arg0[%arg8 - 1, %arg9, %arg10 + 1] : memref<258x258x258xf64>
            %15 = mulf %cst_4, %14 : f64
            %16 = addf %13, %15 : f64
            %17 = affine.load %arg0[%arg8 - 1, %arg9 + 1, %arg10 - 1] : memref<258x258x258xf64>
            %18 = mulf %cst_5, %17 : f64
            %19 = addf %16, %18 : f64
            %20 = affine.load %arg0[%arg8 - 1, %arg9 + 1, %arg10] : memref<258x258x258xf64>
            %21 = mulf %cst_6, %20 : f64
            %22 = addf %19, %21 : f64
            %23 = affine.load %arg0[%arg8 - 1, %arg9 + 1, %arg10 + 1] : memref<258x258x258xf64>
            %24 = mulf %cst_7, %23 : f64
            %25 = addf %22, %24 : f64
            %26 = affine.load %arg0[%arg8, %arg9 - 1, %arg10 - 1] : memref<258x258x258xf64>
            %27 = mulf %cst, %26 : f64
            %28 = addf %25, %27 : f64
            %29 = affine.load %arg0[%arg8, %arg9 - 1, %arg10] : memref<258x258x258xf64>
            %30 = mulf %cst_0, %29 : f64
            %31 = addf %28, %30 : f64
            %32 = affine.load %arg0[%arg8, %arg9 - 1, %arg10 + 1] : memref<258x258x258xf64>
            %33 = mulf %cst_1, %32 : f64
            %34 = addf %31, %33 : f64
            %35 = affine.load %arg0[%arg8, %arg9, %arg10 - 1] : memref<258x258x258xf64>
            %36 = mulf %cst_2, %35 : f64
            %37 = addf %34, %36 : f64
            %38 = affine.load %arg0[%arg8, %arg9, %arg10] : memref<258x258x258xf64>
            %39 = mulf %cst_3, %38 : f64
            %40 = addf %37, %39 : f64
            %41 = affine.load %arg0[%arg8, %arg9, %arg10 + 1] : memref<258x258x258xf64>
            %42 = mulf %cst_4, %41 : f64
            %43 = addf %40, %42 : f64
            %44 = affine.load %arg0[%arg8, %arg9 + 1, %arg10 - 1] : memref<258x258x258xf64>
            %45 = mulf %cst_5, %44 : f64
            %46 = addf %43, %45 : f64
            %47 = affine.load %arg0[%arg8, %arg9 + 1, %arg10] : memref<258x258x258xf64>
            %48 = mulf %cst_6, %47 : f64
            %49 = addf %46, %48 : f64
            %50 = affine.load %arg0[%arg8, %arg9 + 1, %arg10 + 1] : memref<258x258x258xf64>
            %51 = mulf %cst_7, %50 : f64
            %52 = addf %49, %51 : f64
            %53 = affine.load %arg0[%arg8 + 1, %arg9 - 1, %arg10 - 1] : memref<258x258x258xf64>
            %54 = mulf %cst, %53 : f64
            %55 = addf %52, %54 : f64
            %56 = affine.load %arg0[%arg8 + 1, %arg9 - 1, %arg10] : memref<258x258x258xf64>
            %57 = mulf %cst_0, %56 : f64
            %58 = addf %55, %57 : f64
            %59 = affine.load %arg0[%arg8 + 1, %arg9 - 1, %arg10 + 1] : memref<258x258x258xf64>
            %60 = mulf %cst_1, %59 : f64
            %61 = addf %58, %60 : f64
            %62 = affine.load %arg0[%arg8 + 1, %arg9, %arg10 - 1] : memref<258x258x258xf64>
            %63 = mulf %cst_2, %62 : f64
            %64 = addf %61, %63 : f64
            %65 = affine.load %arg0[%arg8 + 1, %arg9, %arg10] : memref<258x258x258xf64>
            %66 = mulf %cst_3, %65 : f64
            %67 = addf %64, %66 : f64
            %68 = affine.load %arg0[%arg8 + 1, %arg9, %arg10 + 1] : memref<258x258x258xf64>
            %69 = mulf %cst_4, %68 : f64
            %70 = addf %67, %69 : f64
            %71 = affine.load %arg0[%arg8 + 1, %arg9 + 1, %arg10 - 1] : memref<258x258x258xf64>
            %72 = mulf %cst_5, %71 : f64
            %73 = addf %70, %72 : f64
            %74 = affine.load %arg0[%arg8 + 1, %arg9 + 1, %arg10] : memref<258x258x258xf64>
            %75 = mulf %cst_6, %74 : f64
            %76 = addf %73, %75 : f64
            %77 = affine.load %arg0[%arg8 + 1, %arg9 + 1, %arg10 + 1] : memref<258x258x258xf64>
            %78 = mulf %cst_7, %77 : f64
            %79 = addf %76, %78 : f64
            affine.store %79, %arg1[%arg8, %arg9, %arg10] : memref<258x258x258xf64>
          }
        }
      }
    } {num_dimension = 3 : index, parallelTag = "block"}
  } {num_dimension = 3 : index, parallelTag = "grid"}
  return
}

// -----// IR Dump After UHTilingToParallelPass //----- //
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
  affine.parallel (%arg2, %arg3, %arg4) = (0, 0, 0) to (4, 4, 4) {
    affine.parallel (%arg5, %arg6, %arg7) = (0, 0, 0) to (8, 8, 8) {
      affine.for %arg8 = affine_map<(d0, d1) -> (d0 * 64 + d1 * 8 + 1)>(%arg2, %arg5) to affine_map<(d0, d1) -> (d0 * 64 + d1 * 8 + 9)>(%arg2, %arg5) {
        affine.for %arg9 = affine_map<(d0, d1) -> (d0 * 64 + d1 * 8 + 1)>(%arg3, %arg6) to affine_map<(d0, d1) -> (d0 * 64 + d1 * 8 + 9)>(%arg3, %arg6) {
          affine.for %arg10 = affine_map<(d0, d1) -> (d0 * 64 + d1 * 8 + 1)>(%arg4, %arg7) to affine_map<(d0, d1) -> (d0 * 64 + d1 * 8 + 9)>(%arg4, %arg7) {
            %0 = affine.load %arg0[%arg8 - 1, %arg9 - 1, %arg10 - 1] : memref<258x258x258xf64>
            %1 = mulf %cst, %0 : f64
            %2 = affine.load %arg0[%arg8 - 1, %arg9 - 1, %arg10] : memref<258x258x258xf64>
            %3 = mulf %cst_0, %2 : f64
            %4 = addf %1, %3 : f64
            %5 = affine.load %arg0[%arg8 - 1, %arg9 - 1, %arg10 + 1] : memref<258x258x258xf64>
            %6 = mulf %cst_1, %5 : f64
            %7 = addf %4, %6 : f64
            %8 = affine.load %arg0[%arg8 - 1, %arg9, %arg10 - 1] : memref<258x258x258xf64>
            %9 = mulf %cst_2, %8 : f64
            %10 = addf %7, %9 : f64
            %11 = affine.load %arg0[%arg8 - 1, %arg9, %arg10] : memref<258x258x258xf64>
            %12 = mulf %cst_3, %11 : f64
            %13 = addf %10, %12 : f64
            %14 = affine.load %arg0[%arg8 - 1, %arg9, %arg10 + 1] : memref<258x258x258xf64>
            %15 = mulf %cst_4, %14 : f64
            %16 = addf %13, %15 : f64
            %17 = affine.load %arg0[%arg8 - 1, %arg9 + 1, %arg10 - 1] : memref<258x258x258xf64>
            %18 = mulf %cst_5, %17 : f64
            %19 = addf %16, %18 : f64
            %20 = affine.load %arg0[%arg8 - 1, %arg9 + 1, %arg10] : memref<258x258x258xf64>
            %21 = mulf %cst_6, %20 : f64
            %22 = addf %19, %21 : f64
            %23 = affine.load %arg0[%arg8 - 1, %arg9 + 1, %arg10 + 1] : memref<258x258x258xf64>
            %24 = mulf %cst_7, %23 : f64
            %25 = addf %22, %24 : f64
            %26 = affine.load %arg0[%arg8, %arg9 - 1, %arg10 - 1] : memref<258x258x258xf64>
            %27 = mulf %cst, %26 : f64
            %28 = addf %25, %27 : f64
            %29 = affine.load %arg0[%arg8, %arg9 - 1, %arg10] : memref<258x258x258xf64>
            %30 = mulf %cst_0, %29 : f64
            %31 = addf %28, %30 : f64
            %32 = affine.load %arg0[%arg8, %arg9 - 1, %arg10 + 1] : memref<258x258x258xf64>
            %33 = mulf %cst_1, %32 : f64
            %34 = addf %31, %33 : f64
            %35 = affine.load %arg0[%arg8, %arg9, %arg10 - 1] : memref<258x258x258xf64>
            %36 = mulf %cst_2, %35 : f64
            %37 = addf %34, %36 : f64
            %38 = affine.load %arg0[%arg8, %arg9, %arg10] : memref<258x258x258xf64>
            %39 = mulf %cst_3, %38 : f64
            %40 = addf %37, %39 : f64
            %41 = affine.load %arg0[%arg8, %arg9, %arg10 + 1] : memref<258x258x258xf64>
            %42 = mulf %cst_4, %41 : f64
            %43 = addf %40, %42 : f64
            %44 = affine.load %arg0[%arg8, %arg9 + 1, %arg10 - 1] : memref<258x258x258xf64>
            %45 = mulf %cst_5, %44 : f64
            %46 = addf %43, %45 : f64
            %47 = affine.load %arg0[%arg8, %arg9 + 1, %arg10] : memref<258x258x258xf64>
            %48 = mulf %cst_6, %47 : f64
            %49 = addf %46, %48 : f64
            %50 = affine.load %arg0[%arg8, %arg9 + 1, %arg10 + 1] : memref<258x258x258xf64>
            %51 = mulf %cst_7, %50 : f64
            %52 = addf %49, %51 : f64
            %53 = affine.load %arg0[%arg8 + 1, %arg9 - 1, %arg10 - 1] : memref<258x258x258xf64>
            %54 = mulf %cst, %53 : f64
            %55 = addf %52, %54 : f64
            %56 = affine.load %arg0[%arg8 + 1, %arg9 - 1, %arg10] : memref<258x258x258xf64>
            %57 = mulf %cst_0, %56 : f64
            %58 = addf %55, %57 : f64
            %59 = affine.load %arg0[%arg8 + 1, %arg9 - 1, %arg10 + 1] : memref<258x258x258xf64>
            %60 = mulf %cst_1, %59 : f64
            %61 = addf %58, %60 : f64
            %62 = affine.load %arg0[%arg8 + 1, %arg9, %arg10 - 1] : memref<258x258x258xf64>
            %63 = mulf %cst_2, %62 : f64
            %64 = addf %61, %63 : f64
            %65 = affine.load %arg0[%arg8 + 1, %arg9, %arg10] : memref<258x258x258xf64>
            %66 = mulf %cst_3, %65 : f64
            %67 = addf %64, %66 : f64
            %68 = affine.load %arg0[%arg8 + 1, %arg9, %arg10 + 1] : memref<258x258x258xf64>
            %69 = mulf %cst_4, %68 : f64
            %70 = addf %67, %69 : f64
            %71 = affine.load %arg0[%arg8 + 1, %arg9 + 1, %arg10 - 1] : memref<258x258x258xf64>
            %72 = mulf %cst_5, %71 : f64
            %73 = addf %70, %72 : f64
            %74 = affine.load %arg0[%arg8 + 1, %arg9 + 1, %arg10] : memref<258x258x258xf64>
            %75 = mulf %cst_6, %74 : f64
            %76 = addf %73, %75 : f64
            %77 = affine.load %arg0[%arg8 + 1, %arg9 + 1, %arg10 + 1] : memref<258x258x258xf64>
            %78 = mulf %cst_7, %77 : f64
            %79 = addf %76, %78 : f64
            affine.store %79, %arg1[%arg8, %arg9, %arg10] : memref<258x258x258xf64>
          }
        }
      }
    } {num_dimension = 3 : index, parallelTag = "block"}
  } {num_dimension = 3 : index, parallelTag = "grid"}
  return
}

// -----// IR Dump After AffineInnerTilingPass //----- //
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
  affine.parallel (%arg2, %arg3, %arg4) = (0, 0, 0) to (4, 4, 4) {
    affine.parallel (%arg5, %arg6, %arg7) = (0, 0, 0) to (8, 8, 8) {
      affine.for %arg8 = affine_map<(d0, d1) -> (d0 * 64 + d1 * 8 + 1)>(%arg2, %arg5) to affine_map<(d0, d1) -> (d0 * 64 + d1 * 8 + 9)>(%arg2, %arg5) step 4 {
        affine.for %arg9 = affine_map<(d0, d1) -> (d0 * 64 + d1 * 8 + 1)>(%arg3, %arg6) to affine_map<(d0, d1) -> (d0 * 64 + d1 * 8 + 9)>(%arg3, %arg6) step 4 {
          affine.for %arg10 = affine_map<(d0, d1) -> (d0 * 64 + d1 * 8 + 1)>(%arg4, %arg7) to affine_map<(d0, d1) -> (d0 * 64 + d1 * 8 + 9)>(%arg4, %arg7) step 4 {
            affine.for %arg11 = 0 to 4 {
              affine.for %arg12 = 0 to 4 {
                affine.for %arg13 = 0 to 4 {
                  %0 = affine.apply affine_map<(d0, d1) -> (d0 + d1)>(%arg10, %arg13)
                  %1 = affine.apply affine_map<(d0, d1) -> (d0 + d1)>(%arg9, %arg12)
                  %2 = affine.apply affine_map<(d0, d1) -> (d0 + d1)>(%arg8, %arg11)
                  %3 = affine.load %arg0[%2 - 1, %1 - 1, %0 - 1] : memref<258x258x258xf64>
                  %4 = mulf %cst, %3 : f64
                  %5 = affine.load %arg0[%2 - 1, %1 - 1, %0] : memref<258x258x258xf64>
                  %6 = mulf %cst_0, %5 : f64
                  %7 = addf %4, %6 : f64
                  %8 = affine.load %arg0[%2 - 1, %1 - 1, %0 + 1] : memref<258x258x258xf64>
                  %9 = mulf %cst_1, %8 : f64
                  %10 = addf %7, %9 : f64
                  %11 = affine.load %arg0[%2 - 1, %1, %0 - 1] : memref<258x258x258xf64>
                  %12 = mulf %cst_2, %11 : f64
                  %13 = addf %10, %12 : f64
                  %14 = affine.load %arg0[%2 - 1, %1, %0] : memref<258x258x258xf64>
                  %15 = mulf %cst_3, %14 : f64
                  %16 = addf %13, %15 : f64
                  %17 = affine.load %arg0[%2 - 1, %1, %0 + 1] : memref<258x258x258xf64>
                  %18 = mulf %cst_4, %17 : f64
                  %19 = addf %16, %18 : f64
                  %20 = affine.load %arg0[%2 - 1, %1 + 1, %0 - 1] : memref<258x258x258xf64>
                  %21 = mulf %cst_5, %20 : f64
                  %22 = addf %19, %21 : f64
                  %23 = affine.load %arg0[%2 - 1, %1 + 1, %0] : memref<258x258x258xf64>
                  %24 = mulf %cst_6, %23 : f64
                  %25 = addf %22, %24 : f64
                  %26 = affine.load %arg0[%2 - 1, %1 + 1, %0 + 1] : memref<258x258x258xf64>
                  %27 = mulf %cst_7, %26 : f64
                  %28 = addf %25, %27 : f64
                  %29 = affine.load %arg0[%2, %1 - 1, %0 - 1] : memref<258x258x258xf64>
                  %30 = mulf %cst, %29 : f64
                  %31 = addf %28, %30 : f64
                  %32 = affine.load %arg0[%2, %1 - 1, %0] : memref<258x258x258xf64>
                  %33 = mulf %cst_0, %32 : f64
                  %34 = addf %31, %33 : f64
                  %35 = affine.load %arg0[%2, %1 - 1, %0 + 1] : memref<258x258x258xf64>
                  %36 = mulf %cst_1, %35 : f64
                  %37 = addf %34, %36 : f64
                  %38 = affine.load %arg0[%2, %1, %0 - 1] : memref<258x258x258xf64>
                  %39 = mulf %cst_2, %38 : f64
                  %40 = addf %37, %39 : f64
                  %41 = affine.load %arg0[%2, %1, %0] : memref<258x258x258xf64>
                  %42 = mulf %cst_3, %41 : f64
                  %43 = addf %40, %42 : f64
                  %44 = affine.load %arg0[%2, %1, %0 + 1] : memref<258x258x258xf64>
                  %45 = mulf %cst_4, %44 : f64
                  %46 = addf %43, %45 : f64
                  %47 = affine.load %arg0[%2, %1 + 1, %0 - 1] : memref<258x258x258xf64>
                  %48 = mulf %cst_5, %47 : f64
                  %49 = addf %46, %48 : f64
                  %50 = affine.load %arg0[%2, %1 + 1, %0] : memref<258x258x258xf64>
                  %51 = mulf %cst_6, %50 : f64
                  %52 = addf %49, %51 : f64
                  %53 = affine.load %arg0[%2, %1 + 1, %0 + 1] : memref<258x258x258xf64>
                  %54 = mulf %cst_7, %53 : f64
                  %55 = addf %52, %54 : f64
                  %56 = affine.load %arg0[%2 + 1, %1 - 1, %0 - 1] : memref<258x258x258xf64>
                  %57 = mulf %cst, %56 : f64
                  %58 = addf %55, %57 : f64
                  %59 = affine.load %arg0[%2 + 1, %1 - 1, %0] : memref<258x258x258xf64>
                  %60 = mulf %cst_0, %59 : f64
                  %61 = addf %58, %60 : f64
                  %62 = affine.load %arg0[%2 + 1, %1 - 1, %0 + 1] : memref<258x258x258xf64>
                  %63 = mulf %cst_1, %62 : f64
                  %64 = addf %61, %63 : f64
                  %65 = affine.load %arg0[%2 + 1, %1, %0 - 1] : memref<258x258x258xf64>
                  %66 = mulf %cst_2, %65 : f64
                  %67 = addf %64, %66 : f64
                  %68 = affine.load %arg0[%2 + 1, %1, %0] : memref<258x258x258xf64>
                  %69 = mulf %cst_3, %68 : f64
                  %70 = addf %67, %69 : f64
                  %71 = affine.load %arg0[%2 + 1, %1, %0 + 1] : memref<258x258x258xf64>
                  %72 = mulf %cst_4, %71 : f64
                  %73 = addf %70, %72 : f64
                  %74 = affine.load %arg0[%2 + 1, %1 + 1, %0 - 1] : memref<258x258x258xf64>
                  %75 = mulf %cst_5, %74 : f64
                  %76 = addf %73, %75 : f64
                  %77 = affine.load %arg0[%2 + 1, %1 + 1, %0] : memref<258x258x258xf64>
                  %78 = mulf %cst_6, %77 : f64
                  %79 = addf %76, %78 : f64
                  %80 = affine.load %arg0[%2 + 1, %1 + 1, %0 + 1] : memref<258x258x258xf64>
                  %81 = mulf %cst_7, %80 : f64
                  %82 = addf %79, %81 : f64
                  affine.store %82, %arg1[%2, %1, %0] : memref<258x258x258xf64>
                }
              }
            }
          }
        }
      }
    } {num_dimension = 3 : index, parallelTag = "block"}
  } {num_dimension = 3 : index, parallelTag = "grid"}
  return
}

// -----// IR Dump After CollapseAffineParallelPass //----- //
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
    affine.for %arg8 = affine_map<(d0, d1) -> (d0 * 64 + d1 * 8 + 1)>(%arg2, %arg5) to affine_map<(d0, d1) -> (d0 * 64 + d1 * 8 + 9)>(%arg2, %arg5) step 4 {
      affine.for %arg9 = affine_map<(d0, d1) -> (d0 * 64 + d1 * 8 + 1)>(%arg3, %arg6) to affine_map<(d0, d1) -> (d0 * 64 + d1 * 8 + 9)>(%arg3, %arg6) step 4 {
        affine.for %arg10 = affine_map<(d0, d1) -> (d0 * 64 + d1 * 8 + 1)>(%arg4, %arg7) to affine_map<(d0, d1) -> (d0 * 64 + d1 * 8 + 9)>(%arg4, %arg7) step 4 {
          affine.for %arg11 = 0 to 4 {
            affine.for %arg12 = 0 to 4 {
              affine.for %arg13 = 0 to 4 {
                %0 = affine.apply affine_map<(d0, d1) -> (d0 + d1)>(%arg10, %arg13)
                %1 = affine.apply affine_map<(d0, d1) -> (d0 + d1)>(%arg9, %arg12)
                %2 = affine.apply affine_map<(d0, d1) -> (d0 + d1)>(%arg8, %arg11)
                %3 = affine.load %arg0[%2 - 1, %1 - 1, %0 - 1] : memref<258x258x258xf64>
                %4 = mulf %cst, %3 : f64
                %5 = affine.load %arg0[%2 - 1, %1 - 1, %0] : memref<258x258x258xf64>
                %6 = mulf %cst_0, %5 : f64
                %7 = addf %4, %6 : f64
                %8 = affine.load %arg0[%2 - 1, %1 - 1, %0 + 1] : memref<258x258x258xf64>
                %9 = mulf %cst_1, %8 : f64
                %10 = addf %7, %9 : f64
                %11 = affine.load %arg0[%2 - 1, %1, %0 - 1] : memref<258x258x258xf64>
                %12 = mulf %cst_2, %11 : f64
                %13 = addf %10, %12 : f64
                %14 = affine.load %arg0[%2 - 1, %1, %0] : memref<258x258x258xf64>
                %15 = mulf %cst_3, %14 : f64
                %16 = addf %13, %15 : f64
                %17 = affine.load %arg0[%2 - 1, %1, %0 + 1] : memref<258x258x258xf64>
                %18 = mulf %cst_4, %17 : f64
                %19 = addf %16, %18 : f64
                %20 = affine.load %arg0[%2 - 1, %1 + 1, %0 - 1] : memref<258x258x258xf64>
                %21 = mulf %cst_5, %20 : f64
                %22 = addf %19, %21 : f64
                %23 = affine.load %arg0[%2 - 1, %1 + 1, %0] : memref<258x258x258xf64>
                %24 = mulf %cst_6, %23 : f64
                %25 = addf %22, %24 : f64
                %26 = affine.load %arg0[%2 - 1, %1 + 1, %0 + 1] : memref<258x258x258xf64>
                %27 = mulf %cst_7, %26 : f64
                %28 = addf %25, %27 : f64
                %29 = affine.load %arg0[%2, %1 - 1, %0 - 1] : memref<258x258x258xf64>
                %30 = mulf %cst, %29 : f64
                %31 = addf %28, %30 : f64
                %32 = affine.load %arg0[%2, %1 - 1, %0] : memref<258x258x258xf64>
                %33 = mulf %cst_0, %32 : f64
                %34 = addf %31, %33 : f64
                %35 = affine.load %arg0[%2, %1 - 1, %0 + 1] : memref<258x258x258xf64>
                %36 = mulf %cst_1, %35 : f64
                %37 = addf %34, %36 : f64
                %38 = affine.load %arg0[%2, %1, %0 - 1] : memref<258x258x258xf64>
                %39 = mulf %cst_2, %38 : f64
                %40 = addf %37, %39 : f64
                %41 = affine.load %arg0[%2, %1, %0] : memref<258x258x258xf64>
                %42 = mulf %cst_3, %41 : f64
                %43 = addf %40, %42 : f64
                %44 = affine.load %arg0[%2, %1, %0 + 1] : memref<258x258x258xf64>
                %45 = mulf %cst_4, %44 : f64
                %46 = addf %43, %45 : f64
                %47 = affine.load %arg0[%2, %1 + 1, %0 - 1] : memref<258x258x258xf64>
                %48 = mulf %cst_5, %47 : f64
                %49 = addf %46, %48 : f64
                %50 = affine.load %arg0[%2, %1 + 1, %0] : memref<258x258x258xf64>
                %51 = mulf %cst_6, %50 : f64
                %52 = addf %49, %51 : f64
                %53 = affine.load %arg0[%2, %1 + 1, %0 + 1] : memref<258x258x258xf64>
                %54 = mulf %cst_7, %53 : f64
                %55 = addf %52, %54 : f64
                %56 = affine.load %arg0[%2 + 1, %1 - 1, %0 - 1] : memref<258x258x258xf64>
                %57 = mulf %cst, %56 : f64
                %58 = addf %55, %57 : f64
                %59 = affine.load %arg0[%2 + 1, %1 - 1, %0] : memref<258x258x258xf64>
                %60 = mulf %cst_0, %59 : f64
                %61 = addf %58, %60 : f64
                %62 = affine.load %arg0[%2 + 1, %1 - 1, %0 + 1] : memref<258x258x258xf64>
                %63 = mulf %cst_1, %62 : f64
                %64 = addf %61, %63 : f64
                %65 = affine.load %arg0[%2 + 1, %1, %0 - 1] : memref<258x258x258xf64>
                %66 = mulf %cst_2, %65 : f64
                %67 = addf %64, %66 : f64
                %68 = affine.load %arg0[%2 + 1, %1, %0] : memref<258x258x258xf64>
                %69 = mulf %cst_3, %68 : f64
                %70 = addf %67, %69 : f64
                %71 = affine.load %arg0[%2 + 1, %1, %0 + 1] : memref<258x258x258xf64>
                %72 = mulf %cst_4, %71 : f64
                %73 = addf %70, %72 : f64
                %74 = affine.load %arg0[%2 + 1, %1 + 1, %0 - 1] : memref<258x258x258xf64>
                %75 = mulf %cst_5, %74 : f64
                %76 = addf %73, %75 : f64
                %77 = affine.load %arg0[%2 + 1, %1 + 1, %0] : memref<258x258x258xf64>
                %78 = mulf %cst_6, %77 : f64
                %79 = addf %76, %78 : f64
                %80 = affine.load %arg0[%2 + 1, %1 + 1, %0 + 1] : memref<258x258x258xf64>
                %81 = mulf %cst_7, %80 : f64
                %82 = addf %79, %81 : f64
                affine.store %82, %arg1[%2, %1, %0] : memref<258x258x258xf64>
              }
            }
          }
        }
      }
    }
  }
  return
}

// -----// IR Dump After ConvertAffineToStandard //----- //
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
    %c0 = constant 0 : index
    %c4 = constant 4 : index
    %c0_8 = constant 0 : index
    %c4_9 = constant 4 : index
    %c0_10 = constant 0 : index
    %c4_11 = constant 4 : index
    %c0_12 = constant 0 : index
    %c8 = constant 8 : index
    %c0_13 = constant 0 : index
    %c8_14 = constant 8 : index
    %c0_15 = constant 0 : index
    %c8_16 = constant 8 : index
    %c1 = constant 1 : index
    %c1_17 = constant 1 : index
    %c1_18 = constant 1 : index
    %c1_19 = constant 1 : index
    %c1_20 = constant 1 : index
    %c1_21 = constant 1 : index
    scf.parallel (%arg2, %arg3, %arg4, %arg5, %arg6, %arg7) = (%c0, %c0_8, %c0_10, %c0_12, %c0_13, %c0_15) to (%c4, %c4_9, %c4_11, %c8, %c8_14, %c8_16) step (%c1, %c1_17, %c1_18, %c1_19, %c1_20, %c1_21) {
      %c64 = constant 64 : index
      %0 = muli %arg2, %c64 : index
      %c8_22 = constant 8 : index
      %1 = muli %arg5, %c8_22 : index
      %2 = addi %0, %1 : index
      %c1_23 = constant 1 : index
      %3 = addi %2, %c1_23 : index
      %c64_24 = constant 64 : index
      %4 = muli %arg2, %c64_24 : index
      %c8_25 = constant 8 : index
      %5 = muli %arg5, %c8_25 : index
      %6 = addi %4, %5 : index
      %c9 = constant 9 : index
      %7 = addi %6, %c9 : index
      %c4_26 = constant 4 : index
      scf.for %arg8 = %3 to %7 step %c4_26 {
        %c64_27 = constant 64 : index
        %8 = muli %arg3, %c64_27 : index
        %c8_28 = constant 8 : index
        %9 = muli %arg6, %c8_28 : index
        %10 = addi %8, %9 : index
        %c1_29 = constant 1 : index
        %11 = addi %10, %c1_29 : index
        %c64_30 = constant 64 : index
        %12 = muli %arg3, %c64_30 : index
        %c8_31 = constant 8 : index
        %13 = muli %arg6, %c8_31 : index
        %14 = addi %12, %13 : index
        %c9_32 = constant 9 : index
        %15 = addi %14, %c9_32 : index
        %c4_33 = constant 4 : index
        scf.for %arg9 = %11 to %15 step %c4_33 {
          %c64_34 = constant 64 : index
          %16 = muli %arg4, %c64_34 : index
          %c8_35 = constant 8 : index
          %17 = muli %arg7, %c8_35 : index
          %18 = addi %16, %17 : index
          %c1_36 = constant 1 : index
          %19 = addi %18, %c1_36 : index
          %c64_37 = constant 64 : index
          %20 = muli %arg4, %c64_37 : index
          %c8_38 = constant 8 : index
          %21 = muli %arg7, %c8_38 : index
          %22 = addi %20, %21 : index
          %c9_39 = constant 9 : index
          %23 = addi %22, %c9_39 : index
          %c4_40 = constant 4 : index
          scf.for %arg10 = %19 to %23 step %c4_40 {
            %c0_41 = constant 0 : index
            %c4_42 = constant 4 : index
            %c1_43 = constant 1 : index
            scf.for %arg11 = %c0_41 to %c4_42 step %c1_43 {
              %c0_44 = constant 0 : index
              %c4_45 = constant 4 : index
              %c1_46 = constant 1 : index
              scf.for %arg12 = %c0_44 to %c4_45 step %c1_46 {
                %c0_47 = constant 0 : index
                %c4_48 = constant 4 : index
                %c1_49 = constant 1 : index
                scf.for %arg13 = %c0_47 to %c4_48 step %c1_49 {
                  %24 = addi %arg10, %arg13 : index
                  %25 = addi %arg9, %arg12 : index
                  %26 = addi %arg8, %arg11 : index
                  %c-1 = constant -1 : index
                  %27 = addi %26, %c-1 : index
                  %c-1_50 = constant -1 : index
                  %28 = addi %25, %c-1_50 : index
                  %c-1_51 = constant -1 : index
                  %29 = addi %24, %c-1_51 : index
                  %30 = memref.load %arg0[%27, %28, %29] : memref<258x258x258xf64>
                  %31 = mulf %cst, %30 : f64
                  %c-1_52 = constant -1 : index
                  %32 = addi %26, %c-1_52 : index
                  %c-1_53 = constant -1 : index
                  %33 = addi %25, %c-1_53 : index
                  %34 = memref.load %arg0[%32, %33, %24] : memref<258x258x258xf64>
                  %35 = mulf %cst_0, %34 : f64
                  %36 = addf %31, %35 : f64
                  %c-1_54 = constant -1 : index
                  %37 = addi %26, %c-1_54 : index
                  %c-1_55 = constant -1 : index
                  %38 = addi %25, %c-1_55 : index
                  %c1_56 = constant 1 : index
                  %39 = addi %24, %c1_56 : index
                  %40 = memref.load %arg0[%37, %38, %39] : memref<258x258x258xf64>
                  %41 = mulf %cst_1, %40 : f64
                  %42 = addf %36, %41 : f64
                  %c-1_57 = constant -1 : index
                  %43 = addi %26, %c-1_57 : index
                  %c-1_58 = constant -1 : index
                  %44 = addi %24, %c-1_58 : index
                  %45 = memref.load %arg0[%43, %25, %44] : memref<258x258x258xf64>
                  %46 = mulf %cst_2, %45 : f64
                  %47 = addf %42, %46 : f64
                  %c-1_59 = constant -1 : index
                  %48 = addi %26, %c-1_59 : index
                  %49 = memref.load %arg0[%48, %25, %24] : memref<258x258x258xf64>
                  %50 = mulf %cst_3, %49 : f64
                  %51 = addf %47, %50 : f64
                  %c-1_60 = constant -1 : index
                  %52 = addi %26, %c-1_60 : index
                  %c1_61 = constant 1 : index
                  %53 = addi %24, %c1_61 : index
                  %54 = memref.load %arg0[%52, %25, %53] : memref<258x258x258xf64>
                  %55 = mulf %cst_4, %54 : f64
                  %56 = addf %51, %55 : f64
                  %c-1_62 = constant -1 : index
                  %57 = addi %26, %c-1_62 : index
                  %c1_63 = constant 1 : index
                  %58 = addi %25, %c1_63 : index
                  %c-1_64 = constant -1 : index
                  %59 = addi %24, %c-1_64 : index
                  %60 = memref.load %arg0[%57, %58, %59] : memref<258x258x258xf64>
                  %61 = mulf %cst_5, %60 : f64
                  %62 = addf %56, %61 : f64
                  %c-1_65 = constant -1 : index
                  %63 = addi %26, %c-1_65 : index
                  %c1_66 = constant 1 : index
                  %64 = addi %25, %c1_66 : index
                  %65 = memref.load %arg0[%63, %64, %24] : memref<258x258x258xf64>
                  %66 = mulf %cst_6, %65 : f64
                  %67 = addf %62, %66 : f64
                  %c-1_67 = constant -1 : index
                  %68 = addi %26, %c-1_67 : index
                  %c1_68 = constant 1 : index
                  %69 = addi %25, %c1_68 : index
                  %c1_69 = constant 1 : index
                  %70 = addi %24, %c1_69 : index
                  %71 = memref.load %arg0[%68, %69, %70] : memref<258x258x258xf64>
                  %72 = mulf %cst_7, %71 : f64
                  %73 = addf %67, %72 : f64
                  %c-1_70 = constant -1 : index
                  %74 = addi %25, %c-1_70 : index
                  %c-1_71 = constant -1 : index
                  %75 = addi %24, %c-1_71 : index
                  %76 = memref.load %arg0[%26, %74, %75] : memref<258x258x258xf64>
                  %77 = mulf %cst, %76 : f64
                  %78 = addf %73, %77 : f64
                  %c-1_72 = constant -1 : index
                  %79 = addi %25, %c-1_72 : index
                  %80 = memref.load %arg0[%26, %79, %24] : memref<258x258x258xf64>
                  %81 = mulf %cst_0, %80 : f64
                  %82 = addf %78, %81 : f64
                  %c-1_73 = constant -1 : index
                  %83 = addi %25, %c-1_73 : index
                  %c1_74 = constant 1 : index
                  %84 = addi %24, %c1_74 : index
                  %85 = memref.load %arg0[%26, %83, %84] : memref<258x258x258xf64>
                  %86 = mulf %cst_1, %85 : f64
                  %87 = addf %82, %86 : f64
                  %c-1_75 = constant -1 : index
                  %88 = addi %24, %c-1_75 : index
                  %89 = memref.load %arg0[%26, %25, %88] : memref<258x258x258xf64>
                  %90 = mulf %cst_2, %89 : f64
                  %91 = addf %87, %90 : f64
                  %92 = memref.load %arg0[%26, %25, %24] : memref<258x258x258xf64>
                  %93 = mulf %cst_3, %92 : f64
                  %94 = addf %91, %93 : f64
                  %c1_76 = constant 1 : index
                  %95 = addi %24, %c1_76 : index
                  %96 = memref.load %arg0[%26, %25, %95] : memref<258x258x258xf64>
                  %97 = mulf %cst_4, %96 : f64
                  %98 = addf %94, %97 : f64
                  %c1_77 = constant 1 : index
                  %99 = addi %25, %c1_77 : index
                  %c-1_78 = constant -1 : index
                  %100 = addi %24, %c-1_78 : index
                  %101 = memref.load %arg0[%26, %99, %100] : memref<258x258x258xf64>
                  %102 = mulf %cst_5, %101 : f64
                  %103 = addf %98, %102 : f64
                  %c1_79 = constant 1 : index
                  %104 = addi %25, %c1_79 : index
                  %105 = memref.load %arg0[%26, %104, %24] : memref<258x258x258xf64>
                  %106 = mulf %cst_6, %105 : f64
                  %107 = addf %103, %106 : f64
                  %c1_80 = constant 1 : index
                  %108 = addi %25, %c1_80 : index
                  %c1_81 = constant 1 : index
                  %109 = addi %24, %c1_81 : index
                  %110 = memref.load %arg0[%26, %108, %109] : memref<258x258x258xf64>
                  %111 = mulf %cst_7, %110 : f64
                  %112 = addf %107, %111 : f64
                  %c1_82 = constant 1 : index
                  %113 = addi %26, %c1_82 : index
                  %c-1_83 = constant -1 : index
                  %114 = addi %25, %c-1_83 : index
                  %c-1_84 = constant -1 : index
                  %115 = addi %24, %c-1_84 : index
                  %116 = memref.load %arg0[%113, %114, %115] : memref<258x258x258xf64>
                  %117 = mulf %cst, %116 : f64
                  %118 = addf %112, %117 : f64
                  %c1_85 = constant 1 : index
                  %119 = addi %26, %c1_85 : index
                  %c-1_86 = constant -1 : index
                  %120 = addi %25, %c-1_86 : index
                  %121 = memref.load %arg0[%119, %120, %24] : memref<258x258x258xf64>
                  %122 = mulf %cst_0, %121 : f64
                  %123 = addf %118, %122 : f64
                  %c1_87 = constant 1 : index
                  %124 = addi %26, %c1_87 : index
                  %c-1_88 = constant -1 : index
                  %125 = addi %25, %c-1_88 : index
                  %c1_89 = constant 1 : index
                  %126 = addi %24, %c1_89 : index
                  %127 = memref.load %arg0[%124, %125, %126] : memref<258x258x258xf64>
                  %128 = mulf %cst_1, %127 : f64
                  %129 = addf %123, %128 : f64
                  %c1_90 = constant 1 : index
                  %130 = addi %26, %c1_90 : index
                  %c-1_91 = constant -1 : index
                  %131 = addi %24, %c-1_91 : index
                  %132 = memref.load %arg0[%130, %25, %131] : memref<258x258x258xf64>
                  %133 = mulf %cst_2, %132 : f64
                  %134 = addf %129, %133 : f64
                  %c1_92 = constant 1 : index
                  %135 = addi %26, %c1_92 : index
                  %136 = memref.load %arg0[%135, %25, %24] : memref<258x258x258xf64>
                  %137 = mulf %cst_3, %136 : f64
                  %138 = addf %134, %137 : f64
                  %c1_93 = constant 1 : index
                  %139 = addi %26, %c1_93 : index
                  %c1_94 = constant 1 : index
                  %140 = addi %24, %c1_94 : index
                  %141 = memref.load %arg0[%139, %25, %140] : memref<258x258x258xf64>
                  %142 = mulf %cst_4, %141 : f64
                  %143 = addf %138, %142 : f64
                  %c1_95 = constant 1 : index
                  %144 = addi %26, %c1_95 : index
                  %c1_96 = constant 1 : index
                  %145 = addi %25, %c1_96 : index
                  %c-1_97 = constant -1 : index
                  %146 = addi %24, %c-1_97 : index
                  %147 = memref.load %arg0[%144, %145, %146] : memref<258x258x258xf64>
                  %148 = mulf %cst_5, %147 : f64
                  %149 = addf %143, %148 : f64
                  %c1_98 = constant 1 : index
                  %150 = addi %26, %c1_98 : index
                  %c1_99 = constant 1 : index
                  %151 = addi %25, %c1_99 : index
                  %152 = memref.load %arg0[%150, %151, %24] : memref<258x258x258xf64>
                  %153 = mulf %cst_6, %152 : f64
                  %154 = addf %149, %153 : f64
                  %c1_100 = constant 1 : index
                  %155 = addi %26, %c1_100 : index
                  %c1_101 = constant 1 : index
                  %156 = addi %25, %c1_101 : index
                  %c1_102 = constant 1 : index
                  %157 = addi %24, %c1_102 : index
                  %158 = memref.load %arg0[%155, %156, %157] : memref<258x258x258xf64>
                  %159 = mulf %cst_7, %158 : f64
                  %160 = addf %154, %159 : f64
                  memref.store %160, %arg1[%26, %25, %24] : memref<258x258x258xf64>
                }
              }
            }
          }
        }
      }
      scf.yield
    }
    return
  }
  func @stencil_3d27pt_box_iteration(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) attributes {llvm.emit_c_interface} {
    call @stencil_3d27pt_box(%arg0, %arg1) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
    call @stencil_3d27pt_box(%arg1, %arg0) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
    return
  }
}


// -----// IR Dump After {anonymous}::GPUParallelLoopMappingPass //----- //
func @stencil_3d27pt_box_iteration(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) attributes {llvm.emit_c_interface} {
  call @stencil_3d27pt_box(%arg0, %arg1) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
  call @stencil_3d27pt_box(%arg1, %arg0) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
  return
}

// -----// IR Dump After {anonymous}::GPUParallelLoopMappingPass //----- //
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
  %c0 = constant 0 : index
  %c4 = constant 4 : index
  %c0_8 = constant 0 : index
  %c4_9 = constant 4 : index
  %c0_10 = constant 0 : index
  %c4_11 = constant 4 : index
  %c0_12 = constant 0 : index
  %c8 = constant 8 : index
  %c0_13 = constant 0 : index
  %c8_14 = constant 8 : index
  %c0_15 = constant 0 : index
  %c8_16 = constant 8 : index
  %c1 = constant 1 : index
  %c1_17 = constant 1 : index
  %c1_18 = constant 1 : index
  %c1_19 = constant 1 : index
  %c1_20 = constant 1 : index
  %c1_21 = constant 1 : index
  scf.parallel (%arg2, %arg3, %arg4, %arg5, %arg6, %arg7) = (%c0, %c0_8, %c0_10, %c0_12, %c0_13, %c0_15) to (%c4, %c4_9, %c4_11, %c8, %c8_14, %c8_16) step (%c1, %c1_17, %c1_18, %c1_19, %c1_20, %c1_21) {
    %c64 = constant 64 : index
    %0 = muli %arg2, %c64 : index
    %c8_22 = constant 8 : index
    %1 = muli %arg5, %c8_22 : index
    %2 = addi %0, %1 : index
    %c1_23 = constant 1 : index
    %3 = addi %2, %c1_23 : index
    %c64_24 = constant 64 : index
    %4 = muli %arg2, %c64_24 : index
    %c8_25 = constant 8 : index
    %5 = muli %arg5, %c8_25 : index
    %6 = addi %4, %5 : index
    %c9 = constant 9 : index
    %7 = addi %6, %c9 : index
    %c4_26 = constant 4 : index
    scf.for %arg8 = %3 to %7 step %c4_26 {
      %c64_27 = constant 64 : index
      %8 = muli %arg3, %c64_27 : index
      %c8_28 = constant 8 : index
      %9 = muli %arg6, %c8_28 : index
      %10 = addi %8, %9 : index
      %c1_29 = constant 1 : index
      %11 = addi %10, %c1_29 : index
      %c64_30 = constant 64 : index
      %12 = muli %arg3, %c64_30 : index
      %c8_31 = constant 8 : index
      %13 = muli %arg6, %c8_31 : index
      %14 = addi %12, %13 : index
      %c9_32 = constant 9 : index
      %15 = addi %14, %c9_32 : index
      %c4_33 = constant 4 : index
      scf.for %arg9 = %11 to %15 step %c4_33 {
        %c64_34 = constant 64 : index
        %16 = muli %arg4, %c64_34 : index
        %c8_35 = constant 8 : index
        %17 = muli %arg7, %c8_35 : index
        %18 = addi %16, %17 : index
        %c1_36 = constant 1 : index
        %19 = addi %18, %c1_36 : index
        %c64_37 = constant 64 : index
        %20 = muli %arg4, %c64_37 : index
        %c8_38 = constant 8 : index
        %21 = muli %arg7, %c8_38 : index
        %22 = addi %20, %21 : index
        %c9_39 = constant 9 : index
        %23 = addi %22, %c9_39 : index
        %c4_40 = constant 4 : index
        scf.for %arg10 = %19 to %23 step %c4_40 {
          %c0_41 = constant 0 : index
          %c4_42 = constant 4 : index
          %c1_43 = constant 1 : index
          scf.for %arg11 = %c0_41 to %c4_42 step %c1_43 {
            %c0_44 = constant 0 : index
            %c4_45 = constant 4 : index
            %c1_46 = constant 1 : index
            scf.for %arg12 = %c0_44 to %c4_45 step %c1_46 {
              %c0_47 = constant 0 : index
              %c4_48 = constant 4 : index
              %c1_49 = constant 1 : index
              scf.for %arg13 = %c0_47 to %c4_48 step %c1_49 {
                %24 = addi %arg10, %arg13 : index
                %25 = addi %arg9, %arg12 : index
                %26 = addi %arg8, %arg11 : index
                %c-1 = constant -1 : index
                %27 = addi %26, %c-1 : index
                %c-1_50 = constant -1 : index
                %28 = addi %25, %c-1_50 : index
                %c-1_51 = constant -1 : index
                %29 = addi %24, %c-1_51 : index
                %30 = memref.load %arg0[%27, %28, %29] : memref<258x258x258xf64>
                %31 = mulf %cst, %30 : f64
                %c-1_52 = constant -1 : index
                %32 = addi %26, %c-1_52 : index
                %c-1_53 = constant -1 : index
                %33 = addi %25, %c-1_53 : index
                %34 = memref.load %arg0[%32, %33, %24] : memref<258x258x258xf64>
                %35 = mulf %cst_0, %34 : f64
                %36 = addf %31, %35 : f64
                %c-1_54 = constant -1 : index
                %37 = addi %26, %c-1_54 : index
                %c-1_55 = constant -1 : index
                %38 = addi %25, %c-1_55 : index
                %c1_56 = constant 1 : index
                %39 = addi %24, %c1_56 : index
                %40 = memref.load %arg0[%37, %38, %39] : memref<258x258x258xf64>
                %41 = mulf %cst_1, %40 : f64
                %42 = addf %36, %41 : f64
                %c-1_57 = constant -1 : index
                %43 = addi %26, %c-1_57 : index
                %c-1_58 = constant -1 : index
                %44 = addi %24, %c-1_58 : index
                %45 = memref.load %arg0[%43, %25, %44] : memref<258x258x258xf64>
                %46 = mulf %cst_2, %45 : f64
                %47 = addf %42, %46 : f64
                %c-1_59 = constant -1 : index
                %48 = addi %26, %c-1_59 : index
                %49 = memref.load %arg0[%48, %25, %24] : memref<258x258x258xf64>
                %50 = mulf %cst_3, %49 : f64
                %51 = addf %47, %50 : f64
                %c-1_60 = constant -1 : index
                %52 = addi %26, %c-1_60 : index
                %c1_61 = constant 1 : index
                %53 = addi %24, %c1_61 : index
                %54 = memref.load %arg0[%52, %25, %53] : memref<258x258x258xf64>
                %55 = mulf %cst_4, %54 : f64
                %56 = addf %51, %55 : f64
                %c-1_62 = constant -1 : index
                %57 = addi %26, %c-1_62 : index
                %c1_63 = constant 1 : index
                %58 = addi %25, %c1_63 : index
                %c-1_64 = constant -1 : index
                %59 = addi %24, %c-1_64 : index
                %60 = memref.load %arg0[%57, %58, %59] : memref<258x258x258xf64>
                %61 = mulf %cst_5, %60 : f64
                %62 = addf %56, %61 : f64
                %c-1_65 = constant -1 : index
                %63 = addi %26, %c-1_65 : index
                %c1_66 = constant 1 : index
                %64 = addi %25, %c1_66 : index
                %65 = memref.load %arg0[%63, %64, %24] : memref<258x258x258xf64>
                %66 = mulf %cst_6, %65 : f64
                %67 = addf %62, %66 : f64
                %c-1_67 = constant -1 : index
                %68 = addi %26, %c-1_67 : index
                %c1_68 = constant 1 : index
                %69 = addi %25, %c1_68 : index
                %c1_69 = constant 1 : index
                %70 = addi %24, %c1_69 : index
                %71 = memref.load %arg0[%68, %69, %70] : memref<258x258x258xf64>
                %72 = mulf %cst_7, %71 : f64
                %73 = addf %67, %72 : f64
                %c-1_70 = constant -1 : index
                %74 = addi %25, %c-1_70 : index
                %c-1_71 = constant -1 : index
                %75 = addi %24, %c-1_71 : index
                %76 = memref.load %arg0[%26, %74, %75] : memref<258x258x258xf64>
                %77 = mulf %cst, %76 : f64
                %78 = addf %73, %77 : f64
                %c-1_72 = constant -1 : index
                %79 = addi %25, %c-1_72 : index
                %80 = memref.load %arg0[%26, %79, %24] : memref<258x258x258xf64>
                %81 = mulf %cst_0, %80 : f64
                %82 = addf %78, %81 : f64
                %c-1_73 = constant -1 : index
                %83 = addi %25, %c-1_73 : index
                %c1_74 = constant 1 : index
                %84 = addi %24, %c1_74 : index
                %85 = memref.load %arg0[%26, %83, %84] : memref<258x258x258xf64>
                %86 = mulf %cst_1, %85 : f64
                %87 = addf %82, %86 : f64
                %c-1_75 = constant -1 : index
                %88 = addi %24, %c-1_75 : index
                %89 = memref.load %arg0[%26, %25, %88] : memref<258x258x258xf64>
                %90 = mulf %cst_2, %89 : f64
                %91 = addf %87, %90 : f64
                %92 = memref.load %arg0[%26, %25, %24] : memref<258x258x258xf64>
                %93 = mulf %cst_3, %92 : f64
                %94 = addf %91, %93 : f64
                %c1_76 = constant 1 : index
                %95 = addi %24, %c1_76 : index
                %96 = memref.load %arg0[%26, %25, %95] : memref<258x258x258xf64>
                %97 = mulf %cst_4, %96 : f64
                %98 = addf %94, %97 : f64
                %c1_77 = constant 1 : index
                %99 = addi %25, %c1_77 : index
                %c-1_78 = constant -1 : index
                %100 = addi %24, %c-1_78 : index
                %101 = memref.load %arg0[%26, %99, %100] : memref<258x258x258xf64>
                %102 = mulf %cst_5, %101 : f64
                %103 = addf %98, %102 : f64
                %c1_79 = constant 1 : index
                %104 = addi %25, %c1_79 : index
                %105 = memref.load %arg0[%26, %104, %24] : memref<258x258x258xf64>
                %106 = mulf %cst_6, %105 : f64
                %107 = addf %103, %106 : f64
                %c1_80 = constant 1 : index
                %108 = addi %25, %c1_80 : index
                %c1_81 = constant 1 : index
                %109 = addi %24, %c1_81 : index
                %110 = memref.load %arg0[%26, %108, %109] : memref<258x258x258xf64>
                %111 = mulf %cst_7, %110 : f64
                %112 = addf %107, %111 : f64
                %c1_82 = constant 1 : index
                %113 = addi %26, %c1_82 : index
                %c-1_83 = constant -1 : index
                %114 = addi %25, %c-1_83 : index
                %c-1_84 = constant -1 : index
                %115 = addi %24, %c-1_84 : index
                %116 = memref.load %arg0[%113, %114, %115] : memref<258x258x258xf64>
                %117 = mulf %cst, %116 : f64
                %118 = addf %112, %117 : f64
                %c1_85 = constant 1 : index
                %119 = addi %26, %c1_85 : index
                %c-1_86 = constant -1 : index
                %120 = addi %25, %c-1_86 : index
                %121 = memref.load %arg0[%119, %120, %24] : memref<258x258x258xf64>
                %122 = mulf %cst_0, %121 : f64
                %123 = addf %118, %122 : f64
                %c1_87 = constant 1 : index
                %124 = addi %26, %c1_87 : index
                %c-1_88 = constant -1 : index
                %125 = addi %25, %c-1_88 : index
                %c1_89 = constant 1 : index
                %126 = addi %24, %c1_89 : index
                %127 = memref.load %arg0[%124, %125, %126] : memref<258x258x258xf64>
                %128 = mulf %cst_1, %127 : f64
                %129 = addf %123, %128 : f64
                %c1_90 = constant 1 : index
                %130 = addi %26, %c1_90 : index
                %c-1_91 = constant -1 : index
                %131 = addi %24, %c-1_91 : index
                %132 = memref.load %arg0[%130, %25, %131] : memref<258x258x258xf64>
                %133 = mulf %cst_2, %132 : f64
                %134 = addf %129, %133 : f64
                %c1_92 = constant 1 : index
                %135 = addi %26, %c1_92 : index
                %136 = memref.load %arg0[%135, %25, %24] : memref<258x258x258xf64>
                %137 = mulf %cst_3, %136 : f64
                %138 = addf %134, %137 : f64
                %c1_93 = constant 1 : index
                %139 = addi %26, %c1_93 : index
                %c1_94 = constant 1 : index
                %140 = addi %24, %c1_94 : index
                %141 = memref.load %arg0[%139, %25, %140] : memref<258x258x258xf64>
                %142 = mulf %cst_4, %141 : f64
                %143 = addf %138, %142 : f64
                %c1_95 = constant 1 : index
                %144 = addi %26, %c1_95 : index
                %c1_96 = constant 1 : index
                %145 = addi %25, %c1_96 : index
                %c-1_97 = constant -1 : index
                %146 = addi %24, %c-1_97 : index
                %147 = memref.load %arg0[%144, %145, %146] : memref<258x258x258xf64>
                %148 = mulf %cst_5, %147 : f64
                %149 = addf %143, %148 : f64
                %c1_98 = constant 1 : index
                %150 = addi %26, %c1_98 : index
                %c1_99 = constant 1 : index
                %151 = addi %25, %c1_99 : index
                %152 = memref.load %arg0[%150, %151, %24] : memref<258x258x258xf64>
                %153 = mulf %cst_6, %152 : f64
                %154 = addf %149, %153 : f64
                %c1_100 = constant 1 : index
                %155 = addi %26, %c1_100 : index
                %c1_101 = constant 1 : index
                %156 = addi %25, %c1_101 : index
                %c1_102 = constant 1 : index
                %157 = addi %24, %c1_102 : index
                %158 = memref.load %arg0[%155, %156, %157] : memref<258x258x258xf64>
                %159 = mulf %cst_7, %158 : f64
                %160 = addf %154, %159 : f64
                memref.store %160, %arg1[%26, %25, %24] : memref<258x258x258xf64>
              }
            }
          }
        }
      }
    }
    scf.yield
  } {mapping = [{bound = affine_map<(d0) -> (d0)>, map = affine_map<(d0) -> (d0)>, processor = 0 : i64}, {bound = affine_map<(d0) -> (d0)>, map = affine_map<(d0) -> (d0)>, processor = 1 : i64}, {bound = affine_map<(d0) -> (d0)>, map = affine_map<(d0) -> (d0)>, processor = 2 : i64}, {bound = affine_map<(d0) -> (d0)>, map = affine_map<(d0) -> (d0)>, processor = 6 : i64}, {bound = affine_map<(d0) -> (d0)>, map = affine_map<(d0) -> (d0)>, processor = 6 : i64}, {bound = affine_map<(d0) -> (d0)>, map = affine_map<(d0) -> (d0)>, processor = 6 : i64}]}
  return
}

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
    %c0 = constant 0 : index
    %c4 = constant 4 : index
    %c0_8 = constant 0 : index
    %c4_9 = constant 4 : index
    %c0_10 = constant 0 : index
    %c4_11 = constant 4 : index
    %c0_12 = constant 0 : index
    %c8 = constant 8 : index
    %c0_13 = constant 0 : index
    %c8_14 = constant 8 : index
    %c0_15 = constant 0 : index
    %c8_16 = constant 8 : index
    %c1 = constant 1 : index
    %c1_17 = constant 1 : index
    %c1_18 = constant 1 : index
    %c1_19 = constant 1 : index
    %c1_20 = constant 1 : index
    %c1_21 = constant 1 : index
    scf.parallel (%arg2, %arg3, %arg4, %arg5, %arg6, %arg7) = (%c0, %c0_8, %c0_10, %c0_12, %c0_13, %c0_15) to (%c4, %c4_9, %c4_11, %c8, %c8_14, %c8_16) step (%c1, %c1_17, %c1_18, %c1_19, %c1_20, %c1_21) {
      %c64 = constant 64 : index
      %0 = muli %arg2, %c64 : index
      %c8_22 = constant 8 : index
      %1 = muli %arg5, %c8_22 : index
      %2 = addi %0, %1 : index
      %c1_23 = constant 1 : index
      %3 = addi %2, %c1_23 : index
      %c64_24 = constant 64 : index
      %4 = muli %arg2, %c64_24 : index
      %c8_25 = constant 8 : index
      %5 = muli %arg5, %c8_25 : index
      %6 = addi %4, %5 : index
      %c9 = constant 9 : index
      %7 = addi %6, %c9 : index
      %c4_26 = constant 4 : index
      scf.for %arg8 = %3 to %7 step %c4_26 {
        %c64_27 = constant 64 : index
        %8 = muli %arg3, %c64_27 : index
        %c8_28 = constant 8 : index
        %9 = muli %arg6, %c8_28 : index
        %10 = addi %8, %9 : index
        %c1_29 = constant 1 : index
        %11 = addi %10, %c1_29 : index
        %c64_30 = constant 64 : index
        %12 = muli %arg3, %c64_30 : index
        %c8_31 = constant 8 : index
        %13 = muli %arg6, %c8_31 : index
        %14 = addi %12, %13 : index
        %c9_32 = constant 9 : index
        %15 = addi %14, %c9_32 : index
        %c4_33 = constant 4 : index
        scf.for %arg9 = %11 to %15 step %c4_33 {
          %c64_34 = constant 64 : index
          %16 = muli %arg4, %c64_34 : index
          %c8_35 = constant 8 : index
          %17 = muli %arg7, %c8_35 : index
          %18 = addi %16, %17 : index
          %c1_36 = constant 1 : index
          %19 = addi %18, %c1_36 : index
          %c64_37 = constant 64 : index
          %20 = muli %arg4, %c64_37 : index
          %c8_38 = constant 8 : index
          %21 = muli %arg7, %c8_38 : index
          %22 = addi %20, %21 : index
          %c9_39 = constant 9 : index
          %23 = addi %22, %c9_39 : index
          %c4_40 = constant 4 : index
          scf.for %arg10 = %19 to %23 step %c4_40 {
            %c0_41 = constant 0 : index
            %c4_42 = constant 4 : index
            %c1_43 = constant 1 : index
            scf.for %arg11 = %c0_41 to %c4_42 step %c1_43 {
              %c0_44 = constant 0 : index
              %c4_45 = constant 4 : index
              %c1_46 = constant 1 : index
              scf.for %arg12 = %c0_44 to %c4_45 step %c1_46 {
                %c0_47 = constant 0 : index
                %c4_48 = constant 4 : index
                %c1_49 = constant 1 : index
                scf.for %arg13 = %c0_47 to %c4_48 step %c1_49 {
                  %24 = addi %arg10, %arg13 : index
                  %25 = addi %arg9, %arg12 : index
                  %26 = addi %arg8, %arg11 : index
                  %c-1 = constant -1 : index
                  %27 = addi %26, %c-1 : index
                  %c-1_50 = constant -1 : index
                  %28 = addi %25, %c-1_50 : index
                  %c-1_51 = constant -1 : index
                  %29 = addi %24, %c-1_51 : index
                  %30 = memref.load %arg0[%27, %28, %29] : memref<258x258x258xf64>
                  %31 = mulf %cst, %30 : f64
                  %c-1_52 = constant -1 : index
                  %32 = addi %26, %c-1_52 : index
                  %c-1_53 = constant -1 : index
                  %33 = addi %25, %c-1_53 : index
                  %34 = memref.load %arg0[%32, %33, %24] : memref<258x258x258xf64>
                  %35 = mulf %cst_0, %34 : f64
                  %36 = addf %31, %35 : f64
                  %c-1_54 = constant -1 : index
                  %37 = addi %26, %c-1_54 : index
                  %c-1_55 = constant -1 : index
                  %38 = addi %25, %c-1_55 : index
                  %c1_56 = constant 1 : index
                  %39 = addi %24, %c1_56 : index
                  %40 = memref.load %arg0[%37, %38, %39] : memref<258x258x258xf64>
                  %41 = mulf %cst_1, %40 : f64
                  %42 = addf %36, %41 : f64
                  %c-1_57 = constant -1 : index
                  %43 = addi %26, %c-1_57 : index
                  %c-1_58 = constant -1 : index
                  %44 = addi %24, %c-1_58 : index
                  %45 = memref.load %arg0[%43, %25, %44] : memref<258x258x258xf64>
                  %46 = mulf %cst_2, %45 : f64
                  %47 = addf %42, %46 : f64
                  %c-1_59 = constant -1 : index
                  %48 = addi %26, %c-1_59 : index
                  %49 = memref.load %arg0[%48, %25, %24] : memref<258x258x258xf64>
                  %50 = mulf %cst_3, %49 : f64
                  %51 = addf %47, %50 : f64
                  %c-1_60 = constant -1 : index
                  %52 = addi %26, %c-1_60 : index
                  %c1_61 = constant 1 : index
                  %53 = addi %24, %c1_61 : index
                  %54 = memref.load %arg0[%52, %25, %53] : memref<258x258x258xf64>
                  %55 = mulf %cst_4, %54 : f64
                  %56 = addf %51, %55 : f64
                  %c-1_62 = constant -1 : index
                  %57 = addi %26, %c-1_62 : index
                  %c1_63 = constant 1 : index
                  %58 = addi %25, %c1_63 : index
                  %c-1_64 = constant -1 : index
                  %59 = addi %24, %c-1_64 : index
                  %60 = memref.load %arg0[%57, %58, %59] : memref<258x258x258xf64>
                  %61 = mulf %cst_5, %60 : f64
                  %62 = addf %56, %61 : f64
                  %c-1_65 = constant -1 : index
                  %63 = addi %26, %c-1_65 : index
                  %c1_66 = constant 1 : index
                  %64 = addi %25, %c1_66 : index
                  %65 = memref.load %arg0[%63, %64, %24] : memref<258x258x258xf64>
                  %66 = mulf %cst_6, %65 : f64
                  %67 = addf %62, %66 : f64
                  %c-1_67 = constant -1 : index
                  %68 = addi %26, %c-1_67 : index
                  %c1_68 = constant 1 : index
                  %69 = addi %25, %c1_68 : index
                  %c1_69 = constant 1 : index
                  %70 = addi %24, %c1_69 : index
                  %71 = memref.load %arg0[%68, %69, %70] : memref<258x258x258xf64>
                  %72 = mulf %cst_7, %71 : f64
                  %73 = addf %67, %72 : f64
                  %c-1_70 = constant -1 : index
                  %74 = addi %25, %c-1_70 : index
                  %c-1_71 = constant -1 : index
                  %75 = addi %24, %c-1_71 : index
                  %76 = memref.load %arg0[%26, %74, %75] : memref<258x258x258xf64>
                  %77 = mulf %cst, %76 : f64
                  %78 = addf %73, %77 : f64
                  %c-1_72 = constant -1 : index
                  %79 = addi %25, %c-1_72 : index
                  %80 = memref.load %arg0[%26, %79, %24] : memref<258x258x258xf64>
                  %81 = mulf %cst_0, %80 : f64
                  %82 = addf %78, %81 : f64
                  %c-1_73 = constant -1 : index
                  %83 = addi %25, %c-1_73 : index
                  %c1_74 = constant 1 : index
                  %84 = addi %24, %c1_74 : index
                  %85 = memref.load %arg0[%26, %83, %84] : memref<258x258x258xf64>
                  %86 = mulf %cst_1, %85 : f64
                  %87 = addf %82, %86 : f64
                  %c-1_75 = constant -1 : index
                  %88 = addi %24, %c-1_75 : index
                  %89 = memref.load %arg0[%26, %25, %88] : memref<258x258x258xf64>
                  %90 = mulf %cst_2, %89 : f64
                  %91 = addf %87, %90 : f64
                  %92 = memref.load %arg0[%26, %25, %24] : memref<258x258x258xf64>
                  %93 = mulf %cst_3, %92 : f64
                  %94 = addf %91, %93 : f64
                  %c1_76 = constant 1 : index
                  %95 = addi %24, %c1_76 : index
                  %96 = memref.load %arg0[%26, %25, %95] : memref<258x258x258xf64>
                  %97 = mulf %cst_4, %96 : f64
                  %98 = addf %94, %97 : f64
                  %c1_77 = constant 1 : index
                  %99 = addi %25, %c1_77 : index
                  %c-1_78 = constant -1 : index
                  %100 = addi %24, %c-1_78 : index
                  %101 = memref.load %arg0[%26, %99, %100] : memref<258x258x258xf64>
                  %102 = mulf %cst_5, %101 : f64
                  %103 = addf %98, %102 : f64
                  %c1_79 = constant 1 : index
                  %104 = addi %25, %c1_79 : index
                  %105 = memref.load %arg0[%26, %104, %24] : memref<258x258x258xf64>
                  %106 = mulf %cst_6, %105 : f64
                  %107 = addf %103, %106 : f64
                  %c1_80 = constant 1 : index
                  %108 = addi %25, %c1_80 : index
                  %c1_81 = constant 1 : index
                  %109 = addi %24, %c1_81 : index
                  %110 = memref.load %arg0[%26, %108, %109] : memref<258x258x258xf64>
                  %111 = mulf %cst_7, %110 : f64
                  %112 = addf %107, %111 : f64
                  %c1_82 = constant 1 : index
                  %113 = addi %26, %c1_82 : index
                  %c-1_83 = constant -1 : index
                  %114 = addi %25, %c-1_83 : index
                  %c-1_84 = constant -1 : index
                  %115 = addi %24, %c-1_84 : index
                  %116 = memref.load %arg0[%113, %114, %115] : memref<258x258x258xf64>
                  %117 = mulf %cst, %116 : f64
                  %118 = addf %112, %117 : f64
                  %c1_85 = constant 1 : index
                  %119 = addi %26, %c1_85 : index
                  %c-1_86 = constant -1 : index
                  %120 = addi %25, %c-1_86 : index
                  %121 = memref.load %arg0[%119, %120, %24] : memref<258x258x258xf64>
                  %122 = mulf %cst_0, %121 : f64
                  %123 = addf %118, %122 : f64
                  %c1_87 = constant 1 : index
                  %124 = addi %26, %c1_87 : index
                  %c-1_88 = constant -1 : index
                  %125 = addi %25, %c-1_88 : index
                  %c1_89 = constant 1 : index
                  %126 = addi %24, %c1_89 : index
                  %127 = memref.load %arg0[%124, %125, %126] : memref<258x258x258xf64>
                  %128 = mulf %cst_1, %127 : f64
                  %129 = addf %123, %128 : f64
                  %c1_90 = constant 1 : index
                  %130 = addi %26, %c1_90 : index
                  %c-1_91 = constant -1 : index
                  %131 = addi %24, %c-1_91 : index
                  %132 = memref.load %arg0[%130, %25, %131] : memref<258x258x258xf64>
                  %133 = mulf %cst_2, %132 : f64
                  %134 = addf %129, %133 : f64
                  %c1_92 = constant 1 : index
                  %135 = addi %26, %c1_92 : index
                  %136 = memref.load %arg0[%135, %25, %24] : memref<258x258x258xf64>
                  %137 = mulf %cst_3, %136 : f64
                  %138 = addf %134, %137 : f64
                  %c1_93 = constant 1 : index
                  %139 = addi %26, %c1_93 : index
                  %c1_94 = constant 1 : index
                  %140 = addi %24, %c1_94 : index
                  %141 = memref.load %arg0[%139, %25, %140] : memref<258x258x258xf64>
                  %142 = mulf %cst_4, %141 : f64
                  %143 = addf %138, %142 : f64
                  %c1_95 = constant 1 : index
                  %144 = addi %26, %c1_95 : index
                  %c1_96 = constant 1 : index
                  %145 = addi %25, %c1_96 : index
                  %c-1_97 = constant -1 : index
                  %146 = addi %24, %c-1_97 : index
                  %147 = memref.load %arg0[%144, %145, %146] : memref<258x258x258xf64>
                  %148 = mulf %cst_5, %147 : f64
                  %149 = addf %143, %148 : f64
                  %c1_98 = constant 1 : index
                  %150 = addi %26, %c1_98 : index
                  %c1_99 = constant 1 : index
                  %151 = addi %25, %c1_99 : index
                  %152 = memref.load %arg0[%150, %151, %24] : memref<258x258x258xf64>
                  %153 = mulf %cst_6, %152 : f64
                  %154 = addf %149, %153 : f64
                  %c1_100 = constant 1 : index
                  %155 = addi %26, %c1_100 : index
                  %c1_101 = constant 1 : index
                  %156 = addi %25, %c1_101 : index
                  %c1_102 = constant 1 : index
                  %157 = addi %24, %c1_102 : index
                  %158 = memref.load %arg0[%155, %156, %157] : memref<258x258x258xf64>
                  %159 = mulf %cst_7, %158 : f64
                  %160 = addf %154, %159 : f64
                  memref.store %160, %arg1[%26, %25, %24] : memref<258x258x258xf64>
                }
              }
            }
          }
        }
      }
      scf.yield
    } {mapping = [{bound = affine_map<(d0) -> (d0)>, map = affine_map<(d0) -> (d0)>, processor = 0 : i64}, {bound = affine_map<(d0) -> (d0)>, map = affine_map<(d0) -> (d0)>, processor = 1 : i64}, {bound = affine_map<(d0) -> (d0)>, map = affine_map<(d0) -> (d0)>, processor = 2 : i64}, {bound = affine_map<(d0) -> (d0)>, map = affine_map<(d0) -> (d0)>, processor = 6 : i64}, {bound = affine_map<(d0) -> (d0)>, map = affine_map<(d0) -> (d0)>, processor = 6 : i64}, {bound = affine_map<(d0) -> (d0)>, map = affine_map<(d0) -> (d0)>, processor = 6 : i64}]}
    return
  }
  func @stencil_3d27pt_box_iteration(%arg0: memref<258x258x258xf64>, %arg1: memref<258x258x258xf64>) attributes {llvm.emit_c_interface} {
    call @stencil_3d27pt_box(%arg0, %arg1) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
    call @stencil_3d27pt_box(%arg1, %arg0) : (memref<258x258x258xf64>, memref<258x258x258xf64>) -> ()
    return
  }
}
