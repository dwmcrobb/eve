##==================================================================================================
##  EVE - Expressive Vector Engine
##  Copyright : EVE Project Contributors
##  SPDX-License-Identifier: BSL-1.0
##==================================================================================================
cmake_host_system_information(RESULT os_name QUERY OS_NAME)
if ("${os_name}" STREQUAL "macOS")
  if (EXISTS "/opt/local/bin/cmake")
    set(CMAKE_INSTALL_PREFIX "/opt/local")
  endif()
elseif (EXISTS "/etc/debian_version")
  set(CMAKE_INSTALL_PREFIX "/usr")
endif()


include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "C++20 type-based wrappers around SIMD extensions")

set(MAIN_DEST     "${CMAKE_INSTALL_LIBDIR}/eve")
set(INSTALL_DEST  "${CMAKE_INSTALL_INCLUDEDIR}")
set(DOC_DEST      "${CMAKE_INSTALL_DOCDIR}")
set(CMAKE_DEST    "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}")

message(os_name="${os_name}")
message(CMAKE_INSTALL_LIBDIR="${CMAKE_INSTALL_LIBDIR}")
message(CMAKE_INSTALL_PREFIX="${CMAKE_INSTALL_PREFIX}")
message(CMAKE_MODULE_PATH="${CMAKE_MODULE_PATH}")
message(CMAKE_DEST="${CMAKE_DEST}")

## =================================================================================================
## Exporting target for external use
## =================================================================================================
add_library(eve_lib INTERFACE)
target_include_directories( eve_lib INTERFACE
                            $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
                            $<INSTALL_INTERFACE:${INSTALL_DEST}>
                          )
target_compile_features(eve_lib INTERFACE cxx_std_20)
set_target_properties(eve_lib PROPERTIES EXPORT_NAME eve)
add_library(eve::eve ALIAS eve_lib)

write_basic_package_version_file( "${CMAKE_CURRENT_BINARY_DIR}/eve-config-version.cmake"
                                  VERSION "${EVE_VERSION}"
                                  COMPATIBILITY ExactVersion
                                  ARCH_INDEPENDENT
                                )

## ============================================================================
## Create eve.pc for pkg-config.
## ============================================================================
configure_file("${PROJECT_SOURCE_DIR}/cmake/eve.pc.in" "${PROJECT_SOURCE_DIR}/cmake/eve.pc" @ONLY)

## ============================================================================
## Figure out where we should install eve.pc for pkg-config.
## ============================================================================
execute_process(COMMAND pkg-config --variable=pc_path pkg-config OUTPUT_VARIABLE pc_path)
string(REGEX MATCHALL "[^:]+" pc_path_list "${pc_path}")
list(LENGTH pc_path_list pc_path_list_len)

if (${pc_path_list_len} GREATER 0)
  list(GET pc_path_list 0 PKGCONFIG_PC_DIR)
  file(RELATIVE_PATH PKGCONFIG_PC_DIR "${CMAKE_INSTALL_PREFIX}" "${PKGCONFIG_PC_DIR}")
else()
  set(PKGCONFIG_PC_DIR "${CMAKE_INSTALL_LIBDIR}/pkgconfig")
endif()

## =================================================================================================
## Install target
## =================================================================================================
install(FILES ${PROJECT_SOURCE_DIR}/cmake/eve.pc DESTINATION ${PKGCONFIG_PC_DIR} COMPONENT EVEpkg)
install(TARGETS   eve_lib EXPORT eve-targets                            DESTINATION "${CONFIG_INSTALL_DIR}" COMPONENT EVEpkg   )
install(DIRECTORY ${PROJECT_SOURCE_DIR}/include/eve                     DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}" COMPONENT EVEpkg )
install(FILES     ${PROJECT_SOURCE_DIR}/cmake/eve-config.cmake          DESTINATION "${CMAKE_DEST}" COMPONENT EVEpkg   )
install(FILES     ${CMAKE_CURRENT_BINARY_DIR}/eve-config-version.cmake  DESTINATION "${CMAKE_DEST}" COMPONENT EVEpkg   )
install(FILES     ${PROJECT_SOURCE_DIR}/cmake/eve-multiarch.cmake       DESTINATION "${CMAKE_DEST}" COMPONENT EVEpkg   )
install(FILES     ${PROJECT_SOURCE_DIR}/LICENSE.md                      DESTINATION "${DOC_DEST}" COMPONENT EVEpkg    )
install(EXPORT    eve-targets NAMESPACE "eve::"                         DESTINATION "${CMAKE_DEST}" COMPONENT EVEpkg   )
