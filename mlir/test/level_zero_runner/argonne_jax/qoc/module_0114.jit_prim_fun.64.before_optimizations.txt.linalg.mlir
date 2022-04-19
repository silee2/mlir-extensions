module @jit_prim_fun.64 {
  func @foo(%arg0: tensor<400xf64>) -> tensor<200xf64> {
    %0 = tensor.extract_slice %arg0[200] [200] [1] : tensor<400xf64> to tensor<200xf64>
    return %0 : tensor<200xf64>
  }

  func @main() {
    %0 = arith.constant dense<1.000000e+00> : tensor<400xf64>
    %2 = call @foo(%0) : (tensor<400xf64>) -> tensor<200xf64>
    %unranked = tensor.cast %2 : tensor<200xf64> to tensor<*xf64>
    call @print_memref_f64(%unranked) : (tensor<*xf64>) -> ()
    return
  }

  func private @print_memref_f64(%ptr : tensor<*xf64>)
}

