module @jit_matmul.27 {
  func @main(%arg0: tensor<2x2xf64>, %arg1: tensor<2x2xf64>) -> tensor<2x2xf64> {
    %cst = arith.constant 0.000000e+00 : f64
    %0 = linalg.init_tensor [2, 2] : tensor<2x2xf64>
    %1 = linalg.fill ins(%cst : f64) outs(%0 : tensor<2x2xf64>) -> tensor<2x2xf64> 
    %2 = linalg.matmul ins(%arg0, %arg1 : tensor<2x2xf64>, tensor<2x2xf64>) outs(%1 : tensor<2x2xf64>) -> tensor<2x2xf64>
    return %2 : tensor<2x2xf64>
  }
}

