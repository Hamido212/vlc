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

import VLC.Style

// A slider drawn as a bar: the track is filled from where the values start
// to a handle that is taller than the track.
T.Slider {
    id: control

    // The value the filled part starts from. A slider that goes both ways
    // around a neutral value has it there.
    property real origin: from

    // Number of marks spread over the track, ends included. None if less
    // than two.
    property int ticks: 0

    readonly property ColorContext colorContext: ColorContext {
        id: theme

        colorSet: ColorContext.Slider

        enabled: control.enabled
        focused: control.visualFocus
        hovered: control.hovered
    }

    readonly property real _inset: VLCStyle.dp(2, VLCStyle.scale)

    // What the handle can travel, and where it is for a value.
    readonly property real _range: availableWidth - 2 * _inset - handle.width

    function _handleX(value: real) : real {
        const span = to - from
        const position = (span !== 0) ? (value - from) / span : 0

        return leftPadding + _inset + Math.max(0, Math.min(1, position)) * _range
    }

    implicitWidth: VLCStyle.dp(200, VLCStyle.scale)
    implicitHeight: VLCStyle.dp(24, VLCStyle.scale)

    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + (control.availableHeight - height) / 2

        width: control.availableWidth
        height: VLCStyle.dp(16, VLCStyle.scale)

        radius: VLCStyle.dp(6, VLCStyle.scale)

        color: theme.bg.primary

        border.width: VLCStyle.focus_border
        border.color: control.visualFocus ? theme.visualFocus : "transparent"

        Rectangle {
            // From the origin to the handle, both included.

            readonly property real _from: control._handleX(control.origin) - control.leftPadding
            readonly property real _to: control.handle.x - control.leftPadding

            x: Math.min(_from, _to)
            y: control._inset

            width: Math.abs(_to - _from) + control.handle.width
            height: parent.height - 2 * control._inset

            radius: VLCStyle.dp(4, VLCStyle.scale)

            color: theme.bg.secondary
        }

        Repeater {
            model: (control.ticks > 1) ? control.ticks : 0

            Rectangle {
                required property int index

                x: control._inset + control.handle.width / 2
                   + index * control._range / (control.ticks - 1) - width / 2
                y: (parent.height - height) / 2

                width: VLCStyle.dp(1, VLCStyle.scale)
                height: VLCStyle.dp(6, VLCStyle.scale)

                color: theme.fg.primary
                opacity: 0.35
            }
        }
    }

    handle: Rectangle {
        x: control.leftPadding + control._inset + control.visualPosition * control._range
        y: control.topPadding + (control.availableHeight - height) / 2

        width: VLCStyle.dp(8, VLCStyle.scale)
        height: VLCStyle.dp(24, VLCStyle.scale)

        radius: VLCStyle.dp(4, VLCStyle.scale)

        // A shade under the accent, which is kept for what plays.
        color: Qt.darker(theme.fg.primary, control.pressed ? 1.0 : 1.23)
    }
}
