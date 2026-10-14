// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import VLC.Widgets as Widgets
import VLC.Style

Item {
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
    readonly property bool hasScaleLabels: !!presentation.scaleLabels && presentation.scaleLabels.length > 0
    readonly property bool isToggle: description.kind === "bool" && !choices.length
    readonly property RedesignTheme theme: RedesignTheme { scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor }
    readonly property bool available: description.kind !== undefined
    visible: available
    height: available ? theme.dp(presentation.rowHeight || (editor === "slider" ? hasScaleLabels ? 67 : 42 : isToggle ? 42 : 46)) : 0
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
    Item {
        anchors.fill: parent
        Text {
            id: labelText
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - theme.dp(340)
            text: root.label || root.description.title || ""
            color: theme.foreground; font.pixelSize: theme.dp(14)
            wrapMode: Text.WordWrap
            T.ToolTip {
                id: helpTip
                text: root.description.help || ""
                visible: helpHover.hovered && text.length > 0
                delay: 500
                x: 0; y: -implicitHeight - theme.dp(4)
                padding: theme.dp(8)
                implicitWidth: Math.min(theme.dp(320), helpText.implicitWidth + leftPadding + rightPadding)
                implicitHeight: helpText.implicitHeight + topPadding + bottomPadding
                Component.onCompleted: if (popupType !== undefined) popupType = 0 // Popup.Item
                contentItem: Text { id: helpText; text: helpTip.text; color: theme.bright; font.pixelSize: theme.dp(14); wrapMode: Text.WordWrap }
                background: Rectangle { color: theme.field; border.color: theme.border; radius: theme.dp(4) }
            }
            HoverHandler { id: helpHover }
        }
        RedesignIcon {
            visible: !!root.presentation.helpIcon
            x: Math.min(labelText.implicitWidth, labelText.width) + theme.dp(12)
            anchors.verticalCenter: parent.verticalCenter
            width: theme.dp(14); height: width; name: "info"; color: theme.foreground
        }
        Loader {
            anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
            width: theme.dp(320)
            height: item ? item.implicitHeight || theme.dp(36) : theme.dp(36)
            sourceComponent: root.editorComponent
        }
    }
    Component {
        id: toggleEditor
        Item {
            implicitHeight: theme.dp(32)
            RedesignButton {
                anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
                width: theme.dp(68); height: theme.dp(32)
                objectName: "preferenceToggleEditor"
                checkable: true; checked: !!root.displayedValue
                text: root.label || root.description.title
                onClicked: root.commit(checked)
                background: Rectangle {
                    radius: theme.dp(6); color: theme.field
                    border.width: parent.visualFocus ? 1 : 0; border.color: theme.accent
                }
                contentItem: Item {
                    Rectangle {
                        x: parent.parent.checked ? parent.width - width - theme.dp(3) : theme.dp(3)
                        y: theme.dp(3); width: theme.dp(26); height: parent.height - theme.dp(6)
                        radius: theme.dp(3); color: parent.parent.checked ? Qt.darker(theme.accent, 1.23) : theme.border
                    }
                    Text {
                        x: parent.parent.checked ? theme.dp(8) : theme.dp(35)
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
        T.ComboBox {
            id: choice
            objectName: "preferenceChoiceEditor"
            implicitHeight: theme.dp(36)
            model: root.choices; textRole: "label"; valueRole: "value"
            currentIndex: {
                for (let i = 0; i < count; ++i) if (model[i].value == root.displayedValue) return i
                return -1
            }
            font.pixelSize: theme.dp(14)
            leftPadding: theme.dp(16); rightPadding: theme.dp(12)
            contentItem: Text {
                text: choice.displayText; color: theme.foreground; font: choice.font
                verticalAlignment: Text.AlignVCenter; elide: Text.ElideRight
                rightPadding: theme.dp(24)
            }
            indicator: Widgets.IconLabel {
                x: choice.width - width - choice.rightPadding
                y: (choice.height - height) / 2
                text: VLCIcons.expand; font.pixelSize: theme.dp(20); color: theme.foreground
            }
            delegate: T.ItemDelegate {
                width: choice.width; height: theme.dp(34); padding: theme.dp(6)
                contentItem: Text { text: modelData.label; color: theme.foreground; font: choice.font; verticalAlignment: Text.AlignVCenter }
                background: Rectangle { color: choice.highlightedIndex === index ? theme.selected : theme.panel }
            }
            popup: T.Popup {
                y: choice.height; width: choice.width; padding: 1
                contentItem: ListView {
                    clip: true; implicitHeight: Math.min(contentHeight, theme.dp(300))
                    model: choice.popup.visible ? choice.delegateModel : null
                    currentIndex: choice.highlightedIndex
                    T.ScrollBar.vertical: T.ScrollBar {
                        implicitWidth: theme.dp(8)
                        contentItem: Rectangle { implicitWidth: theme.dp(4); color: theme.foreground; visible: parent.size < 1 }
                    }
                }
                background: Rectangle { color: theme.panel; border.color: theme.border; radius: theme.dp(4) }
            }
            background: Rectangle { radius: theme.dp(4); color: theme.panel; border.color: choice.activeFocus ? theme.accent : theme.field }
            onActivated: root.commit(currentValue)
        }
    }
    Component {
        id: sliderEditor
        Item {
            implicitHeight: theme.dp(root.hasScaleLabels ? root.presentation.sliderHeight || 57 : 24)
            T.Slider {
                id: slider
                objectName: "preferenceSliderEditor"
                width: parent.width; height: theme.dp(24)
                y: root.hasScaleLabels && (root.presentation.sliderHeight || 57) === 57 ? theme.dp(4) : 0
                from: root.presentation.from === undefined ? root.description.minimum : root.presentation.from
                to: root.presentation.to === undefined ? root.description.maximum : root.presentation.to
                stepSize: root.presentation.step || (root.description.kind === "integer" ? 1 : 0.01)
                value: Number(root.currentValue) * root.factor
                Accessible.name: root.label || root.description.title
                background: Rectangle {
                    x: slider.leftPadding; y: (slider.height - height) / 2
                    width: slider.availableWidth; height: theme.dp(16); radius: theme.dp(5); color: theme.field
                    Rectangle { width: slider.visualPosition * parent.width; height: parent.height; radius: parent.radius; color: theme.progress }
                    Repeater {
                        model: root.presentation.tickCount || 0
                        Rectangle {
                            required property int index
                            x: theme.dp(2) + index * (parent.width - theme.dp(4)) / Math.max(1, (root.presentation.tickCount || 0) - 1)
                            y: theme.dp(5); width: theme.dp(1); height: theme.dp(6); color: theme.border
                        }
                    }
                }
                handle: Rectangle {
                    x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
                    y: (slider.height - height) / 2
                    width: theme.dp(8); height: theme.dp(24); radius: theme.dp(4); color: theme.accent
                    border.width: slider.visualFocus ? 1 : 0; border.color: theme.bright
                }
                onMoved: root.commit(root.description.kind === "integer" ? Math.round(value / root.factor) : value / root.factor)
            }
            Item {
                visible: root.hasScaleLabels
                y: theme.dp(root.presentation.labelTop || 38); width: parent.width; height: theme.dp(15)
                Repeater {
                    model: root.presentation.scaleLabels || []
                    Text {
                        required property int index
                        required property string modelData
                        x: index * (parent.width - width) / Math.max(1, (root.presentation.scaleLabels || []).length - 1)
                        text: modelData; color: theme.foreground; font.pixelSize: theme.dp(11)
                    }
                }
            }
        }
    }
    Component {
        id: colorEditor
        RedesignButton {
            id: colorButton
            implicitHeight: theme.dp(36)
            padding: theme.dp(8)
            scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
            readonly property string chosenColor: "#" + Number(root.currentValue).toString(16).padStart(6, "0")
            caption: chosenColor.toUpperCase(); text: qsTr("Choose %1").arg(root.label)
            background: Rectangle { radius: theme.dp(4); color: theme.field; border.color: theme.border }
            contentItem: Item {
                RowLayout {
                    anchors.fill: parent
                    Text { Layout.fillWidth: true; text: colorButton.caption; color: theme.foreground; font.pixelSize: theme.dp(14) }
                    Rectangle { width: theme.dp(20); height: width; color: colorButton.chosenColor; border.color: theme.border; radius: theme.dp(2) }
                }
            }
            onClicked: { const color = root.backend.chooseColor(chosenColor); if (color.length) root.commit(parseInt(color.slice(1), 16)) }
        }
    }
    Component {
        id: textEditor
        RowLayout {
            implicitHeight: theme.dp(36)
            spacing: theme.dp(12)
            T.TextField {
                id: field
                objectName: "preferenceTextEditor"
                Layout.fillWidth: true; Layout.fillHeight: true
                property bool invalid: false
                text: {
                    if (root.currentValue === undefined) return ""
                    const value = root.factor !== 1 ? Number((Number(root.currentValue) * root.factor).toFixed(root.presentation.decimals || 0)) : root.currentValue
                    return String(value) + (root.presentation.suffix || "")
                }
                color: invalid ? "#e56b6b" : theme.foreground; font.pixelSize: theme.dp(14)
                selectByMouse: true
                padding: theme.dp(6)
                verticalAlignment: TextInput.AlignVCenter
                selectionColor: theme.accent; selectedTextColor: theme.bright
                echoMode: root.description.kind === "password" ? TextInput.Password : TextInput.Normal
                inputMethodHints: root.description.kind === "integer" || root.description.kind === "float" ? Qt.ImhFormattedNumbersOnly : Qt.ImhNone
                Accessible.name: root.label || root.description.title
                background: Rectangle { radius: theme.dp(4); color: theme.field; border.color: field.invalid ? "#e56b6b" : field.activeFocus ? theme.accent : theme.border }
                onEditingFinished: {
                    const suffix = root.presentation.suffix || ""
                    const value = suffix.length && text.endsWith(suffix) ? text.slice(0, -suffix.length) : text
                    const normalized = root.factor !== 1 ? Number(value.trim()) / root.factor : value.trim()
                    invalid = !root.commit(normalized)
                }
                onActiveFocusChanged: if (activeFocus) selectAll()
            }
            RedesignButton {
                visible: root.editor === "file" || root.editor === "directory"
                scaleFactor: root.scaleFactor; lightTheme: root.lightTheme; accentColor: root.accentColor
                caption: qsTr("Browse"); text: caption
                Layout.preferredWidth: theme.dp(100); Layout.fillHeight: true
                background: Rectangle { color: theme.panel; radius: theme.dp(4) }
                onClicked: { const path = root.backend.choosePath(root.optionName); if (path.length) root.commit(path) }
            }
        }
    }
}
