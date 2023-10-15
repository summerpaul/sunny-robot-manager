function ifInCircle(pos, nodes, radius){
    for(let item of nodes.values()){
        if (getDistance(item, pos) < radius) {
            return item
        }
    }
    return false
}

function getCanvasPos(mouseX, mouseY, offsetX = 0, offsetY = 0, scale = 1){
    return{
        x: -(mouseX - offsetX) / scale,
        y: (mouseY - offsetY) / scale
    }
}
function getDistance(p1, p2){

    return Math.sqrt((p1.x - p2.x) ** 2 + (p1.y - p2.y) ** 2)
}

function JsonItems2MapItems(json_items){
    var mapItems = new Map()
    json_items.forEach(function(item, index){
        mapItems.set(item.id,item)
    })
    return mapItems
}
function setRoadmap(roadmap)
{
    var nodeItems = new JsonItems2MapItems(roadmap.nodes.subType)
    var laneItems = new Map()
    if(roadmap.lanes.subType === undefined){
        return [nodeItems, laneItems]

    }

    roadmap.lanes.subType.forEach(function(item, index){
        var temp_lane ={
            lane_id:item["id"]*1,
            BN:nodeItems.get(item["BNID"]),
            FN:nodeItems.get(item["FNID"]),
            shape : {
                lane_type : item["lane_type"],
                p1:item["p1"]*1,
                p2:item["p2"]*1,
                hdg:item["hdg"]*1,
                length:item["length"]*1
            },
            info:{
                speed:item["speed"]*1,
                motion_type:item["motion_type"]*1,
                obstacle_avoid:Boolean (item["obstacle_avoid"]),
                extra_cost:item["extra_cost"]*1,
                qr_code:item["qr_code"]*1,
                infrared:Boolean(item["infrared"]),
                heading:item["heading"]*1,
                avoid_level:item["avoid_level"]*1
            }
        }
        laneItems.set(item.id,temp_lane)
    })
    return [nodeItems, laneItems]
}

//根据连个点与offset计算贝塞尔的四控制点
function calFourControlPoint(clickNodes, offset){
    var endIndex = clickNodes.length -1;
    var dist =getDistance(clickNodes[0], clickNodes[endIndex]) / offset;
    var controlNodes = [];
    controlNodes.push(clickNodes[0]);
    controlNodes.push({x:clickNodes[0].x + dist * Math.cos(clickNodes[0].yaw ),
                          y:clickNodes[0].y + dist * Math.sin(clickNodes[0].yaw),
                          yaw:0

                      });
    controlNodes.push({x:clickNodes[endIndex].x - dist *Math.cos(clickNodes[endIndex].yaw ),
                          y:clickNodes[endIndex].y - dist * Math.sin(clickNodes[endIndex].yaw ),
                          yaw:0
                      });
    controlNodes.push(clickNodes[endIndex]);
    return controlNodes;
}

//计算贝塞尔的多阶段导数的控制点
function bezierDerivativesControlNodes(controlPoints, n_derivatives){
    var De_control_points = []
    De_control_points.push(controlPoints)
    for(var i = 0; i < n_derivatives; i++){
        var n = De_control_points[i].length
        var tempPoints = []
        for(var j = 0; j < n-1; j++){
            var tmp = {
                x : (n - 1) * (De_control_points[i][j+1].x -  De_control_points[i][j].x),
                y : (n - 1) * (De_control_points[i][j+1].y -  De_control_points[i][j].y),
                yaw : 0
            }
            tempPoints.push(tmp)
        }
        De_control_points.push(tempPoints)
    }
    return De_control_points
}

function factorial(num){
    if (num <= 1) {
        return 1;
    } else {
        return num * factorial(num - 1);
    }
}

//通过控制点,一条贝塞尔中的
function bezier(t, controlNodes){
    var x = 0, y = 0,
    n = controlNodes.length - 1;
    controlNodes.forEach(function(item, index) {
        if(!index) {
            //0阶段bezier，即直线
            x += item.x * Math.pow(( 1 - t ), n - index) * Math.pow(t, index);
            y += item.y * Math.pow(( 1 - t ), n - index) * Math.pow(t, index);
        } else {
            x += factorial(n) / factorial(index) / factorial(n - index) * item.x * Math.pow(( 1 - t ), n - index) * Math.pow(t, index);
            y += factorial(n) / factorial(index) / factorial(n - index) * item.y * Math.pow(( 1 - t ), n - index) * Math.pow(t, index);
        }
    })
    return {
        x: x,
        y: y
    };

}

function getBezier(controlNodes){
    var bezierArr = [];

    for(let i = 0; i <= 1; i+=0.05){
        bezierArr.push(bezier(i,controlNodes));
    }
    bezierArr.push(bezier(1,controlNodes))
    var all_controlPoints = bezierDerivativesControlNodes(controlNodes,2)
    var d_control_points = all_controlPoints[1]
    var dd_point = bezier(0.4,d_control_points)
    var keyPoint ={
        x:bezier(0.4,controlNodes).x,
        y:bezier(0.4,controlNodes).y,
        yaw :Math.atan2(dd_point.y, dd_point.x),
        id:0

    }

    return [bezierArr, keyPoint]

}

function getBezierLength(btn_node, end_node, p1){
    var control_nodes = calFourControlPoint([btn_node, end_node],p1)
//    console.log("bezier_lane.shape.p1 is ", bezier_lane.shape.p1)
    var allPath = getBezier(control_nodes)
    var path_nodes = allPath[0]
    var dis_all = 0, dis_line = 0
    for(let i = 1; i < path_nodes.length; i++){
        dis_line = getDistance(path_nodes[i], path_nodes[i-1])
//        console.log("dis_line is ", dis_line)
        dis_all += dis_line
    }

    return dis_all


}

function calcVehicleModel(vehicle_model){
    var outline_node1 = {x:vehicle_model.Length/2, y:vehicle_model.Width / 2}
    var outline_node2 = {x:-vehicle_model.Length/2, y:vehicle_model.Width / 2}
    var outline_node3 = {x:-vehicle_model.Length/2, y:-vehicle_model.Width / 2}
    var outline_node4 = {x:vehicle_model.Length/2, y:-vehicle_model.Width / 2}
    var outline = [outline_node1, outline_node2, outline_node3, outline_node4]

    var left_wheel_node1 = {x:vehicle_model.LeftWheelRadius  , y:vehicle_model.WheelWidth /2 + vehicle_model.WheelDistance / 2}
    var left_wheel_node2 = {x:-vehicle_model.LeftWheelRadius, y:vehicle_model.WheelWidth /2 + vehicle_model.WheelDistance / 2}
    var left_wheel_node3 = {x:-vehicle_model.LeftWheelRadius, y:-vehicle_model.WheelWidth /2 + vehicle_model.WheelDistance / 2}
    var left_wheel_node4 = {x:vehicle_model.LeftWheelRadius, y:-vehicle_model.WheelWidth /2 + vehicle_model.WheelDistance / 2}
    var left_wheel = [left_wheel_node1, left_wheel_node2, left_wheel_node3, left_wheel_node4]

    var right_wheel_node1 = {x:vehicle_model.RightWheelRadius , y:vehicle_model.WheelWidth /2 - vehicle_model.WheelDistance / 2}
    var right_wheel_node2 = {x:-vehicle_model.RightWheelRadius, y:vehicle_model.WheelWidth /2 - vehicle_model.WheelDistance / 2}
    var right_wheel_node3 = {x:-vehicle_model.RightWheelRadius, y:-vehicle_model.WheelWidth /2 - vehicle_model.WheelDistance / 2}
    var right_wheel_node4 = {x:vehicle_model.RightWheelRadius, y:-vehicle_model.WheelWidth /2 - vehicle_model.WheelDistance / 2}
    var right_wheel = [right_wheel_node1, right_wheel_node2, right_wheel_node3, right_wheel_node4]
//    console.log("Length is ", vehicle_model.Length)


    return [outline, left_wheel, right_wheel]


}

