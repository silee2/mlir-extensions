#map0 = affine_map<(d0) -> (d0)>
#map1 = affine_map<(d0) -> ()>
module @jit__argmax.79 {
  func.func @foo(%arg0: tensor<100xi32>) -> tensor<i64> {
    %0 = call @argmax.15(%arg0) : (tensor<100xi32>) -> tensor<i64>
    return %0 : tensor<i64>
  }
  func.func private @argmax.15(%arg0: tensor<100xi32>) -> tensor<i64> {
    %cst = arith.constant dense<0> : tensor<i32>
    %cst_0 = arith.constant dense<0> : tensor<i64>
    %0 = linalg.init_tensor [100] : tensor<100xi64>
    %1 = linalg.generic {indexing_maps = [#map0], iterator_types = ["parallel"]} outs(%0 : tensor<100xi64>) {
    ^bb0(%arg1: i64):
      %7 = linalg.index 0 : index
      %8 = arith.index_cast %7 : index to i64
      linalg.yield %8 : i64
    } -> tensor<100xi64>
    %false = arith.constant 0 : i32
    %2 = linalg.init_tensor [] : tensor<i32>
    %3 = linalg.fill ins(%false : i32) outs(%2 : tensor<i32>) -> tensor<i32>
    %c0_i64 = arith.constant 0 : i64
    %4 = linalg.init_tensor [] : tensor<i64>
    %5 = linalg.fill ins(%c0_i64 : i64) outs(%4 : tensor<i64>) -> tensor<i64>
    %6:2 = linalg.generic {indexing_maps = [#map0, #map0, #map1, #map1], iterator_types = ["reduction"]} ins(%arg0, %1 : tensor<100xi32>, tensor<100xi64>) outs(%3, %5 : tensor<i32>, tensor<i64>) {
    ^bb0(%arg1: i32, %arg2: i64, %arg3: i32, %arg4: i64):
      %7 = arith.cmpi sgt, %arg1, %arg3 : i32
      %8 = arith.select %7, %arg1, %arg3 : i32
      %9 = arith.cmpi eq, %arg1, %arg3 : i32
      %10 = arith.cmpi slt, %arg2, %arg4 : i64
      %11 = arith.andi %9, %10 : i1
      %12 = arith.ori %7, %11 : i1
      %13 = arith.select %12, %arg2, %arg4 : i64
      linalg.yield %8, %13 : i32, i64
    } -> (tensor<i32>, tensor<i64>)
    return %6#1 : tensor<i64>
  }

  func.func @main() {
    %0 = arith.constant dense<[0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,31,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0]> : tensor<100xi32>
    %2 = call @foo(%0) : (tensor<100xi32>) -> tensor<i64>
    %unranked = tensor.cast %2 : tensor<i64> to tensor<*xi64>
    call @printMemrefI64(%unranked) : (tensor<*xi64>) -> ()
    return
  }

  func.func private @printMemrefI64(%ptr : tensor<*xi64>)
}

