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
%47 = stencil.access %arg2 [-1, 0, 0] : (!stencil.temp<?x?x0xf64>) -> f64
%48 = stencil.access %arg2 [1, 0, 0] : (!stencil.temp<?x?x0xf64>) -> f64
%49 = stencil.access %arg2 [0, -1, 0] : (!stencil.temp<?x?x0xf64>) -> f64
%50 = stencil.access %arg2 [0, 1, 0] : (!stencil.temp<?x?x0xf64>) -> f64
%51 = stencil.access %arg2 [0, 0, 0] : (!stencil.temp<?x?x0xf64>) -> f64
%52 = mulf %42, %47 : f64
%53 = mulf %43, %48 : f64
%54 = mulf %44, %49 : f64
%55 = mulf %45, %50 : f64
%56 = mulf %46, %51 : f64
%57 = addf %52, %53 : f64
%58 = addf %57, %54 : f64
%59 = addf %58, %55 : f64
%60 = addf %59, %56 : f64
%61 = stencil.store_result %60 : (f64) -> !stencil.result<f64>
stencil.return %61 : !stencil.result<f64>
}
stencil.store %51 to %out0([0, 0, 0] : [64, 64, 1]) : !stencil.temp<?x?x?xf64> to !stencil.field<72x72x72xf64>
return
}
}
