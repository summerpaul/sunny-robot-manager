import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import "../BasicComponent"
import "../TaoQuick"
import "../../js/CaliTask.js" as Task
Rectangle {
    id:cali_input
    property var caliCanvasConfig
    property int fontSize: 17
    property double square_length: 0
    property var cali_info: null
    property var simuCali_info: null

    signal caliTask(string caliTask)
    signal collectData(bool isCollect)
    signal startAutoCali()
    signal updateCanvas()
    signal cleanCaliData()


    Grid {
        id:input_grid
        columns: 2
        spacing: 4
        Rectangle{
            height: 20
            width: 50
        }

        Rectangle{
            height: 20
            width:  50
        }

        CusLabel{
            text: " 线速度:"
            font.pixelSize: fontSize
            font.family: qsTr("微软雅黑")
        }
        Rectangle{
            height: 25
            width: 100
            border.color: "black"
            TTextInput{
                id:line_speed_set
                anchors.fill: parent
                text: "0.3"
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
                clip: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                onEditingFinished: {
                    editable = true
                }
            }
        }
        CusLabel{
            text: " 角速度:"
            font.pixelSize: fontSize
            font.family: qsTr("微软雅黑")
        }
        Rectangle{
            height: 25
            width: 100
            border.color: "black"
            TTextInput{
                id:angle_speed_set
                anchors.fill: parent
                text: "0.2"
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
                clip: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                onEditingFinished: {
                    editable = true
                }
            }
        }

        CusLabel{
            text: " 边长/直径:"
            font.pixelSize: fontSize
            font.family: qsTr("微软雅黑")
        }
        Rectangle{
            height: 25
            width: 100
            border.color: "black"
            TTextInput{
                id:line_length_set
                anchors.fill: parent
                text: "2.0"
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
                clip: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                onEditingFinished: {
                    editable = true
                }
            }
        }
        CusLabel{
            text: " 旋转角度"
            font.pixelSize: fontSize
            font.family: qsTr("微软雅黑")
        }
        Rectangle{
            height: 25
            width: 100
            border.color: "black"
            TTextInput{
                id:rotation_angle_set
                anchors.fill: parent
                text: "180"
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
                clip: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                onEditingFinished: {
                    editable = true
                }
            }
        }
        CusLabel{
            text: " 路径类型:"
            font.pixelSize: fontSize
            font.family: qsTr("微软雅黑")
        }
        CusComboBox{
            id:path_type
            height: 30
            width: 100
            model: [ "正方形","直线", "自旋", "圆"]
            font.family: qsTr("微软雅黑")
        }
        CusButton{
            text: "执行任务"
            font.family: qsTr("微软雅黑")
            onClicked: {
                var task = Task.getTask(path_type.displayText,
                                        line_speed_set.displayText*1,
                                        angle_speed_set.displayText*1,
                                        line_length_set.displayText*1,
                                        rotation_angle_set.displayText *1 / 180 * Math.PI
                                        )
                caliTask(JSON.stringify(task))
            }


        }
        Rectangle{
            width: path_type.width
            height: path_type.height

        }
        CusLabel{
            text: " 车轮半径"
            font.pixelSize: fontSize
            font.family: qsTr("微软雅黑")
        }
        Rectangle{
            height: 25
            width: 100
            border.color: "black"
            TTextInput{
                id:wheel_radius_set
                anchors.fill: parent
                text: "180"
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
                clip: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                onEditingFinished: {
                    editable = true
                }
            }
        }

        CusLabel{
            text: " 轮距"
            font.pixelSize: fontSize
            font.family: qsTr("微软雅黑")
        }
        Rectangle{
            height: 25
            width: 100
            border.color: "black"
            TTextInput{
                id:wheel_dist_set
                anchors.fill: parent
                text: "180"
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
                clip: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                onEditingFinished: {
                    editable = true
                }
            }
        }


        CusButton{
            text: "重置里程计"
            font.family: qsTr("微软雅黑")
            onClicked: {
                caliCanvasConfig.odomPose = {"x":0, "y":0, "yaw":0}
                updateCanvas()

            }

        }

        CusButton{
            text: "重置激光里程计"
            onClicked: {
                caliCanvasConfig.lidarOdomPose = {"x":0, "y":0, "yaw":0}
                updateCanvas()

            }
        }
        CusButton{
            text: "清空激光轨迹"
            onClicked: {
                caliCanvasConfig.lidarOdomTraj=[]
                updateCanvas()
            }
        }
        CusButton{
            text: "清空里程计轨迹"
            onClicked: {
                caliCanvasConfig.odomTraj=[]
                updateCanvas()
            }
        }
        CusButton{
            text: "开始记录数据"
            onClicked: {
                console.log("开始记录数据")
                collectData(true)
            }
        }
        CusButton{
            text: "停止记录数据"
            onClicked: {
                console.log("停止记录数据")
                collectData(false)
            }
        }
        CusButton{
            text: "开始标定"
            onClicked: {
                console.log("停止记录数据,开始计算标定结果")
                startAutoCali()
            }
        }
        CusButton{
            text: "清空标定数据"
            onClicked: {
                console.log("清空标定数据")
                cleanCaliData()
            }
        }


    }




}
