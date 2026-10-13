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
import VLC.Widgets as Widgets

// A panel that a button of the control bar opens above the bar: tabs at the
// top, a page for each of them, and room for something under the pages.
T.Popup {
    id: root

    // Properties

    // A list of { icon, text }, in the order of the pages
    property var tabs: []

    property int currentTab: 0

    // One item for each tab
    default property alias pages: stack.data

    property alias footer: footerHolder.data

    // The button the panel belongs to. It has to have the
    // requestLockUnlockAutoHide() and menuOpened() signals the control bar
    // expects from a control with a menu.
    property Item button: null

    // As tall as this if the window has the room for it
    property real preferredHeight: VLCStyle.dp(524, VLCStyle.scale)

    readonly property ColorContext colorContext: ColorContext {
        id: theme
        colorSet: ColorContext.Window
    }

    // The panel is made of colors the color sets have no role for, they are
    // taken from the palette by the name they have in the redesign.

    readonly property bool dark: theme.palette.isDark

    readonly property color panelColor: dark ? Qt.alpha(theme.palette.darkBgB1, 0.95)
                                             : Qt.alpha(theme.palette.lightBgB1, 0.8)
    readonly property color wellColor: dark ? theme.palette.darkBgB2 : theme.palette.lightBgB2
    readonly property color wellBorderColor: dark ? theme.palette.darkBgA4 : theme.palette.lightBgA2
    readonly property color dividerColor: dark ? theme.palette.darkDividerDim : theme.palette.lightDividerDim

    readonly property color dimColor: dark ? theme.palette.darkFgA3 : theme.palette.lightFgA3
    readonly property color tabColor: dark ? theme.palette.darkFgA2 : theme.palette.lightFgA2
    readonly property color textColor: dark ? theme.palette.darkFgA1 : theme.palette.lightFgA1
    readonly property color hoverColor: dark ? theme.palette.darkFg1 : theme.palette.lightFgB1
    readonly property color accentColor: theme.accent
    readonly property color knobColor: dark ? theme.palette.darkFgA4 : theme.palette.lightBgA4

    // What is filled in a well in the accent: a slider up to its handle, the
    // half of a switch that says it is on.
    readonly property color accentWellColor: dark ? Qt.darker(theme.accent, 3.8)
                                                  : Qt.tint(theme.palette.lightBgA3, Qt.alpha(theme.accent, 0.35))

    readonly property real cornerRadius: VLCStyle.dp(10, VLCStyle.scale)

    // Private

    readonly property var _parentItem: {
        if ((typeof rootPlayer !== 'undefined') && (rootPlayer !== null))
            return rootPlayer
        else
            return g_mainDisplay
    }

    // Pressing the button while the panel is open closes the panel, as any
    // press outside of it does. The click that follows must not open it again.
    property real _closedAt: 0

    // Functions

    // Open on a tab, or close if this comes from the press that just closed
    // the panel.
    function toggle(tab: int) {
        if (Date.now() - _closedAt < 300)
            return

        currentTab = tab
        open()
    }

    // Settings

    parent: _parentItem

    // Above the control bar, as far from it and from the edge of the window
    // as the bar keeps its own controls from the edge.
    x: parent.width - width - VLCStyle.controlBarInlineMargin
    y: parent.positionSliderY - height - VLCStyle.controlBarInlineMargin
    z: 1

    width: VLCStyle.dp(400, VLCStyle.scale)
    height: Math.min(preferredHeight,
                     parent.positionSliderY - (parent.topBarBottom ?? 0) - 2 * VLCStyle.controlBarInlineMargin)

    padding: 0

    focus: true

    // Events

    // What is in a popup does not find the palette of what the popup belongs
    // to by itself.
    onButtonChanged: {
        if (button)
            colorContext.palette = Qt.binding(function() { return root.button.colorContext.palette })
    }

    onOpened: {
        if (!button)
            return

        button.requestLockUnlockAutoHide(true)
        button.menuOpened(root)
    }

    onClosed: {
        _closedAt = Date.now()

        if (!button)
            return

        button.requestLockUnlockAutoHide(false)
        button.forceActiveFocus()
        button.menuOpened(null)
    }

    // Children

    background: Rectangle {
        radius: root.cornerRadius
        color: root.panelColor
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

                radius: root.cornerRadius
                color: root.wellColor
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                height: root.cornerRadius
                color: root.wellColor
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: VLCStyle.dp(6, VLCStyle.scale)
                anchors.rightMargin: anchors.leftMargin

                spacing: VLCStyle.dp(1, VLCStyle.scale)

                Repeater {
                    model: root.tabs

                    T.AbstractButton {
                        id: tabButton

                        required property var modelData
                        required property int index

                        readonly property bool current: (root.currentTab === index)

                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredWidth: tabContent.implicitWidth + 2 * VLCStyle.margin_xsmall

                        text: modelData.text

                        Accessible.role: Accessible.PageTab
                        Accessible.name: text
                        Accessible.selected: current

                        onClicked: root.currentTab = index

                        contentItem: Item {
                            Row {
                                id: tabContent

                                anchors.horizontalCenter: parent.horizontalCenter

                                y: VLCStyle.dp(14, VLCStyle.scale)

                                spacing: VLCStyle.margin_xsmall

                                Widgets.IconLabel {
                                    text: tabButton.modelData.icon
                                    font.pixelSize: VLCStyle.dp(20, VLCStyle.scale)
                                    color: tabButton.current ? root.accentColor : root.dimColor
                                }

                                T.Label {
                                    anchors.verticalCenter: parent.verticalCenter

                                    text: tabButton.text
                                    font.pixelSize: VLCStyle.dp(12, VLCStyle.scale)
                                    color: (tabButton.current || tabButton.hovered) ? root.tabColor : root.dimColor
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
                                color: root.accentColor
                            }
                        }
                    }
                }
            }
        }

        StackLayout {
            id: stack

            Layout.fillWidth: true
            Layout.fillHeight: true

            currentIndex: root.currentTab
        }

        Item {
            id: footerHolder

            Layout.fillWidth: true

            implicitHeight: childrenRect.height

            visible: (children.length > 0)
        }
    }
}
