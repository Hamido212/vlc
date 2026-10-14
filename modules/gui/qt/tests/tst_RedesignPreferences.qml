// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick
import QtTest
import "../player/qml/redesign"

TestCase {
    id: testCase
    name: "JuxtopposedPreferences"
    width: 900; height: 600
    when: windowShown
    visible: true
    QtObject {
        id: store
        property int revision: 0
        property var values: ({resize: true, fastSeek: false, timeout: 1800})
        function value(name) { return values[name] }
        function describe(name) {
            return {kind: name === "timeout" ? "integer" : "bool", title: name, help: "", choices: []}
        }
        function stage(name, value) {
            const next = Object.assign({}, values)
            next[name] = value
            values = next
            revision++
            return true
        }
        function reset(name) { stage(name, name === "timeout" ? 1800 : name === "resize") }
    }
    RedesignPreferencesCatalog { id: catalog }
    Column {
        width: parent.width
        RedesignPreferenceRow {
            id: resizeRow
            width: parent.width; backend: store; optionName: "resize"
            label: "Resize window to fit video"
            presentation: ({choices: [{label: "Never", value: false}, {label: "Always", value: true}]})
        }
        RedesignPreferenceRow {
            id: seekRow
            width: parent.width; backend: store; optionName: "fastSeek"
            label: "Seek precisely"; presentation: ({inverted: true})
        }
        RedesignPreferenceRow {
            id: delayRow
            width: parent.width; backend: store; optionName: "timeout"
            label: "Hide after"
            presentation: ({editor: "slider", from: 0, to: 10, factor: 0.001, step: 0.1, suffix: " s"})
        }
    }
    RedesignShortcutEditor {
        id: shortcutEditor
        parent: testCase
        shortcuts: [{name: "key-toggle-fullscreen", globalName: "global-key-toggle-fullscreen", title: "Toggle fullscreen", group: "Basic"},
            {name: "key-play-pause", globalName: "global-key-play-pause", title: "Play / pause", group: "Playback"}]
        values: ({"key-toggle-fullscreen": "f", "key-play-pause": "Space"})
        dirty: true
        onCancelRequested: close()
        onSaveRequested: close()
    }
    SignalSpy { id: captureSpy; target: shortcutEditor; signalName: "captureRequested" }
    SignalSpy { id: cancelSpy; target: shortcutEditor; signalName: "cancelRequested" }
    SignalSpy { id: saveSpy; target: shortcutEditor; signalName: "saveRequested" }
    function init() {
        shortcutEditor.close()
        captureSpy.clear(); cancelSpy.clear(); saveSpy.clear()
        store.values = {resize: true, fastSeek: false, timeout: 1800}
        store.revision++
        wait(20)
    }
    function test_guidedChoiceWritesUnderlyingBoolean() {
        const choice = findChild(resizeRow, "preferenceChoiceEditor")
        compare(choice.currentIndex, 1)
        choice.forceActiveFocus()
        keyClick(Qt.Key_Up)
        compare(store.value("resize"), false)
    }
    function test_preciseSeekingInvertsFastSeekOption() {
        const toggle = findChild(seekRow, "preferenceToggleEditor")
        verify(toggle.checked)
        mouseClick(toggle)
        compare(store.value("fastSeek"), true)
        verify(!toggle.checked)
    }
    function test_secondsSliderWritesMilliseconds() {
        const slider = findChild(delayRow, "preferenceSliderEditor")
        compare(slider.value, 1.8)
        mouseClick(slider, slider.width / 2, slider.height / 2)
        verify(store.value("timeout") >= 4900 && store.value("timeout") <= 5100)
    }
    function test_simpleAndAdvancedHaveDifferentContents() {
        const basicGeneral = catalog.sections.general.reduce((names, section) => names.concat(section.rows.map(row => row[0])), [])
        const advancedGeneral = catalog.advancedSections.general.reduce((names, section) => names.concat(section.rows.map(row => row[0])), [])
        verify(!basicGeneral.includes("stats"))
        verify(advancedGeneral.includes("stats"))
        const playback = catalog.sections.playback.reduce((names, section) => names.concat(section.rows.map(row => row[0])), [])
        verify(playback.includes("redesign-repeat"))
        verify(!playback.includes("repeat"))
        verify(!playback.includes("loop"))
        verify(!playback.includes("input-timeshift-path"))
        verify(catalog.advancedSections.playback[0].rows.some(row => row[0] === "input-timeshift-path"))
    }
    function test_shortcutEditorRecordsKeys() {
        shortcutEditor.open()
        tryCompare(shortcutEditor, "opened", true)
        tryVerify(() => !!findChild(shortcutEditor.contentItem, "shortcut_key-toggle-fullscreen"))
        const cell = findChild(shortcutEditor.contentItem, "shortcut_key-toggle-fullscreen")
        mouseClick(cell)
        compare(shortcutEditor.recordingName, "key-toggle-fullscreen")
        keyClick(Qt.Key_F2, Qt.ControlModifier)
        compare(captureSpy.count, 1)
        compare(captureSpy.signalArguments[0][0], "key-toggle-fullscreen")
        compare(captureSpy.signalArguments[0][1], Qt.Key_F2)
        compare(captureSpy.signalArguments[0][2], Qt.ControlModifier)
    }
    function test_shortcutEditorSearchAndCancel() {
        shortcutEditor.open()
        tryCompare(shortcutEditor, "opened", true)
        wait(20)
        const search = findChild(shortcutEditor.contentItem, "shortcutSearch")
        search.text = "pause"
        compare(findChild(shortcutEditor.contentItem, "shortcutList").count, 1)
        mouseClick(findChild(shortcutEditor.contentItem, "shortcutCancel"))
        compare(cancelSpy.count, 1)
        compare(saveSpy.count, 0)
        compare(shortcutEditor.values["key-play-pause"], "Space")
    }
    function test_shortcutEditorHasExplicitSave() {
        shortcutEditor.open()
        tryCompare(shortcutEditor, "opened", true)
        wait(20)
        mouseClick(findChild(shortcutEditor.contentItem, "shortcutSave"))
        compare(saveSpy.count, 1)
        compare(cancelSpy.count, 0)
    }

}
