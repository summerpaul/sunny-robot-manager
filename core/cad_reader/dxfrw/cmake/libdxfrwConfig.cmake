get_filename_component(DXFRW_CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)

if(NOT TARGET libdxfrw::libdxfrw)
    include("${DXFRW_CMAKE_DIR}/libdxfrwTargets.cmake")
endif()
