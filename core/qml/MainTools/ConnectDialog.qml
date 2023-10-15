import QtQuick 2.0
import QtQuick.Dialogs 1.2

import "../TaoQuick"

Dialog {
    width: 250;
    height:200
    title: qsTr("连接")
    standardButtons: StandardButton.Ok
    property int fontSize: 17
    property string vehivle_ip:"10.0.12.91"
    signal updateVehicleIp(string ip)

    onAccepted: {
        updateVehicleIp(vehivle_ip_input.text)
        console.log("vehiclde ip is ", vehivle_ip_input.text)
    }
    Grid{
        anchors.centerIn: parent
        columns: 2
        spacing: 4
        CusLabel{
            text: "车辆IP"
            font.pixelSize: fontSize
        }
        Rectangle{
            height: 25
            width: 100
            border.color: "black"
            CusTextInput{
                id:vehivle_ip_input
                anchors.fill: parent
                text: vehivle_ip
                font.pixelSize: fontSize
                clip: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
            }
        }

    }

}
