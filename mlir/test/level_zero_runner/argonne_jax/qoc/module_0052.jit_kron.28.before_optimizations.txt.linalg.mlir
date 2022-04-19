#map0 = affine_map<(d0, d1, d2, d3) -> (d0, d2)>
#map1 = affine_map<(d0, d1, d2, d3) -> (d0, d1, d2, d3)>
#map2 = affine_map<(d0, d1, d2, d3) -> (d1, d3)>
module @jit_kron.28 {
  func @foo(%arg0: tensor<2x2xf64>, %arg1: tensor<2x2xf64>) -> tensor<4x4xf64> {
    %0 = linalg.init_tensor [2, 2, 2, 2] : tensor<2x2x2x2xf64>
    %1 = linalg.generic {indexing_maps = [#map0, #map1], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%arg0 : tensor<2x2xf64>) outs(%0 : tensor<2x2x2x2xf64>) {
    ^bb0(%arg2: f64, %arg3: f64):
      linalg.yield %arg2 : f64
    } -> tensor<2x2x2x2xf64>
    %2 = linalg.init_tensor [2, 2, 2, 2] : tensor<2x2x2x2xf64>
    %3 = linalg.generic {indexing_maps = [#map2, #map1], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%arg1 : tensor<2x2xf64>) outs(%2 : tensor<2x2x2x2xf64>) {
    ^bb0(%arg2: f64, %arg3: f64):
      linalg.yield %arg2 : f64
    } -> tensor<2x2x2x2xf64>
    %4 = linalg.init_tensor [2, 2, 2, 2] : tensor<2x2x2x2xf64>
    %5 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%1, %3 : tensor<2x2x2x2xf64>, tensor<2x2x2x2xf64>) outs(%4 : tensor<2x2x2x2xf64>) {
    ^bb0(%arg2: f64, %arg3: f64, %arg4: f64):
      %7 = arith.mulf %arg2, %arg3 : f64
      linalg.yield %7 : f64
    } -> tensor<2x2x2x2xf64>
    %6 = tensor.collapse_shape %5 [[0, 1], [2, 3]] : tensor<2x2x2x2xf64> into tensor<4x4xf64>
    return %6 : tensor<4x4xf64>
  }

  func @main() {
    %0 = arith.constant dense<1.000000e+00> : tensor<2x2xf64>
    %1 = arith.constant dense<2.000000e+00> : tensor<2x2xf64>
    %2 = call @foo(%0, %1) : (tensor<2x2xf64>, tensor<2x2xf64>) -> tensor<4x4xf64>
    %unranked = tensor.cast %2 : tensor<4x4xf64> to tensor<*xf64>
    call @print_memref_f64(%unranked) : (tensor<*xf64>) -> ()
    return
  }

  func private @print_memref_f64(%ptr : tensor<*xf64>)
}

