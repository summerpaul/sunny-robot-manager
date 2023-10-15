project(pcd_reader VERSION 0.1 LANGUAGES CXX)
# 读取pcd地图,将


add_library(pcd_reader
    qpointcloudreader.h
    qpointcloudreader.cpp
    qpointcloudgeometry.h
    qpointcloudgeometry.cpp
    qpointcloud.h
    qpointcloud.cpp
    qpointfield.h
    qpointfield.cpp
    )
target_link_libraries(pcd_reader
    ${PCL_LIBRARIES}
    )
qt5_use_modules(pcd_reader Core Qml Widgets Quick 3DCore 3DQuick 3DRender 3DQuickRender)

