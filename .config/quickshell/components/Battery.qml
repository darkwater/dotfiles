import "../utils"
import "../widgets"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower

Repeater {
    id: repeater
    required property PanelWindow toplevel

    model: UPower.devices.values.filter(device => device.percentage > 0)

    SimpleComponent {
        id: component
        required property UPowerDevice modelData

        Layout.preferredWidth: 80

        icon: ""
        text: Math.round(modelData.percentage * 100)
        suffix: "%"

        progress: modelData.percentage
        componentColor: (
            modelData.state == UPowerDeviceState.Charging ||
            modelData.state == UPowerDeviceState.FullyCharged
        ) ? Material.blue :
            Material.green

        HoverPopup {
            toplevel: repeater.toplevel
            popupWidth: 140
            popupHeight: 40
            Text {
                anchors.centerIn: parent
                text: component.modelData.nativePath
                color: Material.white
                font: Theme.defaultFont
            }
        }
    }
}
