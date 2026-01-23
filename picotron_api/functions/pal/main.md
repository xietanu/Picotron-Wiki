# pal(color1, color2, [remapping])

## Overview

Swaps `color1` for `color2` for one of three palette remappings, determined by `remapping` (which defaults to 0 if not specified).

- Remapping 0: Draw palette - remaps the colors when drawn.
- Remapping 1: Indexed display palette - remaps the colors for the whole screen, from the next frame displayed.
- Remapping 2: RGB display palette - remaps the RGB values for the color index.

`pal()` resets the draw and indexed display palettes.

Source: [source.lua](source.lua)

## Arguments

### `color1`: number

Index of the color to remap.

### `color2`: number

Value to remap to.

Index of the color if `remapping` is 0 or 1, or an RGB value (e.g. `0xff0000` would be red) if `remapping` is 2.

### `remapping`

Which remapping to use. Defaults to 0.

## Examples

To draw a sprite with all the red pixels switched for blue, then set it back again for the next sprite

```lua
pal(8, 12)
spr(1, 64, 64) -- recolored
pal(8, 8)
spr(1, 128, 128) -- original colors
```

To change all of the red pixels displayed to be blue:

```lua
pal(8, 12, 1)
```

To change the RGB value of the red to be a pure, bright red:

```lua
pal(8, 0xff0000, 2)
```
