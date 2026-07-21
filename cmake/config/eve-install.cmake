##==================================================================================================
##  EVE - Expressive Vector Engine
##  Copyright : EVE Project Contributors
##  SPDX-License-Identifier: BSL-1.0
##==================================================================================================
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

set(MAIN_DEST     "${CMAKE_INSTALL_LIBDIR}/eve")
set(INSTALL_DEST  "${CMAKE_INSTALL_INCLUDEDIR}")
set(DOC_DEST      "${CMAKE_INSTALL_DOCDIR}")

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
set(CONFIG_INSTALL_DIR "${CMAKE_INSTALL_LIBDIR}/cmake/eve")

install(TARGETS   eve_lib EXPORT eve-targets                            DESTINATION "${CONFIG_INSTALL_DIR}" COMPONENT EVEpkg   )
install(DIRECTORY ${PROJECT_SOURCE_DIR}/include/eve                     DESTINATION "${INSTALL_DEST}" COMPONENT EVEpkg )
install(FILES     ${PROJECT_SOURCE_DIR}/cmake/eve-config.cmake          DESTINATION "${CONFIG_INSTALL_DIR}" COMPONENT EVEpkg   )
install(FILES     ${CMAKE_CURRENT_BINARY_DIR}/eve-config-version.cmake  DESTINATION "${CONFIG_INSTALL_DIR}" COMPONENT EVEpkg   )
install(FILES     ${PROJECT_SOURCE_DIR}/cmake/eve-multiarch.cmake       DESTINATION "${CONFIG_INSTALL_DIR}" COMPONENT EVEpkg   )
install(FILES     ${PROJECT_SOURCE_DIR}/LICENSE.md                      DESTINATION "${DOC_DEST}" COMPONENT EVEpkg    )
install(EXPORT    eve-targets NAMESPACE "eve::"                         DESTINATION "${CONFIG_INSTALL_DIR}" COMPONENT EVEpkg   )
