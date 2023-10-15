import QtQuick 2.12
import QtQuick.Controls 2.12
import "../BasicComponent"
Rectangle {
    id: root
    color: mainConfig.darkerColor
    border.width: 1
    border.color: "gray"
    property var propView
    property var treeModel

    property alias nameWidth: nameItem.width
    property alias typeWidth: typeItem.width
    property alias valueWidth: valueItem.width
    Item {
        width: parent.width
        height: parent.height / 2
        TText {
            text: String("节点属性")
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
        }
    }
    Row {
        y: parent.height - height
        width: parent.width
        height: parent.height / 2
        Item {
            id: nameItem
            height: parent.height
            width: parent.width * 0.33
            TText {
                text: "名称"
                anchors.centerIn: parent
            }
            TBorder {}
        }
        Item {
            id: typeItem
            height: parent.height
            width: parent.width * 0.33
            TText {
                text: "类型"
                anchors.centerIn: parent
            }
            TBorder {}
        }
        Item {
            id: valueItem
            height: parent.height
            width: parent.width * 0.34
            TText {
                text: "数据"
                anchors.centerIn: parent
            }
            TBorder {}
        }
    }
}
