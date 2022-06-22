# Copyright 2021 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

cmake_minimum_required(VERSION 3.20)

project(mlir-extensions)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN 1)

if(POLICY CMP0077)
    cmake_policy(SET CMP0077 NEW)
endif()

if(POLICY CMP0116)
    cmake_policy(SET CMP0116 OLD)
endif()

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules/")

include(SDL)
include(options)

# set(CMAKE_VERBOSE_MAKEFILE on) # enable for debug
macro(apply_llvm_compile_flags target)
    target_compile_definitions(${target} PRIVATE ${LLVM_DEFINITIONS})
endmacro()

if(IMEX_ENABLE_IGPU_RUNNER)
    if(DEFINED ENV{LEVEL_ZERO_VERSION_CHECK_OFF})
        find_package(LevelZero REQUIRED)
    else()
        find_package(LevelZero 1.6 REQUIRED)
    endif()
    add_subdirectory(dpcomp_gpu_runtime)
endif()

if(IMEX_ENABLE_NUMBA_HOTFIX)
    add_definitions(-DIMEX_ENABLE_NUMBA_HOTFIX)
endif()

add_subdirectory(mlir)
add_subdirectory(dpcomp_runtime)
add_subdirectory(tools)

if(IMEX_ENABLE_NUMBA_FE)
    add_subdirectory(numba_dpcomp)
endif()

if(IMEX_ENABLE_TESTS)
    include(CTest)
    add_subdirectory(test)
endif()
