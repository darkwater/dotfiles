import "../utils"
import QtQuick
import QtQuick.Layouts

Rectangle {
    Layout.fillHeight: true
    Layout.preferredWidth: 150

    color: Theme.bg

    Text {
        id: clock
        anchors.centerIn: parent

        text: Time.time
        color: "white"
        font: Qt.font({pixelSize: 14})
    }
}
