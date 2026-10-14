// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Templates as T
import VLC.MainInterface
import VLC.Style
import VLC.Dialogs

Window {
    id: root
    title: qsTr("Settings — VLC Media Player")
    width: Math.min(theme.dp(1048), Screen.desktopAvailableWidth - theme.dp(40))
    height: Math.min(theme.dp(865), Screen.desktopAvailableHeight - theme.dp(60))
    minimumWidth: theme.dp(640); minimumHeight: theme.dp(440)
    flags: Qt.Dialog | Qt.FramelessWindowHint
    modality: Qt.ApplicationModal
    transientParent: MainCtx.intfMainWindow
    color: theme.background
    property real scaleFactor: VLCStyle.scale
    property color accentColor: MainCtx.redesignAccent
    property bool lightTheme: !VLCStyle.palette.isDark
    property string category: "general"
    property bool advanced: false
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
    component GroupHeading: Text {
        width: parent.width; height: theme.dp(39); topPadding: theme.dp(10)
        color: theme.bright; font.pixelSize: theme.dp(16)
    }
    component ActionRow: Item {
        property string label
        property string caption
        signal triggered()
        width: parent.width; height: theme.dp(42)
        Text { anchors.verticalCenter: parent.verticalCenter; text: parent.label; color: theme.foreground; font.pixelSize: theme.dp(14) }
        RedesignButton {
            anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
            width: theme.dp(320); height: theme.dp(32)
            scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
            caption: parent.caption; text: caption
            background: Rectangle { color: theme.panel; radius: theme.dp(4); border.color: parent.visualFocus ? theme.accent : "transparent" }
            onClicked: parent.triggered()
        }
    }
    Item {
        id: content
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: root.closeSettings()
        Rectangle { anchors.top: parent.top; width: parent.width; height: theme.dp(50); color: theme.field }
        T.TextField {
            id: searchField
            x: theme.dp(8); y: theme.dp(8); width: theme.dp(200); height: theme.dp(34)
            placeholderText: qsTr("Search")
            color: theme.foreground; placeholderTextColor: theme.foreground
            font.pixelSize: theme.dp(14); selectByMouse: true
            leftPadding: theme.dp(42); rightPadding: theme.dp(8); verticalAlignment: TextInput.AlignVCenter
            selectionColor: theme.accent; selectedTextColor: theme.bright
            background: Rectangle { color: theme.panel; radius: theme.dp(4); border.color: searchField.activeFocus ? theme.accent : "transparent" }
            RedesignIcon { x: theme.dp(8); y: theme.dp(5); width: theme.dp(24); height: width; name: "search"; color: theme.foreground }
            Text {
                anchors.left: parent.left; anchors.leftMargin: searchField.leftPadding
                anchors.verticalCenter: parent.verticalCenter
                text: searchField.placeholderText; font: searchField.font; color: searchField.placeholderTextColor
                visible: !searchField.text.length && !searchField.preeditText.length
            }
            onTextEdited: root.search = text
            onTextChanged: if (!text.length) root.search = ""
        }
        Text {
            x: theme.dp(240); y: theme.dp(15.5)
            text: root.search.length ? qsTr("Search results") : specification.titles[root.category]
            color: theme.foreground; font.pixelSize: theme.dp(16)
        }
        MouseArea {
            x: theme.dp(216); width: parent.width - x - theme.dp(46); height: theme.dp(50)
            onPressed: root.startSystemMove()
        }
        RedesignButton {
            anchors.right: parent.right; anchors.rightMargin: theme.dp(14); y: theme.dp(9)
            width: theme.dp(32); height: theme.dp(32)
            scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
            iconName: "close"; text: qsTr("Close settings")
            onClicked: root.closeSettings()
        }
        Item {
            id: navigation
            y: theme.dp(50); width: theme.dp(216); height: parent.height - y
            Rectangle { x: theme.dp(8); y: theme.dp(8); width: theme.dp(200); height: parent.height - theme.dp(16); radius: theme.dp(6); color: theme.panel }
            Flickable {
                anchors.fill: parent; clip: true
                contentWidth: width; contentHeight: theme.dp(815)
                boundsBehavior: Flickable.StopAtBounds
                Repeater {
                    model: [{title: qsTr("App"), y: 22}, {title: qsTr("Media"), y: 255}, {title: qsTr("System"), y: 536}]
                    Text {
                        required property var modelData
                        x: theme.dp(24); y: theme.dp(modelData.y)
                        text: modelData.title; color: theme.foreground; font.pixelSize: theme.dp(12)
                    }
                }
                Repeater {
                    model: [
                        {key: "general", title: qsTr("General"), icon: "general", y: 55},
                        {key: "interface", title: qsTr("Interface"), icon: "interface", y: 103},
                        {key: "privacy", title: qsTr("Privacy"), icon: "privacy", y: 151},
                        {key: "controls", title: qsTr("Controls"), icon: "controls", y: 199},
                        {key: "playback", title: qsTr("Playback"), icon: "playback", y: 288},
                        {key: "video", title: qsTr("Video"), icon: "video", y: 336},
                        {key: "audio", title: qsTr("Audio"), icon: "audio", y: 384},
                        {key: "subtitles", title: qsTr("Subtitles"), icon: "subtitles", y: 432},
                        {key: "library", title: qsTr("Library"), icon: "folder", y: 480},
                        {key: "network", title: qsTr("Network"), icon: "network", y: 569},
                        {key: "performance", title: qsTr("Performance"), icon: "performance", y: 617},
                        {key: "recording", title: qsTr("Recording"), icon: "record", y: 665},
                        {key: "extensions", title: qsTr("Extensions"), icon: "extensions", y: 713}]
                    RedesignButton {
                        required property var modelData
                        x: theme.dp(14); y: theme.dp(modelData.y); width: theme.dp(188); height: theme.dp(40)
                        scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
                        caption: modelData.title; text: caption; iconName: modelData.icon; leftAligned: true
                        selected: root.category === modelData.key && !root.search.length
                        onClicked: {
                            content.forceActiveFocus()
                            root.category = modelData.key; root.search = ""; searchField.clear(); root.advanced = false
                            scroll.contentItem.contentY = 0
                        }
                    }
                }
            }
        }
        T.ScrollView {
            id: scroll
            x: theme.dp(240); y: theme.dp(70)
            width: parent.width - x - theme.dp(24); height: footer.y - y
            clip: true; contentWidth: availableWidth
            T.ScrollBar.vertical: T.ScrollBar {
                implicitWidth: theme.dp(8)
                contentItem: Rectangle { implicitWidth: theme.dp(4); radius: width / 2; color: theme.foreground; visible: parent.size < 1 }
            }
            Column {
                width: scroll.availableWidth
                spacing: theme.dp(20)
                Column {
                    visible: root.category === "general" && !root.search.length
                    width: parent.width
                    GroupHeading { text: qsTr("Appearance") }
                    Item {
                        width: parent.width; height: theme.dp(46)
                        Text { anchors.verticalCenter: parent.verticalCenter; text: qsTr("Theme"); color: theme.foreground; font.pixelSize: theme.dp(14) }
                        Rectangle {
                            anchors.right: parent.right; y: theme.dp(5); width: theme.dp(320); height: theme.dp(36); color: theme.field; radius: theme.dp(4)
                            Row {
                                anchors.fill: parent; anchors.margins: theme.dp(2); spacing: theme.dp(2)
                                Repeater {
                                    model: [{label: qsTr("Dark"), value: 2}, {label: qsTr("Light"), value: 1}, {label: qsTr("System"), value: 0}]
                                    RedesignButton {
                                        required property var modelData
                                        width: (theme.dp(320) - theme.dp(8)) / 3; height: theme.dp(32)
                                        scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
                                        caption: modelData.label; text: caption
                                        selected: MainCtx.colorScheme.scheme === modelData.value
                                        background: Rectangle { radius: theme.dp(4); color: parent.selected ? theme.progress : theme.panel }
                                        onClicked: MainCtx.colorScheme.setData(MainCtx.colorScheme.index(modelData.value, 0), true, Qt.CheckStateRole)
                                    }
                                }
                            }
                        }
                    }
                    Item {
                        width: parent.width; height: theme.dp(46)
                        Text { anchors.verticalCenter: parent.verticalCenter; text: qsTr("Accent color"); color: theme.foreground; font.pixelSize: theme.dp(14) }
                        Rectangle {
                            anchors.right: parent.right; y: theme.dp(5); width: theme.dp(320); height: theme.dp(36); color: theme.field; radius: theme.dp(4)
                            Row {
                                x: theme.dp(2); y: theme.dp(2); spacing: theme.dp(4)
                                Repeater {
                                    // The user allowed the imported swatch paints; the XML has no values.
                                    model: ["default", "#d37918", "#b99327", "#809f3c", "#438b71", "#3c85b7", "#7360ba", "#a35ca0", "#bd5960"]
                                    RedesignButton {
                                        required property string modelData
                                        width: theme.dp(31.555555); height: theme.dp(32)
                                        scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
                                        text: modelData === "default" ? qsTr("Default orange") : modelData
                                        background: Rectangle {
                                            radius: theme.dp(4)
                                            color: { preferenceStore.revision; return preferenceStore.value("qt-accent-color") === parent.modelData ? theme.progress : "transparent" }
                                        }
                                        contentItem: Item {
                                            Rectangle { x: theme.dp(6); y: theme.dp(6); width: theme.dp(19.555555); height: theme.dp(20); radius: theme.dp(2); color: parent.parent.modelData === "default" ? "#D37918" : parent.parent.modelData }
                                        }
                                        onClicked: preferenceStore.stage("qt-accent-color", modelData)
                                    }
                                }
                            }
                        }
                    }
                }
                Repeater {
                    model: root.search.length ? [] : specification.sections[root.category] || []
                    delegate: Column {
                        required property var modelData
                        width: parent.width
                        visible: modelData.rows.some(row => preferenceStore.describe(row[0]).kind !== undefined) || root.category === "controls" && modelData.title === qsTr("Keyboard Shortcuts")
                        GroupHeading { text: modelData.title }
                        Column {
                            width: parent.width
                            visible: root.category === "controls" && modelData.title === qsTr("Keyboard Shortcuts")
                            ActionRow {
                                label: qsTr("Defaults"); caption: qsTr("Edit Keyboard Shortcuts")
                                onTriggered: { content.forceActiveFocus(); if (!preferenceStore.dirty || preferenceStore.save()) shortcuts.open() }
                            }
                            ActionRow {
                                label: qsTr("Reset all shortcuts"); caption: qsTr("Reset")
                                onTriggered: {
                                    for (const entry of preferenceStore.catalog("controls", ""))
                                        if (entry.name.startsWith("key-") || entry.name.startsWith("global-key-")) preferenceStore.reset(entry.name)
                                }
                            }
                        }
                        Repeater {
                            model: modelData.rows
                            delegate: Column {
                                required property var modelData
                                width: parent.width
                                RedesignPreferenceRow {
                                    width: parent.width
                                    backend: preferenceStore; optionName: parent.modelData[0]; label: parent.modelData[1]; presentation: parent.modelData[2] || {}
                                    scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
                                }
                                Loader {
                                    width: parent.width
                                    active: { preferenceStore.revision; return parent.modelData[0] === "equalizer-preset" && !!preferenceStore.value("filter:audio-filter:equalizer") }
                                    visible: active; height: active ? theme.dp(499) : 0
                                    sourceComponent: Item {
                                        RedesignEqualizer {
                                            y: theme.dp(5); width: parent.width
                                            height: theme.dp(489); backend: preferenceStore
                                            scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                RedesignButton {
                    visible: !root.search.length && root.category !== "privacy"
                    width: parent.width; height: theme.dp(38)
                    scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
                    text: qsTr("Advanced Options")
                    background: Rectangle { color: theme.panel }
                    contentItem: Item {
                        Row {
                            anchors.centerIn: parent; spacing: theme.dp(16)
                            Text { anchors.verticalCenter: parent.verticalCenter; text: qsTr("Advanced Options"); color: theme.foreground; font.pixelSize: theme.dp(14) }
                            RedesignIcon { width: theme.dp(24); height: width; name: root.advanced ? "expand" : "chevron_right"; color: theme.foreground }
                        }
                    }
                    onClicked: root.advanced = !root.advanced
                }
                Repeater {
                    model: root.advanced && !root.search.length ? specification.advancedSections[root.category] || [] : []
                    delegate: Column {
                        required property var modelData
                        width: parent.width
                        visible: modelData.rows.some(row => preferenceStore.describe(row[0]).kind !== undefined)
                        GroupHeading { visible: text.length > 0; height: visible ? theme.dp(39) : 0; text: modelData.title }
                        Repeater {
                            model: modelData.rows
                            delegate: RedesignPreferenceRow {
                                required property var modelData
                                width: parent.width; backend: preferenceStore; optionName: modelData[0]; label: modelData[1]; presentation: modelData[2] || {}
                                scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
                            }
                        }
                    }
                }
                Repeater {
                    model: root.search.length ? specification.find(root.search) : []
                    delegate: RedesignPreferenceRow {
                        required property var modelData
                        width: parent.width; backend: preferenceStore; optionName: modelData.name; label: modelData.title; presentation: modelData.presentation
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
            visible: height > 0; color: theme.background
            RowLayout {
                anchors.fill: parent; anchors.margins: theme.dp(16)
                Text { Layout.fillWidth: true; text: preferenceStore.errorMessage; color: theme.bright; font.pixelSize: theme.dp(13); wrapMode: Text.WordWrap }
                RedesignButton { scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor; caption: qsTr("Retry"); text: caption; onClicked: preferenceStore.save() }
            }
        }
    }
}
