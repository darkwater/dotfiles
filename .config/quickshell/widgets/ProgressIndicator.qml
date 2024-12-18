import QtQuick

Rectangle {
    required property real progress
    required property color progressColor

    color: Qt.alpha(this.progressColor, 0.2)

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width * parent.progress
        color: parent.progressColor
    }
}
