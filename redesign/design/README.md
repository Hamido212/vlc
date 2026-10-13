# Design reference

What was read from the Figma file, kept here because the file cannot be
queried at will (the Figma MCP server allows 20 calls a month on a free plan).

- `figma-nodes.xml`: every node of the file with its id, type, name, position
  and size. No colors or text styles, but enough to find a screen and measure
  its layout.
- `player.png`, `player-reference.tsx`: the main player frame (node `247:445`)
  as an image and as the reference code Figma generates for it, with the
  colors, sizes and spacings of the top bar, the control bar and the sidebar.
  The asset links in the code are temporary.
- `tokens.json`: the paint styles of the file, dark and light, from
  Olmo Gutierrez' implementation (see ../README.md).
