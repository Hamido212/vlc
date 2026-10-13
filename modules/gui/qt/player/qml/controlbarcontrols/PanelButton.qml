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

// A button that opens a PlayerPanel on one of its tabs.
Widgets.IconToolButton {
    id: root

    // Properties

    required property Component panel

    required property int tab

    // Signals

    signal requestLockUnlockAutoHide(bool lock)
    signal menuOpened(var menu)

    // Settings

    checked: (panelLoader.item?.visible ?? false) && (panelLoader.item.currentTab === tab)

    // Events

    onClicked: {
        // The panel is not made before it is asked for.
        panelLoader.active = true
        panelLoader.item.toggle(tab)
    }

    // Children

    Loader {
        id: panelLoader

        active: false

        sourceComponent: root.panel

        onLoaded: item.button = root
    }

    function forceUnlock() {
        // This is also called while the button is being destroyed.
        if (panelLoader && panelLoader.item)
            panelLoader.item.close()
    }
}
