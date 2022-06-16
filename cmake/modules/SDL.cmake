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

if(SDL_cmake_included)
    return()
endif()
set(SDL_cmake_included true)

# SDL
if (CMAKE_SYSTEM_NAME STREQUAL Windows)
    add_compile_options(-GS -D_CRT_SECURE_NO_WARNINGS)
    add_link_options(-DYNAMICBASE -NXCOMPAT -GUARD:CF)
    # add_link_options(-INTEGRITYCHECK) # require signatures of libs, only recommended
endif()
if (CMAKE_SYSTEM_NAME STREQUAL Linux)
    string(CONCAT WARN_FLAGS
        "-Wall "
        "-Wextra "
        "-Winit-self "
        "-Wunused-function "
        "-Wuninitialized "
        "-Wmissing-declarations "
        "-fdiagnostics-color=auto "
        "-Wno-deprecated-declarations "
    )
    string(CONCAT SDL_FLAGS
        "-D_FORTIFY_SOURCE=2 "
        "-Wformat "
        "-Wformat-security "
        "-Werror=format-security "
        "-fno-delete-null-pointer-checks "
        "-fstack-protector-strong  "
        "-fno-strict-overflow "
        "-fstack-clash-protection "
        "-fcf-protection=full "
    )
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${WARN_FLAGS} ${SDL_FLAGS}")
    # add_compile_options(-mcet) # v8.0 and newer # unrecognized command line option '-mcet', only recommended
    add_link_options(-Wl,-z,noexecstack,-z,relro,-z,now)
endif()
if (CMAKE_SYSTEM_NAME STREQUAL Darwin)
    add_compile_options(-D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -Werror=format-security -fno-delete-null-pointer-checks -fstack-protector-strong -fno-strict-overflow -Wall)
    add_compile_options(-fcf-protection=full) # v8.0 and newer
    # add_compile_options(-mcet) # v8.0 and newer # unrecognized command line option '-mcet', only recommended
endif()

