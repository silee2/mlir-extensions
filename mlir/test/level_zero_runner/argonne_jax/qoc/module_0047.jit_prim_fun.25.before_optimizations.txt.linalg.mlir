module @jit_prim_fun.25 {
  func @foo(%arg0: tensor<i64>) -> tensor<i64> {
    return %arg0 : tensor<i64>
  }

  func @main() {
    %0 = arith.constant dense<1> : tensor<i64>
    %2 = call @foo(%0) : (tensor<i64>) -> tensor<i64>
    %unranked = tensor.cast %2 : tensor<i64> to tensor<*xi64>
    call @print_memref_i64(%unranked) : (tensor<*xi64>) -> ()
    return
  }

  func private @print_memref_i64(%ptr : tensor<*xi64>)
}

