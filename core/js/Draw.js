Qt.include("Common.js")
//绘制网格
function drawGrid(ctx, gridInterval,offset_x, offset_y, width, height, scale){
    var xgridmin = -(width - offset_x) / scale
    var xgridmax = offset_x/scale
    var ygridmin = -offset_y / scale
    var ygridmax = (height-offset_y) / scale
    ctx.strokeStyle = Qt.rgba(233/255,233/255,233/255,1)
    ctx.lineWidth = 1.5 / scale;

    for (var i = 0; i < xgridmax; i = i + gridInterval) {
        ctx.beginPath()

        ctx.moveTo(i, ygridmin);
        ctx.lineTo(i, ygridmax);
        ctx.stroke()
    }

    for (i = 0; i > xgridmin; i = i - gridInterval) {
        ctx.beginPath()
        ctx.moveTo(i, ygridmin);
        ctx.lineTo(i, ygridmax);
        ctx.stroke()
    }

    for (i = 0; i < ygridmax; i = i + gridInterval) {
        ctx.beginPath()
        ctx.moveTo(xgridmin, i);
        ctx.lineTo(xgridmax, i);
        ctx.stroke()
    }

    for (i = 0; i > ygridmin; i = i - gridInterval) {
        ctx.beginPath()
        ctx.moveTo(xgridmin, i);
        ctx.lineTo(xgridmax, i);
        ctx.stroke()
    }
    ctx.closePath()
}

function drawOrigin(ctx, length , lineWidth, rotation = 0){
    ctx.beginPath()
    ctx.strokeStyle = "red"
    ctx.lineWidth = lineWidth
    var originPose = {x = 0, y = 0}
    var XaisPose = { x = length, y = 0}
    var YaisPose = {x = 0, y = length}
    ctx.rotate(rotation)
    drawLine(ctx, originPose, XaisPose)
//    ctx.rotate(rotation)
    ctx.stroke()
    ctx.beginPath()
    ctx.strokeStyle = "green"
    drawLine(ctx, originPose, YaisPose)
    ctx.stroke()

}

function drawLine(ctx, start_node, end_node){

    ctx.moveTo(start_node.x, start_node.y)
    ctx.lineTo(end_node.x, end_node.y)

}

function drawLines(ctx, nodes){
    nodes.forEach(function(item, index){
        var x = item.x,
        y = item.y
        if (index) {
            var startX = nodes[index - 1].x,
            startY = nodes[index - 1].y
            drawLine(ctx,{x:startX, y:startY}, {x:x,y:y})

        }
    })
}

function drawCadLines(ctx, cad_lines, lineWidth, lineColor){

    ctx.beginPath()
    ctx.strokeStyle = lineColor
    ctx.lineWidth = lineWidth
    cad_lines.forEach(function(item, index){
        var node1 = {
            x: item.x1,
            y: item.y1
        }
        var node2 = {
            x: item.x2,
            y : item.y2
        }
        drawLine(ctx,node1, node2)
    })
    ctx.stroke()
    ctx.closePath()

}

function drawCadPolylines(ctx, cad_polylines, lineWidth, lineColor){
    ctx.beginPath()
    ctx.strokeStyle = lineColor
    ctx.lineWidth = lineWidth
    cad_polylines.forEach(function(item, index){
        var nodes = []
        item.forEach(function(nodeitem, nodeindex){
            var node = {
                x = nodeitem.x,
                y = nodeitem.y
            }
            nodes.push(node)
        })
//        console.log("cad polyline node size", nodes.length)
        drawLines(ctx,nodes)
    })
    ctx.stroke()
    ctx.closePath()
}

function drawNode(ctx, item, circleRarius, lineWidth, lineColor, circleColor, isKeyNodes){
    ctx.beginPath()
    var x = (item.x),
    y = (item.y),
    yaw = item.yaw
    ctx.beginPath()
    ctx.strokeStyle = circleColor
    ctx.arc(x, y, circleRarius, 0, Math.PI * 2,  true)
    ctx.fillStyle = circleColor
    ctx.fill()
    ctx.closePath()
    if(isKeyNodes){
        var endNodes = {
            x = item.x + circleRarius * Math.cos(yaw),
            y = item.y + circleRarius * Math.sin(yaw)
        }
        ctx.beginPath()
        ctx.strokeStyle = lineColor
        ctx.lineWidth = lineWidth
        drawLine(ctx, item,endNodes)
        ctx.stroke()
        ctx.closePath()
    }
}

function drawNodes(ctx, nodes, circleRarius, lineWidth, lineColor, circleColor = "blue", isKeyNodes = true, show_nodeID = true){
    for(let item of nodes.values()){
        drawNode(ctx, item, circleRarius, lineWidth, lineColor, circleColor, isKeyNodes)
        drawID(ctx, item,"bold 2px Arial","#058")
    }
}

function drawLanes(ctx, mapLanes, lineWidth, show_laneID=false){
    ctx.save()

    ctx.lineWidth = lineWidth
    for(let item of mapLanes.values()){
        var btn_node = item.BN
        var end_node = item.FN
        if(item.shape.lane_type === "bezier"){
            var control_nodes = calFourControlPoint([btn_node, end_node],item.shape.p1)
            var allPath = getBezier(control_nodes)
            var path_nodes = allPath[0]
            var keyPoint = allPath[1]
            keyPoint.id = item.lane_id
            ctx.beginPath()
            drawLines(ctx,path_nodes)
        }
        else if(item.shape.lane_type === "line"){
            var dx = end_node.x - btn_node.x
            var dy = end_node.y - btn_node.y
            var k_yaw = Math.atan2(dy, dx)
            var dis = Math.sqrt(dx * dx + dy *dy)
            var k_x = btn_node.x + 0.4 * dis * Math.cos(k_yaw)
            var k_y = btn_node.y + 0.4 * dis * Math.sin(k_yaw)
            keyPoint = {
                x : k_x,
                y : k_y,
                yaw: k_yaw
            }
            keyPoint.id = item.lane_id
            ctx.beginPath()
            drawLine(ctx,btn_node, end_node)
        }
        var id_font = "bold 1px Arial",id_color
        if(item.info.motion_type === 1){
            ctx.strokeStyle = "blue"
            ctx.stroke()
            drawArrow(ctx,keyPoint, 0.3,"blue")
            id_color = "blue"
        }
        else{
            ctx.strokeStyle = "crimson"
            ctx.stroke()
            drawArrow(ctx,keyPoint, 0.3,"crimson")
            id_color = "crimson"
        }
        if(show_laneID){
            drawID(ctx, keyPoint,id_font,id_color)
        }
    }
    ctx.restore()
}

function drawArrow(ctx, item, headlen,color){
    ctx.save()
    ctx.beginPath()
    var theta = 10 * Math.PI / 180
    var arrowX, arrowY, angle1, angle2, topX, topY, botX, botY
    angle1 = item.yaw +  theta
    angle2 = (item.yaw - theta)
    topX = item.x - headlen * Math.cos(angle1)
    topY =  item.y - headlen * Math.sin(angle1)
    botX =item.x - headlen * Math.cos(angle2)
    botY = item.y -headlen * Math.sin(angle2)
    ctx.strokeStyle = color
    ctx.moveTo(topX, topY)
    ctx.lineTo(item.x, item.y);
    ctx.lineTo(botX, botY)
    ctx.closePath()
    ctx.stroke()
    ctx.restore()

}

function drawID(ctx, item, font, color){
    ctx.save ();
    var noodeid = item.id
    var posx = item.x - 0.15
    var posy = item.y + 0.15
    ctx.translate (posx , posy)
    ctx.rotate (Math .PI)
    ctx.scale(-0.15,0.15)
    ctx.translate ( -posx , -posy )
    ctx.font = font
    ctx.fillStyle= color
    ctx.fillText(noodeid, posx, posy)
    ctx.restore ()


}

//function dra
function drawRouteResult(ctx, result, mapLanes,lineWidth, lineColor){
    ctx.save()
    ctx.beginPath()
    ctx.strokeStyle = lineColor
    ctx.lineWidth = lineWidth
    for (let i = 0; i < result.length; i++)
    {
//        console.log("draw result")
        var bezierLane = mapLanes.get(result[i])
        var btn_node = bezierLane.BN
        var end_node = bezierLane.FN
        if(bezierLane.shape.lane_type === "bezier"){
            var control_nodes = calFourControlPoint([btn_node, end_node],bezierLane.shape.p1)
            var allPath = getBezier(control_nodes)
            var path_nodes = allPath[0]
            var keyPoint = allPath[1]
            keyPoint.id = bezierLane.id
            drawLines(ctx,path_nodes)
        }
        else if(bezierLane.shape.lane_type === "line"){
            var dx = end_node.x - btn_node.x
            var dy = end_node.y - btn_node.y
            var k_yaw = Math.atan2(dy, dx)
            var dis = Math.sqrt(dx * dx + dy *dy)
            var k_x = btn_node.x + 0.4 * dis * Math.cos(k_yaw)
            var k_y = btn_node.y + 0.4 * dis * Math.sin(k_yaw)
            keyPoint = {
                x : k_x,
                y : k_y,
                yaw: k_yaw
            }
            keyPoint.id = bezierLane.id
            drawLine(ctx,btn_node, end_node)
        }
        ctx.stroke()
        drawArrow(ctx,keyPoint, 0.3,lineColor)
    }

    ctx.closePath()
    ctx.restore()
}

function drawSearchArrows(ctx, nodes,nodeRidius, color){
    nodes.forEach(function(item, index){
        drawSearchArrow(ctx, item,nodeRidius, color)

    })

}

function drawSearchArrow(ctx, node,nodeRidius, color){
    ctx.save()
    ctx.beginPath()
    var yaw = node.yaw
    ctx.translate (node.x , node.y)
    ctx.rotate (yaw)
    ctx.moveTo(4 *nodeRidius, 0)
    ctx.lineTo(2 *nodeRidius, 2 *nodeRidius)
    ctx.lineTo(-2 *nodeRidius, 2 *nodeRidius)
    ctx.lineTo(-2 *nodeRidius, -2 *nodeRidius)
    ctx.lineTo(2 *nodeRidius, -2 *nodeRidius)
    ctx.translate ( -node.x , -node.y )
    ctx.strokeStyle = color
    ctx.closePath()
    ctx.stroke()
    ctx.restore()

}
function drawMeasure(ctx, btn_node, end_node, lineWidth, lineColor){
    ctx.save()
    ctx.beginPath()
    drawLine(ctx,btn_node, end_node)
    ctx.lineWidth = lineWidth
    ctx.strokeStyle = lineColor
    var dx = end_node.x - btn_node.x
    var dy = end_node.y - btn_node.y
    var k_yaw = Math.atan2(dy, dx)
    var dis = Math.sqrt(dx * dx + dy *dy)
    var k_x = btn_node.x + 0.5 * dis * Math.cos(k_yaw)
    var k_y = btn_node.y + 0.5 * dis * Math.sin(k_yaw)
    var keyPoint = {
        x : k_x,
        y : k_y,
        yaw: k_yaw
    }
    ctx.translate (k_x , k_y)
    ctx.rotate (Math .PI)
    ctx.scale(-0.1,0.1)
    ctx.translate ( -k_x , -k_y )
    ctx.font =  "bold 2px Arial"
    ctx.fillText(getDistance(btn_node, end_node).toFixed(2) + "m", k_x, k_y)
    ctx.stroke()
    ctx.restore()
}

function drawRectangle(ctx, nodes){

    nodes.forEach(function(item, index){
        if(!index){
            ctx.beginPath()
            ctx.moveTo(item.x, item.y)
        }else{
            ctx.lineTo(item.x, item.y)
        }

    })
    ctx.closePath()
    ctx.stroke()
}



function drawVehicle(ctx, node,  vehicle_model, lineWidth, lineColor){
    ctx.save()
    ctx.beginPath()
    ctx.lineWidth = lineWidth
    ctx.strokeStyle = lineColor
    var yaw = node.yaw
//    console.log("vehicle yaw is ", yaw)
    ctx.translate (node.x , node.y)
    ctx.rotate (yaw)

    var model= calcVehicleModel(vehicle_model)
    var outline = model[0]
    var left_wheel = model[1]
    var right_wheel = model[2]
    drawRectangle(ctx, outline)
    drawRectangle(ctx, left_wheel)
    drawRectangle(ctx, right_wheel)
    drawOrigin(ctx, 0.3, lineWidth)
    ctx.translate (vehicle_model.laserX , vehicle_model.laserY)
    drawOrigin(ctx, 0.3, lineWidth, vehicle_model.laserTheta * Math.PI)
    ctx.translate (-vehicle_model.laserX , -vehicle_model.laserY)
    ctx.translate ( -node.x , -node.y )
    ctx.restore()
}

function drawCaliPath(ctx, vehivle_pose, caliPath, lineWidth, lineColor){
    ctx.save()
    ctx.beginPath()
    ctx.lineWidth = lineWidth
    ctx.strokeStyle = lineColor
    var yaw = vehivle_pose.yaw / 180 * Math.PI


    switch(caliPath.path_type){
    case "直线":
        var line_end_node = {
            x:vehivle_pose.x + Math.cos(yaw) * caliPath.length,
            y:vehivle_pose.y + Math.sin(yaw) * caliPath.length
        }
        drawLine(ctx,vehivle_pose, line_end_node )
        break
    case "正方形":
        var rectNode1 = {
            x:vehivle_pose.x + Math.cos(yaw) * caliPath.length,
            y:vehivle_pose.y + Math.sin(yaw) * caliPath.length,
            yaw:yaw+Math.sign(caliPath.angle_speed) *Math.PI * 0.5
        }
        var rectNode2 = {
            x:rectNode1.x + Math.cos(rectNode1.yaw) * caliPath.length,
            y:rectNode1.y + Math.sin(rectNode1.yaw)* caliPath.length,
            yaw:rectNode1.yaw+Math.sign(caliPath.angle_speed) *Math.PI * 0.5
        }
        var rectNode3 = {
            x:rectNode2.x + Math.cos(rectNode2.yaw) * caliPath.length,
            y:rectNode2.y + Math.sin(rectNode2.yaw) * caliPath.length
        }
        drawLines(ctx, [vehivle_pose, rectNode1, rectNode2, rectNode3,vehivle_pose])
    }
    ctx.stroke()
    ctx.restore()

}
function drawTraj(ctx, nodes, lineColor){
    ctx.save()
    ctx.beginPath()
    ctx.strokeStyle = lineColor
    drawLines(ctx, nodes)
    ctx.stroke()
    ctx.restore()
}
function drawAxis(ctx, axisPose, length ,lineWidth){
    ctx.save()
    ctx.beginPath()
    ctx.translate (axisPose.x , axisPose.y)
    ctx.rotate (axisPose.yaw)
    drawOrigin(ctx, length, lineWidth)
    ctx.stroke()
    ctx.restore()
}


