/*****************************************************************************
 * Copyright (C) 2021 VLC authors and VideoLAN
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


import VLC.MainInterface
import VLC.Style
import VLC.Player
import VLC.Playlist
import VLC.Util

T.Control {
    id: root

    // Properties

    property bool paintOnly: false

    readonly property ColorContext colorContext: ColorContext {
        id: theme

        colorSet: ColorContext.ButtonAccent

        enabled: root.enabled || root.paintOnly
        focused: root.activeFocus
        hovered: root.cursorInside
        pressed: mouseArea.containsPress
    }

    // The button stands out as long as there is something to start.
    readonly property bool _playing: !paintOnly
                                     && Player.playingState !== Player.PLAYING_STATE_PAUSED
                                     && Player.playingState !== Player.PLAYING_STATE_STOPPED

    property bool _keyOkPressed: false

    // Aliases

    property alias cursorInside: mouseArea.cursorInside

    // Settings

    implicitWidth: implicitBackgroundWidth + leftInset + rightInset
    implicitHeight: implicitBackgroundHeight + topInset + bottomInset

    scale: (_keyOkPressed || (mouseArea.pressed && cursorInside)) ? 0.95
                                                                  : 1.00

    Accessible.role: Accessible.Button
    Accessible.name: qsTr("Play/Pause")
    AccessibleCompat.id: "playButton"
    Accessible.checkable: true
    Accessible.checked: Player.playingState !== Player.PLAYING_STATE_PAUSED
                        && Player.playingState !== Player.PLAYING_STATE_STOPPED
    Accessible.onPressAction: MainPlaylistController.togglePlayPause()
    Accessible.onToggleAction: MainPlaylistController.togglePlayPause()

    // Tooltip

    T.ToolTip.visible: (hovered || visualFocus)
    T.ToolTip.delay: VLCStyle.delayToolTipAppear
    T.ToolTip.text: root.Accessible.name

    // States

    // Keys

    Keys.onPressed: (event) => {
        if (KeyHelper.matchOk(event) ) {
            if (!event.isAutoRepeat) {
                _keyOkPressed = true
                keyHoldTimer.restart()
                innerRectangle.state = "diminished"
            }
            event.accepted = true
        }
        Navigation.defaultKeyAction(event)
    }

    Keys.onReleased: (event) => {
        if (KeyHelper.matchOk(event)) {
            if (!event.isAutoRepeat) {
                _keyOkPressed = false
                keyHoldTimer.stop()
                innerRectangle.state = ""
                if (Player.playingState !== Player.PLAYING_STATE_STOPPED)
                    MainPlaylistController.togglePlayPause()
            }
            event.accepted = true
        }
    }

    // Functions

    function _pressAndHoldAction() {
        innerRectangle.state = ""
        _keyOkPressed = false
        MainPlaylistController.stop()
    }

    // Children

    Timer {
        id: keyHoldTimer

        interval: mouseArea.pressAndHoldInterval
        repeat: false

        Component.onCompleted: {
            triggered.connect(_pressAndHoldAction)
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        hoverEnabled: true

        readonly property bool cursorInside: containsMouse

        onCursorInsideChanged: {
            if (pressed && !cursorInside) {
                // Press and hold action can no longer be done,
                // so reset the state in order to reset the
                // animation:
                innerRectangle.state = ""
            }
        }

        onPressed: (mouse) => {
            if (!cursorInside) {
                mouse.accepted = false
                return
            }

            root.forceActiveFocus(Qt.MouseFocusReason)
            innerRectangle.state = "diminished"
        }

        onReleased: {
            innerRectangle.state = ""
        }

        onClicked: (mouse) => {
            MainPlaylistController.togglePlayPause()
            mouse.accepted = true
        }

        onPressAndHold: (mouse) => {
            if (!cursorInside) {
                mouse.accepted = false
                return
            }

            _pressAndHoldAction()
            mouse.accepted = true
        }
    }

    contentItem: T.Label {
        text: root._playing ? VLCIcons.pause_filled : VLCIcons.play_filled

        color: root._playing ? theme.fg.secondary : theme.fg.primary

        font.pixelSize: VLCStyle.icon_toolbar

        font.family: VLCIcons.fontFamily

        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter

        Accessible.ignored: true
    }

    background: Rectangle {
        implicitWidth: VLCStyle.dp(54, VLCStyle.scale)
        implicitHeight: VLCStyle.controlBarItemHeight

        radius: VLCStyle.dp(6, VLCStyle.scale)

        color: root._playing ? theme.bg.secondary : theme.bg.primary

        border.width: VLCStyle.focus_border
        border.color: root.visualFocus ? theme.visualFocus : Qt.alpha(theme.visualFocus, 0.0)

        Rectangle {
            // Hovering lightens the button, whichever color it has.
            anchors.fill: parent

            radius: parent.radius

            color: "white"
            opacity: root.cursorInside ? 0.12 : 0.0

            Behavior on opacity {
                NumberAnimation {
                    easing.type: Easing.InOutSine
                    duration: VLCStyle.duration_veryShort
                }
            }
        }

        Rectangle {
            // Fills the button while it is held down, playback stops when
            // it is full.
            id: innerRectangle

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            width: _diminished ? parent.width : 0

            radius: parent.radius

            color: Qt.rgba(0, 0, 0, 0.3)

            property bool _diminished: false

            onStateChanged: {
                if (state === "diminished") {
                    widthBehavior.enabled = true
                    bindingTimer.start()
                } else {
                    bindingTimer.stop()
                    widthBehavior.enabled = false
                    _diminished = false
                }
            }

            Timer {
                // Do not immediately start the animation.
                // Give some time if the intention is not
                // to hold the button.
                id: bindingTimer
                interval: mouseArea.pressAndHoldInterval / 3
                onTriggered: innerRectangle._diminished = true
            }

            Behavior on width {
                id: widthBehavior
                NumberAnimation {
                    // Press and hold action must be triggered
                    // as soon as the fill is complete.
                    // Subtract the interval here so that we satisfy
                    // that condition.
                    duration: mouseArea.pressAndHoldInterval - bindingTimer.interval
                }
            }
        }
    }
}
