// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick

QtObject {
    property real scaleFactor: 1
    property color accentColor: "#d37918"
    property bool lightTheme: false
    readonly property color background: lightTheme ? "#acacac" : "#1b1b1b"
    readonly property color panel: lightTheme ? "#c3c3c3" : "#101010"
    readonly property color field: lightTheme ? "#dedede" : "#090909"
    readonly property color border: lightTheme ? "#969696" : "#292929"
    readonly property color foreground: lightTheme ? "#404040" : "#8f8f8f"
    readonly property color bright: lightTheme ? "#2e2e2e" : "#e5e5e5"
    readonly property color hover: lightTheme ? "#d5d5d5" : "#292929"
    readonly property color selected: lightTheme ? "#b8b8b8" : "#333333"
    readonly property color accent: accentColor
    readonly property color progress: lightTheme ? "#d8ba9a" : "#371f06"

    function dp(value: real): real { return value * scaleFactor }
}
