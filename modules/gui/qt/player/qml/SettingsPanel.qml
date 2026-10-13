/*****************************************************************************
 * Copyright (C) 2026 VLC authors and VideoLAN
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * ( at your option ) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston MA 02110-1301, USA.
 *****************************************************************************/
import QtQuick
import QtQuick.Templates as T
import QtQuick.Layouts

import VLC.MainInterface
import VLC.Style
import VLC.Player
import VLC.Widgets as Widgets
import VLC.Dialogs
import VLC.Util

// What can be changed about the media that is playing, without leaving it:
// what the settings button of the control bar opens.
PlayerPanel {
    id: root

    enum Tab {
        Playback,
        Video,
        Audio,
        Subtitles
    }

    tabs: [
        { icon: VLCIcons.play, text: qsTr("Playback") },
        { icon: VLCIcons.video, text: qsTr("Video") },
        { icon: VLCIcons.audio, text: qsTr("Audio") },
        { icon: VLCIcons.subtitles, text: qsTr("Subtitles") }
    ]

    currentTab: SettingsPanel.Tab.Playback

    preferredHeight: VLCStyle.dp(946, VLCStyle.scale)

    // Milliseconds as seconds with three decimals, the way delays are shown.
    function _seconds(ms: int) : string {
        return qsTr("%1 s").arg((ms / 1000).toFixed(3))
    }

    TabPage {
        Group {
            title: qsTr("Speed")

            SliderSetting {
                title: qsTr("Playback Speed")
                valueText: qsTr("%1x").arg(Player.rate.toFixed(2))

                // A speed is a ratio: the slider is in powers of two, which
                // puts the normal speed in its middle.
                from: -2
                to: 2
                origin: 0
                stepSize: 0.05

                value: Math.log2(Player.rate)
                onMoved: (value) => { Player.rate = Math.pow(2, value) }

                scaleLabels: [qsTr("0.25x"), qsTr("1x"), qsTr("4x")]
            }
        }
    }

    TabPage {
        // Nothing yet
    }

    TabPage {
        Group {
            title: qsTr("Synchronization")

            SliderSetting {
                title: qsTr("Audio Track Delay")
                valueText: root._seconds(Player.audioDelayMS)

                from: -10000
                to: 10000
                origin: 0
                stepSize: 50

                value: Player.audioDelayMS
                onMoved: (value) => { Player.audioDelayMS = value }

                scaleLabels: [qsTr("-10 s"), qsTr("0 s"), qsTr("+10 s")]
            }
        }
    }

    TabPage {
        Group {
            title: qsTr("Synchronization")

            SliderSetting {
                title: qsTr("Subtitle Track Delay")
                valueText: root._seconds(Player.subtitleDelayMS)

                from: -10000
                to: 10000
                origin: 0
                stepSize: 50

                value: Player.subtitleDelayMS
                onMoved: (value) => { Player.subtitleDelayMS = value }

                scaleLabels: [qsTr("-10 s"), qsTr("0 s"), qsTr("+10 s")]
            }

            SliderSetting {
                title: qsTr("Subtitle Speed")
                valueText: qsTr("%1 fps").arg(Player.subtitleFPS.toFixed(3))

                from: 0
                to: 10
                stepSize: 0.1

                value: Player.subtitleFPS
                onMoved: (value) => { Player.subtitleFPS = value }
            }
        }
    }

    footer: Item {
        width: parent.width
        height: VLCStyle.dp(72, VLCStyle.scale)

        Rectangle {
            width: parent.width
            height: VLCStyle.dp(1, VLCStyle.scale)

            color: root.dividerColor
        }

        T.AbstractButton {
            id: advancedButton

            anchors.fill: parent
            anchors.margins: VLCStyle.dp(20, VLCStyle.scale)

            text: qsTr("Open Advanced Settings")

            Accessible.name: text

            onClicked: {
                root.close()
                DialogsProvider.prefsDialog()
            }

            contentItem: Item {
                Row {
                    anchors.centerIn: parent

                    spacing: VLCStyle.dp(6, VLCStyle.scale)

                    Widgets.IconLabel {
                        anchors.verticalCenter: parent.verticalCenter

                        text: VLCIcons.settings
                        font.pixelSize: VLCStyle.dp(20, VLCStyle.scale)
                        color: advancedLabel.color
                    }

                    T.Label {
                        id: advancedLabel

                        anchors.verticalCenter: parent.verticalCenter

                        text: advancedButton.text
                        font.pixelSize: VLCStyle.dp(14, VLCStyle.scale)
                        color: advancedButton.hovered ? root.tabColor : root.dimColor
                    }
                }
            }
        }
    }

    // What a tab shows: groups of settings, one under the other, that scroll
    // when they do not fit.
    component TabPage: Flickable {
        id: page

        default property alias groups: groupsColumn.data

        contentWidth: width
        contentHeight: groupsColumn.height

        clip: true

        boundsBehavior: Flickable.StopAtBounds

        Column {
            id: groupsColumn

            width: page.width
        }
    }

    // Settings that belong together, under a title. A line sets a group apart
    // from the one before it.
    component Group: Column {
        id: group

        required property string title

        default property alias settings: settingsColumn.data

        width: parent.width

        Rectangle {
            width: parent.width
            height: VLCStyle.dp(1, VLCStyle.scale)

            visible: (group.y > 0)
            color: root.dividerColor
        }

        Item {
            width: parent.width
            height: VLCStyle.dp(39, VLCStyle.scale)

            T.Label {
                x: VLCStyle.margin_large
                y: VLCStyle.dp(20, VLCStyle.scale)

                text: group.title
                font.pixelSize: VLCStyle.dp(16, VLCStyle.scale)
                font.weight: Font.Medium
                color: root.textColor
            }
        }

        Column {
            id: settingsColumn

            x: VLCStyle.dp(20, VLCStyle.scale)
            width: parent.width - 2 * x

            topPadding: VLCStyle.dp(10, VLCStyle.scale)
            bottomPadding: VLCStyle.dp(20, VLCStyle.scale)

            spacing: VLCStyle.dp(5, VLCStyle.scale)
        }
    }

    // A setting that is a number: its name, its value in a box, and a slider
    // to change it, with what the ends and the middle of the slider stand for
    // under it if that needs saying.
    component SliderSetting: Column {
        id: setting

        required property string title
        required property string valueText

        property alias from: slider.from
        property alias to: slider.to
        property alias origin: slider.origin
        property alias stepSize: slider.stepSize
        property alias ticks: slider.ticks

        // Bound to what the setting is. The slider does not write to it,
        // moved() says what the user asked for.
        property real value: 0

        // Texts for the start, the middle and the end of the slider
        property var scaleLabels: []

        signal moved(real value)

        width: parent.width

        spacing: VLCStyle.dp(5, VLCStyle.scale)

        Item {
            width: parent.width
            height: VLCStyle.dp(56, VLCStyle.scale)

            T.Label {
                anchors.verticalCenter: parent.verticalCenter

                x: VLCStyle.margin_xxsmall

                text: setting.title
                font.pixelSize: VLCStyle.dp(14, VLCStyle.scale)
                color: root.dimColor
            }

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right

                width: VLCStyle.dp(140, VLCStyle.scale)
                height: VLCStyle.dp(36, VLCStyle.scale)

                radius: VLCStyle.dp(6, VLCStyle.scale)

                color: root.wellColor

                border.width: VLCStyle.dp(2, VLCStyle.scale)
                border.color: root.wellBorderColor

                T.Label {
                    anchors.verticalCenter: parent.verticalCenter

                    x: VLCStyle.dp(14, VLCStyle.scale)

                    text: setting.valueText
                    font.pixelSize: VLCStyle.dp(14, VLCStyle.scale)
                    color: root.tabColor
                }
            }
        }

        Widgets.BarSlider {
            id: slider

            width: parent.width

            colorContext.palette: root.colorContext.palette

            Accessible.name: setting.title

            // The value follows the setting, also while it is dragged: what
            // was asked for comes back through the setting.
            Binding on value {
                value: setting.value
            }

            onMoved: setting.moved(value)
        }

        Item {
            width: parent.width
            height: VLCStyle.dp(15, VLCStyle.scale)

            visible: (setting.scaleLabels.length === 3)

            Repeater {
                model: setting.scaleLabels

                T.Label {
                    required property string modelData
                    required property int index

                    x: [0, (parent.width - width) / 2, parent.width - width][index]

                    text: modelData
                    font.pixelSize: VLCStyle.dp(12, VLCStyle.scale)
                    color: root.dimColor
                }
            }
        }
    }
}
