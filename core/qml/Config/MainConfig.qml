import QtQuick 2.0

QtObject {
    enum VIEWSTATE{
        ROUTE_DESIGNER,
        ROUTE_PLAN,
        AUTO_CALIBTARION,
        ODOM_CALIBTARION,
        LIDIAR_CALIBTARION
    }
    enum FILETYPE{
        NONE,
        ROADMAP,
        CAD,
        PCD,
        CHASSIS_CONFIG
    }
    enum DIALOGTYPE{
        CreateFile,
        OpenFile,
        OpenFiles,
        OpenFolder
    }

    property string vehicleIP: "192.168.8.123"
    property bool isShowDeadReconking: false
    readonly property color backgroundColor: "#336A80"
    readonly property color mainColor: "#52A9CC"
    readonly property color normalColor: Qt.lighter(mainColor)
    readonly property color darkerColor: Qt.darker(mainColor)
    readonly property color constrastColor: "#51BDE8"

}
