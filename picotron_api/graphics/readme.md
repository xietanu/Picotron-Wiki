# Graphics

## Overview

Information from here is sourced from the [Picotron Manual](https://www.lexaloffle.com/dl/docs/picotron_manual.html)

Graphics operations all respect the current [clip](/picotron_api/functions/clip/main.md) rectangle, [camera](/picotron_api/functions/camera/main.md) position, fill pattern [fillp()](/picotron_api/functions/fillp/main.md), draw [color](/picotron_api/functions/color/main.md), @{Colour Tables} and @Masks.

There are two categories of drawing operations: sprites ( [spr](/picotron_api/functions/spr/main.md), [sspr](/picotron_api/functions/sspr/main.md), [map](/picotron_api/functions/map/main.md), [tline3d](/picotron_api/functions/tline3d/main.md)) and shapes ( [pset](/picotron_api/functions/pset/main.md), [circ](/picotron_api/functions/circ/main.md), [rectfill](/picotron_api/functions/rectfill/main.md) ..). The default Colour Tables and MaskS state are set up so that sprites are drawn with colour 0 as transparent, while shapes draw colour 0 as opaque.

## Sprite Indexes

Each sprite in memory can be assigned an index between 0..8191 that is used to reference it from sprite and map drawing functions.

Default indexes are assigned on cartridge startup based on the names of files found in `gfx/`.

Each one that starts with an integer is assigned a block of 256 indexes based on that number.

For example:

```
gfx/0.gfx  0 ..     255
gfx/1_monsters.gfx  256 .. 511
gfx/2_blocks.gfx    512 .. 767
..
gfx/31_ending.gfx   7936 ..8191
```

Sprites can also be manually indexed and retrieved with [set_spr](/picotron_api/functions/set_spr/main.md) / [get_spr](/picotron_api/functions/get_spr/main.md).

## Colour Tables

Colour tables are applied by all graphics operations when each pixel is drawn. Each one is a 64 x 64 lookup table indexed by two colours:

1. the colour to be drawn (0..63)
2. the colour at the target pixel (0..63)

The entry at those two indexes is the output value that will be written to the draw target. 

For example, when drawing black (0) over on a red (8) pixel, the colour table entry for that combination might also be red  (in effect, making colour 0 transparent).

Additionally, one of four colour tables can be selected using the upper bits 0xc0 of either the draw colour or destination pixel. In the case of sprite functions ([spr](/picotron_api/functions/spr/main.md), [sspr](/picotron_api/functions/sspr/main.md), [map](/picotron_api/functions/map/main.md), [tline3d](/picotron_api/functions/tline3d/main.md), the fill pattern can also be used to switch between colour table 0 and 2 (or 1 and 3). The four colour tables live at `0x8000`, `0x9000`, `0xa000` and `0xb000`.

Using custom colour table data and selection bits allows for a variety of effects including overlapping shadows, fog,  tinting, additive blending, and per-pixel clipping. Functions like [palt](/picotron_api/functions/palt/main.md) and [pal](/picotron_api/functions/pal/main.md) also modify colour tables to  implement transparency and palette swapping.

To use colour tables with shapes, note that the default target_mask for shapes is `0x0`, so every table look up is equivalent to drawing on colour 0. To fix this, use:
```lua
poke(0x550b, 0x3f)
```

Colour tables and masks are quite low level and often can be ignored! For more details, see: [Picotron GFX Pipeline](https://www.lexaloffle.com/dl/docs/picotron_gfx_pipeline.html)

## Masks

When each pixel is drawn, three masks are also used to determine the output colour. The draw colour (or pixel colour in the case of a sprite) is first `AND`ed with the read mask. The colour of the pixel that will be overwritten is then `AND`ed by the target mask. The colour bits (`0x3f`) of the masked draw colour and target colour are then used as indexes into a colour table to get the output colour. Finally, the write mask determines which bits in the output colour will be written to the draw target.

```
0x5508  read mask
0x5509  write mask
0x550a  target mask for sprites
0x550b  target_mask for shapes
```

The default values are: `0x3f`, `0x3f`, `0x3f` and `0x00`. `0x3f` means that colour table selection bits are ignored (always use colour table 0), and the `0x00` for shapes means that the target pixel colour is also ignored, as all shape drawing functions ([rectfill](/picotron_api/functions/rectfill/main.md) etc) draw a solid colour by default.

The following program uses only the write mask to control which bits of the draw target are written. Each circle writes to 1 of the 5 bits: `0x1`, `0x2`, `0x4`, `0x8` and `0x10`. When they are all overlapping, all 5 bits are set giving colour 31.

```lua
function _draw()
    cls()
    for i=0,4 do
        -- draw to a single bitplane
        poke(0x5509, 1 << i) -- write mask
        r=60+cos(t()/4)*40
        x = 240+cos((t()+i)/5)*r
        y = 135+sin((t()+i)/5)*r
        circfill(x, y, 40, 1 << i)
    end
    poke(0x5509, 0x3f) -- reset to default
end
```

## Graphics CPU Costs

The CPU cost of graphics calls (and all other api calls / code) is taken from a single system-wide pool of 16,777,216 cycles per second, or around 280,000 cycles per frame at 60fps. After system overheads (roughly 10%), around 250,000 cycles can be used by a fullscreen program before the framerate drops to 30fps.

Use [`stat(7)`](/picotron_api/functions/stat/main.md) to check the current framerate, and [`stat(1)`](/picotron_api/functions/stat/main.md) at the end of `_draw()` to find out the current cpu usage; anything under 0.9 will normally maintain 60fps.

Disregarding the overhead of making each api call, graphics functions can normally fill at least 3 pixels per cycle, which is considerably faster than the equivalent Lua vm instructions that cost around 2 cycles each.

Graphics operations are faster still when the default read and target mask values (`0x3f`) are set, and in the case of sprite operations, when the fill pattern is 0. Under these conditions only a single colour table is referenced and so a specialised code path in the runtime can be used that is able to fill spans at 6 pixels per cycle.

An additional fast code path is available to shape operations when the target mask (@550b) is 0, which is the default value. In this case, there is no need for Picotron to perform per-pixel colour table lookups and the runtime can use 64-bit instructions to modify 8 pixels at a time. This is true even when fill patterns and arbitrary read/write masks are used. When drawing large regions that contain many 8-byte aligned segments, a fill rate of 24 pixels / cycle can be achieved.