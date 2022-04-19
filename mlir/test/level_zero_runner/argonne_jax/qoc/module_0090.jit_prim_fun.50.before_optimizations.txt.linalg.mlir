#map = affine_map<(d0, d1) -> (d0, d1)>
module @jit_prim_fun.50 {
  func @foo(%arg0: tensor<1x4x1xf64>, %arg1: tensor<1xi32>) -> tensor<4x1xf64> {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c2 = arith.constant 2 : index
    %0 = linalg.init_tensor [4, 1] : tensor<4x1xf64>
    %1 = linalg.generic {indexing_maps = [#map], iterator_types = ["parallel", "parallel"]} outs(%0 : tensor<4x1xf64>) {
    ^bb0(%arg2: f64):
      %2 = linalg.index 0 : index
      %3 = linalg.index 1 : index
      %4 = tensor.extract %arg1[%c0] : tensor<1xi32>
      %5 = arith.index_cast %4 : i32 to index
      %6 = arith.addi %5, %c0 : index
      %7 = arith.addi %c0, %2 : index
      %8 = arith.addi %c0, %3 : index
      %9 = tensor.extract %arg0[%6, %7, %8] : tensor<1x4x1xf64>
      linalg.yield %9 : f64
    } -> tensor<4x1xf64>
    return %1 : tensor<4x1xf64>
  }

  func @main() {
    %0 = arith.constant dense<1.000000e+00> : tensor<1x4x1xf64>
    %1 = arith.constant dense<2> : tensor<1xi32>
    %2 = call @foo(%0, %1) : (tensor<1x4x1xf64>, tensor<1xi32>) -> tensor<4x1xf64>
    %unranked = tensor.cast %2 : tensor<4x1xf64> to tensor<*xf64>
    call @print_memref_f64(%unranked) : (tensor<*xf64>) -> ()
    return
  }

  func private @print_memref_f64(%ptr : tensor<*xf64>)
}

