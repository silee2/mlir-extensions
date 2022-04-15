module @jit_matmul.27 {
  func @foo(%arg0: tensor<2x2xf64>, %arg1: tensor<2x2xf64>) -> tensor<2x2xf64> {
    %cst = arith.constant 0.000000e+00 : f64
    %0 = linalg.init_tensor [2, 2] : tensor<2x2xf64>
    %1 = linalg.fill(%cst, %0) : f64, tensor<2x2xf64> -> tensor<2x2xf64>
    %2 = linalg.matmul ins(%arg0, %arg1 : tensor<2x2xf64>, tensor<2x2xf64>) outs(%1 : tensor<2x2xf64>) -> tensor<2x2xf64>
    return %2 : tensor<2x2xf64>
  }

  func @main() {
    %0 = arith.constant dense<1.000000e+00> : tensor<2x2xf64>
    %1 = arith.constant dense<2.000000e+00> : tensor<2x2xf64>
    %2 = call @foo(%0, %1) : (tensor<2x2xf64>, tensor<2x2xf64>) -> tensor<2x2xf64>
    %unranked = tensor.cast %2 : tensor<2x2xf64> to tensor<*xf64>
    call @print_memref_f64(%unranked) : (tensor<*xf64>) -> ()
    return
  }

  func private @print_memref_f64(%ptr : tensor<*xf64>)
}

