#map0 = affine_map<(d0, d1) -> ()>
#map1 = affine_map<(d0, d1) -> (d0, d1)>
module @jit_true_divide.142 {
  func @foo(%arg0: tensor<4x6xf32>, %arg1: tensor<f32>) -> tensor<4x6xf32> {
    %0 = linalg.init_tensor [4, 6] : tensor<4x6xf32>
    %1 = linalg.generic {indexing_maps = [#map0, #map1], iterator_types = ["parallel", "parallel"]} ins(%arg1 : tensor<f32>) outs(%0 : tensor<4x6xf32>) {
    ^bb0(%arg2: f32, %arg3: f32):
      linalg.yield %arg2 : f32
    } -> tensor<4x6xf32>
    %2 = linalg.init_tensor [4, 6] : tensor<4x6xf32>
    %3 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%arg0, %1 : tensor<4x6xf32>, tensor<4x6xf32>) outs(%2 : tensor<4x6xf32>) {
    ^bb0(%arg2: f32, %arg3: f32, %arg4: f32):
      %4 = arith.divf %arg2, %arg3 : f32
      linalg.yield %4 : f32
    } -> tensor<4x6xf32>
    return %3 : tensor<4x6xf32>
  }

  func @main() {
    %0 = arith.constant dense<1.000000e+00> : tensor<4x6xf32>
    %1 = arith.constant dense<2.000000e+00> : tensor<f32>
    %2 = call @foo(%0, %1) : (tensor<4x6xf32>, tensor<f32>) -> tensor<4x6xf32>
    %unranked = tensor.cast %2 : tensor<4x6xf32> to tensor<*xf32>
    call @print_memref_f32(%unranked) : (tensor<*xf32>) -> ()
    return
  }

  func private @print_memref_f32(%ptr : tensor<*xf32>)
}

