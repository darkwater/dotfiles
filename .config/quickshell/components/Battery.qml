import "../utils"
import "../widgets"
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

Repeater {
    model: UPower.devices.values.filter(device => device.percentage > 0)

    Rectangle {
        required property UPowerDevice modelData

        Layout.fillHeight: true
        Layout.preferredWidth: 80

        color: Theme.bg

        Text {
            id: clock
            anchors.centerIn: parent

            text: Math.round(parent.modelData.percentage * 100)
            color: "white"
            font: Qt.font({pixelSize: 14})
        }

        ProgressIndicator {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 2
            progress: parent.modelData.percentage
            progressColor: (
                parent.modelData.state == UPowerDeviceState.Charging ||
                parent.modelData.state == UPowerDeviceState.FullyCharged
            ) ? Material.blue :
                Material.green
        }
    }
}
