#map = affine_map<(d0) -> (d0)>
module @jit_absolute.70 {
  func @foo(%arg0: tensor<100xcomplex<f64>>) -> tensor<100xf64> {
    %0 = linalg.init_tensor [100] : tensor<100xf64>
    %1 = linalg.generic {indexing_maps = [#map, #map], iterator_types = ["parallel"]} ins(%arg0 : tensor<100xcomplex<f64>>) outs(%0 : tensor<100xf64>) {
    ^bb0(%arg1: complex<f64>, %arg2: f64):
      %12 = complex.re %arg1 : complex<f64>
      linalg.yield %12 : f64
    } -> tensor<100xf64>
    %2 = linalg.init_tensor [100] : tensor<100xf64>
    %3 = linalg.generic {indexing_maps = [#map, #map], iterator_types = ["parallel"]} ins(%arg0 : tensor<100xcomplex<f64>>) outs(%2 : tensor<100xf64>) {
    ^bb0(%arg1: complex<f64>, %arg2: f64):
      %12 = complex.im %arg1 : complex<f64>
      linalg.yield %12 : f64
    } -> tensor<100xf64>
    %4 = linalg.init_tensor [100] : tensor<100xf64>
    %5 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel"]} ins(%3, %3 : tensor<100xf64>, tensor<100xf64>) outs(%4 : tensor<100xf64>) {
    ^bb0(%arg1: f64, %arg2: f64, %arg3: f64):
      %12 = arith.mulf %arg1, %arg2 : f64
      linalg.yield %12 : f64
    } -> tensor<100xf64>
    %6 = linalg.init_tensor [100] : tensor<100xf64>
    %7 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel"]} ins(%1, %1 : tensor<100xf64>, tensor<100xf64>) outs(%6 : tensor<100xf64>) {
    ^bb0(%arg1: f64, %arg2: f64, %arg3: f64):
      %12 = arith.mulf %arg1, %arg2 : f64
      linalg.yield %12 : f64
    } -> tensor<100xf64>
    %8 = linalg.init_tensor [100] : tensor<100xf64>
    %9 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel"]} ins(%7, %5 : tensor<100xf64>, tensor<100xf64>) outs(%8 : tensor<100xf64>) {
    ^bb0(%arg1: f64, %arg2: f64, %arg3: f64):
      %12 = arith.addf %arg1, %arg2 : f64
      linalg.yield %12 : f64
    } -> tensor<100xf64>
    %10 = linalg.init_tensor [100] : tensor<100xf64>
    %11 = linalg.generic {indexing_maps = [#map, #map], iterator_types = ["parallel"]} ins(%9 : tensor<100xf64>) outs(%10 : tensor<100xf64>) {
    ^bb0(%arg1: f64, %arg2: f64):
      %12 = math.sqrt %arg1 : f64
      linalg.yield %12 : f64
    } -> tensor<100xf64>
    return %11 : tensor<100xf64>
  }

  func @main() {
    %0 = arith.constant dense<(0.1, 0.1)> : tensor<100xcomplex<f64>>
    %2 = call @foo(%0) : (tensor<100xcomplex<f64>>) -> tensor<100xf64>
    %unranked = tensor.cast %2 : tensor<100xf64> to tensor<*xf64>
    call @print_memref_f64(%unranked) : (tensor<*xf64>) -> ()
    return
  }
  
  func private @print_memref_f64(%ptr : tensor<*xf64>)
}

