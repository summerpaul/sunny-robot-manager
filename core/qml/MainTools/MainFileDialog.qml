import QtQuick 2.12
import QtQuick.Dialogs 1.3
import "../Data"
import "../Config"
Item {
    //顶层使用Item，不用FileDialog，屏蔽FileDialog内部属性和函数
    enum Type {
        CreateFile,
        OpenFile,
        OpenFiles,
        OpenFolder
    }
    property int m_type
    property var m_acceptCallback: function(file) {}

    FileDialog {
        id: d
        onAccepted: {
            switch(m_type) {
            case MainConfig.DIALOGTYPE.CreateFile:
                m_acceptCallback(d.fileUrl)
                break
            case MainConfig.DIALOGTYPE.OpenFile:
                m_acceptCallback(d.fileUrl)
                break
            case MainConfig.DIALOGTYPE.OpenFiles:
                m_acceptCallback(d.fileUrls)
                break
            case MainConfig.DIALOGTYPE.OpenFolder:
                m_acceptCallback(d.folder)
                break
            }
        }
    }
    function createFile(title, nameFilters, callback) {
        m_type = MainConfig.DIALOGTYPE.CreateFile
        d.selectExisting = false
        d.selectFolder = false
        d.selectMultiple = false
        d.title = title
        d.nameFilters = nameFilters
        m_acceptCallback = callback
        d.open()
    }
    function openFile(title, nameFilters, callback) {
        m_type = MainConfig.DIALOGTYPE.OpenFile
        d.selectExisting = true
        d.selectFolder = false
        d.selectMultiple = false
        d.title = title
        d.nameFilters = nameFilters
        m_acceptCallback = callback
        d.open()
    }
    function openFiles(title, nameFilters, callback) {
        m_type = CanvasConfig.DIALOGTYPE.OpenFiles
        d.selectExisting = true
        d.selectFolder = false
        d.selectMultiple = true
        d.title = title
        d.nameFilters = nameFilters
        m_acceptCallback = callback
        d.open()
    }
    function openFolder(title, callback) {
        m_type = MainConfig.DIALOGTYPE.OpenFolder
        d.selectExisting = true
        d.selectFolder = true
        d.selectMultiple = false
        d.title = title
        m_acceptCallback = callback
        d.open()
    }
}
