// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Layouts
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
        return value.length === 1 ? value.toUpperCase() : value
    }
    signal captureRequested(string name, int key, int modifiers)
    signal clearRequested(string name)
    signal saveRequested()
    signal cancelRequested()
    width: Math.min(theme.dp(1048), parent.width - theme.dp(30))
    height: Math.min(theme.dp(800), parent.height - theme.dp(30))
    x: (parent.width - width) / 2; y: (parent.height - height) / 2
    padding: theme.dp(20)
    modal: true; focus: true
    closePolicy: T.Popup.NoAutoClose
    background: Rectangle { color: theme.background; radius: theme.dp(12); border.color: theme.border }
    onAboutToShow: { recordingName = ""; search.clear(); filter.currentIndex = 0 }
    onOpened: if (!recordingName.length) search.forceActiveFocus()

    ColumnLayout {
        Keys.onEscapePressed: root.cancelRequested()
        anchors.fill: parent
        spacing: theme.dp(16)
        RowLayout {
            Layout.fillWidth: true; Layout.preferredHeight: theme.dp(36); Layout.maximumHeight: theme.dp(36)
            Text { Layout.fillWidth: true; text: qsTr("Keyboard Shortcuts"); color: theme.foreground; font.pixelSize: theme.dp(14) }
            RedesignButton { scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor; iconName: "close"; text: qsTr("Close shortcut editor"); onClicked: root.cancelRequested() }
        }
        RowLayout {
            Layout.fillWidth: true; Layout.preferredHeight: theme.dp(34); Layout.maximumHeight: theme.dp(34)
            T.TextField {
                id: search
                objectName: "shortcutSearch"
                Layout.fillWidth: true; Layout.fillHeight: true
                placeholderText: qsTr("Search Keyboard Shortcuts…")
                color: theme.foreground; placeholderTextColor: theme.foreground
                font.pixelSize: theme.dp(14); selectByMouse: true
                padding: theme.dp(6); verticalAlignment: TextInput.AlignVCenter
                selectionColor: theme.accent; selectedTextColor: theme.bright
                background: Rectangle { radius: theme.dp(5); color: theme.panel; border.color: search.activeFocus ? theme.accent : "transparent" }
                Text {
                    anchors.left: parent.left; anchors.leftMargin: search.leftPadding
                    anchors.verticalCenter: parent.verticalCenter
                    text: search.placeholderText; font: search.font; color: search.placeholderTextColor
                    visible: !search.text.length && !search.preeditText.length
                }
            }
            T.ComboBox {
                id: filter
                Layout.preferredWidth: theme.dp(200); Layout.fillHeight: true
                model: [qsTr("All Fields"), qsTr("Action"), qsTr("Hotkey"), qsTr("Global Hotkey")]
                padding: theme.dp(6); font.pixelSize: theme.dp(14)
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
        Row {
            Layout.fillWidth: true; Layout.preferredHeight: theme.dp(44); Layout.maximumHeight: theme.dp(44)
            Text { width: parent.width * .376; text: qsTr("Action"); color: theme.foreground; font.pixelSize: theme.dp(14) }
            Text { width: parent.width * .268; horizontalAlignment: Text.AlignHCenter; text: qsTr("Hotkey"); color: theme.foreground; font.pixelSize: theme.dp(14) }
            Item { width: parent.width * .088; height: 1 }
            Text { width: parent.width * .268; horizontalAlignment: Text.AlignHCenter; text: qsTr("Global Hotkey"); color: theme.foreground; font.pixelSize: theme.dp(14) }
        }
        ListView {
            id: list
            objectName: "shortcutList"
            Layout.fillWidth: true; Layout.fillHeight: true
            clip: true; model: root.filteredRows
            T.ScrollBar.vertical: Widgets.ScrollBarExt { }
            delegate: Item {
                id: row
                required property int index
                required property var modelData
                readonly property bool groupStart: index === 0 || root.filteredRows[index - 1].group !== modelData.group
                width: list.width; height: theme.dp(46 + (groupStart ? 56 : 0))
                Column {
                    visible: row.groupStart
                    width: parent.width
                    Rectangle { width: parent.width; height: theme.dp(1); color: theme.border }
                    Text { topPadding: theme.dp(20); text: row.modelData.group; color: theme.foreground; font.pixelSize: theme.dp(16) }
                }
                Row {
                    anchors.bottom: parent.bottom; width: parent.width; height: theme.dp(42)
                    Text {
                        width: parent.width * .376; height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        text: row.modelData.title; color: theme.bright; font.pixelSize: theme.dp(14)
                        elide: Text.ElideRight; rightPadding: theme.dp(16)
                    }
                    Loader {
                        width: parent.width * .268; height: theme.dp(34); anchors.verticalCenter: parent.verticalCenter
                        property string actionName: row.modelData.title
                        property string optionName: row.modelData.name
                        sourceComponent: hotkeyCell
                    }
                    Item { width: parent.width * .088; height: 1 }
                    Loader {
                        width: parent.width * .268; height: theme.dp(34); anchors.verticalCenter: parent.verticalCenter
                        property string actionName: row.modelData.title
                        property string optionName: row.modelData.globalName
                        sourceComponent: hotkeyCell
                    }
                }
            }
            Text { anchors.centerIn: parent; visible: list.count === 0; text: qsTr("No matching shortcuts"); color: theme.foreground; font.pixelSize: theme.dp(14) }
        }
        RowLayout {
            Layout.fillWidth: true; Layout.preferredHeight: theme.dp(36); Layout.maximumHeight: theme.dp(36)
            RedesignButton { objectName: "shortcutCancel"; scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor; caption: qsTr("Cancel"); text: caption; onClicked: root.cancelRequested() }
            Text { Layout.fillWidth: true; text: root.errorMessage; color: "#e56b6b"; wrapMode: Text.WordWrap; font.pixelSize: theme.dp(12) }
            RedesignButton { objectName: "shortcutSave"; scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor; caption: qsTr("Save"); text: caption; accent: true; enabled: root.dirty; onClicked: root.saveRequested() }
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
            RedesignIcon { anchors.right: parent.right; anchors.rightMargin: theme.dp(8); anchors.verticalCenter: parent.verticalCenter; width: theme.dp(18); height: width; name: "edit"; color: theme.foreground; visible: !clear.hovered }
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
