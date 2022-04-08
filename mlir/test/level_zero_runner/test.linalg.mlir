#map0 = affine_map<() -> ()>
#map1 = affine_map<(d0) -> ()>
#map2 = affine_map<(d0) -> (d0)>
module @jit__linspace.34 {
  func @main(%arg0: tensor<i64>, %arg1: tensor<i64>) -> tensor<100xf64> {
    %cst = arith.constant dense<1.000000e+00> : tensor<99xf64>
    %cst_0 = arith.constant dense<9.900000e+01> : tensor<99xf64>
    %0 = linalg.init_tensor [] : tensor<f64>
    %1 = linalg.generic {indexing_maps = [#map0, #map0], iterator_types = []} ins(%arg0 : tensor<i64>) outs(%0 : tensor<f64>) {
    ^bb0(%arg2: i64, %arg3: f64):
      %27 = arith.sitofp %arg2 : i64 to f64
      linalg.yield %27 : f64
    } -> tensor<f64>
    %2 = linalg.init_tensor [99] : tensor<99xf64>
    %3 = linalg.generic {indexing_maps = [#map1, #map2], iterator_types = ["parallel"]} ins(%1 : tensor<f64>) outs(%2 : tensor<99xf64>) {
    ^bb0(%arg2: f64, %arg3: f64):
      linalg.yield %arg2 : f64
    } -> tensor<99xf64>
    %4 = linalg.init_tensor [99] : tensor<99xf64>
    %5 = linalg.generic {indexing_maps = [#map2], iterator_types = ["parallel"]} outs(%4 : tensor<99xf64>) {
    ^bb0(%arg2: f64):
      %27 = linalg.index 0 : index
      %28 = arith.index_cast %27 : index to i64
      %29 = arith.sitofp %28 : i64 to f64
      linalg.yield %29 : f64
    } -> tensor<99xf64>
    %6 = linalg.init_tensor [99] : tensor<99xf64>
    %7 = linalg.generic {indexing_maps = [#map2, #map2, #map2], iterator_types = ["parallel"]} ins(%5, %cst_0 : tensor<99xf64>, tensor<99xf64>) outs(%6 : tensor<99xf64>) {
    ^bb0(%arg2: f64, %arg3: f64, %arg4: f64):
      %27 = arith.divf %arg2, %arg3 : f64
      linalg.yield %27 : f64
    } -> tensor<99xf64>
    %8 = linalg.init_tensor [99] : tensor<99xf64>
    %9 = linalg.generic {indexing_maps = [#map2, #map2, #map2], iterator_types = ["parallel"]} ins(%cst, %7 : tensor<99xf64>, tensor<99xf64>) outs(%8 : tensor<99xf64>) {
    ^bb0(%arg2: f64, %arg3: f64, %arg4: f64):
      %27 = arith.subf %arg2, %arg3 : f64
      linalg.yield %27 : f64
    } -> tensor<99xf64>
    %10 = linalg.init_tensor [99] : tensor<99xf64>
    %11 = linalg.generic {indexing_maps = [#map2, #map2, #map2], iterator_types = ["parallel"]} ins(%3, %9 : tensor<99xf64>, tensor<99xf64>) outs(%10 : tensor<99xf64>) {
    ^bb0(%arg2: f64, %arg3: f64, %arg4: f64):
      %27 = arith.mulf %arg2, %arg3 : f64
      linalg.yield %27 : f64
    } -> tensor<99xf64>
    %12 = linalg.init_tensor [] : tensor<f64>
    %13 = linalg.generic {indexing_maps = [#map0, #map0], iterator_types = []} ins(%arg1 : tensor<i64>) outs(%12 : tensor<f64>) {
    ^bb0(%arg2: i64, %arg3: f64):
      %27 = arith.sitofp %arg2 : i64 to f64
      linalg.yield %27 : f64
    } -> tensor<f64>
    %14 = linalg.init_tensor [99] : tensor<99xf64>
    %15 = linalg.generic {indexing_maps = [#map1, #map2], iterator_types = ["parallel"]} ins(%13 : tensor<f64>) outs(%14 : tensor<99xf64>) {
    ^bb0(%arg2: f64, %arg3: f64):
      linalg.yield %arg2 : f64
    } -> tensor<99xf64>
    %16 = linalg.init_tensor [99] : tensor<99xf64>
    %17 = linalg.generic {indexing_maps = [#map2, #map2, #map2], iterator_types = ["parallel"]} ins(%15, %7 : tensor<99xf64>, tensor<99xf64>) outs(%16 : tensor<99xf64>) {
    ^bb0(%arg2: f64, %arg3: f64, %arg4: f64):
      %27 = arith.mulf %arg2, %arg3 : f64
      linalg.yield %27 : f64
    } -> tensor<99xf64>
    %18 = linalg.init_tensor [99] : tensor<99xf64>
    %19 = linalg.generic {indexing_maps = [#map2, #map2, #map2], iterator_types = ["parallel"]} ins(%11, %17 : tensor<99xf64>, tensor<99xf64>) outs(%18 : tensor<99xf64>) {
    ^bb0(%arg2: f64, %arg3: f64, %arg4: f64):
      %27 = arith.addf %arg2, %arg3 : f64
      linalg.yield %27 : f64
    } -> tensor<99xf64>
    %20 = tensor.expand_shape %13 [] : tensor<f64> into tensor<1xf64>
    %c0 = arith.constant 0 : index
    %c0_1 = arith.constant 0 : index
    %c99 = arith.constant 99 : index
    %c1 = arith.constant 1 : index
    %c0_2 = arith.constant 0 : index
    %c0_3 = arith.constant 0 : index
    %c99_4 = arith.constant 99 : index
    %c99_5 = arith.constant 99 : index
    %c0_6 = arith.constant 0 : index
    %c1_7 = arith.constant 1 : index
    %c100 = arith.constant 100 : index
    %21 = linalg.init_tensor [100] : tensor<100xf64>
    %cst_8 = arith.constant 0.000000e+00 : f64
    %22 = linalg.fill ins(%cst_8 : f64) outs(%21: tensor<100xf64>) -> tensor<100xf64> 
    %c0_9 = arith.constant 0 : index
    %c0_10 = arith.constant 0 : index
    %c99_11 = arith.constant 99 : index
    %23 = tensor.insert_slice %19 into %22[0] [99] [1] : tensor<99xf64> into tensor<100xf64>
    %24 = arith.addi %c0_9, %c99_11 : index
    %c0_12 = arith.constant 0 : index
    %c1_13 = arith.constant 1 : index
    %25 = tensor.insert_slice %20 into %23[%24] [1] [1] : tensor<1xf64> into tensor<100xf64>
    %26 = arith.addi %24, %c1_13 : index
    return %25 : tensor<100xf64>
  }
}

