module @jit__argmax.79 {
  memref.global "private" constant @__constant_100xi1 : memref<100xi1> = dense<[false, true, false, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false]>
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
    %0 = memref.alloc() {alignment = 128 : i64} : memref<100xi64>
    %1 = memref.alloc() {alignment = 128 : i64} : memref<i1>
    %2 = memref.alloc() {alignment = 128 : i64} : memref<i64>
    %3 = memref.alloc() {alignment = 128 : i64} : memref<i64>
    %4 = memref.alloc() {alignment = 128 : i64} : memref<i1>
    cf.br ^bb1(%c0 : index)
  ^bb1(%5: index):  // 2 preds: ^bb0, ^bb2
    %6 = arith.cmpi slt, %5, %c100 : index
    cf.cond_br %6, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %7 = arith.index_cast %5 : index to i64
    memref.store %7, %0[%5] : memref<100xi64>
    %8 = arith.addi %5, %c1 : index
    cf.br ^bb1(%8 : index)
  ^bb3:  // pred: ^bb1
    memref.store %false, %1[] : memref<i1>
    memref.store %c0_i64, %2[] : memref<i64>
    memref.copy %1, %4 : memref<i1> to memref<i1>
    memref.dealloc %1 : memref<i1>
    memref.copy %2, %3 : memref<i64> to memref<i64>
    memref.dealloc %2 : memref<i64>
    cf.br ^bb4(%c0 : index)
  ^bb4(%9: index):  // 2 preds: ^bb3, ^bb5
    %10 = arith.cmpi slt, %9, %c100 : index
    cf.cond_br %10, ^bb5, ^bb6
  ^bb5:  // pred: ^bb4
    %11 = memref.load %arg0[%9] : memref<100xi1>
    %12 = memref.load %0[%9] : memref<100xi64>
    %13 = memref.load %4[] : memref<i1>
    %14 = memref.load %3[] : memref<i64>
    %15 = arith.cmpi sgt, %11, %13 : i1
    %16 = arith.select %15, %11, %13 : i1
    %17 = arith.cmpi eq, %11, %13 : i1
    %18 = arith.cmpi slt, %12, %14 : i64
    %19 = arith.andi %17, %18 : i1
    %20 = arith.ori %15, %19 : i1
    %21 = arith.select %20, %12, %14 : i64
    memref.store %16, %4[] : memref<i1>
    memref.store %21, %3[] : memref<i64>
    %22 = arith.addi %9, %c1 : index
    cf.br ^bb4(%22 : index)
  ^bb6:  // pred: ^bb4
    memref.dealloc %4 : memref<i1>
    memref.dealloc %0 : memref<100xi64>
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

