// map for original linalg.generic
#map0 = affine_map<(d0) -> (d0)>
#map1 = affine_map<(d0) -> ()>
// First linalg.generic: prepend index to input map and output map for both ins and outs
#map2 = affine_map<(d1, d0) -> (d1, d0)>
#map3 = affine_map<(d1, d0) -> (d1)>
// Second linalg.generic: prepend index to input map for both ins and outs. prepend index to output map for ins only
#map4 = affine_map<(d1, d0) -> (d1, d0)>
#map5 = affine_map<(d1, d0) -> ()>
module @jit__argmax.79 {
  func.func @foo(%arg0: tensor<100xi1>) -> tensor<i64> {
    %0 = call @argmax.15(%arg0) : (tensor<100xi1>) -> tensor<i64>
    return %0 : tensor<i64>
  }
  func.func private @argmax.15(%arg0: tensor<100xi1>) -> tensor<i64> {
    %cst = arith.constant dense<false> : tensor<i1>
    %cst_0 = arith.constant dense<0> : tensor<i64>
    %0 = linalg.init_tensor [100] : tensor<100xi64>
    %1 = linalg.generic {indexing_maps = [#map0], iterator_types = ["parallel"]} outs(%0 : tensor<100xi64>) {
    ^bb0(%arg1: i64):
      %7 = linalg.index 0 : index
      %8 = arith.index_cast %7 : index to i64
      linalg.yield %8 : i64
    } -> tensor<100xi64>
    %false = arith.constant false
    %2 = linalg.init_tensor [] : tensor<i1>
    %3 = linalg.fill ins(%false : i1) outs(%2 : tensor<i1>) -> tensor<i1>
    %c0_i64 = arith.constant 0 : i64
    %4 = linalg.init_tensor [] : tensor<i64>
    %5 = linalg.fill ins(%c0_i64 : i64) outs(%4 : tensor<i64>) -> tensor<i64>
    // start of modification

    // original linalg.generic
    //%6:2 = linalg.generic {indexing_maps = [#map0, #map0, #map1, #map1], iterator_types = ["reduction"]} ins(%arg0, %1 : tensor<100xi1>, tensor<100xi64>) outs(%3, %5 : tensor<i1>, tensor<i64>) {
    //^bb0(%arg1: i1, %arg2: i64, %arg3: i1, %arg4: i64):
    //  %7 = arith.cmpi sgt, %arg1, %arg3 : i1
    //  %8 = arith.select %7, %arg1, %arg3 : i1
    //  %9 = arith.cmpi eq, %arg1, %arg3 : i1
    //  %10 = arith.cmpi slt, %arg2, %arg4 : i64
    //  %11 = arith.andi %9, %10 : i1
    //  %12 = arith.ori %7, %11 : i1
    //  %13 = arith.select %12, %arg2, %arg4 : i64
    //  linalg.yield %8, %13 : i1, i64
    //} -> (tensor<i1>, tensor<i64>)
    //return %6#1 : tensor<i64>

    // Preconditions for modification
    // 0. linalg.generic op
    // 1. iterator_type is "1" element of "reduction"
    // 2. two input and input ranks are "1" and shape is static (and multiple of 10)
    // 3. two outputs and output ranks are "0" and shape is static

    // First linalg.generic
    // decide parallel factor (10 for now)
    // split dim into two by parallel factor (10x) : 100 -> 10x10
    %s1 = arith.constant dense<[10, 10]> : tensor<2xi32>
    // reshape input args
    %in1 = tensor.reshape %arg0(%s1) : (tensor<100xi1>, tensor<2xi32>) -> tensor<10x10xi1>
    %in2 = tensor.reshape %1(%s1) : (tensor<100xi64>, tensor<2xi32>) -> tensor<10x10xi64>
    // replicate output args by parallel factor (10x)
    %e1 = tensor.extract %3[] : tensor<i1>
    %e2 = tensor.extract %5[] : tensor<i64>
    %u1 = linalg.init_tensor [10] : tensor<10xi1>
    %u2 = linalg.init_tensor [10] : tensor<10xi64>
    %t1 = linalg.fill ins(%e1 : i1) outs(%u1 : tensor<10xi1>) -> tensor<10xi1>
    %t2 = linalg.fill ins(%e2 : i64) outs(%u2 : tensor<10xi64>) -> tensor<10xi64>
    %r1:2 = linalg.generic {indexing_maps = [#map2, #map2, #map3, #map3], iterator_types = ["parallel", "reduction"]} ins(%in1, %in2 : tensor<10x10xi1>, tensor<10x10xi64>) outs(%t1, %t2 : tensor<10xi1>, tensor<10xi64>) {
    ^bb0(%arg1: i1, %arg2: i64, %arg3: i1, %arg4: i64):
      %7 = arith.cmpi sgt, %arg1, %arg3 : i1
      %8 = arith.select %7, %arg1, %arg3 : i1
      %9 = arith.cmpi eq, %arg1, %arg3 : i1
      %10 = arith.cmpi slt, %arg2, %arg4 : i64
      %11 = arith.andi %9, %10 : i1
      %12 = arith.ori %7, %11 : i1
      %13 = arith.select %12, %arg2, %arg4 : i64
      linalg.yield %8, %13 : i1, i64
    } -> (tensor<10xi1>, tensor<10xi64>)

    // Second linalg.generic
    // dummy outer dim 1
    %s2 = arith.constant dense<[1, 10]> : tensor<2xi32>
    // reshape input args
    %in3 = tensor.reshape %r1#0(%s2) : (tensor<10xi1>, tensor<2xi32>) -> tensor<1x10xi1>
    %in4 = tensor.reshape %r1#1(%s2) : (tensor<10xi64>, tensor<2xi32>) -> tensor<1x10xi64>
    // reuse original output args
    %6:2 = linalg.generic {indexing_maps = [#map4, #map4, #map5, #map5], iterator_types = ["parallel", "reduction"]} ins(%in3, %in4 : tensor<1x10xi1>, tensor<1x10xi64>) outs(%3, %5 : tensor<i1>, tensor<i64>) {
    ^bb0(%arg1: i1, %arg2: i64, %arg3: i1, %arg4: i64):
      %7 = arith.cmpi sgt, %arg1, %arg3 : i1
      %8 = arith.select %7, %arg1, %arg3 : i1
      %9 = arith.cmpi eq, %arg1, %arg3 : i1
      %10 = arith.cmpi slt, %arg2, %arg4 : i64
      %11 = arith.andi %9, %10 : i1
      %12 = arith.ori %7, %11 : i1
      %13 = arith.select %12, %arg2, %arg4 : i64
      linalg.yield %8, %13 : i1, i64
    } -> (tensor<i1>, tensor<i64>)
    return %6#1 : tensor<i64>
  }

  func.func @main() {
    %0 = arith.constant dense<[0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0]> : tensor<100xi1>
    %2 = call @foo(%0) : (tensor<100xi1>) -> tensor<i64>
    %unranked = tensor.cast %2 : tensor<i64> to tensor<*xi64>
    call @printMemrefI64(%unranked) : (tensor<*xi64>) -> ()
    return
  }

  func.func private @printMemrefI64(%ptr : tensor<*xi64>)
}

