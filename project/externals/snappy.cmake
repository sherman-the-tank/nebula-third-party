# Copyright (c) 2019 vesoft inc. All rights reserved.
#
# This source code is licensed under Apache 2.0 License.

set(name snappy)
set(source_dir ${CMAKE_CURRENT_BINARY_DIR}/${name}/source)
ExternalProject_Add(
    ${name}
    URL https://github.com/google/snappy/archive/refs/tags/1.2.1.tar.gz
    URL_HASH MD5=dd6f9b667e69491e1dbf7419bdf68823
    DOWNLOAD_NAME snappy-1.2.1.tar.gz
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/${name}
    TMP_DIR ${BUILD_INFO_DIR}
    STAMP_DIR ${BUILD_INFO_DIR}
    DOWNLOAD_DIR ${DOWNLOAD_DIR}
    SOURCE_DIR ${source_dir}
    CMAKE_ARGS
        ${common_cmake_args}
        -DCMAKE_BUILD_TYPE=Release
        -DSNAPPY_BUILD_TESTS=OFF
        -DSNAPPY_BUILD_BENCHMARKS=OFF
    BUILD_IN_SOURCE 1
    BUILD_COMMAND make -s -j${BUILDING_JOBS_NUM}
    INSTALL_COMMAND make -s install -j${BUILDING_JOBS_NUM}
    LOG_CONFIGURE TRUE
    LOG_BUILD TRUE
    LOG_INSTALL TRUE
)

ExternalProject_Add_Step(${name} clean
    EXCLUDE_FROM_MAIN TRUE
    ALWAYS TRUE
    DEPENDEES configure
    COMMAND make clean -j
    COMMAND rm -f ${BUILD_INFO_DIR}/${name}-build
    WORKING_DIRECTORY ${source_dir}
)

ExternalProject_Add_StepTargets(${name} clean)
