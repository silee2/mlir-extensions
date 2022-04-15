#map0 = affine_map<(d0) -> (d0)>
#map1 = affine_map<(d0, d1) -> (d0)>
#map2 = affine_map<(d0, d1) -> (d0, d1)>
module @jit__unit_scale_traindata.8 {
  func @foo(%arg0: tensor<6xf32>, %arg1: tensor<i32>, %arg2: tensor<i32>) -> tensor<1x6xf32> {
    %cst = arith.constant dense<0.000000e+00> : tensor<f32>
    %cst_0 = arith.constant dense<1.000000e+00> : tensor<f32>
    %0 = call @jit_atleast_2d.6(%arg0) : (tensor<6xf32>) -> tensor<1x6xf32>
    %1 = call @jit_atleast_1d.10(%arg1) : (tensor<i32>) -> tensor<1xi32>
    %2 = call @jit_atleast_1d_0.14(%arg2) : (tensor<i32>) -> tensor<1xi32>
    %3 = linalg.init_tensor [1] : tensor<1xi1>
    %4 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%1, %2 : tensor<1xi32>, tensor<1xi32>) outs(%3 : tensor<1xi1>) {
    ^bb0(%arg3: i32, %arg4: i32, %arg5: i1):
      %17 = arith.cmpi eq, %arg3, %arg4 : i32
      linalg.yield %17 : i1
    } -> tensor<1xi1>
    %5 = call @jit__where_1.28(%4, %cst, %1) : (tensor<1xi1>, tensor<f32>, tensor<1xi32>) -> tensor<1xf32>
    %6 = linalg.init_tensor [1, 6] : tensor<1x6xf32>
    %7 = linalg.generic {indexing_maps = [#map1, #map2], iterator_types = ["parallel", "parallel"]} ins(%5 : tensor<1xf32>) outs(%6 : tensor<1x6xf32>) {
    ^bb0(%arg3: f32, %arg4: f32):
      linalg.yield %arg3 : f32
    } -> tensor<1x6xf32>
    %8 = linalg.init_tensor [1, 6] : tensor<1x6xf32>
    %9 = linalg.generic {indexing_maps = [#map2, #map2, #map2], iterator_types = ["parallel", "parallel"]} ins(%0, %7 : tensor<1x6xf32>, tensor<1x6xf32>) outs(%8 : tensor<1x6xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %17 = arith.subf %arg3, %arg4 : f32
      linalg.yield %17 : f32
    } -> tensor<1x6xf32>
    %10 = linalg.init_tensor [1] : tensor<1xi32>
    %11 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%2, %1 : tensor<1xi32>, tensor<1xi32>) outs(%10 : tensor<1xi32>) {
    ^bb0(%arg3: i32, %arg4: i32, %arg5: i32):
      %17 = arith.subi %arg3, %arg4 : i32
      linalg.yield %17 : i32
    } -> tensor<1xi32>
    %12 = call @jit__where.20(%4, %cst_0, %11) : (tensor<1xi1>, tensor<f32>, tensor<1xi32>) -> tensor<1xf32>
    %13 = linalg.init_tensor [1, 6] : tensor<1x6xf32>
    %14 = linalg.generic {indexing_maps = [#map1, #map2], iterator_types = ["parallel", "parallel"]} ins(%12 : tensor<1xf32>) outs(%13 : tensor<1x6xf32>) {
    ^bb0(%arg3: f32, %arg4: f32):
      linalg.yield %arg3 : f32
    } -> tensor<1x6xf32>
    %15 = linalg.init_tensor [1, 6] : tensor<1x6xf32>
    %16 = linalg.generic {indexing_maps = [#map2, #map2, #map2], iterator_types = ["parallel", "parallel"]} ins(%9, %14 : tensor<1x6xf32>, tensor<1x6xf32>) outs(%15 : tensor<1x6xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %17 = arith.divf %arg3, %arg4 : f32
      linalg.yield %17 : f32
    } -> tensor<1x6xf32>
    return %16 : tensor<1x6xf32>
  }
  func private @jit_atleast_2d.6(%arg0: tensor<6xf32>) -> tensor<1x6xf32> {
    %0 = tensor.expand_shape %arg0 [[0, 1]] : tensor<6xf32> into tensor<1x6xf32>
    return %0 : tensor<1x6xf32>
  }
  func private @jit_atleast_1d.10(%arg0: tensor<i32>) -> tensor<1xi32> {
    %0 = tensor.expand_shape %arg0 [] : tensor<i32> into tensor<1xi32>
    return %0 : tensor<1xi32>
  }
  func private @jit_atleast_1d_0.14(%arg0: tensor<i32>) -> tensor<1xi32> {
    %0 = tensor.expand_shape %arg0 [] : tensor<i32> into tensor<1xi32>
    return %0 : tensor<1xi32>
  }
  func private @jit__where_1.28(%arg0: tensor<1xi1>, %arg1: tensor<f32>, %arg2: tensor<1xi32>) -> tensor<1xf32> {
    %0 = tensor.expand_shape %arg1 [] : tensor<f32> into tensor<1xf32>
    %1 = linalg.init_tensor [1] : tensor<1xf32>
    %2 = linalg.generic {indexing_maps = [#map0, #map0], iterator_types = ["parallel"]} ins(%arg2 : tensor<1xi32>) outs(%1 : tensor<1xf32>) {
    ^bb0(%arg3: i32, %arg4: f32):
      %5 = arith.sitofp %arg3 : i32 to f32
      linalg.yield %5 : f32
    } -> tensor<1xf32>
    %3 = linalg.init_tensor [1] : tensor<1xf32>
    %4 = linalg.generic {indexing_maps = [#map0, #map0, #map0, #map0], iterator_types = ["parallel"]} ins(%arg0, %0, %2 : tensor<1xi1>, tensor<1xf32>, tensor<1xf32>) outs(%3 : tensor<1xf32>) {
    ^bb0(%arg3: i1, %arg4: f32, %arg5: f32, %arg6: f32):
      %5 = arith.select %arg3, %arg4, %arg5 : f32
      linalg.yield %5 : f32
    } -> tensor<1xf32>
    return %4 : tensor<1xf32>
  }
  func private @jit__where.20(%arg0: tensor<1xi1>, %arg1: tensor<f32>, %arg2: tensor<1xi32>) -> tensor<1xf32> {
    %0 = tensor.expand_shape %arg1 [] : tensor<f32> into tensor<1xf32>
    %1 = linalg.init_tensor [1] : tensor<1xf32>
    %2 = linalg.generic {indexing_maps = [#map0, #map0], iterator_types = ["parallel"]} ins(%arg2 : tensor<1xi32>) outs(%1 : tensor<1xf32>) {
    ^bb0(%arg3: i32, %arg4: f32):
      %5 = arith.sitofp %arg3 : i32 to f32
      linalg.yield %5 : f32
    } -> tensor<1xf32>
    %3 = linalg.init_tensor [1] : tensor<1xf32>
    %4 = linalg.generic {indexing_maps = [#map0, #map0, #map0, #map0], iterator_types = ["parallel"]} ins(%arg0, %0, %2 : tensor<1xi1>, tensor<1xf32>, tensor<1xf32>) outs(%3 : tensor<1xf32>) {
    ^bb0(%arg3: i1, %arg4: f32, %arg5: f32, %arg6: f32):
      %5 = arith.select %arg3, %arg4, %arg5 : f32
      linalg.yield %5 : f32
    } -> tensor<1xf32>
    return %4 : tensor<1xf32>
  }

  func @main() {
    %0 = arith.constant dense<1.000000e+00> : tensor<6xf32>
    %1 = arith.constant dense<1> : tensor<i32>
    %3 = arith.constant dense<2> : tensor<i32>
    %2 = call @foo(%0, %1, %3) : (tensor<6xf32>, tensor<i32>, tensor<i32>) -> tensor<1x6xf32>
    %unranked = tensor.cast %2 : tensor<1x6xf32> to tensor<*xf32>
    call @print_memref_f32(%unranked) : (tensor<*xf32>) -> ()
    return
  }

  func private @print_memref_f32(%ptr : tensor<*xf32>)
}

