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
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
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
import VLC.Playlist
import VLC.Widgets as Widgets
import VLC.Dialogs
import VLC.Util

// What is going to be played, in its order: what the queue button of the
// control bar opens.
PlayerPanel {
    id: root

    enum Tab {
        Queue
    }

    tabs: [
        { icon: VLCIcons.queue, text: qsTr("Queue") }
    ]

    // A queue is long: the panel takes the height there is.
    preferredHeight: VLCStyle.dp(946, VLCStyle.scale)

    // Not a child: children are the pages.
    readonly property PlaylistListModel _model: PlaylistListModel {
        playlist: MainPlaylistController.playlist
    }

    // The row that was picked, which is the one that can be removed. -1 if
    // there is none.
    property int _picked: -1

    // While a row is moved: which one, and the gap between two rows it would
    // go to, counted from the one above the first row.
    property int _moved: -1
    property int _gap: -1

    // "2h 3m" for a duration in seconds
    function _durationText(seconds: int) : string {
        const hours = Math.floor(seconds / 3600)
        const minutes = Math.floor(seconds / 60) % 60

        if (hours > 0)
            return qsTr("%1h %2m").arg(hours).arg(minutes)
        else if (minutes > 0)
            return qsTr("%1m").arg(minutes)
        else
            return qsTr("%1s").arg(seconds)
    }

    function _move(from: int, gap: int) {
        // The gaps around a row are where it is already.
        if (gap === from || gap === from + 1)
            return

        if (gap < _model.count)
            _model.moveItemsPre([from], gap)
        else
            _model.moveItemsPost([from], _model.count - 1)

        _picked = -1
    }

    // Sort by something, the other way around if the queue is sorted by that
    // already.
    function _sort(key) {
        const turn = (key === MainPlaylistController.sortKey)
                     && (MainPlaylistController.sortOrder === PlaylistController.SORT_ORDER_ASC)

        MainPlaylistController.sort(key, turn ? PlaylistController.SORT_ORDER_DESC
                                              : PlaylistController.SORT_ORDER_ASC)
        _picked = -1
    }

    onClosed: _picked = -1

    ColumnLayout {
        spacing: 0

        Item {
            Layout.fillWidth: true

            implicitHeight: VLCStyle.dp(64, VLCStyle.scale)

            T.Label {
                anchors.verticalCenter: parent.verticalCenter

                x: VLCStyle.dp(28, VLCStyle.scale)

                text: {
                    const count = root._model.count
                    const items = (count === 1) ? qsTr("1 item") : qsTr("%1 items").arg(count)
                    const duration = root._model.duration

                    if (count === 0 || !duration.valid())
                        return items

                    return qsTr("%1 - %2").arg(items).arg(root._durationText(duration.toSeconds()))
                }

                font.pixelSize: VLCStyle.dp(14, VLCStyle.scale)
                color: root.dimColor
            }

            Row {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: VLCStyle.dp(20, VLCStyle.scale)

                spacing: VLCStyle.dp(12, VLCStyle.scale)

                HeadButton {
                    text: VLCIcons.sort
                    description: qsTr("Sort")

                    enabled: (root._model.count > 1)

                    checked: sortList.visible

                    onClicked: sortList.open()

                    // What the queue can be sorted by
                    T.Popup {
                        id: sortList

                        x: parent.width - width
                        y: parent.height + VLCStyle.margin_xxsmall

                        width: VLCStyle.dp(180, VLCStyle.scale)
                        height: Math.min(keys.contentHeight + 2 * padding, VLCStyle.dp(240, VLCStyle.scale))

                        padding: VLCStyle.dp(2, VLCStyle.scale)

                        background: Rectangle {
                            radius: VLCStyle.dp(6, VLCStyle.scale)

                            color: root.wellColor

                            border.width: VLCStyle.dp(2, VLCStyle.scale)
                            border.color: root.wellBorderColor
                        }

                        contentItem: ListView {
                            id: keys

                            clip: true

                            boundsBehavior: Flickable.StopAtBounds

                            model: MainPlaylistController.sortKeyTitleList

                            delegate: T.AbstractButton {
                                id: keyButton

                                required property var modelData

                                readonly property bool current: (modelData.criteria === MainPlaylistController.sortKey)

                                width: ListView.view.width
                                height: VLCStyle.dp(32, VLCStyle.scale)

                                text: modelData.text

                                Accessible.name: text

                                onClicked: {
                                    sortList.close()
                                    root._sort(modelData.criteria)
                                }

                                background: Rectangle {
                                    radius: VLCStyle.dp(4, VLCStyle.scale)

                                    color: keyButton.current ? root.accentWellColor
                                                             : (keyButton.hovered ? root.wellBorderColor
                                                                                  : "transparent")
                                }

                                contentItem: T.Label {
                                    leftPadding: VLCStyle.margin_small
                                    rightPadding: VLCStyle.margin_small

                                    verticalAlignment: Text.AlignVCenter

                                    text: keyButton.text
                                    elide: Text.ElideRight
                                    font.pixelSize: VLCStyle.dp(14, VLCStyle.scale)
                                    color: keyButton.current ? root.accentColor : root.tabColor
                                }
                            }
                        }
                    }
                }

                HeadButton {
                    text: (MainPlaylistController.repeatMode === PlaylistController.PLAYBACK_REPEAT_CURRENT) ? VLCIcons.repeat_one
                                                                                                            : VLCIcons.repeat_all
                    description: qsTr("Repeat")

                    checked: (MainPlaylistController.repeatMode !== PlaylistController.PLAYBACK_REPEAT_NONE)

                    onClicked: MainPlaylistController.toggleRepeatMode()
                }

                HeadButton {
                    text: VLCIcons.shuffle
                    description: qsTr("Shuffle")

                    checked: MainPlaylistController.random

                    onClicked: MainPlaylistController.toggleRandom()
                }

                HeadButton {
                    text: VLCIcons.remove
                    description: qsTr("Remove from the queue")

                    enabled: (root._picked >= 0)

                    onClicked: {
                        const picked = root._picked

                        root._picked = -1
                        root._model.removeItems([picked])
                    }
                }

                HeadButton {
                    text: VLCIcons.add
                    description: qsTr("Add files to the queue")

                    onClicked: {
                        root.close()
                        DialogsProvider.simpleOpenDialog(false)
                    }
                }
            }
        }

        ListView {
            id: list

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: VLCStyle.dp(20, VLCStyle.scale)
            Layout.rightMargin: VLCStyle.dp(20, VLCStyle.scale)

            readonly property real rowHeight: VLCStyle.dp(32, VLCStyle.scale)

            clip: true

            boundsBehavior: Flickable.StopAtBounds

            spacing: VLCStyle.dp(12, VLCStyle.scale)

            // The last row keeps the distance from the end of the panel that
            // the first one has from the head.
            bottomMargin: VLCStyle.dp(20, VLCStyle.scale)

            model: root._model

            delegate: T.AbstractButton {
                id: row

                required property int index
                required property var model

                readonly property bool picked: (root._picked === index)

                width: ListView.view.width
                height: list.rowHeight

                text: model.title

                Accessible.name: text

                onClicked: root._picked = index

                onDoubleClicked: MainPlaylistController.goTo(index, true)

                background: Rectangle {
                    radius: VLCStyle.dp(4, VLCStyle.scale)

                    color: row.picked ? root.wellColor : "transparent"
                }

                contentItem: Item {
                    Widgets.IconLabel {
                        id: grip

                        width: VLCStyle.dp(32, VLCStyle.scale)
                        height: width

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        text: VLCIcons.move
                        font.pixelSize: VLCStyle.icon_normal
                        color: (gripArea.pressed || gripArea.containsMouse) ? root.hoverColor : root.tabColor

                        // Moving a row by this: the row stays where it is and
                        // a line shows between which rows it will go.
                        MouseArea {
                            id: gripArea

                            anchors.fill: parent

                            hoverEnabled: true
                            preventStealing: true

                            cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor

                            function _gapAt(mouse) : int {
                                const y = mapToItem(list.contentItem, mouse.x, mouse.y).y
                                const step = list.rowHeight + list.spacing

                                return Math.max(0, Math.min(Math.round((y + list.spacing / 2) / step), list.count))
                            }

                            onPressed: (mouse) => {
                                root._moved = row.index
                                root._gap = _gapAt(mouse)
                            }

                            onPositionChanged: (mouse) => {
                                if (pressed)
                                    root._gap = _gapAt(mouse)
                            }

                            onReleased: {
                                const from = root._moved
                                const gap = root._gap

                                root._moved = -1
                                root._gap = -1

                                if (from >= 0 && gap >= 0)
                                    root._move(from, gap)
                            }

                            onCanceled: {
                                root._moved = -1
                                root._gap = -1
                            }
                        }
                    }

                    T.Label {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: grip.right
                        anchors.leftMargin: VLCStyle.dp(10, VLCStyle.scale)
                        anchors.right: time.left
                        anchors.rightMargin: VLCStyle.dp(10, VLCStyle.scale)

                        text: row.text
                        elide: Text.ElideRight
                        font.pixelSize: VLCStyle.dp(14, VLCStyle.scale)

                        // What plays is told apart by the accent.
                        color: row.model.isCurrent ? root.accentColor
                                                   : (row.hovered ? root.hoverColor : root.textColor)
                    }

                    T.Label {
                        id: time

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: VLCStyle.dp(4, VLCStyle.scale)

                        text: row.model.duration.valid() ? row.model.duration.formatShort() : ""
                        font.pixelSize: VLCStyle.dp(14, VLCStyle.scale)
                        color: root.dimColor
                    }
                }
            }

            // Where the row that is moved will go
            Rectangle {
                parent: list.contentItem

                visible: (root._gap >= 0)

                // In the middle of the gap. There is none over the first row.
                y: Math.max(0, root._gap * (list.rowHeight + list.spacing) - (list.spacing + height) / 2)
                z: 1

                width: list.width
                height: VLCStyle.dp(2, VLCStyle.scale)
                radius: height / 2

                color: root.accentColor
            }
        }
    }

    component HeadButton: Widgets.IconToolButton {
        colorContext.palette: root.colorContext.palette
    }
}
