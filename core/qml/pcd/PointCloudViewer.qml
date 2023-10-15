import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Scene3D 2.0
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Extras 2.0
import pcl 1.0
Scene3D{
    id:scene3d
    aspects: ["input", "logic"]
    function reset(){
        camera.position = Qt.vector3d( 0.0, 0.0, 1000 )
        camera.upVector = Qt.vector3d( 0.0, -1.0, 0.0 )
        camera.viewCenter = Qt.vector3d( 0.0, 0.0, 0.0 )

    }
    Entity {
        id: sceneRoot

        Camera {
            id: camera
            projectionType: CameraLens.PerspectiveProjection
            fieldOfView: 45
            aspectRatio: scene3d.width/scene3d.height
            nearPlane : 0.1
            farPlane : 1000.0
            position: Qt.vector3d( 0.0, 0.0, 1000 )
            upVector: Qt.vector3d( 0.0, -1.0, 0.0 )
            viewCenter: Qt.vector3d( 0.0, 0.0, 0.0 )
        }

        //相机的选择,待研究
        FirstPersonCameraController {
            camera: camera
        }

        components: [
            RenderSettings {
                activeFrameGraph: Viewport {
                    id: viewport
                    normalizedRect: Qt.rect(0.0, 0.0, 1.0, 1.0)
                    RenderSurfaceSelector {
                        CameraSelector {
                            id : cameraSelector
                            camera: camera
                            FrustumCulling {
                                ClearBuffers {
                                    buffers : ClearBuffers.ColorDepthBuffer
                                    clearColor: "white"
                                    NoDraw {}
                                }
                                LayerFilter {
                                    layers: pointLayer
                                    RenderStateSet {
                                        renderStates: [DepthTest { depthFunction: DepthTest.Less }]
                                    }
                                }
                            }
                        }
                    }
                }
            },
            InputSettings { }
        ]
        Layer {
            id: pointLayer
        }
        Entity {
            id: pointcloud
            property var pointLayer: Layer{}
            property var meshTransform: Transform {
                id: pointcloudTransform
                scale: 20
                translation: Qt.vector3d(0, -2, 0)
            }
            property GeometryRenderer pointcloudMesh: GeometryRenderer {
                geometry: PointcloudGeometry { pointcloud: readerPcdMap.pointcloud }
                primitiveType: GeometryRenderer.Points
            }
            property Material materialPoint: Material {
                effect: Effect {
                    techniques: Technique {
                        renderPasses: RenderPass {
                            shaderProgram: ShaderProgram {
                                vertexShaderCode: loadSource("qrc:/shader/pointcloud.vert")
                                fragmentShaderCode: loadSource("qrc:/shader/pointcloud.frag")
                            }
                        }
                    }
                }
                parameters: Parameter { name: "pointSize"; value: 0.7 }
            }
            components: [ pointcloudMesh, materialPoint, meshTransform, pointLayer ]
        }

    }
}

