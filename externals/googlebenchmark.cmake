# Copyright (c) 2019 vesoft inc. All rights reserved.
#
# This source code is licensed under Apache 2.0 License,
# attached with Common Clause Condition 1.0, found in the LICENSES directory.

set(name googlebenchmark)
set(source_dir ${CMAKE_CURRENT_BINARY_DIR}/${name}/source)
ExternalProject_Add(
    ${name}
    URL https://github.com/google/benchmark/archive/v1.5.2.tar.gz
    URL_HASH MD5=084b34aceaeac11a6607d35220ca2efa
    DOWNLOAD_NAME googlebenchmark-1.5.2.tar.gz
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/${name}
    TMP_DIR ${BUILD_INFO_DIR}
    STAMP_DIR ${BUILD_INFO_DIR}
    DOWNLOAD_DIR ${DOWNLOAD_DIR}
    SOURCE_DIR ${source_dir}
    UPDATE_COMMAND ""
    CMAKE_ARGS
        ${common_cmake_args}
        -DBENCHMARK_ENABLE_GTEST_TESTS=OFF
        -DCMAKE_BUILD_TYPE=Release
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
