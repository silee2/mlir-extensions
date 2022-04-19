#map0 = affine_map<(d0, d1, d2, d3) -> (d0, d2, d3)>
#map1 = affine_map<(d0, d1, d2, d3) -> (d0, d1, d2, d3)>
#map2 = affine_map<(d0, d1, d2, d3) -> (d1, d2, d3)>
module @jit_kron.31 {
  func @foo(%arg0: tensor<2x1xf64>, %arg1: tensor<2x1xf64>) -> tensor<4x1xf64> {
    %0 = tensor.expand_shape %arg0 [[0], [1, 2]] : tensor<2x1xf64> into tensor<2x1x1xf64>
    %1 = linalg.init_tensor [2, 2, 1, 1] : tensor<2x2x1x1xf64>
    %2 = linalg.generic {indexing_maps = [#map0, #map1], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%0 : tensor<2x1x1xf64>) outs(%1 : tensor<2x2x1x1xf64>) {
    ^bb0(%arg2: f64, %arg3: f64):
      linalg.yield %arg2 : f64
    } -> tensor<2x2x1x1xf64>
    %3 = tensor.expand_shape %arg1 [[0], [1, 2]] : tensor<2x1xf64> into tensor<2x1x1xf64>
    %4 = linalg.init_tensor [2, 2, 1, 1] : tensor<2x2x1x1xf64>
    %5 = linalg.generic {indexing_maps = [#map2, #map1], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%3 : tensor<2x1x1xf64>) outs(%4 : tensor<2x2x1x1xf64>) {
    ^bb0(%arg2: f64, %arg3: f64):
      linalg.yield %arg2 : f64
    } -> tensor<2x2x1x1xf64>
    %6 = linalg.init_tensor [2, 2, 1, 1] : tensor<2x2x1x1xf64>
    %7 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel", "parallel", "parallel"]} ins(%2, %5 : tensor<2x2x1x1xf64>, tensor<2x2x1x1xf64>) outs(%6 : tensor<2x2x1x1xf64>) {
    ^bb0(%arg2: f64, %arg3: f64, %arg4: f64):
      %9 = arith.mulf %arg2, %arg3 : f64
      linalg.yield %9 : f64
    } -> tensor<2x2x1x1xf64>
    %8 = tensor.collapse_shape %7 [[0, 1], [2, 3]] : tensor<2x2x1x1xf64> into tensor<4x1xf64>
    return %8 : tensor<4x1xf64>
  }

  func @main() {
    %0 = arith.constant dense<1.000000e+00> : tensor<2x1xf64>
    %1 = arith.constant dense<2.000000e+00> : tensor<2x1xf64>
    %2 = call @foo(%0, %1) : (tensor<2x1xf64>, tensor<2x1xf64>) -> tensor<4x1xf64>
    %unranked = tensor.cast %2 : tensor<4x1xf64> to tensor<*xf64>
    call @print_memref_f64(%unranked) : (tensor<*xf64>) -> ()
    return
  }

  func private @print_memref_f64(%ptr : tensor<*xf64>)
}

