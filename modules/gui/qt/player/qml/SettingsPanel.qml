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
import VLC.Player
import VLC.Widgets as Widgets
import VLC.Dialogs
import VLC.Util

// What can be changed about the media that is playing, without leaving it:
// what the settings button of the control bar opens.
PlayerPanel {
    id: root

    enum Tab {
        Playback,
        Video,
        Audio,
        Subtitles
    }

    tabs: [
        { icon: VLCIcons.play, text: qsTr("Playback") },
        { icon: VLCIcons.video, text: qsTr("Video") },
        { icon: VLCIcons.audio, text: qsTr("Audio") },
        { icon: VLCIcons.subtitles, text: qsTr("Subtitles") }
    ]

    currentTab: SettingsPanel.Tab.Playback

    preferredHeight: VLCStyle.dp(946, VLCStyle.scale)

    // An option that holds a color is a number, 0xRRGGBB. This is how it
    // is shown and typed.
    function _colorText(rgb: int) : string {
        return "#" + (rgb & 0xFFFFFF).toString(16).padStart(6, "0").toUpperCase()
    }

    // The number for what was typed, or -1 if that is not a color.
    function _colorValue(text: string) : int {
        const match = /^\s*#?([0-9a-fA-F]{6})\s*$/.exec(text)
        return match ? parseInt(match[1], 16) : -1
    }

    // Audio filters are a list of module names in an option. This says
    // whether one is in it, and puts it in or takes it out, for what plays
    // too.

    readonly property var _audioFilters: String(audioFilterOption.value).split(":").filter(name => name !== "")

    function _setAudioFilter(name: string, enable: bool) {
        const filters = _audioFilters.filter(other => other !== name)
        if (enable)
            filters.push(name)

        audioFilterOption.set(filters.join(":"))
        Player.enableAudioFilter(name, enable)
    }

    // Milliseconds as seconds with three decimals, the way delays are shown.
    function _seconds(ms: int) : string {
        return qsTr("%1 s").arg((ms / 1000).toFixed(3))
    }

    TabPage {
        Group {
            title: qsTr("Speed")

            SliderSetting {
                title: qsTr("Playback Speed")
                valueText: qsTr("%1x").arg(Player.rate.toFixed(2))

                // A speed is a ratio: the slider is in powers of two, which
                // puts the normal speed in its middle.
                from: -2
                to: 2
                origin: 0
                stepSize: 0.05

                value: Math.log2(Player.rate)
                onMoved: (value) => { Player.rate = Math.pow(2, value) }

                scaleLabels: [qsTr("0.25x"), qsTr("1x"), qsTr("4x")]
            }
        }
    }

    TabPage {
        // Nothing yet
    }

    TabPage {
        Group {
            title: qsTr("Defaults")
            note: qsTr("For the next media that is opened.")

            Option {
                id: audioTrack
                name: "audio-track"
            }

            Option {
                id: audioLanguage
                name: "audio-language"
            }

            FieldSetting {
                title: qsTr("Audio Track")

                // The option counts from zero and is -1 when no track is
                // asked for.
                text: (audioTrack.value >= 0) ? String(audioTrack.value + 1) : ""
                placeholder: qsTr("Automatic")

                onEdited: (text) => {
                    const track = parseInt(text)
                    audioTrack.set((track >= 1) ? track - 1 : -1)
                }
            }

            FieldSetting {
                title: qsTr("Audio Language")

                text: audioLanguage.value
                placeholder: qsTr("Any")

                onEdited: (text) => audioLanguage.set(text.trim())
            }
        }

        Group {
            title: qsTr("Synchronization")

            SliderSetting {
                title: qsTr("Audio Track Delay")
                valueText: root._seconds(Player.audioDelayMS)

                from: -10000
                to: 10000
                origin: 0
                stepSize: 50

                value: Player.audioDelayMS
                onMoved: (value) => { Player.audioDelayMS = value }

                scaleLabels: [qsTr("-10 s"), qsTr("0 s"), qsTr("+10 s")]
            }
        }

        Group {
            title: qsTr("Filters")

            Option {
                id: audioFilterOption
                name: "audio-filter"
            }

            Option {
                id: equalizerPreset
                name: "equalizer-preset"
            }

            Option {
                id: equalizerTwoPass
                name: "equalizer-2pass"
            }

            Option {
                id: pitchShift
                name: "pitch-shift"
            }

            ToggleSetting {
                title: qsTr("Equalizer")

                checked: root._audioFilters.includes("equalizer")
                onToggled: (checked) => {
                    // It does not load without the bands of a preset.
                    if (checked)
                        Player.setEqualizerPreset(equalizerPreset.value)

                    root._setAudioFilter("equalizer", checked)
                }
            }

            ChoiceSetting {
                title: qsTr("Preset")

                // The names the equalizer knows its presets by
                options: [
                    { value: "flat", text: qsTr("Flat") },
                    { value: "classical", text: qsTr("Classical") },
                    { value: "club", text: qsTr("Club") },
                    { value: "dance", text: qsTr("Dance") },
                    { value: "fullbass", text: qsTr("Full bass") },
                    { value: "fullbasstreble", text: qsTr("Full bass and treble") },
                    { value: "fulltreble", text: qsTr("Full treble") },
                    { value: "headphones", text: qsTr("Headphones") },
                    { value: "largehall", text: qsTr("Large hall") },
                    { value: "live", text: qsTr("Live") },
                    { value: "party", text: qsTr("Party") },
                    { value: "pop", text: qsTr("Pop") },
                    { value: "reggae", text: qsTr("Reggae") },
                    { value: "rock", text: qsTr("Rock") },
                    { value: "ska", text: qsTr("Ska") },
                    { value: "soft", text: qsTr("Soft") },
                    { value: "softrock", text: qsTr("Soft rock") },
                    { value: "techno", text: qsTr("Techno") }
                ]

                value: equalizerPreset.value

                onChosen: (value) => {
                    Player.setEqualizerPreset(value)
                    equalizerPreset.set(value)
                }
            }

            ToggleSetting {
                title: qsTr("2 Pass")

                checked: !!equalizerTwoPass.value
                onToggled: (checked) => equalizerTwoPass.set(checked)
            }

            ToggleSetting {
                title: qsTr("Compressor")

                checked: root._audioFilters.includes("compressor")
                onToggled: (checked) => root._setAudioFilter("compressor", checked)
            }

            ToggleSetting {
                title: qsTr("Spatializer")

                checked: root._audioFilters.includes("spatializer")
                onToggled: (checked) => root._setAudioFilter("spatializer", checked)
            }

            ToggleSetting {
                title: qsTr("Stereo Widener")

                checked: root._audioFilters.includes("stereo_widen")
                onToggled: (checked) => root._setAudioFilter("stereo_widen", checked)
            }

            SliderSetting {
                title: qsTr("Adjust Pitch")
                valueText: qsTr("%1 semitones").arg(Number(pitchShift.value).toFixed(1))
                boxed: false

                from: -12
                to: 12
                origin: 0
                stepSize: 0.5
                ticks: 3

                value: pitchShift.value

                // The filter that shifts the pitch is only there while there
                // is something to shift.
                onMoved: (value) => {
                    pitchShift.set(value)
                    root._setAudioFilter("scaletempo_pitch", value !== 0)
                    Player.applyAudioSetting("pitch-shift", value)
                }
            }
        }
    }

    TabPage {
        Group {
            title: qsTr("Defaults")
            note: qsTr("For the next media that is opened.")

            Option {
                id: subTrack
                name: "sub-track"
            }

            Option {
                id: subLanguage
                name: "sub-language"
            }

            FieldSetting {
                title: qsTr("Subtitle Track")

                // The option counts from zero and is -1 when no track is
                // asked for.
                text: (subTrack.value >= 0) ? String(subTrack.value + 1) : ""
                placeholder: qsTr("Automatic")

                onEdited: (text) => {
                    const track = parseInt(text)
                    subTrack.set((track >= 1) ? track - 1 : -1)
                }
            }

            FieldSetting {
                title: qsTr("Subtitle Language")

                text: subLanguage.value
                placeholder: qsTr("Any")

                onEdited: (text) => subLanguage.set(text.trim())
            }
        }

        Group {
            title: qsTr("Synchronization")

            SliderSetting {
                title: qsTr("Subtitle Track Delay")
                valueText: root._seconds(Player.subtitleDelayMS)

                from: -10000
                to: 10000
                origin: 0
                stepSize: 50

                value: Player.subtitleDelayMS
                onMoved: (value) => { Player.subtitleDelayMS = value }

                scaleLabels: [qsTr("-10 s"), qsTr("0 s"), qsTr("+10 s")]
            }

            SliderSetting {
                title: qsTr("Subtitle Speed")
                valueText: qsTr("%1 fps").arg(Player.subtitleFPS.toFixed(3))

                from: 0
                to: 10
                stepSize: 0.1

                value: Player.subtitleFPS
                onMoved: (value) => { Player.subtitleFPS = value }
            }
        }

        Group {
            title: qsTr("Appearance")
            note: qsTr("The size and the offset change right away, the rest with the next video.")

            Option {
                id: subFont
                name: "freetype-font"
            }

            Option {
                id: subColor
                name: "freetype-color"
            }

            Option {
                id: subOutlineColor
                name: "freetype-outline-color"
            }

            Option {
                id: subOutlineThickness
                name: "freetype-outline-thickness"
            }

            Option {
                id: subBackgroundOpacity
                name: "freetype-background-opacity"
            }

            FieldSetting {
                title: qsTr("Subtitle Font")

                text: subFont.value

                // Only a font that is installed is taken, under the name it
                // is installed with.
                onEdited: (text) => {
                    const wanted = text.trim().toLowerCase()
                    const family = Qt.fontFamilies().find(name => name.toLowerCase() === wanted)
                    if (family !== undefined)
                        subFont.set(family)
                }
            }

            FieldSetting {
                title: qsTr("Text Color")

                text: root._colorText(subColor.value)
                swatch: text

                onEdited: (text) => {
                    const rgb = root._colorValue(text)
                    if (rgb >= 0)
                        subColor.set(rgb)
                }
            }

            FieldSetting {
                title: qsTr("Outline Color")

                text: root._colorText(subOutlineColor.value)
                swatch: text

                onEdited: (text) => {
                    const rgb = root._colorValue(text)
                    if (rgb >= 0)
                        subOutlineColor.set(rgb)
                }
            }

            FieldSetting {
                title: qsTr("Subtitle Offset")

                text: qsTr("%1px").arg(Player.subtitleMargin)

                onEdited: (text) => {
                    const margin = parseInt(text)
                    if (!isNaN(margin)) {
                        Player.subtitleMargin = Math.max(0, margin)

                        // The player applies it, this is what saves it.
                        MainCtx.setOption("sub-margin", Math.max(0, margin))
                    }
                }
            }

            SliderSetting {
                title: qsTr("Font Size")
                valueText: (Player.subtitleTextScale === 100) ? qsTr("Auto")
                                                              : qsTr("%1 %").arg(Player.subtitleTextScale)
                boxed: false

                from: 50
                to: 300
                stepSize: 10
                ticks: 6

                value: Player.subtitleTextScale
                onMoved: (value) => {
                    Player.subtitleTextScale = Math.round(value)

                    // The player applies it, this is what saves it.
                    MainCtx.setOption("sub-text-scale", Math.round(value))
                }
            }

            SliderSetting {
                // The option is a number, these are the steps it has names for.
                readonly property var _steps: [
                    { thickness: 0, text: qsTr("None") },
                    { thickness: 2, text: qsTr("Thin") },
                    { thickness: 4, text: qsTr("Normal") },
                    { thickness: 6, text: qsTr("Thick") }
                ]

                readonly property int _step: {
                    let closest = 0
                    for (let i = 1; i < _steps.length; ++i) {
                        if (Math.abs(_steps[i].thickness - subOutlineThickness.value)
                                < Math.abs(_steps[closest].thickness - subOutlineThickness.value))
                            closest = i
                    }
                    return closest
                }

                title: qsTr("Outline Thickness")
                valueText: _steps[_step].text
                boxed: false

                from: 0
                to: 3
                stepSize: 1
                ticks: 4

                value: _step
                onMoved: (value) => subOutlineThickness.set(_steps[Math.round(value)].thickness)
            }

            SliderSetting {
                // The option goes from 0 to 255.
                readonly property int _percent: Math.round(subBackgroundOpacity.value * 100 / 255)

                title: qsTr("Background Opacity")
                valueText: qsTr("%1 %").arg(_percent)
                boxed: false

                from: 0
                to: 100
                stepSize: 10
                ticks: 11

                value: _percent
                onMoved: (value) => subBackgroundOpacity.set(Math.round(value * 255 / 100))
            }
        }
    }

    footer: Item {
        width: parent.width
        height: VLCStyle.dp(72, VLCStyle.scale)

        Rectangle {
            width: parent.width
            height: VLCStyle.dp(1, VLCStyle.scale)

            color: root.dividerColor
        }

        T.AbstractButton {
            id: advancedButton

            anchors.fill: parent
            anchors.margins: VLCStyle.dp(20, VLCStyle.scale)

            text: qsTr("Open Advanced Settings")

            Accessible.name: text

            onClicked: {
                root.close()
                DialogsProvider.prefsDialog()
            }

            contentItem: Item {
                Row {
                    anchors.centerIn: parent

                    spacing: VLCStyle.dp(6, VLCStyle.scale)

                    Widgets.IconLabel {
                        anchors.verticalCenter: parent.verticalCenter

                        text: VLCIcons.settings
                        font.pixelSize: VLCStyle.dp(20, VLCStyle.scale)
                        color: advancedLabel.color
                    }

                    T.Label {
                        id: advancedLabel

                        anchors.verticalCenter: parent.verticalCenter

                        text: advancedButton.text
                        font.pixelSize: VLCStyle.dp(14, VLCStyle.scale)
                        color: advancedButton.hovered ? root.tabColor : root.dimColor
                    }
                }
            }
        }
    }

    // What a tab shows: groups of settings, one under the other, that scroll
    // when they do not fit.
    component TabPage: Flickable {
        id: page

        default property alias groups: groupsColumn.data

        contentWidth: width
        contentHeight: groupsColumn.height

        clip: true

        boundsBehavior: Flickable.StopAtBounds

        Column {
            id: groupsColumn

            width: page.width
        }
    }

    // Settings that belong together, under a title. A line sets a group apart
    // from the one before it.
    component Group: Column {
        id: group

        required property string title

        // Something to know about the settings of the group
        property string note: ""

        default property alias settings: settingsColumn.data

        width: parent.width

        Rectangle {
            width: parent.width
            height: VLCStyle.dp(1, VLCStyle.scale)

            visible: (group.y > 0)
            color: root.dividerColor
        }

        Item {
            width: parent.width
            height: VLCStyle.dp(39, VLCStyle.scale)

            T.Label {
                x: VLCStyle.margin_large
                y: VLCStyle.dp(20, VLCStyle.scale)

                text: group.title
                font.pixelSize: VLCStyle.dp(16, VLCStyle.scale)
                font.weight: Font.Medium
                color: root.textColor
            }
        }

        Column {
            id: settingsColumn

            x: VLCStyle.dp(20, VLCStyle.scale)
            width: parent.width - 2 * x

            topPadding: VLCStyle.dp(10, VLCStyle.scale)
            bottomPadding: (group.note !== "") ? VLCStyle.dp(10, VLCStyle.scale)
                                               : VLCStyle.dp(20, VLCStyle.scale)

            spacing: VLCStyle.dp(5, VLCStyle.scale)
        }

        T.Label {
            x: VLCStyle.margin_large
            width: parent.width - 2 * x

            visible: (group.note !== "")

            bottomPadding: VLCStyle.dp(20, VLCStyle.scale)

            text: group.note
            wrapMode: Text.WordWrap
            font.pixelSize: VLCStyle.dp(12, VLCStyle.scale)
            color: root.dimColor
        }
    }

    // An option of VLC, see MainCtx.option(). It takes no room in a group.
    component Option: Item {
        id: option

        required property string name

        property var value: MainCtx.option(name)

        function set(value) {
            MainCtx.setOption(name, value)
        }

        visible: false

        Connections {
            target: MainCtx

            function onOptionChanged(name) {
                if (name === option.name)
                    option.value = MainCtx.option(name)
            }
        }
    }

    // A setting that is on or off: its name and a switch.
    component ToggleSetting: Item {
        id: toggle

        required property string title

        // Bound to what the setting is, toggled() says what was asked for.
        property bool checked: false

        signal toggled(bool checked)

        width: parent.width
        height: VLCStyle.dp(48, VLCStyle.scale)

        T.Label {
            anchors.verticalCenter: parent.verticalCenter

            x: VLCStyle.margin_xxsmall

            text: toggle.title
            font.pixelSize: VLCStyle.dp(14, VLCStyle.scale)
            color: root.dimColor
        }

        T.AbstractButton {
            id: switchButton

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right

            width: VLCStyle.dp(68, VLCStyle.scale)
            height: VLCStyle.dp(32, VLCStyle.scale)

            Accessible.role: Accessible.CheckBox
            Accessible.name: toggle.title
            Accessible.checkable: true
            Accessible.checked: toggle.checked

            onClicked: toggle.toggled(!toggle.checked)

            background: Rectangle {
                radius: VLCStyle.dp(6, VLCStyle.scale)

                color: root.wellColor

                border.width: VLCStyle.focus_border
                border.color: switchButton.visualFocus ? root.accentColor : "transparent"
            }

            contentItem: Item {
                // The half the knob is not on says what the switch is at.
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter

                    x: toggle.checked ? VLCStyle.dp(3, VLCStyle.scale) : VLCStyle.dp(32, VLCStyle.scale)

                    width: VLCStyle.dp(33, VLCStyle.scale)
                    height: VLCStyle.dp(26, VLCStyle.scale)

                    radius: VLCStyle.dp(3, VLCStyle.scale)

                    color: toggle.checked ? root.accentWellColor : root.wellBorderColor

                    T.Label {
                        anchors.centerIn: parent

                        text: toggle.checked ? qsTr("ON") : qsTr("OFF")
                        font.pixelSize: VLCStyle.dp(12, VLCStyle.scale)
                        color: toggle.checked ? root.accentColor : root.dimColor
                    }
                }

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter

                    x: toggle.checked ? VLCStyle.dp(39, VLCStyle.scale) : VLCStyle.dp(3, VLCStyle.scale)

                    width: VLCStyle.dp(26, VLCStyle.scale)
                    height: width

                    radius: VLCStyle.dp(3, VLCStyle.scale)

                    color: toggle.checked ? Qt.darker(root.accentColor, 1.23) : root.knobColor

                    Behavior on x {
                        NumberAnimation {
                            duration: VLCStyle.duration_short
                            easing.type: Easing.InOutSine
                        }
                    }
                }
            }
        }
    }

    // A setting that is one of a few things: its name and a field that opens
    // the list of them.
    component ChoiceSetting: Item {
        id: choice

        required property string title

        // A list of { value, text }
        property var options: []

        // Bound to what the setting is, chosen() says what was asked for.
        property var value

        signal chosen(var value)

        readonly property string _text: options.find(option => option.value === value)?.text ?? ""

        width: parent.width
        height: VLCStyle.dp(48, VLCStyle.scale)

        T.Label {
            anchors.verticalCenter: parent.verticalCenter

            x: VLCStyle.margin_xxsmall

            text: choice.title
            font.pixelSize: VLCStyle.dp(14, VLCStyle.scale)
            color: root.dimColor
        }

        T.AbstractButton {
            id: choiceButton

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right

            width: VLCStyle.dp(180, VLCStyle.scale)
            height: VLCStyle.dp(36, VLCStyle.scale)

            Accessible.role: Accessible.ComboBox
            Accessible.name: choice.title

            onClicked: choiceList.open()

            background: Rectangle {
                radius: VLCStyle.dp(6, VLCStyle.scale)

                color: root.wellColor

                border.width: VLCStyle.dp(2, VLCStyle.scale)
                border.color: (choiceButton.visualFocus || choiceList.visible) ? root.accentColor
                                                                             : root.wellBorderColor
            }

            contentItem: Item {
                T.Label {
                    anchors.verticalCenter: parent.verticalCenter

                    x: VLCStyle.dp(14, VLCStyle.scale)
                    width: parent.width - x - VLCStyle.dp(34, VLCStyle.scale)

                    text: choice._text
                    elide: Text.ElideRight
                    font.pixelSize: VLCStyle.dp(14, VLCStyle.scale)
                    color: root.tabColor
                }

                Widgets.IconLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: VLCStyle.dp(6, VLCStyle.scale)

                    text: choiceList.visible ? VLCIcons.chevron_up : VLCIcons.chevron_down
                    font.pixelSize: VLCStyle.icon_normal
                    color: root.tabColor
                }
            }

            T.Popup {
                id: choiceList

                y: parent.height + VLCStyle.margin_xxsmall

                width: parent.width
                height: Math.min(listView.contentHeight + 2 * padding, VLCStyle.dp(240, VLCStyle.scale))

                padding: VLCStyle.dp(2, VLCStyle.scale)

                background: Rectangle {
                    radius: VLCStyle.dp(6, VLCStyle.scale)

                    color: root.wellColor

                    border.width: VLCStyle.dp(2, VLCStyle.scale)
                    border.color: root.wellBorderColor
                }

                contentItem: ListView {
                    id: listView

                    clip: true

                    boundsBehavior: Flickable.StopAtBounds

                    model: choice.options

                    delegate: T.AbstractButton {
                        id: optionButton

                        required property var modelData

                        readonly property bool current: (modelData.value === choice.value)

                        width: ListView.view.width
                        height: VLCStyle.dp(32, VLCStyle.scale)

                        text: modelData.text

                        Accessible.name: text

                        onClicked: {
                            choiceList.close()
                            choice.chosen(modelData.value)
                        }

                        background: Rectangle {
                            radius: VLCStyle.dp(4, VLCStyle.scale)

                            color: optionButton.current ? root.accentWellColor
                                                        : (optionButton.hovered ? root.wellBorderColor
                                                                                : "transparent")
                        }

                        contentItem: T.Label {
                            leftPadding: VLCStyle.margin_small
                            rightPadding: VLCStyle.margin_small

                            verticalAlignment: Text.AlignVCenter

                            text: optionButton.text
                            elide: Text.ElideRight
                            font.pixelSize: VLCStyle.dp(14, VLCStyle.scale)
                            color: optionButton.current ? root.accentColor : root.tabColor
                        }
                    }
                }
            }
        }
    }

    // A setting that is typed: its name and a field. The field can show the
    // color that is typed in it.
    component FieldSetting: Item {
        id: field

        required property string title

        property string text: ""
        property string placeholder: ""

        // A color, as it would be typed, or nothing for no color
        property string swatch: ""

        signal edited(string text)

        width: parent.width
        height: VLCStyle.dp(48, VLCStyle.scale)

        T.Label {
            anchors.verticalCenter: parent.verticalCenter

            x: VLCStyle.margin_xxsmall

            text: field.title
            font.pixelSize: VLCStyle.dp(14, VLCStyle.scale)
            color: root.dimColor
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right

            width: VLCStyle.dp(140, VLCStyle.scale)
            height: VLCStyle.dp(36, VLCStyle.scale)

            radius: VLCStyle.dp(6, VLCStyle.scale)

            color: root.wellColor

            border.width: VLCStyle.dp(2, VLCStyle.scale)
            border.color: input.activeFocus ? root.accentColor : root.wellBorderColor

            TextInput {
                id: input

                anchors.fill: parent
                anchors.leftMargin: VLCStyle.dp(14, VLCStyle.scale)
                anchors.rightMargin: swatchRect.visible ? VLCStyle.dp(32, VLCStyle.scale)
                                                        : VLCStyle.dp(14, VLCStyle.scale)

                verticalAlignment: TextInput.AlignVCenter

                clip: true
                selectByMouse: true

                font.pixelSize: VLCStyle.dp(14, VLCStyle.scale)
                color: root.tabColor
                selectionColor: root.accentColor
                selectedTextColor: root.wellColor

                Accessible.name: field.title

                // What is typed stays until it is entered, then the field
                // shows what the setting became.
                text: field.text

                onEditingFinished: {
                    field.edited(text)
                    text = Qt.binding(function() { return field.text })
                }

                T.Label {
                    anchors.fill: parent

                    verticalAlignment: Text.AlignVCenter

                    visible: (input.text === "") && !input.activeFocus

                    text: field.placeholder
                    font: input.font
                    color: root.dimColor
                }
            }

            Rectangle {
                id: swatchRect

                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: VLCStyle.dp(5, VLCStyle.scale)

                width: VLCStyle.dp(22, VLCStyle.scale)
                height: width

                radius: VLCStyle.dp(2, VLCStyle.scale)

                visible: (field.swatch !== "")
                color: visible ? field.swatch : "transparent"

                border.width: VLCStyle.dp(1.5, VLCStyle.scale)
                border.color: Qt.rgba(1, 1, 1, 0.21)
            }
        }
    }

    // A setting that is a number: its name, its value in a box, and a slider
    // to change it, with what the ends and the middle of the slider stand for
    // under it if that needs saying.
    component SliderSetting: Column {
        id: setting

        required property string title
        required property string valueText

        // The value in a box, as something that is set, or as plain text for
        // what is more of a level.
        property bool boxed: true

        property alias from: slider.from
        property alias to: slider.to
        property alias origin: slider.origin
        property alias stepSize: slider.stepSize
        property alias ticks: slider.ticks

        // Bound to what the setting is. The slider does not write to it,
        // moved() says what the user asked for.
        property real value: 0

        // Texts for the start, the middle and the end of the slider
        property var scaleLabels: []

        signal moved(real value)

        width: parent.width

        spacing: VLCStyle.dp(5, VLCStyle.scale)

        Item {
            width: parent.width
            height: setting.boxed ? VLCStyle.dp(56, VLCStyle.scale) : VLCStyle.dp(37, VLCStyle.scale)

            T.Label {
                anchors.verticalCenter: parent.verticalCenter

                x: VLCStyle.margin_xxsmall

                text: setting.title
                font.pixelSize: VLCStyle.dp(14, VLCStyle.scale)
                color: root.dimColor
            }

            T.Label {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: VLCStyle.margin_xxsmall

                visible: !setting.boxed

                text: setting.valueText
                font.pixelSize: VLCStyle.dp(14, VLCStyle.scale)
                color: root.dimColor
            }

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right

                visible: setting.boxed

                width: VLCStyle.dp(140, VLCStyle.scale)
                height: VLCStyle.dp(36, VLCStyle.scale)

                radius: VLCStyle.dp(6, VLCStyle.scale)

                color: root.wellColor

                border.width: VLCStyle.dp(2, VLCStyle.scale)
                border.color: root.wellBorderColor

                T.Label {
                    anchors.verticalCenter: parent.verticalCenter

                    x: VLCStyle.dp(14, VLCStyle.scale)

                    text: setting.valueText
                    font.pixelSize: VLCStyle.dp(14, VLCStyle.scale)
                    color: root.tabColor
                }
            }
        }

        Widgets.BarSlider {
            id: slider

            width: parent.width

            colorContext.palette: root.colorContext.palette

            Accessible.name: setting.title

            // The value follows the setting, also while it is dragged: what
            // was asked for comes back through the setting.
            Binding on value {
                value: setting.value
            }

            onMoved: setting.moved(value)
        }

        Item {
            width: parent.width
            height: VLCStyle.dp(15, VLCStyle.scale)

            visible: (setting.scaleLabels.length === 3)

            Repeater {
                model: setting.scaleLabels

                T.Label {
                    required property string modelData
                    required property int index

                    x: [0, (parent.width - width) / 2, parent.width - width][index]

                    text: modelData
                    font.pixelSize: VLCStyle.dp(12, VLCStyle.scale)
                    color: root.dimColor
                }
            }
        }
    }
}
