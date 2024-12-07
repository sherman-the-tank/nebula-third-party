# Copyright (c) 2019 vesoft inc. All rights reserved.
#
# This source code is licensed under Apache 2.0 License.

set(name mvfst)
set(source_dir ${CMAKE_CURRENT_BINARY_DIR}/${name}/source)
ExternalProject_Add(
    ${name}
    URL https://github.com/facebook/mvfst/archive/refs/tags/v${fb_release_tag}.00.tar.gz
    URL_HASH MD5=f975e3ebee0916b24f2dccdbd64e2149
    DOWNLOAD_NAME mvfst-${fb_package_name_part}.tar.gz
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/${name}
    TMP_DIR ${BUILD_INFO_DIR}
    STAMP_DIR ${BUILD_INFO_DIR}
    DOWNLOAD_DIR ${DOWNLOAD_DIR}
    SOURCE_DIR ${source_dir}
    CMAKE_ARGS
        ${common_cmake_args}
        -DBUILD_TESTS=OFF
        -DBoost_NO_BOOST_CMAKE=ON
        -DBUILD_EXAMPLES=OFF
        -DCMAKE_BUILD_TYPE=Release
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
    WORKING_DIRECTORY <SOURCE_DIR>
)

ExternalProject_Add_StepTargets(${name} clean)
