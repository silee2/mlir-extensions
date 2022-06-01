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
    scf.for %arg1 = %c0 to %c100 step %c1 {
      %5 = arith.index_cast %arg1 : index to i64
      memref.store %5, %0[%arg1] : memref<100xi64>
    }
    memref.store %false, %1[] : memref<i1>
    memref.store %c0_i64, %2[] : memref<i64>
    memref.copy %1, %4 : memref<i1> to memref<i1>
    memref.dealloc %1 : memref<i1>
    memref.copy %2, %3 : memref<i64> to memref<i64>
    memref.dealloc %2 : memref<i64>
    scf.for %arg1 = %c0 to %c100 step %c1 {
      %5 = memref.load %arg0[%arg1] : memref<100xi1>
      %6 = memref.load %0[%arg1] : memref<100xi64>
      %7 = memref.load %4[] : memref<i1>
      %8 = memref.load %3[] : memref<i64>
      %9 = arith.cmpi sgt, %5, %7 : i1
      %10 = arith.select %9, %5, %7 : i1
      %11 = arith.cmpi eq, %5, %7 : i1
      %12 = arith.cmpi slt, %6, %8 : i64
      %13 = arith.andi %11, %12 : i1
      %14 = arith.ori %9, %13 : i1
      %15 = arith.select %14, %6, %8 : i64
      memref.store %10, %4[] : memref<i1>
      memref.store %15, %3[] : memref<i64>
    }
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

