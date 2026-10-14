// SPDX-License-Identifier: GPL-2.0-or-later
import QtQml

QtObject {
    // Exact labels and ordering follow the local Figma settings frames.
    // Only verified configuration mappings are included. Native metadata
    // hides options unavailable in the running build.
    readonly property var titles: ({
        general: qsTr("Global Settings"),
        interface: qsTr("Interface Settings"),
        privacy: qsTr("Privacy Settings"),
        controls: qsTr("Mouse, Keyboard & Remote Controls"),
        playback: qsTr("Playback Preferences"),
        video: qsTr("Video Defaults"),
        audio: qsTr("Audio Defaults"),
        subtitles: qsTr("Subtitle Defaults"),
        library: qsTr("Playlists, Folders & Files"),
        network: qsTr("Network Connections & Security"),
        performance: qsTr("Performance Settings"),
        recording: qsTr("Recording, Casting & Streaming Out"),
        extensions: qsTr("Add-ons & Scripts")
    })

    readonly property var sections: ({
        general: [
            { title: qsTr("Startup"), rows: [
                ["qt-error-dialogs", qsTr("Show confirmation and error dialogs"), {rowHeight: 42, helpIcon: true}],
                ["qt-updates-notif", qsTr("Check for updates automatically"), {rowHeight: 42, helpIcon: true}] ] },
            { title: qsTr("Diagnostics"), rows: [
                ["file-logging", qsTr("Save a log"), {rowHeight: 42, helpIcon: true}],
                ["logfile", qsTr("Log file"), {enabledWhen: "file-logging", rowHeight: 46, helpIcon: true}],
                ["verbose", qsTr("Log details"), {choices: [{label: qsTr("Errors only"), value: 0}, {label: qsTr("Warnings"), value: 1}, {label: qsTr("Debug"), value: 2}, {label: qsTr("Silent"), value: -1}], rowHeight: 46, helpIcon: true}] ] } ],
        interface: [
            { title: qsTr("Skin"), rows: [
                ["skins2-last", qsTr("Skin file"), {rowHeight: 46, helpIcon: true}] ] },
            { title: qsTr("Window"), rows: [
                ["embedded-video", qsTr("Play video inside main window"), {rowHeight: 42, helpIcon: true}],
                ["qt-video-autoresize", qsTr("Resize window to fit video"), {choices: [{label: qsTr("Never"), value: false}, {label: qsTr("Always"), value: true}], rowHeight: 46, helpIcon: true}],
                ["video-on-top", qsTr("Keep window above other windows"), {rowHeight: 42, helpIcon: true}],
                ["qt-titlebar", qsTr("Show window decorations"), {rowHeight: 42, helpIcon: true}],
                ["qt-name-in-title", qsTr("Show the file name in the title bar"), {rowHeight: 42, helpIcon: true}],
                ["qt-fullscreen-screennumber", qsTr("Open fullscreen on"), {rowHeight: 46, helpIcon: true}] ] },
            { title: qsTr("Playback Controls"), rows: [
                ["qt-minimal-view", qsTr("Start in compact mode"), {rowHeight: 42, helpIcon: true}],
                ["qt-fs-controller", qsTr("Show controls in fullscreen"), {rowHeight: 42, helpIcon: true}] ] },
            { title: qsTr("Notifications and System Tray"), rows: [
                ["qt-system-tray", qsTr("Show a system tray icon"), {rowHeight: 42, helpIcon: true}],
                ["qt-start-minimized", qsTr("Start minimized to the tray"), {rowHeight: 42, helpIcon: true}],
                ["qt-notification", qsTr("Show a popup when the track changes"), {rowHeight: 46, helpIcon: true}] ] },
            { title: qsTr("Playlist"), rows: [
                ["playlist-tree", qsTr("Show the playlist as a tree"), {rowHeight: 42, helpIcon: true}] ] } ],
        privacy: [
            { title: qsTr("History"), rows: [
                ["save-recentplay", qsTr("Save recently played items"), {rowHeight: 42, helpIcon: true}],
                ["restore-playback-pos", qsTr("Remember the playback position"), {rowHeight: 42, helpIcon: true}] ] },
            { title: qsTr("Network"), rows: [
                ["metadata-network-access", qsTr("Fetch titles and cover art from the internet"), {rowHeight: 42, helpIcon: true}],
                ["filter:extraintf:audioscrobbler", qsTr("Submit played tracks to last.fm"), {rowHeight: 42, helpIcon: true}],
                ["lastfm-username", qsTr("Last.fm username"), {rowHeight: 46, helpIcon: true}],
                ["scrobbler-url", qsTr("Last.fm submission URL"), {rowHeight: 46, helpIcon: true}] ] } ],
        controls: [
            { title: qsTr("Keyboard Shortcuts"), rows: [] },
            { title: qsTr("Skip Amounts"), rows: [
                ["extrashort-jump-size", qsTr("Very short skip"), {suffix: " s", rowHeight: 48}],
                ["short-jump-size", qsTr("Short skip"), {suffix: " s", rowHeight: 48}],
                ["medium-jump-size", qsTr("Medium skip"), {suffix: " s", rowHeight: 48}],
                ["long-jump-size", qsTr("Long skip"), {suffix: " s", rowHeight: 48}] ] },
            { title: qsTr("Mouse"), rows: [
                ["mouse-pause-policy", qsTr("Single click on the video"), {rowHeight: 46}],
                ["hotkeys-y-wheel-mode", qsTr("Scroll wheel"), {rowHeight: 46}],
                ["hotkeys-x-wheel-mode", qsTr("Horizontal scroll"), {rowHeight: 46}] ] },
            { title: qsTr("Remotes"), rows: [
                ["http-port", qsTr("Port"), {rowHeight: 48}],
                ["hotkeys-y-wheel-mode", qsTr("Scroll wheel"), {rowHeight: 46}],
                ["hotkeys-x-wheel-mode", qsTr("Horizontal scroll"), {rowHeight: 46}] ] } ],
        playback: [
            { title: qsTr("Startup"), rows: [
                ["restore-playback-pos", qsTr("Continue where you left off"), {rowHeight: 46, helpIcon: true}],
                ["playlist-autostart", qsTr("Start playing as soon as a file opens"), {rowHeight: 42, helpIcon: true}],
                ["rate", qsTr("Default playback speed"), {editor: "slider", from: 0.25, to: 2, step: 0.05, decimals: 2, suffix: "×", rowHeight: 67, sliderHeight: 57, labelTop: 38, scaleLabels: ["0.25","0.5","0.75","1","1.25","1.5","1.75","2"], tickCount: 8}],
                ["playlist-cork", qsTr("Pause when another app uses audio"), {rowHeight: 42, helpIcon: true}] ] },
            { title: qsTr("Tracks"), rows: [
                ["preferred-resolution", qsTr("Preferred video quality"), {rowHeight: 46, helpIcon: true}],
                ["menu-language", qsTr("Preferred menu language"), {rowHeight: 46, helpIcon: true}],
                ["audio-track", qsTr("Default audio track"), {rowHeight: 46, helpIcon: true}],
                ["sub-track", qsTr("Default subtitle track"), {rowHeight: 46, helpIcon: true}] ] },
            { title: qsTr("Order"), rows: [
                ["redesign-repeat", qsTr("Repeat"), {rowHeight: 46, helpIcon: true}],
                ["random", qsTr("Shuffle"), {rowHeight: 42, helpIcon: true}],
                ["play-and-stop", qsTr("Stop after each item"), {rowHeight: 42, helpIcon: true}],
                ["redesign-after-playback", qsTr("When playback finishes"), {rowHeight: 46, helpIcon: true}] ] },
            { title: qsTr("Seeking"), rows: [
                ["input-fast-seek", qsTr("Seek precisely"), {inverted: true, rowHeight: 42, helpIcon: true}] ] },
            { title: qsTr("Files & Discs"), rows: [
                ["dvd", qsTr("Default optical drive"), {rowHeight: 46, helpIcon: true}],
                ["avi-index", qsTr("Repair damaged AVI files"), {rowHeight: 46, helpIcon: true}],
                ["mkv-preload-local-dir", qsTr("Load matching .mkv files from the same folder"), {rowHeight: 42, helpIcon: true}] ] } ],
        video: [
            { title: qsTr("Output"), rows: [
                ["video", qsTr("Enable video"), {rowHeight: 42, helpIcon: true}],
                ["fullscreen", qsTr("Start videos in fullscreen"), {rowHeight: 42, helpIcon: true}],
                ["disable-screensaver", qsTr("Stop the screensaver during playback"), {rowHeight: 42, helpIcon: true}],
                ["video-wallpaper", qsTr("Play video as desktop wallpaper"), {rowHeight: 42, helpIcon: true}] ] },
            { title: qsTr("Picture"), rows: [
                ["hue", qsTr("Hue"), {editor: "slider", from: -180, to: 180, step: 1, rowHeight: 42, tickCount: 3}],
                ["brightness", qsTr("Brightness"), {editor: "slider", from: 0, to: 2, decimals: 2, rowHeight: 42, tickCount: 3}],
                ["contrast", qsTr("Contrast"), {editor: "slider", from: 0, to: 2, decimals: 2, rowHeight: 42, tickCount: 3}],
                ["saturation", qsTr("Saturation"), {editor: "slider", from: 0, to: 3, decimals: 2, rowHeight: 42, tickCount: 4}],
                ["gamma", qsTr("Gamma"), {editor: "slider", from: 0.01, to: 10, decimals: 2, rowHeight: 42, tickCount: 11}] ] },
            { title: qsTr("Deinterlacing"), rows: [
                ["deinterlace", qsTr("Deinterlacing"), {rowHeight: 46, helpIcon: true}],
                ["deinterlace-mode", qsTr("Method"), {rowHeight: 46, helpIcon: true}] ] },
            { title: qsTr("Framing"), rows: [
                ["aspect-ratio", qsTr("Aspect ratio"), {rowHeight: 46, helpIcon: true}],
                ["crop", qsTr("Crop"), {rowHeight: 46, helpIcon: true}],
                ["autoscale", qsTr("Scale video to the window"), {rowHeight: 42, helpIcon: true}],
                ["zoom", qsTr("Zoom"), {rowHeight: 46, helpIcon: true}],
                ["align", qsTr("Position in the window"), {rowHeight: 46, helpIcon: true}] ] },
            { title: qsTr("Snapshots"), rows: [
                ["snapshot-path", qsTr("Save to"), {rowHeight: 42, helpIcon: true}],
                ["snapshot-prefix", qsTr("File name prefix"), {rowHeight: 42, helpIcon: true}],
                ["snapshot-format", qsTr("Format"), {rowHeight: 46, helpIcon: true}],
                ["snapshot-sequential", qsTr("Number files sequentially"), {rowHeight: 42, helpIcon: true}],
                ["snapshot-preview", qsTr("Show a preview after capture"), {rowHeight: 42, helpIcon: true}] ] } ],
        audio: [
            { title: qsTr("Output"), rows: [
                ["audio", qsTr("Enable audio"), {rowHeight: 42, helpIcon: true}],
                ["mix-mode", qsTr("Speaker setup"), {rowHeight: 46, helpIcon: true}] ] },
            { title: qsTr("Volume"), rows: [
                ["qt-max-volume", qsTr("Maximum volume"), {editor: "slider", from: 100, to: 300, step: 1, suffix: "%", rowHeight: 67, sliderHeight: 57, labelTop: 38, scaleLabels: ["100%","200%","300%"], tickCount: 9}],
                ["volume-step", qsTr("Volume step"), {factor: 100 / 256, decimals: 2, suffix: "%", rowHeight: 48, helpIcon: true}] ] },
            { title: qsTr("Loudness"), rows: [
                ["filter:audio-filter:normvol", qsTr("Normalize loudness"), {rowHeight: 42, helpIcon: true}],
                ["norm-max-level", qsTr("Target level"), {enabledWhen: "filter:audio-filter:normvol", rowHeight: 48, helpIcon: true}],
                ["audio-replay-gain-mode", qsTr("Replay gain"), {rowHeight: 46, helpIcon: true}],
                ["audio-replay-gain-preamp", qsTr("Replay gain preamp"), {rowHeight: 48, helpIcon: true}] ] },
            { title: qsTr("Effects"), rows: [
                ["filter:audio-filter:equalizer", qsTr("Equalizer"), {rowHeight: 42, helpIcon: true}],
                ["equalizer-preset", qsTr("Equalizer preset"), {enabledWhen: "filter:audio-filter:equalizer", rowHeight: 48, helpIcon: true}],
                ["equalizer-2pass", qsTr("Two-pass"), {enabledWhen: "filter:audio-filter:equalizer", rowHeight: 42, helpIcon: true}],
                ["filter:audio-filter:stereo_widen", qsTr("Stereo widening"), {rowHeight: 42, helpIcon: true}],
                ["filter:audio-filter:compressor", qsTr("Compressor"), {rowHeight: 42, helpIcon: true}],
                ["filter:audio-filter:chorus_flanger", qsTr("Chorus/flanger"), {rowHeight: 42, helpIcon: true}],
                ["filter:audio-filter:karaoke", qsTr("Karaoke"), {rowHeight: 42, helpIcon: true}] ] },
            { title: qsTr("Tracks"), rows: [
                ["audio-language", qsTr("Preferred audio language"), {rowHeight: 46, helpIcon: true}],
                ["audio-desync", qsTr("Audio delay"), {rowHeight: 46, helpIcon: true}] ] },
            { title: qsTr("Visualization"), rows: [
                ["audio-visual", qsTr("Visualizer"), {rowHeight: 46, helpIcon: true}] ] } ],
        subtitles: [
            { title: qsTr("Tracks & Languages"), rows: [
                ["spu", qsTr("Enable subtitles"), {rowHeight: 42, helpIcon: true}],
                ["sub-language", qsTr("Preferred language"), {rowHeight: 46, helpIcon: true}],
                ["subsdec-encoding", qsTr("Text encoding"), {rowHeight: 46, helpIcon: true}] ] },
            { title: qsTr("Loading Subtitles"), rows: [
                ["sub-autodetect-file", qsTr("Load subtitle files automatically"), {rowHeight: 42, helpIcon: true}],
                ["sub-autodetect-fuzzy", qsTr("File name matching"), {rowHeight: 46, helpIcon: true}] ] },
            { title: qsTr("Appearance"), rows: [
                ["freetype-font", qsTr("Font"), {rowHeight: 48, helpIcon: true}],
                ["sub-text-scale", qsTr("Font size"), {suffix: "%", rowHeight: 46}],
                ["freetype-bold", qsTr("Bold"), {rowHeight: 42}],
                ["freetype-color", qsTr("Text color"), {rowHeight: 42}],
                ["freetype-opacity", qsTr("Text opacity"), {editor: "slider", from: 0, to: 100, factor: 0.39215686274509803, suffix: "%", rowHeight: 67, sliderHeight: 57, labelTop: 38, scaleLabels: ["0%","50%","100%"], tickCount: 11}],
                ["freetype-outline-thickness", qsTr("Outline thickness"), {rowHeight: 46}],
                ["freetype-outline-color", qsTr("Outline color"), {rowHeight: 42}],
                ["freetype-shadow-color", qsTr("Shadow color"), {rowHeight: 42}],
                ["freetype-background-color", qsTr("Background color"), {rowHeight: 42}],
                ["freetype-background-opacity", qsTr("Background opacity"), {editor: "slider", from: 0, to: 100, factor: 0.39215686274509803, suffix: "%", rowHeight: 67, sliderHeight: 57, labelTop: 38, scaleLabels: ["0%","50%","100%"], tickCount: 11}] ] },
            { title: qsTr("Timing"), rows: [
                ["sub-delay", qsTr("Subtitle delay"), {editor: "slider", from: -5, to: 5, factor: 0.1, step: 0.1, suffix: " s", rowHeight: 67, sliderHeight: 57, labelTop: 38, scaleLabels: ["-5 s","0 s","+5 s"], tickCount: 11}] ] },
            { title: qsTr("On-Screen Messages"), rows: [
                ["osd", qsTr("Show feedback for shortcuts"), {rowHeight: 42, helpIcon: true}],
                ["video-title-show", qsTr("Show filename when a video starts"), {rowHeight: 42, helpIcon: true}],
                ["video-title-timeout", qsTr("Show filename for"), {editor: "slider", from: 1, to: 10, factor: 0.001, step: 1, suffix: " s", rowHeight: 67, sliderHeight: 57, labelTop: 38, scaleLabels: ["1 s","10 s"], tickCount: 10}] ] } ],
        library: [
            { title: qsTr("Opening Files"), rows: [
                ["one-instance", qsTr("Only allow one VLC window"), {rowHeight: 42, helpIcon: true}],
                ["one-instance-when-started-from-file", qsTr("Apply to files opened from the file manager"), {rowHeight: 42, helpIcon: true}],
                ["playlist-enqueue", qsTr("Add to the playlist instead of replacing it"), {rowHeight: 42, helpIcon: true}],
                ["recursive", qsTr("When opening a folder"), {rowHeight: 46, helpIcon: true}],
                ["show-hiddenfiles", qsTr("Show hidden files"), {rowHeight: 42, helpIcon: true}] ] },
            { title: qsTr("Metadata & Artwork"), rows: [
                ["media-library", qsTr("Use the media library"), {rowHeight: 42, helpIcon: true}] ] } ],
        network: [
            { title: qsTr("Buffering"), rows: [
                ["file-caching", qsTr("Local files"), {suffix: " ms", rowHeight: 48}],
                ["disc-caching", qsTr("Discs"), {suffix: " ms", rowHeight: 48}],
                ["network-caching", qsTr("Network streams"), {suffix: " ms", rowHeight: 48}],
                ["live-caching", qsTr("Live capture"), {suffix: " ms", rowHeight: 48}] ] },
            { title: qsTr("Proxy"), rows: [
                ["http-proxy", qsTr("HTTP proxy"), {rowHeight: 48, helpIcon: true}],
                ["http-proxy-pwd", qsTr("HTTP proxy password"), {rowHeight: 48, helpIcon: true}] ] },
            { title: qsTr("Security"), rows: [
                ["gnutls-system-trust", qsTr("Verify certificates against the system trust store"), {rowHeight: 42, helpIcon: true}] ] } ],
        performance: [
            { title: qsTr("Decoding"), rows: [
                ["postproc-q", qsTr("Video post-processing"), {rowHeight: 46, helpIcon: true}],
                ["avcodec-skiploopfilter", qsTr("Skip the H.264 loop filter"), {rowHeight: 46, helpIcon: true}],
                ["avcodec-threads", qsTr("Decoding threads"), {rowHeight: 48, helpIcon: true}] ] },
            { title: qsTr("Smooth Playback"), rows: [
                ["drop-late-frames", qsTr("Drop frames when the system can't keep up"), {rowHeight: 42}],
                ] } ],
        recording: [
            { title: qsTr("Recording"), rows: [
                ["input-record-path", qsTr("Save recordings to"), {rowHeight: 48, helpIcon: true}],
                ["input-record-native", qsTr("Record without re-encoding when possible"), {rowHeight: 42}] ] },
            { title: qsTr("Casting"), rows: [
                ["sout-chromecast-conversion-quality", qsTr("Cast quality"), {rowHeight: 46, helpIcon: true}] ] },
            { title: qsTr("Streaming"), rows: [
                ["sout-display", qsTr("Play locally while streaming"), {rowHeight: 42}],
                ["sout-audio", qsTr("Include audio"), {rowHeight: 42}],
                ["sout-video", qsTr("Include video"), {rowHeight: 42}],
                ["sout-spu", qsTr("include subtitles"), {rowHeight: 42}],
                ["sout-x264-preset", qsTr("Encoding preset"), {rowHeight: 46, helpIcon: true}],
                ["sout-x264-tune", qsTr("Tuning"), {rowHeight: 46, helpIcon: true}] ] } ],
        extensions: [
            { title: qsTr("Add-ons"), rows: [
                ["qt-autoload-extensions", qsTr("Load add-ons on startup"), {rowHeight: 42}] ] } ]
    })

    readonly property var advancedSections: ({
        general: [
            { title: "", rows: [
                ["logmode", qsTr("Log format"), {rowHeight: 46, helpIcon: true}],
                ["stats", qsTr("Collect playback statistics"), {rowHeight: 42, helpIcon: true}] ] },
            { title: qsTr("Developer Options"), rows: [
                ["syslog", qsTr("Write to the system log"), {rowHeight: 42, helpIcon: true}],
                ["syslog-debug", qsTr("Include debug messages in the system log"), {rowHeight: 42, helpIcon: true}],
                ["syslog-ident", qsTr("System log identity"), {rowHeight: 42, helpIcon: true}],
                ["syslog-facility", qsTr("System log facility"), {rowHeight: 46, helpIcon: true}] ] } ],
        interface: [
            { title: "", rows: [
                ["qt-opacity", qsTr("Window opacity"), {editor: "slider", from: 10, to: 100, factor: 100, suffix: "%", rowHeight: 57, sliderHeight: 47, labelTop: 28, scaleLabels: ["10%","100%"], tickCount: 10}],
                ["qt-pause-minimized", qsTr("Pause video when window is minimized"), {rowHeight: 42}],
                ["qt-auto-raise", qsTr("Bring VLC to the front when playback starts"), {rowHeight: 46, helpIcon: true}],
                ["qt-embedded-open", qsTr("Show the file browser inside the open dialog"), {rowHeight: 42}],
                ["qt-icon-change", qsTr("Allow the app icon to change"), {rowHeight: 42}],
                ["qt-fs-opacity", qsTr("Fullscreen controls opacity"), {editor: "slider", from: 10, to: 100, factor: 100, suffix: "%", rowHeight: 47, sliderHeight: 47, labelTop: 28, scaleLabels: ["10%","100%"], tickCount: 10}] ] } ],
        playback: [
            { title: "", rows: [
                ["input-timeshift-path", qsTr("Time-shift buffer folder"), {rowHeight: 42, helpIcon: true}] ] } ],
        audio: [
            { title: "", rows: [
                ["spdif", qsTr("Pass compressed audio to the receiver"), {rowHeight: 42, helpIcon: true}],
                ["force-dolby-surround", qsTr("Detect Dolby Surround"), {rowHeight: 46, helpIcon: true}],
                ["role", qsTr("Media role"), {rowHeight: 46, helpIcon: true}] ] } ],
        video: [
            { title: "", rows: [
                ["custom-aspect-ratios", qsTr("Custom aspect ratios"), {rowHeight: 42, helpIcon: true}],
                ["custom-crop-ratios", qsTr("Custom crop ratios"), {rowHeight: 42, helpIcon: true}] ] } ],
        subtitles: [
            { title: "", rows: [
                ["sub-autodetect-path", qsTr("Load subtitles from these folders"), {rowHeight: 48, helpIcon: true}],
                ["freetype-shadow-angle", qsTr("Shadow angle"), {rowHeight: 48, helpIcon: true}],
                ["freetype-text-direction", qsTr("Text direction"), {rowHeight: 46, helpIcon: true}],
                ["freetype-monofont", qsTr("Monospace font"), {rowHeight: 48, helpIcon: true}] ] } ],
        performance: [
            { title: qsTr("Developer"), rows: [
                ["codec", qsTr("Decoder"), {rowHeight: 46, helpIcon: true}],
                ["clock-synchro", qsTr("Clock synchronisation"), {rowHeight: 46, helpIcon: true}],
                ["clock-jitter", qsTr("Clock jitter"), {suffix: " ms", rowHeight: 48, helpIcon: true}],
                ["cr-average", qsTr("Clock reference averaging"), {rowHeight: 48, helpIcon: true}] ] } ]
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
