# linalg dialect to gpu dialect lowering pipeline
# Ready for vulkan runner or narrow scope l0/sycl runner starting from GPU dialect.
convert-tensor-to-linalg
arith-bufferize
func.func(linalg-init-tensor-to-alloc-tensor
          scf-bufferize
          shape-bufferize
          linalg-bufferize
          bufferization-bufferize
          tensor-bufferize)
func-bufferize
func.func(finalizing-bufferize
          convert-linalg-to-parallel-loops
          gpu-map-parallel-loops
          convert-parallel-loops-to-gpu)
insert-gpu-alloc
canonicalize
# Adds spirv storage class attributes to memrefs based on memory space attribute
# Need the pass to target narrower scope
#memref.load(map-memref-spirv-storage-class{client-api=vulkan})
normalize-memrefs
# Unstride memrefs does not seem to be needed.
#func.func(unstride-memrefs)
func.func(lower-affine)
gpu-kernel-outlining
canonicalize
cse
# The following set-spirv-* passes can have client-api = opencl or vulkan args
set-spirv-capablilities
set-spirv-abi-attrs
canonicalize
