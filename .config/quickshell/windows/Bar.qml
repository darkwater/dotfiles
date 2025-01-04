import "../components"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

Variants {
    model: Quickshell.screens

    delegate: PanelWindow {
        id: panel
        required property ShellScreen modelData

        screen: modelData

        WlrLayershell.layer: WlrLayer.Top

        anchors.bottom: true
        anchors.left: true
        anchors.right: true

        height: 30

        color: "transparent"

        RowLayout {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            spacing: 5

            Workspaces {
               screen: panel.modelData
            }
        }

        RowLayout {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            spacing: 5

            Battery { toplevel: panel }
            SysTray { toplevel: panel }
            Clock { toplevel: panel }
        }
    }
}
