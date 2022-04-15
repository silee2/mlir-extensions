#map = affine_map<(d0, d1) -> (d0, d1)>
module @jit__lambda_.143 {
  func @foo(%arg0: tensor<4x6xf32>) -> tensor<4x6xf32> {
    %0 = linalg.init_tensor [4, 6] : tensor<4x6xf32>
    %1 = linalg.generic {indexing_maps = [#map, #map], iterator_types = ["parallel", "parallel"]} ins(%arg0 : tensor<4x6xf32>) outs(%0 : tensor<4x6xf32>) {
    ^bb0(%arg1: f32, %arg2: f32):
      %2 = math.sqrt %arg1 : f32
      linalg.yield %2 : f32
    } -> tensor<4x6xf32>
    return %1 : tensor<4x6xf32>
  }

  func @main() {
    %0 = arith.constant dense<1.000000e+00> : tensor<4x6xf32>
    %2 = call @foo(%0) : (tensor<4x6xf32>) -> tensor<4x6xf32>
    %unranked = tensor.cast %2 : tensor<4x6xf32> to tensor<*xf32>
    call @print_memref_f32(%unranked) : (tensor<*xf32>) -> ()
    return
  }

  func private @print_memref_f32(%ptr : tensor<*xf32>)
}

