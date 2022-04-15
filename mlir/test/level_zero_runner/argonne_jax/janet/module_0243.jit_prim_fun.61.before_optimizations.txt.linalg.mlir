#map = affine_map<() -> ()>
module @jit_prim_fun.61 {
  func @foo(%arg0: tensor<f32>, %arg1: tensor<f32>) -> tensor<i1> {
    %0 = linalg.init_tensor [] : tensor<i1>
    %1 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = []} ins(%arg0, %arg1 : tensor<f32>, tensor<f32>) outs(%0 : tensor<i1>) {
    ^bb0(%arg2: f32, %arg3: f32, %arg4: i1):
      %2 = arith.cmpf olt, %arg2, %arg3 : f32
      linalg.yield %2 : i1
    } -> tensor<i1>
    return %1 : tensor<i1>
  }

  func @main() {
    %0 = arith.constant dense<1.000000e+00> : tensor<f32>
    %1 = arith.constant dense<2.000000e+00> : tensor<f32>
    %2 = call @foo(%0, %1) : (tensor<f32>, tensor<f32>) -> tensor<i1>
    %unranked = tensor.cast %2 : tensor<i1> to tensor<*xi1>
    call @print_memref_i1(%unranked) : (tensor<*xi1>) -> ()
    return
  }

  func private @print_memref_i1(%ptr : tensor<*xi1>)
}

