//===- XeGPUToVC.cpp -  XeGPU to VC Lowering pass  --------------*- C++ -*-===//
//
// Copyright 2024 Intel Corporation
// Part of the IMEX Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
///
/// \file
/// This file implements a pass to generate Func calls to intel VC intrinsics
/// functions for XeGPU dialect ops
///
//===----------------------------------------------------------------------===//

#include <imex/Conversion/XeGPUToVC/XeGPUToVC.h>

#include "mlir/Dialect/SPIRV/IR/SPIRVAttributes.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Pass/PassManager.h"

#include "mlir/Conversion/LLVMCommon/TypeConverter.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"

#include "../PassDetail.h"

using namespace mlir;

namespace imex {

/// This function adds necessary Func Declaration for Imported VC-intrinsics
/// functions and sets linkage attributes to those declaration
/// to support SPIRV compilation
static FlatSymbolRefAttr
getFuncRefAttr(gpu::GPUModuleOp module, StringRef name, TypeRange resultType,
               ValueRange operands, bool isVectorComputeFunction,
               bool emitCInterface, bool emitSPIRVLinkage = true) {
  MLIRContext *context = module.getContext();
  auto result = SymbolRefAttr::get(context, name);

  // Look up for existing VC instrinsics Function declaration and
  // create it if not present Module level
  auto func = module.lookupSymbol<func::FuncOp>(result.getAttr());
  if (!func) {
    OpBuilder moduleBuilder(module.getBodyRegion());
    func = moduleBuilder.create<func::FuncOp>(
        module.getLoc(), name,
        FunctionType::get(context, operands.getTypes(), resultType));

    func.setPrivate();
    if (emitCInterface)
      func->setAttr(LLVM::LLVMDialect::getEmitCWrapperAttrName(),
                    UnitAttr::get(context));

    // Set spirv attributes.
    // Set VectorComputeFunctionINTEL atribute if it is a VectorComputeFunction.
    if (isVectorComputeFunction)
      func->setAttr(spirv::stringifyDecoration(
                        spirv::Decoration::VectorComputeFunctionINTEL),
                    UnitAttr::get(context));
    // Emit linkage attributes needed for SPIR-V dialect path
    if (emitSPIRVLinkage) {
      auto linkageNameAttr = StringAttr::get(context, name);
      auto linkageTypeAttr =
          spirv::LinkageTypeAttr::get(context, spirv::LinkageType::Import);
      auto linkageAttribute = spirv::LinkageAttributesAttr::get(
          context, linkageNameAttr, linkageTypeAttr);
      func->setAttr("linkage_attributes", linkageAttribute);
    }
  }
  return result;
}

/// Create VC-Intrinsics function declaration and insert func.call Op
static func::CallOp createFuncCall(PatternRewriter &rewriter, Location loc,
                                   StringRef funcName, TypeRange resultType,
                                   ValueRange operands, bool emitCInterface) {
  auto module =
      rewriter.getBlock()->getParentOp()->getParentOfType<gpu::GPUModuleOp>();
  FlatSymbolRefAttr fn = getFuncRefAttr(
      module, funcName, resultType, operands,
      true /*isVectorComputeFunctionINTEL=true*/, emitCInterface);
  return rewriter.create<func::CallOp>(loc, fn, resultType, operands);
}

struct CreateNdDescPattern
    : public OpConversionPattern<::mlir::xegpu::CreateNdDescOp> {
  using OpConversionPattern<::mlir::xegpu::CreateNdDescOp>::OpConversionPattern;

  LogicalResult
  matchAndRewrite(xegpu::CreateNdDescOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {

    auto loc = op.getLoc();
    auto i32Type = rewriter.getI32Type();
    auto i64Type = rewriter.getI64Type();
    auto v8i32 = VectorType::get(8, i32Type);
    auto v4i64 = VectorType::get(4, i64Type);

    // 2D Block Load Payload structure
    //    DWORD0..DWORD1 [63:0] 2D Block Base Address
    //    DWORD2: 2D Block Width
    //    DWORD3: 2D Block Height
    //    DWORD4: 2D Block Pitch
    //    DWORD5: Block Start OffsetX
    //    DWORD6: Block Start OffsetY
    //    DWORD7 [7:0]: 2D Block Width in number of elements
    //    DWORD7 [15:8]: 2D Block Height in number of elements
    //    DWORD7 [16:23]: Array Length

    // Create Payload using 1-D Vector of 4 64-bit elements, mainly because 2D
    // Block Base address value is 64-bit and it has to be 64 bytes aligned.
    // Rest of the payload parameters can be represented using i32 DWORD, so
    // payload is later casted to 1-D vector of 8 i32 elements.
    Value payLoad = rewriter.create<arith::ConstantOp>(
        loc, DenseElementsAttr::get(
                 v4i64, IntegerAttr::get(v4i64.getElementType(), 0)));

    auto createIntConstant = [&](unsigned index) {
      return rewriter.create<arith::ConstantOp>(
          loc, i32Type, rewriter.getI32IntegerAttr(index));
    };

    auto base = rewriter.create<memref::ExtractAlignedPointerAsIndexOp>(
        loc, adaptor.getSource());
    Value baseVal = rewriter.create<arith::IndexCastUIOp>(loc, i64Type, base);

    payLoad = rewriter.create<vector::InsertOp>(loc, baseVal, payLoad, 0);
    payLoad = rewriter.create<vector::BitCastOp>(loc, v8i32, payLoad);

    auto tileType = op.getTensorDesc().getType();
    auto rank = tileType.getRank();
    if (rank == 2) {
      auto blockWidth = tileType.getShape()[1];
      auto blockHeight = tileType.getShape()[0];
      // fixme: support memref for now
      auto memType = cast<MemRefType>(op.getSource().getType());
      unsigned bitWidth = memType.getElementType().getIntOrFloatBitWidth();
      Value surfaceW, surfaceH, surfaceP;

      // Static memref
      if (memType.hasStaticShape()) {
        auto surfaceWidth = memType.getShape()[1] * (bitWidth / 8) - 1;
        auto surfaceHeight = memType.getShape()[0] - 1;
        // fixme: pitch = width for now
        auto surfacePitch = surfaceWidth;
        surfaceW = createIntConstant(surfaceWidth);
        surfaceH = createIntConstant(surfaceHeight);
        surfaceP = createIntConstant(surfacePitch);
      } else {
        // Handle dynamic 2D memref to support dynamic shapes
        // Get the surfaceWidth and Height from the op attributes
        // compute surface width
        auto bytesPerElem = createIntConstant(bitWidth / 8);
        auto one = createIntConstant(1);
        surfaceW = rewriter.create<arith::ExtUIOp>(loc, i32Type,
                                                   adaptor.getShape()[1]);
        surfaceW = rewriter.create<arith::MulIOp>(loc, surfaceW, bytesPerElem);
        surfaceW = rewriter.create<arith::SubIOp>(loc, surfaceW, one);
        // compute surface height
        surfaceH = rewriter.create<arith::ExtUIOp>(loc, i32Type,
                                                   adaptor.getShape()[0]);
        surfaceH = rewriter.create<arith::SubIOp>(loc, surfaceH, one);
        // fixme: pitch = width for now
        surfaceP = surfaceW;
      }

      payLoad = rewriter.create<vector::InsertOp>(loc, surfaceW, payLoad, 2);
      payLoad = rewriter.create<vector::InsertOp>(loc, surfaceH, payLoad, 3);
      payLoad = rewriter.create<vector::InsertOp>(loc, surfaceP, payLoad, 4);
      auto createOffset = [&](unsigned idx) -> Value {
        Value val;
        OpFoldResult ofr = op.getMixedOffsets()[idx];
        auto v = llvm::dyn_cast_if_present<Value>(ofr);
        if (v) {
          val = ofr.get<Value>();
          val = rewriter.create<arith::IndexCastOp>(loc, i64Type, val);
          val = rewriter.create<arith::TruncIOp>(loc, i32Type, val);
        } else {
          int off = llvm::cast<IntegerAttr>(ofr.get<Attribute>()).getInt();
          val = createIntConstant(off);
        }
        return val;
      };
      auto offsetX = createOffset(1);
      auto offsetY = createOffset(0);
      payLoad = rewriter.create<vector::InsertOp>(loc, offsetX, payLoad, 5);
      payLoad = rewriter.create<vector::InsertOp>(loc, offsetY, payLoad, 6);
      int array_length = op.getType().getArrayLength();
      unsigned blockVal = (array_length - 1) << 16;
      blockVal |= ((blockHeight - 1) << 8) | (blockWidth - 1);
      auto blockInfo = createIntConstant(blockVal);
      payLoad = rewriter.create<vector::InsertOp>(loc, blockInfo, payLoad, 7);
    }
    rewriter.replaceOp(op, payLoad);
    return success();
  }
};

class UpdateNDOffsetToVCPattern
    : public OpConversionPattern<::mlir::xegpu::UpdateNdOffsetOp> {
public:
  using OpConversionPattern<
      ::mlir::xegpu::UpdateNdOffsetOp>::OpConversionPattern;
  LogicalResult
  matchAndRewrite(mlir::xegpu::UpdateNdOffsetOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {

    auto loc = op.getLoc();
    auto i32Type = rewriter.getI32Type();
    auto offsets = adaptor.getOffsets();

    // Get Payload
    auto desc = adaptor.getTensorDesc();

    for (size_t i = 0; i < offsets.size(); i++) {
      auto offset = offsets[i];
      if (auto cst = dyn_cast<arith::ConstantOp>(offset.getDefiningOp()))
        if (auto attr = dyn_cast<mlir::IntegerAttr>(cst.getValue());
            attr && attr.getInt() == 0)
          continue;

      // Get 2D Block OffsetX / Offset Y from PayLoad DWORD 5 / DWORD6
      // respectively. Advance to new offset within 2D block Tile using input
      // offset.
      int32_t idx = i == 0 ? 6 : 5;
      auto oldOffset = rewriter.create<vector::ExtractOp>(loc, desc, idx);
      offset = rewriter.create<arith::TruncIOp>(loc, i32Type, offset);
      auto newOffset = rewriter.create<arith::AddIOp>(loc, oldOffset, offset);

      // Update new 2D Block OffsetX/OffsetY in Payload descriptor.
      desc = rewriter.create<vector::InsertOp>(loc, newOffset, desc, idx);
    }
    rewriter.replaceOp(op, desc);
    return success();
  }
};

class CreateDescToVCPattern
    : public OpConversionPattern<::mlir::xegpu::CreateDescOp> {
public:
  using OpConversionPattern<::mlir::xegpu::CreateDescOp>::OpConversionPattern;
  LogicalResult
  matchAndRewrite(::mlir::xegpu::CreateDescOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {

    auto loc = op.getLoc();
    auto i32Type = rewriter.getI32Type();
    auto i64Type = rewriter.getI64Type();
    auto v8i32 = VectorType::get(8, i32Type);
    auto v4i64 = VectorType::get(4, i64Type);
    Value payLoad = rewriter.create<arith::ConstantOp>(
        loc, DenseElementsAttr::get(
                 v4i64, IntegerAttr::get(v4i64.getElementType(), 0)));

    auto base = rewriter.create<memref::ExtractAlignedPointerAsIndexOp>(
        loc, adaptor.getSource());
    Value baseVal = rewriter.create<arith::IndexCastUIOp>(loc, i64Type, base);

    payLoad = rewriter.create<vector::InsertOp>(loc, baseVal, payLoad, 0);
    payLoad = rewriter.create<vector::BitCastOp>(loc, v8i32, payLoad);
    rewriter.replaceOp(op, payLoad);
    return success();
  }
};

template <typename OpType>
class LoadStorePrefetchNdToLscPattern : public OpConversionPattern<OpType> {
  using OpConversionPattern<OpType>::OpConversionPattern;

  LogicalResult
  matchAndRewrite(OpType op, typename OpType::Adaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {

    auto tileType = op.getTensorDesc().getType();
    int rank = tileType.getRank();
    assert(rank <= 2 && "only support 1d/2d load/store/prefetch for now");
    auto loc = op.getLoc();
    ::mlir::VectorType vecType;
    std::string funcName;
    constexpr bool isLoad = std::is_same_v<OpType, xegpu::LoadNdOp>;
    constexpr bool isPrefetch = std::is_same_v<OpType, xegpu::PrefetchNdOp>;
    if constexpr (isLoad) {
      vecType = cast<VectorType>(op.getResult().getType());
      funcName = rank == 2 ? "llvm.genx.lsc.load2d.stateless."
                           : "llvm.genx.lsc.load.stateless.";
    } else if constexpr (isPrefetch) {
      vecType = VectorType::get({8, 16}, rewriter.getF32Type());
      funcName = rank == 2 ? "llvm.genx.lsc.prefetch2d.stateless.i1.i64"
                           : "llvm.genx.lsc.prefetch.stateless.";
    } else {
      vecType = cast<VectorType>(op.getValue().getType());
      funcName = rank == 2 ? "llvm.genx.lsc.store2d.stateless.i1.i64."
                           : "llvm.genx.lsc.store.stateless.i1.i64.";
    }
    auto createIntConstant = [&](Type type, unsigned value) {
      auto attr = rewriter.getIntegerAttr(type, value);
      return rewriter.create<arith::ConstantOp>(loc, type, attr);
    };
    auto i8Type = rewriter.getI8Type();
    auto i16Type = rewriter.getI16Type();
    auto i32Type = rewriter.getI32Type();
    auto i64Type = rewriter.getI64Type();
    auto v4i64 = VectorType::get(4, i64Type);
    auto vnni = false;
    auto transpose = false;
    if constexpr (isLoad) {
      auto vnniValue = op.getVnniAxis();
      vnni = vnniValue.has_value() && vnniValue.value() == 0 ? true : false;
      auto transposeValue = op.getTranspose();
      transpose = transposeValue.has_value() && transposeValue.value()[0] == 1
                      ? true
                      : false;
    }
    auto l1hint = op.getL1Hint();
    // auto l2hint = op.getL2Hint();
    auto l3hint = op.getL3Hint();

    // predicate(true for now)
    auto pred = createIntConstant(rewriter.getI1Type(), 1);
    auto l1CacheHint =
        createIntConstant(i8Type, l1hint.has_value() ? (int)l1hint.value() : 0);
    auto l3CacheHint =
        createIntConstant(i8Type, l3hint.has_value() ? (int)l3hint.value() : 0);
    unsigned dataSize = encodeDataum(vecType.getElementType());
    auto dataum = createIntConstant(i8Type, dataSize);
    auto trans = createIntConstant(i8Type, transpose ? 2 : 1);
    auto array_length = op.getTensorDescType().getArrayLength();
    auto nBlks = createIntConstant(i8Type, array_length);
    auto tensorDesc = adaptor.getTensorDesc();
    auto cast = rewriter.create<vector::BitCastOp>(loc, v4i64, tensorDesc);
    auto base = rewriter.create<vector::ExtractOp>(loc, cast, 0);
    auto [typeStr, newType] = encodeVectorType(rewriter, vecType, rank == 1);
    SmallVector<Value> args;
    if (rank == 2) {
      auto blockWidth = tileType.getShape()[1];
      auto blockHeight = tileType.getShape()[0];
      auto blockW = createIntConstant(i32Type, blockWidth);
      auto blockH = createIntConstant(i32Type, blockHeight);
      auto transform = createIntConstant(i8Type, vnni ? 1 : 0);
      // static memref for now
      auto createDescOp =
          op.getTensorDesc().template getDefiningOp<xegpu::CreateNdDescOp>();
      auto memType = llvm::cast<MemRefType>(createDescOp.getSource().getType());
      unsigned bitWidth = memType.getElementType().getIntOrFloatBitWidth();
      auto surfaceWidth = memType.getShape()[1] * (bitWidth / 8) - 1;
      auto surfaceHeight = memType.getShape()[0] - 1;
      // pitch = width for now
      auto surfacePitch = surfaceWidth;
      auto surfaceW = createIntConstant(i32Type, surfaceWidth);
      auto surfaceH = createIntConstant(i32Type, surfaceHeight);
      auto surfaceP = createIntConstant(i32Type, surfacePitch);
      auto offsetX = rewriter.create<vector::ExtractOp>(loc, tensorDesc, 5);
      auto offsetY = rewriter.create<vector::ExtractOp>(loc, tensorDesc, 6);
      args.assign({pred, l1CacheHint, l3CacheHint, dataum, trans, nBlks, blockW,
                   blockH, transform, base, surfaceW, surfaceH, surfaceP,
                   offsetX, offsetY});
      if constexpr (!isLoad && !isPrefetch) {
        args.push_back(adaptor.getValue());
      }
    } else if (rank == 1) {
      auto subOpcode =
          createIntConstant(i8Type, (isLoad || isPrefetch) ? 0 : 4);
      auto addrScale = createIntConstant(i16Type, 1);
      auto immOffset = createIntConstant(i32Type, 0);
      auto dataumSize = createIntConstant(i8Type, 4);
      int lscVecSize = 0;
      int numElts = newType.getNumElements();
      if (numElts <= 4) {
        lscVecSize = numElts;
      } else {
        lscVecSize = log2(numElts) + 2;
      }
      auto vecSize = createIntConstant(i8Type, lscVecSize);
      auto transposed = createIntConstant(i8Type, 2); // transpose
      auto mask = createIntConstant(i8Type, 0);
      auto surface = createIntConstant(i32Type, 0);
      args.assign({
          pred,
          subOpcode,
          l1CacheHint,
          l3CacheHint,
          addrScale,
          immOffset,
          dataumSize,
          vecSize,
          transposed,
          mask,
          base,
      });
      if constexpr (!isLoad && !isPrefetch) {
        auto cast = rewriter.create<vector::BitCastOp>(loc, newType,
                                                       adaptor.getValue());
        args.push_back(cast);
      }
      args.push_back(surface);
    }
    if constexpr (!isPrefetch)
      funcName += typeStr;
    if constexpr (isLoad) {
      funcName += ".i1.i64";
      auto retType = newType;
      auto funcOp = createFuncCall(rewriter, loc, funcName, TypeRange{retType},
                                   args, false);
      if (rank == 2) {
        rewriter.replaceOp(op, funcOp);
      } else {
        auto cast = rewriter.create<vector::BitCastOp>(loc, op.getType(),
                                                       funcOp->getResult(0));
        rewriter.replaceOp(op, cast);
      }
    } else {
      createFuncCall(rewriter, loc, funcName, TypeRange{}, args, false);
      rewriter.eraseOp(op);
    }
    return success();
  }
};

template <typename OpType>
class LoadStorePrefetchNdToRawSendPattern : public OpConversionPattern<OpType> {
  using OpConversionPattern<OpType>::OpConversionPattern;

  LogicalResult
  matchAndRewrite(OpType op, typename OpType::Adaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {

    auto tileType = op.getTensorDesc().getType();
    auto rank = tileType.getRank();
    assert(rank <= 2 && "only support 1d/2d load/store/prefetch for now");
    auto loc = op.getLoc();
    constexpr bool isLoad = std::is_same_v<OpType, xegpu::LoadNdOp>;
    constexpr bool isPrefetch = std::is_same_v<OpType, xegpu::PrefetchNdOp>;
    auto createIntConstant = [&](Type type, unsigned value) {
      auto attr = rewriter.getIntegerAttr(type, value);
      return rewriter.create<arith::ConstantOp>(loc, type, attr);
    };

    /// collect common info
    auto i1Type = rewriter.getI1Type();
    auto i8Type = rewriter.getI8Type();
    auto i32Type = rewriter.getI32Type();
    auto vnni = false;
    auto transpose = false;
    if constexpr (isLoad) {
      auto vnniValue = op.getVnniAxis();
      vnni = vnniValue.has_value() && vnniValue.value() == 0 ? true : false;
      auto transposeValue = op.getTranspose();
      transpose = transposeValue.has_value() && transposeValue.value()[0] == 1
                      ? true
                      : false;
    }
    auto elmType = tileType.getElementType();
    VectorType newType = VectorType::get(1, i32Type);
    std::string funcName;
    if constexpr (isPrefetch) {
      funcName = "llvm.genx.raw.send2.noresult.i1.v8i32";
    } else {
      VectorType vecType;
      if constexpr (isLoad) {
        vecType = cast<VectorType>(op.getResult().getType());
        funcName = "llvm.genx.raw.send2.";
      } else {
        vecType = cast<VectorType>(op.getValue().getType());
        funcName = "llvm.genx.raw.sends2.noresult.i1.v8i32.";
      }
      std::string typeStr;
      std::tie(typeStr, newType) =
          encodeVectorType(rewriter, vecType, rank == 1);
      funcName += typeStr;
    }
    unsigned cacheHint = encodeCacheHint(op);

    /// fill in parameters for raw.send
    // bit[1:0] EOT,sendc
    auto modifier = createIntConstant(i8Type, 0);
    auto execSize = createIntConstant(i8Type, 0);
    auto pred = createIntConstant(i1Type, 1);
    auto numSrc1 = createIntConstant(i8Type, 1);
    unsigned numDstVal = newType.getNumElements() / 16;
    if (rank == 1) {
      numDstVal *= 2;
    }
    // numDstVal is represented using only 5 bits in the raw_send message.
    // So, value 32 is represented as 31 and data port hardware derives the
    // correct destination length based on message parameters.
    if (numDstVal == 32)
      numDstVal = 31;
    auto numDst = createIntConstant(i8Type, numDstVal);
    // 15 for ugm
    auto sfid = createIntConstant(i8Type, 15);
    auto extMsg = createIntConstant(i32Type, 0);
    auto dataSize2D = (encodeDataum(elmType) - 1);
    auto payLoad = adaptor.getTensorDesc();

    // TODO: currently limit transposeBitWidth to 32, it is
    // an architecture feature, and 32 works on PVC.
    // To support other bits, we cannot hardcode
    // with i32Type, and need to generalize the logic.
    auto loadOp = llvm::dyn_cast<xegpu::LoadNdOp>(op.getOperation());
    if (loadOp && transpose && loadOp.getTransposeBitWidth() == 32) {
      // in raw_send msg set vnni effect to false and update data size of
      // payload item to 32 bits
      vnni = false;
      dataSize2D = (encodeDataum(i32Type) - 1);

      // we also need to update the payload (address descriptor) to reflect that
      // now we are viewing the memref and tile in 32 bit data type not original
      // type. This requires updaing the offsetX (row dim offset) and block
      // width (divide the value by vnni factor).
      auto vnniFactor = 32 / elmType.getIntOrFloatBitWidth();
      auto getLog2OfVnniFactor = [&]() -> unsigned {
        if (vnniFactor == 2)
          return 1;
        else if (vnniFactor == 4)
          return 2;
        else
          assert(false && "invalid vnni Factor!");
      };
      auto oldOffsetX = rewriter.create<vector::ExtractOp>(loc, payLoad, 5);
      // do an aritmetic right shift instead of divide.
      auto newOffsetX = rewriter.create<arith::ShRUIOp>(
          loc, oldOffsetX, createIntConstant(i32Type, getLog2OfVnniFactor()));
      payLoad = rewriter.create<vector::InsertOp>(loc, newOffsetX, payLoad, 5);
      int array_length = op.getTensorDescType().getArrayLength();
      unsigned blockVal = (array_length - 1) << 16;
      auto blockWidth = tileType.getShape()[1];
      auto blockHeight = tileType.getShape()[0];
      auto newBlockWidth = blockWidth / vnniFactor;
      blockVal |= ((blockHeight - 1) << 8) | (newBlockWidth - 1);
      auto blockInfo = createIntConstant(i32Type, blockVal);
      payLoad = rewriter.create<vector::InsertOp>(loc, blockInfo, payLoad, 7);
    }
    // message descriptor
    uint32_t rawSendMsg = 0;
    if (rank == 2) {
      rawSendMsg |= (isLoad || isPrefetch) ? 3 : 7;
      rawSendMsg |= (vnni ? 1 : 0) << 7;
      rawSendMsg |= dataSize2D << 9;
      rawSendMsg |= (transpose ? 1 : 0) << 15;
      rawSendMsg |= cacheHint << 17;
      rawSendMsg |= (isLoad ? numDstVal : 0) << 20;
      rawSendMsg |= 1 << 25;
    } else {
      // rank == 1
      rawSendMsg |= (isLoad || isPrefetch) ? 0 : 4;
      rawSendMsg |= 3 << 7;
      rawSendMsg |= 3 << 9;
      rawSendMsg |= int(log2(newType.getNumElements()) + 1) << 12;
      rawSendMsg |= 1 << 15;
      rawSendMsg |= cacheHint << 17;
      rawSendMsg |= (isLoad ? 2 * numDstVal : 0) << 20;
      rawSendMsg |= 1 << 25;
    }
    auto msg = createIntConstant(i32Type, rawSendMsg);

    SmallVector<Value> args{modifier, execSize, pred, numSrc1, numDst,
                            sfid,     extMsg,   msg,  payLoad};
    if constexpr (isLoad) {
      funcName += ".i1.v8i32";
      auto elementTy = newType.getElementType();
      Attribute initValueAttr;
      if (isa<FloatType>(elementTy))
        initValueAttr = FloatAttr::get(elementTy, 0.0);
      else
        initValueAttr = IntegerAttr::get(elementTy, 0);
      Value old = rewriter.create<arith::ConstantOp>(
          loc, DenseElementsAttr::get(newType, initValueAttr));

      args.push_back(old);
      auto retType = newType;
      auto funcOp = createFuncCall(rewriter, loc, funcName, TypeRange{retType},
                                   args, false);
      if (rank == 2) {
        rewriter.replaceOp(op, funcOp);
      } else {
        auto cast = rewriter.create<vector::BitCastOp>(loc, op.getType(),
                                                       funcOp->getResult(0));
        rewriter.replaceOp(op, cast);
      }
    } else {
      if constexpr (isPrefetch)
        args.erase(args.begin() + 4);
      else {
        if (rank == 2) {
          args.push_back(adaptor.getValue());
        } else if (rank == 1) {
          auto cast = rewriter.create<vector::BitCastOp>(loc, newType,
                                                         adaptor.getValue());
          args.push_back(cast);
        }
      }
      createFuncCall(rewriter, loc, funcName, TypeRange{}, args, false);
      rewriter.eraseOp(op);
    }
    return success();
  }
};

struct DpasPattern : public OpConversionPattern<::mlir::xegpu::DpasOp> {
  using OpConversionPattern<::mlir::xegpu::DpasOp>::OpConversionPattern;

  LogicalResult
  matchAndRewrite(xegpu::DpasOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {

    auto loc = op.getLoc();
    auto lhsType = mlir::cast<VectorType>(op.getLhs().getType());
    auto rhsType = mlir::cast<VectorType>(op.getRhs().getType());
    auto resultType = mlir::cast<VectorType>(op.getResultType());
    uint8_t rc = lhsType.getShape()[0];
    uint8_t sd = lhsType.getShape()[1];
    auto encodePrecision = [&](Type type) -> uint8_t {
      if (type == rewriter.getBF16Type())
        return 9;
      else if (type == rewriter.getF16Type())
        return 10;
      else if (type == rewriter.getTF32Type())
        return 12;
      else {
        assert(0 && "add more support");
        return 0;
      }
    };
    uint8_t prec1 = encodePrecision(rhsType.getElementType());
    uint8_t prec2 = encodePrecision(lhsType.getElementType());
    unsigned infoVal = (rc << 24) | (sd << 16) | (prec2 << 8) | (prec1);
    auto infoAttr = rewriter.getIntegerAttr(rewriter.getI32Type(), infoVal);
    auto info = rewriter.create<arith::ConstantOp>(loc, rewriter.getI32Type(),
                                                   infoAttr);
    auto newResultType = encodeVectorType(rewriter, resultType).second;
    SmallVector<Value, 4> args{adaptor.getRhs(), adaptor.getLhs(), info};
    std::string funcName = "llvm.genx.dpas.nosrc0.";
    if (op.getAcc()) {
      funcName = "llvm.genx.dpas2.";
      auto i32Type = rewriter.getI32Type();
      auto createIntConstant = [&](Type type, unsigned value) {
        auto attr = rewriter.getIntegerAttr(type, value);
        return rewriter.create<arith::ConstantOp>(loc, type, attr);
      };
      auto prec1Arg = createIntConstant(i32Type, prec1);
      auto prec2Arg = createIntConstant(i32Type, prec2);
      auto sdArg = createIntConstant(i32Type, sd);
      auto rcArg = createIntConstant(i32Type, rc);
      auto signless = createIntConstant(i32Type, 0);
      args.assign({adaptor.getAcc(), adaptor.getRhs(), adaptor.getLhs(),
                   prec1Arg, prec2Arg, sdArg, rcArg, signless, signless});
    }
    funcName += encodeVectorType(rewriter, resultType).first;
    funcName += ".";
    funcName += encodeVectorType(rewriter, rhsType).first;
    funcName += ".";
    funcName += encodeVectorType(rewriter, lhsType).first;
    auto funcOp = createFuncCall(rewriter, loc, funcName,
                                 TypeRange{newResultType}, args, false);
    auto newcast = rewriter.create<vector::ShapeCastOp>(loc, resultType,
                                                        funcOp.getResult(0));
    rewriter.replaceOp(op, newcast);
    return success();
  }
};

template <typename OpType>
class GatherScatterToRawSend : public OpConversionPattern<OpType> {
  using OpConversionPattern<OpType>::OpConversionPattern;

  LogicalResult
  matchAndRewrite(OpType op, typename OpType::Adaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {

    auto tileType = op.getTensorDesc().getType();
    auto rank = tileType.getRank();
    assert(rank <= 2 && "only support 1d/2d for now");
    auto loc = op->getLoc();
    constexpr bool isLoad = std::is_same_v<OpType, xegpu::LoadGatherOp>;
    auto createIntConstant = [&](Type type, unsigned value) {
      auto attr = rewriter.getIntegerAttr(type, value);
      return rewriter.create<arith::ConstantOp>(loc, type, attr);
    };

    /// collect common info
    auto i1Type = rewriter.getI1Type();
    auto i8Type = rewriter.getI8Type();
    auto i32Type = rewriter.getI32Type();
    auto i64Type = rewriter.getI64Type();
    auto v4i64 = VectorType::get(4, i64Type);
    auto tensorDesc = adaptor.getTensorDesc();
    tensorDesc = rewriter.create<vector::BitCastOp>(loc, v4i64, tensorDesc);
    auto base = rewriter.create<vector::ExtractOp>(loc, tensorDesc, 0);
    VectorType newType = VectorType::get(1, i32Type);
    std::string funcName;
    VectorType vecType;
    if constexpr (isLoad) {
      vecType = cast<VectorType>(op.getResult().getType());
      funcName = "llvm.genx.raw.send2.";
    } else {
      vecType = cast<VectorType>(op.getValue().getType());
      funcName = "llvm.genx.raw.sends2.noresult.i1.v8i32.";
    }
    std::string typeStr;
    std::tie(typeStr, newType) = encodeVectorType(rewriter, vecType);
    funcName += typeStr;
    unsigned cacheHint = encodeCacheHint(op);

    /// fill in parameters for raw.send
    // bit[1:0] EOT,sendc
    auto modifier = createIntConstant(i8Type, 0);
    auto execSize = createIntConstant(i8Type, 4);
    auto pred = createIntConstant(i1Type, 1);
    auto numSrc1 = createIntConstant(i8Type, 2);
    unsigned numDstVal = newType.getNumElements() / 16;
    auto numDst = createIntConstant(i8Type, numDstVal);
    // 15 for ugm
    auto sfid = createIntConstant(i8Type, 15);
    auto extMsg = createIntConstant(i32Type, 0);
    auto vecSize = 0;
    if (numDstVal <= 4) {
      vecSize = numDstVal - 1;
    } else {
      vecSize = log2(numDstVal) + 1;
    }
    // message descriptor
    uint32_t rawSendMsg = 0;
    rawSendMsg |= (isLoad) ? 0 : 4;
    rawSendMsg |= 3 << 7; // A64
    rawSendMsg |= 2 << 9; // D32
    rawSendMsg |= vecSize << 12;
    rawSendMsg |= cacheHint << 17;
    rawSendMsg |= (isLoad ? numDstVal : 0) << 20;
    rawSendMsg |= 2 << 25;
    auto msg = createIntConstant(i32Type, rawSendMsg);
    // payload
    auto v16i64 = VectorType::get(16, i64Type);
    Value payLoad = rewriter.create<arith::ConstantOp>(
        loc, DenseElementsAttr::get(
                 v16i64, IntegerAttr::get(v16i64.getElementType(), 0)));
    payLoad = rewriter.create<vector::InsertOp>(loc, base, payLoad, 0);
    SmallVector<int64_t, 16> indices(16, 0);
    payLoad = rewriter.create<mlir::vector::ShuffleOp>(
        loc, payLoad, payLoad, rewriter.getI64ArrayAttr(indices));
    auto createDescOp =
        op.getTensorDesc().template getDefiningOp<xegpu::CreateDescOp>();
    auto offsets = rewriter.getRemappedValue(createDescOp.getOffsets());
    payLoad = rewriter.create<arith::AddIOp>(loc, payLoad, offsets);
    SmallVector<Value> args{modifier, execSize, pred, numSrc1, numDst,
                            sfid,     extMsg,   msg,  payLoad};
    if constexpr (isLoad) {
      funcName += ".i1.v16i64";
      auto elementTy = newType.getElementType();
      Attribute initValueAttr;
      if (isa<FloatType>(elementTy))
        initValueAttr = FloatAttr::get(elementTy, 0.0);
      else
        initValueAttr = IntegerAttr::get(elementTy, 0);

      Value old = rewriter.create<arith::ConstantOp>(
          loc, DenseElementsAttr::get(newType, initValueAttr));
      args.push_back(old);
      auto retType = newType;
      auto funcOp = createFuncCall(rewriter, loc, funcName, TypeRange{retType},
                                   args, false);

      auto *converter = this->getTypeConverter();
      auto castTy = converter->convertType(op.getType());
      auto cast =
          rewriter.create<vector::BitCastOp>(loc, castTy, funcOp->getResult(0));
      rewriter.replaceOp(op, cast);
    } else {
      Value data = adaptor.getValue();
      if (data.getType() != newType) {
        data = rewriter.create<vector::BitCastOp>(loc, newType, data);
      }
      args.push_back(data);
      createFuncCall(rewriter, loc, funcName, TypeRange{}, args, false);
      rewriter.eraseOp(op);
    }
    return success();
  }
};

class AtomicToLsc : public OpConversionPattern<::mlir::xegpu::AtomicRMWOp> {
public:
  using OpConversionPattern<::mlir::xegpu::AtomicRMWOp>::OpConversionPattern;
  LogicalResult
  matchAndRewrite(xegpu::AtomicRMWOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    auto tileType = op.getTensorDesc().getType();
    auto rank = tileType.getRank();
    assert(rank <= 2 && "only support 1d/2d for now");
    auto loc = op->getLoc();
    auto createIntConstant = [&](Type type, unsigned value) {
      auto attr = rewriter.getIntegerAttr(type, value);
      return rewriter.create<arith::ConstantOp>(loc, type, attr);
    };

    /// collect common info
    auto i1Type = rewriter.getI1Type();
    auto i8Type = rewriter.getI8Type();
    auto i16Type = rewriter.getI16Type();
    auto i32Type = rewriter.getI32Type();
    auto i64Type = rewriter.getI64Type();
    auto v4i64 = VectorType::get(4, i64Type);
    VectorType vecType = cast<VectorType>(op.getResult().getType());
    std::string funcName = "llvm.genx.lsc.xatomic.stateless.";
    auto [typeStr, newType] = encodeVectorType(rewriter, vecType, false, true);
    funcName += typeStr;

    /// fill in parameters for lsc
    auto v16i1 = VectorType::get(16, i1Type);
    auto vecAttr = DenseElementsAttr::get(v16i1, true);
    auto pred = rewriter.create<arith::ConstantOp>(loc, v16i1, vecAttr);
    auto subOpcode = createIntConstant(i8Type, encodeOpcode(op.getKind()));
    auto l1CacheHint = createIntConstant(i8Type, 1);
    auto l3CacheHint = createIntConstant(i8Type, 1);
    auto addrScale = createIntConstant(i16Type, 1);
    auto immOffset = createIntConstant(i32Type, 0);
    unsigned dataSize = encodeDataum(vecType.getElementType());
    auto dataumSize = createIntConstant(i8Type, dataSize);
    unsigned numDstVal = newType.getNumElements() / 16;
    auto lscVecSize = 0;
    if (numDstVal <= 4) {
      lscVecSize = numDstVal;
    } else {
      lscVecSize = log2(numDstVal) + 2;
    }
    auto vecSize = createIntConstant(i8Type, lscVecSize);
    auto transposed = createIntConstant(i8Type, 1);
    auto mask = createIntConstant(i8Type, 0);

    auto tensorDesc = adaptor.getTensorDesc();
    tensorDesc = rewriter.create<vector::BitCastOp>(loc, v4i64, tensorDesc);
    auto base = rewriter.create<vector::ExtractOp>(loc, tensorDesc, 0);
    // payload
    auto v16i64 = VectorType::get(16, i64Type);
    Value payLoad = rewriter.create<arith::ConstantOp>(
        loc, DenseElementsAttr::get(
                 v16i64, IntegerAttr::get(v16i64.getElementType(), 0)));

    payLoad = rewriter.create<vector::InsertOp>(loc, base, payLoad, 0);

    SmallVector<int64_t, 16> indices(16, 0);
    payLoad = rewriter.create<mlir::vector::ShuffleOp>(
        loc, payLoad, payLoad, rewriter.getI64ArrayAttr(indices));
    auto createDescOp = op.getTensorDesc().getDefiningOp<xegpu::CreateDescOp>();
    auto offsets = rewriter.getRemappedValue(createDescOp.getOffsets());
    payLoad = rewriter.create<arith::AddIOp>(loc, payLoad, offsets);
    // src
    auto v16i32 = VectorType::get(16, i32Type);
    Value undef = rewriter.create<arith::ConstantOp>(
        loc, DenseElementsAttr::get(
                 v16i32, IntegerAttr::get(v16i32.getElementType(), 0)));
    Value src0 = undef;
    if (op.getValue()) {
      src0 = op.getValue();
      if (src0.getType() != newType) {
        src0 = rewriter.create<vector::BitCastOp>(loc, newType, src0);
      }
    }
    Value src1 = undef;
    auto surface = createIntConstant(i32Type, 0);
    SmallVector<Value> args{pred,       subOpcode, l1CacheHint, l3CacheHint,
                            addrScale,  immOffset, dataumSize,  vecSize,
                            transposed, mask,      payLoad,     src0,
                            src1,       surface,   undef};
    funcName += ".v16i1.v16i64";
    auto retType = newType;
    auto newOp = createFuncCall(rewriter, loc, funcName, TypeRange{retType},
                                args, false);

    auto *converter = this->getTypeConverter();
    auto castTy = converter->convertType(op.getType());
    auto cast =
        rewriter.create<vector::BitCastOp>(loc, castTy, newOp->getResult(0));
    rewriter.replaceOp(op, cast);
    return success();
  }
};

// TODO: enable this later
// class AllocNbarrierToVCPattern : public OpConversionPattern<AllocNbarrierOp>
// { public:
//   using OpConversionPattern<AllocNbarrierOp>::OpConversionPattern;
//   LogicalResult
//   matchAndRewrite(AllocNbarrierOp op, OpAdaptor adaptor,
//                   ConversionPatternRewriter &rewriter) const override {
//     OpBuilder::InsertionGuard guard(rewriter);
//     auto func = op->getParentOfType<spirv::FuncOp>();
//     rewriter.setInsertionPointAfter(func);
//     rewriter.create<spirv::ExecutionModeOp>(
//         op.getLoc(), func, spirv::ExecutionMode::NamedBarrierCountINTEL,
//         op.getNbarrierNum());
//     rewriter.eraseOp(op);
//     return success();
//   }
// };

static Value createConstantI32(Location loc, PatternRewriter &rewriter,
                               int32_t v) {
  auto i32ty = rewriter.getIntegerType(32);
  return rewriter.create<arith::ConstantOp>(loc, i32ty,
                                            IntegerAttr::get(i32ty, v));
}

#define zext(...) rewriter.create<arith::ExtUIOp>(loc, __VA_ARGS__)
#define logic_shl(...) rewriter.create<arith::ShLIOp>(loc, __VA_ARGS__)
#define bitwise_or(...) rewriter.create<arith::OrIOp>(loc, __VA_ARGS__)
#define bitwise_and(...) rewriter.create<arith::AndIOp>(loc, __VA_ARGS__)
#define i32_val(...) createConstantI32(loc, rewriter, __VA_ARGS__)
#define i8_val(value)                                                          \
  rewriter.create<arith::ConstantOp>(loc, rewriter.getIntegerType(8),          \
                                     rewriter.getI8IntegerAttr(value))
#define i1_val(value)                                                          \
  rewriter.create<arith::ConstantOp>(loc, rewriter.getI1Type(),                \
                                     rewriter.getBoolAttr(value))

class InitNbarrierToVCPattern
    : public OpConversionPattern<::mlir::xegpu::InitNbarrierOp> {
public:
  using OpConversionPattern<::mlir::xegpu::InitNbarrierOp>::OpConversionPattern;
  LogicalResult
  matchAndRewrite(xegpu::InitNbarrierOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    auto i32Type = rewriter.getIntegerType(32);
    auto v8i32Type = mlir::VectorType::get(8, i32Type);

    auto loc = op.getLoc();
    auto nbarrier_id = op.getNbarrierId();

    // a participant is both a producer or a consumer (0)
    auto nbarrier_role = rewriter.create<arith::ConstantOp>(
        loc, i32Type, rewriter.getI32IntegerAttr(0));
    auto num_participants = zext(i32Type, op.getParticipantThreadNum());

    DenseElementsAttr constantData = DenseElementsAttr::get(
        v8i32Type, ArrayRef<int>(std::vector<int>(1, 0)));
    Value nbarrier_src =
        rewriter.create<arith::ConstantOp>(loc, v8i32Type, constantData);

    Value payload = zext(i32Type, nbarrier_id);

    Value payload_nbarrier_role =
        logic_shl(i32Type, nbarrier_role, i32_val(14));
    payload = bitwise_or(i32Type, payload, payload_nbarrier_role);

    Value payload_num_producers =
        logic_shl(i32Type, num_participants, i32_val(16));
    payload = bitwise_or(i32Type, payload, payload_num_producers);

    Value payload_num_consumers =
        logic_shl(i32Type, num_participants, i32_val(24));
    payload = bitwise_or(i32Type, payload, payload_num_consumers);

    nbarrier_src =
        rewriter.create<vector::InsertOp>(loc, nbarrier_src, payload, 2);
    rewriter.replaceOp(op, nbarrier_src);

    return success();
  }
};

class NbarrierArriveToVCPattern
    : public OpConversionPattern<::mlir::xegpu::NbarrierArriveOp> {
public:
  using OpConversionPattern<
      ::mlir::xegpu::NbarrierArriveOp>::OpConversionPattern;
  LogicalResult
  matchAndRewrite(xegpu::NbarrierArriveOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    auto loc = op.getLoc();
    auto payload = adaptor.getNbarrier();

    std::string funcName = "llvm.genx.raw.send2.noresult.i1.v8i32";

    // desc format
    Value modifier = i8_val(0);
    Value exec_size = i8_val(0);
    Value predicate = i1_val(1);
    Value numsrc1 = i8_val(1); // register nums of payload
    Value sfid = i8_val(3);
    Value etDesc = i32_val(0);
    Value msg_desc = i32_val(0x2000004);

    SmallVector<Value> args{modifier, exec_size, predicate, numsrc1,
                            sfid,     etDesc,    msg_desc,  payload};

    createFuncCall(rewriter, loc, funcName, TypeRange{}, args, false);

    rewriter.eraseOp(op);
    return success();
  }
};

class NbarrierWaitToVCPattern
    : public OpConversionPattern<::mlir::xegpu::NbarrierWaitOp> {
public:
  using OpConversionPattern<::mlir::xegpu::NbarrierWaitOp>::OpConversionPattern;
  LogicalResult
  matchAndRewrite(xegpu::NbarrierWaitOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    auto loc = op.getLoc();
    auto payload = adaptor.getNbarrier();

    auto i8Type = rewriter.getIntegerType(8);
    auto i32Type = rewriter.getIntegerType(32);
    auto nbarrier_src = rewriter.create<vector::ExtractOp>(loc, payload, 2);
    auto nbarrier_id =
        zext(i8Type, bitwise_and(i32Type, nbarrier_src, i32_val(0xFF)));

    Value signal_flag = i8_val(0); // 0b0: wait 0b1: signal
    Value num_threads = i8_val(0); // This field is ignored for nbarrier.wait

    std::string funcName = "llvm.genx.nbarrier";
    SmallVector<Value> args{signal_flag, nbarrier_id, num_threads};

    createFuncCall(rewriter, loc, funcName, TypeRange{}, args, false);
    rewriter.eraseOp(op);
    return success();
  }
};

class CompilerHintToVCPattern
    : public OpConversionPattern<mlir::xegpu::CompileHintOp> {
public:
  using OpConversionPattern<mlir::xegpu::CompileHintOp>::OpConversionPattern;
  LogicalResult
  matchAndRewrite(mlir::xegpu::CompileHintOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    auto loc = op.getLoc();

    std::string funcName = "llvm.genx.fence";
    Value fence_flag = i8_val(-128);
    SmallVector<Value> args{fence_flag};

    createFuncCall(rewriter, loc, funcName, TypeRange{}, args, false);
    rewriter.eraseOp(op);
    return success();
  }
};

class FenceToVCPattern : public OpConversionPattern<::mlir::xegpu::FenceOp> {
public:
  using OpConversionPattern<::mlir::xegpu::FenceOp>::OpConversionPattern;
  LogicalResult
  matchAndRewrite(xegpu::FenceOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    auto loc = op.getLoc();
    auto pred = i1_val(1);
    uint8_t fence_op, sfid, fence_scope;

    enum lscFenceOp {
      NONE = 0,
      EVICT = 1,
      INVALIDATE = 2,
      DISCARD = 3,
      CLEAN = 4,
      FLUSHL3 = 5
    };
    enum lscFenceScope {
      GROUP = 0,
      LOCAL = 1,
      TILE = 2,
      GPU = 3,
      GPUS = 4,
      SYSTEM = 5,
      SYSACQ = 6
    };
    enum lscSFID { UGM = 0, UGML = 1, TGM = 3, SLM = 4 };

    // the design limits the fence_op to NONE
    fence_op = lscFenceOp::NONE;

    switch (op.getMemoryKind()) {
    case mlir::xegpu::MemoryScope::Global:
      sfid = lscSFID::UGM;
      break;
    case mlir::xegpu::MemoryScope::SLM:
      sfid = lscSFID::TGM;
      break;
    default:
      llvm_unreachable("unsupported value for memory_kind attribute");
      break;
    }

    switch (op.getFenceScope()) {
    case mlir::xegpu::FenceScope::Workgroup:
      fence_scope = lscFenceScope::GROUP;
      break;
    case mlir::xegpu::FenceScope::GPU:
      fence_scope = lscFenceScope::GPU;
      break;
    default:
      llvm_unreachable("unsupported value for fence_scope attribute");
      break;
    }

    SmallVector<Value> args{pred, i8_val(sfid), i8_val(fence_op),
                            i8_val(fence_scope)};

    std::string funcName = "llvm.genx.lsc.fence.i1";

    createFuncCall(rewriter, loc, funcName, TypeRange{}, args, false);
    rewriter.eraseOp(op);
    return success();
  }
};

struct VectorShapeCast final
    : public OpConversionPattern<mlir::vector::ShapeCastOp> {
  using OpConversionPattern<mlir::vector::ShapeCastOp>::OpConversionPattern;

  LogicalResult
  matchAndRewrite(mlir::vector::ShapeCastOp shapeCastOp, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    auto *converter = getTypeConverter();

    Type dstType = converter->convertType(shapeCastOp.getType());

    if (!dstType)
      return failure();
    if (dstType == adaptor.getSource().getType() ||
        shapeCastOp.getResultVectorType().getNumElements() == 1) {
      rewriter.replaceOp(shapeCastOp, adaptor.getSource());
      return success();
    }
    rewriter.replaceOpWithNewOp<vector::BitCastOp>(shapeCastOp, dstType,
                                                   adaptor.getSource());
    return success();
  }
};

struct VectorExtract final
    : public OpConversionPattern<mlir::vector::ExtractOp> {
  using OpConversionPattern<mlir::vector::ExtractOp>::OpConversionPattern;

  LogicalResult
  matchAndRewrite(mlir::vector::ExtractOp extractOp, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {

    auto *converter = getTypeConverter();
    auto dstTy = converter->convertType(extractOp.getType());
    if (!dstTy)
      return failure();

    // dynamic position is not supported
    if (extractOp.hasDynamicPosition())
      return failure();

    auto srcTy = extractOp.getVector().getType();
    auto shape = srcTy.getShape();
    auto size = srcTy.getNumElements();
    auto vec = adaptor.getVector();
    auto vecTy = llvm::dyn_cast_if_present<mlir::VectorType>(vec.getType());

    if (!vecTy)
      return mlir::failure();

    // for some cases of vector types, current VectorType Converter could
    // convert e.g., vector of fp16/bf16 into vector of i32s, so the size
    // and strides is reduced half. (This is partially because load_2d
    // intrinsics handles i32 types for fp16/bf16, and current converter guess
    // the vector type is used by load/store based on the dims of vector shape)
    auto factor = vecTy.getElementType().getIntOrFloatBitWidth() /
                  srcTy.getElementType().getIntOrFloatBitWidth();
    size /= factor;

    // dstTy is vector<2xf16> or f16, and srcTy is <8x16x2xf16>, but vecTy is
    // <128xi32> because src is the result of load. it is a mismatch of ty.
    // This is an issue raised from current desgin of type converter, and
    // needs to be fixed.
    auto ty = llvm::dyn_cast<mlir::VectorType>(dstTy);
    if ((ty && ty.getElementType() != vecTy.getElementType()) ||
        (!ty && dstTy != vecTy.getElementType()))
      return mlir::failure();

    // compute linearized offset
    int64_t linearizedOffset = 0;
    auto offsets = extractOp.getStaticPosition();
    for (auto [i, off] : llvm::enumerate(offsets)) {
      size /= shape[i];
      linearizedOffset += offsets[i] * size;
    }

    if (ty) { // use VectorShuffer for vector result
      llvm::SmallVector<int64_t, 2> indices(size);
      std::iota(indices.begin(), indices.end(), linearizedOffset);
      rewriter.replaceOpWithNewOp<mlir::vector::ShuffleOp>(
          extractOp, vec, vec, rewriter.getI64ArrayAttr(indices));
    } else { // use CompositExtract for scalar result
      rewriter.replaceOpWithNewOp<mlir::vector::ExtractOp>(extractOp, vec,
                                                           linearizedOffset);
    }

    return success();
  }
};

static uint64_t getFirstIntValue(mlir::ArrayAttr attr) {
  return (*attr.getAsValueRange<IntegerAttr>().begin()).getZExtValue();
};

struct VectorExtractStridedSlice final
    : public OpConversionPattern<vector::ExtractStridedSliceOp> {
  using OpConversionPattern<vector::ExtractStridedSliceOp>::OpConversionPattern;
  LogicalResult
  matchAndRewrite(vector::ExtractStridedSliceOp extractOp, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    auto *converter = getTypeConverter();
    auto dstType = converter->convertType(extractOp.getType());
    if (!dstType)
      return failure();

    auto offsets = extractOp.getOffsets().getValue();
    auto sizes = extractOp.getSizes().getValue();
    auto strides = extractOp.getStrides().getValue();

    if (mlir::cast<IntegerAttr>(strides[0]).getInt() != 1)
      return rewriter.notifyMatchFailure(
          extractOp, "Strided slice with stride != 1 is not supported.");

    Value srcVector = adaptor.getOperands().front();

    // Extract vector<1xT> case.
    if (isa<spirv::ScalarType>(dstType)) {
      uint64_t offset = getFirstIntValue(extractOp.getOffsets());
      rewriter.replaceOpWithNewOp<vector::ExtractOp>(extractOp, srcVector,
                                                     offset);
      return success();
    }

    // if kD offsets are specified for nd source vector (n > k), the granularity
    // of the extraction is greater than 1. In this case last (n-k) dimensions
    // form the extraction granularity. example : %0 =
    // vector.extract_strided_slice %src { offsets = [0, 0], sizes = [2, 2],
    // strides = [1, 1]} : vector<4x8x8xf32> to vector<2x2x8xf32>
    // here, extraction granularity is 8.
    int64_t extractSliceLen = 1;
    auto n = extractOp.getSourceVectorType().getRank();
    auto k = (int64_t)offsets.size();
    if (n > k) {
      for (unsigned i = 0; i < n - k; i++) {
        extractSliceLen *= extractOp.getSourceVectorType().getShape()[i + k];
      }
    }

    // get total number of extracted slices
    int64_t nExtractedSlices = 1;
    for (auto size : sizes) {
      nExtractedSlices *= mlir::cast<IntegerAttr>(size).getInt();
    }

    // compute the strides of the source vector considering first k dimensions
    SmallVector<int32_t, 4> sourceStrides(k, extractSliceLen);
    for (int i = k - 2; i >= 0; --i) {
      sourceStrides[i] = sourceStrides[i + 1] *
                         extractOp.getSourceVectorType().getShape()[i + 1];
    }
    // final shuffle indices has nExtractedElems * extractSliceLen elements
    SmallVector<int64_t, 4> indices(nExtractedSlices * extractSliceLen);
    // compute the strides of the extracted kD vector
    SmallVector<int32_t, 4> extractedStrides(k, 1);
    // compute extractedStrides
    for (int i = k - 2; i >= 0; --i) {
      extractedStrides[i] = extractedStrides[i + 1] *
                            mlir::cast<IntegerAttr>(sizes[i + 1]).getInt();
    }
    // iterate over all extracted slices from 0 to nExtractedElems-1
    // and compute the multi-dimensional index and the corresponding linearized
    // index within the source vector
    for (int64_t i = 0; i < nExtractedSlices; ++i) {
      int64_t index = i;
      // compute the corresponding multi-dimensional index
      SmallVector<int32_t, 4> multiDimIndex(k, 0);
      for (int64_t j = 0; j < k; ++j) {
        multiDimIndex[j] = (index / extractedStrides[j]);
        index -= multiDimIndex[j] * extractedStrides[j];
      }
      // compute the corresponding linearized index in the source vector
      // i.e. shift the multiDimIndex by the offsets
      int64_t linearizedIndex = 0;
      for (int64_t j = 0; j < k; ++j) {
        linearizedIndex +=
            (mlir::cast<IntegerAttr>(offsets[j]).getInt() + multiDimIndex[j]) *
            sourceStrides[j];
      }
      // fill the indices array form linearizedIndex to linearizedIndex +
      // sliceLen
      for (int64_t j = 0; j < extractSliceLen; ++j) {
        indices[i * extractSliceLen + j] = linearizedIndex + j;
      }
    }
    // perform a shuffle to extract the kD vector
    rewriter.replaceOpWithNewOp<vector::ShuffleOp>(
        extractOp, srcVector, srcVector, rewriter.getI64ArrayAttr(indices));

    return success();
  }
};

struct VectorShuffle final
    : public OpConversionPattern<mlir::vector::ShuffleOp> {
  using OpConversionPattern<mlir::vector::ShuffleOp>::OpConversionPattern;

  LogicalResult
  matchAndRewrite(vector::ShuffleOp shuffleOp, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    auto *converter = getTypeConverter();

    auto dstType = converter->convertType(shuffleOp.getType());
    if (!dstType)
      return failure();

    auto vec1 = adaptor.getV1();
    auto vec2 = adaptor.getV2();

    int shuffleSliceLen = 1;
    int rank = shuffleOp.getV1().getType().getRank();

    // if rank > 1, we need to do the shuffle in the granularity of slices
    // instead of scalars. Size of the slice is equal to the rank-1 innermost
    // dims. Mask of the shuffle op specifies which slice to take from the
    // outermost dim.
    if (rank > 1) {
      auto shape = shuffleOp.getV1().getType().getShape();
      for (unsigned i = 1; i < shape.size(); i++) {
        shuffleSliceLen *= shape[i];
      }
    }

    // llvm shufflevector does not support  shuffling vectors with
    // unequal sizes. Howver if both vectors are constants this restriction
    // does not apply.
    // FIXME : Currently this only checks for arith::ConstantOp as the operands.
    // Need to use constant analyis for better support.
    bool bothConstants = isa<arith::ConstantOp>(vec1.getDefiningOp()) &&
                         isa<arith::ConstantOp>(vec2.getDefiningOp());
    bool sizeMismatch = shuffleOp.getV1().getType().getShape()[0] !=
                        shuffleOp.getV2().getType().getShape()[0];
    if (!bothConstants && sizeMismatch)
      return rewriter.notifyMatchFailure(
          shuffleOp, "Two source vectors must have equal number of elements.");

    auto mask = shuffleOp.getMask();
    auto totalSize = mask.size() * shuffleSliceLen;

    SmallVector<int64_t, 2> indices(totalSize);
    for (auto [i, value] :
         llvm::enumerate(mask.getAsValueRange<IntegerAttr>())) {

      int32_t v = value.getZExtValue();
      std::iota(indices.begin() + shuffleSliceLen * i,
                indices.begin() + shuffleSliceLen * (i + 1),
                shuffleSliceLen * v);
    }

    rewriter.replaceOpWithNewOp<vector::ShuffleOp>(
        shuffleOp, vec1, vec2, rewriter.getI64ArrayAttr(indices));

    return success();
  }
};

struct SCFForOpBlockVCPattern final
    : public OpConversionPattern<mlir::scf::ForOp> {
  using OpConversionPattern<mlir::scf::ForOp>::OpConversionPattern;

  LogicalResult
  matchAndRewrite(mlir::scf::ForOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {

    llvm::SmallVector<mlir::Value> convertedArgs;

    convertedArgs.append(adaptor.getInitArgs().begin(),
                         adaptor.getInitArgs().end());

    auto newOp = rewriter.create<mlir::scf::ForOp>(
        op.getLoc(), op.getLowerBound(), op.getUpperBound(), op.getStep(),
        convertedArgs);

    TypeConverter::SignatureConversion signatureConverter(
        op.getRegion().getNumArguments());
    for (size_t i = 0; i < op.getRegion().getNumArguments(); i++) {
      signatureConverter.addInputs(i,
                                   newOp.getRegion().getArgument(i).getType());
    }

    rewriter.applySignatureConversion(&op.getRegion(), signatureConverter);

    newOp.getBody()->erase();
    rewriter.inlineRegionBefore(op.getRegion(), newOp.getRegion(),
                                newOp.getRegion().end());
    rewriter.replaceOp(op, newOp.getResults());

    return mlir::success();
  }
};

struct SCFYieldOpVCPattern final
    : public OpConversionPattern<mlir::scf::YieldOp> {
  using OpConversionPattern<mlir::scf::YieldOp>::OpConversionPattern;

  LogicalResult
  matchAndRewrite(mlir::scf::YieldOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {

    auto newOp =
        rewriter.create<mlir::scf::YieldOp>(op.getLoc(), adaptor.getResults());

    rewriter.replaceOp(op, newOp);
    return mlir::success();
  }
};

bool isLegalXeGPUSCFOp(mlir::Operation *op) {
  bool result = true;
  if (llvm::isa<mlir::scf::ForOp>(op)) {
    auto forOp = llvm::cast<mlir::scf::ForOp>(op);
    for (const auto &arg : forOp.getInitArgs()) {
      auto type = arg.getType();
      if (mlir::isa<mlir::VectorType>(type))
        result &= (mlir::cast<mlir::VectorType>(type).getRank() == 1);
    }
  }

  if (llvm::isa<mlir::scf::YieldOp>(op)) {
    auto yieldOp = llvm::cast<mlir::scf::YieldOp>(op);
    for (const auto &arg : yieldOp.getResults()) {
      auto type = arg.getType();

      if (mlir::isa<mlir::VectorType>(type))
        result &= (mlir::cast<mlir::VectorType>(type).getRank() == 1);
    }
  }

  return result;
}

struct XeGPUToVCPass : public ::imex::ConvertXeGPUToVCBase<XeGPUToVCPass> {
  using Base::Base;

  void runOnOperation() override {
    gpu::GPUModuleOp m = getOperation();
    mlir::LLVMTypeConverter typeConverter(&getContext());
    mlir::RewritePatternSet patterns(&getContext());
    mlir::ConversionTarget target(getContext());

    target.addLegalDialect<
        ::mlir::func::FuncDialect, ::mlir::arith::ArithDialect,
        ::mlir::memref::MemRefDialect, ::mlir::vector::VectorDialect>();
    // target.addIllegalDialect<mlir::xegpu::XeGPUDialect>();

    target.addDynamicallyLegalDialect<mlir::scf::SCFDialect>(
        [&](mlir::Operation *op) { return isLegalXeGPUSCFOp(op); });

    target.addIllegalOp<::mlir::vector::ShapeCastOp>();
    target.addIllegalOp<::mlir::vector::ExtractStridedSliceOp>();

    typeConverter.addConversion(
        [&](xegpu::TensorDescType type) -> ::mlir::Type {
          auto i32Type = ::mlir::IntegerType::get(&getContext(), 32);
          return ::mlir::VectorType::get(8, i32Type);
        });

    typeConverter.addConversion([&](::mlir::VectorType type) -> ::mlir::Type {
      // TODO: it looks like needs some improvement for matching upstream
      // passes

      unsigned rank = type.getRank();
      auto elemType = type.getElementType();

      if (llvm::isa<mlir::IndexType>(elemType))
        elemType = mlir::IntegerType::get(&getContext(), 64);

      auto scalarType =
          llvm::dyn_cast_or_null<mlir::spirv::ScalarType>(elemType);
      if (!scalarType) {
        llvm::dbgs() << type
                     << " illegal: cannot convert non-scalar element type\n";
        return nullptr;
      }

      if (rank < 1 || type.getNumElements() == 1)
        return elemType;

      // load2d/store2d is 3-d with vnni format, and 4d with array_length
      // TODO: what if load without any vnni? are we going to transform all
      // fp16/bf16
      auto factor = 32 / elemType.getIntOrFloatBitWidth();
      if ((rank == 3 || rank == 4) && type.getShape()[rank - 1] == factor) {
        elemType = ::mlir::IntegerType::get(&getContext(), 32);
        rank--;
      }

      unsigned sum = 1;
      for (unsigned i = 0; i < rank; i++) {
        sum *= type.getShape()[i];
      }

      return ::mlir::VectorType::get(sum, elemType);
    });

    // TODO: Add AllocNbarrierToVCPattern patterns
    patterns.add<CreateNdDescPattern, CreateDescToVCPattern, DpasPattern,
                 /*AllocNbarrierToVCPattern, */ InitNbarrierToVCPattern,
                 NbarrierArriveToVCPattern, NbarrierWaitToVCPattern,
                 CompilerHintToVCPattern, FenceToVCPattern,
                 UpdateNDOffsetToVCPattern, SCFYieldOpVCPattern>(
        patterns.getContext());
    patterns.add<GatherScatterToRawSend<xegpu::LoadGatherOp>,
                 GatherScatterToRawSend<xegpu::StoreScatterOp>, AtomicToLsc,
                 VectorShapeCast, VectorExtract, VectorExtractStridedSlice,
                 VectorShuffle, SCFForOpBlockVCPattern>(typeConverter,
                                                        patterns.getContext());

    if (this->useRawSend) {
      patterns.add<LoadStorePrefetchNdToRawSendPattern<xegpu::LoadNdOp>,
                   LoadStorePrefetchNdToRawSendPattern<xegpu::StoreNdOp>,
                   LoadStorePrefetchNdToRawSendPattern<xegpu::PrefetchNdOp>>(
          patterns.getContext());
    } else {
      patterns.add<LoadStorePrefetchNdToLscPattern<xegpu::LoadNdOp>,
                   LoadStorePrefetchNdToLscPattern<xegpu::StoreNdOp>,
                   LoadStorePrefetchNdToLscPattern<xegpu::PrefetchNdOp>>(
          patterns.getContext());
    }

    if (failed(applyPartialConversion(m, target, std::move(patterns))))
      return signalPassFailure();
  }
};

std::unique_ptr<::mlir::OperationPass<::mlir::gpu::GPUModuleOp>>
createConvertXeGPUToVCPass() {
  return std::make_unique<XeGPUToVCPass>();
}

} // namespace imex
