import QtQuick 2.12
import QtQuick.Controls 2.12
import "../BasicComponent"
Item {
    id: root
    readonly property string m_depthKey: "TModel_depth"
    readonly property string m_expendKey: "TModel_expend"
    readonly property string m_childrenExpendKey: "TModel_childrenExpend"
    readonly property string m_hasChildendKey: "TModel_hasChildren"

    readonly property string m_parentKey: "TModel_parent"
    readonly property string m_childrenKey: "TModel_children"

    // 就是t model
    property alias sourceModel: listView.model
    property int basePadding: 4
    property int subPadding: 16
    property alias currentIndex: listView.currentIndex
    property alias header: listView.header
    property alias treeListView: listView
    property var currentData
    //    property var name: value

    onCurrentIndexChanged: {
        if (currentIndex < 0) {
            currentData = null;
        } else {
            currentData = sourceModel.data(currentIndex);
        }
    }
    clip: true

    signal collapse(int index);
    signal expand(int index);
    ListView {
        id: listView
        anchors.fill: parent
        currentIndex: -1
        //list 显示设置
        delegate: Rectangle {
            id: delegateRect
            width: listView.width
            color: (listView.currentIndex === index || area.hovered) ? mainConfig.normalColor : mainConfig.darkerColor
            height: model.display[m_expendKey] === true ? 35 : 0
            visible: height > 0
            property alias editable: nameEdit.editable
            property alias editItem: nameEdit
            TTextInput {
                id: nameEdit
                font.family: qsTr("微软雅黑")
                font.pixelSize: 14
                anchors.verticalCenter: parent.verticalCenter
                x: root.basePadding + model.display[m_depthKey] * root.subPadding
                text: model.display["id"]
                height: parent.height
                width: parent.width * 0.8 - x
                editable: false
            }
            TTransArea {
                id: area
                height: parent.height
                width: parent.width - controlIcon.x
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                enabled: !delegateRect.editable
                onPressed: {
                    if(mouse.button ==  Qt.LeftButton)
                    {
                        if (listView.currentIndex !== index) {
                            listView.currentIndex = index;
                        } else {
                            listView.currentIndex = -1;
                        }
                    }
                    if(mouse.button == Qt.RightButton){
                        if(listView.currentIndex !== -1){
                            contextMenu.popup()
                        }
                    }
                }
                Menu {

                    id: contextMenu
                    width: 80
                    MenuItem {
                        text: "增加"
                        onClicked: {
                            console.log("选择新增段模板")
                        }
                    }
                    MenuItem { text: "删除" }
                }
            }


            Image {
                id: controlIcon
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: 20
                }
                visible: model.display[m_hasChildendKey]
                source: model.display[m_childrenExpendKey] ? "qrc:/icon/collapse.png" : "qrc:/icon/expand.png"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (model.display[m_hasChildendKey]) {
                            if( true === model.display[m_childrenExpendKey]) {
                                collapse(index)
                            } else {
                                expand(index)
                            }
                        }
                    }
                }
            }
        }
        add: Transition {
            NumberAnimation  { from: -root.width; to: 0; properties: "x"; duration: 300; easing.type: Easing.OutQuad }
        }
        remove: Transition {
            NumberAnimation { to: -root.width; property: "x"; duration: 300; easing.type: Easing.OutQuad }
        }
        displaced : Transition {
            NumberAnimation  { properties: "x,y"; duration: 300; easing.type: Easing.OutQuad }
        }
        ScrollIndicator.vertical: ScrollIndicator { }
    }
    TBorder {}

    function rename(index) {
        if (listView.currentItem) {
            listView.currentItem.editable = !listView.currentItem.editable
        }
    }
    function positionTo(index) {
        listView.positionViewAtIndex(index, ListView.Center)
    }
}
