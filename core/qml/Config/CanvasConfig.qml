import QtQuick 2.0
//与绘图相关的配置文件

QtObject {

    //编辑canvas的模式
    enum MODES{
        ADDPOINT,
        ADDLINE,
        ADDCURVE,
        ADDMEASURE,
        DRAG,
        DELETE,
        SEARCH,
        TRIM,
        NAVIGATE,
        MOVE,
        EDIT,
        NAN
    }

    //各种操作模式
    enum EDIEMODES{
        UNEDIT,
        EDIT_POINT,
        EDIT_LINE,
        EDIT_CURVE,
        EDIT_SEARCH,
        EDIT_MEASURE
    }

    property int editState: CanvasConfig.UNEDIT
    property bool hasLaneBNID: false
    property bool hasLaneFNID: false
    property bool hasSearchBN: false
    property bool hasSearchFN: false
    property int laneBNID: 0
    property int laneFNID: 0
    property bool hasMeasureStartNode: false
    property bool hasMeasureEndNode: false
    property bool showNodeID: true
    property bool showLaneID: false
    property var searchBN: null
    property var searchFN: null
    property var laneLengthMap: []
    property var measureStartNode: null
    property var measureEndNode: null

    readonly property double maxScale: 200 //canvas最大放大倍数
    readonly property double minScale: 3//canvas最小放大倍数
    readonly property double scaleStep: 3.5//canvas单步放大比例
    readonly property double gridSpacing: 1//canvas网格间隔
    readonly property double roadmapNodeRadius: 0.15//绘制的路网点的半径
    readonly property double roadmapNodeLineWidth: 0.04 //绘制的路网点方向线的宽度
    readonly property double roadmapLaneLineWidth: 0.04 //绘制的路网曲线的宽度


    property var locationPose: {
        "x":0,
        "y":0,
        "yaw": 0
    }
    property var locationTraj: []
    property var odomPose: {
        "x":0,
        "y":0,
        "yaw": 0
    }
    property var odomTraj: []
    property var lidarOdomPose: {
        "x":0,
        "y":0,
        "yaw": 0
    }
    property var lidarOdomTraj: []
    property double vehicleLineWidth: 0.02
    property string vehicleColor: "black"


    property double trajWidth: 0.02//轨迹线的宽
    property bool showLocationTraj: false //是否显示定位的轨迹
    property string locationTrajColor: "blue"
    property bool showOdomTraj: false //是否显示里程计轨迹
    property string odomTrajColor: "green"
    property bool showLidarOdomTarj: false //是否显示激光里程计数据
    property string lidarOdomColor: "red"

}
