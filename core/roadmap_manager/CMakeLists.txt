project(roadmap_manager LANGUAGES CXX)

add_subdirectory(route)

add_library(roadmap_manager
    RoadmapJsonTreeModel.h
    BaseListModel.h
    BaseListModel.inl
    RoadmapJsonTreeModel.cpp
    )

target_link_libraries(roadmap_manager
    route
    )


