import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import "../TaoQuick"
Rectangle{
    id:task_view
    //    color: mainConfig.darkerColor
    signal sendTask(string task)
    //    signal sendJsonTask( task);
    property int fontSize: 17
    function getAction( action){
        if(action === "NONE"){
            return 11
        }
        else if (action === "UP"){
            return 12
        }
        else if(action === "DOWN"){
            return 13
        }
        else if(action === "TRAY_UP"){
            return 14
        }

    }
    function getDirection(direction){
        if(direction === "NONE"){
            return 0
        }
        else if (direction === "LEFT"){
            return 1
        }
        else if(direction === "RIGHT"){
            return 2
        }

    }
    Grid {
        anchors.horizontalCenter: parent.horizontalCenter
        columns: 2
        spacing: 4
        Rectangle{
            height: 20
            width: 100
        }

        Rectangle{
            height: 20
            width: 100
        }

        Label{
            text: "任务类型"
            font.pixelSize: fontSize
            font.family: qsTr("微软雅黑")
        }
        CusComboBox{
            id:task_type
            height: 30
            width: 120
            model: ["LIFT", "CHARGE", "CTU", "FORKLIFT"]
            font.pixelSize: fontSize
            font.family: qsTr("微软雅黑")
        }
        Label{
            text:"执行类型"
            font.pixelSize: fontSize
            font.family: qsTr("微软雅黑")
        }
        CusComboBox{
            id:action
            model: ["NONE", "UP", "DOWN", "TRAY_UP"]
            width: 120
            font.family: qsTr("微软雅黑")
        }
        Label{
            text: "执行方向"
            font.pixelSize: fontSize
            font.family: qsTr("微软雅黑")
        }
        CusComboBox{
            id:action_direction
            width: 120
            model: ["NONE", "LEFT", "RIGHT"]
            font.family: qsTr("微软雅黑")
        }
        Label{
            text: "执行层数"
            font.pixelSize: fontSize
            font.family: qsTr("微软雅黑")
        }
        Rectangle{
            height: 25
            width: 100
            border.color: "black"
            TextInput{
                id:action_target
                anchors.fill: parent
                text: "0"
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
                clip: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
            }
        }
        Label{
            text: "循环次数"
            font.pixelSize: fontSize
            font.family: qsTr("微软雅黑")
        }
        Rectangle{
            height: 25
            width: 100
            border.color: "black"
            TextInput{
                id:cycle_num
                anchors.fill: parent
                text: "1"
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
                clip: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
            }
        }
        Button{
            text: "执行任务"
            font.family: qsTr("微软雅黑")
            onClicked:{
                if(main_data.m_route_result < 1){
                    return
                }
                var lanes = []

                if(cycle_num.displayText *1 >1){
                    for(let i = 0 ; i < cycle_num.displayText *1; i++){
                        var lane_length = main_data.m_route_result.length
                        for(let j = 0; j < lane_length; j++){

                            var lane = main_data.m_lanes.get(main_data.m_route_result[j])
                            lanes.push(lane)

                            if(j === lane_length -1 && i < cycle_num.displayText *1 -1){

                                var FN_out_list =  main_data.m_map_nodes_index_id.get(lane.FN.id).out_list

                                mainCanvas.m_lane_FNID
                                if(FN_out_list.length >1){
                                    messageBox.showMessage("规划任务警告","终点的出度大于1，不能用循环任务")
                                    return
                                }
                                lane = main_data.m_lanes.get(FN_out_list[0])
                                var route_BNID = main_data.m_lanes.get(main_data.m_route_result[0]).BN.id
                                if(lane.FN.id !== route_BNID){
                                    messageBox.showMessage("规划任务警告","终点距离起点不是一段，不能使用循环任务")
                                }
                                lanes.push(lane)
                            }
                        }

                    }


                }
                else//循环次数为1
                {
                    for (let i = 0; i < main_data.m_route_result.length; i++){
                        lane = main_data.m_lanes.get(main_data.m_route_result[i])
                        if(!i){
                            lanes = [lane]
                        }
                        else{
                            lanes.push(lane)
                        }
                    }

                }


                var json_task = {
                    "taskId": "GcJ9p-MmkS",
                    "node": mainCanvas.m_search_FN.id,
                    "taskType":task_type.displayText,
                    "action":getAction(action.displayText) ,
                    "direction": getDirection(action_direction.displayText),
                    "target":Number(action_target.displayText)
                }
                var root = new Object
                root["lanes"] = lanes
                root["task"] = json_task
                root["type"] = "move"
                root["msgid"] = 1
//                console.log(JSON.stringify(lanes))
                sendTask(JSON.stringify(root))
            }
        }

    }




}
