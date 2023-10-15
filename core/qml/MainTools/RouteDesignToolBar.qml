import QtQuick 2.5
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import "../TaoQuick"
import "../Data"
import "../Config"
ToolBar {
    id:toolBar
    signal openFile()
    signal saveFile()

    property var toolbarIcon
    property var toolbarCanvasConfig
    property var toolbarRoadmap
    property int fileType: MainConfig.FILETYPE.NONE
    property bool isConnected: false
    property var connectDialog
    property string laneTemplate: ""
    signal openConnectDialog(bool isOpen)
    signal backToOrigin()
    signal followVehicle()
    signal addVehiclePoint()
    signal updateCanvas()

    function tcpConnect(isConnect){
        if(isConnect){
            isConnected = true
            connectBtn.text = "已连接"
            connectBtn.icon.source =toolbarIcon.connectSrc
        }
        else{
            isConnected = false
            connectBtn.text = "连接"
            connectBtn.icon.source=toolbarIcon.disconnectSrc
        }
    }


    function publishTask(task){
        connectDialog.publishTask(task)
    }
    //设置画布的操作模式
    function setEditStatus(status){
        console.log("editState is ", status)
        toolbarCanvasConfig.editState = status
        switch(status){
        case CanvasConfig.UNEDIT:
            edit_point.checked = false
            edit_line.checked = false
            edit_curve.checked = false
            search.checked = false
            measure.checked = false

            toolbarCanvasConfig.hasMeasureEndNode = false
            toolbarCanvasConfig.hasMeasureStartNode = false

            toolbarCanvasConfig.measureEndNode = null
            toolbarCanvasConfig.measureStartNode = null
            if(toolbarRoadmap.routeResult.size !==0){
                toolbarRoadmap.routeResult = []
                toolbarCanvasConfig.hasSearchBN = false
                toolbarCanvasConfig.hasSearchFN = false
                updateCanvas()
            }

            break
        case CanvasConfig.EDIT_POINT:
            edit_line.checked = false
            edit_curve.checked = false
            search.checked = false
            measure.checked = false
            break
        case CanvasConfig.EDIT_LINE:
            edit_point.checked = false
            edit_curve.checked = false
            search.checked = false
            measure.checked = false
            break
        case CanvasConfig.EDIT_CURVE:
            edit_point.checked = false
            edit_line.checked = false
            search.checked = false
            measure.checked = false
            break
        case CanvasConfig.EDIT_SEARCH:
            edit_point.checked = false
            edit_line.checked = false
            edit_curve.checked = false
            measure.checked = false
            break
        case CanvasConfig.EDIT_MEASURE:
            edit_point.checked = false
            edit_line.checked = false
            edit_curve.checked = false
            search.checked = false
            console.log("in EDIT_MEASURE")
            break
        default:
            break
        }
    }

    Shortcut{
        sequence: "esc"
        onActivated: {
            if(toolbarCanvasConfig.editState !== CanvasConfig.UNEDIT){
                setEditStatus(CanvasConfig.UNEDIT)
            }
        }
    }

    RowLayout{
        ToolButton{
            id:roadmapBtn
            text: "路网"
            icon.source: toolbarIcon.roadmapSrc
            onClicked: {
                fileType = MainConfig.ROADMAP
                openFile()
            }
        }
        ToolButton{
            id:backgroundBtn
            text: "背景"
            icon.source: toolbarIcon.backgroundSrc
            onClicked: {
                fileType = MainConfig.CAD
                openFile()
            }
        }
        ToolButton{
            id:connectBtn
            text: "连接"
            icon.source: toolbarIcon.disconnectSrc
            onClicked: {
                if(!isConnected){
                    openConnectDialog(false)
                }
                else{
                    openConnectDialog(true)
                }
            }
        }

        ToolButton{
            id:saveBtn
            text: "保存"
            icon.source: toolbarIcon.saveSrc
            onClicked: {
                saveFile()
            }
        }
        ToolButton{
            id:withrawBtn
            text: "撤回"
            icon.source: toolbarIcon.withdrawSrc
        }
        ToolButton{
            id:onwardBtn
            text: "前进"
            icon.source: toolbarIcon.onwardSrc
        }
        ToolButton{
            id:edit_point
            text: "点"
            icon.source: toolbarIcon.editPointSrc
            checkable: true
            onClicked: {
                if(toolbarCanvasConfig.editState !== CanvasConfig.EDIT_POINT){
                    setEditStatus(CanvasConfig.EDIT_POINT)
                }
                else{
                    setEditStatus(CanvasConfig.UNEDIT)
                }
            }
        }
        ToolButton{
            id:edit_line
            text: "直线"
            icon.source: toolbarIcon.editLineSrc
            checkable: true
            onClicked: {
                if(toolbarCanvasConfig.editState !== CanvasConfig.EDIT_LINE){
                    setEditStatus(CanvasConfig.EDIT_LINE)
                }
                else{
                    setEditStatus(CanvasConfig.UNEDIT)
                }
            }
        }
        ToolButton{
            id:edit_curve
            text: "曲线"
            icon.source: toolbarIcon.editCurveSrc
            checkable: true
            onClicked: {
                if(toolbarCanvasConfig.editState !== CanvasConfig.EDIT_CURVE){
                    setEditStatus(CanvasConfig.EDIT_CURVE)
                }
                else{
                    setEditStatus(CanvasConfig.UNEDIT)
                }
            }
        }
        ComboBox{
            id:lane_template
            model: ["常规前进", "常规后退"]
            onDisplayTextChanged: {
                laneTemplate = displayText
            }
        }

        ToolButton{
            id:search
            text: "搜索"
            checkable: true
            icon.source: toolbarIcon.searchSrc
            onClicked: {
                if(toolbarCanvasConfig.editState !== CanvasConfig.EDIT_SEARCH){
                    setEditStatus(CanvasConfig.EDIT_SEARCH)
                }
                else{
                    setEditStatus(CanvasConfig.UNEDIT)
                }
            }
        }
        ToolButton{
            id:measure
            text: "测距"
            checkable: true
            icon.source: toolbarIcon.measureSrc
            onClicked: {
                if(toolbarCanvasConfig.editState !== CanvasConfig.EDIT_MEASURE){
                    setEditStatus(CanvasConfig.EDIT_MEASURE)
                }
                else{
                    setEditStatus(CanvasConfig.UNEDIT)
                }
            }
        }
        ToolButton{
            text: "回到原点"
            icon.source: toolbarIcon.originSrc
            onClicked: {
                backToOrigin()
            }
        }
        ToolButton{
            text: "跟踪车辆"
            icon.source: toolbarIcon.vehicleSrc
            checkable: true
            onClicked: {
                followVehicle()
            }
        }
        ToolButton{
            text: "车辆采点"
            onClicked: {
                addVehiclePoint()
            }
        }

        ToolButton{
            text: "导出"
            icon.source: toolbarIcon.exportSrc
            onClicked: {

            }
        }

    }

}

