module @jit_prim_fun.65 {
  func @foo(%arg0: tensor<f32>) -> tensor<f32> {
    return %arg0 : tensor<f32>
  }

  func @main() {
    %0 = arith.constant dense<1.000000e+00> : tensor<f32>
    %2 = call @foo(%0) : (tensor<f32>) -> tensor<f32>
    %unranked = tensor.cast %2 : tensor<f32> to tensor<*xf32>
    call @print_memref_f32(%unranked) : (tensor<*xf32>) -> ()
    return
  }

  func private @print_memref_f32(%ptr : tensor<*xf32>)
}

