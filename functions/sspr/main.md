# sspr(sprite,[x],[y],[flip_x],[flip_y])

## Overview

`sspr` draws a sprite, similar to [`spr()`](/functions/spr/main.md), but allows you to also resize the sprite.

This is scaling sprites, e.g: zoom

Source: [source.lua](source.lua)

## Arguments

### sprite

Sprite index from the spritesheet, or a `userdata u8` piece of data - this is what is drawn.

### x,y

The coordinates of what is treated as the top left of `sprite`, allowing you to add offsets

### sw,sh

The width & height of `sprite` - allows you to crop the sprite.

### dx,dy

Where you want the sprite to be drawn on the screen

### [dw],[dh]

Optional, defaults to the proportions of the sprite

The new width & height of `sprite`.

`sprite` will be drawn rescaled to match the proportions of `[dx],[dy]`.

### [flip_x],[flip_y]

Flips the sprite on their respective axis

## Examples

```lua
local mapUD=userdata("u8",480,270)

set_draw_target(mapUD) --all graphical operations now go to the map userdata
map() --draw map
set_draw_target() --return graphical operations to the window/screen

--mapwidth,mapheight is the proportions of the map
--x,y is where to draw the map

sspr(mapUD,0,0,mapwidth,mapheight,x,y,mapwidth*2,mapheight*2)
```

## Returns

Unknown