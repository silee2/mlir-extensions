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

include(GenerateExportHeader)

set(IMEX_UTILS_SOURCES_LIST
    imex_utils.cpp
    )

add_library(imex_utils SHARED ${IMEX_UTILS_SOURCES_LIST})
generate_export_header(imex_utils)

target_include_directories(imex_utils PRIVATE
    ${CMAKE_CURRENT_BINARY_DIR}
    )

if(IMEX_ENABLE_IGPU_DIALECT)
    set(IGPU_RUNTIME_SOURCES_LIST
        igpu_runtime.cpp
    )
    set(IGPU_RUNTIME_HEADERS_LIST
        level_zero_printing.hpp
        level_zero_wrapper.hpp
    )

    add_library(igpu_runtime SHARED ${IGPU_RUNTIME_SOURCES_LIST} ${IGPU_RUNTIME_HEADERS_LIST})
    generate_export_header(igpu_runtime)

    target_include_directories(igpu_runtime PRIVATE
        ${CMAKE_CURRENT_BINARY_DIR}
        ${LevelZero_INCLUDE_DIR}
    )

    target_link_directories(igpu_runtime PRIVATE
        ${LevelZero_LIBRARIES_DIR}
    )

    target_link_libraries(igpu_runtime PRIVATE ${LevelZero_LIBRARY})
endif()
