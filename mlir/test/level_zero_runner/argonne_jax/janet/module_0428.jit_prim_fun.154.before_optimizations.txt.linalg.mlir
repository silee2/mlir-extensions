module @jit_prim_fun.154 {
  func @foo(%arg0: tensor<1x6xf32>, %arg1: tensor<1x6xf32>, %arg2: tensor<1x6xf32>, %arg3: tensor<1x6xf32>, %arg4: tensor<1x6xf32>, %arg5: tensor<1x6xf32>) -> tensor<6x6xf32> {
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
    %c0_11 = arith.constant 0 : index
    %c1_12 = arith.constant 1 : index
    %c3 = arith.constant 3 : index
    %c0_13 = arith.constant 0 : index
    %c1_14 = arith.constant 1 : index
    %c4 = arith.constant 4 : index
    %c0_15 = arith.constant 0 : index
    %c1_16 = arith.constant 1 : index
    %c5 = arith.constant 5 : index
    %c0_17 = arith.constant 0 : index
    %c1_18 = arith.constant 1 : index
    %c6_19 = arith.constant 6 : index
    %0 = linalg.init_tensor [6, 6] : tensor<6x6xf32>
    %cst = arith.constant 0.000000e+00 : f32
    %1 = linalg.fill(%cst, %0) : f32, tensor<6x6xf32> -> tensor<6x6xf32>
    %c0_20 = arith.constant 0 : index
    %c0_21 = arith.constant 0 : index
    %c1_22 = arith.constant 1 : index
    %2 = tensor.insert_slice %arg0 into %1[0, 0] [1, 6] [1, 1] : tensor<1x6xf32> into tensor<6x6xf32>
    %3 = arith.addi %c0_20, %c1_22 : index
    %c0_23 = arith.constant 0 : index
    %c1_24 = arith.constant 1 : index
    %4 = tensor.insert_slice %arg1 into %2[%3, 0] [1, 6] [1, 1] : tensor<1x6xf32> into tensor<6x6xf32>
    %5 = arith.addi %3, %c1_24 : index
    %c0_25 = arith.constant 0 : index
    %c1_26 = arith.constant 1 : index
    %6 = tensor.insert_slice %arg2 into %4[%5, 0] [1, 6] [1, 1] : tensor<1x6xf32> into tensor<6x6xf32>
    %7 = arith.addi %5, %c1_26 : index
    %c0_27 = arith.constant 0 : index
    %c1_28 = arith.constant 1 : index
    %8 = tensor.insert_slice %arg3 into %6[%7, 0] [1, 6] [1, 1] : tensor<1x6xf32> into tensor<6x6xf32>
    %9 = arith.addi %7, %c1_28 : index
    %c0_29 = arith.constant 0 : index
    %c1_30 = arith.constant 1 : index
    %10 = tensor.insert_slice %arg4 into %8[%9, 0] [1, 6] [1, 1] : tensor<1x6xf32> into tensor<6x6xf32>
    %11 = arith.addi %9, %c1_30 : index
    %c0_31 = arith.constant 0 : index
    %c1_32 = arith.constant 1 : index
    %12 = tensor.insert_slice %arg5 into %10[%11, 0] [1, 6] [1, 1] : tensor<1x6xf32> into tensor<6x6xf32>
    %13 = arith.addi %11, %c1_32 : index
    return %12 : tensor<6x6xf32>
  }

  func @main() {
    %0 = arith.constant dense<1.000000e+00> : tensor<1x6xf32>
    %1 = arith.constant dense<2.000000e+00> : tensor<1x6xf32>
    %2 = arith.constant dense<3.000000e+00> : tensor<1x6xf32>
    %3 = arith.constant dense<1.000000e+00> : tensor<1x6xf32>
    %4 = arith.constant dense<2.000000e+00> : tensor<1x6xf32>
    %5 = arith.constant dense<3.000000e+00> : tensor<1x6xf32>
    %6 = call @foo(%0, %1, %2, %3, %4, %5) : (tensor<1x6xf32>, tensor<1x6xf32>, tensor<1x6xf32>, tensor<1x6xf32>, tensor<1x6xf32>, tensor<1x6xf32>) -> tensor<6x6xf32>
    %unranked = tensor.cast %2 : tensor<6x6xf32> to tensor<*xf32>
    call @print_memref_f32(%unranked) : (tensor<*xf32>) -> ()
    return
  }

  func private @print_memref_f32(%ptr : tensor<*xf32>)
}
}

