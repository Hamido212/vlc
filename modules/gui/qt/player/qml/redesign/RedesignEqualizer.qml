// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Templates as T

Item {
    id: root
    required property var backend
    property real scaleFactor: 1
    property color accentColor: "#D37918"
    property bool lightTheme: false
    readonly property RedesignTheme theme: RedesignTheme { scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor }
    readonly property var state: { backend.revision; return backend.equalizerState() }
    implicitHeight: theme.dp(489)

    // The user allowed VLC's native band layout inside the opaque Figma EQ instance.
    Rectangle { anchors.fill: parent; color: theme.field; radius: theme.dp(4) }
    Row {
        x: theme.dp(16); y: theme.dp(16)
        width: parent.width - theme.dp(32); height: parent.height - theme.dp(32)
        Repeater {
            model: 11
            Item {
                id: band
                required property int index
                readonly property string label: index === 0 ? qsTr("Preamp") : root.state.frequencyLabels[index - 1]
                width: index === 0 ? theme.dp(94) : (parent.width - theme.dp(94)) / 10
                height: parent.height
                T.Slider {
                    id: slider
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: theme.dp(40); height: parent.height - theme.dp(52)
                    orientation: Qt.Vertical
                    from: root.state.minimum; to: root.state.maximum; stepSize: 0.1
                    snapMode: T.Slider.SnapAlways
                    value: band.index === 0 ? root.state.preamp : root.state.gains[band.index - 1]
                    Accessible.name: band.label
                    background: Rectangle {
                        x: (slider.width - width) / 2; y: slider.topPadding
                        width: theme.dp(8); height: slider.availableHeight; radius: theme.dp(4); color: theme.border
                        Rectangle {
                            y: slider.visualPosition * parent.height
                            width: parent.width; height: parent.height - y; radius: parent.radius; color: theme.progress
                        }
                    }
                    handle: Rectangle {
                        x: (slider.width - width) / 2
                        y: slider.topPadding + slider.visualPosition * (slider.availableHeight - height)
                        width: theme.dp(24); height: theme.dp(8); radius: theme.dp(4); color: theme.accent
                        border.width: slider.visualFocus ? 1 : 0; border.color: theme.bright
                    }
                    onMoved: {
                        if (band.index === 0) root.backend.stageEqualizerPreamp(value)
                        else root.backend.stageEqualizerBand(band.index - 1, value)
                    }
                }
                Text {
                    y: slider.height + theme.dp(8); width: parent.width
                    text: band.label; color: theme.foreground; font.pixelSize: theme.dp(11)
                    horizontalAlignment: Text.AlignHCenter
                }
                Text {
                    y: slider.height + theme.dp(28); width: parent.width
                    text: qsTr("%1 dB").arg((Math.round(slider.value * 10) / 10).toFixed(1)); color: theme.bright; font.pixelSize: theme.dp(11)
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }
}
