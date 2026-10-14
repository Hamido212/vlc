// SPDX-License-Identifier: GPL-2.0-or-later
// Glyphs from VLC Redesign by
// Juxtopposed (https://www.juxtopposed.com/), design licensed CC BY 4.0:
// https://creativecommons.org/licenses/by/4.0/
// https://www.figma.com/community/file/1691465999134370980/vlc-redesign
// This file's implementation code is GPL-2.0-or-later.
import QtQuick
import VLC.Widgets as Widgets
import VLC.Style

Widgets.IconLabel {
    id: root
    property string name
    color: "#969696"
    font.pixelSize: Math.min(width, height)
    readonly property var glyphs: ({
        "cone": VLCIcons.cone,
        "more": VLCIcons.more,
        "sidebar": VLCIcons.panel_left,
        "folder": VLCIcons.folder,
        "library": VLCIcons.folder,
        "minimize": VLCIcons.window_minimize,
        "maximize": VLCIcons.window_maximize,
        "fullscreen": VLCIcons.fullscreen,
        "close": VLCIcons.close,
        "previous": VLCIcons.previous,
        "play": VLCIcons.play_filled,
        "playback": VLCIcons.play,
        "next": VLCIcons.next,
        "volume": VLCIcons.volume_high,
        "audio": VLCIcons.audio,
        "subtitles": VLCIcons.subtitles,
        "settings": VLCIcons.settings,
        "general": VLCIcons.preferences,
        "preferences": VLCIcons.preferences,
        "interface": VLCIcons.interface_settings,
        "privacy": VLCIcons.privacy,
        "controls": VLCIcons.preferences_hotkeys,
        "performance": VLCIcons.preferences,
        "recording": VLCIcons.record,
        "record": VLCIcons.record,
        "extensions": VLCIcons.plugins,
        "queue": VLCIcons.queue,
        "edit": VLCIcons.edit,
        "pause": VLCIcons.pause_filled,
        "add": VLCIcons.add,
        "back": VLCIcons.back,
        "forward": VLCIcons.arrow_right,
        "arrow_right": VLCIcons.arrow_right,
        "chevron_right": VLCIcons.ic_fluent_chevron_right_24,
        "info": VLCIcons.info,
        "search": VLCIcons.search,
        "expand": VLCIcons.chevron_down,
        "home": VLCIcons.home,
        "videos": VLCIcons.topbar_video,
        "music": VLCIcons.music,
        "network": VLCIcons.stream,
        "history": VLCIcons.refresh,
        "sort": VLCIcons.sort,
        "check": VLCIcons.check,
        "stop": VLCIcons.stop,
        "muted": VLCIcons.volume_muted,
        "video": VLCIcons.preferences_video,
        "grid": VLCIcons.grid,
        "repeat": VLCIcons.repeat_all,
        "shuffle": VLCIcons.shuffle
    })

    text: glyphs[name] || ""
}
