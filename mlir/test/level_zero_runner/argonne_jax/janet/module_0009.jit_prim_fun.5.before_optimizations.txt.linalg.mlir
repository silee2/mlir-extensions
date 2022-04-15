module @jit_prim_fun.5 {
  func @foo(%arg0: tensor<1xi32>, %arg1: tensor<1xi32>) -> tensor<2xi32> {
    %c0 = arith.constant 0 : index
    %c0_0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c1_1 = arith.constant 1 : index
    %c0_2 = arith.constant 0 : index
    %c0_3 = arith.constant 0 : index
    %c1_4 = arith.constant 1 : index
    %c1_5 = arith.constant 1 : index
    %c0_6 = arith.constant 0 : index
    %c1_7 = arith.constant 1 : index
    %c2 = arith.constant 2 : index
    %0 = linalg.init_tensor [2] : tensor<2xi32>
    %c0_i32 = arith.constant 0 : i32
    %1 = linalg.fill(%c0_i32, %0) : i32, tensor<2xi32> -> tensor<2xi32>
    %c0_8 = arith.constant 0 : index
    %c0_9 = arith.constant 0 : index
    %c1_10 = arith.constant 1 : index
    %2 = tensor.insert_slice %arg0 into %1[0] [1] [1] : tensor<1xi32> into tensor<2xi32>
    %3 = arith.addi %c0_8, %c1_10 : index
    %c0_11 = arith.constant 0 : index
    %c1_12 = arith.constant 1 : index
    %4 = tensor.insert_slice %arg1 into %2[%3] [1] [1] : tensor<1xi32> into tensor<2xi32>
    %5 = arith.addi %3, %c1_12 : index
    return %4 : tensor<2xi32>
  }

  func @main() {
    %0 = arith.constant dense<1> : tensor<i32>
    %1 = arith.constant dense<2> : tensor<i32>
    %2 = call @foo(%0) : (tensor<i32>, tensor<i32>) -> tensor<2xi32>
    %unranked = tensor.cast %2 : tensor<2xi32> to tensor<*xi32>
    call @print_memref_i32(%unranked) : (tensor<*xi32>) -> ()
    return
  }

  func private @print_memref_i32(%ptr : tensor<*xi32>)
}

