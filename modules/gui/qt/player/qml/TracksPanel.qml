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
PlayerPanel {
    id: root

    enum Tab {
        Video,
        Audio,
        Subtitles
    }

    tabs: [
        { icon: VLCIcons.video, text: qsTr("Video") },
        { icon: VLCIcons.audio, text: qsTr("Audio") },
        { icon: VLCIcons.subtitles, text: qsTr("Subtitles") }
    ]

    currentTab: TracksPanel.Tab.Subtitles

    // Not a child: children are the pages.
    readonly property Loader _settingsLoader: Loader {
        active: false

        sourceComponent: SettingsPanel { }
    }

    // The settings that go with the tracks of a tab
    function _showPreferences() {
        const tab = [SettingsPanel.Tab.Video, SettingsPanel.Tab.Audio, SettingsPanel.Tab.Subtitles][currentTab]
        const button = root.button

        close()

        _settingsLoader.active = true
        _settingsLoader.item.button = button
        _settingsLoader.item._closedAt = 0
        _settingsLoader.item.toggle(tab)
    }

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
            color: root.dividerColor
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
            // The tracks of a file that was added are listed with the others
            // above: this is where to add one.
            title: qsTr("External Tracks")
            tracks: null

            actions: Widgets.IconToolButton {
                text: VLCIcons.add
                description: qsTr("Add a subtitle file")

                colorContext.palette: root.colorContext.palette

                onClicked: {
                    root.close()
                    DialogsProvider.loadSubtitlesFile()
                }
            }
        }
    }

    footer: Item {
        width: parent.width
        height: VLCStyle.dp(72, VLCStyle.scale)

        T.AbstractButton {
            id: preferencesButton

            anchors.fill: parent
            anchors.margins: VLCStyle.dp(20, VLCStyle.scale)

            text: qsTr("Show Preferences")

            Accessible.name: text

            onClicked: root._showPreferences()

            background: Rectangle {
                radius: VLCStyle.dp(4, VLCStyle.scale)
                color: root.wellColor
            }

            contentItem: T.Label {
                text: preferencesButton.text
                font.pixelSize: VLCStyle.dp(14, VLCStyle.scale)
                color: preferencesButton.hovered ? root.tabColor : root.dimColor

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
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
                color: root.dimColor
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
                        color: root.accentColor

                        opacity: model.checked ? 1.0 : 0.0
                    }

                    T.Label {
                        anchors.verticalCenter: parent.verticalCenter

                        width: parent.width - parent.spacing - VLCStyle.dp(32, VLCStyle.scale)

                        text: track.text
                        elide: Text.ElideRight
                        font.pixelSize: VLCStyle.dp(14, VLCStyle.scale)
                        color: track.hovered ? root.hoverColor : root.textColor
                    }
                }
            }
        }
    }
}
