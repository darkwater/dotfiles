pragma ComponentBehavior: Bound

import "../utils"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Repeater {
    id: repeater

    required property ShellScreen screen
    readonly property HyprlandMonitor hyprMonitor: Hyprland.monitorFor(this.screen)

    model: Hyprland.workspaces.values.map(ws => ws.id).reduce((a, v) => Math.max(a, v)) + 1

    Rectangle {
        required property var index
        readonly property var workspace: Hyprland.workspaces.values.find(ws => ws.id === index + 1)
        readonly property bool isPlus: index + 1 == repeater.model

        Layout.preferredWidth: (this.isPlus) ? 30 : 50
        Layout.fillHeight: true

        readonly property var colors: {
            if (isPlus) return Theme.workspaceUsedColors;
            let ws = workspace;
            if (ws == null) return Theme.workspaceEmptyColors;
            if (ws.monitor != repeater.hyprMonitor) return Theme.workspaceOtherMonitorColors;
            if (ws == repeater.hyprMonitor.activeWorkspace) return Theme.workspaceActiveColors;
            Theme.workspaceUsedColors
        }

        color: colors.bg
        border.color: colors.border

        MouseArea {
            anchors.fill: parent
            onClicked: Hyprland.dispatch(`workspace ${parent.index + 1}`)
            cursorShape: Qt.PointingHandCursor
        }

        Text {
            anchors.centerIn: parent
            text: (parent.isPlus) ? "+" : parent.index + 1
            color: parent.border.color
            font: Theme.defaultFont
        }
    }
}
