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
%51 = constant 1.000000e+00: f64
%52 = constant 1.100000e+00: f64
%53 = constant 1.200000e+00: f64
%54 = constant 1.300000e+00: f64
%55 = stencil.access %arg2 [-3, 0, 0] : (!stencil.temp<?x?x0xf64>) -> f64
%56 = stencil.access %arg2 [-2, 0, 0] : (!stencil.temp<?x?x0xf64>) -> f64
%57 = stencil.access %arg2 [-1, 0, 0] : (!stencil.temp<?x?x0xf64>) -> f64
%58 = stencil.access %arg2 [0, 0, 0] : (!stencil.temp<?x?x0xf64>) -> f64
%59 = stencil.access %arg2 [1, 0, 0] : (!stencil.temp<?x?x0xf64>) -> f64
%60 = stencil.access %arg2 [2, 0, 0] : (!stencil.temp<?x?x0xf64>) -> f64
%61 = stencil.access %arg2 [3, 0, 0] : (!stencil.temp<?x?x0xf64>) -> f64
%62 = stencil.access %arg2 [0, -3, 0] : (!stencil.temp<?x?x0xf64>) -> f64
%63 = stencil.access %arg2 [0, -2, 0] : (!stencil.temp<?x?x0xf64>) -> f64
%64 = stencil.access %arg2 [0, -1, 0] : (!stencil.temp<?x?x0xf64>) -> f64
%65 = stencil.access %arg2 [0, 1, 0] : (!stencil.temp<?x?x0xf64>) -> f64
%66 = stencil.access %arg2 [0, 2, 0] : (!stencil.temp<?x?x0xf64>) -> f64
%67 = stencil.access %arg2 [0, 3, 0] : (!stencil.temp<?x?x0xf64>) -> f64
%68 = mulf %42, %55 : f64
%69 = mulf %43, %56 : f64
%70 = mulf %44, %57 : f64
%71 = mulf %45, %58 : f64
%72 = mulf %46, %59 : f64
%73 = mulf %47, %60 : f64
%74 = mulf %48, %61 : f64
%75 = mulf %49, %62 : f64
%76 = mulf %50, %63 : f64
%77 = mulf %51, %64 : f64
%78 = mulf %52, %65 : f64
%79 = mulf %53, %66 : f64
%80 = mulf %54, %67 : f64
%81 = addf %68, %69 : f64
%82 = addf %81, %70 : f64
%83 = addf %82, %71 : f64
%84 = addf %83, %72 : f64
%85 = addf %84, %73 : f64
%86 = addf %85, %74 : f64
%87 = addf %86, %75 : f64
%88 = addf %87, %76 : f64
%89 = addf %88, %77 : f64
%90 = addf %89, %78 : f64
%91 = addf %90, %79 : f64
%92 = addf %91, %80 : f64
%93 = stencil.store_result %92 : (f64) -> !stencil.result<f64>
stencil.return %93 : !stencil.result<f64>
}
stencil.store %51 to %out0([0, 0, 0] : [64, 64, 1]) : !stencil.temp<?x?x?xf64> to !stencil.field<72x72x72xf64>
return
}
}
