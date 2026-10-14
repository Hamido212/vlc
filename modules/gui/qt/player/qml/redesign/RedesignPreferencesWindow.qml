// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Templates as T
import VLC.Widgets as Widgets
import VLC.MainInterface
import VLC.Style
import VLC.Dialogs

Window {
    id: root
    title: qsTr("Settings — VLC Media Player")
    width: Math.min(theme.dp(1078), Screen.desktopAvailableWidth - theme.dp(40))
    height: Math.min(theme.dp(895), Screen.desktopAvailableHeight - theme.dp(60))
    minimumWidth: theme.dp(640); minimumHeight: theme.dp(440)
    flags: Qt.Dialog | Qt.FramelessWindowHint
    modality: Qt.ApplicationModal
    transientParent: MainCtx.intfMainWindow
    color: theme.background
    property real scaleFactor: VLCStyle.scale
    property color accentColor: MainCtx.redesignAccent
    property bool lightTheme: !VLCStyle.palette.isDark
    property string category: "general"
    property string categoryTitle: qsTr("General")
    property bool advanced: false
    property bool expert: false
    property string search: ""
    readonly property RedesignTheme theme: RedesignTheme { scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor }
    RedesignPreferences { id: preferenceStore; ctx: MainCtx; autoSave: true }
    RedesignPreferencesCatalog { id: specification }
    RedesignShortcuts {
        id: shortcuts
        parent: content
        scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
        onSaved: preferenceStore.discard()
    }
    function begin() {
        preferenceStore.discard()
        searchField.clear()
        visible = true
        raise(); requestActivate()
    }
    function closeSettings() {
        content.forceActiveFocus()
        if (!preferenceStore.dirty || preferenceStore.save()) visible = false
    }
    onClosing: event => { event.accepted = false; closeSettings() }
    Connections {
        target: DialogsProvider
        function onShowRedesignPreferences() { if (!root.visible) root.begin(); else { root.raise(); root.requestActivate() } }
    }
    Item {
        id: content
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: root.closeSettings()
        Rectangle {
            id: navigation
            width: theme.dp(250); anchors.top: parent.top; anchors.bottom: parent.bottom
            color: theme.panel
            T.TextField {
                id: searchField
                anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top
                anchors.margins: theme.dp(20); height: theme.dp(34)
                placeholderText: qsTr("Search settings")
                color: theme.foreground; placeholderTextColor: theme.foreground
                font.pixelSize: theme.dp(14); selectByMouse: true
                padding: theme.dp(6); verticalAlignment: TextInput.AlignVCenter
                selectionColor: theme.accent; selectedTextColor: theme.bright
                background: Rectangle { color: theme.background; radius: theme.dp(4); border.color: searchField.activeFocus ? theme.accent : theme.border }
                Text {
                    anchors.left: parent.left; anchors.leftMargin: searchField.leftPadding
                    anchors.verticalCenter: parent.verticalCenter
                    text: searchField.placeholderText; font: searchField.font; color: searchField.placeholderTextColor
                    visible: !searchField.text.length && !searchField.preeditText.length
                }
                onTextEdited: root.search = text
                onTextChanged: if (!text.length) root.search = ""
            }
            T.ScrollView {
                anchors.top: searchField.bottom; anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right
                anchors.topMargin: theme.dp(18)
                clip: true
                T.ScrollBar.vertical: Widgets.ScrollBarExt { }
                Column {
                    width: navigation.width
                    Repeater {
                        model: [
                            {group: qsTr("App"), key: "general", title: qsTr("General"), icon: "settings"},
                            {key: "interface", title: qsTr("Interface"), icon: "video"},
                            {key: "privacy", title: qsTr("Privacy"), icon: "history"},
                            {key: "controls", title: qsTr("Controls"), icon: "play"},
                            {group: qsTr("Media"), key: "playback", title: qsTr("Playback"), icon: "play"},
                            {key: "video", title: qsTr("Video"), icon: "video"},
                            {key: "audio", title: qsTr("Audio"), icon: "audio"},
                            {key: "subtitles", title: qsTr("Subtitles"), icon: "subtitles"},
                            {key: "library", title: qsTr("Library"), icon: "folder"},
                            {group: qsTr("System"), key: "network", title: qsTr("Network"), icon: "network"},
                            {key: "performance", title: qsTr("Performance"), icon: "settings"},
                            {key: "recording", title: qsTr("Recording"), icon: "video"},
                            {key: "extensions", title: qsTr("Extensions"), icon: "add"} ]
                        delegate: Column {
                            required property var modelData
                            width: navigation.width
                            Text {
                                visible: !!modelData.group
                                height: visible ? theme.dp(42) : 0
                                leftPadding: theme.dp(22); topPadding: theme.dp(17)
                                text: modelData.group || ""; color: theme.foreground; font.pixelSize: theme.dp(12)
                            }
                            RedesignButton {
                                width: parent.width - theme.dp(20); x: theme.dp(10); height: theme.dp(40)
                                scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
                                caption: modelData.title; text: caption; iconName: modelData.icon
                                leftAligned: true
                                selected: root.category === modelData.key && !root.search.length
                                onClicked: {
                                    root.category = modelData.key; root.categoryTitle = modelData.title
                                    root.search = ""; searchField.clear(); root.advanced = false; root.expert = false
                                    scroll.contentItem.contentY = 0
                                }
                            }
                        }
                    }
                }
            }
        }
        Text {
            id: heading
            anchors.left: navigation.right; anchors.leftMargin: theme.dp(24)
            y: theme.dp(22)
            text: root.search.length ? qsTr("Search results") : root.categoryTitle
            color: theme.bright; font.pixelSize: theme.dp(18)
        }
        MouseArea {
            anchors.left: navigation.right; anchors.right: closeButton.left; anchors.top: parent.top; height: theme.dp(60)
            z: -1
            onPressed: root.startSystemMove()
        }
        RedesignButton {
            id: closeButton
            anchors.right: parent.right; anchors.top: parent.top; anchors.margins: theme.dp(12)
            scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
            iconName: "close"; text: qsTr("Close settings")
            onClicked: root.closeSettings()
        }
        T.ScrollView {
            id: scroll
            anchors.top: parent.top; anchors.topMargin: theme.dp(68)
            anchors.left: navigation.right; anchors.right: parent.right; anchors.bottom: footer.top
            anchors.leftMargin: theme.dp(24); anchors.rightMargin: theme.dp(24)
            clip: true
            T.ScrollBar.vertical: Widgets.ScrollBarExt { }
            contentWidth: availableWidth
            Column {
                width: scroll.availableWidth
                spacing: theme.dp(6)
                ColumnLayout {
                    visible: root.category === "general" && !root.search.length
                    width: parent.width
                    spacing: theme.dp(16)
                    Text { text: qsTr("Appearance"); color: theme.bright; font.pixelSize: theme.dp(16); Layout.topMargin: theme.dp(8) }
                    RowLayout {
                        Layout.fillWidth: true
                        Text { Layout.fillWidth: true; text: qsTr("Theme"); color: theme.foreground; font.pixelSize: theme.dp(14) }
                        Row {
                            spacing: theme.dp(8)
                            Repeater {
                                model: [{label: qsTr("Dark"), value: 2}, {label: qsTr("Light"), value: 1}, {label: qsTr("System"), value: 0}]
                                RedesignButton {
                                    required property var modelData
                                    width: theme.dp(96); height: theme.dp(34)
                                    scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
                                    caption: modelData.label; text: caption
                                    selected: MainCtx.colorScheme.scheme === modelData.value
                                    onClicked: MainCtx.colorScheme.setData(MainCtx.colorScheme.index(modelData.value, 0), true, Qt.CheckStateRole)
                                }
                            }
                        }
                        Item { width: theme.dp(26) }
                    }
                    RowLayout {
                        Layout.fillWidth: true; Layout.preferredHeight: theme.dp(34)
                        Text { Layout.fillWidth: true; text: qsTr("Accent color"); color: theme.foreground; font.pixelSize: theme.dp(14) }
                        Repeater {
                            model: ["default", "#d37918", "#b99327", "#809f3c", "#438b71", "#3c85b7", "#7360ba", "#a35ca0", "#bd5960"]
                            RedesignButton {
                                required property string modelData
                                width: theme.dp(26); height: theme.dp(30)
                                scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
                                text: modelData === "default" ? qsTr("Default orange") : modelData
                                background: Rectangle {
                                    anchors.centerIn: parent; width: theme.dp(20); height: theme.dp(24); radius: theme.dp(2)
                                    color: parent.modelData === "default" ? "#d37918" : parent.modelData
                                    border.width: { preferenceStore.revision; return preferenceStore.value("qt-accent-color") === parent.modelData ? theme.dp(2) : 0 }
                                    border.color: theme.bright
                                }
                                onClicked: preferenceStore.stage("qt-accent-color", modelData)
                            }
                        }
                        RedesignButton {
                            scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
                            iconName: "add"; text: qsTr("Custom accent color")
                            onClicked: { const color = preferenceStore.chooseColor(root.accentColor.toString()); if (color.length) preferenceStore.stage("qt-accent-color", color) }
                        }
                        Item { width: theme.dp(26) }
                    }
                    RedesignPreferenceRow { Layout.fillWidth: true; backend: preferenceStore; optionName: "language"; label: qsTr("Language"); scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor }
                }
                Repeater {
                    model: root.search.length ? [] : specification.sections[root.category] || []
                    delegate: Column {
                        required property var modelData
                        width: parent.width
                        visible: modelData.rows.some(row => preferenceStore.describe(row[0]).kind !== undefined) || root.category === "controls" && modelData.title === qsTr("Keyboard Shortcuts")
                        Text {
                            topPadding: theme.dp(24); bottomPadding: theme.dp(10)
                            text: modelData.title; color: theme.bright; font.pixelSize: theme.dp(16)
                        }
                        Row {
                            visible: root.category === "controls" && modelData.title === qsTr("Keyboard Shortcuts")
                            spacing: theme.dp(12)
                            RedesignButton {
                                scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
                                caption: qsTr("Edit Keyboard Shortcuts"); text: caption
                                onClicked: { content.forceActiveFocus(); if (!preferenceStore.dirty || preferenceStore.save()) shortcuts.open() }
                            }
                            RedesignButton {
                                scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
                                caption: qsTr("Reset all shortcuts"); text: caption
                                onClicked: {
                                    for (const entry of preferenceStore.catalog("controls", ""))
                                        if (entry.name.startsWith("key-") || entry.name.startsWith("global-key-")) preferenceStore.reset(entry.name)
                                }
                            }
                        }
                        Repeater {
                            model: modelData.rows
                            delegate: RedesignPreferenceRow {
                                required property var modelData
                                width: parent.width
                                backend: preferenceStore; optionName: modelData[0]; label: modelData[1]
                                presentation: modelData[2] || {}
                                scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
                            }
                        }
                    }
                }
                RedesignButton {
                    visible: !root.search.length
                    width: parent.width; height: theme.dp(40)
                    scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
                    caption: root.advanced ? qsTr("Hide Advanced Options") : qsTr("Advanced Options")
                    text: caption; selected: root.advanced
                    onClicked: root.advanced = !root.advanced
                }
                Repeater {
                    model: root.advanced && !root.search.length ? specification.advancedSections[root.category] || [] : []
                    delegate: Column {
                        required property var modelData
                        width: parent.width
                        Text {
                            visible: text.length > 0; topPadding: theme.dp(20); bottomPadding: theme.dp(10)
                            text: modelData.title; color: theme.bright; font.pixelSize: theme.dp(16)
                        }
                        Repeater {
                            model: modelData.rows
                            delegate: RedesignPreferenceRow {
                                required property var modelData
                                width: parent.width; backend: preferenceStore; optionName: modelData[0]; label: modelData[1]
                                presentation: modelData[2] || {}
                                scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
                            }
                        }
                    }
                }
                RedesignButton {
                    visible: root.advanced && !root.search.length
                    width: parent.width
                    scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
                    caption: root.expert ? qsTr("Hide all VLC options") : qsTr("All VLC options")
                    text: caption; selected: root.expert
                    onClicked: root.expert = !root.expert
                }
                Repeater {
                    model: {
                        if (root.search.length) {
                            const matches = specification.find(root.search)
                            for (const entry of preferenceStore.catalog("", root.search))
                                if (!matches.some(row => row.name === entry.name)) matches.push(entry)
                            return matches
                        }
                        return root.expert ? preferenceStore.catalog(root.category, "") : []
                    }
                    delegate: RedesignPreferenceRow {
                        required property var modelData
                        width: parent.width
                        backend: preferenceStore; optionName: modelData.name; label: modelData.title || ""; presentation: modelData.presentation || {}
                        scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
                    }
                }
                Item { width: 1; height: theme.dp(24) }
            }
        }
        Rectangle {
            id: footer
            anchors.left: navigation.right; anchors.right: parent.right; anchors.bottom: parent.bottom
            height: preferenceStore.errorMessage.length ? theme.dp(64) : 0
            visible: height > 0
            color: theme.background
            RowLayout {
                anchors.fill: parent; anchors.margins: theme.dp(16)
                Text {
                    Layout.fillWidth: true
                    text: preferenceStore.errorMessage
                    color: "#e56b6b"; font.pixelSize: theme.dp(13); wrapMode: Text.WordWrap
                }
                RedesignButton {
                    scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
                    caption: qsTr("Retry"); text: caption; onClicked: preferenceStore.save()
                }
            }
        }
    }
}
