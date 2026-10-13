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


import VLC.Widgets as Widgets
import VLC.Style
import VLC.Player
import VLC.Util

// A button that opens the tracks panel on one of its tabs.
Widgets.IconToolButton {
    id: root

    // Properties

    // One of TracksPanel.Tab
    required property int tab

    readonly property var _parentItem: {
        if ((typeof rootPlayer !== 'undefined') && (rootPlayer !== null))
            return rootPlayer
        else
            return g_mainDisplay
    }

    // Pressing the button while the panel is open closes the panel, as any
    // press outside of it does. The click that follows must not open it again.
    property real _closedAt: 0

    // Signals

    signal requestLockUnlockAutoHide(bool lock)
    signal menuOpened(var menu)

    // Settings

    enabled: panelLoader.status === Loader.Ready

    checked: (panelLoader.item?.visible ?? false) && (panelLoader.item.currentTab === tab)

    // Events

    onClicked: {
        if (Date.now() - _closedAt < 300)
            return

        panelLoader.item.currentTab = tab
        panelLoader.item.open()
    }

    // Children

    Loader {
        id: panelLoader

        sourceComponent: TracksPanel {
            id: panel

            parent: root._parentItem

            // Above the control bar, as far from it and from the edge of the
            // window as the bar keeps its own controls from the edge.
            x: parent.width - width - VLCStyle.controlBarInlineMargin
            y: parent.positionSliderY - height - VLCStyle.controlBarInlineMargin
            z: 1

            height: Math.min(VLCStyle.dp(524, VLCStyle.scale),
                             parent.positionSliderY - 2 * VLCStyle.controlBarInlineMargin)

            focus: true

            colorContext.palette: root.colorContext.palette

            onOpened: {
                root.requestLockUnlockAutoHide(true)
                root.menuOpened(panel)
            }

            onClosed: {
                root._closedAt = Date.now()
                root.requestLockUnlockAutoHide(false)
                root.forceActiveFocus()
                root.menuOpened(null)
            }
        }
    }

    function forceUnlock() {
        // This is also called while the button is being destroyed.
        if (panelLoader && panelLoader.item)
            panelLoader.item.close()
    }
}
