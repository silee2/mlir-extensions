#map = affine_map<() -> ()>
module @jit_log10.0 {
  func @foo(%arg0: tensor<f32>) -> tensor<f32> {
    %cst = arith.constant dense<1.000000e+01> : tensor<f32>
    %0 = linalg.init_tensor [] : tensor<f32>
    %1 = linalg.generic {indexing_maps = [#map, #map], iterator_types = []} ins(%arg0 : tensor<f32>) outs(%0 : tensor<f32>) {
    ^bb0(%arg1: f32, %arg2: f32):
      %6 = math.log %arg1 : f32
      linalg.yield %6 : f32
    } -> tensor<f32>
    %2 = linalg.init_tensor [] : tensor<f32>
    %3 = linalg.generic {indexing_maps = [#map, #map], iterator_types = []} ins(%cst : tensor<f32>) outs(%2 : tensor<f32>) {
    ^bb0(%arg1: f32, %arg2: f32):
      %6 = math.log %arg1 : f32
      linalg.yield %6 : f32
    } -> tensor<f32>
    %4 = linalg.init_tensor [] : tensor<f32>
    %5 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = []} ins(%1, %3 : tensor<f32>, tensor<f32>) outs(%4 : tensor<f32>) {
    ^bb0(%arg1: f32, %arg2: f32, %arg3: f32):
      %6 = arith.divf %arg1, %arg2 : f32
      linalg.yield %6 : f32
    } -> tensor<f32>
    return %5 : tensor<f32>
  }

  func @main() {
    %0 = arith.constant dense<1.000000e+00> : tensor<f32>
    %2 = call @foo(%0) : (tensor<f32>) -> tensor<f32>
    %unranked = tensor.cast %2 : tensor<f32> to tensor<*xf32>
    call @print_memref_f32(%unranked) : (tensor<*xf32>) -> ()
    return
  }

  func private @print_memref_f32(%ptr : tensor<*xf32>)
}

