// SPDX-License-Identifier: GPL-2.0-or-later
import QtQuick

QtObject {
    property real scaleFactor: 1
    property color accentColor: "#D37918"
    property bool lightTheme: false
    readonly property color background: lightTheme ? "#E7E7E7" : "#0E0E0E"
    readonly property color panel: lightTheme ? "#D5D5D5" : "#1B1B1B"
    readonly property color field: lightTheme ? "#DEDEDE" : "#090909"
    readonly property color border: lightTheme ? "#9B9B9B" : "#373737"
    readonly property color foreground: lightTheme ? "#3C3C3C" : "#969696"
    readonly property color bright: lightTheme ? "#2E2E2E" : "#C6C6C6"
    readonly property color hover: lightTheme ? "#EDEDED" : "#222222"
    readonly property color selected: lightTheme ? "#EDEDED" : "#222222"
    readonly property color accent: accentColor
    readonly property color progress: lightTheme ? "#D8BA9A" : "#371F06"

    function dp(value: real): real { return value * scaleFactor }
}
