import QtQuick 2.12
import QtQuick.Controls 2.5
import Qt.labs.qmlmodels 1.0
import QtQuick.Layouts 1.3

TableView{
    property var horizontal_header_data: ["dx", "dy","dyaw"]
    property int rows_number: 0

    function add_table_model(){
        let row_data = {
            dx:"",
            dy:"",
            dyaw:""
        }
        rows_number++
        if(rows_number === 0 || isNaN(rows_number)){
            tablemodel.clear()
        }
        else if(rows_number > tablemodel.rowCount){
            for(let i = tablemodel.rowCount; i < rows_number; i++) tablemodel.appendRow(row_data)
        }
        tableview.forceLayout()


    }
    function calcMeanError(){
        if(rows_number ===0){
            return
        }
        var all_dx = 0
        var all_dy = 0
        var all_dyaw = 0
        var mean_dx,mean_dy,mean_dyaw

        for(let i = 0; i <  tablemodel.rowCount; i++) {

            all_dx += tablemodel.rows[i].dx *1
            all_dy += tablemodel.rows[i].dy *1
            var dyaw = Math.atan(tablemodel.rows[i].dyaw)
            all_dyaw += dyaw
        }
        mean_dx = all_dx /  tablemodel.rowCount
        mean_dy = all_dy /  tablemodel.rowCount
        mean_dyaw = all_dyaw /tablemodel.rowCount
        console.log("mean_dyaw is ", mean_dyaw)
        return [mean_dx, mean_dy,mean_dyaw]

    }

    id: tableview
    clip: true
    boundsBehavior: Flickable.StopAtBounds
    width:  0.8*arent.width;
    height: 0.8 * parent.height
    anchors.horizontalCenter: parent.horizontalCenter
    reuseItems: false
    columnSpacing: 1
    leftMargin: verticalHeader.width
    topMargin: horizontalHeader.height
    ScrollBar.vertical: ScrollBar{
    }
    ScrollIndicator.horizontal: ScrollIndicator { }
    ScrollIndicator.vertical: ScrollIndicator { }
    property var columnWidths: [100, 80, 120, 100, 100]
    columnWidthProvider: function(column){ return columnWidths[column] }
    rowHeightProvider: function (column) { return 25 }

    // table horizontal header
    Row {
        id: horizontalHeader
        y: tableview.contentY
        z: 2
        Repeater {
            model: tableview.columns
            Label {
                width: tableview.columnWidthProvider(modelData);
                height: 30
                text: horizontal_header_data[index]
                padding: 10
                verticalAlignment: Text.AlignVCenter;
                horizontalAlignment: Text.AlignHCenter
                color: "white"
                background: Rectangle { color: "#b5b5b5" }
            }
        }
    }

    // table vertical header
    Column {
        id: verticalHeader
        x: tableview.contentX
        z: 2
        Repeater {
            model: tableview.rows
            Label {
                width:30
                height: tableview.rowHeightProvider(modelData)
                text: index
                padding: 10
                verticalAlignment: Text.AlignVCenter;
                horizontalAlignment: Text.AlignHCenter
                color: "white"
                background: Rectangle { color: "#b5b5b5" }
            }
        }
    }
    model: TableModel {
        id: tablemodel

        TableModelColumn{ display: "dx" }
        TableModelColumn{ display: "dy" }
        TableModelColumn{ display: "dyaw" }

    }
    delegate: DelegateChooser {
        DelegateChoice {
            column: 0
            delegate:

                TextField {

                implicitWidth: 30
                verticalAlignment: Text.AlignVCenter;
                horizontalAlignment: Text.AlignHCenter
                text: model.display
                placeholderText: "dx"
                selectByMouse: true
                onTextEdited: model.display = this.text
            }
        }
        DelegateChoice {
            column: 1
            delegate:
                TextField {
                implicitWidth:30
                verticalAlignment: Text.AlignVCenter;
                horizontalAlignment: Text.AlignHCenter
                text: model.display
                placeholderText: "dy"
                selectByMouse: true
                onTextEdited: model.display = this.text
            }
        }
        DelegateChoice {
            column: 2
            delegate:
                TextField {
                implicitWidth: 30
                verticalAlignment: Text.AlignVCenter;
                horizontalAlignment: Text.AlignHCenter
                text: model.display
                placeholderText: "dyaw"
                selectByMouse: true
                onTextEdited: model.display = this.text
            }
        }


    }


}

