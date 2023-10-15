import QtQuick 2.15
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import "../BasicComponent"
import "../../TaoQuick"
Rectangle {
    property int fontSize: 17
    signal saveOdomCaliInfo()
    signal getUmbmarkInfo()
    property bool getCCWError: false
    property bool getCWError: false
    property var umbmarkInfo: {
        "dxCW":0,
        "dxCCW":0,
        "dyawCW":0,
        "dyawCCW":0,
        "dyCW":0,
        "dyCCW":0,
        "square_length":2
    }

    id:odomInfoView

    Row{
        id:cw_row
        anchors.horizontalCenter: parent.horizontalCenter
        Rectangle{
            id:cw
            height: 30
            width: 100
            TText{
                anchors.fill: parent
                text: "顺时针"
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
                clip: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
            }
        }
        Button{
            height: 30
            width: 100
            text: "增加数据"
            font.family: qsTr("微软雅黑")
            onClicked: {
                cw_view.add_table_model()
            }
        }
        Button{
            height: 30
            width: 100
            text: "计算"
            font.family: qsTr("微软雅黑")
            onClicked: {
                var error = cw_view.calcMeanError()
                console.log(error)
                if(error!== undefined){
                    umbmarkInfo.dxCW = error[0]
                    umbmarkInfo.dyCW = error[1]
                    umbmarkInfo.dyawCW = error[2]
                    if(!getCWError){
                        getCWError = true
                    }
                    if(getCCWError && getCWError){
                        getUmbmarkInfo()
                        getCCWError = false
                        getCWError = false

                    }
                }
            }
        }

    }
    UMBmarkInputView{
        id:cw_view
        anchors.top:cw_row.bottom
        width: odomInfoView.width
        height: 200
    }

    Row{
        id:ccw_row
        anchors{
            top: cw_view.bottom
        }
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle{
            height: 30
            width: 100
            TText{
                anchors.fill: parent
                text: "逆时针"
                font.pixelSize: fontSize
                font.family: qsTr("微软雅黑")
                clip: true
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
            }
        }
        Button{
            height: 30
            width: 100
            text: "增加数据"
            font.family: qsTr("微软雅黑")
            onClicked: {
                ccw_view.add_table_model()
                console.log(ccw_view.model.rows)
            }
        }
        Button{
            height: 30
            width: 100
            text: "计算"
            font.family: qsTr("微软雅黑")
            onClicked: {
                var error = ccw_view.calcMeanError()
                console.log(error)
                if(error!== undefined){
                    umbmarkInfo.dxCCW = error[0]
                    umbmarkInfo.dyCCW = error[1]
                    umbmarkInfo.dyawCCW = error[2]
                    if(!getCCWError){
                        getCCWError = true
                    }
                    if(getCCWError && getCWError){
                        getUmbmarkInfo()
                        getCCWError = false
                        getCWError = false
                    }
                }
            }
        }

    }
    UMBmarkInputView{
        id:ccw_view
        anchors.top:ccw_row.bottom
        width: odomInfoView.width
        height: 200
    }
}
