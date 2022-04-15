// -----// IR Dump Before ArithmeticBufferize //----- //
#map0 = affine_map<(d0) -> (d0)>
#map1 = affine_map<(d0) -> ()>
module @jit__argmax.79 {
  func @foo(%arg0: tensor<100xi1>) -> tensor<i64> {
    %0 = call @argmax.15(%arg0) : (tensor<100xi1>) -> tensor<i64>
    return %0 : tensor<i64>
  }
  func private @argmax.15(%arg0: tensor<100xi1>) -> tensor<i64> {
    %cst = arith.constant dense<false> : tensor<i1>
    %cst_0 = arith.constant dense<0> : tensor<i64>
    %0 = linalg.init_tensor [100] : tensor<100xi64>
    %1 = linalg.generic {indexing_maps = [#map0], iterator_types = ["parallel"]} outs(%0 : tensor<100xi64>) {
    ^bb0(%arg1: i64):
      %7 = linalg.index 0 : index
      %8 = arith.index_cast %7 : index to i64
      linalg.yield %8 : i64
    } -> tensor<100xi64>
    %false = arith.constant false
    %2 = linalg.init_tensor [] : tensor<i1>
    %3 = linalg.fill(%false, %2) : i1, tensor<i1> -> tensor<i1> 
    %c0_i64 = arith.constant 0 : i64
    %4 = linalg.init_tensor [] : tensor<i64>
    %5 = linalg.fill(%c0_i64, %4) : i64, tensor<i64> -> tensor<i64> 
    %6:2 = linalg.generic {indexing_maps = [#map0, #map0, #map1, #map1], iterator_types = ["reduction"]} ins(%arg0, %1 : tensor<100xi1>, tensor<100xi64>) outs(%3, %5 : tensor<i1>, tensor<i64>) {
    ^bb0(%arg1: i1, %arg2: i64, %arg3: i1, %arg4: i64):
      %7 = arith.cmpi sgt, %arg1, %arg3 : i1
      %8 = arith.select %7, %arg1, %arg3 : i1
      %9 = arith.cmpi eq, %arg1, %arg3 : i1
      %10 = arith.cmpi slt, %arg2, %arg4 : i64
      %11 = arith.andi %9, %10 : i1
      %12 = arith.ori %7, %11 : i1
      %13 = arith.select %12, %arg2, %arg4 : i64
      linalg.yield %8, %13 : i1, i64
    } -> (tensor<i1>, tensor<i64>)
    return %6#1 : tensor<i64>
  }
  func @main() {
    %cst = arith.constant dense<true> : tensor<100xi1>
    %0 = call @foo(%cst) : (tensor<100xi1>) -> tensor<i64>
    %1 = tensor.cast %0 : tensor<i64> to tensor<*xi64>
    call @print_memref_i64(%1) : (tensor<*xi64>) -> ()
    return
  }
  func private @print_memref_i64(tensor<*xi64>)
}


// -----// IR Dump Before SCFBufferize //----- //
func private @argmax.15(%arg0: tensor<100xi1>) -> tensor<i64> {
  %false = arith.constant false
  %c0_i64 = arith.constant 0 : i64
  %0 = linalg.init_tensor [100] : tensor<100xi64>
  %1 = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>], iterator_types = ["parallel"]} outs(%0 : tensor<100xi64>) {
  ^bb0(%arg1: i64):
    %7 = linalg.index 0 : index
    %8 = arith.index_cast %7 : index to i64
    linalg.yield %8 : i64
  } -> tensor<100xi64>
  %2 = linalg.init_tensor [] : tensor<i1>
  %3 = linalg.fill(%false, %2) : i1, tensor<i1> -> tensor<i1> 
  %4 = linalg.init_tensor [] : tensor<i64>
  %5 = linalg.fill(%c0_i64, %4) : i64, tensor<i64> -> tensor<i64> 
  %6:2 = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> (d0)>, affine_map<(d0) -> ()>, affine_map<(d0) -> ()>], iterator_types = ["reduction"]} ins(%arg0, %1 : tensor<100xi1>, tensor<100xi64>) outs(%3, %5 : tensor<i1>, tensor<i64>) {
  ^bb0(%arg1: i1, %arg2: i64, %arg3: i1, %arg4: i64):
    %7 = arith.cmpi sgt, %arg1, %arg3 : i1
    %8 = arith.select %7, %arg1, %arg3 : i1
    %9 = arith.cmpi eq, %arg1, %arg3 : i1
    %10 = arith.cmpi slt, %arg2, %arg4 : i64
    %11 = arith.andi %9, %10 : i1
    %12 = arith.ori %7, %11 : i1
    %13 = arith.select %12, %arg2, %arg4 : i64
    linalg.yield %8, %13 : i1, i64
  } -> (tensor<i1>, tensor<i64>)
  return %6#1 : tensor<i64>
}

// -----// IR Dump Before SCFBufferize //----- //
func @foo(%arg0: tensor<100xi1>) -> tensor<i64> {
  %0 = call @argmax.15(%arg0) : (tensor<100xi1>) -> tensor<i64>
  return %0 : tensor<i64>
}

// -----// IR Dump Before LinalgBufferize //----- //
func private @argmax.15(%arg0: tensor<100xi1>) -> tensor<i64> {
  %false = arith.constant false
  %c0_i64 = arith.constant 0 : i64
  %0 = linalg.init_tensor [100] : tensor<100xi64>
  %1 = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>], iterator_types = ["parallel"]} outs(%0 : tensor<100xi64>) {
  ^bb0(%arg1: i64):
    %7 = linalg.index 0 : index
    %8 = arith.index_cast %7 : index to i64
    linalg.yield %8 : i64
  } -> tensor<100xi64>
  %2 = linalg.init_tensor [] : tensor<i1>
  %3 = linalg.fill(%false, %2) : i1, tensor<i1> -> tensor<i1> 
  %4 = linalg.init_tensor [] : tensor<i64>
  %5 = linalg.fill(%c0_i64, %4) : i64, tensor<i64> -> tensor<i64> 
  %6:2 = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> (d0)>, affine_map<(d0) -> ()>, affine_map<(d0) -> ()>], iterator_types = ["reduction"]} ins(%arg0, %1 : tensor<100xi1>, tensor<100xi64>) outs(%3, %5 : tensor<i1>, tensor<i64>) {
  ^bb0(%arg1: i1, %arg2: i64, %arg3: i1, %arg4: i64):
    %7 = arith.cmpi sgt, %arg1, %arg3 : i1
    %8 = arith.select %7, %arg1, %arg3 : i1
    %9 = arith.cmpi eq, %arg1, %arg3 : i1
    %10 = arith.cmpi slt, %arg2, %arg4 : i64
    %11 = arith.andi %9, %10 : i1
    %12 = arith.ori %7, %11 : i1
    %13 = arith.select %12, %arg2, %arg4 : i64
    linalg.yield %8, %13 : i1, i64
  } -> (tensor<i1>, tensor<i64>)
  return %6#1 : tensor<i64>
}

// -----// IR Dump Before SCFBufferize //----- //
func @main() {
  %0 = memref.get_global @__constant_100xi1 : memref<100xi1>
  %1 = bufferization.to_tensor %0 : memref<100xi1>
  %2 = call @foo(%1) : (tensor<100xi1>) -> tensor<i64>
  %3 = tensor.cast %2 : tensor<i64> to tensor<*xi64>
  call @print_memref_i64(%3) : (tensor<*xi64>) -> ()
  return
}

// -----// IR Dump Before LinalgBufferize //----- //
func @foo(%arg0: tensor<100xi1>) -> tensor<i64> {
  %0 = call @argmax.15(%arg0) : (tensor<100xi1>) -> tensor<i64>
  return %0 : tensor<i64>
}

// -----// IR Dump Before TensorBufferize //----- //
func private @argmax.15(%arg0: tensor<100xi1>) -> tensor<i64> {
  %0 = bufferization.to_memref %arg0 : memref<100xi1>
  %false = arith.constant false
  %c0_i64 = arith.constant 0 : i64
  %1 = memref.alloc() : memref<100xi64>
  %2 = memref.alloc() : memref<100xi64>
  linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>], iterator_types = ["parallel"]} outs(%2 : memref<100xi64>) {
  ^bb0(%arg1: i64):
    %8 = linalg.index 0 : index
    %9 = arith.index_cast %8 : index to i64
    linalg.yield %9 : i64
  }
  %3 = memref.alloc() : memref<i1>
  linalg.fill(%false, %3) : i1, memref<i1> 
  %4 = memref.alloc() : memref<i64>
  linalg.fill(%c0_i64, %4) : i64, memref<i64> 
  %5 = memref.alloc() : memref<i1>
  memref.copy %3, %5 : memref<i1> to memref<i1>
  %6 = memref.alloc() : memref<i64>
  memref.copy %4, %6 : memref<i64> to memref<i64>
  linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> (d0)>, affine_map<(d0) -> ()>, affine_map<(d0) -> ()>], iterator_types = ["reduction"]} ins(%0, %2 : memref<100xi1>, memref<100xi64>) outs(%5, %6 : memref<i1>, memref<i64>) {
  ^bb0(%arg1: i1, %arg2: i64, %arg3: i1, %arg4: i64):
    %8 = arith.cmpi sgt, %arg1, %arg3 : i1
    %9 = arith.select %8, %arg1, %arg3 : i1
    %10 = arith.cmpi eq, %arg1, %arg3 : i1
    %11 = arith.cmpi slt, %arg2, %arg4 : i64
    %12 = arith.andi %10, %11 : i1
    %13 = arith.ori %8, %12 : i1
    %14 = arith.select %13, %arg2, %arg4 : i64
    linalg.yield %9, %14 : i1, i64
  }
  %7 = bufferization.to_tensor %6 : memref<i64>
  return %7 : tensor<i64>
}

// -----// IR Dump Before LinalgBufferize //----- //
func @main() {
  %0 = memref.get_global @__constant_100xi1 : memref<100xi1>
  %1 = bufferization.to_tensor %0 : memref<100xi1>
  %2 = call @foo(%1) : (tensor<100xi1>) -> tensor<i64>
  %3 = tensor.cast %2 : tensor<i64> to tensor<*xi64>
  call @print_memref_i64(%3) : (tensor<*xi64>) -> ()
  return
}

// -----// IR Dump Before TensorBufferize //----- //
func @foo(%arg0: tensor<100xi1>) -> tensor<i64> {
  %0 = call @argmax.15(%arg0) : (tensor<100xi1>) -> tensor<i64>
  return %0 : tensor<i64>
}

// -----// IR Dump Before SCFBufferize //----- //
func private @print_memref_i64(tensor<*xi64>)

// -----// IR Dump Before TensorBufferize //----- //
func @main() {
  %0 = memref.get_global @__constant_100xi1 : memref<100xi1>
  %1 = bufferization.to_tensor %0 : memref<100xi1>
  %2 = call @foo(%1) : (tensor<100xi1>) -> tensor<i64>
  %3 = tensor.cast %2 : tensor<i64> to tensor<*xi64>
  call @print_memref_i64(%3) : (tensor<*xi64>) -> ()
  return
}

// -----// IR Dump Before LinalgBufferize //----- //
func private @print_memref_i64(tensor<*xi64>)

// -----// IR Dump Before TensorBufferize //----- //
func private @print_memref_i64(tensor<*xi64>)

// -----// IR Dump Before FuncBufferize //----- //
#map0 = affine_map<(d0) -> (d0)>
#map1 = affine_map<(d0) -> ()>
module @jit__argmax.79 {
  memref.global "private" constant @__constant_100xi1 : memref<100xi1> = dense<true>
  func @foo(%arg0: tensor<100xi1>) -> tensor<i64> {
    %0 = call @argmax.15(%arg0) : (tensor<100xi1>) -> tensor<i64>
    return %0 : tensor<i64>
  }
  func private @argmax.15(%arg0: tensor<100xi1>) -> tensor<i64> {
    %false = arith.constant false
    %c0_i64 = arith.constant 0 : i64
    %0 = bufferization.to_memref %arg0 : memref<100xi1>
    %1 = memref.alloc() : memref<100xi64>
    linalg.generic {indexing_maps = [#map0], iterator_types = ["parallel"]} outs(%1 : memref<100xi64>) {
    ^bb0(%arg1: i64):
      %7 = linalg.index 0 : index
      %8 = arith.index_cast %7 : index to i64
      linalg.yield %8 : i64
    }
    %2 = memref.alloc() : memref<i1>
    linalg.fill(%false, %2) : i1, memref<i1> 
    %3 = memref.alloc() : memref<i64>
    linalg.fill(%c0_i64, %3) : i64, memref<i64> 
    %4 = memref.alloc() : memref<i1>
    memref.copy %2, %4 : memref<i1> to memref<i1>
    %5 = memref.alloc() : memref<i64>
    memref.copy %3, %5 : memref<i64> to memref<i64>
    linalg.generic {indexing_maps = [#map0, #map0, #map1, #map1], iterator_types = ["reduction"]} ins(%0, %1 : memref<100xi1>, memref<100xi64>) outs(%4, %5 : memref<i1>, memref<i64>) {
    ^bb0(%arg1: i1, %arg2: i64, %arg3: i1, %arg4: i64):
      %7 = arith.cmpi sgt, %arg1, %arg3 : i1
      %8 = arith.select %7, %arg1, %arg3 : i1
      %9 = arith.cmpi eq, %arg1, %arg3 : i1
      %10 = arith.cmpi slt, %arg2, %arg4 : i64
      %11 = arith.andi %9, %10 : i1
      %12 = arith.ori %7, %11 : i1
      %13 = arith.select %12, %arg2, %arg4 : i64
      linalg.yield %8, %13 : i1, i64
    }
    %6 = bufferization.to_tensor %5 : memref<i64>
    return %6 : tensor<i64>
  }
  func @main() {
    %0 = memref.get_global @__constant_100xi1 : memref<100xi1>
    %1 = bufferization.to_tensor %0 : memref<100xi1>
    %2 = call @foo(%1) : (tensor<100xi1>) -> tensor<i64>
    %3 = bufferization.to_memref %2 : memref<i64>
    %4 = memref.cast %3 : memref<i64> to memref<*xi64>
    %5 = bufferization.to_tensor %4 : memref<*xi64>
    call @print_memref_i64(%5) : (tensor<*xi64>) -> ()
    return
  }
  func private @print_memref_i64(tensor<*xi64>)
}


// -----// IR Dump Before FinalizingBufferize //----- //
func private @argmax.15(%arg0: memref<100xi1>) -> memref<i64> {
  %0 = bufferization.to_tensor %arg0 : memref<100xi1>
  %false = arith.constant false
  %c0_i64 = arith.constant 0 : i64
  %1 = bufferization.to_memref %0 : memref<100xi1>
  %2 = memref.alloc() : memref<100xi64>
  linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>], iterator_types = ["parallel"]} outs(%2 : memref<100xi64>) {
  ^bb0(%arg1: i64):
    %9 = linalg.index 0 : index
    %10 = arith.index_cast %9 : index to i64
    linalg.yield %10 : i64
  }
  %3 = memref.alloc() : memref<i1>
  linalg.fill(%false, %3) : i1, memref<i1> 
  %4 = memref.alloc() : memref<i64>
  linalg.fill(%c0_i64, %4) : i64, memref<i64> 
  %5 = memref.alloc() : memref<i1>
  memref.copy %3, %5 : memref<i1> to memref<i1>
  %6 = memref.alloc() : memref<i64>
  memref.copy %4, %6 : memref<i64> to memref<i64>
  linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> (d0)>, affine_map<(d0) -> ()>, affine_map<(d0) -> ()>], iterator_types = ["reduction"]} ins(%1, %2 : memref<100xi1>, memref<100xi64>) outs(%5, %6 : memref<i1>, memref<i64>) {
  ^bb0(%arg1: i1, %arg2: i64, %arg3: i1, %arg4: i64):
    %9 = arith.cmpi sgt, %arg1, %arg3 : i1
    %10 = arith.select %9, %arg1, %arg3 : i1
    %11 = arith.cmpi eq, %arg1, %arg3 : i1
    %12 = arith.cmpi slt, %arg2, %arg4 : i64
    %13 = arith.andi %11, %12 : i1
    %14 = arith.ori %9, %13 : i1
    %15 = arith.select %14, %arg2, %arg4 : i64
    linalg.yield %10, %15 : i1, i64
  }
  %7 = bufferization.to_tensor %6 : memref<i64>
  %8 = bufferization.to_memref %7 : memref<i64>
  return %8 : memref<i64>
}

// -----// IR Dump Before FinalizingBufferize //----- //
func @foo(%arg0: memref<100xi1>) -> memref<i64> {
  %0 = call @argmax.15(%arg0) : (memref<100xi1>) -> memref<i64>
  return %0 : memref<i64>
}

// -----// IR Dump Before FinalizingBufferize //----- //
func private @print_memref_i64(memref<*xi64>)

// -----// IR Dump Before LinalgLowerToParallelLoops //----- //
func private @argmax.15(%arg0: memref<100xi1>) -> memref<i64> {
  %false = arith.constant false
  %c0_i64 = arith.constant 0 : i64
  %0 = memref.alloc() : memref<100xi64>
  linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>], iterator_types = ["parallel"]} outs(%0 : memref<100xi64>) {
  ^bb0(%arg1: i64):
    %5 = linalg.index 0 : index
    %6 = arith.index_cast %5 : index to i64
    linalg.yield %6 : i64
  }
  %1 = memref.alloc() : memref<i1>
  linalg.fill(%false, %1) : i1, memref<i1> 
  %2 = memref.alloc() : memref<i64>
  linalg.fill(%c0_i64, %2) : i64, memref<i64> 
  %3 = memref.alloc() : memref<i1>
  memref.copy %1, %3 : memref<i1> to memref<i1>
  %4 = memref.alloc() : memref<i64>
  memref.copy %2, %4 : memref<i64> to memref<i64>
  linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> (d0)>, affine_map<(d0) -> ()>, affine_map<(d0) -> ()>], iterator_types = ["reduction"]} ins(%arg0, %0 : memref<100xi1>, memref<100xi64>) outs(%3, %4 : memref<i1>, memref<i64>) {
  ^bb0(%arg1: i1, %arg2: i64, %arg3: i1, %arg4: i64):
    %5 = arith.cmpi sgt, %arg1, %arg3 : i1
    %6 = arith.select %5, %arg1, %arg3 : i1
    %7 = arith.cmpi eq, %arg1, %arg3 : i1
    %8 = arith.cmpi slt, %arg2, %arg4 : i64
    %9 = arith.andi %7, %8 : i1
    %10 = arith.ori %5, %9 : i1
    %11 = arith.select %10, %arg2, %arg4 : i64
    linalg.yield %6, %11 : i1, i64
  }
  return %4 : memref<i64>
}

// -----// IR Dump Before FinalizingBufferize //----- //
func @main() {
  %0 = memref.get_global @__constant_100xi1 : memref<100xi1>
  %1 = bufferization.to_tensor %0 : memref<100xi1>
  %2 = bufferization.to_memref %1 : memref<100xi1>
  %3 = call @foo(%2) : (memref<100xi1>) -> memref<i64>
  %4 = bufferization.to_tensor %3 : memref<i64>
  %5 = bufferization.to_memref %4 : memref<i64>
  %6 = memref.cast %5 : memref<i64> to memref<*xi64>
  %7 = bufferization.to_tensor %6 : memref<*xi64>
  %8 = bufferization.to_memref %7 : memref<*xi64>
  call @print_memref_i64(%8) : (memref<*xi64>) -> ()
  return
}

// -----// IR Dump Before LinalgLowerToParallelLoops //----- //
func private @print_memref_i64(memref<*xi64>)

// -----// IR Dump Before LinalgLowerToParallelLoops //----- //
func @foo(%arg0: memref<100xi1>) -> memref<i64> {
  %0 = call @argmax.15(%arg0) : (memref<100xi1>) -> memref<i64>
  return %0 : memref<i64>
}

// -----// IR Dump Before ParallelLoopGPUMappingPass //----- //
func private @argmax.15(%arg0: memref<100xi1>) -> memref<i64> {
  %false = arith.constant false
  %c0_i64 = arith.constant 0 : i64
  %c100 = arith.constant 100 : index
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %0 = memref.alloc() : memref<100xi64>
  scf.parallel (%arg1) = (%c0) to (%c100) step (%c1) {
    %5 = arith.index_cast %arg1 : index to i64
    memref.store %5, %0[%arg1] : memref<100xi64>
    scf.yield
  }
  %1 = memref.alloc() : memref<i1>
  memref.store %false, %1[] : memref<i1>
  %2 = memref.alloc() : memref<i64>
  memref.store %c0_i64, %2[] : memref<i64>
  %3 = memref.alloc() : memref<i1>
  memref.copy %1, %3 : memref<i1> to memref<i1>
  %4 = memref.alloc() : memref<i64>
  memref.copy %2, %4 : memref<i64> to memref<i64>
  scf.for %arg1 = %c0 to %c100 step %c1 {
    %5 = memref.load %arg0[%arg1] : memref<100xi1>
    %6 = memref.load %0[%arg1] : memref<100xi64>
    %7 = memref.load %3[] : memref<i1>
    %8 = memref.load %4[] : memref<i64>
    %9 = arith.cmpi sgt, %5, %7 : i1
    %10 = arith.select %9, %5, %7 : i1
    %11 = arith.cmpi eq, %5, %7 : i1
    %12 = arith.cmpi slt, %6, %8 : i64
    %13 = arith.andi %11, %12 : i1
    %14 = arith.ori %9, %13 : i1
    %15 = arith.select %14, %6, %8 : i64
    memref.store %10, %3[] : memref<i1>
    memref.store %15, %4[] : memref<i64>
  }
  return %4 : memref<i64>
}

// -----// IR Dump Before LinalgLowerToParallelLoops //----- //
func @main() {
  %0 = memref.get_global @__constant_100xi1 : memref<100xi1>
  %1 = call @foo(%0) : (memref<100xi1>) -> memref<i64>
  %2 = memref.cast %1 : memref<i64> to memref<*xi64>
  call @print_memref_i64(%2) : (memref<*xi64>) -> ()
  return
}

// -----// IR Dump Before ParallelLoopGPUMappingPass //----- //
func private @print_memref_i64(memref<*xi64>)

// -----// IR Dump Before ConvertParallelLoopToGpu //----- //
func private @print_memref_i64(memref<*xi64>)

// -----// IR Dump Before InsertGPUAllocs //----- //
func private @print_memref_i64(memref<*xi64>)

// -----// IR Dump Before ConvertParallelLoopToGpu //----- //
func private @argmax.15(%arg0: memref<100xi1>) -> memref<i64> {
  %false = arith.constant false
  %c0_i64 = arith.constant 0 : i64
  %c100 = arith.constant 100 : index
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %0 = memref.alloc() : memref<100xi64>
  scf.parallel (%arg1) = (%c0) to (%c100) step (%c1) {
    %5 = arith.index_cast %arg1 : index to i64
    memref.store %5, %0[%arg1] : memref<100xi64>
    scf.yield
  } {mapping = [{bound = affine_map<(d0) -> (d0)>, map = affine_map<(d0) -> (d0)>, processor = 0 : i64}]}
  %1 = memref.alloc() : memref<i1>
  memref.store %false, %1[] : memref<i1>
  %2 = memref.alloc() : memref<i64>
  memref.store %c0_i64, %2[] : memref<i64>
  %3 = memref.alloc() : memref<i1>
  memref.copy %1, %3 : memref<i1> to memref<i1>
  %4 = memref.alloc() : memref<i64>
  memref.copy %2, %4 : memref<i64> to memref<i64>
  scf.for %arg1 = %c0 to %c100 step %c1 {
    %5 = memref.load %arg0[%arg1] : memref<100xi1>
    %6 = memref.load %0[%arg1] : memref<100xi64>
    %7 = memref.load %3[] : memref<i1>
    %8 = memref.load %4[] : memref<i64>
    %9 = arith.cmpi sgt, %5, %7 : i1
    %10 = arith.select %9, %5, %7 : i1
    %11 = arith.cmpi eq, %5, %7 : i1
    %12 = arith.cmpi slt, %6, %8 : i64
    %13 = arith.andi %11, %12 : i1
    %14 = arith.ori %9, %13 : i1
    %15 = arith.select %14, %6, %8 : i64
    memref.store %10, %3[] : memref<i1>
    memref.store %15, %4[] : memref<i64>
  }
  return %4 : memref<i64>
}

// -----// IR Dump Before ParallelLoopGPUMappingPass //----- //
func @main() {
  %0 = memref.get_global @__constant_100xi1 : memref<100xi1>
  %1 = call @foo(%0) : (memref<100xi1>) -> memref<i64>
  %2 = memref.cast %1 : memref<i64> to memref<*xi64>
  call @print_memref_i64(%2) : (memref<*xi64>) -> ()
  return
}

// -----// IR Dump Before ParallelLoopGPUMappingPass //----- //
func @foo(%arg0: memref<100xi1>) -> memref<i64> {
  %0 = call @argmax.15(%arg0) : (memref<100xi1>) -> memref<i64>
  return %0 : memref<i64>
}

// -----// IR Dump Before ConvertParallelLoopToGpu //----- //
func @foo(%arg0: memref<100xi1>) -> memref<i64> {
  %0 = call @argmax.15(%arg0) : (memref<100xi1>) -> memref<i64>
  return %0 : memref<i64>
}

// -----// IR Dump Before InsertGPUAllocs //----- //
func private @argmax.15(%arg0: memref<100xi1>) -> memref<i64> {
  %false = arith.constant false
  %c0_i64 = arith.constant 0 : i64
  %c100 = arith.constant 100 : index
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %0 = memref.alloc() : memref<100xi64>
  %c1_0 = arith.constant 1 : index
  %1 = affine.apply affine_map<(d0)[s0, s1] -> ((d0 - s0) ceildiv s1)>(%c100)[%c0, %c1]
  gpu.launch blocks(%arg1, %arg2, %arg3) in (%arg7 = %1, %arg8 = %c1_0, %arg9 = %c1_0) threads(%arg4, %arg5, %arg6) in (%arg10 = %c1_0, %arg11 = %c1_0, %arg12 = %c1_0) {
    %6 = affine.apply affine_map<(d0)[s0, s1] -> (d0 * s0 + s1)>(%arg1)[%c1, %c0]
    %7 = arith.index_cast %6 : index to i64
    memref.store %7, %0[%6] : memref<100xi64>
    gpu.terminator
  } {SCFToGPU_visited}
  %2 = memref.alloc() : memref<i1>
  memref.store %false, %2[] : memref<i1>
  %3 = memref.alloc() : memref<i64>
  memref.store %c0_i64, %3[] : memref<i64>
  %4 = memref.alloc() : memref<i1>
  memref.copy %2, %4 : memref<i1> to memref<i1>
  %5 = memref.alloc() : memref<i64>
  memref.copy %3, %5 : memref<i64> to memref<i64>
  scf.for %arg1 = %c0 to %c100 step %c1 {
    %6 = memref.load %arg0[%arg1] : memref<100xi1>
    %7 = memref.load %0[%arg1] : memref<100xi64>
    %8 = memref.load %4[] : memref<i1>
    %9 = memref.load %5[] : memref<i64>
    %10 = arith.cmpi sgt, %6, %8 : i1
    %11 = arith.select %10, %6, %8 : i1
    %12 = arith.cmpi eq, %6, %8 : i1
    %13 = arith.cmpi slt, %7, %9 : i64
    %14 = arith.andi %12, %13 : i1
    %15 = arith.ori %10, %14 : i1
    %16 = arith.select %15, %7, %9 : i64
    memref.store %11, %4[] : memref<i1>
    memref.store %16, %5[] : memref<i64>
  }
  return %5 : memref<i64>
}

// -----// IR Dump Before ConvertParallelLoopToGpu //----- //
func @main() {
  %0 = memref.get_global @__constant_100xi1 : memref<100xi1>
  %1 = call @foo(%0) : (memref<100xi1>) -> memref<i64>
  %2 = memref.cast %1 : memref<i64> to memref<*xi64>
  call @print_memref_i64(%2) : (memref<*xi64>) -> ()
  return
}

// -----// IR Dump Before InsertGPUAllocs //----- //
func @foo(%arg0: memref<100xi1>) -> memref<i64> {
  %0 = call @argmax.15(%arg0) : (memref<100xi1>) -> memref<i64>
  return %0 : memref<i64>
}

// -----// IR Dump Before InsertGPUAllocs //----- //
func @main() {
  %0 = memref.get_global @__constant_100xi1 : memref<100xi1>
  %1 = call @foo(%0) : (memref<100xi1>) -> memref<i64>
  %2 = memref.cast %1 : memref<i64> to memref<*xi64>
  call @print_memref_i64(%2) : (memref<*xi64>) -> ()
  return
}

// -----// IR Dump Before Canonicalizer //----- //
#map0 = affine_map<(d0)[s0, s1] -> ((d0 - s0) ceildiv s1)>
#map1 = affine_map<(d0)[s0, s1] -> (d0 * s0 + s1)>
module @jit__argmax.79 {
  memref.global "private" constant @__constant_100xi1 : memref<100xi1> = dense<true>
  func @foo(%arg0: memref<100xi1>) -> memref<i64> {
    %0 = call @argmax.15(%arg0) : (memref<100xi1>) -> memref<i64>
    return %0 : memref<i64>
  }
  func private @argmax.15(%arg0: memref<100xi1>) -> memref<i64> {
    %false = arith.constant false
    %c0_i64 = arith.constant 0 : i64
    %c100 = arith.constant 100 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %memref = gpu.alloc  () {gpu.alloc_shared} : memref<100xi64>
    %c1_0 = arith.constant 1 : index
    %0 = affine.apply #map0(%c100)[%c0, %c1]
    gpu.launch blocks(%arg1, %arg2, %arg3) in (%arg7 = %0, %arg8 = %c1_0, %arg9 = %c1_0) threads(%arg4, %arg5, %arg6) in (%arg10 = %c1_0, %arg11 = %c1_0, %arg12 = %c1_0) {
      %5 = affine.apply #map1(%arg1)[%c1, %c0]
      %6 = arith.index_cast %5 : index to i64
      memref.store %6, %memref[%5] : memref<100xi64>
      gpu.terminator
    } {SCFToGPU_visited}
    %1 = memref.alloc() : memref<i1>
    memref.store %false, %1[] : memref<i1>
    %2 = memref.alloc() : memref<i64>
    memref.store %c0_i64, %2[] : memref<i64>
    %3 = memref.alloc() : memref<i1>
    memref.copy %1, %3 : memref<i1> to memref<i1>
    %4 = memref.alloc() : memref<i64>
    memref.copy %2, %4 : memref<i64> to memref<i64>
    scf.for %arg1 = %c0 to %c100 step %c1 {
      %5 = memref.load %arg0[%arg1] : memref<100xi1>
      %6 = memref.load %memref[%arg1] : memref<100xi64>
      %7 = memref.load %3[] : memref<i1>
      %8 = memref.load %4[] : memref<i64>
      %9 = arith.cmpi sgt, %5, %7 : i1
      %10 = arith.select %9, %5, %7 : i1
      %11 = arith.cmpi eq, %5, %7 : i1
      %12 = arith.cmpi slt, %6, %8 : i64
      %13 = arith.andi %11, %12 : i1
      %14 = arith.ori %9, %13 : i1
      %15 = arith.select %14, %6, %8 : i64
      memref.store %10, %3[] : memref<i1>
      memref.store %15, %4[] : memref<i64>
    }
    return %4 : memref<i64>
  }
  func @main() {
    %0 = memref.get_global @__constant_100xi1 : memref<100xi1>
    %1 = call @foo(%0) : (memref<100xi1>) -> memref<i64>
    %2 = memref.cast %1 : memref<i64> to memref<*xi64>
    call @print_memref_i64(%2) : (memref<*xi64>) -> ()
    return
  }
  func private @print_memref_i64(memref<*xi64>)
}


// -----// IR Dump Before UnstrideMemrefsPass //----- //
func @foo(%arg0: memref<100xi1>) -> memref<i64> {
  %0 = call @argmax.15(%arg0) : (memref<100xi1>) -> memref<i64>
  return %0 : memref<i64>
}

// -----// IR Dump Before UnstrideMemrefsPass //----- //
func private @argmax.15(%arg0: memref<100xi1>) -> memref<i64> {
  %c100 = arith.constant 100 : index
  %c1 = arith.constant 1 : index
  %c0 = arith.constant 0 : index
  %c0_i64 = arith.constant 0 : i64
  %false = arith.constant false
  %memref = gpu.alloc  () {gpu.alloc_shared} : memref<100xi64>
  gpu.launch blocks(%arg1, %arg2, %arg3) in (%arg7 = %c100, %arg8 = %c1, %arg9 = %c1) threads(%arg4, %arg5, %arg6) in (%arg10 = %c1, %arg11 = %c1, %arg12 = %c1) {
    %4 = arith.index_cast %arg1 : index to i64
    memref.store %4, %memref[%arg1] : memref<100xi64>
    gpu.terminator
  } {SCFToGPU_visited}
  %0 = memref.alloc() : memref<i1>
  memref.store %false, %0[] : memref<i1>
  %1 = memref.alloc() : memref<i64>
  memref.store %c0_i64, %1[] : memref<i64>
  %2 = memref.alloc() : memref<i1>
  memref.copy %0, %2 : memref<i1> to memref<i1>
  %3 = memref.alloc() : memref<i64>
  memref.copy %1, %3 : memref<i64> to memref<i64>
  scf.for %arg1 = %c0 to %c100 step %c1 {
    %4 = memref.load %arg0[%arg1] : memref<100xi1>
    %5 = memref.load %memref[%arg1] : memref<100xi64>
    %6 = memref.load %2[] : memref<i1>
    %7 = memref.load %3[] : memref<i64>
    %8 = arith.cmpi sgt, %4, %6 : i1
    %9 = arith.cmpi sle, %4, %6 : i1
    %10 = arith.andi %8, %4 : i1
    %11 = arith.andi %9, %6 : i1
    %12 = arith.ori %10, %11 : i1
    %13 = arith.cmpi eq, %4, %6 : i1
    %14 = arith.cmpi slt, %5, %7 : i64
    %15 = arith.andi %13, %14 : i1
    %16 = arith.ori %8, %15 : i1
    %17 = arith.select %16, %5, %7 : i64
    memref.store %12, %2[] : memref<i1>
    memref.store %17, %3[] : memref<i64>
  }
  return %3 : memref<i64>
}

// -----// IR Dump Before UnstrideMemrefsPass //----- //
func @main() {
  %0 = memref.get_global @__constant_100xi1 : memref<100xi1>
  %1 = call @foo(%0) : (memref<100xi1>) -> memref<i64>
  %2 = memref.cast %1 : memref<i64> to memref<*xi64>
  call @print_memref_i64(%2) : (memref<*xi64>) -> ()
  return
}

// -----// IR Dump Before ConvertAffineToStandard //----- //
func @foo(%arg0: memref<100xi1>) -> memref<i64> {
  %0 = call @argmax.15(%arg0) : (memref<100xi1>) -> memref<i64>
  return %0 : memref<i64>
}

// -----// IR Dump Before ConvertAffineToStandard //----- //
func private @argmax.15(%arg0: memref<100xi1>) -> memref<i64> {
  %c100 = arith.constant 100 : index
  %c1 = arith.constant 1 : index
  %c0 = arith.constant 0 : index
  %c0_i64 = arith.constant 0 : i64
  %false = arith.constant false
  %memref = gpu.alloc  () {gpu.alloc_shared} : memref<100xi64>
  gpu.launch blocks(%arg1, %arg2, %arg3) in (%arg7 = %c100, %arg8 = %c1, %arg9 = %c1) threads(%arg4, %arg5, %arg6) in (%arg10 = %c1, %arg11 = %c1, %arg12 = %c1) {
    %4 = arith.index_cast %arg1 : index to i64
    memref.store %4, %memref[%arg1] : memref<100xi64>
    gpu.terminator
  } {SCFToGPU_visited}
  %0 = memref.alloc() : memref<i1>
  memref.store %false, %0[] : memref<i1>
  %1 = memref.alloc() : memref<i64>
  memref.store %c0_i64, %1[] : memref<i64>
  %2 = memref.alloc() : memref<i1>
  memref.copy %0, %2 : memref<i1> to memref<i1>
  %3 = memref.alloc() : memref<i64>
  memref.copy %1, %3 : memref<i64> to memref<i64>
  scf.for %arg1 = %c0 to %c100 step %c1 {
    %4 = memref.load %arg0[%arg1] : memref<100xi1>
    %5 = memref.load %memref[%arg1] : memref<100xi64>
    %6 = memref.load %2[] : memref<i1>
    %7 = memref.load %3[] : memref<i64>
    %8 = arith.cmpi sgt, %4, %6 : i1
    %9 = arith.cmpi sle, %4, %6 : i1
    %10 = arith.andi %8, %4 : i1
    %11 = arith.andi %9, %6 : i1
    %12 = arith.ori %10, %11 : i1
    %13 = arith.cmpi eq, %4, %6 : i1
    %14 = arith.cmpi slt, %5, %7 : i64
    %15 = arith.andi %13, %14 : i1
    %16 = arith.ori %8, %15 : i1
    %17 = arith.select %16, %5, %7 : i64
    memref.store %12, %2[] : memref<i1>
    memref.store %17, %3[] : memref<i64>
  }
  return %3 : memref<i64>
}

// -----// IR Dump Before ConvertAffineToStandard //----- //
func @main() {
  %0 = memref.get_global @__constant_100xi1 : memref<100xi1>
  %1 = call @foo(%0) : (memref<100xi1>) -> memref<i64>
  %2 = memref.cast %1 : memref<i64> to memref<*xi64>
  call @print_memref_i64(%2) : (memref<*xi64>) -> ()
  return
}

// -----// IR Dump Before UnstrideMemrefsPass //----- //
func private @print_memref_i64(memref<*xi64>)

// -----// IR Dump Before ConvertAffineToStandard //----- //
func private @print_memref_i64(memref<*xi64>)

// -----// IR Dump Before GpuKernelOutlining //----- //
module @jit__argmax.79 {
  memref.global "private" constant @__constant_100xi1 : memref<100xi1> = dense<true>
  func @foo(%arg0: memref<100xi1>) -> memref<i64> {
    %0 = call @argmax.15(%arg0) : (memref<100xi1>) -> memref<i64>
    return %0 : memref<i64>
  }
  func private @argmax.15(%arg0: memref<100xi1>) -> memref<i64> {
    %c100 = arith.constant 100 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %c0_i64 = arith.constant 0 : i64
    %false = arith.constant false
    %memref = gpu.alloc  () {gpu.alloc_shared} : memref<100xi64>
    gpu.launch blocks(%arg1, %arg2, %arg3) in (%arg7 = %c100, %arg8 = %c1, %arg9 = %c1) threads(%arg4, %arg5, %arg6) in (%arg10 = %c1, %arg11 = %c1, %arg12 = %c1) {
      %4 = arith.index_cast %arg1 : index to i64
      memref.store %4, %memref[%arg1] : memref<100xi64>
      gpu.terminator
    } {SCFToGPU_visited}
    %0 = memref.alloc() : memref<i1>
    memref.store %false, %0[] : memref<i1>
    %1 = memref.alloc() : memref<i64>
    memref.store %c0_i64, %1[] : memref<i64>
    %2 = memref.alloc() : memref<i1>
    memref.copy %0, %2 : memref<i1> to memref<i1>
    %3 = memref.alloc() : memref<i64>
    memref.copy %1, %3 : memref<i64> to memref<i64>
    scf.for %arg1 = %c0 to %c100 step %c1 {
      %4 = memref.load %arg0[%arg1] : memref<100xi1>
      %5 = memref.load %memref[%arg1] : memref<100xi64>
      %6 = memref.load %2[] : memref<i1>
      %7 = memref.load %3[] : memref<i64>
      %8 = arith.cmpi sgt, %4, %6 : i1
      %9 = arith.cmpi sle, %4, %6 : i1
      %10 = arith.andi %8, %4 : i1
      %11 = arith.andi %9, %6 : i1
      %12 = arith.ori %10, %11 : i1
      %13 = arith.cmpi eq, %4, %6 : i1
      %14 = arith.cmpi slt, %5, %7 : i64
      %15 = arith.andi %13, %14 : i1
      %16 = arith.ori %8, %15 : i1
      %17 = arith.select %16, %5, %7 : i64
      memref.store %12, %2[] : memref<i1>
      memref.store %17, %3[] : memref<i64>
    }
    return %3 : memref<i64>
  }
  func @main() {
    %0 = memref.get_global @__constant_100xi1 : memref<100xi1>
    %1 = call @foo(%0) : (memref<100xi1>) -> memref<i64>
    %2 = memref.cast %1 : memref<i64> to memref<*xi64>
    call @print_memref_i64(%2) : (memref<*xi64>) -> ()
    return
  }
  func private @print_memref_i64(memref<*xi64>)
}


// -----// IR Dump Before FoldSubViewOps //----- //
module @jit__argmax.79 attributes {gpu.container_module} {
  memref.global "private" constant @__constant_100xi1 : memref<100xi1> = dense<true>
  func @foo(%arg0: memref<100xi1>) -> memref<i64> {
    %0 = call @argmax.15(%arg0) : (memref<100xi1>) -> memref<i64>
    return %0 : memref<i64>
  }
  func private @argmax.15(%arg0: memref<100xi1>) -> memref<i64> {
    %c100 = arith.constant 100 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %c0_i64 = arith.constant 0 : i64
    %false = arith.constant false
    %memref = gpu.alloc  () {gpu.alloc_shared} : memref<100xi64>
    gpu.launch_func  @argmax.15_kernel::@argmax.15_kernel blocks in (%c100, %c1, %c1) threads in (%c1, %c1, %c1) args(%memref : memref<100xi64>)
    %0 = memref.alloc() : memref<i1>
    memref.store %false, %0[] : memref<i1>
    %1 = memref.alloc() : memref<i64>
    memref.store %c0_i64, %1[] : memref<i64>
    %2 = memref.alloc() : memref<i1>
    memref.copy %0, %2 : memref<i1> to memref<i1>
    %3 = memref.alloc() : memref<i64>
    memref.copy %1, %3 : memref<i64> to memref<i64>
    scf.for %arg1 = %c0 to %c100 step %c1 {
      %4 = memref.load %arg0[%arg1] : memref<100xi1>
      %5 = memref.load %memref[%arg1] : memref<100xi64>
      %6 = memref.load %2[] : memref<i1>
      %7 = memref.load %3[] : memref<i64>
      %8 = arith.cmpi sgt, %4, %6 : i1
      %9 = arith.cmpi sle, %4, %6 : i1
      %10 = arith.andi %8, %4 : i1
      %11 = arith.andi %9, %6 : i1
      %12 = arith.ori %10, %11 : i1
      %13 = arith.cmpi eq, %4, %6 : i1
      %14 = arith.cmpi slt, %5, %7 : i64
      %15 = arith.andi %13, %14 : i1
      %16 = arith.ori %8, %15 : i1
      %17 = arith.select %16, %5, %7 : i64
      memref.store %12, %2[] : memref<i1>
      memref.store %17, %3[] : memref<i64>
    }
    return %3 : memref<i64>
  }
  gpu.module @argmax.15_kernel {
    gpu.func @argmax.15_kernel(%arg0: memref<100xi64>) kernel {
      %0 = gpu.block_id  x
      %1 = gpu.block_id  y
      %2 = gpu.block_id  z
      %3 = gpu.thread_id  x
      %4 = gpu.thread_id  y
      %5 = gpu.thread_id  z
      %6 = gpu.grid_dim  x
      %7 = gpu.grid_dim  y
      %8 = gpu.grid_dim  z
      %9 = gpu.block_dim  x
      %10 = gpu.block_dim  y
      %11 = gpu.block_dim  z
      cf.br ^bb1
    ^bb1:  // pred: ^bb0
      %12 = arith.index_cast %0 : index to i64
      memref.store %12, %arg0[%0] : memref<100xi64>
      gpu.return
    }
  }
  func @main() {
    %0 = memref.get_global @__constant_100xi1 : memref<100xi1>
    %1 = call @foo(%0) : (memref<100xi1>) -> memref<i64>
    %2 = memref.cast %1 : memref<i64> to memref<*xi64>
    call @print_memref_i64(%2) : (memref<*xi64>) -> ()
    return
  }
  func private @print_memref_i64(memref<*xi64>)
}


// -----// IR Dump Before AbiAttrsPass //----- //
gpu.module @argmax.15_kernel {
  gpu.func @argmax.15_kernel(%arg0: memref<100xi64>) kernel {
    %0 = gpu.block_id  x
    cf.br ^bb1
  ^bb1:  // pred: ^bb0
    %1 = arith.index_cast %0 : index to i64
    memref.store %1, %arg0[%0] : memref<100xi64>
    gpu.return
  }
}

// -----// IR Dump Before SetSPIRVCapabilitiesPass //----- //
module @jit__argmax.79 attributes {gpu.container_module} {
  memref.global "private" constant @__constant_100xi1 : memref<100xi1> = dense<true>
  func @foo(%arg0: memref<100xi1>) -> memref<i64> {
    %0 = call @argmax.15(%arg0) : (memref<100xi1>) -> memref<i64>
    return %0 : memref<i64>
  }
  func private @argmax.15(%arg0: memref<100xi1>) -> memref<i64> {
    %c100 = arith.constant 100 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %c0_i64 = arith.constant 0 : i64
    %false = arith.constant false
    %memref = gpu.alloc  () {gpu.alloc_shared} : memref<100xi64>
    gpu.launch_func  @argmax.15_kernel::@argmax.15_kernel blocks in (%c100, %c1, %c1) threads in (%c1, %c1, %c1) args(%memref : memref<100xi64>)
    %0 = memref.alloc() : memref<i1>
    memref.store %false, %0[] : memref<i1>
    %1 = memref.alloc() : memref<i64>
    memref.store %c0_i64, %1[] : memref<i64>
    %2 = memref.alloc() : memref<i1>
    memref.copy %0, %2 : memref<i1> to memref<i1>
    %3 = memref.alloc() : memref<i64>
    memref.copy %1, %3 : memref<i64> to memref<i64>
    scf.for %arg1 = %c0 to %c100 step %c1 {
      %4 = memref.load %arg0[%arg1] : memref<100xi1>
      %5 = memref.load %memref[%arg1] : memref<100xi64>
      %6 = memref.load %2[] : memref<i1>
      %7 = memref.load %3[] : memref<i64>
      %8 = arith.cmpi sgt, %4, %6 : i1
      %9 = arith.cmpi sle, %4, %6 : i1
      %10 = arith.andi %8, %4 : i1
      %11 = arith.andi %9, %6 : i1
      %12 = arith.ori %10, %11 : i1
      %13 = arith.cmpi eq, %4, %6 : i1
      %14 = arith.cmpi slt, %5, %7 : i64
      %15 = arith.andi %13, %14 : i1
      %16 = arith.ori %8, %15 : i1
      %17 = arith.select %16, %5, %7 : i64
      memref.store %12, %2[] : memref<i1>
      memref.store %17, %3[] : memref<i64>
    }
    return %3 : memref<i64>
  }
  gpu.module @argmax.15_kernel {
    gpu.func @argmax.15_kernel(%arg0: memref<100xi64>) kernel attributes {spv.entry_point_abi = {local_size = dense<0> : vector<3xi32>}} {
      %0 = gpu.block_id  x
      cf.br ^bb1
    ^bb1:  // pred: ^bb0
      %1 = arith.index_cast %0 : index to i64
      memref.store %1, %arg0[%0] : memref<100xi64>
      gpu.return
    }
  }
  func @main() {
    %0 = memref.get_global @__constant_100xi1 : memref<100xi1>
    %1 = call @foo(%0) : (memref<100xi1>) -> memref<i64>
    %2 = memref.cast %1 : memref<i64> to memref<*xi64>
    call @print_memref_i64(%2) : (memref<*xi64>) -> ()
    return
  }
  func private @print_memref_i64(memref<*xi64>)
}


// -----// IR Dump Before GPUToSpirvPass //----- //
module @jit__argmax.79 attributes {gpu.container_module, spv.target_env = #spv.target_env<#spv.vce<v1.0, [Addresses, Float16Buffer, Int64, Int16, Int8, Kernel, Linkage, Vector16, GenericPointer, Groups, Float16, Float64, AtomicFloat32AddEXT], [SPV_EXT_shader_atomic_float_add]>, {}>} {
  memref.global "private" constant @__constant_100xi1 : memref<100xi1> = dense<true>
  func @foo(%arg0: memref<100xi1>) -> memref<i64> {
    %0 = call @argmax.15(%arg0) : (memref<100xi1>) -> memref<i64>
    return %0 : memref<i64>
  }
  func private @argmax.15(%arg0: memref<100xi1>) -> memref<i64> {
    %c100 = arith.constant 100 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %c0_i64 = arith.constant 0 : i64
    %false = arith.constant false
    %memref = gpu.alloc  () {gpu.alloc_shared} : memref<100xi64>
    gpu.launch_func  @argmax.15_kernel::@argmax.15_kernel blocks in (%c100, %c1, %c1) threads in (%c1, %c1, %c1) args(%memref : memref<100xi64>)
    %0 = memref.alloc() : memref<i1>
    memref.store %false, %0[] : memref<i1>
    %1 = memref.alloc() : memref<i64>
    memref.store %c0_i64, %1[] : memref<i64>
    %2 = memref.alloc() : memref<i1>
    memref.copy %0, %2 : memref<i1> to memref<i1>
    %3 = memref.alloc() : memref<i64>
    memref.copy %1, %3 : memref<i64> to memref<i64>
    scf.for %arg1 = %c0 to %c100 step %c1 {
      %4 = memref.load %arg0[%arg1] : memref<100xi1>
      %5 = memref.load %memref[%arg1] : memref<100xi64>
      %6 = memref.load %2[] : memref<i1>
      %7 = memref.load %3[] : memref<i64>
      %8 = arith.cmpi sgt, %4, %6 : i1
      %9 = arith.cmpi sle, %4, %6 : i1
      %10 = arith.andi %8, %4 : i1
      %11 = arith.andi %9, %6 : i1
      %12 = arith.ori %10, %11 : i1
      %13 = arith.cmpi eq, %4, %6 : i1
      %14 = arith.cmpi slt, %5, %7 : i64
      %15 = arith.andi %13, %14 : i1
      %16 = arith.ori %8, %15 : i1
      %17 = arith.select %16, %5, %7 : i64
      memref.store %12, %2[] : memref<i1>
      memref.store %17, %3[] : memref<i64>
    }
    return %3 : memref<i64>
  }
  gpu.module @argmax.15_kernel {
    gpu.func @argmax.15_kernel(%arg0: memref<100xi64>) kernel attributes {spv.entry_point_abi = {local_size = dense<0> : vector<3xi32>}} {
      %0 = gpu.block_id  x
      cf.br ^bb1
    ^bb1:  // pred: ^bb0
      %1 = arith.index_cast %0 : index to i64
      memref.store %1, %arg0[%0] : memref<100xi64>
      gpu.return
    }
  }
  func @main() {
    %0 = memref.get_global @__constant_100xi1 : memref<100xi1>
    %1 = call @foo(%0) : (memref<100xi1>) -> memref<i64>
    %2 = memref.cast %1 : memref<i64> to memref<*xi64>
    call @print_memref_i64(%2) : (memref<*xi64>) -> ()
    return
  }
  func private @print_memref_i64(memref<*xi64>)
}


// -----// IR Dump Before SPIRVLowerABIAttributes //----- //
spv.module @__spv__argmax.15_kernel Physical64 OpenCL {
  spv.GlobalVariable @__builtin_var_WorkgroupId__ built_in("WorkgroupId") : !spv.ptr<vector<3xi64>, Input>
  spv.func @argmax.15_kernel(%arg0: !spv.ptr<i64, CrossWorkgroup>) "None" attributes {spv.entry_point_abi = {local_size = dense<0> : vector<3xi32>}, workgroup_attributions = 0 : i64} {
    %__builtin_var_WorkgroupId___addr = spv.mlir.addressof @__builtin_var_WorkgroupId__ : !spv.ptr<vector<3xi64>, Input>
    %0 = spv.Load "Input" %__builtin_var_WorkgroupId___addr : vector<3xi64>
    %1 = spv.CompositeExtract %0[0 : i32] : vector<3xi64>
    spv.Branch ^bb1
  ^bb1:  // pred: ^bb0
    %2 = spv.InBoundsPtrAccessChain %arg0[%1] : !spv.ptr<i64, CrossWorkgroup>, i64
    spv.Store "CrossWorkgroup" %2, %1 ["Aligned", 8] : i64
    spv.Return
  }
}

// -----// IR Dump Before SPIRVUpdateVCE //----- //
spv.module @__spv__argmax.15_kernel Physical64 OpenCL {
  spv.GlobalVariable @__builtin_var_WorkgroupId__ built_in("WorkgroupId") : !spv.ptr<vector<3xi64>, Input>
  spv.func @argmax.15_kernel(%arg0: !spv.ptr<i64, CrossWorkgroup>) "None" attributes {workgroup_attributions = 0 : i64} {
    %__builtin_var_WorkgroupId___addr = spv.mlir.addressof @__builtin_var_WorkgroupId__ : !spv.ptr<vector<3xi64>, Input>
    %0 = spv.Load "Input" %__builtin_var_WorkgroupId___addr : vector<3xi64>
    %1 = spv.CompositeExtract %0[0 : i32] : vector<3xi64>
    spv.Branch ^bb1
  ^bb1:  // pred: ^bb0
    %2 = spv.InBoundsPtrAccessChain %arg0[%1] : !spv.ptr<i64, CrossWorkgroup>, i64
    spv.Store "CrossWorkgroup" %2, %1 ["Aligned", 8] : i64
    spv.Return
  }
  spv.EntryPoint "Kernel" @argmax.15_kernel, @__builtin_var_WorkgroupId__
  spv.ExecutionMode @argmax.15_kernel "LocalSize", 0, 0, 0
}

// -----// IR Dump Before SerializeSPIRVPass //----- //
module @jit__argmax.79 attributes {gpu.container_module, spv.target_env = #spv.target_env<#spv.vce<v1.0, [Addresses, Float16Buffer, Int64, Int16, Int8, Kernel, Linkage, Vector16, GenericPointer, Groups, Float16, Float64, AtomicFloat32AddEXT], [SPV_EXT_shader_atomic_float_add]>, {}>} {
  memref.global "private" constant @__constant_100xi1 : memref<100xi1> = dense<true>
  func @foo(%arg0: memref<100xi1>) -> memref<i64> {
    %0 = call @argmax.15(%arg0) : (memref<100xi1>) -> memref<i64>
    return %0 : memref<i64>
  }
  func private @argmax.15(%arg0: memref<100xi1>) -> memref<i64> {
    %c100 = arith.constant 100 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %c0_i64 = arith.constant 0 : i64
    %false = arith.constant false
    %memref = gpu.alloc  () {gpu.alloc_shared} : memref<100xi64>
    gpu.launch_func  @argmax.15_kernel::@argmax.15_kernel blocks in (%c100, %c1, %c1) threads in (%c1, %c1, %c1) args(%memref : memref<100xi64>)
    %0 = memref.alloc() : memref<i1>
    memref.store %false, %0[] : memref<i1>
    %1 = memref.alloc() : memref<i64>
    memref.store %c0_i64, %1[] : memref<i64>
    %2 = memref.alloc() : memref<i1>
    memref.copy %0, %2 : memref<i1> to memref<i1>
    %3 = memref.alloc() : memref<i64>
    memref.copy %1, %3 : memref<i64> to memref<i64>
    scf.for %arg1 = %c0 to %c100 step %c1 {
      %4 = memref.load %arg0[%arg1] : memref<100xi1>
      %5 = memref.load %memref[%arg1] : memref<100xi64>
      %6 = memref.load %2[] : memref<i1>
      %7 = memref.load %3[] : memref<i64>
      %8 = arith.cmpi sgt, %4, %6 : i1
      %9 = arith.cmpi sle, %4, %6 : i1
      %10 = arith.andi %8, %4 : i1
      %11 = arith.andi %9, %6 : i1
      %12 = arith.ori %10, %11 : i1
      %13 = arith.cmpi eq, %4, %6 : i1
      %14 = arith.cmpi slt, %5, %7 : i64
      %15 = arith.andi %13, %14 : i1
      %16 = arith.ori %8, %15 : i1
      %17 = arith.select %16, %5, %7 : i64
      memref.store %12, %2[] : memref<i1>
      memref.store %17, %3[] : memref<i64>
    }
    return %3 : memref<i64>
  }
  spv.module @__spv__argmax.15_kernel Physical64 OpenCL requires #spv.vce<v1.0, [Int64, Addresses, Kernel], []> {
    spv.GlobalVariable @__builtin_var_WorkgroupId__ built_in("WorkgroupId") : !spv.ptr<vector<3xi64>, Input>
    spv.func @argmax.15_kernel(%arg0: !spv.ptr<i64, CrossWorkgroup>) "None" attributes {workgroup_attributions = 0 : i64} {
      %__builtin_var_WorkgroupId___addr = spv.mlir.addressof @__builtin_var_WorkgroupId__ : !spv.ptr<vector<3xi64>, Input>
      %0 = spv.Load "Input" %__builtin_var_WorkgroupId___addr : vector<3xi64>
      %1 = spv.CompositeExtract %0[0 : i32] : vector<3xi64>
      spv.Branch ^bb1
    ^bb1:  // pred: ^bb0
      %2 = spv.InBoundsPtrAccessChain %arg0[%1] : !spv.ptr<i64, CrossWorkgroup>, i64
      spv.Store "CrossWorkgroup" %2, %1 ["Aligned", 8] : i64
      spv.Return
    }
    spv.EntryPoint "Kernel" @argmax.15_kernel, @__builtin_var_WorkgroupId__
    spv.ExecutionMode @argmax.15_kernel "LocalSize", 0, 0, 0
  }
  gpu.module @argmax.15_kernel {
    gpu.func @argmax.15_kernel(%arg0: memref<100xi64>) kernel attributes {spv.entry_point_abi = {local_size = dense<0> : vector<3xi32>}} {
      %0 = gpu.block_id  x
      cf.br ^bb1
    ^bb1:  // pred: ^bb0
      %1 = arith.index_cast %0 : index to i64
      memref.store %1, %arg0[%0] : memref<100xi64>
      gpu.return
    }
  }
  func @main() {
    %0 = memref.get_global @__constant_100xi1 : memref<100xi1>
    %1 = call @foo(%0) : (memref<100xi1>) -> memref<i64>
    %2 = memref.cast %1 : memref<i64> to memref<*xi64>
    call @print_memref_i64(%2) : (memref<*xi64>) -> ()
    return
  }
  func private @print_memref_i64(memref<*xi64>)
}


// -----// IR Dump Before GPUExPass //----- //
func @foo(%arg0: memref<100xi1>) -> memref<i64> {
  %0 = call @argmax.15(%arg0) : (memref<100xi1>) -> memref<i64>
  return %0 : memref<i64>
}

// -----// IR Dump Before GPUExPass //----- //
func private @argmax.15(%arg0: memref<100xi1>) -> memref<i64> {
  %c100 = arith.constant 100 : index
  %c1 = arith.constant 1 : index
  %c0 = arith.constant 0 : index
  %c0_i64 = arith.constant 0 : i64
  %false = arith.constant false
  %memref = gpu.alloc  () {gpu.alloc_shared} : memref<100xi64>
  gpu.launch_func  @argmax.15_kernel::@argmax.15_kernel blocks in (%c100, %c1, %c1) threads in (%c1, %c1, %c1) args(%memref : memref<100xi64>)
  %0 = memref.alloc() : memref<i1>
  memref.store %false, %0[] : memref<i1>
  %1 = memref.alloc() : memref<i64>
  memref.store %c0_i64, %1[] : memref<i64>
  %2 = memref.alloc() : memref<i1>
  memref.copy %0, %2 : memref<i1> to memref<i1>
  %3 = memref.alloc() : memref<i64>
  memref.copy %1, %3 : memref<i64> to memref<i64>
  scf.for %arg1 = %c0 to %c100 step %c1 {
    %4 = memref.load %arg0[%arg1] : memref<100xi1>
    %5 = memref.load %memref[%arg1] : memref<100xi64>
    %6 = memref.load %2[] : memref<i1>
    %7 = memref.load %3[] : memref<i64>
    %8 = arith.cmpi sgt, %4, %6 : i1
    %9 = arith.cmpi sle, %4, %6 : i1
    %10 = arith.andi %8, %4 : i1
    %11 = arith.andi %9, %6 : i1
    %12 = arith.ori %10, %11 : i1
    %13 = arith.cmpi eq, %4, %6 : i1
    %14 = arith.cmpi slt, %5, %7 : i64
    %15 = arith.andi %13, %14 : i1
    %16 = arith.ori %8, %15 : i1
    %17 = arith.select %16, %5, %7 : i64
    memref.store %12, %2[] : memref<i1>
    memref.store %17, %3[] : memref<i64>
  }
  return %3 : memref<i64>
}

// -----// IR Dump Before GPUExPass //----- //
func private @print_memref_i64(memref<*xi64>)

// -----// IR Dump Before GPUExPass //----- //
func @main() {
  %0 = memref.get_global @__constant_100xi1 : memref<100xi1>
  %1 = call @foo(%0) : (memref<100xi1>) -> memref<i64>
  %2 = memref.cast %1 : memref<i64> to memref<*xi64>
  call @print_memref_i64(%2) : (memref<*xi64>) -> ()
  return
}

// -----// IR Dump Before EnumerateEventsPass //----- //
module @jit__argmax.79 attributes {gpu.container_module, spv.target_env = #spv.target_env<#spv.vce<v1.0, [Addresses, Float16Buffer, Int64, Int16, Int8, Kernel, Linkage, Vector16, GenericPointer, Groups, Float16, Float64, AtomicFloat32AddEXT], [SPV_EXT_shader_atomic_float_add]>, {}>} {
  memref.global "private" constant @__constant_100xi1 : memref<100xi1> = dense<true>
  func @foo(%arg0: memref<100xi1>) -> memref<i64> {
    %0 = call @argmax.15(%arg0) : (memref<100xi1>) -> memref<i64>
    return %0 : memref<i64>
  }
  func private @argmax.15(%arg0: memref<100xi1>) -> memref<i64> {
    %c100 = arith.constant 100 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %c0_i64 = arith.constant 0 : i64
    %false = arith.constant false
    %0 = "gpu_runtime.create_gpu_stream"() : () -> !gpu_runtime.OpaqueType
    %memref = "gpu_runtime.gpu_alloc"(%0) {gpu.alloc_shared, operand_segment_sizes = dense<[0, 1, 0, 0]> : vector<4xi32>} : (!gpu_runtime.OpaqueType) -> memref<100xi64>
    %1 = "gpu_runtime.load_gpu_module"(%0) {module = @argmax.15_kernel} : (!gpu_runtime.OpaqueType) -> !gpu_runtime.OpaqueType
    %2 = "gpu_runtime.get_gpu_kernel"(%1) {kernel = @argmax.15_kernel} : (!gpu_runtime.OpaqueType) -> !gpu_runtime.OpaqueType
    "gpu_runtime.launch_gpu_kernel"(%0, %2, %c100, %c1, %c1, %c1, %c1, %c1, %memref) {operand_segment_sizes = dense<[0, 1, 1, 1, 1, 1, 1, 1, 1, 1]> : vector<10xi32>} : (!gpu_runtime.OpaqueType, !gpu_runtime.OpaqueType, index, index, index, index, index, index, memref<100xi64>) -> ()
    %3 = memref.alloc() : memref<i1>
    memref.store %false, %3[] : memref<i1>
    %4 = memref.alloc() : memref<i64>
    memref.store %c0_i64, %4[] : memref<i64>
    %5 = memref.alloc() : memref<i1>
    memref.copy %3, %5 : memref<i1> to memref<i1>
    %6 = memref.alloc() : memref<i64>
    memref.copy %4, %6 : memref<i64> to memref<i64>
    scf.for %arg1 = %c0 to %c100 step %c1 {
      %7 = memref.load %arg0[%arg1] : memref<100xi1>
      %8 = memref.load %memref[%arg1] : memref<100xi64>
      %9 = memref.load %5[] : memref<i1>
      %10 = memref.load %6[] : memref<i64>
      %11 = arith.cmpi sgt, %7, %9 : i1
      %12 = arith.cmpi sle, %7, %9 : i1
      %13 = arith.andi %11, %7 : i1
      %14 = arith.andi %12, %9 : i1
      %15 = arith.ori %13, %14 : i1
      %16 = arith.cmpi eq, %7, %9 : i1
      %17 = arith.cmpi slt, %8, %10 : i64
      %18 = arith.andi %16, %17 : i1
      %19 = arith.ori %11, %18 : i1
      %20 = arith.select %19, %8, %10 : i64
      memref.store %15, %5[] : memref<i1>
      memref.store %20, %6[] : memref<i64>
    }
    "gpu_runtime.destroy_gpu_stream"(%0) : (!gpu_runtime.OpaqueType) -> ()
    return %6 : memref<i64>
  }
  gpu.module @argmax.15_kernel attributes {gpu.binary = "\03\02#\07\00\00\01\00\16\00\00\00\0F\00\00\00\00\00\00\00\11\00\02\00\0B\00\00\00\11\00\02\00\04\00\00\00\11\00\02\00\06\00\00\00\0E\00\03\00\02\00\00\00\02\00\00\00\0F\00\09\00\06\00\00\00\08\00\00\00argmax.15_kernel\00\00\00\00\04\00\00\00\10\00\06\00\08\00\00\00\11\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\05\00\09\00\04\00\00\00__builtin_var_WorkgroupId__\00\05\00\07\00\08\00\00\00argmax.15_kernel\00\00\00\00G\00\04\00\04\00\00\00\0B\00\00\00\1A\00\00\00\15\00\04\00\03\00\00\00@\00\00\00\00\00\00\00\17\00\04\00\02\00\00\00\03\00\00\00\03\00\00\00 \00\04\00\01\00\00\00\01\00\00\00\02\00\00\00;\00\04\00\01\00\00\00\04\00\00\00\01\00\00\00\13\00\02\00\06\00\00\00 \00\04\00\07\00\00\00\05\00\00\00\03\00\00\00!\00\04\00\05\00\00\00\06\00\00\00\07\00\00\006\00\05\00\06\00\00\00\08\00\00\00\00\00\00\00\05\00\00\007\00\03\00\07\00\00\00\09\00\00\00\F8\00\02\00\0A\00\00\00=\00\04\00\02\00\00\00\0B\00\00\00\04\00\00\00Q\00\05\00\03\00\00\00\0C\00\00\00\0B\00\00\00\00\00\00\00\F9\00\02\00\0D\00\00\00\F8\00\02\00\0D\00\00\00F\00\05\00\07\00\00\00\0E\00\00\00\09\00\00\00\0C\00\00\00>\00\05\00\0E\00\00\00\0C\00\00\00\02\00\00\00\08\00\00\00\FD\00\01\008\00\01\00"} {
    gpu.func @argmax.15_kernel(%arg0: memref<100xi64>) kernel attributes {spv.entry_point_abi = {local_size = dense<0> : vector<3xi32>}} {
      %0 = gpu.block_id  x
      cf.br ^bb1
    ^bb1:  // pred: ^bb0
      %1 = arith.index_cast %0 : index to i64
      memref.store %1, %arg0[%0] : memref<100xi64>
      gpu.return
    }
  }
  func @main() {
    %0 = memref.get_global @__constant_100xi1 : memref<100xi1>
    %1 = call @foo(%0) : (memref<100xi1>) -> memref<i64>
    %2 = memref.cast %1 : memref<i64> to memref<*xi64>
    call @print_memref_i64(%2) : (memref<*xi64>) -> ()
    return
  }
  func private @print_memref_i64(memref<*xi64>)
}


// -----// IR Dump Before GPUToLLVMPass //----- //
module @jit__argmax.79 attributes {gpu.container_module, gpu.event_count = 0 : i64, spv.target_env = #spv.target_env<#spv.vce<v1.0, [Addresses, Float16Buffer, Int64, Int16, Int8, Kernel, Linkage, Vector16, GenericPointer, Groups, Float16, Float64, AtomicFloat32AddEXT], [SPV_EXT_shader_atomic_float_add]>, {}>} {
  memref.global "private" constant @__constant_100xi1 : memref<100xi1> = dense<true>
  func @foo(%arg0: memref<100xi1>) -> memref<i64> {
    %0 = call @argmax.15(%arg0) : (memref<100xi1>) -> memref<i64>
    return %0 : memref<i64>
  }
  func private @argmax.15(%arg0: memref<100xi1>) -> memref<i64> {
    %c100 = arith.constant 100 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %c0_i64 = arith.constant 0 : i64
    %false = arith.constant false
    %0 = "gpu_runtime.create_gpu_stream"() : () -> !gpu_runtime.OpaqueType
    %memref = "gpu_runtime.gpu_alloc"(%0) {gpu.alloc_shared, operand_segment_sizes = dense<[0, 1, 0, 0]> : vector<4xi32>} : (!gpu_runtime.OpaqueType) -> memref<100xi64>
    %1 = "gpu_runtime.load_gpu_module"(%0) {module = @argmax.15_kernel} : (!gpu_runtime.OpaqueType) -> !gpu_runtime.OpaqueType
    %2 = "gpu_runtime.get_gpu_kernel"(%1) {kernel = @argmax.15_kernel} : (!gpu_runtime.OpaqueType) -> !gpu_runtime.OpaqueType
    "gpu_runtime.launch_gpu_kernel"(%0, %2, %c100, %c1, %c1, %c1, %c1, %c1, %memref) {operand_segment_sizes = dense<[0, 1, 1, 1, 1, 1, 1, 1, 1, 1]> : vector<10xi32>} : (!gpu_runtime.OpaqueType, !gpu_runtime.OpaqueType, index, index, index, index, index, index, memref<100xi64>) -> ()
    %3 = memref.alloc() : memref<i1>
    memref.store %false, %3[] : memref<i1>
    %4 = memref.alloc() : memref<i64>
    memref.store %c0_i64, %4[] : memref<i64>
    %5 = memref.alloc() : memref<i1>
    memref.copy %3, %5 : memref<i1> to memref<i1>
    %6 = memref.alloc() : memref<i64>
    memref.copy %4, %6 : memref<i64> to memref<i64>
    scf.for %arg1 = %c0 to %c100 step %c1 {
      %7 = memref.load %arg0[%arg1] : memref<100xi1>
      %8 = memref.load %memref[%arg1] : memref<100xi64>
      %9 = memref.load %5[] : memref<i1>
      %10 = memref.load %6[] : memref<i64>
      %11 = arith.cmpi sgt, %7, %9 : i1
      %12 = arith.cmpi sle, %7, %9 : i1
      %13 = arith.andi %11, %7 : i1
      %14 = arith.andi %12, %9 : i1
      %15 = arith.ori %13, %14 : i1
      %16 = arith.cmpi eq, %7, %9 : i1
      %17 = arith.cmpi slt, %8, %10 : i64
      %18 = arith.andi %16, %17 : i1
      %19 = arith.ori %11, %18 : i1
      %20 = arith.select %19, %8, %10 : i64
      memref.store %15, %5[] : memref<i1>
      memref.store %20, %6[] : memref<i64>
    }
    "gpu_runtime.destroy_gpu_stream"(%0) : (!gpu_runtime.OpaqueType) -> ()
    return %6 : memref<i64>
  }
  gpu.module @argmax.15_kernel attributes {gpu.binary = "\03\02#\07\00\00\01\00\16\00\00\00\0F\00\00\00\00\00\00\00\11\00\02\00\0B\00\00\00\11\00\02\00\04\00\00\00\11\00\02\00\06\00\00\00\0E\00\03\00\02\00\00\00\02\00\00\00\0F\00\09\00\06\00\00\00\08\00\00\00argmax.15_kernel\00\00\00\00\04\00\00\00\10\00\06\00\08\00\00\00\11\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\05\00\09\00\04\00\00\00__builtin_var_WorkgroupId__\00\05\00\07\00\08\00\00\00argmax.15_kernel\00\00\00\00G\00\04\00\04\00\00\00\0B\00\00\00\1A\00\00\00\15\00\04\00\03\00\00\00@\00\00\00\00\00\00\00\17\00\04\00\02\00\00\00\03\00\00\00\03\00\00\00 \00\04\00\01\00\00\00\01\00\00\00\02\00\00\00;\00\04\00\01\00\00\00\04\00\00\00\01\00\00\00\13\00\02\00\06\00\00\00 \00\04\00\07\00\00\00\05\00\00\00\03\00\00\00!\00\04\00\05\00\00\00\06\00\00\00\07\00\00\006\00\05\00\06\00\00\00\08\00\00\00\00\00\00\00\05\00\00\007\00\03\00\07\00\00\00\09\00\00\00\F8\00\02\00\0A\00\00\00=\00\04\00\02\00\00\00\0B\00\00\00\04\00\00\00Q\00\05\00\03\00\00\00\0C\00\00\00\0B\00\00\00\00\00\00\00\F9\00\02\00\0D\00\00\00\F8\00\02\00\0D\00\00\00F\00\05\00\07\00\00\00\0E\00\00\00\09\00\00\00\0C\00\00\00>\00\05\00\0E\00\00\00\0C\00\00\00\02\00\00\00\08\00\00\00\FD\00\01\008\00\01\00"} {
    gpu.func @argmax.15_kernel(%arg0: memref<100xi64>) kernel attributes {spv.entry_point_abi = {local_size = dense<0> : vector<3xi32>}} {
      %0 = gpu.block_id  x
      cf.br ^bb1
    ^bb1:  // pred: ^bb0
      %1 = arith.index_cast %0 : index to i64
      memref.store %1, %arg0[%0] : memref<100xi64>
      gpu.return
    }
  }
  func @main() {
    %0 = memref.get_global @__constant_100xi1 : memref<100xi1>
    %1 = call @foo(%0) : (memref<100xi1>) -> memref<i64>
    %2 = memref.cast %1 : memref<i64> to memref<*xi64>
    call @print_memref_i64(%2) : (memref<*xi64>) -> ()
    return
  }
  func private @print_memref_i64(memref<*xi64>)
}


// -----// IR Dump Before ConvertStandardToLLVM //----- //
module @jit__argmax.79 attributes {gpu.container_module, gpu.event_count = 0 : i64, spv.target_env = #spv.target_env<#spv.vce<v1.0, [Addresses, Float16Buffer, Int64, Int16, Int8, Kernel, Linkage, Vector16, GenericPointer, Groups, Float16, Float64, AtomicFloat32AddEXT], [SPV_EXT_shader_atomic_float_add]>, {}>} {
  llvm.mlir.global internal constant @kernel_name("argmax.15_kernel\00")
  llvm.mlir.global internal constant @gpu_blob("\03\02#\07\00\00\01\00\16\00\00\00\0F\00\00\00\00\00\00\00\11\00\02\00\0B\00\00\00\11\00\02\00\04\00\00\00\11\00\02\00\06\00\00\00\0E\00\03\00\02\00\00\00\02\00\00\00\0F\00\09\00\06\00\00\00\08\00\00\00argmax.15_kernel\00\00\00\00\04\00\00\00\10\00\06\00\08\00\00\00\11\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\05\00\09\00\04\00\00\00__builtin_var_WorkgroupId__\00\05\00\07\00\08\00\00\00argmax.15_kernel\00\00\00\00G\00\04\00\04\00\00\00\0B\00\00\00\1A\00\00\00\15\00\04\00\03\00\00\00@\00\00\00\00\00\00\00\17\00\04\00\02\00\00\00\03\00\00\00\03\00\00\00 \00\04\00\01\00\00\00\01\00\00\00\02\00\00\00;\00\04\00\01\00\00\00\04\00\00\00\01\00\00\00\13\00\02\00\06\00\00\00 \00\04\00\07\00\00\00\05\00\00\00\03\00\00\00!\00\04\00\05\00\00\00\06\00\00\00\07\00\00\006\00\05\00\06\00\00\00\08\00\00\00\00\00\00\00\05\00\00\007\00\03\00\07\00\00\00\09\00\00\00\F8\00\02\00\0A\00\00\00=\00\04\00\02\00\00\00\0B\00\00\00\04\00\00\00Q\00\05\00\03\00\00\00\0C\00\00\00\0B\00\00\00\00\00\00\00\F9\00\02\00\0D\00\00\00\F8\00\02\00\0D\00\00\00F\00\05\00\07\00\00\00\0E\00\00\00\09\00\00\00\0C\00\00\00>\00\05\00\0E\00\00\00\0C\00\00\00\02\00\00\00\08\00\00\00\FD\00\01\008\00\01\00")
  memref.global "private" constant @__constant_100xi1 : memref<100xi1> = dense<true>
  func @foo(%arg0: memref<100xi1>) -> memref<i64> {
    %0 = call @argmax.15(%arg0) : (memref<100xi1>) -> memref<i64>
    return %0 : memref<i64>
  }
  func private @argmax.15(%arg0: memref<100xi1>) -> memref<i64> {
    %c100 = arith.constant 100 : index
    %0 = builtin.unrealized_conversion_cast %c100 : index to i64
    %c1 = arith.constant 1 : index
    %1 = builtin.unrealized_conversion_cast %c1 : index to i64
    %c0 = arith.constant 0 : index
    %c0_i64 = arith.constant 0 : i64
    %false = arith.constant false
    %2 = llvm.mlir.constant(0 : i64) : i64
    %3 = llvm.call @dpcompGpuStreamCreate(%2) : (i64) -> !llvm.ptr<i8>
    %4 = llvm.mlir.constant(100 : index) : i64
    %5 = llvm.mlir.constant(1 : index) : i64
    %6 = llvm.mlir.null : !llvm.ptr<i64>
    %7 = llvm.getelementptr %6[%4] : (!llvm.ptr<i64>, i64) -> !llvm.ptr<i64>
    %8 = llvm.ptrtoint %7 : !llvm.ptr<i64> to i64
    %9 = llvm.mlir.constant(64 : i64) : i64
    %10 = llvm.mlir.constant(1 : i32) : i32
    %11 = llvm.mlir.undef : !llvm.array<1 x ptr<i8>>
    %12 = llvm.mlir.null : !llvm.ptr<i8>
    %13 = llvm.insertvalue %12, %11[0] : !llvm.array<1 x ptr<i8>>
    %14 = llvm.mlir.constant(1 : i64) : i64
    %15 = llvm.alloca %14 x !llvm.array<1 x ptr<i8>> : (i64) -> !llvm.ptr<array<1 x ptr<i8>>>
    llvm.store %13, %15 : !llvm.ptr<array<1 x ptr<i8>>>
    %16 = llvm.bitcast %15 : !llvm.ptr<array<1 x ptr<i8>>> to !llvm.ptr<ptr<i8>>
    %17 = llvm.mlir.constant(-1 : i64) : i64
    %18 = llvm.mlir.constant(1 : i64) : i64
    %19 = llvm.alloca %18 x !llvm.struct<(ptr<i8>, ptr<i8>, ptr<i8>)> : (i64) -> !llvm.ptr<struct<(ptr<i8>, ptr<i8>, ptr<i8>)>>
    llvm.call @dpcompGpuAlloc(%3, %8, %9, %10, %16, %17, %19) : (!llvm.ptr<i8>, i64, i64, i32, !llvm.ptr<ptr<i8>>, i64, !llvm.ptr<struct<(ptr<i8>, ptr<i8>, ptr<i8>)>>) -> ()
    %20 = llvm.load %19 : !llvm.ptr<struct<(ptr<i8>, ptr<i8>, ptr<i8>)>>
    %21 = llvm.extractvalue %20[0] : !llvm.struct<(ptr<i8>, ptr<i8>, ptr<i8>)>
    %22 = llvm.extractvalue %20[1] : !llvm.struct<(ptr<i8>, ptr<i8>, ptr<i8>)>
    %23 = llvm.mlir.undef : !llvm.struct<(ptr<i64>, ptr<i64>, i64, array<1 x i64>, array<1 x i64>)>
    %24 = llvm.bitcast %21 : !llvm.ptr<i8> to !llvm.ptr<i64>
    %25 = llvm.insertvalue %24, %23[0] : !llvm.struct<(ptr<i64>, ptr<i64>, i64, array<1 x i64>, array<1 x i64>)>
    %26 = llvm.bitcast %22 : !llvm.ptr<i8> to !llvm.ptr<i64>
    %27 = llvm.insertvalue %26, %25[1] : !llvm.struct<(ptr<i64>, ptr<i64>, i64, array<1 x i64>, array<1 x i64>)>
    %28 = llvm.mlir.constant(0 : i64) : i64
    %29 = llvm.insertvalue %28, %27[2] : !llvm.struct<(ptr<i64>, ptr<i64>, i64, array<1 x i64>, array<1 x i64>)>
    %30 = llvm.insertvalue %4, %29[3, 0] : !llvm.struct<(ptr<i64>, ptr<i64>, i64, array<1 x i64>, array<1 x i64>)>
    %31 = llvm.insertvalue %5, %30[4, 0] : !llvm.struct<(ptr<i64>, ptr<i64>, i64, array<1 x i64>, array<1 x i64>)>
    %32 = builtin.unrealized_conversion_cast %31 : !llvm.struct<(ptr<i64>, ptr<i64>, i64, array<1 x i64>, array<1 x i64>)> to memref<100xi64>
    %33 = llvm.mlir.addressof @gpu_blob : !llvm.ptr<array<440 x i8>>
    %34 = llvm.mlir.constant(0 : index) : i64
    %35 = llvm.getelementptr %33[%34, %34] : (!llvm.ptr<array<440 x i8>>, i64, i64) -> !llvm.ptr<i8>
    %36 = llvm.mlir.constant(440 : i64) : i64
    %37 = llvm.call @dpcompGpuModuleLoad(%3, %35, %36) : (!llvm.ptr<i8>, !llvm.ptr<i8>, i64) -> !llvm.ptr<i8>
    %38 = llvm.mlir.addressof @kernel_name : !llvm.ptr<array<17 x i8>>
    %39 = llvm.mlir.constant(0 : index) : i64
    %40 = llvm.getelementptr %38[%39, %39] : (!llvm.ptr<array<17 x i8>>, i64, i64) -> !llvm.ptr<i8>
    %41 = llvm.call @dpcompGpuKernelGet(%37, %40) : (!llvm.ptr<i8>, !llvm.ptr<i8>) -> !llvm.ptr<i8>
    %42 = llvm.mlir.undef : !llvm.array<1 x ptr<i8>>
    %43 = llvm.mlir.null : !llvm.ptr<i8>
    %44 = llvm.insertvalue %43, %42[0] : !llvm.array<1 x ptr<i8>>
    %45 = llvm.mlir.constant(1 : i64) : i64
    %46 = llvm.alloca %45 x !llvm.array<1 x ptr<i8>> : (i64) -> !llvm.ptr<array<1 x ptr<i8>>>
    llvm.store %44, %46 : !llvm.ptr<array<1 x ptr<i8>>>
    %47 = llvm.bitcast %46 : !llvm.ptr<array<1 x ptr<i8>>> to !llvm.ptr<ptr<i8>>
    %48 = llvm.mlir.constant(1 : i64) : i64
    %49 = llvm.alloca %48 x !llvm.ptr<i64> : (i64) -> !llvm.ptr<ptr<i64>>
    %50 = llvm.alloca %48 x !llvm.array<2 x struct<(ptr<i8>, i64)>> : (i64) -> !llvm.ptr<array<2 x struct<(ptr<i8>, i64)>>>
    %51 = llvm.mlir.undef : !llvm.array<2 x struct<(ptr<i8>, i64)>>
    %52 = llvm.mlir.constant(1 : i32) : i32
    %53 = llvm.extractvalue %31[1] : !llvm.struct<(ptr<i64>, ptr<i64>, i64, array<1 x i64>, array<1 x i64>)>
    llvm.store %53, %49 : !llvm.ptr<ptr<i64>>
    %54 = llvm.bitcast %49 : !llvm.ptr<ptr<i64>> to !llvm.ptr<i8>
    %55 = llvm.mlir.null : !llvm.ptr<ptr<i64>>
    %56 = llvm.getelementptr %55[%52] : (!llvm.ptr<ptr<i64>>, i32) -> !llvm.ptr<ptr<i64>>
    %57 = llvm.ptrtoint %56 : !llvm.ptr<ptr<i64>> to i64
    %58 = llvm.mlir.undef : !llvm.struct<(ptr<i8>, i64)>
    %59 = llvm.insertvalue %54, %58[0] : !llvm.struct<(ptr<i8>, i64)>
    %60 = llvm.insertvalue %57, %59[1] : !llvm.struct<(ptr<i8>, i64)>
    %61 = llvm.insertvalue %60, %51[0] : !llvm.array<2 x struct<(ptr<i8>, i64)>>
    %62 = llvm.mlir.null : !llvm.ptr<i8>
    %63 = llvm.mlir.constant(0 : i64) : i64
    %64 = llvm.mlir.undef : !llvm.struct<(ptr<i8>, i64)>
    %65 = llvm.insertvalue %62, %64[0] : !llvm.struct<(ptr<i8>, i64)>
    %66 = llvm.insertvalue %63, %65[1] : !llvm.struct<(ptr<i8>, i64)>
    %67 = llvm.insertvalue %66, %61[1] : !llvm.array<2 x struct<(ptr<i8>, i64)>>
    llvm.store %67, %50 : !llvm.ptr<array<2 x struct<(ptr<i8>, i64)>>>
    %68 = llvm.mlir.constant(-1 : i64) : i64
    %69 = llvm.bitcast %50 : !llvm.ptr<array<2 x struct<(ptr<i8>, i64)>>> to !llvm.ptr<struct<(ptr<i8>, i64)>>
    %70 = llvm.call @dpcompGpuLaunchKernel(%3, %41, %0, %1, %1, %1, %1, %1, %47, %69, %68) : (!llvm.ptr<i8>, !llvm.ptr<i8>, i64, i64, i64, i64, i64, i64, !llvm.ptr<ptr<i8>>, !llvm.ptr<struct<(ptr<i8>, i64)>>, i64) -> !llvm.ptr<i8>
    %71 = memref.alloc() : memref<i1>
    memref.store %false, %71[] : memref<i1>
    %72 = memref.alloc() : memref<i64>
    memref.store %c0_i64, %72[] : memref<i64>
    %73 = memref.alloc() : memref<i1>
    memref.copy %71, %73 : memref<i1> to memref<i1>
    %74 = memref.alloc() : memref<i64>
    memref.copy %72, %74 : memref<i64> to memref<i64>
    scf.for %arg1 = %c0 to %c100 step %c1 {
      %75 = memref.load %arg0[%arg1] : memref<100xi1>
      %76 = memref.load %32[%arg1] : memref<100xi64>
      %77 = memref.load %73[] : memref<i1>
      %78 = memref.load %74[] : memref<i64>
      %79 = arith.cmpi sgt, %75, %77 : i1
      %80 = arith.cmpi sle, %75, %77 : i1
      %81 = arith.andi %79, %75 : i1
      %82 = arith.andi %80, %77 : i1
      %83 = arith.ori %81, %82 : i1
      %84 = arith.cmpi eq, %75, %77 : i1
      %85 = arith.cmpi slt, %76, %78 : i64
      %86 = arith.andi %84, %85 : i1
      %87 = arith.ori %79, %86 : i1
      %88 = arith.select %87, %76, %78 : i64
      memref.store %83, %73[] : memref<i1>
      memref.store %88, %74[] : memref<i64>
    }
    llvm.call @dpcompGpuStreamDestroy(%3) : (!llvm.ptr<i8>) -> ()
    return %74 : memref<i64>
  }
  func @main() {
    %0 = memref.get_global @__constant_100xi1 : memref<100xi1>
    %1 = call @foo(%0) : (memref<100xi1>) -> memref<i64>
    %2 = memref.cast %1 : memref<i64> to memref<*xi64>
    call @print_memref_i64(%2) : (memref<*xi64>) -> ()
    return
  }
  func private @print_memref_i64(memref<*xi64>)
  llvm.func @dpcompGpuStreamCreate(i64) -> !llvm.ptr<i8>
  llvm.func @dpcompGpuAlloc(!llvm.ptr<i8>, i64, i64, i32, !llvm.ptr<ptr<i8>>, i64, !llvm.ptr<struct<(ptr<i8>, ptr<i8>, ptr<i8>)>>)
  llvm.func @dpcompGpuModuleLoad(!llvm.ptr<i8>, !llvm.ptr<i8>, i64) -> !llvm.ptr<i8>
  llvm.func @dpcompGpuKernelGet(!llvm.ptr<i8>, !llvm.ptr<i8>) -> !llvm.ptr<i8>
  llvm.func @dpcompGpuLaunchKernel(!llvm.ptr<i8>, !llvm.ptr<i8>, i64, i64, i64, i64, i64, i64, !llvm.ptr<ptr<i8>>, !llvm.ptr<struct<(ptr<i8>, i64)>>, i64) -> !llvm.ptr<i8>
  llvm.func @dpcompGpuStreamDestroy(!llvm.ptr<i8>)
}


// -----// IR Dump Before ConvertMemRefToLLVM //----- //
module @jit__argmax.79 attributes {gpu.container_module, gpu.event_count = 0 : i64, llvm.data_layout = "", spv.target_env = #spv.target_env<#spv.vce<v1.0, [Addresses, Float16Buffer, Int64, Int16, Int8, Kernel, Linkage, Vector16, GenericPointer, Groups, Float16, Float64, AtomicFloat32AddEXT], [SPV_EXT_shader_atomic_float_add]>, {}>} {
  llvm.mlir.global internal constant @kernel_name("argmax.15_kernel\00")
  llvm.mlir.global internal constant @gpu_blob("\03\02#\07\00\00\01\00\16\00\00\00\0F\00\00\00\00\00\00\00\11\00\02\00\0B\00\00\00\11\00\02\00\04\00\00\00\11\00\02\00\06\00\00\00\0E\00\03\00\02\00\00\00\02\00\00\00\0F\00\09\00\06\00\00\00\08\00\00\00argmax.15_kernel\00\00\00\00\04\00\00\00\10\00\06\00\08\00\00\00\11\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\05\00\09\00\04\00\00\00__builtin_var_WorkgroupId__\00\05\00\07\00\08\00\00\00argmax.15_kernel\00\00\00\00G\00\04\00\04\00\00\00\0B\00\00\00\1A\00\00\00\15\00\04\00\03\00\00\00@\00\00\00\00\00\00\00\17\00\04\00\02\00\00\00\03\00\00\00\03\00\00\00 \00\04\00\01\00\00\00\01\00\00\00\02\00\00\00;\00\04\00\01\00\00\00\04\00\00\00\01\00\00\00\13\00\02\00\06\00\00\00 \00\04\00\07\00\00\00\05\00\00\00\03\00\00\00!\00\04\00\05\00\00\00\06\00\00\00\07\00\00\006\00\05\00\06\00\00\00\08\00\00\00\00\00\00\00\05\00\00\007\00\03\00\07\00\00\00\09\00\00\00\F8\00\02\00\0A\00\00\00=\00\04\00\02\00\00\00\0B\00\00\00\04\00\00\00Q\00\05\00\03\00\00\00\0C\00\00\00\0B\00\00\00\00\00\00\00\F9\00\02\00\0D\00\00\00\F8\00\02\00\0D\00\00\00F\00\05\00\07\00\00\00\0E\00\00\00\09\00\00\00\0C\00\00\00>\00\05\00\0E\00\00\00\0C\00\00\00\02\00\00\00\08\00\00\00\FD\00\01\008\00\01\00")
  memref.global "private" constant @__constant_100xi1 : memref<100xi1> = dense<true>
  llvm.func @foo(%arg0: !llvm.ptr<i1>, %arg1: !llvm.ptr<i1>, %arg2: i64, %arg3: i64, %arg4: i64) -> !llvm.struct<(ptr<i64>, ptr<i64>, i64)> {
    %0 = llvm.mlir.undef : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %3 = llvm.insertvalue %arg2, %2[2] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %4 = llvm.insertvalue %arg3, %3[3, 0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %5 = llvm.insertvalue %arg4, %4[4, 0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %6 = llvm.extractvalue %5[0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %7 = llvm.extractvalue %5[1] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %8 = llvm.extractvalue %5[2] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %9 = llvm.extractvalue %5[3, 0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %10 = llvm.extractvalue %5[4, 0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %11 = llvm.call @argmax.15(%6, %7, %8, %9, %10) : (!llvm.ptr<i1>, !llvm.ptr<i1>, i64, i64, i64) -> !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
    llvm.return %11 : !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
  }
  llvm.func @_mlir_ciface_foo(%arg0: !llvm.ptr<struct<(ptr<i64>, ptr<i64>, i64)>>, %arg1: !llvm.ptr<struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>>) {
    %0 = llvm.load %arg1 : !llvm.ptr<struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>>
    %1 = llvm.extractvalue %0[0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %2 = llvm.extractvalue %0[1] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %3 = llvm.extractvalue %0[2] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %4 = llvm.extractvalue %0[3, 0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %5 = llvm.extractvalue %0[4, 0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %6 = llvm.call @foo(%1, %2, %3, %4, %5) : (!llvm.ptr<i1>, !llvm.ptr<i1>, i64, i64, i64) -> !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
    llvm.store %6, %arg0 : !llvm.ptr<struct<(ptr<i64>, ptr<i64>, i64)>>
    llvm.return
  }
  llvm.func @argmax.15(%arg0: !llvm.ptr<i1>, %arg1: !llvm.ptr<i1>, %arg2: i64, %arg3: i64, %arg4: i64) -> !llvm.struct<(ptr<i64>, ptr<i64>, i64)> attributes {sym_visibility = "private"} {
    %0 = llvm.mlir.undef : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %3 = llvm.insertvalue %arg2, %2[2] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %4 = llvm.insertvalue %arg3, %3[3, 0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %5 = llvm.insertvalue %arg4, %4[4, 0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %6 = builtin.unrealized_conversion_cast %5 : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)> to memref<100xi1>
    %7 = llvm.mlir.constant(100 : index) : i64
    %8 = builtin.unrealized_conversion_cast %7 : i64 to index
    %9 = builtin.unrealized_conversion_cast %8 : index to i64
    %10 = llvm.mlir.constant(1 : index) : i64
    %11 = builtin.unrealized_conversion_cast %10 : i64 to index
    %12 = builtin.unrealized_conversion_cast %11 : index to i64
    %13 = llvm.mlir.constant(0 : index) : i64
    %14 = builtin.unrealized_conversion_cast %13 : i64 to index
    %15 = llvm.mlir.constant(0 : i64) : i64
    %16 = llvm.mlir.constant(false) : i1
    %17 = llvm.mlir.constant(0 : i64) : i64
    %18 = llvm.call @dpcompGpuStreamCreate(%17) : (i64) -> !llvm.ptr<i8>
    %19 = llvm.mlir.constant(100 : index) : i64
    %20 = llvm.mlir.constant(1 : index) : i64
    %21 = llvm.mlir.null : !llvm.ptr<i64>
    %22 = llvm.getelementptr %21[%19] : (!llvm.ptr<i64>, i64) -> !llvm.ptr<i64>
    %23 = llvm.ptrtoint %22 : !llvm.ptr<i64> to i64
    %24 = llvm.mlir.constant(64 : i64) : i64
    %25 = llvm.mlir.constant(1 : i32) : i32
    %26 = llvm.mlir.undef : !llvm.array<1 x ptr<i8>>
    %27 = llvm.mlir.null : !llvm.ptr<i8>
    %28 = llvm.insertvalue %27, %26[0] : !llvm.array<1 x ptr<i8>>
    %29 = llvm.mlir.constant(1 : i64) : i64
    %30 = llvm.alloca %29 x !llvm.array<1 x ptr<i8>> : (i64) -> !llvm.ptr<array<1 x ptr<i8>>>
    llvm.store %28, %30 : !llvm.ptr<array<1 x ptr<i8>>>
    %31 = llvm.bitcast %30 : !llvm.ptr<array<1 x ptr<i8>>> to !llvm.ptr<ptr<i8>>
    %32 = llvm.mlir.constant(-1 : i64) : i64
    %33 = llvm.mlir.constant(1 : i64) : i64
    %34 = llvm.alloca %33 x !llvm.struct<(ptr<i8>, ptr<i8>, ptr<i8>)> : (i64) -> !llvm.ptr<struct<(ptr<i8>, ptr<i8>, ptr<i8>)>>
    llvm.call @dpcompGpuAlloc(%18, %23, %24, %25, %31, %32, %34) : (!llvm.ptr<i8>, i64, i64, i32, !llvm.ptr<ptr<i8>>, i64, !llvm.ptr<struct<(ptr<i8>, ptr<i8>, ptr<i8>)>>) -> ()
    %35 = llvm.load %34 : !llvm.ptr<struct<(ptr<i8>, ptr<i8>, ptr<i8>)>>
    %36 = llvm.extractvalue %35[0] : !llvm.struct<(ptr<i8>, ptr<i8>, ptr<i8>)>
    %37 = llvm.extractvalue %35[1] : !llvm.struct<(ptr<i8>, ptr<i8>, ptr<i8>)>
    %38 = llvm.mlir.undef : !llvm.struct<(ptr<i64>, ptr<i64>, i64, array<1 x i64>, array<1 x i64>)>
    %39 = llvm.bitcast %36 : !llvm.ptr<i8> to !llvm.ptr<i64>
    %40 = llvm.insertvalue %39, %38[0] : !llvm.struct<(ptr<i64>, ptr<i64>, i64, array<1 x i64>, array<1 x i64>)>
    %41 = llvm.bitcast %37 : !llvm.ptr<i8> to !llvm.ptr<i64>
    %42 = llvm.insertvalue %41, %40[1] : !llvm.struct<(ptr<i64>, ptr<i64>, i64, array<1 x i64>, array<1 x i64>)>
    %43 = llvm.mlir.constant(0 : i64) : i64
    %44 = llvm.insertvalue %43, %42[2] : !llvm.struct<(ptr<i64>, ptr<i64>, i64, array<1 x i64>, array<1 x i64>)>
    %45 = llvm.insertvalue %19, %44[3, 0] : !llvm.struct<(ptr<i64>, ptr<i64>, i64, array<1 x i64>, array<1 x i64>)>
    %46 = llvm.insertvalue %20, %45[4, 0] : !llvm.struct<(ptr<i64>, ptr<i64>, i64, array<1 x i64>, array<1 x i64>)>
    %47 = builtin.unrealized_conversion_cast %46 : !llvm.struct<(ptr<i64>, ptr<i64>, i64, array<1 x i64>, array<1 x i64>)> to memref<100xi64>
    %48 = llvm.mlir.addressof @gpu_blob : !llvm.ptr<array<440 x i8>>
    %49 = llvm.mlir.constant(0 : index) : i64
    %50 = llvm.getelementptr %48[%49, %49] : (!llvm.ptr<array<440 x i8>>, i64, i64) -> !llvm.ptr<i8>
    %51 = llvm.mlir.constant(440 : i64) : i64
    %52 = llvm.call @dpcompGpuModuleLoad(%18, %50, %51) : (!llvm.ptr<i8>, !llvm.ptr<i8>, i64) -> !llvm.ptr<i8>
    %53 = llvm.mlir.addressof @kernel_name : !llvm.ptr<array<17 x i8>>
    %54 = llvm.mlir.constant(0 : index) : i64
    %55 = llvm.getelementptr %53[%54, %54] : (!llvm.ptr<array<17 x i8>>, i64, i64) -> !llvm.ptr<i8>
    %56 = llvm.call @dpcompGpuKernelGet(%52, %55) : (!llvm.ptr<i8>, !llvm.ptr<i8>) -> !llvm.ptr<i8>
    %57 = llvm.mlir.undef : !llvm.array<1 x ptr<i8>>
    %58 = llvm.mlir.null : !llvm.ptr<i8>
    %59 = llvm.insertvalue %58, %57[0] : !llvm.array<1 x ptr<i8>>
    %60 = llvm.mlir.constant(1 : i64) : i64
    %61 = llvm.alloca %60 x !llvm.array<1 x ptr<i8>> : (i64) -> !llvm.ptr<array<1 x ptr<i8>>>
    llvm.store %59, %61 : !llvm.ptr<array<1 x ptr<i8>>>
    %62 = llvm.bitcast %61 : !llvm.ptr<array<1 x ptr<i8>>> to !llvm.ptr<ptr<i8>>
    %63 = llvm.mlir.constant(1 : i64) : i64
    %64 = llvm.alloca %63 x !llvm.ptr<i64> : (i64) -> !llvm.ptr<ptr<i64>>
    %65 = llvm.alloca %63 x !llvm.array<2 x struct<(ptr<i8>, i64)>> : (i64) -> !llvm.ptr<array<2 x struct<(ptr<i8>, i64)>>>
    %66 = llvm.mlir.undef : !llvm.array<2 x struct<(ptr<i8>, i64)>>
    %67 = llvm.mlir.constant(1 : i32) : i32
    %68 = llvm.extractvalue %46[1] : !llvm.struct<(ptr<i64>, ptr<i64>, i64, array<1 x i64>, array<1 x i64>)>
    llvm.store %68, %64 : !llvm.ptr<ptr<i64>>
    %69 = llvm.bitcast %64 : !llvm.ptr<ptr<i64>> to !llvm.ptr<i8>
    %70 = llvm.mlir.null : !llvm.ptr<ptr<i64>>
    %71 = llvm.getelementptr %70[%67] : (!llvm.ptr<ptr<i64>>, i32) -> !llvm.ptr<ptr<i64>>
    %72 = llvm.ptrtoint %71 : !llvm.ptr<ptr<i64>> to i64
    %73 = llvm.mlir.undef : !llvm.struct<(ptr<i8>, i64)>
    %74 = llvm.insertvalue %69, %73[0] : !llvm.struct<(ptr<i8>, i64)>
    %75 = llvm.insertvalue %72, %74[1] : !llvm.struct<(ptr<i8>, i64)>
    %76 = llvm.insertvalue %75, %66[0] : !llvm.array<2 x struct<(ptr<i8>, i64)>>
    %77 = llvm.mlir.null : !llvm.ptr<i8>
    %78 = llvm.mlir.constant(0 : i64) : i64
    %79 = llvm.mlir.undef : !llvm.struct<(ptr<i8>, i64)>
    %80 = llvm.insertvalue %77, %79[0] : !llvm.struct<(ptr<i8>, i64)>
    %81 = llvm.insertvalue %78, %80[1] : !llvm.struct<(ptr<i8>, i64)>
    %82 = llvm.insertvalue %81, %76[1] : !llvm.array<2 x struct<(ptr<i8>, i64)>>
    llvm.store %82, %65 : !llvm.ptr<array<2 x struct<(ptr<i8>, i64)>>>
    %83 = llvm.mlir.constant(-1 : i64) : i64
    %84 = llvm.bitcast %65 : !llvm.ptr<array<2 x struct<(ptr<i8>, i64)>>> to !llvm.ptr<struct<(ptr<i8>, i64)>>
    %85 = llvm.call @dpcompGpuLaunchKernel(%18, %56, %9, %12, %12, %12, %12, %12, %62, %84, %83) : (!llvm.ptr<i8>, !llvm.ptr<i8>, i64, i64, i64, i64, i64, i64, !llvm.ptr<ptr<i8>>, !llvm.ptr<struct<(ptr<i8>, i64)>>, i64) -> !llvm.ptr<i8>
    %86 = memref.alloc() : memref<i1>
    memref.store %16, %86[] : memref<i1>
    %87 = memref.alloc() : memref<i64>
    memref.store %15, %87[] : memref<i64>
    %88 = memref.alloc() : memref<i1>
    memref.copy %86, %88 : memref<i1> to memref<i1>
    %89 = memref.alloc() : memref<i64>
    %90 = builtin.unrealized_conversion_cast %89 : memref<i64> to !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
    memref.copy %87, %89 : memref<i64> to memref<i64>
    scf.for %arg5 = %14 to %8 step %11 {
      %91 = memref.load %6[%arg5] : memref<100xi1>
      %92 = memref.load %47[%arg5] : memref<100xi64>
      %93 = memref.load %88[] : memref<i1>
      %94 = memref.load %89[] : memref<i64>
      %95 = llvm.icmp "sgt" %91, %93 : i1
      %96 = llvm.icmp "sle" %91, %93 : i1
      %97 = llvm.and %95, %91  : i1
      %98 = llvm.and %96, %93  : i1
      %99 = llvm.or %97, %98  : i1
      %100 = llvm.icmp "eq" %91, %93 : i1
      %101 = llvm.icmp "slt" %92, %94 : i64
      %102 = llvm.and %100, %101  : i1
      %103 = llvm.or %95, %102  : i1
      %104 = llvm.select %103, %92, %94 : i1, i64
      memref.store %99, %88[] : memref<i1>
      memref.store %104, %89[] : memref<i64>
    }
    llvm.call @dpcompGpuStreamDestroy(%18) : (!llvm.ptr<i8>) -> ()
    llvm.return %90 : !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
  }
  llvm.func @_mlir_ciface_argmax.15(%arg0: !llvm.ptr<struct<(ptr<i64>, ptr<i64>, i64)>>, %arg1: !llvm.ptr<struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>>) attributes {sym_visibility = "private"} {
    %0 = llvm.load %arg1 : !llvm.ptr<struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>>
    %1 = llvm.extractvalue %0[0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %2 = llvm.extractvalue %0[1] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %3 = llvm.extractvalue %0[2] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %4 = llvm.extractvalue %0[3, 0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %5 = llvm.extractvalue %0[4, 0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %6 = llvm.call @argmax.15(%1, %2, %3, %4, %5) : (!llvm.ptr<i1>, !llvm.ptr<i1>, i64, i64, i64) -> !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
    llvm.store %6, %arg0 : !llvm.ptr<struct<(ptr<i64>, ptr<i64>, i64)>>
    llvm.return
  }
  llvm.func @main() {
    %0 = memref.get_global @__constant_100xi1 : memref<100xi1>
    %1 = builtin.unrealized_conversion_cast %0 : memref<100xi1> to !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %2 = llvm.extractvalue %1[0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %3 = llvm.extractvalue %1[1] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %4 = llvm.extractvalue %1[2] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %5 = llvm.extractvalue %1[3, 0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %6 = llvm.extractvalue %1[4, 0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %7 = llvm.call @foo(%2, %3, %4, %5, %6) : (!llvm.ptr<i1>, !llvm.ptr<i1>, i64, i64, i64) -> !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
    %8 = builtin.unrealized_conversion_cast %7 : !llvm.struct<(ptr<i64>, ptr<i64>, i64)> to memref<i64>
    %9 = memref.cast %8 : memref<i64> to memref<*xi64>
    %10 = builtin.unrealized_conversion_cast %9 : memref<*xi64> to !llvm.struct<(i64, ptr<i8>)>
    %11 = llvm.extractvalue %10[0] : !llvm.struct<(i64, ptr<i8>)>
    %12 = llvm.extractvalue %10[1] : !llvm.struct<(i64, ptr<i8>)>
    llvm.call @print_memref_i64(%11, %12) : (i64, !llvm.ptr<i8>) -> ()
    llvm.return
  }
  llvm.func @_mlir_ciface_main() {
    llvm.call @main() : () -> ()
    llvm.return
  }
  llvm.func @print_memref_i64(%arg0: i64, %arg1: !llvm.ptr<i8>) attributes {sym_visibility = "private"} {
    %0 = llvm.mlir.undef : !llvm.struct<(i64, ptr<i8>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(i64, ptr<i8>)>
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(i64, ptr<i8>)>
    %3 = llvm.mlir.constant(1 : index) : i64
    %4 = llvm.alloca %3 x !llvm.struct<(i64, ptr<i8>)> : (i64) -> !llvm.ptr<struct<(i64, ptr<i8>)>>
    llvm.store %2, %4 : !llvm.ptr<struct<(i64, ptr<i8>)>>
    llvm.call @_mlir_ciface_print_memref_i64(%4) : (!llvm.ptr<struct<(i64, ptr<i8>)>>) -> ()
    llvm.return
  }
  llvm.func @_mlir_ciface_print_memref_i64(!llvm.ptr<struct<(i64, ptr<i8>)>>) attributes {sym_visibility = "private"}
  llvm.func @dpcompGpuStreamCreate(i64) -> !llvm.ptr<i8>
  llvm.func @dpcompGpuAlloc(!llvm.ptr<i8>, i64, i64, i32, !llvm.ptr<ptr<i8>>, i64, !llvm.ptr<struct<(ptr<i8>, ptr<i8>, ptr<i8>)>>)
  llvm.func @dpcompGpuModuleLoad(!llvm.ptr<i8>, !llvm.ptr<i8>, i64) -> !llvm.ptr<i8>
  llvm.func @dpcompGpuKernelGet(!llvm.ptr<i8>, !llvm.ptr<i8>) -> !llvm.ptr<i8>
  llvm.func @dpcompGpuLaunchKernel(!llvm.ptr<i8>, !llvm.ptr<i8>, i64, i64, i64, i64, i64, i64, !llvm.ptr<ptr<i8>>, !llvm.ptr<struct<(ptr<i8>, i64)>>, i64) -> !llvm.ptr<i8>
  llvm.func @dpcompGpuStreamDestroy(!llvm.ptr<i8>)
}


// -----// IR Dump Before ReconcileUnrealizedCasts //----- //
module @jit__argmax.79 attributes {gpu.container_module, gpu.event_count = 0 : i64, llvm.data_layout = "", spv.target_env = #spv.target_env<#spv.vce<v1.0, [Addresses, Float16Buffer, Int64, Int16, Int8, Kernel, Linkage, Vector16, GenericPointer, Groups, Float16, Float64, AtomicFloat32AddEXT], [SPV_EXT_shader_atomic_float_add]>, {}>} {
  llvm.func @malloc(i64) -> !llvm.ptr<i8>
  llvm.mlir.global internal constant @kernel_name("argmax.15_kernel\00")
  llvm.mlir.global internal constant @gpu_blob("\03\02#\07\00\00\01\00\16\00\00\00\0F\00\00\00\00\00\00\00\11\00\02\00\0B\00\00\00\11\00\02\00\04\00\00\00\11\00\02\00\06\00\00\00\0E\00\03\00\02\00\00\00\02\00\00\00\0F\00\09\00\06\00\00\00\08\00\00\00argmax.15_kernel\00\00\00\00\04\00\00\00\10\00\06\00\08\00\00\00\11\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\05\00\09\00\04\00\00\00__builtin_var_WorkgroupId__\00\05\00\07\00\08\00\00\00argmax.15_kernel\00\00\00\00G\00\04\00\04\00\00\00\0B\00\00\00\1A\00\00\00\15\00\04\00\03\00\00\00@\00\00\00\00\00\00\00\17\00\04\00\02\00\00\00\03\00\00\00\03\00\00\00 \00\04\00\01\00\00\00\01\00\00\00\02\00\00\00;\00\04\00\01\00\00\00\04\00\00\00\01\00\00\00\13\00\02\00\06\00\00\00 \00\04\00\07\00\00\00\05\00\00\00\03\00\00\00!\00\04\00\05\00\00\00\06\00\00\00\07\00\00\006\00\05\00\06\00\00\00\08\00\00\00\00\00\00\00\05\00\00\007\00\03\00\07\00\00\00\09\00\00\00\F8\00\02\00\0A\00\00\00=\00\04\00\02\00\00\00\0B\00\00\00\04\00\00\00Q\00\05\00\03\00\00\00\0C\00\00\00\0B\00\00\00\00\00\00\00\F9\00\02\00\0D\00\00\00\F8\00\02\00\0D\00\00\00F\00\05\00\07\00\00\00\0E\00\00\00\09\00\00\00\0C\00\00\00>\00\05\00\0E\00\00\00\0C\00\00\00\02\00\00\00\08\00\00\00\FD\00\01\008\00\01\00")
  llvm.mlir.global private constant @__constant_100xi1(dense<true> : tensor<100xi1>) : !llvm.array<100 x i1>
  llvm.func @foo(%arg0: !llvm.ptr<i1>, %arg1: !llvm.ptr<i1>, %arg2: i64, %arg3: i64, %arg4: i64) -> !llvm.struct<(ptr<i64>, ptr<i64>, i64)> {
    %0 = llvm.mlir.undef : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %3 = llvm.insertvalue %arg2, %2[2] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %4 = llvm.insertvalue %arg3, %3[3, 0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %5 = llvm.insertvalue %arg4, %4[4, 0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %6 = llvm.extractvalue %5[0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %7 = llvm.extractvalue %5[1] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %8 = llvm.extractvalue %5[2] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %9 = llvm.extractvalue %5[3, 0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %10 = llvm.extractvalue %5[4, 0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %11 = llvm.call @argmax.15(%6, %7, %8, %9, %10) : (!llvm.ptr<i1>, !llvm.ptr<i1>, i64, i64, i64) -> !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
    llvm.return %11 : !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
  }
  llvm.func @_mlir_ciface_foo(%arg0: !llvm.ptr<struct<(ptr<i64>, ptr<i64>, i64)>>, %arg1: !llvm.ptr<struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>>) {
    %0 = llvm.load %arg1 : !llvm.ptr<struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>>
    %1 = llvm.extractvalue %0[0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %2 = llvm.extractvalue %0[1] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %3 = llvm.extractvalue %0[2] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %4 = llvm.extractvalue %0[3, 0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %5 = llvm.extractvalue %0[4, 0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %6 = llvm.call @foo(%1, %2, %3, %4, %5) : (!llvm.ptr<i1>, !llvm.ptr<i1>, i64, i64, i64) -> !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
    llvm.store %6, %arg0 : !llvm.ptr<struct<(ptr<i64>, ptr<i64>, i64)>>
    llvm.return
  }
  llvm.func @argmax.15(%arg0: !llvm.ptr<i1>, %arg1: !llvm.ptr<i1>, %arg2: i64, %arg3: i64, %arg4: i64) -> !llvm.struct<(ptr<i64>, ptr<i64>, i64)> attributes {sym_visibility = "private"} {
    %0 = llvm.mlir.undef : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %3 = llvm.insertvalue %arg2, %2[2] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %4 = llvm.insertvalue %arg3, %3[3, 0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %5 = llvm.insertvalue %arg4, %4[4, 0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %6 = builtin.unrealized_conversion_cast %5 : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)> to memref<100xi1>
    %7 = llvm.mlir.constant(100 : index) : i64
    %8 = builtin.unrealized_conversion_cast %7 : i64 to index
    %9 = builtin.unrealized_conversion_cast %8 : index to i64
    %10 = llvm.mlir.constant(1 : index) : i64
    %11 = builtin.unrealized_conversion_cast %10 : i64 to index
    %12 = builtin.unrealized_conversion_cast %11 : index to i64
    %13 = llvm.mlir.constant(0 : index) : i64
    %14 = builtin.unrealized_conversion_cast %13 : i64 to index
    %15 = llvm.mlir.constant(0 : i64) : i64
    %16 = llvm.mlir.constant(false) : i1
    %17 = llvm.mlir.constant(0 : i64) : i64
    %18 = llvm.call @dpcompGpuStreamCreate(%17) : (i64) -> !llvm.ptr<i8>
    %19 = llvm.mlir.constant(100 : index) : i64
    %20 = llvm.mlir.constant(1 : index) : i64
    %21 = llvm.mlir.null : !llvm.ptr<i64>
    %22 = llvm.getelementptr %21[%19] : (!llvm.ptr<i64>, i64) -> !llvm.ptr<i64>
    %23 = llvm.ptrtoint %22 : !llvm.ptr<i64> to i64
    %24 = llvm.mlir.constant(64 : i64) : i64
    %25 = llvm.mlir.constant(1 : i32) : i32
    %26 = llvm.mlir.undef : !llvm.array<1 x ptr<i8>>
    %27 = llvm.mlir.null : !llvm.ptr<i8>
    %28 = llvm.insertvalue %27, %26[0] : !llvm.array<1 x ptr<i8>>
    %29 = llvm.mlir.constant(1 : i64) : i64
    %30 = llvm.alloca %29 x !llvm.array<1 x ptr<i8>> : (i64) -> !llvm.ptr<array<1 x ptr<i8>>>
    llvm.store %28, %30 : !llvm.ptr<array<1 x ptr<i8>>>
    %31 = llvm.bitcast %30 : !llvm.ptr<array<1 x ptr<i8>>> to !llvm.ptr<ptr<i8>>
    %32 = llvm.mlir.constant(-1 : i64) : i64
    %33 = llvm.mlir.constant(1 : i64) : i64
    %34 = llvm.alloca %33 x !llvm.struct<(ptr<i8>, ptr<i8>, ptr<i8>)> : (i64) -> !llvm.ptr<struct<(ptr<i8>, ptr<i8>, ptr<i8>)>>
    llvm.call @dpcompGpuAlloc(%18, %23, %24, %25, %31, %32, %34) : (!llvm.ptr<i8>, i64, i64, i32, !llvm.ptr<ptr<i8>>, i64, !llvm.ptr<struct<(ptr<i8>, ptr<i8>, ptr<i8>)>>) -> ()
    %35 = llvm.load %34 : !llvm.ptr<struct<(ptr<i8>, ptr<i8>, ptr<i8>)>>
    %36 = llvm.extractvalue %35[0] : !llvm.struct<(ptr<i8>, ptr<i8>, ptr<i8>)>
    %37 = llvm.extractvalue %35[1] : !llvm.struct<(ptr<i8>, ptr<i8>, ptr<i8>)>
    %38 = llvm.mlir.undef : !llvm.struct<(ptr<i64>, ptr<i64>, i64, array<1 x i64>, array<1 x i64>)>
    %39 = llvm.bitcast %36 : !llvm.ptr<i8> to !llvm.ptr<i64>
    %40 = llvm.insertvalue %39, %38[0] : !llvm.struct<(ptr<i64>, ptr<i64>, i64, array<1 x i64>, array<1 x i64>)>
    %41 = llvm.bitcast %37 : !llvm.ptr<i8> to !llvm.ptr<i64>
    %42 = llvm.insertvalue %41, %40[1] : !llvm.struct<(ptr<i64>, ptr<i64>, i64, array<1 x i64>, array<1 x i64>)>
    %43 = llvm.mlir.constant(0 : i64) : i64
    %44 = llvm.insertvalue %43, %42[2] : !llvm.struct<(ptr<i64>, ptr<i64>, i64, array<1 x i64>, array<1 x i64>)>
    %45 = llvm.insertvalue %19, %44[3, 0] : !llvm.struct<(ptr<i64>, ptr<i64>, i64, array<1 x i64>, array<1 x i64>)>
    %46 = llvm.insertvalue %20, %45[4, 0] : !llvm.struct<(ptr<i64>, ptr<i64>, i64, array<1 x i64>, array<1 x i64>)>
    %47 = builtin.unrealized_conversion_cast %46 : !llvm.struct<(ptr<i64>, ptr<i64>, i64, array<1 x i64>, array<1 x i64>)> to memref<100xi64>
    %48 = llvm.mlir.addressof @gpu_blob : !llvm.ptr<array<440 x i8>>
    %49 = llvm.mlir.constant(0 : index) : i64
    %50 = llvm.getelementptr %48[%49, %49] : (!llvm.ptr<array<440 x i8>>, i64, i64) -> !llvm.ptr<i8>
    %51 = llvm.mlir.constant(440 : i64) : i64
    %52 = llvm.call @dpcompGpuModuleLoad(%18, %50, %51) : (!llvm.ptr<i8>, !llvm.ptr<i8>, i64) -> !llvm.ptr<i8>
    %53 = llvm.mlir.addressof @kernel_name : !llvm.ptr<array<17 x i8>>
    %54 = llvm.mlir.constant(0 : index) : i64
    %55 = llvm.getelementptr %53[%54, %54] : (!llvm.ptr<array<17 x i8>>, i64, i64) -> !llvm.ptr<i8>
    %56 = llvm.call @dpcompGpuKernelGet(%52, %55) : (!llvm.ptr<i8>, !llvm.ptr<i8>) -> !llvm.ptr<i8>
    %57 = llvm.mlir.undef : !llvm.array<1 x ptr<i8>>
    %58 = llvm.mlir.null : !llvm.ptr<i8>
    %59 = llvm.insertvalue %58, %57[0] : !llvm.array<1 x ptr<i8>>
    %60 = llvm.mlir.constant(1 : i64) : i64
    %61 = llvm.alloca %60 x !llvm.array<1 x ptr<i8>> : (i64) -> !llvm.ptr<array<1 x ptr<i8>>>
    llvm.store %59, %61 : !llvm.ptr<array<1 x ptr<i8>>>
    %62 = llvm.bitcast %61 : !llvm.ptr<array<1 x ptr<i8>>> to !llvm.ptr<ptr<i8>>
    %63 = llvm.mlir.constant(1 : i64) : i64
    %64 = llvm.alloca %63 x !llvm.ptr<i64> : (i64) -> !llvm.ptr<ptr<i64>>
    %65 = llvm.alloca %63 x !llvm.array<2 x struct<(ptr<i8>, i64)>> : (i64) -> !llvm.ptr<array<2 x struct<(ptr<i8>, i64)>>>
    %66 = llvm.mlir.undef : !llvm.array<2 x struct<(ptr<i8>, i64)>>
    %67 = llvm.mlir.constant(1 : i32) : i32
    %68 = llvm.extractvalue %46[1] : !llvm.struct<(ptr<i64>, ptr<i64>, i64, array<1 x i64>, array<1 x i64>)>
    llvm.store %68, %64 : !llvm.ptr<ptr<i64>>
    %69 = llvm.bitcast %64 : !llvm.ptr<ptr<i64>> to !llvm.ptr<i8>
    %70 = llvm.mlir.null : !llvm.ptr<ptr<i64>>
    %71 = llvm.getelementptr %70[%67] : (!llvm.ptr<ptr<i64>>, i32) -> !llvm.ptr<ptr<i64>>
    %72 = llvm.ptrtoint %71 : !llvm.ptr<ptr<i64>> to i64
    %73 = llvm.mlir.undef : !llvm.struct<(ptr<i8>, i64)>
    %74 = llvm.insertvalue %69, %73[0] : !llvm.struct<(ptr<i8>, i64)>
    %75 = llvm.insertvalue %72, %74[1] : !llvm.struct<(ptr<i8>, i64)>
    %76 = llvm.insertvalue %75, %66[0] : !llvm.array<2 x struct<(ptr<i8>, i64)>>
    %77 = llvm.mlir.null : !llvm.ptr<i8>
    %78 = llvm.mlir.constant(0 : i64) : i64
    %79 = llvm.mlir.undef : !llvm.struct<(ptr<i8>, i64)>
    %80 = llvm.insertvalue %77, %79[0] : !llvm.struct<(ptr<i8>, i64)>
    %81 = llvm.insertvalue %78, %80[1] : !llvm.struct<(ptr<i8>, i64)>
    %82 = llvm.insertvalue %81, %76[1] : !llvm.array<2 x struct<(ptr<i8>, i64)>>
    llvm.store %82, %65 : !llvm.ptr<array<2 x struct<(ptr<i8>, i64)>>>
    %83 = llvm.mlir.constant(-1 : i64) : i64
    %84 = llvm.bitcast %65 : !llvm.ptr<array<2 x struct<(ptr<i8>, i64)>>> to !llvm.ptr<struct<(ptr<i8>, i64)>>
    %85 = llvm.call @dpcompGpuLaunchKernel(%18, %56, %9, %12, %12, %12, %12, %12, %62, %84, %83) : (!llvm.ptr<i8>, !llvm.ptr<i8>, i64, i64, i64, i64, i64, i64, !llvm.ptr<ptr<i8>>, !llvm.ptr<struct<(ptr<i8>, i64)>>, i64) -> !llvm.ptr<i8>
    %86 = llvm.mlir.constant(1 : index) : i64
    %87 = llvm.mlir.null : !llvm.ptr<i1>
    %88 = llvm.getelementptr %87[%86] : (!llvm.ptr<i1>, i64) -> !llvm.ptr<i1>
    %89 = llvm.ptrtoint %88 : !llvm.ptr<i1> to i64
    %90 = llvm.call @malloc(%89) : (i64) -> !llvm.ptr<i8>
    %91 = llvm.bitcast %90 : !llvm.ptr<i8> to !llvm.ptr<i1>
    %92 = llvm.mlir.undef : !llvm.struct<(ptr<i1>, ptr<i1>, i64)>
    %93 = llvm.insertvalue %91, %92[0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64)>
    %94 = llvm.insertvalue %91, %93[1] : !llvm.struct<(ptr<i1>, ptr<i1>, i64)>
    %95 = llvm.mlir.constant(0 : index) : i64
    %96 = llvm.insertvalue %95, %94[2] : !llvm.struct<(ptr<i1>, ptr<i1>, i64)>
    %97 = llvm.extractvalue %96[1] : !llvm.struct<(ptr<i1>, ptr<i1>, i64)>
    llvm.store %16, %97 : !llvm.ptr<i1>
    %98 = llvm.mlir.constant(1 : index) : i64
    %99 = llvm.mlir.null : !llvm.ptr<i64>
    %100 = llvm.getelementptr %99[%98] : (!llvm.ptr<i64>, i64) -> !llvm.ptr<i64>
    %101 = llvm.ptrtoint %100 : !llvm.ptr<i64> to i64
    %102 = llvm.call @malloc(%101) : (i64) -> !llvm.ptr<i8>
    %103 = llvm.bitcast %102 : !llvm.ptr<i8> to !llvm.ptr<i64>
    %104 = llvm.mlir.undef : !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
    %105 = llvm.insertvalue %103, %104[0] : !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
    %106 = llvm.insertvalue %103, %105[1] : !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
    %107 = llvm.mlir.constant(0 : index) : i64
    %108 = llvm.insertvalue %107, %106[2] : !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
    %109 = llvm.extractvalue %108[1] : !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
    llvm.store %15, %109 : !llvm.ptr<i64>
    %110 = llvm.mlir.constant(1 : index) : i64
    %111 = llvm.mlir.null : !llvm.ptr<i1>
    %112 = llvm.getelementptr %111[%110] : (!llvm.ptr<i1>, i64) -> !llvm.ptr<i1>
    %113 = llvm.ptrtoint %112 : !llvm.ptr<i1> to i64
    %114 = llvm.call @malloc(%113) : (i64) -> !llvm.ptr<i8>
    %115 = llvm.bitcast %114 : !llvm.ptr<i8> to !llvm.ptr<i1>
    %116 = llvm.mlir.undef : !llvm.struct<(ptr<i1>, ptr<i1>, i64)>
    %117 = llvm.insertvalue %115, %116[0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64)>
    %118 = llvm.insertvalue %115, %117[1] : !llvm.struct<(ptr<i1>, ptr<i1>, i64)>
    %119 = llvm.mlir.constant(0 : index) : i64
    %120 = llvm.insertvalue %119, %118[2] : !llvm.struct<(ptr<i1>, ptr<i1>, i64)>
    %121 = llvm.mlir.constant(1 : index) : i64
    %122 = llvm.mlir.null : !llvm.ptr<i1>
    %123 = llvm.mlir.constant(1 : index) : i64
    %124 = llvm.getelementptr %122[%123] : (!llvm.ptr<i1>, i64) -> !llvm.ptr<i1>
    %125 = llvm.ptrtoint %124 : !llvm.ptr<i1> to i64
    %126 = llvm.mul %121, %125  : i64
    %127 = llvm.extractvalue %96[1] : !llvm.struct<(ptr<i1>, ptr<i1>, i64)>
    %128 = llvm.extractvalue %96[2] : !llvm.struct<(ptr<i1>, ptr<i1>, i64)>
    %129 = llvm.getelementptr %127[%128] : (!llvm.ptr<i1>, i64) -> !llvm.ptr<i1>
    %130 = llvm.extractvalue %120[1] : !llvm.struct<(ptr<i1>, ptr<i1>, i64)>
    %131 = llvm.extractvalue %120[2] : !llvm.struct<(ptr<i1>, ptr<i1>, i64)>
    %132 = llvm.getelementptr %130[%131] : (!llvm.ptr<i1>, i64) -> !llvm.ptr<i1>
    %133 = llvm.mlir.constant(false) : i1
    "llvm.intr.memcpy"(%132, %129, %126, %133) : (!llvm.ptr<i1>, !llvm.ptr<i1>, i64, i1) -> ()
    %134 = llvm.mlir.constant(1 : index) : i64
    %135 = llvm.mlir.null : !llvm.ptr<i64>
    %136 = llvm.getelementptr %135[%134] : (!llvm.ptr<i64>, i64) -> !llvm.ptr<i64>
    %137 = llvm.ptrtoint %136 : !llvm.ptr<i64> to i64
    %138 = llvm.call @malloc(%137) : (i64) -> !llvm.ptr<i8>
    %139 = llvm.bitcast %138 : !llvm.ptr<i8> to !llvm.ptr<i64>
    %140 = llvm.mlir.undef : !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
    %141 = llvm.insertvalue %139, %140[0] : !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
    %142 = llvm.insertvalue %139, %141[1] : !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
    %143 = llvm.mlir.constant(0 : index) : i64
    %144 = llvm.insertvalue %143, %142[2] : !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
    %145 = builtin.unrealized_conversion_cast %144 : !llvm.struct<(ptr<i64>, ptr<i64>, i64)> to memref<i64>
    %146 = builtin.unrealized_conversion_cast %145 : memref<i64> to !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
    %147 = llvm.mlir.constant(1 : index) : i64
    %148 = llvm.mlir.null : !llvm.ptr<i64>
    %149 = llvm.mlir.constant(1 : index) : i64
    %150 = llvm.getelementptr %148[%149] : (!llvm.ptr<i64>, i64) -> !llvm.ptr<i64>
    %151 = llvm.ptrtoint %150 : !llvm.ptr<i64> to i64
    %152 = llvm.mul %147, %151  : i64
    %153 = llvm.extractvalue %108[1] : !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
    %154 = llvm.extractvalue %108[2] : !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
    %155 = llvm.getelementptr %153[%154] : (!llvm.ptr<i64>, i64) -> !llvm.ptr<i64>
    %156 = llvm.extractvalue %144[1] : !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
    %157 = llvm.extractvalue %144[2] : !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
    %158 = llvm.getelementptr %156[%157] : (!llvm.ptr<i64>, i64) -> !llvm.ptr<i64>
    %159 = llvm.mlir.constant(false) : i1
    "llvm.intr.memcpy"(%158, %155, %152, %159) : (!llvm.ptr<i64>, !llvm.ptr<i64>, i64, i1) -> ()
    scf.for %arg5 = %14 to %8 step %11 {
      %160 = builtin.unrealized_conversion_cast %arg5 : index to i64
      %161 = llvm.extractvalue %5[1] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
      %162 = llvm.getelementptr %161[%160] : (!llvm.ptr<i1>, i64) -> !llvm.ptr<i1>
      %163 = llvm.load %162 : !llvm.ptr<i1>
      %164 = llvm.extractvalue %46[1] : !llvm.struct<(ptr<i64>, ptr<i64>, i64, array<1 x i64>, array<1 x i64>)>
      %165 = llvm.getelementptr %164[%160] : (!llvm.ptr<i64>, i64) -> !llvm.ptr<i64>
      %166 = llvm.load %165 : !llvm.ptr<i64>
      %167 = llvm.extractvalue %120[1] : !llvm.struct<(ptr<i1>, ptr<i1>, i64)>
      %168 = llvm.load %167 : !llvm.ptr<i1>
      %169 = llvm.extractvalue %144[1] : !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
      %170 = llvm.load %169 : !llvm.ptr<i64>
      %171 = llvm.icmp "sgt" %163, %168 : i1
      %172 = llvm.icmp "sle" %163, %168 : i1
      %173 = llvm.and %171, %163  : i1
      %174 = llvm.and %172, %168  : i1
      %175 = llvm.or %173, %174  : i1
      %176 = llvm.icmp "eq" %163, %168 : i1
      %177 = llvm.icmp "slt" %166, %170 : i64
      %178 = llvm.and %176, %177  : i1
      %179 = llvm.or %171, %178  : i1
      %180 = llvm.select %179, %166, %170 : i1, i64
      %181 = llvm.extractvalue %120[1] : !llvm.struct<(ptr<i1>, ptr<i1>, i64)>
      llvm.store %175, %181 : !llvm.ptr<i1>
      %182 = llvm.extractvalue %144[1] : !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
      llvm.store %180, %182 : !llvm.ptr<i64>
    }
    llvm.call @dpcompGpuStreamDestroy(%18) : (!llvm.ptr<i8>) -> ()
    llvm.return %146 : !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
  }
  llvm.func @_mlir_ciface_argmax.15(%arg0: !llvm.ptr<struct<(ptr<i64>, ptr<i64>, i64)>>, %arg1: !llvm.ptr<struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>>) attributes {sym_visibility = "private"} {
    %0 = llvm.load %arg1 : !llvm.ptr<struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>>
    %1 = llvm.extractvalue %0[0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %2 = llvm.extractvalue %0[1] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %3 = llvm.extractvalue %0[2] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %4 = llvm.extractvalue %0[3, 0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %5 = llvm.extractvalue %0[4, 0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %6 = llvm.call @argmax.15(%1, %2, %3, %4, %5) : (!llvm.ptr<i1>, !llvm.ptr<i1>, i64, i64, i64) -> !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
    llvm.store %6, %arg0 : !llvm.ptr<struct<(ptr<i64>, ptr<i64>, i64)>>
    llvm.return
  }
  llvm.func @main() {
    %0 = llvm.mlir.constant(100 : index) : i64
    %1 = llvm.mlir.constant(1 : index) : i64
    %2 = llvm.mlir.null : !llvm.ptr<i1>
    %3 = llvm.getelementptr %2[%0] : (!llvm.ptr<i1>, i64) -> !llvm.ptr<i1>
    %4 = llvm.ptrtoint %3 : !llvm.ptr<i1> to i64
    %5 = llvm.mlir.addressof @__constant_100xi1 : !llvm.ptr<array<100 x i1>>
    %6 = llvm.mlir.constant(0 : index) : i64
    %7 = llvm.getelementptr %5[%6, %6] : (!llvm.ptr<array<100 x i1>>, i64, i64) -> !llvm.ptr<i1>
    %8 = llvm.mlir.constant(3735928559 : index) : i64
    %9 = llvm.inttoptr %8 : i64 to !llvm.ptr<i1>
    %10 = llvm.mlir.undef : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %11 = llvm.insertvalue %9, %10[0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %12 = llvm.insertvalue %7, %11[1] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %13 = llvm.mlir.constant(0 : index) : i64
    %14 = llvm.insertvalue %13, %12[2] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %15 = llvm.insertvalue %0, %14[3, 0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %16 = llvm.insertvalue %1, %15[4, 0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %17 = builtin.unrealized_conversion_cast %16 : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)> to memref<100xi1>
    %18 = builtin.unrealized_conversion_cast %17 : memref<100xi1> to !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %19 = llvm.extractvalue %18[0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %20 = llvm.extractvalue %18[1] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %21 = llvm.extractvalue %18[2] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %22 = llvm.extractvalue %18[3, 0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %23 = llvm.extractvalue %18[4, 0] : !llvm.struct<(ptr<i1>, ptr<i1>, i64, array<1 x i64>, array<1 x i64>)>
    %24 = llvm.call @foo(%19, %20, %21, %22, %23) : (!llvm.ptr<i1>, !llvm.ptr<i1>, i64, i64, i64) -> !llvm.struct<(ptr<i64>, ptr<i64>, i64)>
    %25 = builtin.unrealized_conversion_cast %24 : !llvm.struct<(ptr<i64>, ptr<i64>, i64)> to memref<i64>
    %26 = llvm.mlir.constant(1 : index) : i64
    %27 = llvm.alloca %26 x !llvm.struct<(ptr<i64>, ptr<i64>, i64)> : (i64) -> !llvm.ptr<struct<(ptr<i64>, ptr<i64>, i64)>>
    llvm.store %24, %27 : !llvm.ptr<struct<(ptr<i64>, ptr<i64>, i64)>>
    %28 = llvm.bitcast %27 : !llvm.ptr<struct<(ptr<i64>, ptr<i64>, i64)>> to !llvm.ptr<i8>
    %29 = llvm.mlir.constant(0 : index) : i64
    %30 = llvm.mlir.undef : !llvm.struct<(i64, ptr<i8>)>
    %31 = llvm.insertvalue %29, %30[0] : !llvm.struct<(i64, ptr<i8>)>
    %32 = llvm.insertvalue %28, %31[1] : !llvm.struct<(i64, ptr<i8>)>
    %33 = builtin.unrealized_conversion_cast %32 : !llvm.struct<(i64, ptr<i8>)> to memref<*xi64>
    %34 = builtin.unrealized_conversion_cast %33 : memref<*xi64> to !llvm.struct<(i64, ptr<i8>)>
    %35 = llvm.extractvalue %34[0] : !llvm.struct<(i64, ptr<i8>)>
    %36 = llvm.extractvalue %34[1] : !llvm.struct<(i64, ptr<i8>)>
    llvm.call @print_memref_i64(%35, %36) : (i64, !llvm.ptr<i8>) -> ()
    llvm.return
  }
  llvm.func @_mlir_ciface_main() {
    llvm.call @main() : () -> ()
    llvm.return
  }
  llvm.func @print_memref_i64(%arg0: i64, %arg1: !llvm.ptr<i8>) attributes {sym_visibility = "private"} {
    %0 = llvm.mlir.undef : !llvm.struct<(i64, ptr<i8>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(i64, ptr<i8>)>
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(i64, ptr<i8>)>
    %3 = llvm.mlir.constant(1 : index) : i64
    %4 = llvm.alloca %3 x !llvm.struct<(i64, ptr<i8>)> : (i64) -> !llvm.ptr<struct<(i64, ptr<i8>)>>
    llvm.store %2, %4 : !llvm.ptr<struct<(i64, ptr<i8>)>>
    llvm.call @_mlir_ciface_print_memref_i64(%4) : (!llvm.ptr<struct<(i64, ptr<i8>)>>) -> ()
    llvm.return
  }
  llvm.func @_mlir_ciface_print_memref_i64(!llvm.ptr<struct<(i64, ptr<i8>)>>) attributes {sym_visibility = "private"}
  llvm.func @dpcompGpuStreamCreate(i64) -> !llvm.ptr<i8>
  llvm.func @dpcompGpuAlloc(!llvm.ptr<i8>, i64, i64, i32, !llvm.ptr<ptr<i8>>, i64, !llvm.ptr<struct<(ptr<i8>, ptr<i8>, ptr<i8>)>>)
  llvm.func @dpcompGpuModuleLoad(!llvm.ptr<i8>, !llvm.ptr<i8>, i64) -> !llvm.ptr<i8>
  llvm.func @dpcompGpuKernelGet(!llvm.ptr<i8>, !llvm.ptr<i8>) -> !llvm.ptr<i8>
  llvm.func @dpcompGpuLaunchKernel(!llvm.ptr<i8>, !llvm.ptr<i8>, i64, i64, i64, i64, i64, i64, !llvm.ptr<ptr<i8>>, !llvm.ptr<struct<(ptr<i8>, i64)>>, i64) -> !llvm.ptr<i8>
  llvm.func @dpcompGpuStreamDestroy(!llvm.ptr<i8>)
}


loc("/home/silee2/Projects/mlir-extensions/mlir/test/level_zero_runner/module_0145.jit__argmax.79.before_optimizations.txt.linalg.mlir":24:12): error: failed to legalize operation 'builtin.unrealized_conversion_cast' that was explicitly marked illegal
