import "../components"
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

Scope {
    Variants {
        model: Quickshell.screens

        delegate: PanelWindow {
            id: panel
            required property ShellScreen modelData

            screen: modelData

            WlrLayershell.layer: WlrLayer.Bottom

            anchors {
                bottom: true
                left: true
                right: true
            }

            height: 30

            color: "transparent"

            RowLayout {
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                spacing: 5

                Workspaces {
                   screen: panel.modelData
                }
            }

            RowLayout {
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                spacing: 5

                Clock {}
            }
        }
    }
}
