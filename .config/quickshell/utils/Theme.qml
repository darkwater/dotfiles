pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property real bgAlpha: 0.9
    property color bg: Qt.alpha("#1d1f21", bgAlpha)

    property var workspaceEmptyColor: Material.transparent
    property var workspaceEmptyBorderColor: Material.transparent

    property var workspaceOtherMonitorColor: Qt.alpha(bg, 0.2)
    property var workspaceOtherMonitorBorderColor: Qt.alpha(Material.amber, 0.3)

    property var workspaceUsedColor: bg
    property var workspaceUsedBorderColor: Material.blueGrey

    property var workspaceActiveColor: bg
    property var workspaceActiveBorderColor: Material.blue

    property var workspaceFont: Qt.font({pixelSize: 16})
}
