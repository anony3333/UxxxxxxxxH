module {
func @fastwavesuv(%arg0: !stencil.field<?x?x0xf64>, %arg1: !stencil.field<?x?x?xf64>) attributes {stencil.program} {
%in0 = stencil.cast %arg0([-4, -4, -4] : [68, 68, 68]) : (!stencil.field<?x?x0xf64>) -> !stencil.field<72x72x0xf64>
%out0 = stencil.cast %arg1([-4, -4, -4] : [68, 68, 68]) : (!stencil.field<?x?x?xf64>) -> !stencil.field<72x72x72xf64>
%21 = stencil.load %in0 : (!stencil.field<72x72x0xf64>) -> !stencil.temp<?x?x0xf64>
%51 = stencil.apply (%arg2 = %21 : !stencil.temp<?x?x0xf64>) -> !stencil.temp<?x?x?xf64> {
%42 = constant 1.000000e-01: f64
%43 = constant 2.000000e-01: f64
%44 = constant 3.000000e-01: f64
%45 = constant 4.000000e-01: f64
%46 = constant 5.000000e-01: f64
%47 = constant 6.000000e-01: f64
%48 = constant 7.000000e-01: f64
%49 = constant 8.000000e-01: f64
%50 = constant 9.000000e-01: f64
%51 = stencil.access %arg2 [-2, 0, 0] : (!stencil.temp<?x?x0xf64>) -> f64
%52 = stencil.access %arg2 [2, 0, 0] : (!stencil.temp<?x?x0xf64>) -> f64
%53 = stencil.access %arg2 [-1, 0, 0] : (!stencil.temp<?x?x0xf64>) -> f64
%54 = stencil.access %arg2 [1, 0, 0] : (!stencil.temp<?x?x0xf64>) -> f64
%55 = stencil.access %arg2 [0, 0, 0] : (!stencil.temp<?x?x0xf64>) -> f64
%56 = stencil.access %arg2 [0, 1, 0] : (!stencil.temp<?x?x0xf64>) -> f64
%57 = stencil.access %arg2 [0, -1, 0] : (!stencil.temp<?x?x0xf64>) -> f64
%58 = stencil.access %arg2 [0, 2, 0] : (!stencil.temp<?x?x0xf64>) -> f64
%59 = stencil.access %arg2 [0, -2, 0] : (!stencil.temp<?x?x0xf64>) -> f64
%60 = mulf %42, %51 : f64
%61 = mulf %43, %52 : f64
%62 = mulf %44, %53 : f64
%63 = mulf %45, %54 : f64
%64 = mulf %46, %55 : f64
%65 = mulf %47, %56 : f64
%66 = mulf %48, %57 : f64
%67 = mulf %49, %58 : f64
%68 = mulf %50, %59 : f64
%69 = addf %60, %61 : f64
%70 = addf %69, %62 : f64
%71 = addf %70, %63 : f64
%72 = addf %71, %64 : f64
%73 = addf %72, %65 : f64
%74 = addf %73, %66 : f64
%75 = addf %74, %67 : f64
%76 = addf %75, %68 : f64
%77 = stencil.store_result %76 : (f64) -> !stencil.result<f64>
stencil.return %77 : !stencil.result<f64>
}
stencil.store %51 to %out0([0, 0, 0] : [64, 64, 1]) : !stencil.temp<?x?x?xf64> to !stencil.field<72x72x72xf64>
return
}
}
