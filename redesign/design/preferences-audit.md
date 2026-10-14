# Preferences reference audit

Static audit for fork PR #6. Juxtopposed VLC Redesign, CC BY 4.0. Uses local figma-nodes.xml, tokens.json and module source definitions; no Figma API. This document makes no runtime-verification claim.

## Evidence and limits

XML supplies exact node names and geometry, but no paints/text styles or component-instance overrides. The existing local olmo/redesign:design/roadmap/phase-7-settings.png Git blob was inspected as Figma-derived reference; ignored copy: redesign/tools/figma-settings-reference.png. It confirms category labels/order and Theme labels. dsojevic code is implementation evidence, not design authority.

Authored ambiguities include two Last.fm username rows, Time-shift buffer size under Video, Visualization size under Subtitles and repeated scroll rows under Remotes. The user approved correcting track changew to track changes and omitting the second username. Do not infer different meanings for the other rows.

## Shared shell

| Element | Unscaled geometry |
|---|---|
| Frame interior | 1048×865; reference PNG1078×895 adds15px outer shadow |
| Top bar | x0 y0,1048×50 |
| Search | x8 y8,200×34; icon x16 y13,24×24; Search text x50 y16.5,47×17 |
| Title | x240 y15.5,19px text bounds high |
| Close wrapper | x1002 y9,32×32 |
| Sidebar | x0 y50,216×815; inner x8 y58,200×799 |
| Group labels | App x24 y72; Media x24 y305; System x24 y586 |
| Category buttons | x14,188×40; top y105/153/201/249 App,338/386/434/482/530 Media,619/667/715/763 System |
| Main viewport | x216 y50,832×815 |
| Main content | x240 y70,width784;24px horizontal padding,right edge1024 |
| Group header |39px high,title x240 y10 within header,19px text bounds |
| Toggle row |42px high,68×32 control at x956,5px vertical insets |
| Dropdown/field row |46px high,320×36 control at x704,5px vertical insets,value text x720 |
| Group gap |20px |
| Advanced Options |784×38,text x554,24px chevron x686 |

Category order from local reference PNG: App General, Interface, Privacy, Controls; Media Playback, Video, Audio, Subtitles, Library; System Network, Performance, Recording, Extensions. Category pitch48px (8px gap).

Reference icons: General sliders, Interface cursor, Privacy shield, Controls keyboard, Playback play, Video clapperboard, Audio levels, Subtitles rectangle, Library folder, Network radio signal, Performance sliders, Recording circle, Extensions puzzle.

## Exact rows and mapping evidence

Coordinates below are text-top y, not row-container top. Bold indicates group headers. Example text is Figma state, not VLC default. Option definitions can still be unavailable in the Windows build. Included-header prefix macros were checked separately where the first source scan gave a collision; the Linux v4l2 capture controls do not define the general picture settings.

### Global — 999:5047 / 3046:9282

Window title: Global Settings.

| Exact label | Text top y | Mapping or open issue |
|---|---:|---|
| **Appearance** | 80 | Group header. |
| Interface language | 123.5 | Open: no language config definition found in VLC4 tree. |
| Theme | 169.5 | Existing MainCtx.colorScheme model; not native config metadata. PNG confirms Dark / Light / System. |
| Accent color | 215.5 | qt-accent-color — modules/gui/qt/qt.cpp:481 (add_string). |
| **Startup** | 277 | Group header. |
| Show confirmation and error dialogs | 318.5 | qt-error-dialogs — modules/gui/qt/qt.cpp:438 (add_bool). |
| Check for updates automatically | 360.5 | qt-updates-notif — modules/gui/qt/qt.cpp:400 (add_bool; conditional UPDATE_CHECK). |
| **Diagnostics** | 420 | Group header. |
| Developer mode | 461.5 | Open: qt-verbose logs Qt messages and excludes Qt debug categories; it does not enable a developer mode. |
| Save a log | 503.5 | file-logging — modules/logger/file.c:239 (add_bool). |
| Log file | 547.5 | logfile — modules/logger/file.c:240 (add_savefile). |
| Log details | 593.5 | verbose — src/libvlc-module.c:2241 (add_integer). |
| **Advanced Options** | 655.5 | Expand/collapse affordance; no invented subsection heading. |

Example control text: English (y123.5), Browse (y547.5), Errors only (y593.5).

Paired state 3046:9282:
- Normal texts/order unchanged; Advanced Options expands.

| Additional exact label | Text top y | Mapping or open issue |
|---|---:|---|
| Show minor warnings | 715.5 | Open: no separate minor-warning config; qt-error-dialogs controls dialogs. |
| Additional command line options | 759.5 | Open: no persistent arbitrary command-line config. |
| Log format | 805.5 | logmode — modules/logger/file.c:241 (add_string). |
| Collect playback statistics | 849.5 | stats — src/libvlc-module.c:2255 (add_bool). |
| Open configurations folder | 891.5 | Open: action not implemented. |
| Reset all settings | 933.5 | Open: global reset action absent; per-option reset exists. |
| **Developer Options** | 993 | Group header. |
| Write to the system log | 1034.5 | syslog — modules/logger/syslog.c:160 (add_bool). |
| Include debug messages in the system log | 1076.5 | syslog-debug — modules/logger/syslog.c:161 (add_bool). |
| System log identity | 1118.5 | syslog-ident — modules/logger/syslog.c:162 (add_string). |
| System log facility | 1162.5 | syslog-facility — modules/logger/syslog.c:164 (add_string). |

Additional example text: Plain text (y805.5), Open (y891.5), Reset (y933.5), User (y1162.5).

### Interface — 3046:10057 / 3062:11379

Window title: Interface Settings.

| Exact label | Text top y | Mapping or open issue |
|---|---:|---|
| **Skin** | 80 | Group header. |
| Use a custom skin | 121.5 | Open: intf=skins2 is main-interface restart switch, not skin-file boolean. |
| Skin file | 165.5 | skins2-last — modules/gui/skins2/src/skin_main.cpp:497 (add_loadfile). |
| **Window** | 227 | Group header. |
| Play video inside main window | 268.5 | embedded-video — src/libvlc-module.c:1683 (add_bool). |
| Resize window to fit video | 312.5 | qt-video-autoresize — modules/gui/qt/qt.cpp:384 (add_bool). |
| Remember window size and position | 356.5 | Open: qt-remember-window-geometry lacks local config definition. |
| Keep window above other windows | 398.5 | video-on-top — src/libvlc-module.c:1698 (add_bool). |
| Show window decorations | 440.5 | qt-titlebar — modules/gui/qt/qt.cpp:418 (add_bool). |
| Show the file name in the title bar | 482.5 | qt-name-in-title — modules/gui/qt/qt.cpp:386 (add_bool). |
| Open fullscreen on | 526.5 | qt-fullscreen-screennumber — modules/gui/qt/qt.cpp:446 (add_integer). |
| **Playback Controls** | 588 | Group header. |
| Start in compact mode | 629.5 | qt-minimal-view — modules/gui/qt/qt.cpp:358 (add_bool). |
| Auto-hide the controls | 673.5 | Open: qt-controls-autohide lacks local config definition. |
| Hide after | 725 | Open: qt-controls-hide-timeout lacks local config definition. |
| Show controls in fullscreen | 774.5 | qt-fs-controller — modules/gui/qt/qt.cpp:388 (add_bool). |
| **Notifications and System Tray** | 834 | Group header. |
| Show a system tray icon | 875.5 | qt-system-tray — modules/gui/qt/qt.cpp:361 (add_bool). |
| Start minimized to the tray | 917.5 | qt-start-minimized — modules/gui/qt/qt.cpp:368 (add_bool). |
| Show a popup when the track changew | 961.5 | qt-notification — modules/gui/qt/qt.cpp:363 (add_integer; integer choices, not bool). |
| Popup duration | 1013 | Open: qt-notification-timeout lacks local config definition. |
| **Playlist** | 1080 | Group header. |
| Show the playlist as a tree | 1121.5 | playlist-tree — src/libvlc-module.c:2180 (add_bool). |
| **Advanced Options** | 1181.5 | Expand/collapse affordance; no invented subsection heading. |

Example control text: Browse (y165.5), Never (y312.5), Current screen (y526.5), In fullscreen only (y673.5), 0 s (y738), 5 s (y738), 10s (y738), When minimized (y961.5), 0 s (y1026), 5 s (y1026), 10s (y1026).

Paired state 3062:11379:
- Normal texts/order unchanged; Advanced Options expands.

| Additional exact label | Text top y | Mapping or open issue |
|---|---:|---|
| Window opacity | 1249 | qt-opacity — modules/gui/qt/qt.cpp:373 (add_float_with_range). |
| Pause video when window is minimized | 1298.5 | qt-pause-minimized — modules/gui/qt/qt.cpp:370 (add_bool). |
| Bring VLC to the front when playback starts | 1342.5 | qt-auto-raise — modules/gui/qt/qt.cpp:463 (add_integer; integer choices, not bool). |
| Show cover art in the window when playing audio | 1386.5 | Open: qt-bgcone controls the idle background logo in MinimalView.qml, not a verified audio-cover view. |
| Show the file browser inside the open dialog | 1428.5 | qt-embedded-open — modules/gui/qt/qt.cpp:428 (add_bool). |
| Allow the app icon to change | 1470.5 | qt-icon-change — modules/gui/qt/qt.cpp:456 (add_bool). |
| Fullscreen controls opacity | 1520 | qt-fs-opacity — modules/gui/qt/qt.cpp:375 (add_float_with_range). |
| Fullscreen controls sensitivity | 1572 | qt-fs-sensitivity — modules/gui/qt/qt.cpp:460 (add_integer_with_range). |

Additional example text: 10% (y1262), 100% (y1262), Video (y1342.5), 10% (y1533), 100% (y1533), Low (y1585), Medium (y1585), High (y1585).

### Privacy — 3062:11911

Window title: Privacy Settings.

| Exact label | Text top y | Mapping or open issue |
|---|---:|---|
| **History** | 80 | Group header. |
| Save recently played items | 121.5 | save-recentplay — src/libvlc-module.c:1926 (add_bool). |
| Remember the playback position | 163.5 | restore-playback-pos — src/libvlc-module.c:1928 (add_integer; integer choices, not bool). |
| Never remember items matching | 207.5 | Open: qt-recentplay-filter obsolete at modules/gui/qt/qt.cpp:395. |
| Clear history now | 251.5 | Open in adapter: MLRecentMediaModel.clearHistory() existing action, not preference. |
| **Network** | 311 | Group header. |
| Fetch titles and cover art from the internet | 352.5 | metadata-network-access — src/libvlc-module.c:2196 (add_bool; bool, multi-level policy not verified). |
| Submit played tracks to last.fm | 394.5 | filter:extraintf:audioscrobbler. Plugin is an interface (audioscrobbler.c:140), not audio filter. Existing generic list adapter uses real extraintf config (libvlc-module.c:2264); src/libvlc.c:112/116 confirms colon separator. Takes effect at next startup; live activation unverified. |
| Last.fm username | 438.5 | lastfm-username — modules/misc/audioscrobbler.c:135 (add_string). |
| Last.fm username | 484.5 | Open: duplicated exact label; second row must not be inferred as password. |
| Last.fm submission URL | 530.5 | scrobbler-url — modules/misc/audioscrobbler.c:138 (add_string). |

Example control text: Clear (y251.5).

### Playback — 3062:12552 / 3072:13408

Window title: Playback Preferences.

| Exact label | Text top y | Mapping or open issue |
|---|---:|---|
| **Startup** | 80 | Group header. |
| Continue where you left off | 123.5 | restore-playback-pos — src/libvlc-module.c:1928 (add_integer; integer choices, not bool). |
| Start playing as soon as a file opens | 167.5 | playlist-autostart — src/libvlc-module.c:2162 (add_bool). |
| Default playback speed | 222 | rate — src/libvlc-module.c:1914 (add_float). |
| Pause when another app uses audio | 276.5 | playlist-cork — src/libvlc-module.c:2164 (add_bool). |
| **Tracks** | 336 | Group header. |
| Preferred video quality | 379.5 | preferred-resolution — src/libvlc-module.c:1889 (add_integer). |
| Preferred menu language | 425.5 | menu-language — src/libvlc-module.c:1873 (add_string). |
| Default audio track | 471.5 | audio-track — src/libvlc-module.c:1861 (add_integer). |
| Default subtitle track | 517.5 | sub-track — src/libvlc-module.c:1864 (add_integer). |
| **Order** | 579 | Group header. |
| Repeat | 622.5 | redesign-repeat; existing adapter combines repeat/loop. |
| Shuffle | 666.5 | random — src/libvlc-module.c:2147 (add_bool). |
| Stop after each item | 708.5 | play-and-stop — src/libvlc-module.c:2157 (add_bool). |
| When playback finishes | 752.5 | redesign-after-playback; existing adapter combines play-and-exit/play-and-pause. |
| **Seeking** | 814 | Group header. |
| Seek precisely | 855.5 | input-fast-seek — src/libvlc-module.c:1911 (add_bool). |
| Show thumbnail while scrubbing | 897.5 | Open: no matching persistent option in this branch. |
| **Files & Discs** | 957 | Group header. |
| Default optical drive | 1000.5 | dvd — src/libvlc-module.c:1937 (add_loadfile). |
| Repair damaged AVI files | 1046.5 | avi-index — modules/demux/avi/avi.c:85 (add_integer). |
| Load matching .mkv files from the same folder | 1090.5 | mkv-preload-local-dir — modules/demux/mkv/mkv.cpp:69 (add_bool). |
| **Advanced Options** | 1150.5 | Expand/collapse affordance; no invented subsection heading. |

Example control text: Always (y123.5), 0.25 (y240), 0.5 (y240), 0.75 (y240), 1 (y240), 1.25 (y240), 1.5 (y240), 1.75 (y240), 2 (y240), Best available (y379.5), English (y425.5), 1 (y471.5), 1 (y517.5), Off (y622.5), Stop (y752.5), - (y1000.5), Ask (y1046.5).

Paired state 3072:13408:
- Track-field rows shift1–2px; groups after them shift 2px. Normal texts unchanged; Advanced Options expands.

| Additional exact label | Text top y | Mapping or open issue |
|---|---:|---|
| Time-shift buffer folder | 1212.5 | input-timeshift-path — src/libvlc-module.c:2032 (add_directory). |
| Time-shift buffer size | 1256.5 | input-timeshift-granularity — src/libvlc-module.c:2034 (add_integer). |

Additional example text: Browse (y1212.5), Medium (y1256.5).

### Video — 3073:14187 / 3073:15375

Window title: Video Defaults.

| Exact label | Text top y | Mapping or open issue |
|---|---:|---|
| **Output** | 80 | Group header. |
| Enable video | 121.5 | video — src/libvlc-module.c:1673 (add_bool). |
| Start videos in fullscreen | 163.5 | fullscreen — src/libvlc-module.c:1677 (add_bool). |
| Stop the screensaver during playback | 205.5 | disable-screensaver — src/libvlc-module.c:1702 (add_integer). |
| Play video as desktop wallpaper | 247.5 | video-wallpaper — src/libvlc-module.c:1700 (add_bool). |
| **Picture** | 307 | Group header. |
| Hue | 348.5 | hue - modules/video_filter/adjust.c:78 (float -180..180, default 0). |
| Brightness | 390.5 | brightness - modules/video_filter/adjust.c:75 (float 0..2, default 1). |
| Contrast | 432.5 | contrast - modules/video_filter/adjust.c:72 (float 0..2, default 1). |
| Saturation | 474.5 | saturation - modules/video_filter/adjust.c:81 (float 0..3, default 1). |
| Gamma | 516.5 | gamma - modules/video_filter/adjust.c:84 (float 0.01..10, default 1). |
| Reset picture | 558.5 | Per-option reset(name) exists; compound action not implemented. |
| **Deinterlacing** | 618 | Group header. |
| Deinterlacing | 661.5 | deinterlace — src/libvlc-module.c:1775 (add_integer). |
| Method | 707.5 | deinterlace-mode — src/libvlc-module.c:1779 (add_string). |
| **Framing** | 769 | Group header. |
| Aspect ratio | 812.5 | aspect-ratio — src/libvlc-module.c:1753 (add_string). |
| Crop | 858.5 | crop — src/libvlc-module.c:1749 (add_string). |
| Scale video to the window | 902.5 | autoscale — src/libvlc-module.c:1756 (add_bool). |
| Zoom | 946.5 | zoom — src/libvlc-module.c:1773 (add_float). |
| Position in the window | 992.5 | align — src/libvlc-module.c:1771 (add_integer). |
| **Snapshots** | 1054 | Group header. |
| Save to | 1095.5 | snapshot-path — src/libvlc-module.c:1723 (add_directory). |
| File name prefix | 1137.5 | snapshot-prefix — src/libvlc-module.c:1724 (add_string). |
| Format | 1181.5 | snapshot-format — src/libvlc-module.c:1726 (add_string). |
| Size | 1227.5 | Open: snapshot-width/height exist; combined Same as video preset values unspecified. |
| Number files sequentially | 1271.5 | snapshot-sequential — src/libvlc-module.c:1731 (add_bool). |
| Show a preview after capture | 1313.5 | snapshot-preview — src/libvlc-module.c:1729 (add_bool). |
| **Advanced Options** | 1373.5 | Expand/collapse affordance; no invented subsection heading. |

Example control text: Reset (y558.5), Automatic (y661.5), Automatic (y707.5), Automatic (y812.5), None (y858.5), Fit (y946.5), Center (y992.5), Browse (y1095.5), 1 (y1137.5), PNG (y1181.5), Same as video (y1227.5).

Paired state 3073:15375:
- Normal texts/order unchanged; Advanced Options expands.

| Additional exact label | Text top y | Mapping or open issue |
|---|---:|---|
| Custom aspect ratios | 1433.5 | custom-aspect-ratios — src/libvlc-module.c:1764 (add_string). |
| Custom crop ratios | 1475.5 | custom-crop-ratios — src/libvlc-module.c:1751 (add_string). |
| Monitor pixel aspect ratio | 1517.5 | Open: no matching persistent monitor-pixel-aspect config. |
| Time-shift buffer size | 1561.5 | input-timeshift-granularity — src/libvlc-module.c:2034 (add_integer). |

Additional example text: 1:1 (y1517.5), Medium (y1561.5).

### Audio — 3073:15879 / 3180:17398

Window title: Audio Defaults.

| Exact label | Text top y | Mapping or open issue |
|---|---:|---|
| **Output** | 80 | Group header. |
| Enable audio | 121.5 | audio — src/libvlc-module.c:1613 (add_bool). |
| Output device | 165.5 | Open: aout selects output module, not device. Windows mmdevice-audio-device exists at mmdevice.c:1584, but adapter exposes raw device IDs and no generic device model. |
| Speaker setup | 211.5 | mix-mode - src/libvlc-module.c:1633 (integer Unset/Stereo/Binaural/4.0/5.1/7.1). Imported stereo-mode selects stereo channels, not speaker layout. |
| **Volume** | 273 | Group header. |
| Maximum volume | 327 | qt-max-volume — modules/gui/qt/qt.cpp:458 (add_integer_with_range). |
| Startup volume | 409.5 | Open: volume-save means remember last volume; module-specific startup levels exist, compound-control semantics missing. |
| Volume step | 482.5 | volume-step — src/libvlc-module.c:1617 (add_float). |
| **Loudness** | 545 | Group header. |
| Normalize loudness | 586.5 | filter:audio-filter:normvol; filter-list pseudo-row, plugin availability required. |
| Target level | 631.5 | norm-max-level — modules/audio_filter/normvol.c:84 (add_float). |
| Night mode | 676.5 | Open: compressor alone does not establish intended night-mode profile. |
| Replay gain | 720.5 | audio-replay-gain-mode — src/libvlc-module.c:1640 (add_string). |
| Replay gain preamp | 767.5 | audio-replay-gain-preamp — src/libvlc-module.c:1643 (add_float). |
| **Effects** | 830 | Group header. |
| Equalizer | 871.5 | filter:audio-filter:equalizer; filter-list pseudo-row, plugin availability required. |
| Equalizer preset | 916.5 | equalizer-preset — modules/audio_filter/equalizer.c:84 (add_string). |
| Two-pass | 1007.5 | equalizer-2pass — modules/audio_filter/equalizer.c:89 (add_bool). |
| Spatial audio | 1049.5 | Uncertain: spatialaudio is audio renderer/converter, not an ordinary audio-filter. |
| Spatial audio mode | 1093.5 | Open: spatialaudio-headphones obsolete; Headphone virtualization choice config missing. |
| Stereo widening | 1137.5 | filter:audio-filter:stereo_widen; filter-list pseudo-row, plugin availability required. |
| Compressor | 1179.5 | filter:audio-filter:compressor; filter-list pseudo-row, plugin availability required. |
| Pitch shift | 1221.5 | pitch-shift — modules/audio_filter/scaletempo.c:71 (add_float_with_range). |
| Chorus/flanger | 1263.5 | filter:audio-filter:chorus_flanger; filter-list pseudo-row, plugin availability required. |
| Karaoke | 1305.5 | filter:audio-filter:karaoke; filter-list pseudo-row, plugin availability required. |
| **Tracks** | 1365 | Group header. |
| Preferred audio language | 1408.5 | audio-language — src/libvlc-module.c:1867 (add_string). |
| Audio delay | 1454.5 | audio-desync — src/libvlc-module.c:1635 (add_integer; ms). |
| **Visualization** | 1516 | Group header. |
| Visualizer | 1559.5 | audio-visual — src/libvlc-module.c:1662 (add_module). |
| **Advanced Options** | 1621.5 | Expand/collapse affordance; no invented subsection heading. |

Example control text: System default (y165.5), Automatic (y211.5), 100% (y345), 200% (y345), 300% (y345), 1 (y482.5), 1 (y631.5), Off (y720.5), 0.0 (y767.5), Headphone virtualization (y1093.5), 0.00 (y1221.5), System language (y1408.5), 0.00 (y1454.5).

Paired state 3180:17398:
- Content scrolls upward 761.5px; expanded equalizer adds 453px before Two-pass. Preset text y155, Two-pass y699. Negative-y normal rows are not removed.

| Additional exact label | Text top y | Mapping or open issue |
|---|---:|---|
| Pass compressed audio to the receiver | 1373 | spdif — src/libvlc-module.c:1624 (add_bool). |
| Detect Dolby Surround | 1417 | force-dolby-surround — src/libvlc-module.c:1628 (add_integer). |
| Resampling quality | 1463 | audio-resampler — src/libvlc-module.c:1666 (add_module). |
| Media role | 1509 | role — src/libvlc-module.c:1653 (add_string). |
| Visualization size | 1555 | Open: effect-width/height exist; Match window preset mapping unspecified. Also authored under Subtitles. |

Additional example text: Balanced (y1463), Video (y1509), Match window (y1555).

### Subtitles — 3180:17989 / 6536:13908

Window title: Subtitle Defaults.

| Exact label | Text top y | Mapping or open issue |
|---|---:|---|
| **Tracks & Languages** | 80 | Group header. |
| Enable subtitles | 121.5 | spu — src/libvlc-module.c:1804 (add_bool). |
| Preferred language | 165.5 | sub-language — src/libvlc-module.c:1870 (add_string). |
| Text encoding | 211.5 | subsdec-encoding — modules/codec/subsdec.c:189 (add_string). |
| **Loading Subtitles** | 273 | Group header. |
| Load subtitle files automatically | 314.5 | sub-autodetect-file — src/libvlc-module.c:1817 (add_bool). |
| File name matching | 358.5 | sub-autodetect-fuzzy — src/libvlc-module.c:1819 (add_integer). |
| **Appearance** | 420 | Group header. |
| Font | 464.5 | freetype-font — modules/text_renderer/freetype/freetype.c:141 (add_font). |
| Size values | 512.5 | Open: opaque XML control; sub-text-scale is percentage, not verified units mode. |
| Font size | 559.5 | sub-text-scale — src/libvlc-module.c:1830 (add_integer_with_range). |
| Bold | 603.5 | freetype-bold — modules/text_renderer/freetype/freetype.c:160 (add_bool). |
| Text color | 645.5 | freetype-color — modules/text_renderer/freetype/freetype.c:156 (add_rgb). |
| Text opacity | 700 | freetype-opacity — modules/text_renderer/freetype/freetype.c:151 (add_integer_with_range). |
| Outline thickness | 756.5 | freetype-outline-thickness — modules/text_renderer/freetype/freetype.c:176 (add_integer_with_range). |
| Outline color | 800.5 | freetype-outline-color — modules/text_renderer/freetype/freetype.c:173 (add_rgb). |
| Shadow | 842.5 | Open: freetype-shadow-opacity is numeric 0..255; toggle restore semantics unspecified. |
| Shadow color | 884.5 | freetype-shadow-color — modules/text_renderer/freetype/freetype.c:184 (add_rgb). |
| Shadow distance | 928.5 | Open: freetype-shadow-distance exists 0..1, Small preset values unspecified. |
| Background | 974.5 | Open: freetype-background-opacity is numeric; None selector mapping unspecified. |
| Background color | 1018.5 | freetype-background-color — modules/text_renderer/freetype/freetype.c:166 (add_rgb). |
| Background opacity | 1073 | freetype-background-opacity — modules/text_renderer/freetype/freetype.c:163 (add_integer_with_range). |
| Vertical position | 1129.5 | Open: sub-margin pixel offset is not verified Bottom selector. |
| **Timing** | 1191 | Group header. |
| Subtitle delay | 1245 | sub-delay — src/libvlc-module.c:1814 (add_integer; tenths seconds, factor 0.1). |
| **On-Screen Messages** | 1317 | Group header. |
| Show feedback for shortcuts | 1358.5 | osd — src/libvlc-module.c:1808 (add_bool). |
| Show feedback for | 1413 | Open: no persistent OSD feedback-duration option; video-title-timeout only filename. |
| Show filename when a video starts | 1467.5 | video-title-show — src/libvlc-module.c:1705 (add_bool). |
| Show filename for | 1522 | video-title-timeout — src/libvlc-module.c:1712 (add_integer). |
| **Advanced Options** | 1594.5 | Expand/collapse affordance; no invented subsection heading. |

Example control text: System language (y165.5), Automatic (y211.5), Title with extra characters (y358.5), System, sans-serif (y464.5), Automatic (y559.5), #FFFFFF (y645.5), 0% (y718), 50% (y718), 100% (y718), Normal (y756.5), #000000 (y800.5), #000000 (y884.5), Small (y928.5), None (y974.5), #000000 (y1018.5), 0% (y1091), 50% (y1091), 100% (y1091), Bottom (y1129.5), -5 s (y1263), 0 s (y1263), +5 s (y1263), 0.5 s (y1431), 5 s (y1431), 1 s (y1540), 10 s (y1540).

Paired state 6536:13908:
- Normal texts/order unchanged; Advanced Options expands.

| Additional exact label | Text top y | Mapping or open issue |
|---|---:|---|
| Load subtitles from these folders | 1657.5 | sub-autodetect-path — src/libvlc-module.c:1826 (add_string). |
| Ignore styling in ASS and SSA subtitles | 1702.5 | Open: subsdec-formatted controls USF, not ASS/SSA overrides. |
| Shadow angle | 1747.5 | freetype-shadow-angle — modules/text_renderer/freetype/freetype.c:187 (add_float_with_range). |
| Text direction | 1794.5 | freetype-text-direction — modules/text_renderer/freetype/freetype.c:209 (add_integer_with_range). |
| Monospace font | 1841.5 | freetype-monofont — modules/text_renderer/freetype/freetype.c:142 (add_font). |
| Visualization size | 1888.5 | Open: effect-width/height exist; Match window preset mapping unspecified. Also authored under Subtitles. |

Additional example text: 0 (y1747.5), System monospace (y1841.5), Match window (y1888.5).

### Controls — 6536:14482

Window title: Mouse, Keyboard & Remote Controls.

| Exact label | Text top y | Mapping or open issue |
|---|---:|---|
| **Keyboard Shortcuts** | 80 | Group header. |
| Defaults | 121.5 | Shortcut editor action. |
| Reset all shortcuts | 163.5 | Existing shortcut reset backend action. |
| **Skip Amounts** | 223 | Group header. |
| Very short skip | 267.5 | extrashort-jump-size — src/libvlc-module.c:2765 (add_integer). |
| Short skip | 315.5 | short-jump-size — src/libvlc-module.c:2767 (add_integer). |
| Medium skip | 363.5 | medium-jump-size — src/libvlc-module.c:2769 (add_integer). |
| Long skip | 411.5 | long-jump-size — src/libvlc-module.c:2771 (add_integer). |
| **Mouse** | 474 | Group header. |
| Single click on the video | 517.5 | mouse-pause-policy — src/libvlc-module.c:1695 (add_string). |
| Double click on the video | 563.5 | Open: fullscreen double-click code exists, no persistent selector config. |
| Scroll wheel | 609.5 | hotkeys-y-wheel-mode — src/libvlc-module.c:2276 (add_integer). |
| Horizontal scroll | 655.5 | hotkeys-x-wheel-mode — src/libvlc-module.c:2279 (add_integer). |
| Reverse scroll direction | 699.5 | Open: hotkeys-wheel-direction lacks local config definition. |
| **Remotes** | 759 | Group header. |
| Web remote control | 800.5 | Open: extraintf=http is interface list; enable/disable lifecycle and list preservation not implemented. |
| Port | 845.5 | http-port — src/libvlc-module.c:1948 (add_integer). |
| Scroll wheel | 892.5 | hotkeys-y-wheel-mode — src/libvlc-module.c:2276 (add_integer). |
| Horizontal scroll | 938.5 | hotkeys-x-wheel-mode — src/libvlc-module.c:2279 (add_integer). |
| Reverse scroll direction | 982.5 | Open: hotkeys-wheel-direction lacks local config definition. |
| **Advanced Options** | 1042.5 | Expand/collapse affordance; no invented subsection heading. |

Example control text: Edit Keyboard Shortcuts (y121.5), Reset (y163.5), 3 s (y267.5), 10 s (y315.5), 60 s (y363.5), 300 s (y411.5), Play / Pause (y517.5), Toggle fullscreen (y563.5), Volume (y609.5), Seek (y655.5), Volume (y892.5), Seek (y938.5).

### Library — 6542:15251

Window title: Playlists, Folders & Files.

| Exact label | Text top y | Mapping or open issue |
|---|---:|---|
| **Opening Files** | 80 | Group header. |
| Only allow one VLC window | 121.5 | one-instance — src/libvlc-module.c:2166 (add_bool). |
| Apply to files opened from the file manager | 163.5 | one-instance-when-started-from-file — src/libvlc-module.c:2171 (add_bool). |
| Add to the playlist instead of replacing it | 205.5 | playlist-enqueue — src/libvlc-module.c:2173 (add_bool). |
| When opening a folder | 249.5 | recursive — src/libvlc-module.c:2198 (add_string). |
| Show hidden files | 293.5 | show-hiddenfiles — src/libvlc-module.c:2205 (add_bool). |
| **Metadata & Artwork** | 353 | Group header. |
| Fetch titles and artwork | 396.5 | metadata-network-access — src/libvlc-module.c:2196 (add_bool; bool, multi-level policy not verified). |
| Use the media library | 440.5 | media-library — src/libvlc-module.c:2179 (add_bool). |
| **Advanced Options** | 500.5 | Expand/collapse affordance; no invented subsection heading. |

Example control text: Include subfolders (y249.5), From the file only (y396.5).

### Network — 6543:15649

Window title: Network Connections & Security.

| Exact label | Text top y | Mapping or open issue |
|---|---:|---|
| **Buffering** | 80 | Group header. |
| Buffering | 123.5 | Open: individual caching values exist, Normal aggregate preset values unspecified. |
| Local files | 170.5 | file-caching — src/libvlc-module.c:1998 (add_integer). |
| Discs | 218.5 | disc-caching — src/libvlc-module.c:2006 (add_integer). |
| Network streams | 266.5 | network-caching — src/libvlc-module.c:2010 (add_integer). |
| Live capture | 314.5 | live-caching — src/libvlc-module.c:2002 (add_integer). |
| **Proxy** | 377 | Group header. |
| HTTP proxy | 421.5 | http-proxy — src/libvlc-module.c:1961 (add_string). |
| HTTP proxy password | 469.5 | http-proxy-pwd — src/libvlc-module.c:1962 (add_password). |
| **Security** | 532 | Group header. |
| Verify certificates against the system trust store | 573.5 | gnutls-system-trust — modules/misc/gnutls.c:757 (add_bool). |
| Cipher preference | 617.5 | gnutls-priorities — modules/misc/gnutls.c:761 (add_string; raw string, Balanced preset not verified). |
| **Advanced Options** | 679.5 | Expand/collapse affordance; no invented subsection heading. |

Example control text: Normal (y123.5), System proxy (y421.5), Balanced (y617.5).

### Performance — 6571:15958

Window title: Performance Settings.

| Exact label | Text top y | Mapping or open issue |
|---|---:|---|
| **Decoding** | 80 | Group header. |
| Hardware-accelerated decoding | 123.5 | Imported avcodec-hw is obsolete (avcodec.c:127). Current hw-dec boolean and dec-dev module selector exist at src/libvlc-module.c:2054/2056; Figma Automatic dropdown mapping needs explicit semantics before implementation. |
| Video post-processing | 169.5 | postproc-q — modules/video_filter/postproc.c:88 (add_integer_with_range). |
| Skip the H.264 loop filter | 215.5 | avcodec-skiploopfilter — modules/codec/avcodec/avcodec.c:120 (add_integer). |
| Decoding threads | 262.5 | avcodec-threads — modules/codec/avcodec/avcodec.c:128 (add_integer). |
| **Smooth Playback** | 325 | Group header. |
| Drop frames when the system can't keep up | 366.5 | drop-late-frames — src/libvlc-module.c:1686 (add_bool). |
| Give VLC real-time priority | 408.5 | Open: Windows high-priority tries ABOVE_NORMAL/HIGH_PRIORITY_CLASS, not REALTIME_PRIORITY_CLASS (src/win32/thread.c). |
| Process priority | 453.5 | Open: high-priority Windows bool exists; numeric Process priority option missing. |
| Rescan plugins | 498.5 | Open: reset-plugins-cache startup-only option; live action not implemented. |
| **Advanced Options** | 558.5 | Expand/collapse affordance; no invented subsection heading. |
| **Developer** | 616 | Group header. |
| Encoder | 659.5 | Open: encoder obsolete at src/libvlc-module.c:2055. |
| Decoder | 705.5 | codec — src/libvlc-module.c:2053 (preferred decoders list string). Imported decoder option does not exist. Automatic is native any. |
| Clock synchronisation | 751.5 | clock-synchro — src/libvlc-module.c:2017 (add_integer). |
| Clock jitter | 798.5 | clock-jitter — src/libvlc-module.c:2020 (integer milliseconds). |
| Clock reference averaging | 846.5 | cr-average — src/libvlc-module.c:2015 (integer counter). Imported clock-average name is wrong. |

Example control text: Automatic (y123.5), Off (y169.5), Never (y215.5), 0 (y262.5), 0 (y453.5), Rescan (y498.5), Automatic (y659.5), Automatic (y705.5), Default (y751.5), 5000 ms (y798.5), 40 (y846.5).

### Recording — 6571:16429

Window title: Recording, Casting & Streaming Out.

| Exact label | Text top y | Mapping or open issue |
|---|---:|---|
| **Recording** | 80 | Group header. |
| Save recordings to | 124.5 | input-record-path — src/libvlc-module.c:2027 (add_directory). |
| Record without re-encoding when possible | 169.5 | input-record-native — src/libvlc-module.c:2029 (add_bool). |
| **Casting** | 229 | Group header. |
| Discover cast devices | 270.5 | Open: RendererManager scan operation, no persistent discovery bool. |
| Cast quality | 314.5 | sout-chromecast-conversion-quality — modules/stream_out/renderer_common.hpp:56, expanded by chromecast/cast.cpp:236. Integer choices High / Medium / Low / Low CPU; Figma Automatic is not a native choice. |
| **Streaming** | 376 | Group header. |
| Play locally while streaming | 417.5 | sout-display — src/libvlc-module.c:2069 (add_bool). |
| Include audio | 459.5 | sout-audio — src/libvlc-module.c:2075 (add_bool). |
| Include video | 501.5 | sout-video — src/libvlc-module.c:2077 (add_bool). |
| include subtitles | 543.5 | sout-spu — src/libvlc-module.c:2079 (add_bool). |
| Encoding preset | 587.5 | sout-x264-preset — modules/codec/x264.c:706 (add_string). |
| Tuning | 633.5 | sout-x264-tune — modules/codec/x264.c:710 (add_string). |
| **Advanced Options** | 695.5 | Expand/collapse affordance; no invented subsection heading. |

Example control text: ~/Videos (y124.5), Browse (y124.5), Automatic (y314.5), Medium (y587.5), None (y633.5).

### Extensions — 6575:17137

Window title: Add-ons & Scripts.

| Exact label | Text top y | Mapping or open issue |
|---|---:|---|
| **Add-ons** | 80 | Group header. |
| Load add-ons on startup | 368.5 | qt-autoload-extensions — modules/gui/qt/qt.cpp:449 (add_bool). |
| **Advanced Options** | 428.5 | Expand/collapse affordance; no invented subsection heading. |

Example control text: Add (y318.5), Remove (y318.5).

## Keyboard Shortcuts — 2437:14832

Frame1048×800. XML exposes Basic and start of Playback only; lower groups are absent and cannot be claimed Figma-matched. Imported backend Audio/Video/Subtitles/Other grouping is implementation evidence only.

| Element | Geometry / exact text |
|---|---|
| Header | Keyboard Shortcuts x19 y16.5,132×17 |
| Search | Search Keyboard Shortcuts... x51 y61.5,193×17 |
| Scope | All Fields x851 y61.5,60×17 |
| Columns | Action x20 y116,width488; Hotkey x508 y116,width332; Global Hotkey x840 y116,width93;25px bounds high |
| Basic header | x20 y181,1008×28 |
| Playback header | x20 y448,1008×28 |
| Rows |25px text bounds,47px pitch |
| Footer | Cancel x46 y755.5,48×17; Save x961.5 y755.5,33×17 |

| Exact action | Text y | Example hotkey | Native key |
|---|---:|---|---|
| Toggle fullscreen | 233 | F | key-toggle-fullscreen (core hotkey macro) |
| Exit fullscreen / close dialog | 280 | esc | key-leave-fullscreen (core hotkey macro) |
| Show playback position and time | 327 | T | key-position (core hotkey macro) |
| Show interface controls in fullscreen | 374 | I | key-intf-show (core hotkey macro) |
| Play / pause | 500 | Space | key-play-pause (core hotkey macro) |
| Stop playback | 547 | S | key-stop (core hotkey macro) |
| Next track | 594 | N | key-next (core hotkey macro) |
| Previous track | 641 | P | key-prev (core hotkey macro) |
| Next program / Service ID | 688 | X | key-program-sid-next (core hotkey macro) |

No reference states for shortcut-edit popup, hover, tooltips, conflict resolution, text weights, or dropdown choice lists. Preserve validated native behavior without claiming visual equivalence for missing states.

## Imported catalog differences

Exact reference labels replace imported labels only with certain source semantics: Web remote port→Port; Save snapshots to→Save to; Image format→Format; Audio delay (ms)→Audio delay; files/discs/stream cache labels→Local files, Discs, Network streams, Live capture. Last.fm password and remote Password are absent from XML; second Username is ambiguous. Remember the last volume is not Startup volume; Shadow opacity is not Shadow. Remove invented Advanced Audio/Video/Subtitles group headings. Global Developer Options is explicitly authored. Complete/expert option browser is absent from these frames.

## Native backend constraints

describe() supports real configs, filter-list pseudo-rows, repeat/loop and after-playback composites. No missing option is synthesized. Per-option reset exists; global reset, config-folder opening, add-on management, discovery control and aggregate/preset actions need implemented existing APIs or stay omitted. Store auto-saves after 300ms. Preferences frames have no Save/Cancel footer; Keyboard Shortcuts does.

Unclear mappings remain omitted/open. Build availability, observed pages and omissions belong in redesign/VERIFICATION.md. No hover or live UI behavior was verified in this static audit.

## Actionable catalog omission list

These are conservative omissions under the user rule to omit unverified semantics. Existing actions may be implemented through verified VLC APIs in a later change; they are not fabricated options.

| Category | Omit or leave open | Reason |
|---|---|---|
| Global | Interface language; Developer mode; Show minor warnings; Additional command line options; Open configurations folder; Reset all settings | No native config or imported action. qt-verbose controls Qt logging, not a developer mode. Theme uses the existing color-scheme model. |
| Interface | Use a custom skin; Remember window size and position; Auto-hide the controls; Hide after; Popup duration; Show cover art in the window when playing audio; Fullscreen controls sensitivity | Restart-interface semantics or nonexistent option names. qt-bgcone controls an idle logo, not audio cover art. Low/Medium/High sensitivity values are unspecified. |
| Privacy | Never remember items matching; Clear history now; second Last.fm username | Obsolete option, unimplemented action, duplicate ambiguous label. Imported Last.fm password is not in reference. |
| Playback | Show thumbnail while scrubbing; Time-shift buffer size | No persistent thumbnail option. Medium does not establish a value for the native byte-count option. |
| Video | Reset picture; Size; Monitor pixel aspect ratio; Medium time-shift preset | Combined reset action missing; aggregate/preset semantics unknown. Real input-timeshift-granularity is bytes, not confirmed named Medium value. |
| Audio | Output device; Startup volume; Night mode; Spatial audio; Spatial audio mode; Pitch shift; Resampling quality; Visualization size | Device model absent; compound controls, filter profile, renderer capability, obsolete headphone option, filter enablement, or unknown quality/size preset. |
| Subtitles | Size values; Shadow; Shadow distance preset; Background; Vertical position; Show feedback for; Ignore styling in ASS and SSA subtitles; Visualization size | Opaque controls or missing exact semantic/preset mapping. Keep numeric settings only if the user explicitly resolves intended presentation. |
| Controls | Double click on the video; Reverse scroll direction; Web remote control; imported Password | Missing persistent selector or enable/disable operation; Password not shown in Figma. Remote repeated Scroll wheel/Horizontal scroll have existing same-named semantics. |
| Library | Multi-level Fetch titles and artwork policy | Existing metadata-network-access is boolean. Only From the file only example is visible; no full selector option list in XML. |
| Network | Buffering preset; Balanced cipher preset | Individual caches/raw GnuTLS priority string exist; aggregate/preset mapping absent. |
| Performance | Automatic hardware selector until its intended mapping is resolved; Give VLC real-time priority; Process priority; Rescan plugins; Encoder | Obsolete avcodec-hw; high-priority uses above-normal/high Windows priority, not real-time; numeric-priority config absent; live operation absent; encoder obsolete. Use codec/cr-average corrected names for verified Decoder/Clock reference averaging rows. |
| Recording | Discover cast devices; Automatic cast-quality choice | No persistent discovery boolean; native quality choices are High/Medium/Low/Low CPU. Actual Cast quality option exists. |
| Extensions | Extension list/search/find/add/remove | Existing imported adapter has no add-on management model/actions. Load add-ons on startup is a real config. |

For exact font size, outline thickness and other curated dropdowns, one visible example in XML is insufficient to establish every preset value. The existing imported choices are implementation evidence and must not be called Figma-verified.

Runtime availability: native metadata hides missing modules, obsolete configs, or options absent from this Windows build. Examples include conditional UPDATE_CHECK, Unix syslog, unavailable filter plugins and platform-only audio outputs. These omissions must be confirmed by observed screenshots rather than inferred as successful controls. The dvd option is defined across platforms; it is not a Linux-only omission.

## User-approved exceptions and implemented catalog presentation

The user explicitly approved keeping the inherited nine accent swatch values as an exception to unavailable Figma paint overrides. Those individual swatches are not claimed independently Figma-paint verified. The user also approved correcting the authored track changew typo to track changes and omitting the second ambiguous Last.fm username row.

The curated catalog now provides exact window titles and retains only normal/advanced Figma sections; its search covers those curated rows. Native config choices are used where defined. Invented Advanced Audio/Video/Subtitles headings and Library/Network advanced lists have been removed. The imported complete/expert browsing affordance is outside the cited frames and is handled by the window owner.

Presentation metadata comes from each actual row ancestor, excluding enclosing group frames. Fields use rowHeight42/46/48 where authored. Slider metadata uses right-column320px width (window implementation), exact rowHeight, authored scaleLabels when present, and tickCount from degrees/vector nodes. Examples: speed67px/8ticks; hue42px/3ticks; brightness42px/3ticks; contrast42px/3ticks; saturation42px/4ticks; gamma42px/11ticks; maximum volume67px/9ticks; text/background opacity67px/11ticks; subtitle delay67px/11ticks; filename duration67px/10ticks; window/fullscreen opacity57px/47px with10ticks. No slider is full-width. Label-sibling18px Icon instances are marked helpIcon; the Global reference PNG independently confirms these are information affordances.

Subtitle Font size is exposed as raw sub-text-scale percent input, not the unverified Automatic/Small/Large presets imported from dsojevic. Outline thickness similarly uses the actual integer config, not invented preset values. These presentations differ from the Figma dropdown state and must remain an explicit fidelity limitation.

Additional deliberate omissions in the implemented catalog: Output device (module/device mismatch), Pitch shift (saving scalar does not enable pitch-shifter filter), Fullscreen controls sensitivity (Low/Medium/High values unspecified), Time-shift buffer size (Medium bytes/preset mapping unspecified), Cipher preference (Balanced priority-string preset unspecified), Resampling quality (Balanced quality/module mapping unspecified), Library Fetch titles and artwork policy (multi-level policy unspecified). Cast quality retains the actual native quality choices; the Figma Automatic example is unsupported.

The expanded EQ instance3180:17553 supplies only784×489 geometry, with no internal band labels or layout. The user approved VLC's existing band representation instead: ten vertical sliders and a separate Preamp, -20 to+20dB in0.1dB steps. Frequencies honor equalizer-vlcfreqs and presets come directly from modules/audio_filter/equalizer_presets.h. Preset selection stages all ten gains and the native preamp together; changing one gain preserves the other nine. Enabling the filter materializes an empty band list so it can load on the next audio output. This is an approved presentation exception, not a claim of exact Figma EQ fidelity.

## Native controls that differ from the Figma example state

Native enum values are preserved instead of coercing them into a guessed toggle or preset. Privacy Remember the playback position uses restore-playback-pos choices (Never/Ask/Always) even though the XML shows a toggle. Video Stop the screensaver during playback uses integer disable-screensaver choices even though the XML shows a toggle. Source-defined choices also remain for deinterlace, notifications and automatic window raising. Actual config values/defaults are not overwritten to imitate the reference's example values.

Other known presentation limits: raw aspect-ratio/crop/zoom fields do not reproduce the authored Automatic/None/Fit dropdown presets; the Decoder preferred-list config is a raw string, not a fabricated Automatic selector; native resampler, cipher and aggregate-size presets remain omitted. Controls observed in screenshots can be marked seen, while these remaining control/preset differences keep full design fidelity open.

Slider wrapper geometry: Window opacity and Fullscreen controls opacity are47px high with tick-label frame top28px. Other retained sliders with labels are57px high with label top38px. Catalog records sliderHeight and labelTop. The fullscreen-opacity row is authored47px while its47px inner widget starts5px down, so the reference contains5px overflow; row height is preserved rather than guessed.

The volume-step config stores VLC volume units: src/audio_output/output.c divides by AOUT_VOLUME_DEFAULT (256). The field therefore displays percent using factor100/256; native default12.8 displays5%. Stereo widening uses the actual stereo_widen module name, not the imported nonexistent stereowiden token.

The local video.svg export contains only a screen outline, while the existing reference PNG shows a clapperboard. The user delegated that choice; the screen export is used and the missing details remain open. The preference keyboard glyph derives eight round key dots from the original hotkeys.svg strokes; the original export and global outline generator are unchanged.
