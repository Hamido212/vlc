/*****************************************************************************
 * Copyright (C) 2019 VLC authors and VideoLAN
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
import QtQml.Models


import VLC.MainInterface
import VLC.Style
import VLC.Widgets as Widgets
import VLC.Player
import VLC.Util

T.Pane {
    id: root

    enum TimeTextPosition {
        Hide,
        AboveSlider,
        LeftRightSlider
    }

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    topInset: sliderY

    topPadding: _inlineSlider ? VLCStyle.controlBarInlinePadding : 0
    bottomPadding: _inlineSlider ? VLCStyle.controlBarInlinePadding : VLCStyle.margin_xsmall

    readonly property real sliderY: mapFromItem(contentItem, 0, contentItem.sliderY).y
    property int textPosition: ControlBar.TimeTextPosition.AboveSlider
    property int identifier: -1

    // Put the time and a thick seek bar in the same row as the controls,
    // between the left and the right ones, instead of above them.
    property bool inlineSlider: false

    // The controls have to leave room for it, see PlayerControlLayout.filler
    readonly property bool _inlineSlider: inlineSlider
                                          && (textPosition === ControlBar.TimeTextPosition.LeftRightSlider)
                                          && !!playerControlLayout.filler

    // The time labels are as wide as the longest text they can show. Inlined,
    // they are boxes of the same height as the seek bar next to them.
    readonly property real _timeTextWidth: _inlineSlider ? Math.max(VLCStyle.dp(76, VLCStyle.scale),
                                                                    timeTextMetrics.width + VLCStyle.margin_xsmall * 2)
                                                         : timeTextMetrics.width

    property real sliderHeight: VLCStyle.heightBar_xxsmall
    property real bookmarksHeight: VLCStyle.controlBarBookmarksHeight
    property bool showRemainingTime: true

    property var menu: undefined

    signal requestLockUnlockAutoHide(bool lock)

    ///incomming signal to request all menu and popup to close
    signal forceUnlock()

    enabled: visible

    Keys.priority: Keys.AfterItem
    Keys.onPressed: (event) => root.Navigation.defaultKeyAction(event)
    Navigation.cancelAction: function() { History.previous(Qt.BacktabFocusReason) }

    Accessible.name: qsTr("Player controls")
    AccessibleCompat.id: "playerControlBar"

    function showChapterMarks() {
        if (contentItem.trackPositionSlider)
            contentItem.trackPositionSlider.showChapterMarks()
    }

    function applyMenu(menu) {
        if (root.menu === menu)
            return

        // NOTE: When applying a new menu we hide the previous one.
        if (menu)
            dismiss()

        root.menu = menu
    }

    function dismiss() {
        if ((typeof menu === undefined) || !menu)
            return
        if (menu.hasOwnProperty("dismiss"))
            menu.dismiss()
        else if (menu.hasOwnProperty("close"))
            menu.close()
    }

    readonly property ColorContext colorContext: ColorContext {
        id: theme
        colorSet: ColorContext.Window
    }

    TextMetrics {
        id: timeTextMetrics
        font.pixelSize: {
            if (root._inlineSlider)
                return VLCStyle.dp(15, VLCStyle.scale)
            return (textPosition === ControlBar.TimeTextPosition.LeftRightSlider) ? VLCStyle.fontSize_small
                                                                                  : VLCStyle.fontSize_normal
        }
        text: {
            // This text metrics is used for both the time and length, as we want them to have the same width.
            // Length might not be reported in some cases, for that reason we should check both and use the bigger one.

            // Some extra space to compensate non-monospaced fonts ("-" takes more space than ":", double "-" for guarantee)
            return (Player.time.isSubHour() && Player.length.isSubHour()) ? "00--00" : "00--00--00"
        }
    }

    background: Rectangle {
        color: theme.bg.primary
    }

    contentItem: ColumnLayout {
        spacing: VLCStyle.margin_xsmall

        readonly property real sliderY: root._inlineSlider ? 0 : sliderRowHolder.y

        property alias trackPositionSlider: trackPositionSlider

        property alias mediaRemainingTime: mediaRemainingTime

        property alias playerControlLayout: playerControlLayout

        readonly property list<Item> strayItems: [
            T.Label {
                id: mediaTime

                Layout.preferredWidth: (textPosition === ControlBar.TimeTextPosition.LeftRightSlider) ? root._timeTextWidth : -1

                text: {
                    const length = Player.length
                    return Player.time.formatHMS(length.isSubSecond() ? VLCTick.SubSecondFormattedAsMS : 0)
                }
                color: theme.fg.primary
                font: timeTextMetrics.font
                horizontalAlignment: Text.AlignHCenter

                // TODO: Do not use `Binding` when minimum Qt is 6.12:
                Binding {
                    target: mediaTime
                    property: "mutabilityGroup"
                    when: (mediaTime.mutabilityGroup !== undefined)
                    value: (Player.playingState === Player.PLAYING_STATE_PLAYING) ? Item.ModerateMutabilityGroup
                                                                                  : Item.StaticMutabilityGroup
                }

                anchors.left: (parent === pseudoRow) ? parent.left : undefined
                anchors.verticalCenter: (parent === pseudoRow) ? parent.verticalCenter : undefined
            },
            T.Label {
                id: mediaRemainingTime

                Layout.preferredWidth: (textPosition === ControlBar.TimeTextPosition.LeftRightSlider) ? root._timeTextWidth : -1

                readonly property bool showRemainingTime: (MainCtx.showRemainingTime && Player.remainingTime.valid())

                text: showRemainingTime
                      ? "-" + Player.remainingTime.formatHMS()
                      : Player.length.formatHMS()
                color: mediaTime.color
                font: timeTextMetrics.font
                horizontalAlignment: Text.AlignHCenter

                visible: root.showRemainingTime

                // TODO: Do not use `Binding` when minimum Qt is 6.12:
                Binding {
                    target: mediaRemainingTime
                    property: "mutabilityGroup"
                    when: (mediaRemainingTime.mutabilityGroup !== undefined)
                    value: ((Player.playingState === Player.PLAYING_STATE_PLAYING) &&
                            mediaRemainingTime.showRemainingTime) ? Item.ModerateMutabilityGroup
                                                                  : Item.StaticMutabilityGroup
                }

                anchors.right: (parent === pseudoRow) ? parent.right : undefined
                anchors.verticalCenter: (parent === pseudoRow) ? parent.verticalCenter : undefined

                TapHandler {
                    onTapped: (eventPoint, button) => {
                        MainCtx.showRemainingTime = !MainCtx.showRemainingTime
                    }
                }

                HoverHandler {
                    id: mediaRemainingTimeHover
                }

                Widgets.ToolTipExt {
                    colorContext.palette: theme.palette

                    visible: mediaRemainingTimeHover.hovered && MainCtx.showRemainingTime && Player.rate !== 1
                    delay: VLCStyle.delayToolTipAppear
                    text: {
                        if (!visible)
                            return ""

                        const playbackSpeed = Math.abs(Player.rate)
                        const adjustedRemainingTime = Player.remainingTime.scale(1 / playbackSpeed)
                            ? Player.remainingTime.scale(1 / playbackSpeed)
                            : Player.remainingTime

                        return qsTr("%1 (%2x)")
                            .arg(adjustedRemainingTime.formatHMS())
                            .arg(+Player.rate.toFixed(2))
                    }

                    x: (parent.width - width) / 2
                }
            },
            SliderBar {
                id: trackPositionSlider

                thick: root._inlineSlider
                barHeight: root._inlineSlider ? VLCStyle.controlBarItemHeight : root.sliderHeight

                Accessible.role: Accessible.Slider
                Accessible.name: qsTr("Progress")
                AccessibleCompat.id: "progressSlider"

                Layout.fillWidth: true
                enabled: Player.playingState === Player.PLAYING_STATE_PLAYING || Player.playingState === Player.PLAYING_STATE_PAUSED

                Navigation.parentItem: root
                Navigation.downItem: playerControlLayout

                activeFocusOnTab: true

                focus: true

                Keys.onPressed: (event) => {
                    Navigation.defaultKeyAction(event)
                }
            },
            Loader {
                id: bookmarksLoader

                // Inlined, the seek bar is nested in the controls and its
                // position in the control bar is not at hand, so the
                // bookmarks hang on to the seek bar itself.
                parent: root._inlineSlider ? trackPositionSlider : root
                active: MainCtx.mediaLibraryAvailable
                source: "qrc:///qt/qml/VLC/MediaLibrary/Bookmarks.qml"

                x: root._inlineSlider ? 0
                                      : (root.leftPadding + sliderRowHolder.x + trackPositionSlider.x)
                y: root._inlineSlider ? (trackPositionSlider.height + VLCStyle.margin_xxxsmall)
                                      : (sliderRowHolder.y + sliderRowHolder.height + VLCStyle.margin_xxsmall)
                width: trackPositionSlider.width

                onLoaded: {
                   item.barHeight = Qt.binding(function() { return bookmarksHeight })
                   item.controlBarHovered = Qt.binding(function() { return root.hovered })
                   item.yShift = Qt.binding(function() { return row2.height + VLCStyle.margin_xxsmall })
                }
            }
        ]

        Item {
            // BUG: RowLayout can not be used here
            // because of a Qt bug. (Height is
            // incorrectly determined. Could be
            // about nested layouting).

            id: pseudoRow
            Layout.fillWidth: true
            Layout.fillHeight: false
            Layout.leftMargin: VLCStyle.margin_normal
            Layout.rightMargin: VLCStyle.margin_normal

            implicitHeight: visible ? Math.max(mediaTime.implicitHeight, mediaRemainingTime.implicitHeight) : 0

            visible: children.length > 0

            children: {
                switch (textPosition) {
                case ControlBar.TimeTextPosition.AboveSlider:
                    return [mediaTime, mediaRemainingTime]
                case ControlBar.TimeTextPosition.Hide:
                case ControlBar.TimeTextPosition.LeftRightSlider:
                default:
                    return []
                }
            }
        }

        Item {
            // The seek bar's own row, empty when it is inlined in the controls.
            id: sliderRowHolder

            visible: !root._inlineSlider && row2.hasContent

            implicitHeight: row2.implicitHeight

            Layout.fillWidth: true
            Layout.fillHeight: false
            Layout.leftMargin: (textPosition === ControlBar.TimeTextPosition.LeftRightSlider) ? VLCStyle.margin_xsmall
                                                                                              : 0

            Layout.rightMargin: Layout.leftMargin

            RowLayout {
                id: row2

                readonly property bool hasContent: (children.length > 0)

                parent: root._inlineSlider ? playerControlLayout.filler : sliderRowHolder

                anchors.fill: parent
                anchors.leftMargin: root._inlineSlider ? playerControlLayout.layoutSpacing : 0
                anchors.rightMargin: anchors.leftMargin

                children: {
                    switch (textPosition) {
                    case ControlBar.TimeTextPosition.Hide:
                    case ControlBar.TimeTextPosition.AboveSlider:
                        return [trackPositionSlider]
                    case ControlBar.TimeTextPosition.LeftRightSlider:
                        return [mediaTime, trackPositionSlider, mediaRemainingTime]
                    default:
                        return []
                    }
                }

                visible: hasContent

                spacing: VLCStyle.margin_xsmall
            }
        }

        PlayerControlLayout {
            id: playerControlLayout

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: root._inlineSlider ? VLCStyle.controlBarInlineMargin : VLCStyle.margin_large
            Layout.rightMargin: Layout.leftMargin

            identifier: root.identifier

            implicitHeight: {
                if (root._inlineSlider)
                    return VLCStyle.controlBarInlineHeight
                return MainCtx.pinVideoControls ? VLCStyle.controlLayoutHeightPinned
                                                : VLCStyle.controlLayoutHeight
            }

            // Binding rather than assignments: the layout's own defaults
            // apply again as soon as the seek bar is not inlined.
            Binding on spacing {
                when: root._inlineSlider
                value: VLCStyle.margin_xsmall
            }

            Binding on rightSpacing {
                when: root._inlineSlider
                value: VLCStyle.margin_small
            }

            Binding on layoutSpacing {
                when: root._inlineSlider
                value: VLCStyle.controlBarInlineMargin
            }

            Binding on groupSpacing {
                when: root._inlineSlider
                value: VLCStyle.controlBarInlineMargin
            }

            Binding on buttonPadding {
                when: root._inlineSlider
                value: VLCStyle.dp(3, VLCStyle.scale)
            }

            visible: !model?.empty ?? false

            Navigation.upItem: trackPositionSlider.enabled ? trackPositionSlider : root.Navigation.upItem

            onRequestLockUnlockAutoHide: (lock) => root.requestLockUnlockAutoHide(lock)

            onMenuOpened: (menu) => root.applyMenu(menu)

            Component.onCompleted: {
                root.forceUnlock.connect(playerControlLayout.forceUnlock)
            }
        }
    }

    // The frame under the pointer and its time, above the seek bar. Its
    // parent is the control itself: the layout of the content would take
    // it for a row.
    Rectangle {
        id: seekPreview

        parent: root

        readonly property bool active: root._inlineSlider && trackPositionSlider.pointerOver
                                       && Player.seekable && Player.length.valid()

        readonly property real pointerX: trackPositionSlider.mapToItem(root, trackPositionSlider.pointerPosition * trackPositionSlider.width, 0).x

        visible: active
        z: 1

        width: VLCStyle.dp(272, VLCStyle.scale)
        height: VLCStyle.dp(189, VLCStyle.scale)
        radius: VLCStyle.dp(14, VLCStyle.scale)

        color: Qt.alpha(theme.bg.secondary, 0.95)

        x: Math.max(0, Math.min(seekPreview.pointerX - width / 2, root.width - width))
        y: trackPositionSlider.mapToItem(root, 0, 0).y - height - VLCStyle.margin_xsmall

        Image {
            x: VLCStyle.dp(10, VLCStyle.scale)
            y: VLCStyle.dp(10, VLCStyle.scale)
            width: VLCStyle.dp(252, VLCStyle.scale)
            height: VLCStyle.dp(142, VLCStyle.scale)
            fillMode: Image.PreserveAspectCrop
            source: Player.seekThumbnail
        }

        T.Label {
            x: (parent.width - width) / 2
            y: VLCStyle.dp(162, VLCStyle.scale)
            text: Player.length.scale(trackPositionSlider.pointerPosition).formatHMS()
            color: theme.fg.primary
            font.pixelSize: VLCStyle.dp(15, VLCStyle.scale)
        }
    }

    Connections {
        target: trackPositionSlider
        enabled: seekPreview.active

        function onPointerPositionChanged() { Player.requestSeekThumbnail(trackPositionSlider.pointerPosition) }
        function onPointerOverChanged() { if (trackPositionSlider.pointerOver) Player.requestSeekThumbnail(trackPositionSlider.pointerPosition) }
    }
}
