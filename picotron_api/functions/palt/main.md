# palt([color], [is_transparent])

## Overview

Set the transparency for color index `color` to `is_transparent` (true makes it transparent).

By default, observed by `spr`, `sspr`, `map`, `tline3d`.

If `is_transparent` is not specified, `color` is treated as a bitfield which can be used to set the transparency of all 64 colors, where a 1 bit sets the color as transparency, and a 0 sets it as non-transparent.

If neither is specified, transparency is reset so all colors are opaque except for 0.

Source: [source.lua](source.lua)

## Arguments

### `color`: number

The color to set the transparency of, or a bitfield to set all colors at once.

### `is_transparent`: boolean

Whether color index `color` should be transparent (true) or not (false).

## Examples

Set red to transparent for just one sprite:

```lua
palt(8, true)
spr(1, 50, 10) -- red pixels won't be drawn
palt(8, false)
spr(1, 100, 10) -- red pixels will be drawn
```

Set colors 0, 1, and 4 to transparent, and the rest to opaque:

```lua
palt(0b1101)
```

