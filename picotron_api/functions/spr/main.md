# spr(sprite,[x],[y],[flip_x],[flip_y])

## Overview

`sspr` draws a sprite, similar to [`spr()`](/functions/spr/main.md), but allows you to also resize the sprite.

This is scaling sprites, e.g: zoom

Source: [source.lua](source.lua)

## Arguments

### sprite

Sprite index from the spritesheet, or a `userdata u8` piece of data - this is what is drawn.

### x,y

The coordinates of where to draw the sprite

### [flip_x],[flip_y]

Flips the sprite on their respective axis

## Examples

Draw a sprite from sprite index 0 to position (0,0)
```lua
spr(0,0,0)
```

Draw a sprite from a `userdata u8` to position (0,0)
```lua
sp=--[[pod_type="gfx"]]unpod("b64:bHo0ALEAAAC4AQAA_gFweHUAQyBAQATw9jPwHDOwBQCvcDM3M-AUMzEzMAkACEuz8BSzBQCPcDNw8wxwM7AHAAGN8ABz_wxz8AQGADAAM-t3AAkFAO9wMzt-IPsMfjszMDM7fgkABo8_dz77BD53PgsAEz9_u34KABBf-gS7-gQIAAjvPxp_Nz67Pjd_PTMwMz0MAA6fcDN9frt_fTOwCAAEYPAAc7s_uwwBDwcAAFQM8wzwFAQAUPMM8P8D")

spr(sp,0,0)
```

## Returns

Unknown