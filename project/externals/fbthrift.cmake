# Copyright (c) 2019 vesoft inc. All rights reserved.
#
# This source code is licensed under Apache 2.0 License.

set(name fbthrift)
set(source_dir ${CMAKE_CURRENT_BINARY_DIR}/${name}/source)
ExternalProject_Add(
    ${name}
    URL https://github.com/facebook/fbthrift/archive/refs/tags/v${fb_release_tag}.00.tar.gz
    URL_HASH MD5=8021ae5031a1d8d811f09cf99320e047
    DOWNLOAD_NAME fbthrift-${fb_package_name_part}.tar.gz
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/${name}
    TMP_DIR ${BUILD_INFO_DIR}
    STAMP_DIR ${BUILD_INFO_DIR}
    DOWNLOAD_DIR ${DOWNLOAD_DIR}
    SOURCE_DIR ${source_dir}
    CMAKE_COMMAND env PATH=${CMAKE_INSTALL_PREFIX}/bin:$ENV{PATH} ${CMAKE_COMMAND}
    CMAKE_ARGS
        ${common_cmake_args}
        "-DCMAKE_EXE_LINKER_FLAGS=-static-libstdc++ -static-libgcc -Wl,-rpath=\$ORIGIN/../lib:\$ORIGIN/../lib64"
        -DCMAKE_BUILD_TYPE=Release
        -DBoost_NO_BOOST_CMAKE=ON
        -Denable_tests=OFF
        -DOPENSSL_ROOT_DIR=${CMAKE_INSTALL_PREFIX}
        "-DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS} -DGLOG_USE_GLOG_EXPORT ${extra_cpp_flags}"
    BUILD_COMMAND make -s -j${BUILDING_JOBS_NUM}
    BUILD_IN_SOURCE 1
    INSTALL_COMMAND make -s -j${BUILDING_JOBS_NUM} install
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
