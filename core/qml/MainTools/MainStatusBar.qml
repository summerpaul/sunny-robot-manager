import QtQuick 2.5
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
Rectangle{
    property string m_mouse_pose : "(0, 0)"
    property string m_select_node_pose:  "(-1, -1)"
    property string m_vehicle_pose: "(0, 0, 0)"
    property var comunication_state_icon
    property var comunication_state
    function setPose(x, y){
        m_mouse_pose = "(" + x.toFixed(3).toString() + ", " + y.toFixed(3).toString() +")"
    }

    function setNodePose(x, y){
        m_select_node_pose = "(" + x.toString() + ", " + y.toString() +")"
    }

    function setVehiclePose(x, y, heading){
        m_vehicle_pose = "(" + x.toFixed(2).toString() + ", " + y.toFixed(2).toString() +", " + heading.toFixed(1).toString() +")"
    }

    function connectToVehicle(connect_flag){
        if(connect_flag){
            comunication_state_icon.source = "qrc:/icon/connect.svg"
            comunication_state.text = "已连接车辆"
        }
        else{
            comunication_state_icon.source = "qrc:/icon/disconnect.svg"
            comunication_state.text = "未连接"
        }
    }

    height: 35
    border.color: "grey"
    property int fontSize: 18
    Label{
        id:mouse_pose_text
        text: "鼠标坐标:"
        font.pixelSize: fontSize
        height: parent.height
        verticalAlignment: Text.AlignVCenter
        width: 80
    }
    Label{
        id:mouse_pose
        anchors.left:mouse_pose_text.right
        font.pixelSize: fontSize
        text: m_mouse_pose
        height: parent.height
        verticalAlignment: Text.AlignVCenter
        width: 200
    }

    Label{
        id:station_pose_text
        anchors.left:mouse_pose.right
        font.pixelSize: fontSize
        text: "站台位置:"
        height: parent.height
        verticalAlignment: Text.AlignVCenter
    }
    Label{
        id:station_pose
        anchors.left:station_pose_text.right
        font.pixelSize: fontSize
        text: m_select_node_pose
        height: parent.height
        verticalAlignment: Text.AlignVCenter
        width: 200
    }

    Image {
        id:comunication_state_icon
        source: "qrc:/icon/disconnect.svg"
        anchors.right: parent.right
        anchors.verticalCenter:parent.verticalCenter
        width: 25
        height: 25
    }

    Label{
        id:comunication_state
        text: "未连接"
//        icon.source:
        anchors.right: comunication_state_icon.left
        font.pixelSize: fontSize
        height: parent.height
        verticalAlignment: Text.AlignVCenter

    }

    Label{
        id:vehicle_pose
        anchors.right:comunication_state.left
        font.pixelSize: fontSize
        text: m_vehicle_pose
        height: parent.height
        verticalAlignment: Text.AlignVCenter
        width: 200

    }

    Label{
        id:vehicle_pose_text
        anchors.right:vehicle_pose.left
        font.pixelSize: fontSize
        text: "车辆坐标:"
        height: parent.height
        verticalAlignment: Text.AlignVCenter
    }
}
