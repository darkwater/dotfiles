import "../utils"
import "../widgets"
import QtQuick
import QtQuick.Layouts
import Quickshell

Rectangle {
    required property PanelWindow toplevel

    id: clock

    Layout.fillHeight: true
    Layout.preferredWidth: 150

    color: Theme.bg

    Text {
        id: time
        anchors.centerIn: parent

        text: Time.time
        color: "white"
        font: Theme.defaultFont
    }

    HoverPopup {
        toplevel: parent.toplevel
        popupWidth: 200
        popupHeight: 40
        Text {
            anchors.centerIn: parent
            text: "foo"
        }
    }
}
