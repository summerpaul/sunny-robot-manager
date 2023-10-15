cmake_minimum_required(VERSION 3.5)
project(common LANGUAGES CXX)

set(COMMON_HEADER
    Tools.h
    FileReadWrite.h)

set(COMMON_SRC
    Tools.cpp)

add_library(common
    ${COMMON_HEADER}
    ${COMMON_SRC}
    )
qt5_use_modules(common Core Quick)


