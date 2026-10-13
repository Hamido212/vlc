// SPDX-License-Identifier: GPL-2.0-or-later
import QtQml

QtObject {
    // Order, grouping, default visibility and editor choice follow the Figma
    // screens. Unsupported options are omitted by the native metadata adapter.
    readonly property var sections: ({
        general: [
            { title: qsTr("Startup"), rows: [
                ["qt-error-dialogs", qsTr("Show confirmation and error dialogs")],
                ["qt-updates-notif", qsTr("Check for updates automatically")] ] },
            { title: qsTr("Diagnostics"), rows: [
                ["qt-verbose", qsTr("Developer mode")], ["file-logging", qsTr("Save a log")], ["logfile", qsTr("Log file"), {enabledWhen: "file-logging"}],
                ["verbose", qsTr("Log details"), { choices: [
                    {label: qsTr("Errors only"), value: 0}, {label: qsTr("Warnings"), value: 1},
                    {label: qsTr("Debug"), value: 2}, {label: qsTr("Silent"), value: -1} ] }] ] } ],
        interface: [
            { title: qsTr("Skin"), rows: [ ["skins2-last", qsTr("Skin file")] ] },
            { title: qsTr("Window"), rows: [
                ["embedded-video", qsTr("Play video inside main window")],
                ["qt-video-autoresize", qsTr("Resize window to fit video"), {choices: [{label: qsTr("Never"), value: false}, {label: qsTr("Always"), value: true}]}],
                ["qt-remember-window-geometry", qsTr("Remember window size and position")],
                ["video-on-top", qsTr("Keep window above other windows")],
                ["qt-titlebar", qsTr("Show window decorations")],
                ["qt-name-in-title", qsTr("Show the file name in the title bar")],
                ["qt-fullscreen-screennumber", qsTr("Open fullscreen on")] ] },
            { title: qsTr("Playback Controls"), rows: [
                ["qt-minimal-view", qsTr("Start in compact mode")],
                ["qt-controls-autohide", qsTr("Auto-hide the controls")],
                ["qt-controls-hide-timeout", qsTr("Hide after"), {editor: "slider", from: 0, to: 10, factor: 0.001, step: 0.1, decimals: 1, suffix: " s"}],
                ["qt-fs-controller", qsTr("Show controls in fullscreen")] ] },
            { title: qsTr("Notifications and System Tray"), rows: [
                ["qt-system-tray", qsTr("Show a system tray icon")],
                ["qt-start-minimized", qsTr("Start minimized to the tray")],
                ["qt-notification", qsTr("Show a popup when the track changes")],
                ["qt-notification-timeout", qsTr("Popup duration"), {editor: "slider", from: 0, to: 10, factor: 0.001, step: 0.1, decimals: 1, suffix: " s"}] ] },
            { title: qsTr("Playlist"), rows: [ ["playlist-tree", qsTr("Show the playlist as a tree")] ] } ],
        privacy: [
            { title: qsTr("History"), rows: [
                ["save-recentplay", qsTr("Save recently played items")],
                ["restore-playback-pos", qsTr("Remember the playback position")],
                ["qt-recentplay-filter", qsTr("Never remember items matching")] ] },
            { title: qsTr("Network"), rows: [
                ["metadata-network-access", qsTr("Fetch titles and cover art from the internet")],
                ["filter:audio-filter:audioscrobbler", qsTr("Submit played tracks to last.fm")],
                ["lastfm-username", qsTr("Last.fm username")], ["lastfm-password", qsTr("Last.fm password")],
                ["scrobbler-url", qsTr("Last.fm submission URL")] ] } ],
        controls: [
            { title: qsTr("Keyboard Shortcuts"), rows: [] },
            { title: qsTr("Skip Amounts"), rows: [
                ["extrashort-jump-size", qsTr("Very short skip")], ["short-jump-size", qsTr("Short skip")],
                ["medium-jump-size", qsTr("Medium skip")], ["long-jump-size", qsTr("Long skip")] ] },
            { title: qsTr("Mouse"), rows: [
                ["mouse-pause-policy", qsTr("Single click on the video")],
                ["hotkeys-y-wheel-mode", qsTr("Scroll wheel")], ["hotkeys-x-wheel-mode", qsTr("Horizontal scroll")],
                ["hotkeys-wheel-direction", qsTr("Reverse scroll direction")] ] },
            { title: qsTr("Remotes"), rows: [ ["http-port", qsTr("Web remote port")], ["http-password", qsTr("Password")] ] } ],
        playback: [
            { title: qsTr("Startup"), rows: [
                ["restore-playback-pos", qsTr("Continue where you left off")],
                ["playlist-autostart", qsTr("Start playing as soon as a file opens")],
                ["rate", qsTr("Default playback speed"), {editor: "slider", from: 0.25, to: 2, step: 0.05, decimals: 2, suffix: "×", fullWidth: true}],
                ["playlist-cork", qsTr("Pause when another app uses audio")] ] },
            { title: qsTr("Tracks"), rows: [
                ["preferred-resolution", qsTr("Preferred video quality")], ["menu-language", qsTr("Preferred menu language")],
                ["audio-track", qsTr("Default audio track")], ["sub-track", qsTr("Default subtitle track")] ] },
            { title: qsTr("Order"), rows: [
                ["redesign-repeat", qsTr("Repeat")], ["random", qsTr("Shuffle")],
                ["play-and-stop", qsTr("Stop after each item")], ["redesign-after-playback", qsTr("When playback finishes")] ] },
            { title: qsTr("Seeking"), rows: [ ["input-fast-seek", qsTr("Seek precisely"), {inverted: true}] ] },
            { title: qsTr("Files & Discs"), rows: [ ["dvd", qsTr("Default optical drive")],
                ["avi-index", qsTr("Repair damaged AVI files")], ["mkv-preload-local-dir", qsTr("Load matching .mkv files from the same folder")] ] } ],
        video: [
            { title: qsTr("Output"), rows: [ ["video", qsTr("Enable video")], ["fullscreen", qsTr("Start videos in fullscreen")],
                ["disable-screensaver", qsTr("Stop the screensaver during playback")], ["video-wallpaper", qsTr("Play video as desktop wallpaper")] ] },
            { title: qsTr("Picture"), rows: [ ["hue", qsTr("Hue"), {editor: "slider", from: -180, to: 180, step: 1}],
                ["brightness", qsTr("Brightness"), {editor: "slider", from: 0, to: 2, decimals: 2}],
                ["contrast", qsTr("Contrast"), {editor: "slider", from: 0, to: 2, decimals: 2}],
                ["saturation", qsTr("Saturation"), {editor: "slider", from: 0, to: 3, decimals: 2}],
                ["gamma", qsTr("Gamma"), {editor: "slider", from: 0.01, to: 10, decimals: 2}] ] },
            { title: qsTr("Deinterlacing"), rows: [ ["deinterlace", qsTr("Deinterlacing")], ["deinterlace-mode", qsTr("Method")] ] },
            { title: qsTr("Framing"), rows: [ ["aspect-ratio", qsTr("Aspect ratio")], ["crop", qsTr("Crop")], ["autoscale", qsTr("Scale video to the window")], ["zoom", qsTr("Zoom")], ["align", qsTr("Position in the window")] ] },
            { title: qsTr("Snapshots"), rows: [ ["snapshot-path", qsTr("Save snapshots to")], ["snapshot-prefix", qsTr("File name prefix")], ["snapshot-format", qsTr("Image format")], ["snapshot-sequential", qsTr("Number files sequentially")], ["snapshot-preview", qsTr("Show a preview after capture")] ] } ],
        audio: [
            { title: qsTr("Output"), rows: [ ["audio", qsTr("Enable audio")], ["aout", qsTr("Output device")], ["stereo-mode", qsTr("Speaker setup")] ] },
            { title: qsTr("Volume"), rows: [ ["qt-max-volume", qsTr("Maximum volume"), {editor: "slider", from: 100, to: 300, step: 1, suffix: "%", fullWidth: true}],
                ["volume-save", qsTr("Remember the last volume")], ["volume-step", qsTr("Volume step")] ] },
            { title: qsTr("Loudness"), rows: [ ["filter:audio-filter:normvol", qsTr("Normalize loudness")],
                ["norm-max-level", qsTr("Target level"), {enabledWhen: "filter:audio-filter:normvol"}],
                ["filter:audio-filter:compressor", qsTr("Night mode")], ["audio-replay-gain-mode", qsTr("Replay gain")],
                ["audio-replay-gain-preamp", qsTr("Replay gain preamp")] ] },
            { title: qsTr("Effects"), rows: [ ["filter:audio-filter:equalizer", qsTr("Equalizer")],
                ["equalizer-preset", qsTr("Equalizer preset"), {enabledWhen: "filter:audio-filter:equalizer"}],
                ["equalizer-2pass", qsTr("Two-pass"), {enabledWhen: "filter:audio-filter:equalizer"}],
                ["filter:audio-filter:spatialaudio", qsTr("Spatial audio")],
                ["filter:audio-filter:stereowiden", qsTr("Stereo widening")], ["filter:audio-filter:compressor", qsTr("Compressor")],
                ["pitch-shift", qsTr("Pitch shift")], ["filter:audio-filter:chorus_flanger", qsTr("Chorus/flanger")], ["filter:audio-filter:karaoke", qsTr("Karaoke")] ] },
            { title: qsTr("Tracks"), rows: [ ["audio-language", qsTr("Preferred audio language")], ["audio-desync", qsTr("Audio delay (ms)")] ] },
            { title: qsTr("Visualization"), rows: [ ["audio-visual", qsTr("Visualizer")] ] } ],
        subtitles: [
            { title: qsTr("Tracks & Languages"), rows: [ ["spu", qsTr("Enable subtitles")], ["sub-language", qsTr("Preferred language")], ["subsdec-encoding", qsTr("Text encoding")] ] },
            { title: qsTr("Loading Subtitles"), rows: [ ["sub-autodetect-file", qsTr("Load subtitle files automatically")], ["sub-autodetect-fuzzy", qsTr("File name matching")] ] },
            { title: qsTr("Appearance"), rows: [ ["freetype-font", qsTr("Font")],
                ["sub-text-scale", qsTr("Font size"), {choices: [{label: qsTr("Automatic"), value: 100}, {label: qsTr("Very small"), value: 50}, {label: qsTr("Small"), value: 75}, {label: qsTr("Large"), value: 150}, {label: qsTr("Very large"), value: 200}]}],
                ["freetype-bold", qsTr("Bold")], ["freetype-color", qsTr("Text color")],
                ["freetype-opacity", qsTr("Text opacity"), {editor: "slider", from: 0, to: 100, factor: 100/255, suffix: "%"}],
                ["freetype-outline-thickness", qsTr("Outline thickness"), {choices: [{label: qsTr("None"), value: 0}, {label: qsTr("Thin"), value: 1}, {label: qsTr("Normal"), value: 4}, {label: qsTr("Thick"), value: 8}]}], ["freetype-outline-color", qsTr("Outline color")],
                ["freetype-shadow-opacity", qsTr("Shadow opacity"), {editor: "slider", from: 0, to: 100, factor: 100/255, suffix: "%"}],
                ["freetype-shadow-color", qsTr("Shadow color")], ["freetype-shadow-distance", qsTr("Shadow distance")],
                ["freetype-background-color", qsTr("Background color")],
                ["freetype-background-opacity", qsTr("Background opacity"), {editor: "slider", from: 0, to: 100, factor: 100/255, suffix: "%"}] ] },
            { title: qsTr("Timing"), rows: [ ["sub-delay", qsTr("Subtitle delay"), {editor: "slider", from: -5, to: 5, factor: 0.1, step: 0.1, suffix: " s"}] ] },
            { title: qsTr("On-Screen Messages"), rows: [ ["osd", qsTr("Show feedback for shortcuts")], ["video-title-show", qsTr("Show filename when a video starts")],
                ["video-title-timeout", qsTr("Show filename for"), {editor: "slider", from: 0, to: 10, factor: 0.001, step: 0.1, suffix: " s"}] ] } ],
        library: [
            { title: qsTr("Opening Files"), rows: [ ["one-instance", qsTr("Only allow one VLC window")],
                ["one-instance-when-started-from-file", qsTr("Apply to files opened from the file manager")],
                ["playlist-enqueue", qsTr("Add to the playlist instead of replacing it")],
                ["recursive", qsTr("When opening a folder")], ["show-hiddenfiles", qsTr("Show hidden files")] ] },
            { title: qsTr("Metadata & Artwork"), rows: [ ["metadata-network-access", qsTr("Fetch titles and artwork from the internet")], ["media-library", qsTr("Use the media library")] ] } ],
        network: [
            { title: qsTr("Buffering"), rows: [ ["file-caching", qsTr("Files (ms)")], ["disc-caching", qsTr("Discs (ms)")],
                ["network-caching", qsTr("Network streams (ms)")], ["live-caching", qsTr("Live capture (ms)")] ] },
            { title: qsTr("Proxy"), rows: [ ["http-proxy", qsTr("HTTP proxy")], ["http-proxy-pwd", qsTr("HTTP proxy password")] ] },
            { title: qsTr("Security"), rows: [ ["gnutls-system-trust", qsTr("Verify certificates against the system trust store")], ["gnutls-priorities", qsTr("Cipher preference")] ] } ],
        performance: [
            { title: qsTr("Decoding"), rows: [ ["avcodec-hw", qsTr("Hardware-accelerated decoding")], ["postproc-q", qsTr("Video post-processing")],
                ["avcodec-skiploopfilter", qsTr("Skip the H.264 loop filter")], ["avcodec-threads", qsTr("Decoding threads")] ] },
            { title: qsTr("Smooth Playback"), rows: [ ["drop-late-frames", qsTr("Drop frames when the system can't keep up")], ["high-priority", qsTr("Give VLC real-time priority")] ] } ],
        recording: [
            { title: qsTr("Recording"), rows: [ ["input-record-path", qsTr("Save recordings to")], ["input-record-native", qsTr("Record without re-encoding when possible")] ] },
            { title: qsTr("Casting"), rows: [ ["sout-chromecast-conversion-quality", qsTr("Cast quality")] ] },
            { title: qsTr("Streaming"), rows: [ ["sout-display", qsTr("Play locally while streaming")], ["sout-audio", qsTr("Include audio")],
                ["sout-video", qsTr("Include video")], ["sout-spu", qsTr("Include subtitles")], ["sout-x264-preset", qsTr("Encoding preset")], ["sout-x264-tune", qsTr("Tuning")] ] } ],
        extensions: [ { title: qsTr("Add-ons"), rows: [ ["qt-autoload-extensions", qsTr("Load add-ons on startup")] ] } ]
    })
    readonly property var advancedSections: ({
        general: [ {title: "", rows: [ ["logmode", qsTr("Log format")], ["stats", qsTr("Collect playback statistics")] ] },
            {title: qsTr("Developer Options"), rows: [ ["syslog", qsTr("Write to the system log")], ["syslog-debug", qsTr("Include debug messages in the system log")],
                ["syslog-ident", qsTr("System log identity")], ["syslog-facility", qsTr("System log facility")] ] } ],
        interface: [ {title: "", rows: [ ["qt-opacity", qsTr("Window opacity"), {editor: "slider", from: 10, to: 100, factor: 100, suffix: "%"}],
            ["qt-pause-minimized", qsTr("Pause video when window is minimized")], ["qt-auto-raise", qsTr("Bring VLC to the front when playback starts")],
            ["qt-bgcone", qsTr("Show cover art in the window when playing audio")], ["qt-embedded-open", qsTr("Show the file browser inside the open dialog")],
            ["qt-icon-change", qsTr("Allow the app icon to change")],
            ["qt-fs-opacity", qsTr("Fullscreen controls opacity"), {editor: "slider", from: 10, to: 100, factor: 100, suffix: "%"}],
            ["qt-fs-sensitivity", qsTr("Fullscreen controls sensitivity"), {editor: "slider", from: 0, to: 10, step: 1}] ] } ],
        playback: [ {title: "", rows: [ ["input-timeshift-path", qsTr("Time-shift buffer folder")], ["input-timeshift-granularity", qsTr("Time-shift buffer size")] ] } ],
        audio: [ {title: qsTr("Advanced Audio"), rows: [ ["spdif", qsTr("Pass compressed audio to the receiver")], ["force-dolby-surround", qsTr("Detect Dolby Surround")], ["audio-resampler", qsTr("Resampling quality")], ["role", qsTr("Media role")] ] } ],
        video: [ {title: qsTr("Advanced Video"), rows: [ ["custom-aspect-ratios", qsTr("Custom aspect ratios")], ["custom-crop-ratios", qsTr("Custom crop ratios")] ] } ],
        subtitles: [ {title: qsTr("Advanced Subtitles"), rows: [ ["sub-autodetect-path", qsTr("Load subtitles from these folders")], ["freetype-shadow-angle", qsTr("Shadow angle")], ["freetype-text-direction", qsTr("Text direction")], ["freetype-monofont", qsTr("Monospace font")] ] } ],
        performance: [ {title: qsTr("Developer"), rows: [ ["encoder", qsTr("Encoder")], ["decoder", qsTr("Decoder")], ["clock-synchro", qsTr("Clock synchronisation")], ["clock-jitter", qsTr("Clock jitter (ms)")], ["clock-average", qsTr("Clock reference averaging")] ] } ],
        library: [ {title: "", rows: [ ["ignore-filetypes", qsTr("Ignore file types")], ["auto-preparse", qsTr("Read file metadata automatically")] ] } ],
        network: [ {title: "", rows: [ ["http-reconnect", qsTr("Reconnect automatically")], ["http-user-agent", qsTr("User agent")], ["ipv4-timeout", qsTr("Connection timeout (ms)")] ] } ]
    })
    function find(query) {
        const found = [], names = {}, needle = query.toLocaleLowerCase()
        for (const collection of [sections, advancedSections]) {
            for (const category in collection) {
                for (const section of collection[category]) {
                    for (const row of section.rows) {
                        if (!names[row[0]] && (row[1].toLocaleLowerCase().includes(needle) || row[0].includes(needle))) {
                            names[row[0]] = true
                            found.push({name: row[0], title: row[1], presentation: row[2] || {}})
                        }
                    }
                }
            }
        }
        return found
    }
}
