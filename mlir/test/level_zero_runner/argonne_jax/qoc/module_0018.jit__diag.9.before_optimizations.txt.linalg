#map0 = affine_map<(d0) -> (d0)>
#map1 = affine_map<(d0, d1) -> (d0)>
#map2 = affine_map<(d0, d1) -> (d0, d1)>
#map3 = affine_map<(d0, d1) -> (d1)>
module @jit__diag.9 {
  func @foo(%arg0: tensor<1xf64>) -> tensor<2x2xf64> {
    %cst = arith.constant dense<-1> : tensor<2x2xi32>
    %cst_0 = arith.constant dense<0.000000e+00> : tensor<f64>
    %cst_1 = arith.constant dense<0.000000e+00> : tensor<2xf64>
    %0 = linalg.init_tensor [2] : tensor<2xi32>
    %1 = linalg.generic {indexing_maps = [#map0], iterator_types = ["parallel"]} outs(%0 : tensor<2xi32>) {
    ^bb0(%arg1: i32):
      %14 = linalg.index 0 : index
      %15 = arith.index_cast %14 : index to i32
      linalg.yield %15 : i32
    } -> tensor<2xi32>
    %2 = linalg.init_tensor [2, 2] : tensor<2x2xi32>
    %3 = linalg.generic {indexing_maps = [#map1, #map2], iterator_types = ["parallel", "parallel"]} ins(%1 : tensor<2xi32>) outs(%2 : tensor<2x2xi32>) {
    ^bb0(%arg1: i32, %arg2: i32):
      linalg.yield %arg1 : i32
    } -> tensor<2x2xi32>
    %4 = linalg.init_tensor [2, 2] : tensor<2x2xi32>
    %5 = linalg.generic {indexing_maps = [#map2, #map2, #map2], iterator_types = ["parallel", "parallel"]} ins(%3, %cst : tensor<2x2xi32>, tensor<2x2xi32>) outs(%4 : tensor<2x2xi32>) {
    ^bb0(%arg1: i32, %arg2: i32, %arg3: i32):
      %14 = arith.addi %arg1, %arg2 : i32
      linalg.yield %14 : i32
    } -> tensor<2x2xi32>
    %6 = linalg.init_tensor [2] : tensor<2xi32>
    %7 = linalg.generic {indexing_maps = [#map0], iterator_types = ["parallel"]} outs(%6 : tensor<2xi32>) {
    ^bb0(%arg1: i32):
      %14 = linalg.index 0 : index
      %15 = arith.index_cast %14 : index to i32
      linalg.yield %15 : i32
    } -> tensor<2xi32>
    %8 = linalg.init_tensor [2, 2] : tensor<2x2xi32>
    %9 = linalg.generic {indexing_maps = [#map3, #map2], iterator_types = ["parallel", "parallel"]} ins(%7 : tensor<2xi32>) outs(%8 : tensor<2x2xi32>) {
    ^bb0(%arg1: i32, %arg2: i32):
      linalg.yield %arg1 : i32
    } -> tensor<2x2xi32>
    %10 = linalg.init_tensor [2, 2] : tensor<2x2xi1>
    %11 = linalg.generic {indexing_maps = [#map2, #map2, #map2], iterator_types = ["parallel", "parallel"]} ins(%5, %9 : tensor<2x2xi32>, tensor<2x2xi32>) outs(%10 : tensor<2x2xi1>) {
    ^bb0(%arg1: i32, %arg2: i32, %arg3: i1):
      %14 = arith.cmpi eq, %arg1, %arg2 : i32
      linalg.yield %14 : i1
    } -> tensor<2x2xi1>
    %cst_2 = arith.constant 0.000000e+00 : f64
    %12 = tensor.pad %arg0 low[0] high[1] {
    ^bb0(%arg1: index):
      tensor.yield %cst_2 : f64
    } : tensor<1xf64> to tensor<2xf64>
    %13 = call @jit__where.14(%11, %12, %cst_1) : (tensor<2x2xi1>, tensor<2xf64>, tensor<2xf64>) -> tensor<2x2xf64>
    return %13 : tensor<2x2xf64>
  }
  func private @jit__where.14(%arg0: tensor<2x2xi1>, %arg1: tensor<2xf64>, %arg2: tensor<2xf64>) -> tensor<2x2xf64> {
    %0 = linalg.init_tensor [2, 2] : tensor<2x2xf64>
    %1 = linalg.generic {indexing_maps = [#map3, #map2], iterator_types = ["parallel", "parallel"]} ins(%arg1 : tensor<2xf64>) outs(%0 : tensor<2x2xf64>) {
    ^bb0(%arg3: f64, %arg4: f64):
      linalg.yield %arg3 : f64
    } -> tensor<2x2xf64>
    %2 = linalg.init_tensor [2, 2] : tensor<2x2xf64>
    %3 = linalg.generic {indexing_maps = [#map3, #map2], iterator_types = ["parallel", "parallel"]} ins(%arg2 : tensor<2xf64>) outs(%2 : tensor<2x2xf64>) {
    ^bb0(%arg3: f64, %arg4: f64):
      linalg.yield %arg3 : f64
    } -> tensor<2x2xf64>
    %4 = linalg.init_tensor [2, 2] : tensor<2x2xf64>
    %5 = linalg.generic {indexing_maps = [#map2, #map2, #map2, #map2], iterator_types = ["parallel", "parallel"]} ins(%arg0, %1, %3 : tensor<2x2xi1>, tensor<2x2xf64>, tensor<2x2xf64>) outs(%4 : tensor<2x2xf64>) {
    ^bb0(%arg3: i1, %arg4: f64, %arg5: f64, %arg6: f64):
      %6 = arith.select %arg3, %arg4, %arg5 : f64
      linalg.yield %6 : f64
    } -> tensor<2x2xf64>
    return %5 : tensor<2x2xf64>
  }

  func @main() {
    %0 = arith.constant dense<1.000000e+00> : tensor<1xf64>
    %2 = call @foo(%0) : (tensor<1xf64>) -> tensor<2x2xf64>
    %unranked = tensor.cast %2 : tensor<2x2xf64> to tensor<*xf64>
    call @print_memref_f64(%unranked) : (tensor<*xf64>) -> ()
    return
  }

  func private @print_memref_f64(%ptr : tensor<*xf64>)
}

