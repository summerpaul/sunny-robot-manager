import QtQuick 2.0
import CADReader 1.0
Item {
    property var cadLines: []
    property var cadPolylines: []

    signal updateCanvas()

    function loadCadFile(filePath){
        cadReader.setFilename(filePath)
    }
    function parseCad(jsonCad){
        cadLines = jsonCad.lines
        cadPolylines = jsonCad.polylines
        updateCanvas()
    }




    CADReader{
        id:cadReader
        onCadChanged: {
            parseCad(jsonCad)
        }
      }

}
