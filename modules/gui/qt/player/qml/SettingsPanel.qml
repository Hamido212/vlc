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

    // An option the video listens to while it plays, when what the option
    // is of is there.
    function _setVideoOption(option, value) {
        option.set(value)
        Player.applyVideoSetting(option.name, value)
    }

    // Filters of the video are lists of module names in options, one option
    // for each kind of filter.

    function _filterList(option) {
        return String(option.value).split(":").filter(name => name !== "")
    }

    function _setFilter(option, name, enable) {
        const filters = _filterList(option).filter(other => other !== name)
        if (enable)
            filters.push(name)

        _setVideoOption(option, filters.join(":"))
    }

    function _videoFilterOn(name: string) : bool {
        return _filterList(videoFilterOption).includes(name)
    }

    function _setVideoFilter(name: string, enable: bool) {
        _setFilter(videoFilterOption, name, enable)
    }

    // Flipping and rotating are one filter, which does one of a few
    // transformations. Several ways to flip and rotate amount to the same
    // one, so what was picked is kept here.

    property string _flip: ""
    property int _rotation: 0

    // The transformation that rotates clockwise by so many degrees and then
    // flips ("h", "v" or not at all), nothing if that leaves the video as it
    // is.
    function _transformType(flip: string, rotation: int) : string {
        return {
            "0": "", "90": "90", "180": "180", "270": "270",
            "h0": "hflip", "h90": "transpose", "h180": "vflip", "h270": "antitranspose",
            "v0": "vflip", "v90": "antitranspose", "v180": "hflip", "v270": "transpose"
        }[flip + rotation]
    }

    function _readTransform() {
        const type = _videoFilterOn("transform") ? String(transformType.value) : ""
        if (_transformType(_flip, _rotation) === type)
            return

        _flip = ({ "hflip": "h", "vflip": "v", "transpose": "h", "antitranspose": "v" })[type] ?? ""
        _rotation = ({ "90": 90, "180": 180, "270": 270, "transpose": 90, "antitranspose": 90 })[type] ?? 0
    }

    function _setTransform(flip: string, rotation: int) {
        _flip = flip
        _rotation = rotation

        // The filter reads what to do when it starts.
        _setVideoFilter("transform", false)

        const type = _transformType(flip, rotation)
        if (type !== "") {
            _setVideoOption(transformType, type)
            _setVideoFilter("transform", true)
        }
    }

    onOpened: _readTransform()

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

    // The sleep timer pauses what plays when its time is up. It is the
    // player's and goes on with this panel closed. These are the times it is
    // offered for, in seconds; any other time is typed.
    readonly property var _sleepPresets: [900, 1800, 2700, 3600, 5400]
    property bool _customSleep: false

    function _timerText(seconds: int) : string {
        return [Math.floor(seconds / 3600), Math.floor(seconds / 60) % 60, seconds % 60]
            .map(value => String(value).padStart(2, "0")).join(":")
    }

    // The seconds of a time typed as "h:mm:ss", as "m:ss" or as minutes,
    // -1 if it is none of these.
    function _timerSeconds(text: string) : int {
        const parts = text.trim().split(":")
        if (parts.length > 3 || !parts.every(part => /^\d{1,3}$/.test(part)))
            return -1

        if (parts.length === 1)
            return Number(parts[0]) * 60

        return parts.reduce((seconds, part) => seconds * 60 + Number(part), 0)
    }

    Connections {
        target: Player

        function onSleepTimerChanged() {
            if (Player.sleepTimerDuration === 0)
                root._customSleep = false
        }
    }

    TabPage {
        Group {
            ToggleSetting {
                title: qsTr("Reverse")

                // Few things can be played backwards.
                enabled: Player.rewindable

                checked: (Player.rate < 0)
                onToggled: Player.reverse()
            }

            ChoiceSetting {
                title: qsTr("Sleep Timer")

                options: [{ value: 0, text: qsTr("Off") }]
                    .concat(root._sleepPresets.map(seconds => ({ value: seconds, text: qsTr("%1 min").arg(seconds / 60) })))
                    .concat([{ value: -1, text: qsTr("Custom") }])

                value: root._customSleep ? -1 : Player.sleepTimerDuration

                // While the timer runs, the time that is left
                currentText: (Player.sleepTimerRemaining > 0) ? root._timerText(Player.sleepTimerRemaining)
                                                              : ""

                onChosen: (value) => {
                    root._customSleep = (value === -1)

                    if (value >= 0)
                        Player.setSleepTimer(value)
                }
            }

            FieldSetting {
                title: qsTr("Duration")

                visible: root._customSleep

                placeholder: qsTr("hh:mm:ss")
                text: (Player.sleepTimerDuration > 0) ? root._timerText(Player.sleepTimerDuration) : ""

                onEdited: (text) => {
                    // The field is also left when it goes away with the
                    // timer: that is not asking for the timer again.
                    if (!root._customSleep)
                        return

                    const seconds = root._timerSeconds(text)
                    if (seconds >= 0 && seconds !== Player.sleepTimerDuration)
                        Player.setSleepTimer(seconds)
                }
            }

            ModelChoiceSetting {
                title: qsTr("Audio Visualizer")

                // The visualizers are those of the audio output, there are
                // none without one.
                enabled: (options.length > 0)
                placeholderText: qsTr("Unavailable")

                model: Player.audioVisualization
            }

            SliderSetting {
                title: qsTr("Speed")
                valueText: qsTr("%1x").arg(Number(Math.abs(Player.rate).toFixed(2)))

                from: 0.25
                to: 2
                stepSize: 0.05
                ticks: 8

                value: Math.abs(Player.rate)
                onMoved: (value) => { Player.rate = (Player.rate < 0) ? -value : value }

                scaleLabels: ["0.25", "0.5", "0.75", "1", "1.25", "1.5", "1.75", "2"]
            }
        }
    }

    TabPage {
        Group {
            title: qsTr("Defaults")
            note: hdrMode.known ? qsTr("HDR and the resolution are for the next video that is opened.")
                                : qsTr("The resolution is for the next video that is opened.")

            Option {
                id: videoFilterOption
                name: "video-filter"
            }

            Option {
                id: subSourceOption
                name: "sub-source"
            }

            Option {
                id: transformType
                name: "transform-type"
            }

            Option {
                id: hdrMode
                name: "d3d11-hdr-mode"

                // It is an option of one way to show the video.
                readonly property bool known: (value !== undefined)
            }

            Option {
                id: preferredResolution
                name: "preferred-resolution"
            }

            SegmentSetting {
                title: qsTr("Flip")

                options: [
                    { value: "", text: qsTr("None") },
                    { value: "h", text: qsTr("Horizontal") },
                    { value: "v", text: qsTr("Vertical") }
                ]

                value: root._flip
                onChosen: (value) => root._setTransform(value, root._rotation)
            }

            ChoiceSetting {
                title: qsTr("Rotate")

                options: [
                    { value: 0, text: qsTr("0 deg") },
                    { value: 90, text: qsTr("90 deg") },
                    { value: 180, text: qsTr("180 deg") },
                    { value: 270, text: qsTr("270 deg") }
                ]

                value: root._rotation
                onChosen: (value) => root._setTransform(root._flip, value)
            }

            ModelChoiceSetting {
                title: qsTr("Zoom")
                model: Player.zoom
            }

            ChoiceSetting {
                title: qsTr("HDR")

                visible: hdrMode.known

                options: [
                    { value: "auto", text: qsTr("Auto") },
                    { value: "never", text: qsTr("Never") },
                    { value: "always", text: qsTr("Always") },
                    { value: "generate", text: qsTr("Generate from SDR") }
                ]

                value: hdrMode.value
                onChosen: (value) => hdrMode.set(value)
            }

            ChoiceSetting {
                title: qsTr("Resolution")

                options: [
                    { value: -1, text: qsTr("Best Available") },
                    { value: 1080, text: qsTr("Full HD (1080p)") },
                    { value: 720, text: qsTr("HD (720p)") },
                    { value: 576, text: qsTr("SD (576p)") },
                    { value: 360, text: qsTr("Low (360p)") },
                    { value: 240, text: qsTr("Very Low (240p)") }
                ]

                value: preferredResolution.value
                onChosen: (value) => preferredResolution.set(value)
            }

            ModelChoiceSetting {
                title: qsTr("Aspect Ratio")
                model: Player.aspectRatio
            }

            ModelChoiceSetting {
                title: qsTr("Crop")
                model: Player.crop
            }
        }

        Group {
            title: qsTr("Filters")

            ExpandSetting {
                title: qsTr("Essential")
                separated: false

                Option {
                    id: gamma
                    name: "gamma"
                }

                FilterToggle {
                    title: qsTr("Image Adjust")
                    filter: "adjust"
                }

                OptionSlider {
                    title: qsTr("Hue")
                    option: "hue"
                    decimals: 0

                    from: -180
                    to: 180
                    origin: 0
                    stepSize: 1
                }

                OptionSlider {
                    title: qsTr("Brightness")
                    option: "brightness"

                    from: 0
                    to: 2
                    origin: 1
                    stepSize: 0.01
                }

                OptionSlider {
                    title: qsTr("Contrast")
                    option: "contrast"

                    from: 0
                    to: 2
                    origin: 1
                    stepSize: 0.01
                }

                OptionSlider {
                    title: qsTr("Saturation")
                    option: "saturation"

                    from: 0
                    to: 3
                    origin: 1
                    stepSize: 0.01
                }

                SliderSetting {
                    title: qsTr("Gamma")
                    valueText: Number(gamma.value).toFixed(2)
                    boxed: false

                    // It is an exponent: the slider is in powers of ten,
                    // which puts no change in its middle.
                    from: -1
                    to: 1
                    origin: 0
                    stepSize: 0.02

                    value: Math.log10(gamma.value)
                    onMoved: (value) => root._setVideoOption(gamma, Math.pow(10, value))
                }

                FilterToggle {
                    title: qsTr("Sharpen")
                    filter: "sharpen"
                }

                OptionSlider {
                    title: qsTr("Sharpen Strength")
                    option: "sharpen-sigma"

                    from: 0
                    to: 2
                    stepSize: 0.01
                }

                FilterToggle {
                    title: qsTr("Banding Removal")
                    filter: "gradfun"
                }

                FilterToggle {
                    title: qsTr("Film Grain")
                    filter: "grain"
                }
            }

            ExpandSetting {
                title: qsTr("Crop")

                CropField {
                    title: qsTr("Top")
                    side: "top"
                }

                CropField {
                    title: qsTr("Left")
                    side: "left"
                }

                CropField {
                    title: qsTr("Right")
                    side: "right"
                }

                CropField {
                    title: qsTr("Bottom")
                    side: "bottom"
                }
            }

            ExpandSetting {
                title: qsTr("Colors")

                FilterToggle {
                    title: qsTr("Sepia")
                    filter: "sepia"
                }

                OptionSlider {
                    title: qsTr("Sepia Intensity")
                    option: "sepia-intensity"
                    decimals: 0

                    from: 0
                    to: 255
                    stepSize: 1
                }

                FilterToggle {
                    title: qsTr("Negate Colors")
                    filter: "invert"
                }

                FilterToggle {
                    title: qsTr("Posterize")
                    filter: "posterize"
                }

                FilterToggle {
                    title: qsTr("Gradient")
                    filter: "gradient"
                }
            }

            ExpandSetting {
                title: qsTr("Geometry")

                FilterToggle {
                    title: qsTr("Interactive Zoom")
                    filter: "magnify"
                }

                FilterToggle {
                    title: qsTr("Free Rotation")
                    filter: "rotate"
                }

                OptionSlider {
                    title: qsTr("Angle")
                    option: "rotate-angle"
                    decimals: 0

                    from: 0
                    to: 359
                    stepSize: 1
                }

                FilterToggle {
                    title: qsTr("Puzzle Game")
                    filter: "puzzle"
                }
            }

            ExpandSetting {
                title: qsTr("Overlay")

                Option {
                    id: marqText
                    name: "marq-marquee"
                }

                Option {
                    id: marqPosition
                    name: "marq-position"
                }

                FieldSetting {
                    title: qsTr("Text")

                    // The option has a text when no text is shown, too.
                    text: root._filterList(subSourceOption).includes("marq") ? marqText.value : ""
                    placeholder: qsTr("None")

                    onEdited: (text) => {
                        if (text !== "")
                            root._setVideoOption(marqText, text)

                        root._setFilter(subSourceOption, "marq", text !== "")
                    }
                }

                ChoiceSetting {
                    title: qsTr("Text Position")

                    // The numbers the option has for the places
                    options: [
                        { value: -1, text: qsTr("Default") },
                        { value: 0, text: qsTr("Center") },
                        { value: 1, text: qsTr("Left") },
                        { value: 2, text: qsTr("Right") },
                        { value: 4, text: qsTr("Top") },
                        { value: 8, text: qsTr("Bottom") },
                        { value: 5, text: qsTr("Top Left") },
                        { value: 6, text: qsTr("Top Right") },
                        { value: 9, text: qsTr("Bottom Left") },
                        { value: 10, text: qsTr("Bottom Right") }
                    ]

                    value: marqPosition.value
                    onChosen: (value) => root._setVideoOption(marqPosition, value)
                }
            }

            ExpandSetting {
                title: qsTr("Advanced")

                FilterToggle {
                    title: qsTr("Anti-Flickering")
                    filter: "antiflicker"
                }

                FilterToggle {
                    title: qsTr("Motion Blur")
                    filter: "motionblur"
                }

                OptionSlider {
                    title: qsTr("Motion Blur Strength")
                    option: "blur-factor"
                    decimals: 0

                    from: 1
                    to: 127
                    stepSize: 1
                }

                FilterToggle {
                    title: qsTr("Spatial Blur")
                    filter: "gaussianblur"
                }

                FilterToggle {
                    title: qsTr("Denoiser")
                    filter: "hqdn3d"
                }

                FilterToggle {
                    title: qsTr("Mirror")
                    filter: "mirror"
                }

                FilterToggle {
                    title: qsTr("Psychedelic")
                    filter: "psychedelic"
                }

                FilterToggle {
                    title: qsTr("Waves")
                    filter: "wave"
                }

                FilterToggle {
                    title: qsTr("Water Effect")
                    filter: "ripple"
                }

                FilterToggle {
                    title: qsTr("Motion Detect")
                    filter: "motiondetect"
                }

                FilterToggle {
                    title: qsTr("Anaglyph 3D")
                    filter: "anaglyph"
                }
            }
        }
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

    // Settings that belong together, under a title if they have one. A line
    // sets a group apart from the one before it.
    component Group: Column {
        id: group

        property string title: ""

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

            visible: (group.title !== "")

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

            opacity: enabled ? 1.0 : 0.4

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

        // What the field shows when the setting is none of the options
        property string placeholderText: ""

        // What the field shows in place of the text of the option, if
        // there is more to say about the setting than that
        property string currentText: ""

        signal chosen(var value)

        readonly property string _text: (currentText !== "") ? currentText
            : (options.find(option => option.value === value)?.text ?? placeholderText)

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

            opacity: enabled ? 1.0 : 0.4

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
    // to change it, with what places on the slider stand for under it if that
    // needs saying.
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

        // Texts spread evenly under the slider, the first at its start and
        // the last at its end
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

            visible: (setting.scaleLabels.length > 1)

            Repeater {
                model: setting.scaleLabels

                T.Label {
                    required property string modelData
                    required property int index

                    x: index * (parent.width - width) / (setting.scaleLabels.length - 1)

                    text: modelData
                    font.pixelSize: VLCStyle.dp(12, VLCStyle.scale)
                    color: root.dimColor
                }
            }
        }
    }

    // A setting that is one of a few things which all fit next to each
    // other: its name, and under it the things to pick from.
    component SegmentSetting: Column {
        id: segments

        required property string title

        // A list of { value, text }
        property var options: []

        // Bound to what the setting is, chosen() says what was asked for.
        property var value

        signal chosen(var value)

        width: parent.width

        spacing: VLCStyle.dp(5, VLCStyle.scale)

        Item {
            width: parent.width
            height: VLCStyle.dp(37, VLCStyle.scale)

            T.Label {
                anchors.verticalCenter: parent.verticalCenter

                x: VLCStyle.margin_xxsmall

                text: segments.title
                font.pixelSize: VLCStyle.dp(14, VLCStyle.scale)
                color: root.dimColor
            }
        }

        Rectangle {
            width: parent.width
            height: VLCStyle.dp(44, VLCStyle.scale)

            radius: VLCStyle.dp(6, VLCStyle.scale)

            color: root.wellColor

            Row {
                id: segmentRow

                anchors.fill: parent
                anchors.margins: VLCStyle.dp(2, VLCStyle.scale)

                spacing: VLCStyle.dp(2, VLCStyle.scale)

                Repeater {
                    model: segments.options

                    T.AbstractButton {
                        id: segment

                        required property var modelData

                        readonly property bool current: (modelData.value === segments.value)

                        width: (segmentRow.width - (segments.options.length - 1) * segmentRow.spacing)
                               / segments.options.length
                        height: segmentRow.height

                        text: modelData.text

                        Accessible.role: Accessible.RadioButton
                        Accessible.name: text
                        Accessible.checked: current

                        onClicked: segments.chosen(modelData.value)

                        background: Rectangle {
                            radius: VLCStyle.dp(4, VLCStyle.scale)

                            color: segment.current ? root.accentWellColor : root.wellBorderColor
                        }

                        contentItem: T.Label {
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                            text: segment.text
                            font.pixelSize: VLCStyle.dp(14, VLCStyle.scale)
                            color: segment.current ? root.accentColor
                                                   : (segment.hovered ? root.tabColor : root.dimColor)
                        }
                    }
                }
            }
        }
    }

    // A setting that is one of the things a model lists, with the "display"
    // and "checked" roles the choices of the player have.
    component ModelChoiceSetting: ChoiceSetting {
        id: modelChoice

        required property var model

        function _read() {
            const options = []
            let current = -1

            for (let i = 0; i < entries.count; ++i) {
                const entry = entries.itemAt(i)
                if (!entry)
                    continue

                options.push({ value: i, text: entry.text })
                if (entry.checked)
                    current = i
            }

            modelChoice.options = options
            modelChoice.value = current
        }

        onChosen: (value) => modelChoice.model.toggleIndex(value)

        Repeater {
            id: entries

            model: modelChoice.model

            // Nothing to see: these keep track of what the model lists.
            Item {
                required property var model

                readonly property string text: model.display
                readonly property bool checked: !!model.checked

                visible: false

                onTextChanged: modelChoice._read()
                onCheckedChanged: modelChoice._read()
            }

            onItemAdded: modelChoice._read()
            onItemRemoved: modelChoice._read()
        }
    }

    // Settings that stay out of the way until they are asked for: a name,
    // and what unfolds under it.
    component ExpandSetting: Column {
        id: expand

        required property string title

        property bool expanded: false

        // A line sets it apart from what is above it.
        property bool separated: true

        default property alias settings: expandColumn.data

        width: parent.width

        Rectangle {
            width: parent.width
            height: VLCStyle.dp(1, VLCStyle.scale)

            visible: expand.separated
            color: root.dividerColor
        }

        T.AbstractButton {
            id: expandButton

            width: parent.width
            height: VLCStyle.dp(48, VLCStyle.scale)

            text: expand.title

            Accessible.name: text

            onClicked: expand.expanded = !expand.expanded

            contentItem: Item {
                T.Label {
                    anchors.verticalCenter: parent.verticalCenter

                    x: VLCStyle.margin_xxsmall

                    text: expand.title
                    font.pixelSize: VLCStyle.dp(14, VLCStyle.scale)
                    color: (expand.expanded || expandButton.hovered) ? root.tabColor : root.dimColor
                }

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: VLCStyle.dp(6, VLCStyle.scale)

                    spacing: VLCStyle.dp(6, VLCStyle.scale)

                    T.Label {
                        anchors.verticalCenter: parent.verticalCenter

                        text: expand.expanded ? qsTr("Collapse Settings") : qsTr("Expand Settings")
                        font.pixelSize: VLCStyle.dp(14, VLCStyle.scale)
                        color: expandButton.hovered ? root.tabColor : root.dimColor
                    }

                    Widgets.IconLabel {
                        anchors.verticalCenter: parent.verticalCenter

                        text: expand.expanded ? VLCIcons.chevron_up : VLCIcons.chevron_down
                        font.pixelSize: VLCStyle.icon_normal
                        color: expandButton.hovered ? root.tabColor : root.dimColor
                    }
                }
            }
        }

        Column {
            id: expandColumn

            width: parent.width

            visible: expand.expanded

            bottomPadding: VLCStyle.dp(10, VLCStyle.scale)

            spacing: VLCStyle.dp(5, VLCStyle.scale)
        }
    }

    // A switch for a filter of the video, by the name of its module.
    component FilterToggle: ToggleSetting {
        required property string filter

        checked: root._videoFilterOn(filter)
        onToggled: (checked) => root._setVideoFilter(filter, checked)
    }

    // A slider for an option the video listens to while it plays.
    component OptionSlider: SliderSetting {
        id: optionSlider

        required property string option

        // How many decimals of the value are shown
        property int decimals: 2

        valueText: Number(sliderOption.value).toFixed(decimals)
        boxed: false

        value: Number(sliderOption.value)
        onMoved: (value) => root._setVideoOption(sliderOption, value)

        Option {
            id: sliderOption

            name: optionSlider.option
        }
    }

    // How much of one side of the video is cut off, in pixels. This is
    // not an option: it is asked from the video that plays.
    component CropField: FieldSetting {
        id: cropField

        required property string side

        property int _pixels: 0

        function _read() {
            _pixels = Player.videoSetting("crop-" + side) ?? 0
        }

        text: qsTr("%1px").arg(_pixels)

        onEdited: (text) => {
            const pixels = parseInt(text)
            if (!isNaN(pixels))
                Player.applyVideoSetting("crop-" + side, Math.max(0, pixels))

            _read()
        }

        Component.onCompleted: _read()

        Connections {
            target: root

            function onOpened() {
                cropField._read()
            }
        }
    }
}
