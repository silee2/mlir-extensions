// RUN: %python_executable %imex_runner -i %s --pass-pipeline-file=%p/linalg-to-cpu.pp \
// RUN:                                       --runner mlir-cpu-runner -e main \
// RUN:                                       --shared-libs=%mlir_runner_utils \
// RUN:                                       --entry-point-result=void | FileCheck %s
// RUN: %python_executable %imex_runner --requires=l0-runtime -i %s --pass-pipeline-file=%p/linalg-to-llvm.pp \
// RUN:                                       --runner mlir-cpu-runner -e main \
// RUN:                                       --entry-point-result=void \
// RUN:                                       --shared-libs=%mlir_runner_utils,%levelzero_runtime | FileCheck %s
#map0 = affine_map<(d0, d1, d2) -> (d0, d1 floordiv 3, d2)>
#map1 = affine_map<(d0, d1, d2) -> (d0, d1, d2)>
module @repeat_elts {
  func.func @main() {
    %0= arith.constant dense<[[[7., 3., 5., 4., 2., 0., 5., 2., 3., 7.], [2., 4., 2., 5., 0., 1., 0., 0., 0., 4.],
                               [3., 3., 7., 5., 0., 2., 0., 3., 5., 0.], [0., 6., 1., 7., 1., 2., 5., 0., 4., 4.],
                               [6., 2., 2., 4., 2., 7., 3., 4., 6., 6.], [2., 5., 0., 6., 0., 0., 1., 5., 1., 2.],
                               [0., 5., 1., 4., 1., 3., 5., 2., 7., 5.], [0., 7., 5., 2., 4., 4., 2., 1., 2., 4.],
                               [3., 2., 5., 7., 6., 4., 2., 6., 0., 3.], [1., 2., 1., 1., 2., 3., 0., 4., 4., 4.]],
                              [[7., 5., 7., 1., 5., 7., 0., 2., 3., 2.], [6., 2., 1., 3., 1., 4., 1., 6., 1., 5.],
                               [2., 4., 4., 4., 1., 7., 6., 2., 1., 6.], [1., 0., 3., 6., 4., 4., 0., 0., 3., 6.],
                               [6., 0., 7., 2., 7., 3., 4., 6., 5., 4.], [5., 3., 2., 2., 7., 0., 7., 1., 3., 0.],
                               [1., 3., 1., 3., 6., 7., 5., 5., 7., 2.], [2., 5., 0., 7., 1., 0., 3., 5., 7., 3.],
                               [3., 0., 7., 3., 4., 0., 0., 6., 6., 7.], [0., 7., 0., 5., 5., 0., 6., 2., 0., 7.]],
                              [[3., 1., 6., 2., 0., 3., 3., 3., 7., 4.], [6., 2., 2., 1., 1., 1., 4., 6., 4., 1.],
                               [0., 0., 1., 7., 0., 0., 3., 3., 1., 3.], [6., 1., 3., 1., 6., 5., 1., 4., 7., 2.],
                               [0., 4., 1., 6., 5., 7., 5., 7., 1., 4.], [1., 4., 1., 1., 7., 6., 6., 4., 4., 6.],
                               [4., 6., 4., 0., 2., 0., 3., 0., 6., 3.], [1., 6., 1., 6., 6., 6., 0., 1., 0., 7.],
                               [5., 3., 2., 0., 0., 0., 2., 5., 0., 7.], [6., 2., 4., 0., 0., 0., 3., 0., 1., 0.]],
                              [[2., 0., 5., 3., 0., 1., 4., 6., 2., 4.], [4., 7., 1., 2., 7., 5., 4., 7., 2., 0.],
                               [0., 1., 0., 0., 5., 1., 6., 1., 5., 5.], [4., 6., 4., 7., 5., 2., 6., 7., 1., 3.],
                               [4., 3., 6., 2., 3., 5., 0., 6., 2., 4.], [5., 1., 1., 6., 7., 0., 6., 5., 2., 2.],
                               [5., 7., 1., 2., 5., 5., 0., 2., 4., 5.], [0., 5., 6., 3., 0., 4., 5., 1., 4., 4.],
                               [0., 3., 4., 0., 5., 1., 7., 2., 0., 4.], [6., 0., 3., 5., 5., 7., 6., 1., 2., 5.]],
                              [[6., 3., 3., 1., 2., 6., 5., 4., 3., 7.], [3., 1., 0., 3., 3., 7., 0., 5., 1., 1.],
                               [3., 4., 4., 3., 0., 6., 6., 4., 3., 4.], [2., 0., 2., 2., 4., 4., 4., 0., 6., 5.],
                               [2., 6., 6., 4., 1., 7., 1., 4., 5., 1.], [4., 0., 6., 6., 1., 5., 6., 4., 3., 4.],
                               [1., 4., 5., 2., 2., 5., 7., 2., 2., 0.], [1., 4., 2., 0., 7., 2., 4., 0., 4., 7.],
                               [1., 5., 3., 1., 4., 1., 4., 2., 5., 3.], [4., 6., 2., 1., 7., 4., 1., 1., 2., 5.]],
                              [[6., 7., 0., 4., 5., 0., 0., 6., 6., 0.], [4., 2., 5., 4., 7., 3., 4., 5., 5., 4.],
                               [6., 5., 5., 5., 4., 6., 1., 5., 2., 5.], [4., 2., 5., 0., 5., 5., 4., 7., 7., 6.],
                               [2., 4., 3., 6., 5., 2., 4., 2., 1., 7.], [1., 1., 4., 0., 7., 5., 6., 6., 1., 5.],
                               [0., 1., 0., 1., 0., 4., 6., 1., 0., 7.], [5., 3., 4., 3., 2., 0., 3., 6., 5., 0.],
                               [1., 0., 6., 2., 0., 2., 1., 1., 2., 6.], [1., 2., 1., 1., 0., 2., 6., 1., 1., 7.]],
                              [[5., 3., 3., 3., 1., 7., 2., 4., 0., 1.], [7., 4., 1., 2., 5., 3., 3., 6., 1., 4.],
                               [5., 4., 1., 3., 7., 6., 6., 7., 5., 1.], [4., 6., 7., 2., 2., 3., 2., 3., 5., 3.],
                               [0., 6., 7., 1., 5., 7., 0., 7., 4., 5.], [4., 0., 6., 0., 2., 1., 7., 0., 2., 6.],
                               [1., 1., 5., 3., 1., 4., 3., 7., 1., 7.], [6., 6., 0., 6., 6., 5., 6., 3., 4., 2.],
                               [0., 6., 0., 6., 2., 1., 4., 2., 3., 1.], [1., 6., 7., 1., 3., 4., 7., 7., 0., 1.]],
                              [[6., 7., 5., 5., 6., 4., 0., 5., 7., 6.], [6., 3., 7., 1., 3., 3., 6., 0., 6., 3.],
                               [7., 0., 7., 5., 1., 4., 3., 7., 7., 6.], [6., 3., 3., 1., 6., 4., 1., 1., 5., 6.],
                               [0., 0., 5., 7., 7., 4., 2., 4., 1., 2.], [0., 3., 0., 1., 5., 0., 0., 6., 4., 7.],
                               [0., 7., 2., 3., 4., 6., 3., 3., 2., 6.], [3., 3., 7., 4., 7., 6., 3., 3., 4., 6.],
                               [6., 5., 5., 0., 1., 3., 1., 2., 2., 5.], [4., 7., 6., 3., 3., 4., 3., 7., 6., 2.]],
                              [[2., 6., 2., 5., 7., 6., 6., 2., 6., 4.], [0., 2., 7., 6., 7., 0., 7., 5., 0., 4.],
                               [7., 1., 5., 6., 1., 7., 4., 0., 2., 4.], [6., 0., 6., 6., 4., 6., 1., 0., 6., 3.],
                               [6., 1., 5., 3., 7., 5., 3., 3., 0., 7.], [3., 1., 3., 4., 1., 3., 7., 4., 4., 4.],
                               [5., 0., 7., 7., 0., 6., 2., 0., 2., 3.], [2., 3., 6., 7., 6., 7., 5., 7., 6., 7.],
                               [6., 4., 4., 3., 1., 5., 5., 5., 5., 3.], [2., 2., 6., 2., 0., 5., 6., 0., 0., 0.]],
                              [[7., 7., 7., 6., 6., 0., 3., 2., 2., 6.], [1., 5., 0., 2., 6., 2., 1., 2., 0., 4.],
                               [0., 7., 1., 6., 2., 4., 5., 3., 6., 7.], [3., 3., 2., 3., 0., 7., 3., 3., 3., 5.],
                               [6., 4., 5., 0., 2., 6., 0., 2., 0., 2.], [5., 1., 5., 2., 7., 6., 2., 4., 1., 2.],
                               [4., 7., 4., 0., 7., 6., 1., 4., 0., 0.], [4., 4., 4., 5., 1., 0., 5., 4., 1., 5.],
                               [2., 5., 0., 6., 2., 1., 6., 5., 1., 6.], [2., 2., 4., 4., 3., 4., 3., 1., 7., 3.]]]>:tensor<10x10x10xf32>
    %1 = call @test(%0) : (tensor<10x10x10xf32>) -> tensor<10x30x10xf32>
    %unranked = tensor.cast %1 : tensor<10x30x10xf32>to tensor<*xf32>
    call @printMemrefF32(%unranked) : (tensor<*xf32>) -> ()
    return
  }
  func.func private @printMemrefF32(tensor<*xf32>)
  func.func @test(%arg0: tensor<10x10x10xf32>) -> tensor<10x30x10xf32> {
    %cst = arith.constant 0.000000e+00 : f32
    %0 = tensor.empty() : tensor<10x30x10xf32>
    %1 = linalg.fill ins(%cst : f32) outs(%0 : tensor<10x30x10xf32>) -> tensor<10x30x10xf32>
    %2 = linalg.generic {indexing_maps = [#map0, #map1], iterator_types = ["parallel", "parallel", "parallel"]} ins(%arg0 : tensor<10x10x10xf32>) outs(%1 : tensor<10x30x10xf32>) attrs =  {iterator_ranges = [10, 30, 10]} {
    ^bb0(%arg1: f32, %arg2: f32):
      linalg.yield %arg1 : f32
    } -> tensor<10x30x10xf32>
    return %2 : tensor<10x30x10xf32>
  }
}
// CHECK: Unranked Memref base@ = {{0x[-9a-f]*}}
// CHECK-SAME: rank = {{.}} offset = {{.}} sizes = [10, 30, 10] strides = [300, 10, 1] data =
// CHECK: [7, 3, 5, 4, 2, 0, 5, 2, 3, 7]
// CHECK: [7, 3, 5, 4, 2, 0, 5, 2, 3, 7]
// CHECK: [7, 3, 5, 4, 2, 0, 5, 2, 3, 7]
// CHECK: [2, 4, 2, 5, 0, 1, 0, 0, 0, 4]
// CHECK: [2, 4, 2, 5, 0, 1, 0, 0, 0, 4]
// CHECK: [2, 4, 2, 5, 0, 1, 0, 0, 0, 4]
// CHECK: [3, 3, 7, 5, 0, 2, 0, 3, 5, 0]
// CHECK: [3, 3, 7, 5, 0, 2, 0, 3, 5, 0]
// CHECK: [3, 3, 7, 5, 0, 2, 0, 3, 5, 0]
