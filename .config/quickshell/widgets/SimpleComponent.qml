import "../utils"
import "../widgets"
import QtQuick
import QtQuick.Layouts

Rectangle {
    required property string icon
    required property string text
    required property string suffix
    required property real progress
    required property color componentColor

    Layout.fillHeight: true

    color: Theme.bg

    Text {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10

        text: parent.icon
        color: "white"
        font: Theme.iconFont
    }

    Text {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 20

        text: parent.text
        color: "white"
        font: Theme.defaultFont
    }

    Text {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 1.4
        anchors.rightMargin: 10

        text: "%"
        color: "white"
        font: Theme.smallFont
    }

    ProgressIndicator {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 2
        progress: parent.progress
        progressColor: parent.componentColor
    }
}
