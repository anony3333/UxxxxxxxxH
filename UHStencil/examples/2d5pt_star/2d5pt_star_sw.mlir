module  {
  func @stencil_2d5pt(%arg0: memref<8194x8194xf64>, %arg1: memref<8194x8194xf64>) attributes {hardware = "sw", llvm.emit_c_interface} {
    %c4096 = constant 4096 : index
    %c8194 = constant 8194 : index
    %c64 = constant 64 : index
    %c0 = constant 0 : index
    %c4356 = constant 4356 : index
    %c66 = constant 66 : index
    %c1 = constant 1 : index
    %c8 = constant 8 : index
    scf.parallel (%arg2, %arg3, %arg4) = (%c0, %c0, %c0) to (%c1, %c8, %c8) step (%c1, %c1, %c1) {
      %c1024 = constant 1024 : index
      %0 = muli %arg4, %c1024 : index
      %1 = addi %0, %c1 : index
      %c1025 = constant 1025 : index
      %2 = addi %0, %c1025 : index
      scf.for %arg5 = %1 to %2 step %c64 {
        %3 = muli %arg3, %c1024 : index
        %4 = addi %3, %c1 : index
        %5 = addi %3, %c1025 : index
        scf.for %arg6 = %4 to %5 step %c64 {
          %6 = memref.alloc() : memref<66x66xf64, 3>
          %7 = memref.alloc() : memref<1xi32>
          %c-1 = constant -1 : index
          %8 = addi %arg5, %c-1 : index
          %9 = addi %arg6, %c-1 : index
          // DMA_get: src, dst, z_dim_size, cnt, stride, bsize
          // src, dst, ..., stride, bsize
          // cnt=dma传输数据量，stride=主存跨步，bsize=dma传输的跨步向量块大小
          // %c4356: cnt
          // %7[%c0]: TagMemRef
          memref.dma_start %arg0[%8, %9], %6[%c0, %c0], %c4356, %7[%c0], %c8194, %c66 : memref<8194x8194xf64>, memref<66x66xf64, 3>, memref<1xi32>
          memref.dma_wait %7[%c0], %c4356 : memref<1xi32>
          %10 = memref.alloc() : memref<64x64xf64, 3>
          %11 = memref.alloc() : memref<1xi32>
          %c4 = constant 4 : index
          scf.for %arg7 = %c0 to %c64 step %c4 {
            scf.for %arg8 = %c0 to %c64 step %c4 {
              scf.for %arg9 = %c0 to %c4 step %c1 {
                scf.for %arg10 = %c0 to %c4 step %c1 {
                  %12 = addi %arg7, %arg9 : index
                  %13 = addi %arg8, %arg10 : index
                  %cst = constant 1.000000e-01 : f64
                  %14 = addi %13, %c1 : index
                  %15 = memref.load %6[%12, %14] : memref<66x66xf64, 3>
                  %16 = mulf %cst, %15 : f64
                  %cst_0 = constant 2.000000e-01 : f64
                  %c2 = constant 2 : index
                  %17 = addi %12, %c2 : index
                  %18 = memref.load %6[%17, %14] : memref<66x66xf64, 3>
                  %19 = mulf %cst_0, %18 : f64
                  %20 = addf %16, %19 : f64
                  %cst_1 = constant 3.000000e-01 : f64
                  %21 = addi %12, %c1 : index
                  %22 = memref.load %6[%21, %14] : memref<66x66xf64, 3>
                  %23 = mulf %cst_1, %22 : f64
                  %24 = addf %20, %23 : f64
                  %cst_2 = constant 4.000000e-01 : f64
                  %25 = addi %13, %c2 : index
                  %26 = memref.load %6[%21, %25] : memref<66x66xf64, 3>
                  %27 = mulf %cst_2, %26 : f64
                  %28 = addf %24, %27 : f64
                  %cst_3 = constant 5.000000e-01 : f64
                  %29 = memref.load %6[%21, %13] : memref<66x66xf64, 3>
                  %30 = mulf %cst_3, %29 : f64
                  %31 = addf %28, %30 : f64
                  memref.store %31, %10[%12, %13] : memref<64x64xf64, 3>
                }
              }
            }
          }
          memref.dma_start %10[%c0, %c0], %arg1[%arg5, %arg6], %c4096, %11[%c0], %c8194, %c64 : memref<64x64xf64, 3>, memref<8194x8194xf64>, memref<1xi32>
          memref.dma_wait %11[%c0], %c4096 : memref<1xi32>
          memref.dealloc %11 : memref<1xi32>
          memref.dealloc %10 : memref<64x64xf64, 3>
          memref.dealloc %7 : memref<1xi32>
          memref.dealloc %6 : memref<66x66xf64, 3>
        }
      }
      scf.yield
    }
    return
  }
  func @stencil_2d5pt_iteration(%arg0: memref<8194x8194xf64>, %arg1: memref<8194x8194xf64>) attributes {llvm.emit_c_interface} {
    %c0 = constant 0 : index
    %c10 = constant 10 : index
    %c1 = constant 1 : index
    scf.for %arg2 = %c0 to %c10 step %c1 {
      call @stencil_2d5pt(%arg0, %arg1) : (memref<8194x8194xf64>, memref<8194x8194xf64>) -> ()
      call @stencil_2d5pt(%arg1, %arg0) : (memref<8194x8194xf64>, memref<8194x8194xf64>) -> ()
    }
    return
  }
}
