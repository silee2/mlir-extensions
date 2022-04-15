#map0 = affine_map<(d0) -> (d0)>
#map1 = affine_map<(d0) -> ()>
#map2 = affine_map<() -> ()>
#map3 = affine_map<(d0) -> (0)>
module @jit__get_met_weights_singlegal.2 {
  func @foo(%arg0: tensor<f32>, %arg1: tensor<f32>, %arg2: tensor<23xf32>) -> tensor<22xf32> {
    %cst = arith.constant dense<0.000000e+00> : tensor<f32>
    %cst_0 = arith.constant dense<1.000000e+00> : tensor<f32>
    %0 = call @jit_triweighted_histogram.170(%arg0, %arg1, %arg2) : (tensor<f32>, tensor<f32>, tensor<23xf32>) -> tensor<22xf32>
    %cst_1 = arith.constant 0.000000e+00 : f32
    %1 = linalg.init_tensor [] : tensor<f32>
    %2 = linalg.fill(%cst_1, %1) : f32, tensor<f32> -> tensor<f32>
    %3 = linalg.generic {indexing_maps = [#map0, #map1], iterator_types = ["reduction"]} ins(%0 : tensor<22xf32>) outs(%2 : tensor<f32>) {
    ^bb0(%arg3: f32, %arg4: f32):
      %12 = arith.addf %arg3, %arg4 : f32
      linalg.yield %12 : f32
    } -> tensor<f32>
    %4 = linalg.init_tensor [] : tensor<i1>
    %5 = linalg.generic {indexing_maps = [#map2, #map2, #map2], iterator_types = []} ins(%3, %cst : tensor<f32>, tensor<f32>) outs(%4 : tensor<i1>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: i1):
      %12 = arith.cmpf oeq, %arg3, %arg4 : f32
      linalg.yield %12 : i1
    } -> tensor<i1>
    %6 = call @jit__where.184(%5, %cst_0, %3) : (tensor<i1>, tensor<f32>, tensor<f32>) -> tensor<f32>
    %7 = linalg.init_tensor [22] : tensor<22xf32>
    %8 = linalg.generic {indexing_maps = [#map1, #map0], iterator_types = ["parallel"]} ins(%6 : tensor<f32>) outs(%7 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32):
      linalg.yield %arg3 : f32
    } -> tensor<22xf32>
    %9 = linalg.init_tensor [22] : tensor<22xf32>
    %10 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%0, %8 : tensor<22xf32>, tensor<22xf32>) outs(%9 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %12 = arith.divf %arg3, %arg4 : f32
      linalg.yield %12 : f32
    } -> tensor<22xf32>
    %11 = call @jit__fill_empty_weights_singlegal.214(%arg0, %arg2, %10) : (tensor<f32>, tensor<23xf32>, tensor<22xf32>) -> tensor<22xf32>
    return %11 : tensor<22xf32>
  }
  func private @jit_triweighted_histogram.170(%arg0: tensor<f32>, %arg1: tensor<f32>, %arg2: tensor<23xf32>) -> tensor<22xf32> {
    %0 = tensor.extract_slice %arg2[0] [22] [1] : tensor<23xf32> to tensor<22xf32>
    %1 = tensor.extract_slice %arg2[1] [22] [1] : tensor<23xf32> to tensor<22xf32>
    %2 = call @jit__triweighted_histogram_kernel.164(%arg0, %arg1, %0, %1) : (tensor<f32>, tensor<f32>, tensor<22xf32>, tensor<22xf32>) -> tensor<22xf32>
    return %2 : tensor<22xf32>
  }
  func private @jit__triweighted_histogram_kernel.164(%arg0: tensor<f32>, %arg1: tensor<f32>, %arg2: tensor<22xf32>, %arg3: tensor<22xf32>) -> tensor<22xf32> {
    %0 = call @jit_vmap__triweighted_histogram_kernel_.156(%arg0, %arg1, %arg2, %arg3) : (tensor<f32>, tensor<f32>, tensor<22xf32>, tensor<22xf32>) -> tensor<22xf32>
    return %0 : tensor<22xf32>
  }
  func private @jit_vmap__triweighted_histogram_kernel_.156(%arg0: tensor<f32>, %arg1: tensor<f32>, %arg2: tensor<22xf32>, %arg3: tensor<22xf32>) -> tensor<22xf32> {
    %0 = call @jit_vmap__tw_cuml_kern_.31(%arg0, %arg2, %arg1) : (tensor<f32>, tensor<22xf32>, tensor<f32>) -> tensor<22xf32>
    %1 = call @jit_vmap__tw_cuml_kern__2.106(%arg0, %arg3, %arg1) : (tensor<f32>, tensor<22xf32>, tensor<f32>) -> tensor<22xf32>
    %2 = linalg.init_tensor [22] : tensor<22xf32>
    %3 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%0, %1 : tensor<22xf32>, tensor<22xf32>) outs(%2 : tensor<22xf32>) {
    ^bb0(%arg4: f32, %arg5: f32, %arg6: f32):
      %4 = arith.subf %arg4, %arg5 : f32
      linalg.yield %4 : f32
    } -> tensor<22xf32>
    return %3 : tensor<22xf32>
  }
  func private @jit_vmap__tw_cuml_kern_.31(%arg0: tensor<f32>, %arg1: tensor<22xf32>, %arg2: tensor<f32>) -> tensor<22xf32> {
    %cst = arith.constant dense<3.000000e+00> : tensor<22xf32>
    %cst_0 = arith.constant dense<1> : tensor<i32>
    %cst_1 = arith.constant dense<-3.000000e+00> : tensor<22xf32>
    %cst_2 = arith.constant dense<0> : tensor<i32>
    %cst_3 = arith.constant dense<-5.000000e+00> : tensor<22xf32>
    %cst_4 = arith.constant dense<6.998400e+04> : tensor<22xf32>
    %cst_5 = arith.constant dense<7.000000e+00> : tensor<22xf32>
    %cst_6 = arith.constant dense<2.592000e+03> : tensor<22xf32>
    %cst_7 = arith.constant dense<3.500000e+01> : tensor<22xf32>
    %cst_8 = arith.constant dense<8.640000e+02> : tensor<22xf32>
    %cst_9 = arith.constant dense<9.600000e+01> : tensor<22xf32>
    %cst_10 = arith.constant dense<5.000000e-01> : tensor<22xf32>
    %0 = linalg.init_tensor [22] : tensor<22xf32>
    %1 = linalg.generic {indexing_maps = [#map1, #map0], iterator_types = ["parallel"]} ins(%arg0 : tensor<f32>) outs(%0 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32):
      linalg.yield %arg3 : f32
    } -> tensor<22xf32>
    %2 = linalg.init_tensor [22] : tensor<22xf32>
    %3 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%1, %arg1 : tensor<22xf32>, tensor<22xf32>) outs(%2 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.subf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %4 = linalg.init_tensor [22] : tensor<22xf32>
    %5 = linalg.generic {indexing_maps = [#map1, #map0], iterator_types = ["parallel"]} ins(%arg2 : tensor<f32>) outs(%4 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32):
      linalg.yield %arg3 : f32
    } -> tensor<22xf32>
    %6 = linalg.init_tensor [22] : tensor<22xf32>
    %7 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%3, %5 : tensor<22xf32>, tensor<22xf32>) outs(%6 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.divf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %8 = linalg.init_tensor [22] : tensor<22xi1>
    %9 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%7, %cst : tensor<22xf32>, tensor<22xf32>) outs(%8 : tensor<22xi1>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: i1):
      %44 = arith.cmpf ogt, %arg3, %arg4 : f32
      linalg.yield %44 : i1
    } -> tensor<22xi1>
    %10 = linalg.init_tensor [22] : tensor<22xi1>
    %11 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%7, %cst_1 : tensor<22xf32>, tensor<22xf32>) outs(%10 : tensor<22xi1>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: i1):
      %44 = arith.cmpf olt, %arg3, %arg4 : f32
      linalg.yield %44 : i1
    } -> tensor<22xi1>
    %12 = call @integer_pow.6(%7) : (tensor<22xf32>) -> tensor<22xf32>
    %13 = linalg.init_tensor [22] : tensor<22xf32>
    %14 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%12, %cst_3 : tensor<22xf32>, tensor<22xf32>) outs(%13 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.mulf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %15 = linalg.init_tensor [22] : tensor<22xf32>
    %16 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%14, %cst_4 : tensor<22xf32>, tensor<22xf32>) outs(%15 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.divf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %17 = call @integer_pow_0.12(%7) : (tensor<22xf32>) -> tensor<22xf32>
    %18 = linalg.init_tensor [22] : tensor<22xf32>
    %19 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%17, %cst_5 : tensor<22xf32>, tensor<22xf32>) outs(%18 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.mulf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %20 = linalg.init_tensor [22] : tensor<22xf32>
    %21 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%19, %cst_6 : tensor<22xf32>, tensor<22xf32>) outs(%20 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.divf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %22 = linalg.init_tensor [22] : tensor<22xf32>
    %23 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%16, %21 : tensor<22xf32>, tensor<22xf32>) outs(%22 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.addf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %24 = linalg.init_tensor [22] : tensor<22xf32>
    %25 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%7, %7 : tensor<22xf32>, tensor<22xf32>) outs(%24 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.mulf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %26 = linalg.init_tensor [22] : tensor<22xf32>
    %27 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%7, %25 : tensor<22xf32>, tensor<22xf32>) outs(%26 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.mulf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %28 = linalg.init_tensor [22] : tensor<22xf32>
    %29 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%27, %cst_7 : tensor<22xf32>, tensor<22xf32>) outs(%28 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.mulf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %30 = linalg.init_tensor [22] : tensor<22xf32>
    %31 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%29, %cst_8 : tensor<22xf32>, tensor<22xf32>) outs(%30 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.divf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %32 = linalg.init_tensor [22] : tensor<22xf32>
    %33 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%23, %31 : tensor<22xf32>, tensor<22xf32>) outs(%32 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.subf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %34 = linalg.init_tensor [22] : tensor<22xf32>
    %35 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%7, %cst_7 : tensor<22xf32>, tensor<22xf32>) outs(%34 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.mulf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %36 = linalg.init_tensor [22] : tensor<22xf32>
    %37 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%35, %cst_9 : tensor<22xf32>, tensor<22xf32>) outs(%36 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.divf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %38 = linalg.init_tensor [22] : tensor<22xf32>
    %39 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%33, %37 : tensor<22xf32>, tensor<22xf32>) outs(%38 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.addf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %40 = linalg.init_tensor [22] : tensor<22xf32>
    %41 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%39, %cst_10 : tensor<22xf32>, tensor<22xf32>) outs(%40 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.addf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %42 = call @jit_vmap__where_.17(%11, %cst_2, %41) : (tensor<22xi1>, tensor<i32>, tensor<22xf32>) -> tensor<22xf32>
    %43 = call @jit_vmap__where__1.24(%9, %cst_0, %42) : (tensor<22xi1>, tensor<i32>, tensor<22xf32>) -> tensor<22xf32>
    return %43 : tensor<22xf32>
  }
  func private @integer_pow.6(%arg0: tensor<22xf32>) -> tensor<22xf32> {
    %0 = linalg.init_tensor [22] : tensor<22xf32>
    %1 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%arg0, %arg0 : tensor<22xf32>, tensor<22xf32>) outs(%0 : tensor<22xf32>) {
    ^bb0(%arg1: f32, %arg2: f32, %arg3: f32):
      %8 = arith.mulf %arg1, %arg2 : f32
      linalg.yield %8 : f32
    } -> tensor<22xf32>
    %2 = linalg.init_tensor [22] : tensor<22xf32>
    %3 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%arg0, %1 : tensor<22xf32>, tensor<22xf32>) outs(%2 : tensor<22xf32>) {
    ^bb0(%arg1: f32, %arg2: f32, %arg3: f32):
      %8 = arith.mulf %arg1, %arg2 : f32
      linalg.yield %8 : f32
    } -> tensor<22xf32>
    %4 = linalg.init_tensor [22] : tensor<22xf32>
    %5 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%1, %1 : tensor<22xf32>, tensor<22xf32>) outs(%4 : tensor<22xf32>) {
    ^bb0(%arg1: f32, %arg2: f32, %arg3: f32):
      %8 = arith.mulf %arg1, %arg2 : f32
      linalg.yield %8 : f32
    } -> tensor<22xf32>
    %6 = linalg.init_tensor [22] : tensor<22xf32>
    %7 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%3, %5 : tensor<22xf32>, tensor<22xf32>) outs(%6 : tensor<22xf32>) {
    ^bb0(%arg1: f32, %arg2: f32, %arg3: f32):
      %8 = arith.mulf %arg1, %arg2 : f32
      linalg.yield %8 : f32
    } -> tensor<22xf32>
    return %7 : tensor<22xf32>
  }
  func private @integer_pow_0.12(%arg0: tensor<22xf32>) -> tensor<22xf32> {
    %0 = linalg.init_tensor [22] : tensor<22xf32>
    %1 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%arg0, %arg0 : tensor<22xf32>, tensor<22xf32>) outs(%0 : tensor<22xf32>) {
    ^bb0(%arg1: f32, %arg2: f32, %arg3: f32):
      %6 = arith.mulf %arg1, %arg2 : f32
      linalg.yield %6 : f32
    } -> tensor<22xf32>
    %2 = linalg.init_tensor [22] : tensor<22xf32>
    %3 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%1, %1 : tensor<22xf32>, tensor<22xf32>) outs(%2 : tensor<22xf32>) {
    ^bb0(%arg1: f32, %arg2: f32, %arg3: f32):
      %6 = arith.mulf %arg1, %arg2 : f32
      linalg.yield %6 : f32
    } -> tensor<22xf32>
    %4 = linalg.init_tensor [22] : tensor<22xf32>
    %5 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%arg0, %3 : tensor<22xf32>, tensor<22xf32>) outs(%4 : tensor<22xf32>) {
    ^bb0(%arg1: f32, %arg2: f32, %arg3: f32):
      %6 = arith.mulf %arg1, %arg2 : f32
      linalg.yield %6 : f32
    } -> tensor<22xf32>
    return %5 : tensor<22xf32>
  }
  func private @jit_vmap__where_.17(%arg0: tensor<22xi1>, %arg1: tensor<i32>, %arg2: tensor<22xf32>) -> tensor<22xf32> {
    %0 = linalg.init_tensor [] : tensor<f32>
    %1 = linalg.generic {indexing_maps = [#map2, #map2], iterator_types = []} ins(%arg1 : tensor<i32>) outs(%0 : tensor<f32>) {
    ^bb0(%arg3: i32, %arg4: f32):
      %6 = arith.sitofp %arg3 : i32 to f32
      linalg.yield %6 : f32
    } -> tensor<f32>
    %2 = linalg.init_tensor [22] : tensor<22xf32>
    %3 = linalg.generic {indexing_maps = [#map1, #map0], iterator_types = ["parallel"]} ins(%1 : tensor<f32>) outs(%2 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32):
      linalg.yield %arg3 : f32
    } -> tensor<22xf32>
    %4 = linalg.init_tensor [22] : tensor<22xf32>
    %5 = linalg.generic {indexing_maps = [#map0, #map0, #map0, #map0], iterator_types = ["parallel"]} ins(%arg0, %3, %arg2 : tensor<22xi1>, tensor<22xf32>, tensor<22xf32>) outs(%4 : tensor<22xf32>) {
    ^bb0(%arg3: i1, %arg4: f32, %arg5: f32, %arg6: f32):
      %6 = arith.select %arg3, %arg4, %arg5 : f32
      linalg.yield %6 : f32
    } -> tensor<22xf32>
    return %5 : tensor<22xf32>
  }
  func private @jit_vmap__where__1.24(%arg0: tensor<22xi1>, %arg1: tensor<i32>, %arg2: tensor<22xf32>) -> tensor<22xf32> {
    %0 = linalg.init_tensor [] : tensor<f32>
    %1 = linalg.generic {indexing_maps = [#map2, #map2], iterator_types = []} ins(%arg1 : tensor<i32>) outs(%0 : tensor<f32>) {
    ^bb0(%arg3: i32, %arg4: f32):
      %6 = arith.sitofp %arg3 : i32 to f32
      linalg.yield %6 : f32
    } -> tensor<f32>
    %2 = linalg.init_tensor [22] : tensor<22xf32>
    %3 = linalg.generic {indexing_maps = [#map1, #map0], iterator_types = ["parallel"]} ins(%1 : tensor<f32>) outs(%2 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32):
      linalg.yield %arg3 : f32
    } -> tensor<22xf32>
    %4 = linalg.init_tensor [22] : tensor<22xf32>
    %5 = linalg.generic {indexing_maps = [#map0, #map0, #map0, #map0], iterator_types = ["parallel"]} ins(%arg0, %3, %arg2 : tensor<22xi1>, tensor<22xf32>, tensor<22xf32>) outs(%4 : tensor<22xf32>) {
    ^bb0(%arg3: i1, %arg4: f32, %arg5: f32, %arg6: f32):
      %6 = arith.select %arg3, %arg4, %arg5 : f32
      linalg.yield %6 : f32
    } -> tensor<22xf32>
    return %5 : tensor<22xf32>
  }
  func private @jit_vmap__tw_cuml_kern__2.106(%arg0: tensor<f32>, %arg1: tensor<22xf32>, %arg2: tensor<f32>) -> tensor<22xf32> {
    %cst = arith.constant dense<3.000000e+00> : tensor<22xf32>
    %cst_0 = arith.constant dense<1> : tensor<i32>
    %cst_1 = arith.constant dense<-3.000000e+00> : tensor<22xf32>
    %cst_2 = arith.constant dense<0> : tensor<i32>
    %cst_3 = arith.constant dense<-5.000000e+00> : tensor<22xf32>
    %cst_4 = arith.constant dense<6.998400e+04> : tensor<22xf32>
    %cst_5 = arith.constant dense<7.000000e+00> : tensor<22xf32>
    %cst_6 = arith.constant dense<2.592000e+03> : tensor<22xf32>
    %cst_7 = arith.constant dense<3.500000e+01> : tensor<22xf32>
    %cst_8 = arith.constant dense<8.640000e+02> : tensor<22xf32>
    %cst_9 = arith.constant dense<9.600000e+01> : tensor<22xf32>
    %cst_10 = arith.constant dense<5.000000e-01> : tensor<22xf32>
    %0 = linalg.init_tensor [22] : tensor<22xf32>
    %1 = linalg.generic {indexing_maps = [#map1, #map0], iterator_types = ["parallel"]} ins(%arg0 : tensor<f32>) outs(%0 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32):
      linalg.yield %arg3 : f32
    } -> tensor<22xf32>
    %2 = linalg.init_tensor [22] : tensor<22xf32>
    %3 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%1, %arg1 : tensor<22xf32>, tensor<22xf32>) outs(%2 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.subf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %4 = linalg.init_tensor [22] : tensor<22xf32>
    %5 = linalg.generic {indexing_maps = [#map1, #map0], iterator_types = ["parallel"]} ins(%arg2 : tensor<f32>) outs(%4 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32):
      linalg.yield %arg3 : f32
    } -> tensor<22xf32>
    %6 = linalg.init_tensor [22] : tensor<22xf32>
    %7 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%3, %5 : tensor<22xf32>, tensor<22xf32>) outs(%6 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.divf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %8 = linalg.init_tensor [22] : tensor<22xi1>
    %9 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%7, %cst : tensor<22xf32>, tensor<22xf32>) outs(%8 : tensor<22xi1>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: i1):
      %44 = arith.cmpf ogt, %arg3, %arg4 : f32
      linalg.yield %44 : i1
    } -> tensor<22xi1>
    %10 = linalg.init_tensor [22] : tensor<22xi1>
    %11 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%7, %cst_1 : tensor<22xf32>, tensor<22xf32>) outs(%10 : tensor<22xi1>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: i1):
      %44 = arith.cmpf olt, %arg3, %arg4 : f32
      linalg.yield %44 : i1
    } -> tensor<22xi1>
    %12 = call @integer_pow.81(%7) : (tensor<22xf32>) -> tensor<22xf32>
    %13 = linalg.init_tensor [22] : tensor<22xf32>
    %14 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%12, %cst_3 : tensor<22xf32>, tensor<22xf32>) outs(%13 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.mulf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %15 = linalg.init_tensor [22] : tensor<22xf32>
    %16 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%14, %cst_4 : tensor<22xf32>, tensor<22xf32>) outs(%15 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.divf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %17 = call @integer_pow_0.87(%7) : (tensor<22xf32>) -> tensor<22xf32>
    %18 = linalg.init_tensor [22] : tensor<22xf32>
    %19 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%17, %cst_5 : tensor<22xf32>, tensor<22xf32>) outs(%18 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.mulf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %20 = linalg.init_tensor [22] : tensor<22xf32>
    %21 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%19, %cst_6 : tensor<22xf32>, tensor<22xf32>) outs(%20 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.divf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %22 = linalg.init_tensor [22] : tensor<22xf32>
    %23 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%16, %21 : tensor<22xf32>, tensor<22xf32>) outs(%22 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.addf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %24 = linalg.init_tensor [22] : tensor<22xf32>
    %25 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%7, %7 : tensor<22xf32>, tensor<22xf32>) outs(%24 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.mulf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %26 = linalg.init_tensor [22] : tensor<22xf32>
    %27 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%7, %25 : tensor<22xf32>, tensor<22xf32>) outs(%26 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.mulf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %28 = linalg.init_tensor [22] : tensor<22xf32>
    %29 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%27, %cst_7 : tensor<22xf32>, tensor<22xf32>) outs(%28 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.mulf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %30 = linalg.init_tensor [22] : tensor<22xf32>
    %31 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%29, %cst_8 : tensor<22xf32>, tensor<22xf32>) outs(%30 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.divf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %32 = linalg.init_tensor [22] : tensor<22xf32>
    %33 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%23, %31 : tensor<22xf32>, tensor<22xf32>) outs(%32 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.subf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %34 = linalg.init_tensor [22] : tensor<22xf32>
    %35 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%7, %cst_7 : tensor<22xf32>, tensor<22xf32>) outs(%34 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.mulf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %36 = linalg.init_tensor [22] : tensor<22xf32>
    %37 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%35, %cst_9 : tensor<22xf32>, tensor<22xf32>) outs(%36 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.divf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %38 = linalg.init_tensor [22] : tensor<22xf32>
    %39 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%33, %37 : tensor<22xf32>, tensor<22xf32>) outs(%38 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.addf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %40 = linalg.init_tensor [22] : tensor<22xf32>
    %41 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%39, %cst_10 : tensor<22xf32>, tensor<22xf32>) outs(%40 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: f32):
      %44 = arith.addf %arg3, %arg4 : f32
      linalg.yield %44 : f32
    } -> tensor<22xf32>
    %42 = call @jit_vmap__where__3.92(%11, %cst_2, %41) : (tensor<22xi1>, tensor<i32>, tensor<22xf32>) -> tensor<22xf32>
    %43 = call @jit_vmap__where__4.99(%9, %cst_0, %42) : (tensor<22xi1>, tensor<i32>, tensor<22xf32>) -> tensor<22xf32>
    return %43 : tensor<22xf32>
  }
  func private @integer_pow.81(%arg0: tensor<22xf32>) -> tensor<22xf32> {
    %0 = linalg.init_tensor [22] : tensor<22xf32>
    %1 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%arg0, %arg0 : tensor<22xf32>, tensor<22xf32>) outs(%0 : tensor<22xf32>) {
    ^bb0(%arg1: f32, %arg2: f32, %arg3: f32):
      %8 = arith.mulf %arg1, %arg2 : f32
      linalg.yield %8 : f32
    } -> tensor<22xf32>
    %2 = linalg.init_tensor [22] : tensor<22xf32>
    %3 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%arg0, %1 : tensor<22xf32>, tensor<22xf32>) outs(%2 : tensor<22xf32>) {
    ^bb0(%arg1: f32, %arg2: f32, %arg3: f32):
      %8 = arith.mulf %arg1, %arg2 : f32
      linalg.yield %8 : f32
    } -> tensor<22xf32>
    %4 = linalg.init_tensor [22] : tensor<22xf32>
    %5 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%1, %1 : tensor<22xf32>, tensor<22xf32>) outs(%4 : tensor<22xf32>) {
    ^bb0(%arg1: f32, %arg2: f32, %arg3: f32):
      %8 = arith.mulf %arg1, %arg2 : f32
      linalg.yield %8 : f32
    } -> tensor<22xf32>
    %6 = linalg.init_tensor [22] : tensor<22xf32>
    %7 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%3, %5 : tensor<22xf32>, tensor<22xf32>) outs(%6 : tensor<22xf32>) {
    ^bb0(%arg1: f32, %arg2: f32, %arg3: f32):
      %8 = arith.mulf %arg1, %arg2 : f32
      linalg.yield %8 : f32
    } -> tensor<22xf32>
    return %7 : tensor<22xf32>
  }
  func private @integer_pow_0.87(%arg0: tensor<22xf32>) -> tensor<22xf32> {
    %0 = linalg.init_tensor [22] : tensor<22xf32>
    %1 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%arg0, %arg0 : tensor<22xf32>, tensor<22xf32>) outs(%0 : tensor<22xf32>) {
    ^bb0(%arg1: f32, %arg2: f32, %arg3: f32):
      %6 = arith.mulf %arg1, %arg2 : f32
      linalg.yield %6 : f32
    } -> tensor<22xf32>
    %2 = linalg.init_tensor [22] : tensor<22xf32>
    %3 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%1, %1 : tensor<22xf32>, tensor<22xf32>) outs(%2 : tensor<22xf32>) {
    ^bb0(%arg1: f32, %arg2: f32, %arg3: f32):
      %6 = arith.mulf %arg1, %arg2 : f32
      linalg.yield %6 : f32
    } -> tensor<22xf32>
    %4 = linalg.init_tensor [22] : tensor<22xf32>
    %5 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%arg0, %3 : tensor<22xf32>, tensor<22xf32>) outs(%4 : tensor<22xf32>) {
    ^bb0(%arg1: f32, %arg2: f32, %arg3: f32):
      %6 = arith.mulf %arg1, %arg2 : f32
      linalg.yield %6 : f32
    } -> tensor<22xf32>
    return %5 : tensor<22xf32>
  }
  func private @jit_vmap__where__3.92(%arg0: tensor<22xi1>, %arg1: tensor<i32>, %arg2: tensor<22xf32>) -> tensor<22xf32> {
    %0 = linalg.init_tensor [] : tensor<f32>
    %1 = linalg.generic {indexing_maps = [#map2, #map2], iterator_types = []} ins(%arg1 : tensor<i32>) outs(%0 : tensor<f32>) {
    ^bb0(%arg3: i32, %arg4: f32):
      %6 = arith.sitofp %arg3 : i32 to f32
      linalg.yield %6 : f32
    } -> tensor<f32>
    %2 = linalg.init_tensor [22] : tensor<22xf32>
    %3 = linalg.generic {indexing_maps = [#map1, #map0], iterator_types = ["parallel"]} ins(%1 : tensor<f32>) outs(%2 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32):
      linalg.yield %arg3 : f32
    } -> tensor<22xf32>
    %4 = linalg.init_tensor [22] : tensor<22xf32>
    %5 = linalg.generic {indexing_maps = [#map0, #map0, #map0, #map0], iterator_types = ["parallel"]} ins(%arg0, %3, %arg2 : tensor<22xi1>, tensor<22xf32>, tensor<22xf32>) outs(%4 : tensor<22xf32>) {
    ^bb0(%arg3: i1, %arg4: f32, %arg5: f32, %arg6: f32):
      %6 = arith.select %arg3, %arg4, %arg5 : f32
      linalg.yield %6 : f32
    } -> tensor<22xf32>
    return %5 : tensor<22xf32>
  }
  func private @jit_vmap__where__4.99(%arg0: tensor<22xi1>, %arg1: tensor<i32>, %arg2: tensor<22xf32>) -> tensor<22xf32> {
    %0 = linalg.init_tensor [] : tensor<f32>
    %1 = linalg.generic {indexing_maps = [#map2, #map2], iterator_types = []} ins(%arg1 : tensor<i32>) outs(%0 : tensor<f32>) {
    ^bb0(%arg3: i32, %arg4: f32):
      %6 = arith.sitofp %arg3 : i32 to f32
      linalg.yield %6 : f32
    } -> tensor<f32>
    %2 = linalg.init_tensor [22] : tensor<22xf32>
    %3 = linalg.generic {indexing_maps = [#map1, #map0], iterator_types = ["parallel"]} ins(%1 : tensor<f32>) outs(%2 : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: f32):
      linalg.yield %arg3 : f32
    } -> tensor<22xf32>
    %4 = linalg.init_tensor [22] : tensor<22xf32>
    %5 = linalg.generic {indexing_maps = [#map0, #map0, #map0, #map0], iterator_types = ["parallel"]} ins(%arg0, %3, %arg2 : tensor<22xi1>, tensor<22xf32>, tensor<22xf32>) outs(%4 : tensor<22xf32>) {
    ^bb0(%arg3: i1, %arg4: f32, %arg5: f32, %arg6: f32):
      %6 = arith.select %arg3, %arg4, %arg5 : f32
      linalg.yield %6 : f32
    } -> tensor<22xf32>
    return %5 : tensor<22xf32>
  }
  func private @jit__where.184(%arg0: tensor<i1>, %arg1: tensor<f32>, %arg2: tensor<f32>) -> tensor<f32> {
    %0 = linalg.init_tensor [] : tensor<f32>
    %1 = linalg.generic {indexing_maps = [#map2, #map2, #map2, #map2], iterator_types = []} ins(%arg0, %arg1, %arg2 : tensor<i1>, tensor<f32>, tensor<f32>) outs(%0 : tensor<f32>) {
    ^bb0(%arg3: i1, %arg4: f32, %arg5: f32, %arg6: f32):
      %2 = arith.select %arg3, %arg4, %arg5 : f32
      linalg.yield %2 : f32
    } -> tensor<f32>
    return %1 : tensor<f32>
  }
  func private @jit__fill_empty_weights_singlegal.214(%arg0: tensor<f32>, %arg1: tensor<23xf32>, %arg2: tensor<22xf32>) -> tensor<22xf32> {
    %cst = arith.constant dense<0.000000e+00> : tensor<22xf32>
    %cst_0 = arith.constant dense<true> : tensor<i1>
    %cst_1 = arith.constant dense<21> : tensor<1xi32>
    %cst_2 = arith.constant dense<1.000000e+00> : tensor<f32>
    %cst_3 = arith.constant dense<0> : tensor<1xi32>
    %0 = linalg.init_tensor [22] : tensor<22xi1>
    %1 = linalg.generic {indexing_maps = [#map0, #map0, #map0], iterator_types = ["parallel"]} ins(%arg2, %cst : tensor<22xf32>, tensor<22xf32>) outs(%0 : tensor<22xi1>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: i1):
      %21 = arith.cmpf oeq, %arg3, %arg4 : f32
      linalg.yield %21 : i1
    } -> tensor<22xi1>
    %true = arith.constant true
    %2 = linalg.init_tensor [] : tensor<i1>
    %3 = linalg.fill(%true, %2) : i1, tensor<i1> -> tensor<i1>
    %4 = linalg.generic {indexing_maps = [#map0, #map1], iterator_types = ["reduction"]} ins(%1 : tensor<22xi1>) outs(%3 : tensor<i1>) {
    ^bb0(%arg3: i1, %arg4: i1):
      %21 = arith.andi %arg3, %arg4 : i1
      linalg.yield %21 : i1
    } -> tensor<i1>
    %5 = tensor.extract_slice %arg1[22] [1] [1] : tensor<23xf32> to tensor<1xf32>
    %6 = tensor.collapse_shape %5 [] : tensor<1xf32> into tensor<f32>
    %7 = linalg.init_tensor [] : tensor<i1>
    %8 = linalg.generic {indexing_maps = [#map2, #map2, #map2], iterator_types = []} ins(%arg0, %6 : tensor<f32>, tensor<f32>) outs(%7 : tensor<i1>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: i1):
      %21 = arith.cmpf ogt, %arg3, %arg4 : f32
      linalg.yield %21 : i1
    } -> tensor<i1>
    %9 = linalg.init_tensor [] : tensor<i1>
    %10 = linalg.generic {indexing_maps = [#map2, #map2, #map2], iterator_types = []} ins(%4, %8 : tensor<i1>, tensor<i1>) outs(%9 : tensor<i1>) {
    ^bb0(%arg3: i1, %arg4: i1, %arg5: i1):
      %21 = arith.andi %arg3, %arg4 : i1
      linalg.yield %21 : i1
    } -> tensor<i1>
    %11 = linalg.generic {indexing_maps = [#map0, #map3, #map1, #map0], iterator_types = ["parallel"]} ins(%cst, %cst_1, %cst_2 : tensor<22xf32>, tensor<1xi32>, tensor<f32>) outs(%cst : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: i32, %arg5: f32, %arg6: f32):
      %21 = linalg.index 0 : index
      %22 = arith.index_cast %arg4 : i32 to index
      %23 = arith.cmpi eq, %21, %22 : index
      %24 = arith.select %23, %arg5, %arg6 : f32
      linalg.yield %24 : f32
    } -> tensor<22xf32>
    %12 = tensor.extract_slice %arg1[0] [1] [1] : tensor<23xf32> to tensor<1xf32>
    %13 = tensor.collapse_shape %12 [] : tensor<1xf32> into tensor<f32>
    %14 = linalg.init_tensor [] : tensor<i1>
    %15 = linalg.generic {indexing_maps = [#map2, #map2, #map2], iterator_types = []} ins(%arg0, %13 : tensor<f32>, tensor<f32>) outs(%14 : tensor<i1>) {
    ^bb0(%arg3: f32, %arg4: f32, %arg5: i1):
      %21 = arith.cmpf olt, %arg3, %arg4 : f32
      linalg.yield %21 : i1
    } -> tensor<i1>
    %16 = linalg.init_tensor [] : tensor<i1>
    %17 = linalg.generic {indexing_maps = [#map2, #map2, #map2], iterator_types = []} ins(%4, %15 : tensor<i1>, tensor<i1>) outs(%16 : tensor<i1>) {
    ^bb0(%arg3: i1, %arg4: i1, %arg5: i1):
      %21 = arith.andi %arg3, %arg4 : i1
      linalg.yield %21 : i1
    } -> tensor<i1>
    %18 = linalg.generic {indexing_maps = [#map0, #map3, #map1, #map0], iterator_types = ["parallel"]} ins(%cst, %cst_3, %cst_2 : tensor<22xf32>, tensor<1xi32>, tensor<f32>) outs(%cst : tensor<22xf32>) {
    ^bb0(%arg3: f32, %arg4: i32, %arg5: f32, %arg6: f32):
      %21 = linalg.index 0 : index
      %22 = arith.index_cast %arg4 : i32 to index
      %23 = arith.cmpi eq, %21, %22 : index
      %24 = arith.select %23, %arg5, %arg6 : f32
      linalg.yield %24 : f32
    } -> tensor<22xf32>
    %19 = call @jit__where_5.202(%17, %18, %arg2) : (tensor<i1>, tensor<22xf32>, tensor<22xf32>) -> tensor<22xf32>
    %20 = call @jit__where_6.208(%10, %11, %19) : (tensor<i1>, tensor<22xf32>, tensor<22xf32>) -> tensor<22xf32>
    return %20 : tensor<22xf32>
  }
  func private @jit__where_5.202(%arg0: tensor<i1>, %arg1: tensor<22xf32>, %arg2: tensor<22xf32>) -> tensor<22xf32> {
    %0 = linalg.init_tensor [22] : tensor<22xi1>
    %1 = linalg.generic {indexing_maps = [#map1, #map0], iterator_types = ["parallel"]} ins(%arg0 : tensor<i1>) outs(%0 : tensor<22xi1>) {
    ^bb0(%arg3: i1, %arg4: i1):
      linalg.yield %arg3 : i1
    } -> tensor<22xi1>
    %2 = linalg.init_tensor [22] : tensor<22xf32>
    %3 = linalg.generic {indexing_maps = [#map0, #map0, #map0, #map0], iterator_types = ["parallel"]} ins(%1, %arg1, %arg2 : tensor<22xi1>, tensor<22xf32>, tensor<22xf32>) outs(%2 : tensor<22xf32>) {
    ^bb0(%arg3: i1, %arg4: f32, %arg5: f32, %arg6: f32):
      %4 = arith.select %arg3, %arg4, %arg5 : f32
      linalg.yield %4 : f32
    } -> tensor<22xf32>
    return %3 : tensor<22xf32>
  }
  func private @jit__where_6.208(%arg0: tensor<i1>, %arg1: tensor<22xf32>, %arg2: tensor<22xf32>) -> tensor<22xf32> {
    %0 = linalg.init_tensor [22] : tensor<22xi1>
    %1 = linalg.generic {indexing_maps = [#map1, #map0], iterator_types = ["parallel"]} ins(%arg0 : tensor<i1>) outs(%0 : tensor<22xi1>) {
    ^bb0(%arg3: i1, %arg4: i1):
      linalg.yield %arg3 : i1
    } -> tensor<22xi1>
    %2 = linalg.init_tensor [22] : tensor<22xf32>
    %3 = linalg.generic {indexing_maps = [#map0, #map0, #map0, #map0], iterator_types = ["parallel"]} ins(%1, %arg1, %arg2 : tensor<22xi1>, tensor<22xf32>, tensor<22xf32>) outs(%2 : tensor<22xf32>) {
    ^bb0(%arg3: i1, %arg4: f32, %arg5: f32, %arg6: f32):
      %4 = arith.select %arg3, %arg4, %arg5 : f32
      linalg.yield %4 : f32
    } -> tensor<22xf32>
    return %3 : tensor<22xf32>
  }

  func @main() {
    %0 = arith.constant dense<1.000000e+00> : tensor<f32>
    %1 = arith.constant dense<1.000000e+00> : tensor<f32>
    %3 = arith.constant dense<1.000000e+00> : tensor<22xf32>
    %2 = call @foo(%0, %1, %3) : (tensor<f32>, tensor<f32>, tensor<23xf32>) -> tensor<22xf32>
    %unranked = tensor.cast %2 : tensor<22xf32> to tensor<*xf32>
    call @print_memref_f32(%unranked) : (tensor<*xf32>) -> ()
    return
  }

  func private @print_memref_f32(%ptr : tensor<*xf32>)
}

