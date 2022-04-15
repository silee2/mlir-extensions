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
