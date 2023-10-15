import QtQuick 2.12
import QtQuick.Controls 2.12

TextInput {

    signal tEditFinished()
    property bool editable: true
    selectByMouse: editable
    verticalAlignment: Text.AlignVCenter
    Keys.enabled: editable
    Keys.onReturnPressed: {
        tEditFinished()

    }
    Keys.onEnterPressed: {
        tEditFinished()
    }
}
