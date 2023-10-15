import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Extras 2.0

Entity {
    id: root
    property Material material

    PlaneMesh {
        id: groundMesh
        width: 50
        height: width
        meshResolution: Qt.size(2, 2)
    }

    Transform {
        id: groundTransform
        translation: Qt.vector3d(0, -5, 0)
    }

    components: [
        groundMesh,
        groundTransform,
        material
    ]
}
