// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Templates as T
import VLC.Widgets as Widgets
import VLC.Style

T.Popup {
    id: root
    property real scaleFactor: 1
    property color accentColor: "#d37918"
    property bool lightTheme: false
    property var shortcuts: []
    property var values: ({})
    property bool dirty: false
    property string errorMessage: ""
    property string recordingName: ""
    readonly property RedesignTheme theme: RedesignTheme { scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor }
    readonly property var filteredRows: {
        const needle = search.text.toLocaleLowerCase()
        return shortcuts.filter(row => !needle ||
            (filter.currentIndex === 0 || filter.currentIndex === 1) && row.title.toLocaleLowerCase().includes(needle) ||
            (filter.currentIndex === 0 || filter.currentIndex === 2) && valueFor(row.name).toLocaleLowerCase().includes(needle) ||
            (filter.currentIndex === 0 || filter.currentIndex === 3) && valueFor(row.globalName).toLocaleLowerCase().includes(needle))
    }
    function valueFor(name) { return String(values[name] || "") }
    function displayValue(name) {
        const value = valueFor(name).split("\t")[0]
        if (value.toLocaleLowerCase() === "esc") return "esc"
        return value.length === 1 ? value.toUpperCase() : value
    }
    signal captureRequested(string name, int key, int modifiers)
    signal clearRequested(string name)
    signal saveRequested()
    signal cancelRequested()
    width: Math.min(theme.dp(1048), parent.width)
    height: Math.min(theme.dp(800), parent.height)
    x: (parent.width - width) / 2; y: (parent.height - height) / 2
    padding: 0
    modal: true; focus: true
    closePolicy: T.Popup.NoAutoClose
    background: Rectangle { color: theme.background; radius: theme.dp(12); border.color: theme.border }
    onAboutToShow: { recordingName = ""; search.clear(); filter.currentIndex = 0 }
    onOpened: if (!recordingName.length) search.forceActiveFocus()

    contentItem: Item {
        Keys.onEscapePressed: root.cancelRequested()
        Item {
            x: theme.dp(9); y: theme.dp(9)
            width: parent.width - theme.dp(18); height: theme.dp(32)
            Text {
                x: theme.dp(10); anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Keyboard Shortcuts"); color: theme.foreground; font.pixelSize: theme.dp(14)
            }
            RedesignButton {
                anchors.right: parent.right; width: theme.dp(32); height: theme.dp(32)
                scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
                iconName: "close"; text: qsTr("Close shortcut editor"); onClicked: root.cancelRequested()
            }
        }
        Item {
            x: theme.dp(9); y: theme.dp(53)
            width: parent.width - theme.dp(18); height: theme.dp(34)
            T.TextField {
                id: search
                objectName: "shortcutSearch"
                width: parent.width - theme.dp(210); height: parent.height
                placeholderText: qsTr("Search Keyboard Shortcuts...")
                color: theme.foreground; placeholderTextColor: theme.foreground
                font.pixelSize: theme.dp(14); selectByMouse: true
                padding: theme.dp(6); leftPadding: theme.dp(42); verticalAlignment: TextInput.AlignVCenter
                selectionColor: theme.accent; selectedTextColor: theme.bright
                background: Rectangle { radius: theme.dp(5); color: theme.panel; border.color: search.activeFocus ? theme.accent : "transparent" }
                RedesignIcon {
                    x: theme.dp(8); anchors.verticalCenter: parent.verticalCenter
                    width: theme.dp(24); height: width; name: "search"; color: theme.foreground
                }
                Text {
                    anchors.left: parent.left; anchors.leftMargin: search.leftPadding
                    anchors.verticalCenter: parent.verticalCenter
                    text: search.placeholderText; font: search.font; color: search.placeholderTextColor
                    visible: !search.text.length && !search.preeditText.length
                }
            }
            T.ComboBox {
                id: filter
                anchors.right: parent.right; width: theme.dp(200); height: parent.height
                model: [qsTr("All Fields"), qsTr("Action"), qsTr("Hotkey"), qsTr("Global Hotkey")]
                padding: theme.dp(6); leftPadding: theme.dp(12); rightPadding: theme.dp(8); font.pixelSize: theme.dp(14)
                contentItem: Text {
                    text: filter.displayText; color: theme.foreground; font: filter.font
                    verticalAlignment: Text.AlignVCenter; rightPadding: theme.dp(24)
                }
                indicator: Widgets.IconLabel {
                    x: filter.width - width - filter.rightPadding; y: (filter.height - height) / 2
                    text: VLCIcons.expand; font.pixelSize: theme.dp(20); color: theme.foreground
                }
                delegate: T.ItemDelegate {
                    width: filter.width; height: theme.dp(34); padding: theme.dp(6)
                    contentItem: Text { text: modelData; color: theme.foreground; font: filter.font; verticalAlignment: Text.AlignVCenter }
                    background: Rectangle { color: filter.highlightedIndex === index ? theme.selected : theme.panel }
                }
                popup: T.Popup {
                    y: filter.height; width: filter.width; padding: 1
                    contentItem: ListView {
                        implicitHeight: contentHeight; model: filter.popup.visible ? filter.delegateModel : null
                        currentIndex: filter.highlightedIndex
                    }
                    background: Rectangle { color: theme.panel; border.color: theme.border; radius: theme.dp(4) }
                }
                background: Rectangle { radius: theme.dp(5); color: theme.panel; border.color: filter.activeFocus ? theme.accent : "transparent" }
            }
        }
        Item {
            x: theme.dp(20); y: theme.dp(116)
            width: parent.width - theme.dp(40); height: parent.height - y - theme.dp(72)
            Row {
                width: parent.width; height: theme.dp(25)
                Text { width: parent.width * 488 / 1008; text: qsTr("Action"); color: theme.foreground; font.pixelSize: theme.dp(14) }
                Text { width: parent.width * 332 / 1008; text: qsTr("Hotkey"); color: theme.foreground; font.pixelSize: theme.dp(14) }
                Text { width: parent.width * 93 / 1008; text: qsTr("Global Hotkey"); color: theme.foreground; font.pixelSize: theme.dp(14) }
            }
            ListView {
                id: list
                objectName: "shortcutList"
                y: theme.dp(45); width: parent.width; height: parent.height - y
                clip: true; model: root.filteredRows
                T.ScrollBar.vertical: Widgets.ScrollBarExt {
                    id: scrollBar
                    padding: root.theme.dp(2)
                    visible: size < 1
                    background: Rectangle { color: root.theme.panel; radius: width / 2; visible: scrollBar.interacting }
                    contentItem: Rectangle {
                        implicitWidth: root.theme.dp(6); implicitHeight: root.theme.dp(6)
                        radius: width / 2; color: root.theme.foreground
                    }
                }
                delegate: Item {
                    id: row
                    required property int index
                    required property var modelData
                    readonly property bool groupStart: index === 0 || root.filteredRows[index - 1].group !== modelData.group
                    readonly property real groupOffset: groupStart && index > 0 ? theme.dp(11) : 0
                    readonly property real rowY: groupStart ? theme.dp(68) + groupOffset : 0
                    width: list.width
                    height: rowY + theme.dp(index === list.count - 1 ? 33 : 47)
                    Item {
                        visible: row.groupStart
                        y: row.groupOffset; width: parent.width; height: theme.dp(48)
                        Rectangle { width: parent.width; height: theme.dp(1); color: theme.border }
                        Text { y: theme.dp(20); height: theme.dp(28); text: row.modelData.group; color: theme.foreground; font.pixelSize: theme.dp(16) }
                    }
                    Item {
                        y: row.rowY; width: parent.width; height: theme.dp(33)
                        Text {
                            y: theme.dp(4); width: parent.width * 290 / 1008; height: theme.dp(25)
                            verticalAlignment: Text.AlignVCenter
                            text: row.modelData.title; color: theme.bright; font.pixelSize: theme.dp(14)
                            elide: Text.ElideRight
                        }
                        Loader {
                            x: parent.width * 379 / 1008; width: parent.width * 270 / 1008; height: parent.height
                            property string actionName: row.modelData.title
                            property string optionName: row.modelData.name
                            sourceComponent: hotkeyCell
                        }
                        Loader {
                            x: parent.width * 738 / 1008; width: parent.width * 270 / 1008; height: parent.height
                            property string actionName: row.modelData.title
                            property string optionName: row.modelData.globalName
                            sourceComponent: hotkeyCell
                        }
                    }
                }
                Text { anchors.centerIn: parent; visible: list.count === 0; text: qsTr("No matching shortcuts"); color: theme.foreground; font.pixelSize: theme.dp(14) }
            }
        }
        Item {
            anchors.bottom: parent.bottom; width: parent.width; height: theme.dp(72)
            RedesignButton {
                id: cancel
                objectName: "shortcutCancel"
                x: theme.dp(20); y: theme.dp(20); width: theme.dp(100); height: theme.dp(32)
                scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
                caption: qsTr("Cancel"); text: caption; onClicked: root.cancelRequested()
            }
            Text {
                anchors.left: cancel.right; anchors.right: save.left; anchors.verticalCenter: parent.verticalCenter
                anchors.margins: theme.dp(16)
                text: root.errorMessage; color: "#e56b6b"; wrapMode: Text.WordWrap; font.pixelSize: theme.dp(12)
            }
            RedesignButton {
                id: save
                objectName: "shortcutSave"
                anchors.right: parent.right; anchors.rightMargin: theme.dp(20)
                y: theme.dp(20); width: theme.dp(100); height: theme.dp(32)
                scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
                caption: qsTr("Save"); text: caption; accent: true; enabled: root.dirty; onClicked: root.saveRequested()
            }
        }
    }
    Component {
        id: hotkeyCell
        RedesignButton {
            id: cell
            readonly property string optionName: parent.optionName
            readonly property bool recording: root.recordingName === optionName && optionName.length > 0
            objectName: "shortcut_" + optionName
            scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
            enabled: optionName.length > 0
            text: {
                const title = optionName.startsWith("global-") ? qsTr("Record global shortcut for %1").arg(parent.actionName) : qsTr("Record shortcut for %1").arg(parent.actionName)
                const extras = root.valueFor(optionName).split("\t").slice(1)
                return extras.length ? title + "\n" + qsTr("Other bindings: %1").arg(extras.join(", ")) : title
            }
            background: Rectangle { radius: theme.dp(5); color: theme.field; border.width: cell.recording || cell.visualFocus ? 1 : 0; border.color: theme.accent }
            contentItem: Text {
                text: cell.recording ? qsTr("Press a shortcut…") : root.displayValue(cell.optionName)
                color: cell.recording ? theme.accent : theme.bright; font.pixelSize: theme.dp(14)
                horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight; leftPadding: theme.dp(26); rightPadding: theme.dp(26)
            }
            RedesignIcon { anchors.right: parent.right; anchors.rightMargin: theme.dp(5); anchors.verticalCenter: parent.verticalCenter; width: theme.dp(24); height: width; name: "edit"; color: theme.foreground; visible: !clear.hovered }
            RedesignButton {
                id: clear
                anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
                width: theme.dp(26); height: theme.dp(28)
                scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
                iconName: "close"; iconSize: theme.dp(14); text: qsTr("Clear all shortcuts for this action")
                visible: cell.hovered && root.valueFor(cell.optionName).length > 0
                onClicked: { root.recordingName = ""; root.clearRequested(cell.optionName) }
            }
            onClicked: { root.recordingName = optionName; forceActiveFocus() }
            Keys.onPressed: event => {
                if (!recording) { event.accepted = false; return }
                event.accepted = true
                if (event.key === Qt.Key_Escape) { root.recordingName = ""; return }
                if (event.isAutoRepeat || [Qt.Key_Shift, Qt.Key_Control, Qt.Key_Alt, Qt.Key_Meta, Qt.Key_AltGr].includes(event.key)) return
                root.captureRequested(optionName, event.key, event.modifiers)
                root.recordingName = ""
            }
        }
    }
}
