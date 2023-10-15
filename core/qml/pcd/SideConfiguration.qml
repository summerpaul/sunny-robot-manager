import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Scene3D 2.0
Item {
    signal reset()

    Column {
        anchors.fill: parent
        Button {
            width: parent.width
            text: qsTr("Reset Camera")
            onClicked: reset()
        }





    }

}
