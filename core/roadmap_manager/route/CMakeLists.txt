project(route)

add_subdirectory(graph)
add_library(route
    route.h
    agvpoint.h
    roadmap_data.h
    route.cpp
    agvpoint.cpp)

target_link_libraries(route
    graph
    )
qt5_use_modules(route
    Gui
    Widgets
    Qml
    Quick)

