// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Templates as T

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
    T.ToolTip {
        id: captionTip
        text: root.text
        visible: text.length > 0 && (root.hovered || root.visualFocus)
        delay: 650
        x: 0; y: -implicitHeight - theme.dp(4)
        padding: theme.dp(8)
        implicitWidth: Math.min(theme.dp(320), captionText.implicitWidth + leftPadding + rightPadding)
        implicitHeight: captionText.implicitHeight + topPadding + bottomPadding
        Component.onCompleted: if (popupType !== undefined) popupType = 0 // Popup.Item
        contentItem: Text { id: captionText; text: captionTip.text; color: theme.bright; font.pixelSize: theme.dp(14); wrapMode: Text.WordWrap }
        background: Rectangle { color: theme.field; border.color: theme.border; radius: theme.dp(4) }
    }

    background: Rectangle {
        radius: theme.dp(2)
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
        spacing: theme.dp(10)
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: root.leftAligned ? undefined : parent.horizontalCenter
        anchors.left: root.leftAligned ? parent.left : undefined
        anchors.leftMargin: theme.dp(10)
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
