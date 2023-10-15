cmake_minimum_required(VERSION 3.5)
project(cad_reader LANGUAGES CXX)
add_compile_options(-std=c++11)
add_subdirectory(dxfrw)
add_library(cad_reader
    cadreader.h
    cadreader.cpp
    dx_data.h
    dx_iface.h
    dx_iface.cpp
    )
target_link_libraries(cad_reader dxfrw)
qt5_use_modules(cad_reader Core)
