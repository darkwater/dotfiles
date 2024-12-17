import "../utils"
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

Repeater {
    model: {
        let max = 1;
        for (let ws of Hyprland.workspaces.values) {
            max = Math.max(max, ws.id);
        }
        max
    }

    Rectangle {
        required property var index
        function workspace() {
            return Hyprland.workspaces.values.find(ws => ws.id === index + 1);
        }

        Layout.preferredWidth: 50
        Layout.fillHeight: true

        color: {
            let ws = workspace();
            if (ws == null) return Theme.workspaceEmptyColor;
            if (ws.monitor != Hyprland.monitorFor(panel.modelData)) return Theme.workspaceOtherMonitorColor;
            if (ws == Hyprland.monitorFor(panel.modelData).activeWorkspace) return Theme.workspaceActiveColor;
            return Theme.workspaceUsedColor;
        }
        border.color: {
            let ws = workspace();
            if (ws == null) return Theme.workspaceEmptyBorderColor;
            if (ws.monitor != Hyprland.monitorFor(panel.modelData)) return Theme.workspaceOtherMonitorBorderColor;
            if (ws == Hyprland.monitorFor(panel.modelData).activeWorkspace) return Theme.workspaceActiveBorderColor;
            return Theme.workspaceUsedBorderColor;
        }

        MouseArea {
            anchors.fill: parent
            onClicked: Hyprland.dispatch(`workspace ${parent.index + 1}`)
        }

        Text {
            anchors.centerIn: parent
            text: parent.index + 1
            color: parent.border.color
            font: Theme.workspaceFont
        }
    }
}
