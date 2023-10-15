import QtQuick 2.0
import "../../js/Draw.js" as Draw
import "../../js/Common.js" as Common
import "../Data"
import "../Config"
Canvas{
    id:canvas
    property var canvasConfig
    property var vehicleModule
    property var canvasCadData
    property var canvasRoadmapData
    property double canvasScale: 20
    property double lastScale: scale
    property int canvasMode: CanvasConfig.MODES.NAVIGATE
    property int offsetX : width * 0.75
    property int offsetY : height * 0.25
    property int lastOffsetX : offsetX
    property int lastOffsetY : offsetY
    property double lastOriginOffsetX:offsetX
    property double lastOriginOffsetY: offsetY
    property double lastWidth: width
    property double lastHeight: height
    property var lastEventPos:null
    property var offsetMouseEvtPos: null
    property var offsetEvtPos: null// 触发拖拽前的坐标
    property var dragTarget: null


    signal realCanvasPose(double x, double y)
    signal mouseNodePose(double x, double y)

    signal mousePoseChange(double x, double y)

    function backToOrigin(){
        offsetX = width * 0.5
        offsetY = height * 0.5
        requestPaint()
    }

    function followVehicle(){
        offsetX = canvasConfig.locationPose.x * canvasScale +  width * 0.5
        offsetY = -canvasConfig.locationPose.y * canvasScale + height * 0.5
        requestPaint()
    }
    rotation: 180
    onPaint: {
        var ctx =  getContext("2d")
        lastOriginOffsetX =  -(width - lastOffsetX) / lastScale
        lastOriginOffsetY = -lastOffsetY / lastScale
        lastWidth = width / lastScale
        lastHeight = height / lastScale
        ctx.clearRect(lastOriginOffsetX, lastOriginOffsetY, lastWidth, lastHeight)
        ctx.setTransform(-canvasScale, 0, 0, canvasScale, offsetX, offsetY)
        //绘制网格
        Draw.drawGrid(ctx, canvasConfig.gridSpacing, offsetX, offsetY, width, height, canvasScale)
        //绘制cad直线
        Draw.drawCadLines(ctx, canvasCadData.cadLines, 2 /canvasScale , "black")
        //绘制cad线串
        Draw.drawCadPolylines(ctx, canvasCadData.cadPolylines, 2 /canvasScale, "black")
        //绘制起起点坐标系
        Draw.drawOrigin(ctx, 10, 2 /canvasScale)
        //绘制路径线段
        Draw.drawLanes(ctx, canvasRoadmapData.roadmapLanes, 2 /canvasScale, canvasConfig.showLaneID)
        //绘制规划结果
        Draw.drawRouteResult(ctx, canvasRoadmapData.routeResult, canvasRoadmapData.roadmapLanes, 3 /canvasScale, "lime" )
        //绘制路网点
        Draw.drawNodes(ctx, canvasRoadmapData.roadmapNodes,  canvasConfig.roadmapNodeRadius ,
                       canvasConfig.roadmapNodeLineWidth, "black", "blue", true, canvasConfig.showNodeID)


        //绘制里程计轨迹
        if(canvasConfig.showOdomTraj){
            Draw.drawTraj(ctx, canvasConfig.odomTraj,canvasConfig.odomTrajColor)
        }
        //绘制定位的轨迹
        if(canvasConfig.showLocationTraj){
            Draw.drawTraj(ctx, canvasConfig.locationTraj, canvasConfig.locationTrajColor)
        }
        //绘制激光里程计的估计
        if(canvasConfig.showLidarOdomTarj){
//            console.log()
            console.log("canvasConfig.lidarOdomTraj length is " ,canvasConfig.lidarOdomTraj.length)
            Draw.drawTraj(ctx, canvasConfig.lidarOdomTraj, canvasConfig.lidarOdomColor)
        }

        //规划的起点
        if(canvasConfig.hasSearchBN){
            Draw.drawSearchArrow(ctx, searchBN,canvasConfig.nodeRadius,"lime")

        }
        //规划的终点
        if(canvasConfig.hasSearchFN){
            Draw.drawSearchArrow(ctx, searchFN,canvasConfig.nodeRadius,"red")

        }
        //测量距离的起点
        if(canvasConfig.hasMeasureStartNode){
            Draw.drawNode(ctx,measureStartNode,
                          canvasConfig.nodeRadius / 4,
                          canvasConfig.nodeLineWidth, "green", "green", false)
            Draw.drawMeasure(ctx, measureStartNode, measureEndNode, 3 /canvasScale, "green")
        }
        //测量距离的终点
        if(canvasConfig.hasMeasureEndNode){
            Draw.drawNode(ctx,measureEndNode,
                          canvasConfig.nodeRadius / 4,
                          canvasConfig.nodeLineWidth, "green", "green", false)

        }

        //绘制里程计的位姿
        Draw.drawAxis(ctx, canvasConfig.odomPose,0.3,0.02)
        //绘制激光里程计的数据
        Draw.drawAxis(ctx, canvasConfig.lidarOdomPose,0.3,0.02)
        //绘制实时的车辆位姿
        Draw.drawVehicle(ctx, canvasConfig.locationPose,
                         vehicleModule,
                         canvasConfig.vehicleLineWidth,
                         canvasConfig.vehicleColor)
        lastOffsetX = offsetX
        lastOffsetY = offsetY
        lastScale = canvasScale

    }

    MouseArea{
        anchors.fill: parent
        acceptedButtons:  Qt.AllButtons
        hoverEnabled: true
        onPressed: {
            const canvasPosition = Common.getCanvasPos(mouseX, mouseY, offsetX, offsetY, canvasScale)
            if(mouse.button === Qt.MiddleButton){
                canvasMode = CanvasConfig.MODES.MOVE
                lastEventPos = canvasPosition
                offsetMouseEvtPos = {x:mouseX, y:mouseY}
                cursorShape = Qt.ClosedHandCursor
            }
            if(mouse.button !== Qt.LeftButton) return

            switch(canvasConfig.editState){
            case CanvasConfig.EDIEMODES.UNEDIT:
                break
            case CanvasConfig.EDIEMODES.EDIT_POINT:
                var circleRef = Common.ifInCircle(canvasPosition, canvasRoadmapData.roadmapNodes, canvasConfig.roadmapNodeRadius)
                if(mouse.button === Qt.LeftButton){
                    lastEventPos = canvasPosition
                    offsetMouseEvtPos = {x:mouseX, y:mouseY}
                    if(circleRef){
                        dragTarget = circleRef
                        canvasMode=CanvasConfig.MODES.DRAG
                        offsetEvtPos = canvasPosition
                    }
                    else canvasMode = CanvasConfig.MODES.ADDPOINT
                }
                break
            case CanvasConfig.EDIEMODES.EDIT_LINE:
                console.log("in edit line ")
                canvasMode=CanvasConfig.ADDLINE
                circleRef = Common.ifInCircle(canvasPosition, canvasRoadmapData.roadmapNodes, canvasConfig.roadmapNodeRadius)
                if(circleRef){
                    if(!canvasConfig.hasLaneBNID){
                        canvasConfig.laneBNID = circleRef.id
                        canvasConfig.hasLaneBNID  = true
                        console.log("lane bnid is ", canvasConfig.laneBNID)

                    }
                    else {
                        if(canvasConfig.hasLaneBNID === circleRef.id) return
                        canvasConfig.laneFNID = circleRef.id
                        canvasConfig.hasLaneFNID = true
                         console.log("lane fnid is ", canvasConfig.laneFNID)
                    }
                }
                else lastEventPos = canvasPosition

                break
            case CanvasConfig.EDIEMODES.EDIT_CURVE:
                canvasMode=CanvasConfig.ADDCURVE
                circleRef = Common.ifInCircle(canvasPosition, canvasRoadmapData.roadmapNodes, canvasConfig.roadmapNodeRadius)
                if(circleRef){
                    if(!canvasConfig.hasLaneBNID)
                    {
                        canvasConfig.laneBNID = circleRef.id
                        canvasConfig.hasLaneBNID  = true
                    }
                    else {
                        if(canvasConfig.laneBNID === circleRef.id) return
                        canvasConfig.laneFNID = circleRef.id
                        canvasConfig.hasLaneFNID = true
                    }
                }
                else{

                }
                break
            case CanvasConfig.EDIEMODES.EDIT_SEARCH:
                canvasMode=CanvasConfig.SEARCH
                circleRef = Common.ifInCircle(canvasPosition, canvasRoadmapData.roadmapNodes, canvasConfig.roadmapNodeRadius)
                if(!circleRef)
                {
                    return
                }
                if(!canvasConfig.hasSearchBN)
                {
                    canvasConfig.searchBN = circleRef
                    canvasConfig.hasSearchBN = true
                    requestPaint()
                }
                else {
                    if(canvasConfig.searchBN.id === circleRef.id){
                        return
                    }
                    canvasConfig.searchFN = circleRef
                    canvasConfig.hasSearchFN = true
                }
                requestPaint()
                break
            case CanvasConfig.EDIEMODES.EDIT_MEASURE:
                canvasConfig.measureStartNode = canvasPosition
                canvasConfig.measureEndNode = canvasPosition
                canvasConfig.hasMeasureStartNode = true
                console.log("in canvas measure start_position.x = ", canvasConfig.measureStartNode.x)
                requestPaint()
                canvasMode = CanvasConfig.MODES.ADDMEASURE
                break

            }
        }
        onPositionChanged: {
            const canvasPosition = Common.getCanvasPos(mouseX ,mouseY, offsetX, offsetY, canvasScale)
            mousePoseChange(canvasPosition.x, canvasPosition.y)


            var circleRef = Common.ifInCircle(canvasPosition, canvasRoadmapData.roadmapNodes, canvasConfig.roadmapNodeRadius)
            if(circleRef){
//                console.log("in circle")
                cursorShape = Qt.CrossCursor
            }
            else if (canvasMode !== CanvasConfig.MODES.MOVE){
                cursorShape = Qt.ArrowCursor
            }

            switch (canvasMode){
            case CanvasConfig.MODES.MOVE:

                offsetX += mouseX - offsetMouseEvtPos.x
                offsetY += mouseY - offsetMouseEvtPos.y
                offsetMouseEvtPos = {x:mouseX, y:mouseY}
                requestPaint()
                break
            case CanvasConfig.MODES.ADDPOINT:
                break
            case CanvasConfig.MODES.DRAG:
                var drag_yaw = dragTarget.yaw
                var dx = canvasPosition.x  - offsetEvtPos.x
                var dy = canvasPosition.y  - offsetEvtPos.y
                dragTarget.x += dx
                dragTarget.y += dy
                offsetEvtPos = canvasPosition
                requestPaint()
                break
            case CanvasConfig.EDIEMODES.EDIT_LINE:

                break
            case CanvasConfig.MODES.ADDMEASURE:
                canvasConfig.measureEndNode = canvasPosition
                canvasConfig.hasMeasureEndNode = true
                requestPaint()

                break
            }
        }
        onReleased: {
            const canvasPosition = Common.getCanvasPos(mouseX ,mouseY, offsetX, offsetY, canvasScale)
            switch (canvasMode){
            case CanvasConfig.MODES.MOVE:
                canvasMode = CanvasConfig.MODES.NAN
                cursorShape = Qt.ArrowCursor
                break
            case CanvasConfig.MODES.ADDPOINT:
                var yaw = Math.atan2(canvasPosition.y -lastEventPos.y,canvasPosition.x - lastEventPos.x)
                canvasRoadmapData.addPoint(lastEventPos.x, lastEventPos.y, yaw)
                canvasMode = CanvasConfig.MODES.NAN
                requestPaint()
                break
            case CanvasConfig.MODES.DRAG:
                var id = dragTarget.id
                canvasRoadmapData.editPoint(dragTarget.id, dragTarget.x, dragTarget.y)
                canvasMode = CanvasConfig.MODES.NAN
                break
            case CanvasConfig.ADDLINE:
                if(canvasConfig.hasLaneFNID){
                    canvasRoadmapData.addLine(canvasConfig.laneBNID, canvasConfig.laneFNID)
                    canvasConfig.hasLaneBNID = false
                    canvasConfig.hasLaneFNID = false
                }
                break
            case CanvasConfig.ADDCURVE:
                if(canvasConfig.hasLaneFNID){
                    canvasRoadmapData.addCurve(canvasConfig.laneBNID, canvasConfig.laneFNID)
                    canvasConfig.hasLaneBNID = false
                    canvasConfig.hasLaneFNID = false
                }
                break
            case CanvasConfig.SEARCH:
                if(canvasConfig.hasSearchFN){
                    canvasRoadmapData.updateRoadmap();
                    canvasRoadmapData.plan(canvasConfig.searchBN.id, canvasConfig.searchFN.id)
                    requestPaint()


                }
                break
            case CanvasConfig.MODES.ADDMEASURE:
                canvasMode = CanvasConfig.MODES.NAN
                canvasConfig.measureEndNode = canvasPosition
                requestPaint()
            }
        }
        onWheel: {
            var canvasPosition = Common.getCanvasPos(mouseX, mouseY, offsetX, offsetY)
            var deltaX = -canvasPosition.x / canvasScale * canvasConfig.scaleStep
            var deltaY = canvasPosition.y / canvasScale * canvasConfig.scaleStep
            if(wheel.angleDelta.y > 0 && parent.canvasScale < canvasConfig.maxScale){
                offsetX -= deltaX
                offsetY -= deltaY
                canvasScale += canvasConfig.scaleStep
            }
            else if(wheel.angleDelta.y < 0 && canvasScale > canvasConfig.minScale){
                offsetX += deltaX
                offsetY += deltaY
                canvasScale -= canvasConfig.scaleStep
            }
            requestPaint()
        }
    }
}
