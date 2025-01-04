import "../utils"
import QtQuick
import Quickshell

MouseArea {
    id: mousearea

    required property PanelWindow toplevel
    required property real popupWidth
    required property real popupHeight
    default property var content

    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true
    onEntered: {
        popup.visible = true
    }
    onExited: {
        popup.visible = false
    }

    PopupWindow {
        id: popup
        visible: false

        color: Theme.bg

        anchor.window: toplevel
        anchor.onAnchoring: {
            this.anchor.rect.x = parent.mapToItem(toplevel.contentItem, 0, 0).x
        }
        anchor.rect.y: -10
        anchor.rect.width: parent.width
        anchor.rect.height: parent.height
        anchor.edges: Edges.Top
        anchor.gravity: Edges.Top
        width: mousearea.popupWidth
        height: mousearea.popupHeight

        contentItem.data: mousearea.content
    }
}
