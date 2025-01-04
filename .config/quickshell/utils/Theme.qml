pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property real bgAlpha: 0.9
    property color bg: Qt.alpha("#1d1f21", bgAlpha)

    property var workspaceEmptyColors:        ({ bg: Material.transparent,
                                                 border: Qt.alpha(Material.blueGrey, 0.2) })
    property var workspaceOtherMonitorColors: ({ bg: Qt.alpha(bg, 0.2),   
                                                 border: Qt.alpha(Material.amber, 0.3) })
    property var workspaceUsedColors:         ({ bg: bg,                  
                                                 border: Material.blueGrey })
    property var workspaceActiveColors:       ({ bg: bg,
                                                 border: Material.blue })

    property var defaultFont: Qt.font({pixelSize: 14})
    property var smallFont: Qt.font({pixelSize: 10})
    property var iconFont: Qt.font({family: "Hack Nerd Font", pixelSize: 18})

    property color progressIndicatorBg: Material.blueGrey800
}
