module @jit_prim_fun.11 {
  func @foo(%arg0: tensor<1x6xf32>, %arg1: tensor<1x6xf32>) -> tensor<2x6xf32> {
    %c0 = arith.constant 0 : index
    %c0_0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c1_1 = arith.constant 1 : index
    %c0_2 = arith.constant 0 : index
    %c1_3 = arith.constant 1 : index
    %c6 = arith.constant 6 : index
    %c1_4 = arith.constant 1 : index
    %c0_5 = arith.constant 0 : index
    %c0_6 = arith.constant 0 : index
    %c1_7 = arith.constant 1 : index
    %c1_8 = arith.constant 1 : index
    %c0_9 = arith.constant 0 : index
    %c1_10 = arith.constant 1 : index
    %c2 = arith.constant 2 : index
    %0 = linalg.init_tensor [2, 6] : tensor<2x6xf32>
    %cst = arith.constant 0.000000e+00 : f32
    %1 = linalg.fill(%cst, %0) : f32, tensor<2x6xf32> -> tensor<2x6xf32>
    %c0_11 = arith.constant 0 : index
    %c0_12 = arith.constant 0 : index
    %c1_13 = arith.constant 1 : index
    %2 = tensor.insert_slice %arg0 into %1[0, 0] [1, 6] [1, 1] : tensor<1x6xf32> into tensor<2x6xf32>
    %3 = arith.addi %c0_11, %c1_13 : index
    %c0_14 = arith.constant 0 : index
    %c1_15 = arith.constant 1 : index
    %4 = tensor.insert_slice %arg1 into %2[%3, 0] [1, 6] [1, 1] : tensor<1x6xf32> into tensor<2x6xf32>
    %5 = arith.addi %3, %c1_15 : index
    return %4 : tensor<2x6xf32>
  }

  func @main() {
    %0 = arith.constant dense<1.000000e+00> : tensor<1x6xf32>
    %1 = arith.constant dense<2.000000e+00> : tensor<1x6xf32>
    %3 = arith.constant dense<3.000000e+00> : tensor<2x6xf32>
    %2 = call @foo(%0, %1, %3) : (tensor<1x6xf32>, tensor<1x6xf32>) -> tensor<2x6xf32>
    %unranked = tensor.cast %2 : tensor<2x6xf32> to tensor<*xf32>
    call @print_memref_f32(%unranked) : (tensor<*xf32>) -> ()
    return
  }

  func private @print_memref_f32(%ptr : tensor<*xf32>)
}

