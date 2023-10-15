import QtQuick 2.5
import QtQuick.Controls 2.12
import "../Data"
import "../Config"
import "../TaoQuick"

MenuBar {
    property var menubar_canvas_config
    signal openPCDFile()
    signal openCadFile()
    signal openRoadmapFile()
    signal planDebug(bool isDebug)
    signal viewType(int type)
    signal openChassisConfig()
    signal updateCanvas()

    background: Rectangle {
        color: "silver"
    }
    Menu{
        title: "文件"
        MenuItem{
            text: "车辆路网"
            onTriggered: {
                openRoadmapFile()
            }
        }
        MenuItem{
            text: "点云地图"
            onTriggered: {
                openPCDFile()
            }
        }
        MenuItem{
            text: "CAD背景"
            onTriggered: {
                openCadFile()
            }
        }
        MenuItem{
            text:"退出"
            onTriggered: Qt.quit()
        }

    }

    Menu{
        title: "显示"
        CusCheckBox{
            checked: true
            text: "Node id"
            onClicked: {
                menubar_canvas_config.showNodeID = checked
                updateCanvas()
            }
        }
        CusCheckBox{
            text: "Lane id"
            onClicked: {
                menubar_canvas_config.showLaneID = checked
                updateCanvas()
            }
        }
        CusCheckBox{
            text: "定位轨迹"
            onClicked: {
                menubar_canvas_config.showLocationTraj = checked
                updateCanvas()
            }
        }
        CusCheckBox{
            text: "里程计轨迹"
            onClicked: {
                menubar_canvas_config.showOdomTraj = checked
                updateCanvas()
            }
        }
        CusCheckBox{
            text: "激光里程计轨迹"
            onClicked: {

                menubar_canvas_config.showLidarOdomTarj = checked
                updateCanvas()
            }
        }

    }
    Menu{
        id:viewTypeMenu
        title: "模式切换"
        ComboBox{
            model: ["路网绘制", "规划测试","内参标定", "外参标定","自动标定"]
            onDisplayTextChanged: {
                switch(displayText){
                case "路网绘制":
                    viewType(MainConfig.ROUTE_DESIGNER)
                    break;
                case "规划测试":
                    viewType(MainConfig.ROUTE_PLAN)
                    break;
                case "内参标定":
                    viewType(MainConfig.ODOM_CALIBTARION)
                    break;
                case "外参标定":
                    viewType(MainConfig.LIDIAR_CALIBTARION)
                    break;
                case "自动标定":
                    viewType(MainConfig.AUTO_CALIBTARION)
                    break;

                }


            }
        }
    }


}
