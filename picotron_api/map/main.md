# Map

## Overview

This information is sourced from the [Picotron Manual](https://www.lexaloffle.com/dl/docs/picotron_manual.html)

A map in Picotron is a 2d userdata of type i16. Each tile value uses 13 bits for the @{Sprite Indexes},  and 3 bits for orientation:

## Userdata Structure
```
0x00ff the sprite number within a .gfx file (0..255)
0x1f00 the gfx file number (0..31)
0x2000 flip the tile diagonally  -- not supported by tline3d()
0x4000 flip the tile horizontally
0x8000 flip the tile vertically
```

## Flipping bits

All tile flipping bits are observed by the map editor and [map()](/picotron_api/functions/map/main.md).

The default tile width and height are set to match sprite 0.

## Map Files

A map file (`foo.map`) is a table of layers, where each layer has a `.bmp` (the userdata for that layer) a `.name`, and some other values for the editor (`.pan_x`, `.zoom` etc). So, to access the userdata for a given layer of a map file:

```lua
layers = fetch("map/mountains.map") -- call once when e.g. loading a level
ud = layers[1].bmp -- grab the top layer's userdata
map(ud) -- draw that layer
print("the layer is "..ud:width().." tiles wide")
```

By default, The first layer of map/0.map is set as the current working map if PICO-8 style manipulation is preferred (see below). Map files can be alternatively be manually loaded, in which each layer can be manipulated as regular [Userdata](/picotron_api/userdata/readme.md) and passed to [map()](/picotron_api/functions/map/main.md) or [tline3d()](/picotron_api/functions/tline3d/main.md) as the first parameter.

```lua
layers = fetch("map/forest.map") -- call once when e.g. loading a level
map(layers[2].bmp)   -- draw a particular layer
?map:get(5,3) -- print the tile value at 5,3 
```

## Setting a Current Working Map

This is an optional PICO-8 compatibility feature

When only a single global map is needed, there is the option to set the "current working map" and use only PICO-8 style map functions [map](/picotron_api/functions/map/main.md), [mset](/picotron_api/functions/mset/main.md) and [mget](/picotron_api/functions/mget/main.md).

The current working map is taken to be whatever i16 userdata is [memmap()](/picotron_api/functions/memmap/main.md)'ed to `0x100000`. This happens automatically when a cartridge is run and `map/0.map` exists (the first layer is used).

```lua
mymap = fetch("forest.map")[2].bmp -- grab layer 2 from a map file
memmap(mymap, 0x100000)
map()  -- same as map(mymap)
?mget(2,2) -- same as mymap:get(2,2)
```