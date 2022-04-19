#map = affine_map<() -> ()>
module @jit_prim_fun.37 {
  func @foo(%arg0: tensor<2xf64>, %arg1: tensor<1xi32>) -> tensor<f64> {
    %c0 = arith.constant 0 : index
    %0 = linalg.init_tensor [] : tensor<f64>
    %1 = linalg.generic {indexing_maps = [#map], iterator_types = []} outs(%0 : tensor<f64>) {
    ^bb0(%arg2: f64):
      %2 = tensor.extract %arg1[%c0] : tensor<1xi32>
      %3 = arith.index_cast %2 : i32 to index
      %4 = arith.addi %3, %c0 : index
      %5 = tensor.extract %arg0[%4] : tensor<2xf64>
      linalg.yield %5 : f64
    } -> tensor<f64>
    return %1 : tensor<f64>
  }

  func @main() {
    %0 = arith.constant dense<1.000000e+00> : tensor<2xf64>
    %1 = arith.constant dense<2> : tensor<1xi32>
    %2 = call @foo(%0, %1) : (tensor<2xf64>, tensor<1xi32>) -> tensor<f64>
    %unranked = tensor.cast %2 : tensor<f64> to tensor<*xf64>
    call @print_memref_f64(%unranked) : (tensor<*xf64>) -> ()
    return
  }

  func private @print_memref_f64(%ptr : tensor<*xf64>)
}

