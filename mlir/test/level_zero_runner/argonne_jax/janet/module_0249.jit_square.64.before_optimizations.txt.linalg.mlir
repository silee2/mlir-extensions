#map = affine_map<(d0, d1) -> (d0, d1)>
module @jit_square.64 {
  func @foo(%arg0: tensor<13x13xf32>) -> tensor<13x13xf32> {
    %0 = linalg.init_tensor [13, 13] : tensor<13x13xf32>
    %1 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%arg0, %arg0 : tensor<13x13xf32>, tensor<13x13xf32>) outs(%0 : tensor<13x13xf32>) {
    ^bb0(%arg1: f32, %arg2: f32, %arg3: f32):
      %2 = arith.mulf %arg1, %arg2 : f32
      linalg.yield %2 : f32
    } -> tensor<13x13xf32>
    return %1 : tensor<13x13xf32>
  }

  func @main() {
    %0 = arith.constant dense<1.000000e+00> : tensor<13x13xf32>
    %2 = call @foo(%0) : (tensor<13x13xf32>) -> tensor<13x13xf32>
    %unranked = tensor.cast %2 : tensor<13x13xf32> to tensor<*xf32>
    call @print_memref_f32(%unranked) : (tensor<*xf32>) -> ()
    return
  }

  func private @print_memref_f32(%ptr : tensor<*xf32>)
}

