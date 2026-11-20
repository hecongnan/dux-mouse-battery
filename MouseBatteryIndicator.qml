import QtQuick
import Quickshell.Services.UPower
import qs.Common
import qs.DCommon.Widgets

Grid {
    id: root

    property int iconSize: Theme.fontSizeLarge
    property int textSize: Theme.fontSizeMedium
    property color foreground: Theme.surfaceText
    property bool vertical: false
    property real availableTextWidth: Math.ceil(levelMetrics.advanceWidth)

    readonly property var mouse: UPower.devices.values.find(device =>
        device.ready && device.type === UPowerDeviceType.Mouse && device.isPresent
        && device.percentage >= 0 && device.percentage <= 1)
    readonly property int percentage: mouse ? Math.round(mouse.percentage * 100) : -1
    readonly property string percentageText: percentage >= 0 ? percentage + "%" : "—"

    columns: vertical ? 1 : 2
    columnSpacing: Theme.spacingXS
    rowSpacing: 2
    horizontalItemAlignment: Grid.AlignHCenter
    verticalItemAlignment: Grid.AlignVCenter

    Accessible.role: Accessible.StaticText
    Accessible.name: mouse ? qsTr("%1 电量 %2").arg(mouse.model || qsTr("鼠标")).arg(percentageText)
                           : qsTr("鼠标电量不可用")

    DIcon {
        name: "mouse"
        size: root.iconSize
        color: root.foreground
        Accessible.ignored: true
    }

    TextMetrics {
        id: levelMetrics
        font: levelLabel.font
        text: "100%"
    }

    Text {
        id: levelLabel

        width: Math.min(Math.ceil(levelMetrics.advanceWidth), root.availableTextWidth)
        text: root.percentageText
        color: root.foreground
        font.family: Theme.fontFamily
        font.pixelSize: root.textSize
        font.weight: Theme.fontWeightMedium
        font.features: ({ "tnum": 1 })
        fontSizeMode: root.vertical ? Text.HorizontalFit : Text.FixedSize
        minimumPixelSize: 8
        horizontalAlignment: root.vertical ? Text.AlignHCenter : Text.AlignLeft
        Accessible.ignored: true
    }
}
