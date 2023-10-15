import QtQuick 2.12
import QtQuick.Controls 1.3
import QtQuick.Window 2.12
import Tools 1.0
// import LaserOdomCalibration 1.0
// import TaskManager 1.0
//import QtQuick.Layouts 1.15
import "./qml/BasicComponent"
import "./qml/MainTools"
import "./qml/Calibration"
import "./qml/Config"
import "./qml/Data"
import "./qml/RouteDesign"


Window {
    id:mainWindow
    width: 1600
    height: 900
    visible: true
    color: "#b9bdc6"
    title: qsTr("Sunny Robot Manager")
    property int view_state: MainConfig.VIEWSTATE.ROUTE_DESIGNER//初始化为路网编辑模式

    Rectangle{
        id:left_layout
        width: 220
        anchors.left: parent.left
        anchors.top: toolbar.bottom
        anchors.bottom: statusbar.top
        CaliInput{
            caliCanvasConfig: canvas_config
            onUpdateCanvas: {
                canvas.requestPaint()
            }
            onCaliTask: {
                console.log("set cali task")
                // task_manager.setCaliTask(JSON.parse(caliTask))
            }
            onCollectData: {
                // laser_odom_cali.collectData(isCollect)
            }
            onStartAutoCali: {
                // laser_odom_cali.calibration()

            }
            onCleanCaliData: {
                // laser_odom_cali.cleanCalibrationData()
            }


        }

    }
    Rectangle{
        id:right_layout
        width:300
        anchors{
            top: toolbar.bottom
            bottom: statusbar.top
            right: parent.right
        }
        ChassisInfoView{
            id:chassis_info_view

        }


    }

    property MainMenuBar menubar//窗框的菜单栏
    property RouteDesignToolBar toolbar//窗口的工具栏
    property MainStatusBar statusbar//窗口的状态栏
    property MainCanvas canvas//绘制界面

    //主要的配置与工具
    MessageBox{id:messageBox}//窗口的弹窗警告
    IconConfig{id:icon_config}//与图标相关的资源
    MainConfig{id:main_config}//与通信,软件各种模式相关的配置
    CanvasConfig{id:canvas_config}
    CalibrationConfig{id:cali_config}// 与标定相关的参数(标定的初始值)

    MainFileDialog{id:file_dialog}//打开文件的对话狂
    ConnectDialog{
        id:connect_dialog
        onUpdateVehicleIp: {
            // laser_odom_cali.connect(ip)
            // task_manager.connect(ip)
        }
    }//确定zmq车辆的ip
    CadData{
        id:cad_data
        onUpdateCanvas: {
            canvas.requestPaint()
        }
    }
    RoadmapData{
        id:roadmap_data
        roadmapToolbar:toolbar
        onUpdateCanvas: {
            canvas.requestPaint()
        }
    }//有关路网文件的相关操作

    //主要的界面
    MainMenuBar{
        id:menubar
        menubar_canvas_config:canvas_config
        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
        }
        antialiasing: true
        layer.smooth: true

        onOpenChassisConfig: {
            file_dialog.openFile("车辆底盘配置文件",
                                 ["Json files (*.json)", "Json_ files (*.json_)"],
                                 function (fileUrl) {
                                     let path = Tools.toLocalFile(fileUrl);
                                 })

        }
        onUpdateCanvas: {
            console.log(canvas_config.showLaneID)
            console.log(canvas_config.showLidarOdomTarj)
        }
    }
    RouteDesignToolBar{
        id:toolbar
        toolbarIcon:icon_config
        toolbarCanvasConfig:canvas_config
        toolbarRoadmap:roadmap_data
        anchors{
            top: menubar.bottom
            left: parent.left
            right: parent.right
        }
        onBackToOrigin: {
            canvas.backToOrigin()
        }
        onFollowVehicle: {
            canvas.followVehicle()
        }
        onAddVehiclePoint: {
            var x = canvas_config.locationPose.x
            var y = canvas_config.locationPose.y
            var yaw = canvas_config.locationPose.yaw
            roadmap_data.addPoint(x, y, yaw)
        }
        onUpdateCanvas: {
            canvas.requestPaint()
        }
        onOpenConnectDialog: {
            connect_dialog.open()
        }

        onOpenFile: {
            switch(fileType){
            case MainConfig.ROADMAP:
                file_dialog.openFile("选择一个路网文件",
                                     ["Json files (*.json)", "Json_ files (*.json_)"],
                                     function (fileUrl) {
                                         let path = Tools.toLocalFile(fileUrl);
                                         roadmap_data.loadRoadmapFile(path)
                                     })
                break
            case MainConfig.CAD:
                file_dialog.openFile("选择一个cad文件",
                                     ["dxf files (*.dxf)","dwg files (*.dwg)"],
                                     function (fileUrl) {
                                         let path = Tools.toLocalFile(fileUrl);
                                         cad_data.loadCadFile(path)

                                     })
                break
            }
        }
    }
    MainCanvas{
        id:canvas
        opacity: 1
        canvasConfig:canvas_config
        canvasRoadmapData:roadmap_data
        vehicleModule:cali_config.vehicleModel
        canvasCadData: cad_data
        anchors{
            top: toolbar.bottom
            left: left_layout.right
            right: right_layout.left
            bottom: statusbar.top
        }

    }
    MainStatusBar{
        id :statusbar
        anchors.bottom:  parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

    }
    // TaskManager{
    //     id:task_manager
    //     onUpdateVehiclePose: {
    //         canvas_config.locationPose = jsonPose
    //     }
    //     onConnectError: {
    //         messageBox.showMessage("任务管理模块连接异常", msg)
    //     }
    // }

    // LaserOdomCalibration{
    //     id:laser_odom_cali
    //     onUpdateOdom: {
    //         canvas_config.odomPose = odom
    //         canvas_config.odomTraj.push(odom)
    //         canvas.requestPaint()
    //     }
    //     onUpdateScanOdom: {
    //         canvas_config.lidarOdomPose = scan_odom
    //         canvas_config.lidarOdomTraj.push(scan_odom)
    //         canvas.requestPaint()

    //     }
    //     onUpdteChassisInfo: {
    //         chassis_info_view.updateChassisInfo(chassisInfo)
    //     }

    //     onConnectError: {
    //         messageBox.showMessage("标定模块连接异常", msg)
    //     }
    // }









}
