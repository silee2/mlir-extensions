#map = affine_map<(d0) -> (d0)>
module @jit_real.59 {
  func @foo(%arg0: tensor<200xcomplex<f64>>) -> tensor<200xf64> {
    %0 = linalg.init_tensor [200] : tensor<200xf64>
    %1 = linalg.generic {indexing_maps = [#map, #map], iterator_types = ["parallel"]} ins(%arg0 : tensor<200xcomplex<f64>>) outs(%0 : tensor<200xf64>) {
    ^bb0(%arg1: complex<f64>, %arg2: f64):
      %2 = complex.re %arg1 : complex<f64>
      linalg.yield %2 : f64
    } -> tensor<200xf64>
    return %1 : tensor<200xf64>
  }

  func @main() {
    %0 = arith.constant dense<(1.000000e+00, 2.000000e+00)> : tensor<200xcomplex<f64>>
    %2 = call @foo(%0) : (tensor<200xcomplex<f64>>) -> tensor<200xf64>
    %unranked = tensor.cast %2 : tensor<200xf64> to tensor<*xf64>
    call @print_memref_f64(%unranked) : (tensor<*xf64>) -> ()
    return
  }

  func private @print_memref_f64(%ptr : tensor<*xf64>)
}

