import QtQuick 2.12
import QtQuick.Controls 2.12
import "../BasicComponent"
Rectangle {
    id: root
    color: mainConfig.darkerColor
    property var treeView
    property var treeModel
    Item {
        width: parent.width
        height: 30
        Row {
            height: parent.height
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            spacing: 4
            TIconButton {
                anchors.verticalCenter: parent.verticalCenter
                imageUrl: "qrc:/icon/delete.png"
                normalColor: treeHeader.color
                tipText: "删除"
                onClicked: {
                    if(roadmapTModel.data(treeView.currentIndex)["description"] != null){
                        var temp_node = roadmapTModel.data(treeView.currentIndex)
                        var map_item = main_data.m_map_nodes_index_id.get(temp_node.id)
                        if(map_item.out_list.length  === 0 && map_item.in_list.length === 0){
                            treeModel.remove(treeView.currentIndex)
                            treeView.currentIndex = -1
                        }
                        else{
                            messageBox.showMessage("提示", "点与其他段相连，不可删除")
                            console.log("can not remove node ")
                            console.log("map_item.out_list is ", map_item.out_list)
                            console.log("map_item.in_list is ", map_item.in_list)
                            return
                        }
                    }
                    else{
                        treeModel.remove(treeView.currentIndex)
                        treeView.currentIndex = -1

                    }

                    console.log()

                }
            }
            TIconButton {
                anchors.verticalCenter: parent.verticalCenter
                imageUrl: "qrc:/icon/expand.png"
                normalColor: treeHeader.color
                tipText: "全部展开"
                onClicked: {
                    treeModel.expandAll()
                }
            }
            TIconButton {
                anchors.verticalCenter: parent.verticalCenter
                imageUrl: "qrc:/icon/collapse.png"
                normalColor: treeHeader.color
                tipText: "全部折叠"
                onClicked: {
                    treeModel.collapseAll()
                }
            }
        }
    }
}
