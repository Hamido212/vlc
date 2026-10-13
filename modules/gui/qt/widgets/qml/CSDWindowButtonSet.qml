/*****************************************************************************
 * Copyright (C) 2020 VLC authors and VideoLAN
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
import QtQuick.Window


import VLC.MainInterface
import VLC.Style

Row {
    id: windowButtonGroup

    spacing: 0
    padding: 0

    width: implicitWidth

    property color color: theme.fg.primary
    property color hoverColor: theme.bg.primary.alpha(0.5)

    // The window buttons are drawn like the rest of the interface, not with
    // the glyphs of the system.
    readonly property bool useWinIcons: false

    // Something to show among the window buttons, in front of the one that
    // closes the window. It gets the height of the buttons.
    property Component beforeClose: null

    readonly property bool buttonHovered: {
        let h = false
        for (let i = 0; i < repeater.count; ++i) {
            const button = repeater.itemAt(i)?.button
            if (button)
                h = h || button.hovered || button.showHovered
        }

        return h
    }

    readonly property ColorContext colorContext: ColorContext {
        id: theme
        colorSet: ColorContext.Window
    }

    Repeater {
        id: repeater

        model: MainCtx.csdButtonModel.windowCSDButtons

        Row {
            id: slot

            required property var modelData

            readonly property alias button: csdButton

            height: windowButtonGroup.height

            Loader {
                active: (slot.modelData.type === CSDButton.Close) && !!windowButtonGroup.beforeClose
                visible: active

                height: parent.height

                sourceComponent: windowButtonGroup.beforeClose
            }

            CSDWindowButton {
                id: csdButton

                height: parent.height

                showHovered: slot.modelData.showHovered

                externalPressed: slot.modelData.externalPressed

                color: (slot.modelData.type === CSDButton.Close && (hovered || slot.modelData.showHovered))
                       ? "white"
                       : windowButtonGroup.color

                hoverColor: (slot.modelData.type === CSDButton.Close) ? "red" : windowButtonGroup.hoverColor

                isThemeDark: theme.palette.isDark

                iconTxt:{
                    switch (slot.modelData.type) {
                    case CSDButton.Minimize:
                    {
                        if (useWinIcons)
                            return "\uE921"

                        else
                            return VLCIcons.window_minimize
                    }

                    case CSDButton.MaximizeRestore:
                    {
                        if (useWinIcons)
                            return (MainCtx.intfMainWindow.visibility === Window.Maximized)
                                    ? "\uE923"
                                    : "\uE922"

                        else
                            return VLCIcons.window_maximize
                    }

                    case CSDButton.Close:
                    {
                        if (useWinIcons)
                            return "\uE8BB"

                        else
                            return VLCIcons.window_close
                    }
                    }
                    console.assert(false, "unreachable")
                }

                onClicked: slot.modelData.click()

                // handles VLCStyle.scale changes
                onWidthChanged: Qt.callLater(updateRect)
                onHeightChanged: Qt.callLater(updateRect)

                Connections {
                    target: VLCStyle

                    // handle window resize
                    function onAppWidthChanged() { Qt.callLater(csdButton.updateRect) }
                    function onAppHeightChanged() { Qt.callLater(csdButton.updateRect) }
                }

                function updateRect() {
                    const point = mapToItem(null, 0, 0)
                    const rect = Qt.rect(point.x, point.y, width, height)

                    slot.modelData.rect = rect
                }
            }
        }
    }
}
