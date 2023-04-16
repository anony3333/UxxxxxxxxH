module {
func @fastwavesuv(%arg0: !stencil.field<?x?x?xf64>, %arg1: !stencil.field<?x?x?xf64>) attributes {stencil.program} {
%in0 = stencil.cast %arg0([-4, -4, -4] : [68, 68, 68]) : (!stencil.field<?x?x?xf64>) -> !stencil.field<72x72x72xf64>
%out0 = stencil.cast %arg1([-4, -4, -4] : [68, 68, 68]) : (!stencil.field<?x?x?xf64>) -> !stencil.field<72x72x72xf64>
%21 = stencil.load %in0 : (!stencil.field<72x72x72xf64>) -> !stencil.temp<?x?x?xf64>
%51 = stencil.apply (%arg2 = %21 : !stencil.temp<?x?x?xf64>) -> !stencil.temp<?x?x?xf64> {
%42 = constant 1.000000e-01: f64
%43 = constant 2.000000e-01: f64
%44 = constant 3.000000e-01: f64
%45 = constant 4.000000e-01: f64
%46 = constant 5.000000e-01: f64
%47 = constant 6.000000e-01: f64
%48 = constant 7.000000e-01: f64
%49 = stencil.access %arg2 [-1, 0, 0] : (!stencil.temp<?x?x?xf64>) -> f64
%50 = stencil.access %arg2 [1, 0, 0] : (!stencil.temp<?x?x?xf64>) -> f64
%51 = stencil.access %arg2 [0, -1, 0] : (!stencil.temp<?x?x?xf64>) -> f64
%52 = stencil.access %arg2 [0, 1, 0] : (!stencil.temp<?x?x?xf64>) -> f64
%53 = stencil.access %arg2 [0, 0, -1] : (!stencil.temp<?x?x?xf64>) -> f64
%54 = stencil.access %arg2 [0, 0, 1] : (!stencil.temp<?x?x?xf64>) -> f64
%55 = stencil.access %arg2 [0, 0, 0] : (!stencil.temp<?x?x?xf64>) -> f64
%56 = mulf %42, %49 : f64
%57 = mulf %43, %50 : f64
%58 = mulf %44, %51 : f64
%59 = mulf %45, %52 : f64
%60 = mulf %46, %53 : f64
%61 = mulf %47, %54 : f64
%62 = mulf %48, %55 : f64
%63 = addf %56, %57 : f64
%64 = addf %63, %58 : f64
%65 = addf %64, %59 : f64
%66 = addf %65, %60 : f64
%67 = addf %66, %61 : f64
%68 = addf %67, %62 : f64
%69 = stencil.store_result %68 : (f64) -> !stencil.result<f64>
stencil.return %69 : !stencil.result<f64>
}
stencil.store %51 to %out0([0, 0, 0] : [64, 64, 64]) : !stencil.temp<?x?x?xf64> to !stencil.field<72x72x72xf64>
return
}
}
