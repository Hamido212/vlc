# Queue panel

Read from the Figma file `kJ3O3At8xC5cqxEwD2LD1n`, variant `491:1781`
("Controls", Property 1=queue), on 2026-10-13. Sizes in px of the 1920x1080
design, colors by their style name in `tokens.json`.

The panel (`463:831`) is the same as the tracks and the settings panel:
400 wide, 20 from the right edge, 20 over the control bar, radius 10,
Dark/BG/B1 Transparent, blurred behind.

## Tabs (`463:832`)

Dark/BG/B2, 50 high, 6 of padding left and right, three tabs of equal width:
Queue (icon `queue`), Bookmarks (icon `bookmarks`), Chapters (icon
`chapters`). Each is a 20 icon, 8, the name in 12; the line under it is 2
high. Selected: Dark/FG/A2 with the line in the accent, the others
Dark/FG/A3. These are the tabs of the other panels.

## Head (`463:840`)

Padding 28 left, 20 right, 20 above and below.

- Left: "4 items - 2h 3m", 14, Dark/FG/A3.
- Right, 12 apart, icons of 24: `sort`, `repeat`, `shuffle`, `remove`, `add`.
  Repeat and shuffle have 3 of padding left and right (30 wide).

## List (`463:846`)

Padding 20 left and right, rows 12 apart. A row (`463:848`), 32 high:

- the `move` icon, 24 with 4 of padding around it,
- 10, the name in 14, Dark/FG/A1, taking the room that is left,
- 10, the duration ("23:06") in 14, Dark/FG/A3, 4 from the right end.

The variant shows no row that is playing, hovered or selected.

## Control bar

With the panel open the queue button is the `lists` icon in its active
state (`467:493`, accent); the rest of the bar is unchanged.
