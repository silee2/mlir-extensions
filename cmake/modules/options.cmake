# Copyright 2022 Intel Corporation
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

if(options_cmake_included)
    return()
endif()
set(options_cmake_included true)

option(IMEX_USE_DPNP
    "Use the dpnp Python NumPy-like library for some math functions"
    OFF
)
option(IMEX_ENABLE_IGPU_RUNNER
    "Enable GPU codegen"
    OFF
)
option(IMEX_ENABLE_NUMBA_FE
    "Enable numba-based python frontend"
    OFF
)
option(IMEX_ENABLE_TBB_SUPPORT
    "Enable TBB"
    OFF
)
option(IMEX_ENABLE_TESTS
    "Enable CTests"
    OFF
)
option(IMEX_ENABLE_NUMBA_HOTFIX
    "Enable hotfix for numba dpcomp"
    OFF
)

message(STATUS "IMEX_USE_DPNP ${DPNIMEX_USE_DPNPP_ENABLE}")
message(STATUS "IMEX_ENABLE_IGPU_RUNNER ${IMEX_ENABLE_IGPU_RUNNER}")
message(STATUS "IMEX_ENABLE_TESTS ${IMEX_ENABLE_TESTS}")
message(STATUS "IMEX_ENABLE_NUMBA_FE ${IMEX_ENABLE_NUMBA_FE}")
message(STATUS "IMEX_ENABLE_NUMBA_HOTFIX ${IMEX_ENABLE_NUMBA_HOTFIX}")
message(STATUS "IMEX_ENABLE_TBB_SUPPORT ${IMEX_ENABLE_TBB_SUPPORT}")

