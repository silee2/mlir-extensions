#map0 = affine_map<(d0, d1) -> (d0, d1)>
#map1 = affine_map<(d0, d1) -> (0)>
#map2 = affine_map<(d0, d1) -> (d0)>
module @jit_prim_fun.77 {
  func @foo(%arg0: tensor<100x2xcomplex<f64>>, %arg1: tensor<1xi32>, %arg2: tensor<100xcomplex<f64>>) -> tensor<100x2xcomplex<f64>> {
    %0 = linalg.generic {indexing_maps = [#map0, #map1, #map2, #map0], iterator_types = ["parallel", "parallel"]} ins(%arg0, %arg1, %arg2 : tensor<100x2xcomplex<f64>>, tensor<1xi32>, tensor<100xcomplex<f64>>) outs(%arg0 : tensor<100x2xcomplex<f64>>) {
    ^bb0(%arg3: complex<f64>, %arg4: i32, %arg5: complex<f64>, %arg6: complex<f64>):
      %1 = linalg.index 1 : index
      %2 = arith.index_cast %arg4 : i32 to index
      %3 = arith.cmpi eq, %1, %2 : index
      %4 = arith.select %3, %arg5, %arg6 : complex<f64>
      linalg.yield %4 : complex<f64>
    } -> tensor<100x2xcomplex<f64>>
    return %0 : tensor<100x2xcomplex<f64>>
  }

  func @main() {
    %0 = arith.constant dense<(1.000000e+00, 2.000000e+00)> : tensor<100x2xcomplex<f64>>
    %1 = arith.constant dense<1> : tensor<1xi32>
    %3 = arith.constant dense<(1.000000e+00, 2.000000e+00)> : tensor<100xcomplex<f64>>
    %2 = call @foo(%0, %1, %3) : (tensor<100x2xcomplex<f64>>, tensor<1xi32>, tensor<100xcomplex<f64>>) -> tensor<100x2xcomplex<f64>>
    //%unranked = tensor.cast %2 : tensor<200xf64> to tensor<*xf64>
    //call @print_memref_f64(%unranked) : (tensor<*xf64>) -> ()
    return
  }

  //func private @print_memref_f64(%ptr : tensor<*xf64>)
}

