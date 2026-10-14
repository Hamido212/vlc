// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Templates as T
import VLC.Widgets as Widgets

T.Button {
    id: root
    property real scaleFactor: 1
    property color accentColor: "#d37918"
    property bool lightTheme: false
    property string iconName
    property string caption
    property bool leftAligned: false
    property bool accent: false
    property bool selected: false
    property color foreground: theme.foreground
    property real iconSize: theme.dp(24)
    readonly property RedesignTheme theme: RedesignTheme { scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor }

    implicitWidth: caption.length > 0 ? Math.max(theme.dp(36), contentItem.implicitWidth + theme.dp(16)) : theme.dp(36)
    implicitHeight: theme.dp(36)
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    Accessible.name: text
    Accessible.role: Accessible.Button
    Widgets.ToolTipExt {
        text: root.text
        visible: text.length > 0 && (root.hovered || root.visualFocus)
        delay: 650
    }

    background: Rectangle {
        radius: theme.dp(6)
        color: root.accent ? theme.accent : (root.down || root.selected) ? theme.selected : root.hovered ? theme.hover : "transparent"
        border.width: root.visualFocus ? theme.dp(2) : 0
        border.color: theme.accent
        opacity: root.enabled ? 1 : 0.35
    }
    contentItem: Item {
        implicitWidth: contentRow.implicitWidth
        implicitHeight: contentRow.implicitHeight
        Row {
        id: contentRow
        spacing: theme.dp(6)
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: root.leftAligned ? undefined : parent.horizontalCenter
        anchors.left: root.leftAligned ? parent.left : undefined
        anchors.leftMargin: theme.dp(12)
        RedesignIcon {
            width: root.iconName ? root.iconSize : 0
            height: root.iconSize
            anchors.verticalCenter: parent.verticalCenter
            name: root.iconName
            color: root.iconName === "cone" ? theme.accent : root.accent ? "#161616" : root.selected ? theme.accent : root.hovered || root.visualFocus ? theme.bright : root.foreground
            opacity: root.enabled ? 1 : 0.35
        }
        Text {
            visible: root.caption.length > 0
            anchors.verticalCenter: parent.verticalCenter
            text: root.caption
            color: root.iconName === "cone" ? theme.accent : root.accent ? "#161616" : root.selected ? theme.accent : root.foreground
            font.pixelSize: theme.dp(14)
            opacity: root.enabled ? 1 : 0.35
        }
    }
    }
}
