import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import "../BasicComponent"
Rectangle {
    property int fontSize: 17
    property string type: ""
    property double leftWheelDiameter: 0
    property double rightWheelDiameter: 0
    property double wheelDistance: 0
    property double leftSpd: 0
    property double rightSpd: 0
    property double leftDis: 0
    property double rightDis: 0
    property double lineSpd: 0
    property double angularSpd: 0
    signal chassisInputChanged()
    function updateChassisInfo(chassis_info){
        leftSpd = chassis_info.leftwheelspd;
        leftDis = chassis_info.letfwheeldis;
        rightSpd = chassis_info.rightwheelspd;
        rightDis = chassis_info.rightwheeldis;
        lineSpd = chassis_info.linearspeed;
        angularSpd = chassis_info.angularspeed;
    }

    Grid {
        columns: 2
        spacing: 4
        Rectangle{
            height: 20
            width: 50
            TText{
                text: type
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
            }
        }
        Rectangle{
            height: 20
            width:  50
        }


        Rectangle{
            width: 100
            height: 25
            border.color: "black"
            TText{
                text: "  左轮直径"
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
            }
        }
        Rectangle{
            width: 100
            height: 25
            border.color: "black"
            TTextInput{
                id:leftWheelInput
                anchors.fill: parent
                text: leftWheelDiameter.toFixed(5)
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
                clip: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                onTEditFinished: {
                    leftWheelDiameter = text *1
                    chassisInputChanged()
                }
            }

        }

        Rectangle{
            width: 100
            height: 25
            border.color: "black"
            TText{
                text: "  右轮直径"
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
            }
        }
        Rectangle{
            width: 100
            height: 25
            border.color: "black"
            TTextInput{
                id:rightWheelInput
                anchors.fill: parent
                text: rightWheelDiameter.toFixed(5)
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
                clip: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                onTEditFinished: {
                    rightWheelDiameter = text *1
                    chassisInputChanged()
                }
            }

        }

        Rectangle{
            width: 100
            height: 25
            border.color: "black"
            TText{
                text: "  轮距"
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
            }
        }
        Rectangle{
            width: 100
            height: 25
            border.color: "black"
            TTextInput{
                id:wheelDistanceInput
                anchors.fill: parent
                text: wheelDistance.toFixed(5)
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
                clip: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                onTEditFinished: {
                    wheelDistance = text *1
                    chassisInputChanged()
                }
            }

        }

        Rectangle{
            width: 100
            height: 25
            border.color: "black"
            TText{
                text: "  左轮速度"
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
            }
        }
        Rectangle{
            width: 100
            height: 25
            border.color: "black"
            TText{
                id:leftWheelSpeed
                anchors.fill: parent
                text: leftSpd.toFixed(5)
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
                clip: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
            }

        }
        Rectangle{
            width: 100
            height: 25
            border.color: "black"
            TText{
                text: "  右轮速度"
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
            }
        }
        Rectangle{
            width: 100
            height: 25
            border.color: "black"
            TText{
                id:rightWheelSpeed
                anchors.fill: parent
                text: rightSpd.toFixed(5)
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
                clip: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
            }

        }
        Rectangle{
            width: 100
            height: 25
            border.color: "black"
            TText{
                text: "  左轮距离"
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
            }
        }
        Rectangle{
            width: 100
            height: 25
            border.color: "black"
            TText{
                id:leftWheelDis
                anchors.fill: parent
                text: leftDis.toFixed(5)
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
                clip: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter

            }

        }
        Rectangle{
            width: 100
            height: 25
            border.color: "black"
            TText{
                text: "  右轮距离"
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
            }
        }
        Rectangle{
            width: 100
            height: 25
            border.color: "black"
            TText{
                id:rightWheelDis
                anchors.fill: parent
                text: rightDis.toFixed(5)
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
                clip: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
            }

        }
        Rectangle{
            width: 100
            height: 25
            border.color: "black"
            TText{
                text: "  线速度"
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
            }
        }
        Rectangle{
            width: 100
            height: 25
            border.color: "black"
            TText{
                id:linearSpeed
                anchors.fill: parent
                text: lineSpd.toFixed(5)
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
                clip: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter

            }

        }
        Rectangle{
            width: 100
            height: 25
            border.color: "black"
            TText{
                text: "  角速度"
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
            }
        }
        Rectangle{
            width: 100
            height: 25
            border.color: "black"
            TText{
                id:angularSpeed
                anchors.fill: parent
                text:angularSpd.toFixed(5)
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
                clip: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter

            }

        }

    }


}
