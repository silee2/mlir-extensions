module @jit_prim_fun.61 {
  func @foo(%arg0: tensor<200xf64>, %arg1: tensor<200xf64>) -> tensor<400xf64> {
    %c0 = arith.constant 0 : index
    %c0_0 = arith.constant 0 : index
    %c200 = arith.constant 200 : index
    %c1 = arith.constant 1 : index
    %c0_1 = arith.constant 0 : index
    %c0_2 = arith.constant 0 : index
    %c200_3 = arith.constant 200 : index
    %c200_4 = arith.constant 200 : index
    %c0_5 = arith.constant 0 : index
    %c200_6 = arith.constant 200 : index
    %c400 = arith.constant 400 : index
    %0 = linalg.init_tensor [400] : tensor<400xf64>
    %cst = arith.constant 0.000000e+00 : f64
    %1 = linalg.fill(%cst, %0) : f64, tensor<400xf64> -> tensor<400xf64>
    %c0_7 = arith.constant 0 : index
    %c0_8 = arith.constant 0 : index
    %c200_9 = arith.constant 200 : index
    %2 = tensor.insert_slice %arg0 into %1[0] [200] [1] : tensor<200xf64> into tensor<400xf64>
    %3 = arith.addi %c0_7, %c200_9 : index
    %c0_10 = arith.constant 0 : index
    %c200_11 = arith.constant 200 : index
    %4 = tensor.insert_slice %arg1 into %2[%3] [200] [1] : tensor<200xf64> into tensor<400xf64>
    %5 = arith.addi %3, %c200_11 : index
    return %4 : tensor<400xf64>
  }

  func @main() {
    %0 = arith.constant dense<1.000000e+00> : tensor<200xf64>
    %1 = arith.constant dense<2.000000e+00> : tensor<200xf64>
    %2 = call @foo(%0, %1) : (tensor<200xf64>, tensor<200xf64>) -> tensor<400xf64>
    %unranked = tensor.cast %2 : tensor<400xf64> to tensor<*xf64>
    call @print_memref_f64(%unranked) : (tensor<*xf64>) -> ()
    return
  }

  func private @print_memref_f64(%ptr : tensor<*xf64>)
}

