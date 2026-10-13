// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as C

ColumnLayout {
    id: root
    required property var backend
    required property string optionName
    property string label
    property var presentation: ({})
    property real scaleFactor: 1
    property color accentColor: "#d37918"
    property bool lightTheme: false
    readonly property var description: backend.describe(optionName)
    readonly property var currentValue: { backend.revision; return backend.value(optionName) }
    readonly property var choices: presentation.choices || description.choices || []
    readonly property string editor: presentation.editor || description.editor || ""
    readonly property real factor: presentation.factor || 1
    readonly property bool fullWidth: !!presentation.fullWidth
    readonly property RedesignTheme theme: RedesignTheme { scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor }
    readonly property bool available: description.kind !== undefined
    visible: available
    spacing: theme.dp(4)
    enabled: { backend.revision; return !presentation.enabledWhen || !!backend.value(presentation.enabledWhen) }
    opacity: enabled ? 1 : 0.5
    function commit(value) {
        if (presentation.inverted) value = !value
        return backend.stage(optionName, value)
    }
    readonly property var displayedValue: presentation.inverted ? !currentValue : currentValue
    readonly property Component editorComponent: editor === "slider" ? sliderEditor
        : description.kind === "bool" && !choices.length ? toggleEditor
        : editor === "color" ? colorEditor
        : choices.length ? choiceEditor : textEditor
    RowLayout {
        Layout.fillWidth: true
        spacing: theme.dp(10)
        implicitHeight: available ? Math.max(theme.dp(44), labelText.implicitHeight + theme.dp(10)) : 0
        Text {
            id: labelText
            Layout.fillWidth: true
            Layout.preferredWidth: 1
            text: root.label || root.description.title || ""
            color: theme.foreground; font.pixelSize: theme.dp(14)
            wrapMode: Text.WordWrap
            C.ToolTip.text: root.description.help || ""
            C.ToolTip.visible: helpHover.hovered && C.ToolTip.text.length > 0
            C.ToolTip.delay: 500
            HoverHandler { id: helpHover }
        }
        Loader {
            visible: !root.fullWidth
            active: visible
            Layout.preferredWidth: Math.min(theme.dp(320), Math.max(theme.dp(150), root.width * 0.43))
            Layout.preferredHeight: item ? item.implicitHeight || theme.dp(34) : theme.dp(34)
            sourceComponent: root.editorComponent
        }
        RedesignButton {
            scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
            implicitWidth: theme.dp(26); implicitHeight: theme.dp(28); iconSize: theme.dp(18)
            iconName: "history"; text: qsTr("Reset to default")
            onClicked: root.backend.reset(root.optionName)
        }
    }
    Loader {
        Layout.fillWidth: true
        Layout.preferredHeight: item ? item.implicitHeight : 0
        active: root.fullWidth; visible: active
        sourceComponent: root.editorComponent
    }
    Component {
        id: toggleEditor
        Item {
            implicitHeight: theme.dp(34)
            RedesignButton {
                anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
                width: theme.dp(64); height: theme.dp(30)
                objectName: "preferenceToggleEditor"
                checkable: true; checked: !!root.displayedValue
                text: root.label || root.description.title
                onClicked: root.commit(checked)
                background: Rectangle {
                    radius: theme.dp(4); color: parent.checked ? theme.progress : theme.background
                    border.width: parent.visualFocus ? 1 : 0; border.color: theme.accent
                }
                contentItem: Item {
                    Rectangle {
                        x: parent.parent.checked ? parent.width - width - theme.dp(3) : theme.dp(3)
                        y: theme.dp(3); width: theme.dp(26); height: parent.height - theme.dp(6)
                        radius: theme.dp(3); color: parent.parent.checked ? theme.accent : "#444444"
                    }
                    Text {
                        x: parent.parent.checked ? theme.dp(8) : theme.dp(34)
                        anchors.verticalCenter: parent.verticalCenter
                        text: parent.parent.checked ? qsTr("ON") : qsTr("OFF")
                        font.pixelSize: theme.dp(12); color: parent.parent.checked ? theme.accent : theme.foreground
                    }
                }
            }
        }
    }
    Component {
        id: choiceEditor
        C.ComboBox {
            id: choice
            objectName: "preferenceChoiceEditor"
            implicitHeight: theme.dp(34)
            model: root.choices; textRole: "label"; valueRole: "value"
            currentIndex: {
                for (let i = 0; i < count; ++i) if (model[i].value == root.displayedValue) return i
                return -1
            }
            font.pixelSize: theme.dp(14)
            palette.text: theme.foreground; palette.buttonText: theme.foreground
            palette.base: theme.field; palette.button: theme.background
            palette.window: theme.panel; palette.highlight: theme.selected; palette.highlightedText: theme.bright
            background: Rectangle { radius: theme.dp(4); color: theme.background; border.color: choice.activeFocus ? theme.accent : theme.border }
            onActivated: root.commit(currentValue)
        }
    }
    Component {
        id: sliderEditor
        ColumnLayout {
            implicitHeight: theme.dp(48)
            spacing: theme.dp(2)
            C.Slider {
                id: slider
                objectName: "preferenceSliderEditor"
                Layout.fillWidth: true
                implicitHeight: theme.dp(28)
                from: root.presentation.from === undefined ? root.description.minimum : root.presentation.from
                to: root.presentation.to === undefined ? root.description.maximum : root.presentation.to
                stepSize: root.presentation.step || (root.description.kind === "integer" ? 1 : 0.01)
                value: Number(root.currentValue) * root.factor
                Accessible.name: root.label || root.description.title
                background: Rectangle {
                    x: slider.leftPadding; y: (slider.height - height) / 2
                    width: slider.availableWidth; height: theme.dp(14); radius: theme.dp(5); color: theme.field
                    Rectangle { width: slider.visualPosition * parent.width; height: parent.height; radius: parent.radius; color: theme.progress }
                }
                handle: Rectangle {
                    x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
                    y: (slider.height - height) / 2
                    width: theme.dp(8); height: theme.dp(24); radius: theme.dp(4); color: theme.accent
                    border.width: slider.visualFocus ? 1 : 0; border.color: theme.bright
                }
                onMoved: root.commit(root.description.kind === "integer" ? Math.round(value / root.factor) : value / root.factor)
            }
            RowLayout {
                Layout.fillWidth: true
                Text { text: slider.from + (root.presentation.suffix || ""); color: theme.foreground; font.pixelSize: theme.dp(11) }
                Text { Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; text: Number(slider.value).toFixed(root.presentation.decimals || 0) + (root.presentation.suffix || ""); color: theme.foreground; font.pixelSize: theme.dp(11) }
                Text { text: slider.to + (root.presentation.suffix || ""); color: theme.foreground; font.pixelSize: theme.dp(11) }
            }
        }
    }
    Component {
        id: colorEditor
        RedesignButton {
            implicitHeight: theme.dp(34)
            scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
            readonly property string chosenColor: "#" + Number(root.currentValue).toString(16).padStart(6, "0")
            caption: chosenColor.toUpperCase(); text: qsTr("Choose %1").arg(root.label)
            background: Rectangle { radius: theme.dp(4); color: theme.field; border.color: theme.border }
            contentItem: RowLayout {
                Text { Layout.fillWidth: true; text: parent.parent.caption; color: theme.foreground; font.pixelSize: theme.dp(14) }
                Rectangle { width: theme.dp(20); height: width; color: parent.parent.chosenColor; border.color: theme.border; radius: theme.dp(2) }
            }
            onClicked: { const color = root.backend.chooseColor(chosenColor); if (color.length) root.commit(parseInt(color.slice(1), 16)) }
        }
    }
    Component {
        id: textEditor
        RowLayout {
            implicitHeight: theme.dp(34)
            spacing: theme.dp(10)
            C.TextField {
                id: field
                objectName: "preferenceTextEditor"
                Layout.fillWidth: true; Layout.fillHeight: true
                property bool invalid: false
                text: root.currentValue === undefined ? "" : String(root.currentValue)
                color: invalid ? "#e56b6b" : theme.foreground; font.pixelSize: theme.dp(14)
                selectByMouse: true
                echoMode: root.description.kind === "password" ? TextInput.Password : TextInput.Normal
                inputMethodHints: root.description.kind === "integer" || root.description.kind === "float" ? Qt.ImhFormattedNumbersOnly : Qt.ImhNone
                Accessible.name: root.label || root.description.title
                background: Rectangle { radius: theme.dp(4); color: theme.field; border.color: field.invalid ? "#e56b6b" : field.activeFocus ? theme.accent : theme.border }
                onEditingFinished: invalid = !root.commit(text)
                onActiveFocusChanged: if (activeFocus) selectAll()
            }
            RedesignButton {
                visible: root.editor === "file" || root.editor === "directory"
                scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
                caption: qsTr("Browse"); text: caption
                onClicked: { const path = root.backend.choosePath(root.optionName); if (path.length) root.commit(path) }
            }
        }
    }
}
