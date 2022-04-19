#map = affine_map<() -> ()>
module @jit_prim_fun.1 {
  func @foo(%arg0: tensor<i32>, %arg1: tensor<i32>) -> tensor<i32> {
    %0 = linalg.init_tensor [] : tensor<i32>
    %1 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = []} ins(%arg0, %arg1 : tensor<i32>, tensor<i32>) outs(%0 : tensor<i32>) {
    ^bb0(%arg2: i32, %arg3: i32, %arg4: i32):
      %2 = arith.shrui %arg2, %arg3 : i32
      linalg.yield %2 : i32
    } -> tensor<i32>
    return %1 : tensor<i32>
  }

  func @main() {
    %0 = arith.constant dense<1> : tensor<i32>
    %1 = arith.constant dense<2> : tensor<i32>
    %2 = call @foo(%0, %1) : (tensor<i32>, tensor<i32>) -> tensor<i32>
    %unranked = tensor.cast %2 : tensor<i32> to tensor<*xi32>
    call @print_memref_i32(%unranked) : (tensor<*xi32>) -> ()
    return
  }

  func private @print_memref_i32(%ptr : tensor<*xi32>)
}

