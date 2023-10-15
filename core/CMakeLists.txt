cmake_minimum_required(VERSION 3.14)

project(sunny-robot-manager VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

#set(Qt5_DIR "/home/sunnypaul/Qt/5.15.2/gcc_64")
#set(VTK_DIR "usr/local/lib/vtk-9.1")
#set(CMAKE_PREFIX_PATH ${Qt5_DIR} "usr/local/lib")
#set(VTK_DIR $ENV{VTK_DIR})
#include(${VTK_USE_FILE})
find_package(Qt5Core REQUIRED)
find_package(Qt5Gui REQUIRED)
find_package(Qt5Qml REQUIRED)
find_package(Qt5Widgets REQUIRED)
find_package(Qt5Quick REQUIRED)
find_package(Qt53DInput REQUIRED)
find_package(Qt53DQuick REQUIRED)
find_package(Qt53DRender REQUIRED)
find_package(Qt53DQuickRender REQUIRED)

#find_package(PCL REQUIRED COMPONENTS common io)


#find_package(VTK REQUIRED)
QT5_ADD_RESOURCES(RESOURCES_RCC qml.qrc)
set(THIRD_PARTY_DIR ${CMAKE_CURRENT_SOURCE_DIR}/third_party/include)
set(THIRD_PARTY_LIB ${CMAKE_CURRENT_SOURCE_DIR}/third_party/lib)


include_directories(
#    ${PCL_INCLUDE_DIRS}
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${THIRD_PARTY_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/laser_odom_calibration/include
    ${EIGEN3_INCLUDE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/cad_reader
    )
link_directories(
    ${THIRD_PARTY_LIB}
#    ${PCL_LIBRARY_DIRS}
#    ${VTK_LIBRARY_DIRS}
    )
set(PROJECT_SOURCES
    main.cpp
    )

file(GLOB_RECURSE SHADER
    ${CMAKE_CURRENT_SOURCE_DIR}/shader/*
    )
file(GLOB_RECURSE CONFIG
    ${CMAKE_CURRENT_SOURCE_DIR}/config/*
    )


#add_subdirectory(pcd_reader)
add_subdirectory(cad_reader)
add_subdirectory(common)
add_subdirectory(roadmap_manager)
# add_subdirectory(laser_odom_calibration)
# add_subdirectory(proto_message)
#add_subdirectory(communication)
# add_subdirectory(task_manager)

add_executable(sunny-robot-manager
    ${PROJECT_SOURCES}
    ${RESOURCES_RCC}
    ${SHADER}
    ${CONFIG}
    )
target_link_libraries(sunny-robot-manager
    #    pcd_reader
    cad_reader
    common
    roadmap_manager
    # laser_odom_calibration
    # task_manager
    #    ${VTK_LIBRARIES}
    )
target_link_libraries(sunny-robot-manager
                    Qt5::Gui
                    Qt5::Widgets
                    Qt5::Qml
                    Qt5::Quick)
execute_process(
  COMMAND "${CMAKE_COMMAND}" "-E" "create_symlink" ${CMAKE_CURRENT_SOURCE_DIR}/config ${CMAKE_CURRENT_BINARY_DIR}/config
)
