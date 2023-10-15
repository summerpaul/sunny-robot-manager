import QtQuick 2.12
import QtQuick.Controls 2.12
import "../BasicComponent"
Rectangle {
    id: root
    color: mainConfig.darkerColor
    property var dataSource: null
    property int nameWidth
    property int typeWidth
    property int valueWidth
    onDataSourceChanged: {
        if (dataSource) {
            propList = []
            propList = Object.keys(dataSource).filter(k=>!k.startsWith("TModel_"))
        } else {
            propList = []
        }
    }
    property var propList
    ListModel {
        id: propModel
    }
    // list显示
    ListView {
        id: listView
        model: propList
        anchors.fill: parent
        highlight: Rectangle {
            width: listView.width
            height: 35
            color: "transparent"
            border.width: 1
            border.color: "black"
            Behavior on y {
                SpringAnimation {
                    spring: 3
                    damping: 0.2
                }
            }
        }
        //显示的具体设置
        delegate: Item {
            width: listView.width
            height: 35
            Row {
                anchors.fill: parent
                //数据名显示的item
                Item {
                    height: parent.height
                    width: nameWidth
                    TText {
                        font.family: qsTr("微软雅黑")
                        font.pixelSize: 14
                        id: nameText
                        anchors.centerIn: parent
                        text: modelData
                        color: mainConfig.constrastColor
                        width: parent.width
//                        backgroundColor: config.backgroundColor
                    }
                    TBorder {}
                }
                //数据类型显示的item
                Item {
                    height: parent.height
                    width: typeWidth
                    TText {
                        font.family: qsTr("微软雅黑")
                        font.pixelSize: 14
                        anchors.centerIn: parent
                        text: typeof dataSource[modelData]
                        color: mainConfig.constrastColor
                        width: parent.width
//                        backgroundColor: config.backgroundColor

                    }
                    TBorder {}
                }
                //具体数据值的item
                Item {
                    height: parent.height
                    width: valueWidth
                    Loader {
                        anchors.fill: parent
                        sourceComponent: {
                            switch (typeof dataSource[modelData]) {
                            case "number":
                                return numberComp
                            case "string":
                                return stringComp
                            case "boolean":
                                return boolComp
                            case "object":
                            default:
                                return jsComp
                            }
                        }
                        onLoaded: {
                            item.compData = dataSource[modelData]
                            item.jsonKey = modelData
                        }
                    }
                    TBorder{}
                }
            }
        }
        ScrollIndicator.vertical: ScrollIndicator { }
    }
    Component {
        id: stringComp
        TTextField {
            property string compData
            property var jsonKey
            text: compData
            font.family: qsTr("微软雅黑")
            font.pixelSize: 14
            height: parent.height
            width: parent.width
            color: mainConfig.constrastColor
            backgroundColor: mainConfig.backgroundColor
            onTextChanged: {
                if(jsonKey != null){
                    roadmapTModel.setNodeValue(tView.currentIndex, jsonKey, text)
                }
            }
        }
    }
    Component {
        id: numberComp
        TTextField {
            property double compData
            property var jsonKey
            font.family: qsTr("微软雅黑")
            font.pixelSize: 14
            text: Number.isInteger(compData) ? compData:compData.toFixed(3)
            validator: DoubleValidator {}
            color: mainConfig.constrastColor
            backgroundColor: mainConfig.backgroundColor
            onTextChanged: {
                if(jsonKey != null){
                    roadmapTModel.setNodeValue(tView.currentIndex, jsonKey, Number(text))
                }
            }
        }
    }
    Component {
        id: boolComp
        CheckBox {
            id: checkBox
            property bool compData
            property var jsonKey
            checked: compData
            text: checkBox.checked ? "true" : "false"
        }
    }
    Component {
        id: jsComp
        TTextField {
            id: field
            font.family: qsTr("微软雅黑")
            font.pixelSize: 14
            property var compData
            property var jsonKey
            text: JSON.stringify(compData)
            height: parent.height
            width: parent.width
            color: mainConfig.constrastColor
            backgroundColor: mainConfig.backgroundColor

        }
    }
}
