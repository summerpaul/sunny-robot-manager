CMAKE_MINIMUM_REQUIRED(VERSION 3.0)

cmake_policy(SET CMP0048 NEW)
project(DXFRW VERSION 1.0.1)

include(GNUInstallDirs)

set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# SOURCE FILES
set(libdxfrw_srcs
    intern/drw_dbg.cpp
    intern/drw_textcodec.cpp
    intern/dwgbuffer.cpp
    intern/dwgreader.cpp
    intern/dwgreader15.cpp
    intern/dwgreader18.cpp
    intern/dwgreader21.cpp
    intern/dwgreader24.cpp
    intern/dwgreader27.cpp
    intern/dwgutil.cpp
    intern/dxfreader.cpp
    intern/dxfwriter.cpp
    intern/rscodec.cpp
    drw_base.cpp
    drw_classes.cpp
    drw_entities.cpp
    drw_header.cpp
    drw_objects.cpp
    libdwgr.cpp
    libdxfrw.cpp
    )

# HEADER FILES
set(libdxfrw_hdrs
    intern/drw_cptable932.h
    intern/drw_cptable936.h
    intern/drw_cptable949.h
    intern/drw_cptable950.h
    intern/drw_cptables.h
    intern/drw_dbg.h
    intern/drw_textcodec.h
    intern/dwgbuffer.h
    intern/dwgreader.h
    intern/dwgreader15.h
    intern/dwgreader18.h
    intern/dwgreader21.h
    intern/dwgreader24.h
    intern/dwgreader27.h
    intern/dwgutil.h
    intern/dxfreader.h
    intern/dxfwriter.h
    intern/rscodec.h
    main_doc.h
    )

set(installdxfrw_hdrs
    drw_base.h
    drw_classes.h
    drw_entities.h
    drw_header.h
    drw_interface.h
    drw_objects.h
    libdwgr.h
    libdxfrw.h
    )

set(LIBDXFRW_INSTALL_INCLUDEDIR ${CMAKE_INSTALL_INCLUDEDIR}/libdxfrw)

add_library(dxfrw ${libdxfrw_srcs} ${libdxfrw_hdrs})
set_target_properties(dxfrw PROPERTIES 
    VERSION "${PROJECT_VERSION}"
    SOVERSION "${PROJECT_VERSION_MAJOR}"
    EXPORT_NAME libdxfrw
    )
target_compile_features(dxfrw PUBLIC cxx_std_11)
target_include_directories(dxfrw
    PUBLIC
    $<INSTALL_INTERFACE:${LIBDXFRW_INSTALL_INCLUDEDIR}>
    )

#add_custom_command(OUTPUT doc/html/index.html
#    COMMAND doxygen ARGS ${CMAKE_CURRENT_SOURCE_DIR}/libdxfrw.dox
#    MAIN_DEPENDENCY ${CMAKE_CURRENT_SOURCE_DIR}/libdxfrw.dox
#    VERBATIM)

#add_custom_target(doc
#    DEPENDS doc/html/index.html)

# add_subdirectory(dwg2dxf)

# INSTALLATION
set(INSTALL_CONFIGDIR ${CMAKE_INSTALL_LIBDIR}/cmake/libdxfrw)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/libdxfrw.pc.in libdxfrw.pc @ONLY)

install(TARGETS dxfrw
    EXPORT libdxfrw-targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    )

install(EXPORT libdxfrw-targets
    FILE libdxfrwTargets.cmake
    NAMESPACE libdxfrw::
    DESTINATION ${INSTALL_CONFIGDIR}
    )

include(CMakePackageConfigHelpers)
configure_package_config_file(${CMAKE_CURRENT_LIST_DIR}/cmake/libdxfrwConfig.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/libdxfrwConfig.cmake
    INSTALL_DESTINATION ${INSTALL_CONFIGDIR}
    )
write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/libdxfrwConfigVersion.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY AnyNewerVersion
    )

install(FILES
    ${installdxfrw_hdrs}
    DESTINATION ${LIBDXFRW_INSTALL_INCLUDEDIR}
    )
install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/libdxfrw.pc
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig
    )
install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/libdxfrwConfig.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/libdxfrwConfigVersion.cmake
    DESTINATION ${INSTALL_CONFIGDIR}
    )
