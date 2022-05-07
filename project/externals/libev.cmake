# Copyright (c) 2019 vesoft inc. All rights reserved.
#
# This source code is licensed under Apache 2.0 License.

set(name libev)
set(source_dir ${CMAKE_CURRENT_BINARY_DIR}/${name}/source)
ExternalProject_Add(
    ${name}
# TODO Need to change the url to a valid one
    URL https://github.com/kindy/libev/archive/refs/4.33.tar.gz
    URL_HASH MD5=a3433f23583167081bf4acdd5b01b34f
    DOWNLOAD_NAME libev-4.33.tar.gz
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/${name}
    TMP_DIR ${BUILD_INFO_DIR}
    STAMP_DIR ${BUILD_INFO_DIR}
    DOWNLOAD_DIR ${DOWNLOAD_DIR}
    SOURCE_DIR ${source_dir}
    CONFIGURE_COMMAND
        "env"
        "CC=${CMAKE_C_COMPILER}"
        "CFLAGS=${CMAKE_C_FLAGS} -fPIC -O2"
        "CPPFLAGS=-isystem ${CMAKE_INSTALL_PREFIX}/include"
        "PATH=${BUILDING_PATH}"
        ./configure --prefix=${CMAKE_INSTALL_PREFIX} --enable-static --disable-shared
    BUILD_COMMAND make -s -j${BUILDING_JOBS_NUM}
    BUILD_IN_SOURCE 1
    INSTALL_COMMAND make -s install -j${BUILDING_JOBS_NUM} PREFIX=${CMAKE_INSTALL_PREFIX}
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
