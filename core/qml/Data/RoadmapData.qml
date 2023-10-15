import QtQuick 2.0
import "../../js/Common.js" as Common
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import Roadmap 1.0

Item {   
    property var roadmapToolbar
    property var roadmapNodes: []
    property var roadmapLanes: []
    property int maxNodeId: 0
    property int maxLaneId: 0
    property int lanesCount: 0
    property int nodesCount: 0
    property int laneTemplateCount: 0
    property int laneBoundingCount: 0
    property int nodeStratIndex: 0
    property int laneStartIndex: 0
    property int laneTemplateStartIndex: 0
    property int laneBoundingStartIndex: 0
    property var mapNodesIndexId: []
    property var mapLanesIndexId: []
    property var laneTemplateMap: []
    property var laneBoundingMap: []
    property var routeResult: []


    property var currentLaneTemplate: null
    property var roadmap
    signal pointAdded()
    signal updateCanvas()

    //对外接口,加载路网文件
    function loadRoadmapFile(filePath){
        roadmap.loadFromJson(filePath)
    }

    Roadmap{

        id:roadmap
        onCountChanged: {
            setRoadmap()
        }
        onRoadmapDataChanged: {
            setRoadmap()
        }
        onLoadRoadmapFile: {
            setRoadmap()
            if(laneTemplateCount == 0){
                addInitLaneTemplate()
            }
//            console.log("接受到新的路网")
        }
        onRouteResultGet: {
            if(routeResult.length === 0){
                console.log()
                messageBox.showMessage("提示", "未成功规划")
                return
            }
            routeResult = routeResult

        }
    }

    //初始化

    Component.onCompleted:
    {
        initRoadmap()
    }



    function initRoadmap(){
        if(laneTemplateCount === 0){
            addInitLaneTemplate()
        }
        roadmap.addNode(nodeStratIndex, {"id": "nodes","TModel_depth":0})
        nodesCount++
        laneStartIndex = nodeStratIndex + nodesCount
        roadmap.addNode(laneStartIndex, {"id": "lanes","TModel_depth":0})
    }

    function addInitLaneTemplate(){
        laneTemplateMap = new Map()
        laneTemplateStartIndex= roadmap.addNode(0, {"id": "段模板","TModel_depth":0})
        addLaneTemplate(laneTemplateStartIndex, "常规前进", 0.5, 1);
        addLaneTemplate(laneTemplateStartIndex, "常规后退", 0.5, -1)
        roadmap.addNode(laneTemplateStartIndex, {"id": "模板绑定","TModel_depth":1})
        nodeStratIndex = laneTemplateStartIndex +laneTemplateCount+2

    }
    function addLaneTemplate(index, name, speed, motion_type){
        var new_item1 = roadmap.addNode(index, {"id": name,"TModel_depth":1})
        roadmap.setNodeValue(new_item1, "motion_type", motion_type)
        roadmap.setNodeValue(new_item1, "speed", speed)
        roadmap.setNodeValue(new_item1, "p1", motion_type*2.0)
        roadmap.setNodeValue(new_item1, "template_type", "lane")
        laneTemplateCount++

    }

    function setCadInfo(cad_lines, cad_polylines){
        m_cad_lines = cad_lines
        m_cad_polylines = cad_polylines
    }
    function setVehiclePose(x, y, yaw){
        m_vehicle_pose_x = x
        m_vehicle_pose_y = y
        m_vehicle_pose_yaw = yaw
    }
    //从C++中获取roadmap
    function setRoadmap(){
        lanesCount = 0
        nodesCount = 0
        laneTemplateCount = 0
        laneBoundingCount = 0
        roadmapNodes = new Map()
        roadmapLanes = new Map()
        mapNodesIndexId = new Map()
        mapLanesIndexId = new Map()
        laneTemplateMap = new Map()
        laneBoundingMap = new Map()

        for(let i = 0; i < roadmap.count; i++){
            if(roadmap.data(i).id === "nodes"){
                nodeStratIndex = i
            }
            else if(roadmap.data(i).id ==="lanes"){
                laneStartIndex=i

            }
            else if(roadmap.data(i).id ==="模板绑定"){
                laneBoundingStartIndex = i

            }

            //增加段模板元素
            if(roadmap.data(i)["template_type"] !== undefined){
                laneTemplateCount++
                var template_item = roadmap.data(i)
                var template_temp = {
                    id:template_item["id"],
                    motion_type:template_item["motion_type"]*1,
                    speed:template_item["speed"]*1,
                    p1:template_item["p1"],
                    index:i
                }
                laneTemplateMap.set(template_item["id"],template_temp)
            }
            //增加与段绑定的模板名称
            else if(roadmap.data(i)["lane_template"] !== undefined){
                var bonuding_item = roadmap.data(i)
                laneBoundingCount++
                var lane_bonuding_item = roadmap.data(i)
                var lane_bounding_temp = {
                    id:bonuding_item.id,
                    lane_template:bonuding_item.lane_template
                }
                laneBoundingMap.set(bonuding_item.id, lane_bounding_temp)
                laneBoundingCount++
            }
            //所有是点的元素
            else if(roadmap.data(i)["description"] !== undefined){
                var node_item = roadmap.data(i)
                nodesCount++
                if(maxNodeId < node_item.id){
                    maxNodeId = node_item.id
                }

                mapNodesIndexId.set(node_item.id, {
                                             tModel_index:i,
                                             out_list:[],
                                             in_list:[]
                                         })
                var temp_node = {
                    id:node_item.id,
                    x:node_item.x,
                    y:node_item.y,
                    yaw:node_item.yaw,
                    description:node_item.description,
                    mark_pose:node_item.mark_pose,
                    ahead_node:node_item.ahead_node,
                    post_node:node_item.post_node
                }
                roadmapNodes.set(roadmap.data(i).id,temp_node)
            }


            //所有是段的元素
            else if (roadmap.data(i)["lane_type"] !== undefined){
                lanesCount++
                var lane_item = roadmap.data(i)
                if(maxLaneId < lane_item.id){
                    maxLaneId = lane_item.id
                }
                mapLanesIndexId.set(lane_item.id,{tModel_index:i})
                var temp_lane ={
                    lane_id:lane_item.id,
                    BN:roadmapNodes.get(lane_item["BNID"]),
                    FN:roadmapNodes.get(lane_item["FNID"]),
                    shape : {
                        lane_type : lane_item["lane_type"],
                        p1:lane_item["p1"]*1,
                        p2:lane_item["p2"]*1,
                        hdg:lane_item["hdg"]*1,
                        length:lane_item["length"]*1
                    },
                    info:{
                        speed:lane_item["speed"]*1,
                        motion_type:lane_item["motion_type"]*1,
                        obstacle_avoid:Boolean (lane_item["obstacle_avoid"]),
                        extra_cost:lane_item["extra_cost"]*1,
                        qr_code:lane_item["qr_code"]*1,
                        infrared:Boolean(lane_item["infrared"]),
                        heading:lane_item["heading"]*1,
                        avoid_level:lane_item["avoid_level"]*1
                    }
                }
                if(laneBoundingMap.get(lane_item.id) !== undefined){
                    var lane_template_temp = laneBoundingMap.get(lane_item.id)
                    //                    console.log("lane_template_temp.lane_template is ", lane_template_temp.lane_template)
                    var bounding_map_temp = laneTemplateMap.get(lane_template_temp.lane_template)
                    //                    console.log("bounding_map_temp.speed is ", bounding_map_temp.speed)
                    temp_lane ={
                        lane_id:lane_item.id,
                        BN:roadmapNodes.get(lane_item["BNID"]),
                        FN:roadmapNodes.get(lane_item["FNID"]),
                        shape : {
                            lane_type : lane_item["lane_type"],
                            p1:lane_item["p1"]*1,
                            p2:lane_item["p2"]*1,
                            hdg:lane_item["hdg"]*1,
                            length:lane_item["length"]*1
                        },
                        info:{
                            speed:bounding_map_temp["speed"]*1,
                            motion_type:bounding_map_temp["motion_type"]*1,
                            obstacle_avoid:Boolean (lane_item["obstacle_avoid"]),
                            extra_cost:lane_item["extra_cost"]*1,
                            qr_code:lane_item["qr_code"]*1,
                            infrared:Boolean(lane_item["infrared"]),
                            heading:lane_item["heading"]*1,
                            avoid_level:lane_item["avoid_level"]*1
                        }
                    }
                    //                    roadmap.setNodeValue(i, "speed", bounding_map_temp["speed"])
                }


                mapNodesIndexId.get(lane_item["BNID"]).out_list.push(lane_item.id)
                mapNodesIndexId.get(lane_item["FNID"]).in_list.push(lane_item.id)
                roadmapLanes.set(lane_item.id, temp_lane)
            }   
        }
//        console.log("roadmap nodes size is ", nodesCount)
        updateCanvas()
    }
    //在C++中写入数据
    function addPoint(x, y, yaw){


        var id = ++maxNodeId
        var newPoint = {
            id :id,
            x:x,
            y:y,
            yaw:yaw,
            mark_pose:0,
            description:"RoadPoint",
        }

        var new_item =roadmap.addNode(nodeStratIndex , {"id": id,"TModel_depth":1})
        nodesCount++
        roadmapNodes.set(id, newPoint)
        roadmap.setNodeValue(new_item, "id", id)
        roadmap.setNodeValue(new_item, "x", x)
        roadmap.setNodeValue(new_item, "y", y)
        roadmap.setNodeValue(new_item, "yaw", yaw)
        roadmap.setNodeValue(new_item, "mark_pose", 0)
        roadmap.setNodeValue(new_item, "description", "RoadPoint")
        roadmap.setNodeValue(new_item, "ahead_node", 0)
        roadmap.setNodeValue(new_item, "post_node", 0)
        roadmap.setNodeValue(new_item, "type", 0)
    }
    function editPoint(id, x, y){
        var map_node =  mapNodesIndexId.get(id)
        roadmap.setNodeValue(map_node.tModel_index, "x", x)
        roadmap.setNodeValue(map_node.tModel_index, "y", y)

        map_node.in_list.forEach(function(item, index) {
            console.log("item is ",item)
            var map_lane_index = mapLanesIndexId.get(item).tModel_index
            console.log("map_lane_index is ",map_lane_index)
            var map_lane = roadmapLanes.get(item)
            var lane_length = 0
            if(map_lane.shape.lane_type === "line"){
                lane_length = Common.getDistance(map_lane.BN, map_lane.FN)
                console.log("new dis is ", lane_length)
            }
            else if(map_lane.shape.lane_type=== "bezier"){
                var btn_node = roadmapLanes.get(item).BN
                var end_node =  roadmapLanes.get(item).FN
                var p1 = roadmapLanes.get(item).shape.p1
                lane_length = Common.getBezierLength(btn_node, end_node, p1)
            }
            roadmap.setNodeValue(map_lane_index, "length", lane_length)
        })

        map_node.out_list.forEach(function(item, index) {
            console.log("item is ",item)
            var map_lane_index = mapLanesIndexId.get(item).tModel_index
            var map_lane = roadmapLanes.get(item)
            var lane_length = 0
            if(map_lane.shape.lane_type === "line"){
                lane_length = Common.getDistance(map_lane.BN, map_lane.FN)
                console.log("new dis is ", lane_length)
            }
            else if(map_lane.shape.lane_type=== "bezier"){
                var btn_node = roadmapLanes.get(item).BN
                var end_node =  roadmapLanes.get(item).FN
                var p1 = roadmapLanes.get(item).shape.p1
                lane_length = Common.getBezierLength(btn_node, end_node, p1)
            }
            roadmap.setNodeValue(map_lane_index, "length", lane_length)
        })


    }
    function addLine(BNID, FNID){
        addLane(BNID, FNID, "line")

    }
    function addCurve(BNID, FNID){
        addLane(BNID, FNID, "bezier")
    }
    function addLane(BNID, FNID,laneType){

        //增加绑定
        if(roadmapToolbar.laneTemplate === ""){
            messageBox.showMessage("提示","段模板不能为空")
            return
        }
        var temp_template = laneTemplateMap.get(roadmapToolbar.laneTemplate)
        var id = ++maxLaneId

        roadmap.addNode(laneBoundingStartIndex, {"id": id,lane_template:roadmapToolbar.laneTemplate,"TModel_depth":2})
        laneBoundingCount++
        var new_item  = roadmap.addNode(laneStartIndex, {"id": id,"TModel_depth":1})

        //        console.log("temp_template.motion_type is ", temp_template.motion_type)

        var lane_length = 0
        var temp_lane ={
            lane_id:id,
            BN:roadmapNodes.get(BNID),
            FN:roadmapNodes.get(FNID),
            shape : {
                lane_type : laneType,
                p1:temp_template.p1,
                p2:0,
                hdg:0,
                length:lane_length
            },
            info:{
                speed:temp_template.speed,
                motion_type:temp_template.motion_type,
                obstacle_avoid:0,
                extra_cost:0,
                qr_code:-1,
                infrared:0,
                heading:0,
                avoid_level:0
            }
        }
        roadmapLanes.set(id, temp_lane)
        if(laneType === "line"){
            lane_length = Common.getDistance(roadmapNodes.get(BNID), roadmapNodes.get(FNID))
            //            console.log("line length is ", lane_length)
        }else if(laneType === "bezier"){
            console.log(roadmapLanes.get(id).BN.yaw)
            var btn_node = roadmapLanes.get(id).BN
            var end_node =  roadmapLanes.get(id).FN
            var p1 = roadmapLanes.get(id).shape.p1
            lane_length = Common.getBezierLength(btn_node, end_node, p1)

            //            console.log("bezier length is ", lane_length)
        }
        roadmap.setNodeValue(new_item, "id", id)
        roadmap.setNodeValue(new_item, "BNID", BNID)
        roadmap.setNodeValue(new_item, "FNID", FNID)
        roadmap.setNodeValue(new_item, "lane_type", laneType)
        roadmap.setNodeValue(new_item, "motion_type", temp_template.motion_type)
        roadmap.setNodeValue(new_item, "speed", temp_template.speed)
        roadmap.setNodeValue(new_item, "p1", temp_template.p1)
        roadmap.setNodeValue(new_item, "p2", temp_template.p2)
        roadmap.setNodeValue(new_item, "hdg", temp_template.hdg)
        roadmap.setNodeValue(new_item, "length", lane_length)

    }

}
