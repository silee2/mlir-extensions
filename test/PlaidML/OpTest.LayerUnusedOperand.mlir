// RUN: %python_executable %imex_runner -i %s --pass-pipeline-file=%p/linalg-to-cpu.pp \
// RUN:                                        --runner mlir-cpu-runner -e main \
// RUN:                                        --shared-libs=%mlir_runner_utils \
// RUN:                                        --entry-point-result=void | FileCheck %s
// RUN: %gpu_skip || %python_executable %imex_runner -i %s --pass-pipeline-file=%p/linalg-to-llvm.pp \
// RUN:                                        --runner mlir-cpu-runner -e main \
// RUN:                                        --entry-point-result=void \
// RUN:                                        --shared-libs=%mlir_runner_utils,%levelzero_runtime | FileCheck %s

#map = affine_map<(d0, d1) -> (d0, d1)>
module @LayerUnusedOperand {
func.func @main() {
    %0 = arith.constant dense<2.5> : tensor<10x20xf32>
    %1 = arith.constant dense<1.5> : tensor<10x20xf32>
    %2 = arith.constant dense<3.0> : tensor<10x20xf32>
    %3 = call @test(%0, %1, %2) : (tensor<10x20xf32>, tensor<10x20xf32>, tensor<10x20xf32>) -> tensor<10x20xf32>
    %unranked = tensor.cast %3 : tensor<10x20xf32> to tensor<*xf32>
    call @printMemrefF32(%unranked) : (tensor<*xf32>) -> ()
    // CHECK: [5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5
    // CHECK-COUNT-8: 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5
    // CHECK: 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 5.5]
    return
}
func.func private @printMemrefF32(tensor<*xf32>)
func.func @test(%arg0: tensor<10x20xf32>, %arg1: tensor<10x20xf32> {stdx.const}, %arg2: tensor<10x20xf32> {stdx.const}) -> tensor<10x20xf32> {
    %0 = tensor.empty() : tensor<10x20xf32>
    %1 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%arg0, %arg2 : tensor<10x20xf32>, tensor<10x20xf32>) outs(%0 : tensor<10x20xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %2 = arith.addf %arg3, %arg4 : f32
      linalg.yield %2 : f32
    } -> tensor<10x20xf32>
    return %1 : tensor<10x20xf32>
  }
}
