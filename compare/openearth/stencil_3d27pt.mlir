module {
func @fastwavesuv(%arg0: !stencil.field<?x?x?xf64>, %arg1: !stencil.field<?x?x?xf64>) attributes {stencil.program} {
%in0 = stencil.cast %arg0([-4, -4, -4] : [68, 68, 68]) : (!stencil.field<?x?x?xf64>) -> !stencil.field<72x72x72xf64>
%out0 = stencil.cast %arg1([-4, -4, -4] : [68, 68, 68]) : (!stencil.field<?x?x?xf64>) -> !stencil.field<72x72x72xf64>
%21 = stencil.load %in0 : (!stencil.field<72x72x72xf64>) -> !stencil.temp<?x?x?xf64>
%51 = stencil.apply (%arg2 = %21 : !stencil.temp<?x?x?xf64>) -> !stencil.temp<?x?x?xf64> {
%42 = constant 1.000000e-01: f64
%43 = constant 2.000000e-01: f64
%44 = constant 3.000000e-01: f64
%45 = stencil.access %arg2 [-1, -1, -1] : (!stencil.temp<?x?x?xf64>) -> f64
%46 = stencil.access %arg2 [-1, -1, 0] : (!stencil.temp<?x?x?xf64>) -> f64
%47 = stencil.access %arg2 [-1, -1, 1] : (!stencil.temp<?x?x?xf64>) -> f64
%48 = stencil.access %arg2 [-1, 0, -1] : (!stencil.temp<?x?x?xf64>) -> f64
%49 = stencil.access %arg2 [-1, 0, 0] : (!stencil.temp<?x?x?xf64>) -> f64
%50 = stencil.access %arg2 [-1, 0, 1] : (!stencil.temp<?x?x?xf64>) -> f64
%51 = stencil.access %arg2 [-1, 1, -1] : (!stencil.temp<?x?x?xf64>) -> f64
%52 = stencil.access %arg2 [-1, 1, 0] : (!stencil.temp<?x?x?xf64>) -> f64
%53 = stencil.access %arg2 [-1, 1, 1] : (!stencil.temp<?x?x?xf64>) -> f64
%54 = stencil.access %arg2 [0, -1, -1] : (!stencil.temp<?x?x?xf64>) -> f64
%55 = stencil.access %arg2 [0, -1, 0] : (!stencil.temp<?x?x?xf64>) -> f64
%56 = stencil.access %arg2 [0, -1, 1] : (!stencil.temp<?x?x?xf64>) -> f64
%57 = stencil.access %arg2 [0, 0, -1] : (!stencil.temp<?x?x?xf64>) -> f64
%58 = stencil.access %arg2 [0, 0, 0] : (!stencil.temp<?x?x?xf64>) -> f64
%59 = stencil.access %arg2 [0, 0, 1] : (!stencil.temp<?x?x?xf64>) -> f64
%60 = stencil.access %arg2 [0, 1, -1] : (!stencil.temp<?x?x?xf64>) -> f64
%61 = stencil.access %arg2 [0, 1, 0] : (!stencil.temp<?x?x?xf64>) -> f64
%62 = stencil.access %arg2 [0, 1, 1] : (!stencil.temp<?x?x?xf64>) -> f64
%63 = stencil.access %arg2 [1, -1, -1] : (!stencil.temp<?x?x?xf64>) -> f64
%64 = stencil.access %arg2 [1, -1, 0] : (!stencil.temp<?x?x?xf64>) -> f64
%65 = stencil.access %arg2 [1, -1, 1] : (!stencil.temp<?x?x?xf64>) -> f64
%66 = stencil.access %arg2 [1, 0, -1] : (!stencil.temp<?x?x?xf64>) -> f64
%67 = stencil.access %arg2 [1, 0, 0] : (!stencil.temp<?x?x?xf64>) -> f64
%68 = stencil.access %arg2 [1, 0, 1] : (!stencil.temp<?x?x?xf64>) -> f64
%69 = stencil.access %arg2 [1, 1, -1] : (!stencil.temp<?x?x?xf64>) -> f64
%70 = stencil.access %arg2 [1, 1, 0] : (!stencil.temp<?x?x?xf64>) -> f64
%71 = stencil.access %arg2 [1, 1, 1] : (!stencil.temp<?x?x?xf64>) -> f64
%72 = mulf %42, %45 : f64
%73 = mulf %43, %46 : f64
%74 = mulf %44, %47 : f64
%75 = mulf %42, %48 : f64
%76 = mulf %43, %49 : f64
%77 = mulf %44, %50 : f64
%78 = mulf %42, %51 : f64
%79 = mulf %43, %52 : f64
%80 = mulf %44, %53 : f64
%81 = mulf %42, %54 : f64
%82 = mulf %43, %55 : f64
%83 = mulf %44, %56 : f64
%84 = mulf %42, %57 : f64
%85 = mulf %43, %58 : f64
%86 = mulf %44, %59 : f64
%87 = mulf %42, %60 : f64
%88 = mulf %43, %61 : f64
%89 = mulf %44, %62 : f64
%90 = mulf %42, %63 : f64
%91 = mulf %43, %64 : f64
%92 = mulf %44, %65 : f64
%93 = mulf %42, %66 : f64
%94 = mulf %43, %67 : f64
%95 = mulf %44, %68 : f64
%96 = mulf %42, %69 : f64
%97 = mulf %43, %70 : f64
%98 = mulf %44, %71 : f64
%99 = addf %72, %73 : f64
%100 = addf %99, %74 : f64
%101 = addf %100, %75 : f64
%102 = addf %101, %76 : f64
%103 = addf %102, %77 : f64
%104 = addf %103, %78 : f64
%105 = addf %104, %79 : f64
%106 = addf %105, %80 : f64
%107 = addf %106, %81 : f64
%108 = addf %107, %82 : f64
%109 = addf %108, %83 : f64
%110 = addf %109, %84 : f64
%111 = addf %110, %85 : f64
%112 = addf %111, %86 : f64
%113 = addf %112, %87 : f64
%114 = addf %113, %88 : f64
%115 = addf %114, %89 : f64
%116 = addf %115, %90 : f64
%117 = addf %116, %91 : f64
%118 = addf %117, %92 : f64
%119 = addf %118, %93 : f64
%120 = addf %119, %94 : f64
%121 = addf %120, %95 : f64
%122 = addf %121, %96 : f64
%123 = addf %122, %97 : f64
%124 = addf %123, %98 : f64
%125 = stencil.store_result %124 : (f64) -> !stencil.result<f64>
stencil.return %125 : !stencil.result<f64>
}
stencil.store %51 to %out0([0, 0, 0] : [64, 64, 64]) : !stencil.temp<?x?x?xf64> to !stencil.field<72x72x72xf64>
return
}
}
