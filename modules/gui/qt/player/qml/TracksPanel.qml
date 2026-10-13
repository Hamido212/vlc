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

// The tracks of the current media and where they go, a tab for each kind:
// what the audio and the subtitles buttons of the control bar open.
T.Popup {
    id: root

    enum Tab {
        Video,
        Audio,
        Subtitles
    }

    property int currentTab: TracksPanel.Tab.Subtitles

    readonly property ColorContext colorContext: ColorContext {
        id: theme
        colorSet: ColorContext.Window
    }

    // The panel is made of colors the color sets have no role for, they are
    // taken from the palette by the name they have in the redesign.

    readonly property bool _dark: theme.palette.isDark

    readonly property color _panelColor: _dark ? Qt.alpha(theme.palette.darkBgB1, 0.95)
                                               : Qt.alpha(theme.palette.lightBgB1, 0.8)
    readonly property color _wellColor: _dark ? theme.palette.darkBgB2 : theme.palette.lightBgB2
    readonly property color _dividerColor: _dark ? theme.palette.darkDividerDim : theme.palette.lightDividerDim

    readonly property color _dimColor: _dark ? theme.palette.darkFgA3 : theme.palette.lightFgA3
    readonly property color _tabColor: _dark ? theme.palette.darkFgA2 : theme.palette.lightFgA2
    readonly property color _textColor: _dark ? theme.palette.darkFgA1 : theme.palette.lightFgA1
    readonly property color _hoverColor: _dark ? theme.palette.darkFg1 : theme.palette.lightFgB1

    readonly property real _radius: VLCStyle.dp(10, VLCStyle.scale)

    width: VLCStyle.dp(400, VLCStyle.scale)
    height: VLCStyle.dp(524, VLCStyle.scale)

    padding: 0

    background: Rectangle {
        radius: root._radius
        color: root._panelColor
    }

    contentItem: ColumnLayout {
        spacing: VLCStyle.dp(1, VLCStyle.scale)

        Item {
            // Tabs

            Layout.fillWidth: true

            implicitHeight: VLCStyle.dp(50, VLCStyle.scale)

            // Only the corners at the top are round.
            Rectangle {
                anchors.fill: parent

                radius: root._radius
                color: root._wellColor
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                height: root._radius
                color: root._wellColor
            }

            Row {
                anchors.fill: parent
                anchors.leftMargin: VLCStyle.dp(6, VLCStyle.scale)
                anchors.rightMargin: anchors.leftMargin

                spacing: VLCStyle.dp(1, VLCStyle.scale)

                Repeater {
                    model: [
                        { tab: TracksPanel.Tab.Video, icon: VLCIcons.video, text: qsTr("Video") },
                        { tab: TracksPanel.Tab.Audio, icon: VLCIcons.audio, text: qsTr("Audio") },
                        { tab: TracksPanel.Tab.Subtitles, icon: VLCIcons.subtitles, text: qsTr("Subtitles") }
                    ]

                    T.AbstractButton {
                        id: tabButton

                        required property var modelData

                        readonly property bool current: (root.currentTab === modelData.tab)

                        width: (parent.width - 2 * parent.spacing) / 3
                        height: parent.height

                        text: modelData.text

                        Accessible.role: Accessible.PageTab
                        Accessible.name: text
                        Accessible.selected: current

                        onClicked: root.currentTab = modelData.tab

                        contentItem: Item {
                            Row {
                                anchors.horizontalCenter: parent.horizontalCenter

                                y: VLCStyle.dp(14, VLCStyle.scale)

                                spacing: VLCStyle.margin_xsmall

                                Widgets.IconLabel {
                                    text: tabButton.modelData.icon
                                    font.pixelSize: VLCStyle.dp(20, VLCStyle.scale)
                                    color: tabButton.current ? theme.accent : root._dimColor
                                }

                                T.Label {
                                    anchors.verticalCenter: parent.verticalCenter

                                    text: tabButton.text
                                    font.pixelSize: VLCStyle.dp(12, VLCStyle.scale)
                                    color: (tabButton.current || tabButton.hovered) ? root._tabColor : root._dimColor
                                }
                            }

                            Rectangle {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                anchors.leftMargin: VLCStyle.margin_xsmall
                                anchors.rightMargin: VLCStyle.margin_xsmall

                                height: VLCStyle.dp(2, VLCStyle.scale)

                                visible: tabButton.current
                                color: theme.accent
                            }
                        }
                    }
                }
            }
        }

        StackLayout {
            // Same order as the tabs
            Layout.fillWidth: true
            Layout.fillHeight: true

            currentIndex: root.currentTab

            Section {
                title: qsTr("Video Tracks")
                tracks: Player.videoTracks
            }

            ColumnLayout {
                spacing: VLCStyle.dp(1, VLCStyle.scale)

                Section {
                    title: qsTr("Embedded Tracks")
                    tracks: Player.audioTracks
                }

                Rectangle {
                    Layout.fillWidth: true

                    implicitHeight: VLCStyle.dp(1, VLCStyle.scale)
                    color: root._dividerColor
                }

                Section {
                    title: qsTr("Output Device")
                    tracks: Player.audioDevices
                }
            }

            ColumnLayout {
                spacing: VLCStyle.dp(1, VLCStyle.scale)

                Section {
                    title: qsTr("Embedded Tracks")
                    tracks: Player.subtitleTracks
                }

                Section {
                    // The tracks of a file that was added are listed with
                    // the others above: this is where to add one.
                    title: qsTr("External Tracks")
                    tracks: null

                    actions: Widgets.IconToolButton {
                        text: VLCIcons.add
                        description: qsTr("Add a subtitle file")

                        // What is in a popup does not find the palette of
                        // what the popup belongs to by itself.
                        colorContext.palette: theme.palette

                        onClicked: {
                            root.close()
                            DialogsProvider.loadSubtitlesFile()
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true

            implicitHeight: VLCStyle.dp(72, VLCStyle.scale)

            T.AbstractButton {
                id: preferencesButton

                anchors.fill: parent
                anchors.margins: VLCStyle.dp(20, VLCStyle.scale)

                text: qsTr("Show Preferences")

                Accessible.name: text

                onClicked: {
                    root.close()
                    DialogsProvider.extendedDialog()
                }

                background: Rectangle {
                    radius: VLCStyle.dp(4, VLCStyle.scale)
                    color: root._wellColor
                }

                contentItem: T.Label {
                    text: preferencesButton.text
                    font.pixelSize: VLCStyle.dp(14, VLCStyle.scale)
                    color: preferencesButton.hovered ? root._tabColor : root._dimColor

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    // A title, with room for buttons at its end, and what can be picked
    // under it.
    component Section: ColumnLayout {
        id: section

        required property string title

        // A model with the "display" and "checked" roles
        required property var tracks

        property alias actions: actionsRow.data

        Layout.fillWidth: true
        Layout.fillHeight: true

        spacing: 0

        Item {
            Layout.fillWidth: true

            implicitHeight: VLCStyle.dp(60, VLCStyle.scale)

            T.Label {
                anchors.verticalCenter: parent.verticalCenter

                x: VLCStyle.dp(28, VLCStyle.scale)

                text: section.title
                font.pixelSize: VLCStyle.dp(14, VLCStyle.scale)
                color: root._dimColor
            }

            Row {
                id: actionsRow

                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: VLCStyle.dp(28, VLCStyle.scale)

                spacing: VLCStyle.dp(20, VLCStyle.scale)
            }
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: VLCStyle.dp(20, VLCStyle.scale)
            Layout.rightMargin: Layout.leftMargin

            clip: true

            boundsBehavior: Flickable.StopAtBounds

            spacing: VLCStyle.margin_small

            model: section.tracks

            Accessible.role: Accessible.List
            Accessible.name: section.title

            delegate: T.AbstractButton {
                id: track

                width: ListView.view.width
                height: VLCStyle.dp(32, VLCStyle.scale)

                text: model.display

                Accessible.role: Accessible.RadioButton
                Accessible.name: text
                Accessible.checked: model.checked

                onClicked: model.checked = true

                contentItem: Row {
                    spacing: VLCStyle.dp(10, VLCStyle.scale)

                    Widgets.IconLabel {
                        width: VLCStyle.dp(32, VLCStyle.scale)
                        height: width

                        text: VLCIcons.check
                        font.pixelSize: VLCStyle.icon_normal
                        color: theme.accent

                        opacity: model.checked ? 1.0 : 0.0
                    }

                    T.Label {
                        anchors.verticalCenter: parent.verticalCenter

                        width: parent.width - parent.spacing - VLCStyle.dp(32, VLCStyle.scale)

                        text: track.text
                        elide: Text.ElideRight
                        font.pixelSize: VLCStyle.dp(14, VLCStyle.scale)
                        color: track.hovered ? root._hoverColor : root._textColor
                    }
                }
            }
        }
    }
}
