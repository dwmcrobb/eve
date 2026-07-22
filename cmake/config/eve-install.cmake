##==================================================================================================
##  EVE - Expressive Vector Engine
##  Copyright : EVE Project Contributors
##  SPDX-License-Identifier: BSL-1.0
##==================================================================================================
cmake_host_system_information(RESULT os_name QUERY OS_NAME)
if ("${os_name}" STREQUAL "Darwin")
  if (EXISTS "/opt/local/bin/cmake")
    set(CMAKE_INSTALL_PREFIX "/opt/local")
  endif()
elseif (EXISTS "/etc/debian_version")
  set(CMAKE_INSTALL_PREFIX "/usr")
endif()


include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

set(MAIN_DEST     "${CMAKE_INSTALL_LIBDIR}/eve")
set(INSTALL_DEST  "${CMAKE_INSTALL_INCLUDEDIR}")
set(DOC_DEST      "${CMAKE_INSTALL_DOCDIR}")
set(CMAKE_DEST    "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}")

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

## =================================================================================================
## Install target with versioned folder
## =================================================================================================
# set(CONFIG_INSTALL_DIR "${CMAKE_INSTALL_LIBDIR}/cmake/eve")
# if (EXISTS "/usr/lib/x86_64-linux-gnu/cmake")
#   set(CONFIG_INSTALL_DIR "/usr/lib/x86_64-linux-gnu/cmake/eve")
# elseif (EXISTS "/usr/lib/aarch64-linux-gnu/cmake")
#   set(CONFIG_INSTALL_DIR "/usr/lib/aarch64-linux-gnu/cmake/eve")
# elseif (EXISTS "/opt/local/lib/cmake")
#   set(CONFIG_INSTALL_DIR "/opt/local/lib/cmake/eve")
# endif()
      
install(TARGETS   eve_lib EXPORT eve-targets                            DESTINATION "${CONFIG_INSTALL_DIR}" COMPONENT EVEpkg   )
install(DIRECTORY ${PROJECT_SOURCE_DIR}/include/eve                     DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}" COMPONENT EVEpkg )
install(FILES     ${PROJECT_SOURCE_DIR}/cmake/eve-config.cmake          DESTINATION "${CMAKE_DEST}" COMPONENT EVEpkg   )
install(FILES     ${CMAKE_CURRENT_BINARY_DIR}/eve-config-version.cmake  DESTINATION "${CMAKE_DEST}" COMPONENT EVEpkg   )
install(FILES     ${PROJECT_SOURCE_DIR}/cmake/eve-multiarch.cmake       DESTINATION "${CMAKE_DEST}" COMPONENT EVEpkg   )
install(FILES     ${PROJECT_SOURCE_DIR}/LICENSE.md                      DESTINATION "${DOC_DEST}" COMPONENT EVEpkg    )
install(EXPORT    eve-targets NAMESPACE "eve::"                         DESTINATION "${CMAKE_DEST}" COMPONENT EVEpkg   )
