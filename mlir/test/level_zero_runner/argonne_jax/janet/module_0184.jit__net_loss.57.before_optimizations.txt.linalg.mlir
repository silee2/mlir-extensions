#map0 = affine_map<(d0, d1) -> (d1)>
#map1 = affine_map<(d0, d1) -> (d0, d1)>
#map2 = affine_map<(d0, d1) -> ()>
#map3 = affine_map<() -> ()>
module @jit__net_loss.57 {
  func @foo(%arg0: tensor<13x13xf32>, %arg1: tensor<13xf32>, %arg2: tensor<13x32xf32>, %arg3: tensor<32xf32>, %arg4: tensor<32x16xf32>, %arg5: tensor<16xf32>, %arg6: tensor<16x8xf32>, %arg7: tensor<8xf32>, %arg8: tensor<8x4xf32>, %arg9: tensor<4xf32>, %arg10: tensor<4x6xf32>, %arg11: tensor<6xf32>, %arg12: tensor<2x13xf32>, %arg13: tensor<2x6xf32>) -> tensor<f32> {
    %cst = arith.constant dense<0.000000e+00> : tensor<2x13xf32>
    %cst_0 = arith.constant dense<0.000000e+00> : tensor<f32>
    %cst_1 = arith.constant dense<1.67326319> : tensor<2x13xf32>
    %cst_2 = arith.constant dense<1.05070102> : tensor<2x13xf32>
    %cst_3 = arith.constant dense<0.000000e+00> : tensor<2x32xf32>
    %cst_4 = arith.constant dense<1.67326319> : tensor<2x32xf32>
    %cst_5 = arith.constant dense<1.05070102> : tensor<2x32xf32>
    %cst_6 = arith.constant dense<0.000000e+00> : tensor<2x16xf32>
    %cst_7 = arith.constant dense<1.67326319> : tensor<2x16xf32>
    %cst_8 = arith.constant dense<1.05070102> : tensor<2x16xf32>
    %cst_9 = arith.constant dense<0.000000e+00> : tensor<2x8xf32>
    %cst_10 = arith.constant dense<1.67326319> : tensor<2x8xf32>
    %cst_11 = arith.constant dense<1.05070102> : tensor<2x8xf32>
    %cst_12 = arith.constant dense<0.000000e+00> : tensor<2x4xf32>
    %cst_13 = arith.constant dense<1.67326319> : tensor<2x4xf32>
    %cst_14 = arith.constant dense<1.05070102> : tensor<2x4xf32>
    %cst_15 = arith.constant 0.000000e+00 : f32
    %0 = linalg.init_tensor [2, 13] : tensor<2x13xf32>
    %1 = linalg.fill(%cst_15, %0) : f32, tensor<2x13xf32> -> tensor<2x13xf32>
    %2 = linalg.matmul ins(%arg12, %arg0 : tensor<2x13xf32>, tensor<13x13xf32>) outs(%1 : tensor<2x13xf32>) -> tensor<2x13xf32>
    %3 = linalg.init_tensor [2, 13] : tensor<2x13xf32>
    %4 = linalg.generic {indexing_maps = [#map0, #map1], iterator_types = ["parallel", "parallel"]} ins(%arg1 : tensor<13xf32>) outs(%3 : tensor<2x13xf32>) {
    ^bb0(%arg14: f32, %arg15: f32):
      linalg.yield %arg14 : f32
    } -> tensor<2x13xf32>
    %5 = linalg.init_tensor [2, 13] : tensor<2x13xf32>
    %6 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%2, %4 : tensor<2x13xf32>, tensor<2x13xf32>) outs(%5 : tensor<2x13xf32>) {
    ^bb0(%arg14: f32, %arg15: f32, %arg16: f32):
      %103 = arith.addf %arg14, %arg15 : f32
      linalg.yield %103 : f32
    } -> tensor<2x13xf32>
    %7 = linalg.init_tensor [2, 13] : tensor<2x13xi1>
    %8 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%6, %cst : tensor<2x13xf32>, tensor<2x13xf32>) outs(%7 : tensor<2x13xi1>) {
    ^bb0(%arg14: f32, %arg15: f32, %arg16: i1):
      %103 = arith.cmpf ogt, %arg14, %arg15 : f32
      linalg.yield %103 : i1
    } -> tensor<2x13xi1>
    %9 = linalg.init_tensor [2, 13] : tensor<2x13xi1>
    %10 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%6, %cst : tensor<2x13xf32>, tensor<2x13xf32>) outs(%9 : tensor<2x13xi1>) {
    ^bb0(%arg14: f32, %arg15: f32, %arg16: i1):
      %103 = arith.cmpf ogt, %arg14, %arg15 : f32
      linalg.yield %103 : i1
    } -> tensor<2x13xi1>
    %11 = call @jit__where.53(%10, %cst_0, %6) : (tensor<2x13xi1>, tensor<f32>, tensor<2x13xf32>) -> tensor<2x13xf32>
    %12 = linalg.init_tensor [2, 13] : tensor<2x13xf32>
    %13 = linalg.generic {indexing_maps = [#map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%11 : tensor<2x13xf32>) outs(%12 : tensor<2x13xf32>) {
    ^bb0(%arg14: f32, %arg15: f32):
      %103 = math.expm1 %arg14 : f32
      linalg.yield %103 : f32
    } -> tensor<2x13xf32>
    %14 = linalg.init_tensor [2, 13] : tensor<2x13xf32>
    %15 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%13, %cst_1 : tensor<2x13xf32>, tensor<2x13xf32>) outs(%14 : tensor<2x13xf32>) {
    ^bb0(%arg14: f32, %arg15: f32, %arg16: f32):
      %103 = arith.mulf %arg14, %arg15 : f32
      linalg.yield %103 : f32
    } -> tensor<2x13xf32>
    %16 = call @jit__where_0.63(%8, %6, %15) : (tensor<2x13xi1>, tensor<2x13xf32>, tensor<2x13xf32>) -> tensor<2x13xf32>
    %17 = linalg.init_tensor [2, 13] : tensor<2x13xf32>
    %18 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%16, %cst_2 : tensor<2x13xf32>, tensor<2x13xf32>) outs(%17 : tensor<2x13xf32>) {
    ^bb0(%arg14: f32, %arg15: f32, %arg16: f32):
      %103 = arith.mulf %arg14, %arg15 : f32
      linalg.yield %103 : f32
    } -> tensor<2x13xf32>
    %cst_16 = arith.constant 0.000000e+00 : f32
    %19 = linalg.init_tensor [2, 32] : tensor<2x32xf32>
    %20 = linalg.fill(%cst_16, %19) : f32, tensor<2x32xf32> -> tensor<2x32xf32>
    %21 = linalg.matmul ins(%18, %arg2 : tensor<2x13xf32>, tensor<13x32xf32>) outs(%20 : tensor<2x32xf32>) -> tensor<2x32xf32>
    %22 = linalg.init_tensor [2, 32] : tensor<2x32xf32>
    %23 = linalg.generic {indexing_maps = [#map0, #map1], iterator_types = ["parallel", "parallel"]} ins(%arg3 : tensor<32xf32>) outs(%22 : tensor<2x32xf32>) {
    ^bb0(%arg14: f32, %arg15: f32):
      linalg.yield %arg14 : f32
    } -> tensor<2x32xf32>
    %24 = linalg.init_tensor [2, 32] : tensor<2x32xf32>
    %25 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%21, %23 : tensor<2x32xf32>, tensor<2x32xf32>) outs(%24 : tensor<2x32xf32>) {
    ^bb0(%arg14: f32, %arg15: f32, %arg16: f32):
      %103 = arith.addf %arg14, %arg15 : f32
      linalg.yield %103 : f32
    } -> tensor<2x32xf32>
    %26 = linalg.init_tensor [2, 32] : tensor<2x32xi1>
    %27 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%25, %cst_3 : tensor<2x32xf32>, tensor<2x32xf32>) outs(%26 : tensor<2x32xi1>) {
    ^bb0(%arg14: f32, %arg15: f32, %arg16: i1):
      %103 = arith.cmpf ogt, %arg14, %arg15 : f32
      linalg.yield %103 : i1
    } -> tensor<2x32xi1>
    %28 = linalg.init_tensor [2, 32] : tensor<2x32xi1>
    %29 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%25, %cst_3 : tensor<2x32xf32>, tensor<2x32xf32>) outs(%28 : tensor<2x32xi1>) {
    ^bb0(%arg14: f32, %arg15: f32, %arg16: i1):
      %103 = arith.cmpf ogt, %arg14, %arg15 : f32
      linalg.yield %103 : i1
    } -> tensor<2x32xi1>
    %30 = call @jit__where_1.77(%29, %cst_0, %25) : (tensor<2x32xi1>, tensor<f32>, tensor<2x32xf32>) -> tensor<2x32xf32>
    %31 = linalg.init_tensor [2, 32] : tensor<2x32xf32>
    %32 = linalg.generic {indexing_maps = [#map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%30 : tensor<2x32xf32>) outs(%31 : tensor<2x32xf32>) {
    ^bb0(%arg14: f32, %arg15: f32):
      %103 = math.expm1 %arg14 : f32
      linalg.yield %103 : f32
    } -> tensor<2x32xf32>
    %33 = linalg.init_tensor [2, 32] : tensor<2x32xf32>
    %34 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%32, %cst_4 : tensor<2x32xf32>, tensor<2x32xf32>) outs(%33 : tensor<2x32xf32>) {
    ^bb0(%arg14: f32, %arg15: f32, %arg16: f32):
      %103 = arith.mulf %arg14, %arg15 : f32
      linalg.yield %103 : f32
    } -> tensor<2x32xf32>
    %35 = call @jit__where_2.87(%27, %25, %34) : (tensor<2x32xi1>, tensor<2x32xf32>, tensor<2x32xf32>) -> tensor<2x32xf32>
    %36 = linalg.init_tensor [2, 32] : tensor<2x32xf32>
    %37 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%35, %cst_5 : tensor<2x32xf32>, tensor<2x32xf32>) outs(%36 : tensor<2x32xf32>) {
    ^bb0(%arg14: f32, %arg15: f32, %arg16: f32):
      %103 = arith.mulf %arg14, %arg15 : f32
      linalg.yield %103 : f32
    } -> tensor<2x32xf32>
    %cst_17 = arith.constant 0.000000e+00 : f32
    %38 = linalg.init_tensor [2, 16] : tensor<2x16xf32>
    %39 = linalg.fill(%cst_17, %38) : f32, tensor<2x16xf32> -> tensor<2x16xf32>
    %40 = linalg.matmul ins(%37, %arg4 : tensor<2x32xf32>, tensor<32x16xf32>) outs(%39 : tensor<2x16xf32>) -> tensor<2x16xf32>
    %41 = linalg.init_tensor [2, 16] : tensor<2x16xf32>
    %42 = linalg.generic {indexing_maps = [#map0, #map1], iterator_types = ["parallel", "parallel"]} ins(%arg5 : tensor<16xf32>) outs(%41 : tensor<2x16xf32>) {
    ^bb0(%arg14: f32, %arg15: f32):
      linalg.yield %arg14 : f32
    } -> tensor<2x16xf32>
    %43 = linalg.init_tensor [2, 16] : tensor<2x16xf32>
    %44 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%40, %42 : tensor<2x16xf32>, tensor<2x16xf32>) outs(%43 : tensor<2x16xf32>) {
    ^bb0(%arg14: f32, %arg15: f32, %arg16: f32):
      %103 = arith.addf %arg14, %arg15 : f32
      linalg.yield %103 : f32
    } -> tensor<2x16xf32>
    %45 = linalg.init_tensor [2, 16] : tensor<2x16xi1>
    %46 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%44, %cst_6 : tensor<2x16xf32>, tensor<2x16xf32>) outs(%45 : tensor<2x16xi1>) {
    ^bb0(%arg14: f32, %arg15: f32, %arg16: i1):
      %103 = arith.cmpf ogt, %arg14, %arg15 : f32
      linalg.yield %103 : i1
    } -> tensor<2x16xi1>
    %47 = linalg.init_tensor [2, 16] : tensor<2x16xi1>
    %48 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%44, %cst_6 : tensor<2x16xf32>, tensor<2x16xf32>) outs(%47 : tensor<2x16xi1>) {
    ^bb0(%arg14: f32, %arg15: f32, %arg16: i1):
      %103 = arith.cmpf ogt, %arg14, %arg15 : f32
      linalg.yield %103 : i1
    } -> tensor<2x16xi1>
    %49 = call @jit__where_3.101(%48, %cst_0, %44) : (tensor<2x16xi1>, tensor<f32>, tensor<2x16xf32>) -> tensor<2x16xf32>
    %50 = linalg.init_tensor [2, 16] : tensor<2x16xf32>
    %51 = linalg.generic {indexing_maps = [#map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%49 : tensor<2x16xf32>) outs(%50 : tensor<2x16xf32>) {
    ^bb0(%arg14: f32, %arg15: f32):
      %103 = math.expm1 %arg14 : f32
      linalg.yield %103 : f32
    } -> tensor<2x16xf32>
    %52 = linalg.init_tensor [2, 16] : tensor<2x16xf32>
    %53 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%51, %cst_7 : tensor<2x16xf32>, tensor<2x16xf32>) outs(%52 : tensor<2x16xf32>) {
    ^bb0(%arg14: f32, %arg15: f32, %arg16: f32):
      %103 = arith.mulf %arg14, %arg15 : f32
      linalg.yield %103 : f32
    } -> tensor<2x16xf32>
    %54 = call @jit__where_4.111(%46, %44, %53) : (tensor<2x16xi1>, tensor<2x16xf32>, tensor<2x16xf32>) -> tensor<2x16xf32>
    %55 = linalg.init_tensor [2, 16] : tensor<2x16xf32>
    %56 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%54, %cst_8 : tensor<2x16xf32>, tensor<2x16xf32>) outs(%55 : tensor<2x16xf32>) {
    ^bb0(%arg14: f32, %arg15: f32, %arg16: f32):
      %103 = arith.mulf %arg14, %arg15 : f32
      linalg.yield %103 : f32
    } -> tensor<2x16xf32>
    %cst_18 = arith.constant 0.000000e+00 : f32
    %57 = linalg.init_tensor [2, 8] : tensor<2x8xf32>
    %58 = linalg.fill(%cst_18, %57) : f32, tensor<2x8xf32> -> tensor<2x8xf32>
    %59 = linalg.matmul ins(%56, %arg6 : tensor<2x16xf32>, tensor<16x8xf32>) outs(%58 : tensor<2x8xf32>) -> tensor<2x8xf32>
    %60 = linalg.init_tensor [2, 8] : tensor<2x8xf32>
    %61 = linalg.generic {indexing_maps = [#map0, #map1], iterator_types = ["parallel", "parallel"]} ins(%arg7 : tensor<8xf32>) outs(%60 : tensor<2x8xf32>) {
    ^bb0(%arg14: f32, %arg15: f32):
      linalg.yield %arg14 : f32
    } -> tensor<2x8xf32>
    %62 = linalg.init_tensor [2, 8] : tensor<2x8xf32>
    %63 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%59, %61 : tensor<2x8xf32>, tensor<2x8xf32>) outs(%62 : tensor<2x8xf32>) {
    ^bb0(%arg14: f32, %arg15: f32, %arg16: f32):
      %103 = arith.addf %arg14, %arg15 : f32
      linalg.yield %103 : f32
    } -> tensor<2x8xf32>
    %64 = linalg.init_tensor [2, 8] : tensor<2x8xi1>
    %65 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%63, %cst_9 : tensor<2x8xf32>, tensor<2x8xf32>) outs(%64 : tensor<2x8xi1>) {
    ^bb0(%arg14: f32, %arg15: f32, %arg16: i1):
      %103 = arith.cmpf ogt, %arg14, %arg15 : f32
      linalg.yield %103 : i1
    } -> tensor<2x8xi1>
    %66 = linalg.init_tensor [2, 8] : tensor<2x8xi1>
    %67 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%63, %cst_9 : tensor<2x8xf32>, tensor<2x8xf32>) outs(%66 : tensor<2x8xi1>) {
    ^bb0(%arg14: f32, %arg15: f32, %arg16: i1):
      %103 = arith.cmpf ogt, %arg14, %arg15 : f32
      linalg.yield %103 : i1
    } -> tensor<2x8xi1>
    %68 = call @jit__where_5.125(%67, %cst_0, %63) : (tensor<2x8xi1>, tensor<f32>, tensor<2x8xf32>) -> tensor<2x8xf32>
    %69 = linalg.init_tensor [2, 8] : tensor<2x8xf32>
    %70 = linalg.generic {indexing_maps = [#map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%68 : tensor<2x8xf32>) outs(%69 : tensor<2x8xf32>) {
    ^bb0(%arg14: f32, %arg15: f32):
      %103 = math.expm1 %arg14 : f32
      linalg.yield %103 : f32
    } -> tensor<2x8xf32>
    %71 = linalg.init_tensor [2, 8] : tensor<2x8xf32>
    %72 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%70, %cst_10 : tensor<2x8xf32>, tensor<2x8xf32>) outs(%71 : tensor<2x8xf32>) {
    ^bb0(%arg14: f32, %arg15: f32, %arg16: f32):
      %103 = arith.mulf %arg14, %arg15 : f32
      linalg.yield %103 : f32
    } -> tensor<2x8xf32>
    %73 = call @jit__where_6.135(%65, %63, %72) : (tensor<2x8xi1>, tensor<2x8xf32>, tensor<2x8xf32>) -> tensor<2x8xf32>
    %74 = linalg.init_tensor [2, 8] : tensor<2x8xf32>
    %75 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%73, %cst_11 : tensor<2x8xf32>, tensor<2x8xf32>) outs(%74 : tensor<2x8xf32>) {
    ^bb0(%arg14: f32, %arg15: f32, %arg16: f32):
      %103 = arith.mulf %arg14, %arg15 : f32
      linalg.yield %103 : f32
    } -> tensor<2x8xf32>
    %cst_19 = arith.constant 0.000000e+00 : f32
    %76 = linalg.init_tensor [2, 4] : tensor<2x4xf32>
    %77 = linalg.fill(%cst_19, %76) : f32, tensor<2x4xf32> -> tensor<2x4xf32>
    %78 = linalg.matmul ins(%75, %arg8 : tensor<2x8xf32>, tensor<8x4xf32>) outs(%77 : tensor<2x4xf32>) -> tensor<2x4xf32>
    %79 = linalg.init_tensor [2, 4] : tensor<2x4xf32>
    %80 = linalg.generic {indexing_maps = [#map0, #map1], iterator_types = ["parallel", "parallel"]} ins(%arg9 : tensor<4xf32>) outs(%79 : tensor<2x4xf32>) {
    ^bb0(%arg14: f32, %arg15: f32):
      linalg.yield %arg14 : f32
    } -> tensor<2x4xf32>
    %81 = linalg.init_tensor [2, 4] : tensor<2x4xf32>
    %82 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%78, %80 : tensor<2x4xf32>, tensor<2x4xf32>) outs(%81 : tensor<2x4xf32>) {
    ^bb0(%arg14: f32, %arg15: f32, %arg16: f32):
      %103 = arith.addf %arg14, %arg15 : f32
      linalg.yield %103 : f32
    } -> tensor<2x4xf32>
    %83 = linalg.init_tensor [2, 4] : tensor<2x4xi1>
    %84 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%82, %cst_12 : tensor<2x4xf32>, tensor<2x4xf32>) outs(%83 : tensor<2x4xi1>) {
    ^bb0(%arg14: f32, %arg15: f32, %arg16: i1):
      %103 = arith.cmpf ogt, %arg14, %arg15 : f32
      linalg.yield %103 : i1
    } -> tensor<2x4xi1>
    %85 = linalg.init_tensor [2, 4] : tensor<2x4xi1>
    %86 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%82, %cst_12 : tensor<2x4xf32>, tensor<2x4xf32>) outs(%85 : tensor<2x4xi1>) {
    ^bb0(%arg14: f32, %arg15: f32, %arg16: i1):
      %103 = arith.cmpf ogt, %arg14, %arg15 : f32
      linalg.yield %103 : i1
    } -> tensor<2x4xi1>
    %87 = call @jit__where_7.149(%86, %cst_0, %82) : (tensor<2x4xi1>, tensor<f32>, tensor<2x4xf32>) -> tensor<2x4xf32>
    %88 = linalg.init_tensor [2, 4] : tensor<2x4xf32>
    %89 = linalg.generic {indexing_maps = [#map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%87 : tensor<2x4xf32>) outs(%88 : tensor<2x4xf32>) {
    ^bb0(%arg14: f32, %arg15: f32):
      %103 = math.expm1 %arg14 : f32
      linalg.yield %103 : f32
    } -> tensor<2x4xf32>
    %90 = linalg.init_tensor [2, 4] : tensor<2x4xf32>
    %91 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%89, %cst_13 : tensor<2x4xf32>, tensor<2x4xf32>) outs(%90 : tensor<2x4xf32>) {
    ^bb0(%arg14: f32, %arg15: f32, %arg16: f32):
      %103 = arith.mulf %arg14, %arg15 : f32
      linalg.yield %103 : f32
    } -> tensor<2x4xf32>
    %92 = call @jit__where_8.159(%84, %82, %91) : (tensor<2x4xi1>, tensor<2x4xf32>, tensor<2x4xf32>) -> tensor<2x4xf32>
    %93 = linalg.init_tensor [2, 4] : tensor<2x4xf32>
    %94 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%92, %cst_14 : tensor<2x4xf32>, tensor<2x4xf32>) outs(%93 : tensor<2x4xf32>) {
    ^bb0(%arg14: f32, %arg15: f32, %arg16: f32):
      %103 = arith.mulf %arg14, %arg15 : f32
      linalg.yield %103 : f32
    } -> tensor<2x4xf32>
    %cst_20 = arith.constant 0.000000e+00 : f32
    %95 = linalg.init_tensor [2, 6] : tensor<2x6xf32>
    %96 = linalg.fill(%cst_20, %95) : f32, tensor<2x6xf32> -> tensor<2x6xf32>
    %97 = linalg.matmul ins(%94, %arg10 : tensor<2x4xf32>, tensor<4x6xf32>) outs(%96 : tensor<2x6xf32>) -> tensor<2x6xf32>
    %98 = linalg.init_tensor [2, 6] : tensor<2x6xf32>
    %99 = linalg.generic {indexing_maps = [#map0, #map1], iterator_types = ["parallel", "parallel"]} ins(%arg11 : tensor<6xf32>) outs(%98 : tensor<2x6xf32>) {
    ^bb0(%arg14: f32, %arg15: f32):
      linalg.yield %arg14 : f32
    } -> tensor<2x6xf32>
    %100 = linalg.init_tensor [2, 6] : tensor<2x6xf32>
    %101 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%97, %99 : tensor<2x6xf32>, tensor<2x6xf32>) outs(%100 : tensor<2x6xf32>) {
    ^bb0(%arg14: f32, %arg15: f32, %arg16: f32):
      %103 = arith.addf %arg14, %arg15 : f32
      linalg.yield %103 : f32
    } -> tensor<2x6xf32>
    %102 = call @jit__mse.176(%101, %arg13) : (tensor<2x6xf32>, tensor<2x6xf32>) -> tensor<f32>
    return %102 : tensor<f32>
  }
  func private @jit__where.53(%arg0: tensor<2x13xi1>, %arg1: tensor<f32>, %arg2: tensor<2x13xf32>) -> tensor<2x13xf32> {
    %0 = linalg.init_tensor [2, 13] : tensor<2x13xf32>
    %1 = linalg.generic {indexing_maps = [#map2, #map1], iterator_types = ["parallel", "parallel"]} ins(%arg1 : tensor<f32>) outs(%0 : tensor<2x13xf32>) {
    ^bb0(%arg3: f32, %arg4: f32):
      linalg.yield %arg3 : f32
    } -> tensor<2x13xf32>
    %2 = linalg.init_tensor [2, 13] : tensor<2x13xf32>
    %3 = linalg.generic {indexing_maps = [#map1, #map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%arg0, %1, %arg2 : tensor<2x13xi1>, tensor<2x13xf32>, tensor<2x13xf32>) outs(%2 : tensor<2x13xf32>) {
    ^bb0(%arg3: i1, %arg4: f32, %arg5: f32, %arg6: f32):
      %4 = arith.select %arg3, %arg4, %arg5 : f32
      linalg.yield %4 : f32
    } -> tensor<2x13xf32>
    return %3 : tensor<2x13xf32>
  }
  func private @jit__where_0.63(%arg0: tensor<2x13xi1>, %arg1: tensor<2x13xf32>, %arg2: tensor<2x13xf32>) -> tensor<2x13xf32> {
    %0 = linalg.init_tensor [2, 13] : tensor<2x13xf32>
    %1 = linalg.generic {indexing_maps = [#map1, #map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%arg0, %arg1, %arg2 : tensor<2x13xi1>, tensor<2x13xf32>, tensor<2x13xf32>) outs(%0 : tensor<2x13xf32>) {
    ^bb0(%arg3: i1, %arg4: f32, %arg5: f32, %arg6: f32):
      %2 = arith.select %arg3, %arg4, %arg5 : f32
      linalg.yield %2 : f32
    } -> tensor<2x13xf32>
    return %1 : tensor<2x13xf32>
  }
  func private @jit__where_1.77(%arg0: tensor<2x32xi1>, %arg1: tensor<f32>, %arg2: tensor<2x32xf32>) -> tensor<2x32xf32> {
    %0 = linalg.init_tensor [2, 32] : tensor<2x32xf32>
    %1 = linalg.generic {indexing_maps = [#map2, #map1], iterator_types = ["parallel", "parallel"]} ins(%arg1 : tensor<f32>) outs(%0 : tensor<2x32xf32>) {
    ^bb0(%arg3: f32, %arg4: f32):
      linalg.yield %arg3 : f32
    } -> tensor<2x32xf32>
    %2 = linalg.init_tensor [2, 32] : tensor<2x32xf32>
    %3 = linalg.generic {indexing_maps = [#map1, #map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%arg0, %1, %arg2 : tensor<2x32xi1>, tensor<2x32xf32>, tensor<2x32xf32>) outs(%2 : tensor<2x32xf32>) {
    ^bb0(%arg3: i1, %arg4: f32, %arg5: f32, %arg6: f32):
      %4 = arith.select %arg3, %arg4, %arg5 : f32
      linalg.yield %4 : f32
    } -> tensor<2x32xf32>
    return %3 : tensor<2x32xf32>
  }
  func private @jit__where_2.87(%arg0: tensor<2x32xi1>, %arg1: tensor<2x32xf32>, %arg2: tensor<2x32xf32>) -> tensor<2x32xf32> {
    %0 = linalg.init_tensor [2, 32] : tensor<2x32xf32>
    %1 = linalg.generic {indexing_maps = [#map1, #map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%arg0, %arg1, %arg2 : tensor<2x32xi1>, tensor<2x32xf32>, tensor<2x32xf32>) outs(%0 : tensor<2x32xf32>) {
    ^bb0(%arg3: i1, %arg4: f32, %arg5: f32, %arg6: f32):
      %2 = arith.select %arg3, %arg4, %arg5 : f32
      linalg.yield %2 : f32
    } -> tensor<2x32xf32>
    return %1 : tensor<2x32xf32>
  }
  func private @jit__where_3.101(%arg0: tensor<2x16xi1>, %arg1: tensor<f32>, %arg2: tensor<2x16xf32>) -> tensor<2x16xf32> {
    %0 = linalg.init_tensor [2, 16] : tensor<2x16xf32>
    %1 = linalg.generic {indexing_maps = [#map2, #map1], iterator_types = ["parallel", "parallel"]} ins(%arg1 : tensor<f32>) outs(%0 : tensor<2x16xf32>) {
    ^bb0(%arg3: f32, %arg4: f32):
      linalg.yield %arg3 : f32
    } -> tensor<2x16xf32>
    %2 = linalg.init_tensor [2, 16] : tensor<2x16xf32>
    %3 = linalg.generic {indexing_maps = [#map1, #map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%arg0, %1, %arg2 : tensor<2x16xi1>, tensor<2x16xf32>, tensor<2x16xf32>) outs(%2 : tensor<2x16xf32>) {
    ^bb0(%arg3: i1, %arg4: f32, %arg5: f32, %arg6: f32):
      %4 = arith.select %arg3, %arg4, %arg5 : f32
      linalg.yield %4 : f32
    } -> tensor<2x16xf32>
    return %3 : tensor<2x16xf32>
  }
  func private @jit__where_4.111(%arg0: tensor<2x16xi1>, %arg1: tensor<2x16xf32>, %arg2: tensor<2x16xf32>) -> tensor<2x16xf32> {
    %0 = linalg.init_tensor [2, 16] : tensor<2x16xf32>
    %1 = linalg.generic {indexing_maps = [#map1, #map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%arg0, %arg1, %arg2 : tensor<2x16xi1>, tensor<2x16xf32>, tensor<2x16xf32>) outs(%0 : tensor<2x16xf32>) {
    ^bb0(%arg3: i1, %arg4: f32, %arg5: f32, %arg6: f32):
      %2 = arith.select %arg3, %arg4, %arg5 : f32
      linalg.yield %2 : f32
    } -> tensor<2x16xf32>
    return %1 : tensor<2x16xf32>
  }
  func private @jit__where_5.125(%arg0: tensor<2x8xi1>, %arg1: tensor<f32>, %arg2: tensor<2x8xf32>) -> tensor<2x8xf32> {
    %0 = linalg.init_tensor [2, 8] : tensor<2x8xf32>
    %1 = linalg.generic {indexing_maps = [#map2, #map1], iterator_types = ["parallel", "parallel"]} ins(%arg1 : tensor<f32>) outs(%0 : tensor<2x8xf32>) {
    ^bb0(%arg3: f32, %arg4: f32):
      linalg.yield %arg3 : f32
    } -> tensor<2x8xf32>
    %2 = linalg.init_tensor [2, 8] : tensor<2x8xf32>
    %3 = linalg.generic {indexing_maps = [#map1, #map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%arg0, %1, %arg2 : tensor<2x8xi1>, tensor<2x8xf32>, tensor<2x8xf32>) outs(%2 : tensor<2x8xf32>) {
    ^bb0(%arg3: i1, %arg4: f32, %arg5: f32, %arg6: f32):
      %4 = arith.select %arg3, %arg4, %arg5 : f32
      linalg.yield %4 : f32
    } -> tensor<2x8xf32>
    return %3 : tensor<2x8xf32>
  }
  func private @jit__where_6.135(%arg0: tensor<2x8xi1>, %arg1: tensor<2x8xf32>, %arg2: tensor<2x8xf32>) -> tensor<2x8xf32> {
    %0 = linalg.init_tensor [2, 8] : tensor<2x8xf32>
    %1 = linalg.generic {indexing_maps = [#map1, #map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%arg0, %arg1, %arg2 : tensor<2x8xi1>, tensor<2x8xf32>, tensor<2x8xf32>) outs(%0 : tensor<2x8xf32>) {
    ^bb0(%arg3: i1, %arg4: f32, %arg5: f32, %arg6: f32):
      %2 = arith.select %arg3, %arg4, %arg5 : f32
      linalg.yield %2 : f32
    } -> tensor<2x8xf32>
    return %1 : tensor<2x8xf32>
  }
  func private @jit__where_7.149(%arg0: tensor<2x4xi1>, %arg1: tensor<f32>, %arg2: tensor<2x4xf32>) -> tensor<2x4xf32> {
    %0 = linalg.init_tensor [2, 4] : tensor<2x4xf32>
    %1 = linalg.generic {indexing_maps = [#map2, #map1], iterator_types = ["parallel", "parallel"]} ins(%arg1 : tensor<f32>) outs(%0 : tensor<2x4xf32>) {
    ^bb0(%arg3: f32, %arg4: f32):
      linalg.yield %arg3 : f32
    } -> tensor<2x4xf32>
    %2 = linalg.init_tensor [2, 4] : tensor<2x4xf32>
    %3 = linalg.generic {indexing_maps = [#map1, #map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%arg0, %1, %arg2 : tensor<2x4xi1>, tensor<2x4xf32>, tensor<2x4xf32>) outs(%2 : tensor<2x4xf32>) {
    ^bb0(%arg3: i1, %arg4: f32, %arg5: f32, %arg6: f32):
      %4 = arith.select %arg3, %arg4, %arg5 : f32
      linalg.yield %4 : f32
    } -> tensor<2x4xf32>
    return %3 : tensor<2x4xf32>
  }
  func private @jit__where_8.159(%arg0: tensor<2x4xi1>, %arg1: tensor<2x4xf32>, %arg2: tensor<2x4xf32>) -> tensor<2x4xf32> {
    %0 = linalg.init_tensor [2, 4] : tensor<2x4xf32>
    %1 = linalg.generic {indexing_maps = [#map1, #map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%arg0, %arg1, %arg2 : tensor<2x4xi1>, tensor<2x4xf32>, tensor<2x4xf32>) outs(%0 : tensor<2x4xf32>) {
    ^bb0(%arg3: i1, %arg4: f32, %arg5: f32, %arg6: f32):
      %2 = arith.select %arg3, %arg4, %arg5 : f32
      linalg.yield %2 : f32
    } -> tensor<2x4xf32>
    return %1 : tensor<2x4xf32>
  }
  func private @jit__mse.176(%arg0: tensor<2x6xf32>, %arg1: tensor<2x6xf32>) -> tensor<f32> {
    %cst = arith.constant dense<0.000000e+00> : tensor<f32>
    %cst_0 = arith.constant dense<1.200000e+01> : tensor<f32>
    %0 = linalg.init_tensor [2, 6] : tensor<2x6xf32>
    %1 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%arg0, %arg1 : tensor<2x6xf32>, tensor<2x6xf32>) outs(%0 : tensor<2x6xf32>) {
    ^bb0(%arg2: f32, %arg3: f32, %arg4: f32):
      %9 = arith.subf %arg2, %arg3 : f32
      linalg.yield %9 : f32
    } -> tensor<2x6xf32>
    %2 = linalg.init_tensor [2, 6] : tensor<2x6xf32>
    %3 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%1, %1 : tensor<2x6xf32>, tensor<2x6xf32>) outs(%2 : tensor<2x6xf32>) {
    ^bb0(%arg2: f32, %arg3: f32, %arg4: f32):
      %9 = arith.mulf %arg2, %arg3 : f32
      linalg.yield %9 : f32
    } -> tensor<2x6xf32>
    %cst_1 = arith.constant 0.000000e+00 : f32
    %4 = linalg.init_tensor [] : tensor<f32>
    %5 = linalg.fill(%cst_1, %4) : f32, tensor<f32> -> tensor<f32>
    %6 = linalg.generic {indexing_maps = [#map1, #map2], iterator_types = ["reduction", "reduction"]} ins(%3 : tensor<2x6xf32>) outs(%5 : tensor<f32>) {
    ^bb0(%arg2: f32, %arg3: f32):
      %9 = arith.addf %arg2, %arg3 : f32
      linalg.yield %9 : f32
    } -> tensor<f32>
    %7 = linalg.init_tensor [] : tensor<f32>
    %8 = linalg.generic {indexing_maps = [#map3, #map3, #map3], iterator_types = []} ins(%6, %cst_0 : tensor<f32>, tensor<f32>) outs(%7 : tensor<f32>) {
    ^bb0(%arg2: f32, %arg3: f32, %arg4: f32):
      %9 = arith.divf %arg2, %arg3 : f32
      linalg.yield %9 : f32
    } -> tensor<f32>
    return %8 : tensor<f32>
  }

  func @main() {
    %0 = arith.constant dense<1.000000e+00> : tensor<13x13xf32>
    %1 = arith.constant dense<2.000000e+00> : tensor<13xf32>
    %2 = arith.constant dense<3.000000e+00> : tensor<13x32xf32>
    %3 = arith.constant dense<3.000000e+00> : tensor<32xf32>
    %4 = arith.constant dense<3.000000e+00> : tensor<32x16xf32>
    %5 = arith.constant dense<3.000000e+00> : tensor<16xf32>
    %6 = arith.constant dense<3.000000e+00> : tensor<16x8xf32>
    %7 = arith.constant dense<3.000000e+00> : tensor<8xf32>
    %8 = arith.constant dense<3.000000e+00> : tensor<8x4xf32>
    %9 = arith.constant dense<3.000000e+00> : tensor<4xf32>
    %10 = arith.constant dense<3.000000e+00> : tensor<4x6xf32>
    %11 = arith.constant dense<3.000000e+00> : tensor<6xf32>
    %12 = arith.constant dense<3.000000e+00> : tensor<2x13xf32>
    %13 = arith.constant dense<3.000000e+00> : tensor<2x6xf32>
    %14 = call @foo(%0, %1, %2, %3, %4, %5, %6, %7, %8, %9, %10, %11, %12, %13) : (tensor<13x13xf32>, tensor<13xf32>, tensor<13x32xf32>, tensor<32xf32>, tensor<32x16xf32>, tensor<16xf32>, tensor<16x8xf32>, tensor<8xf32>, tensor<8x4xf32>, tensor<4xf32>, tensor<4x6xf32>, tensor<6xf32>, tensor<2x13xf32>, tensor<2x6xf32>) -> tensor<f32>
    %unranked = tensor.cast %14 : tensor<f32> to tensor<*xf32>
    call @print_memref_f32(%unranked) : (tensor<*xf32>) -> ()
    return
  }

  func private @print_memref_f32(%ptr : tensor<*xf32>)
}

