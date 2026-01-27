# Creating a Cartridge

## Overview

This guide is sourced from the [Picotron Manual](https://www.lexaloffle.com/dl/docs/picotron_manual.html).

Picotron is a cartridge-orientated workstation. A cartridge is like an application bundle, or a project folder: it is a collection of Lua source code files, graphics, audio and any other data files the cartridge needs to run. The "present working cartridge" is always in a RAM folder named /ram/cart.

## The Code Editor

Click on the code editor workspace at top right, which looks like this: ()

Paste in a program (select here, CTRL-C, and then CTRL-V inside Picotron)

```lua
function _init()
    bunny =
--[[pod_type="gfx"]]unpod("b64:bHo0AEIAAABZAAAA-wpweHUAQyAQEAQgF1AXQDcwNzAHHxcHMAceBAAHc7cwFwFnAQcGAPAJZx8OJ0CXcF8dkFeQFy4HkBcuB5AXEBdA")
    x = 232
    y = 127
end

function _draw()
    cls(3)   -- clear the screen to colour 3 (green)
    rrectfill(x+2,y+15,12,4,1,19) -- draw a 12x4 px shadow with colour 19 (dark green)
    spr(bunny, x, y + (x/8%2), hflip) -- draw bunny; (x/8%2) is for hopping motion
end

function _update()
    if (btn(0)) x -= 2 hflip = true
    if (btn(1)) x += 2 hflip = false
    if (btn(2)) y -= 2
    if (btn(3)) y += 2
end
```

## Running the program
Now, press [CTRL-R](/environment/reload/main.md) to run it. CTRL-R runs whatever is in /ram/cart, and the entry point in the cartridge is always main.lua (the file you were editing).

After hopping around with the cursor keys, press [ESCAPE](/environment/workspaces/main.md) to halt the program and then  ESCAPE  once more to get back to the code editor.

### Cartridge loop

There is a lot going on here! The `_init()` function is always called once when the program starts, and here it creates an image stored as text (a "pod") and sets  the bunny's initial x,y position.

`_draw()` is called whenever a frame is drawn (at 60fps or 30fps if there isn't enough available cpu). There are some comments in the `_draw` function that explain what is happening; everything after `--` on each line is not part of the program.

`_update()` is always called at 60fps, so is a good place to put code that updates the world at a consistent speed. In this example, it looks for button presses [`btn()`](/picotron_api/functions/btn/main.md) to control the bunny's position.

Each line of the program is run in order. Try swapping the `rrectfill` and `spr` lines to draw the shadow after drawing the bunny, to see what happens. Also, try removing the `cls(3)` and running the program again to see why it is important!

## Adding Graphics

Normally graphics are stored in `.gfx` files included in the cartridge as `gfx/*.gfx`

Lets get rid of the "bunny" variable and use the sprite editor instead. Click on the second workspace, which already has `gfx/0.gfx` open by default, and scribble something.

Now, instead of drawing the "bunny" image, the index of the new sprite can be used instead:

```lua
spr(1, x, y, hflip) -- hflip controls horizontal flipping
```

Hit [CTRL-R](/environment/reload/main.md) to run the cartridge, and the new sprite should be visible.

## Adding a map

### Map Editor

The [Map Editor](/environment/map_editor/main.md) works the same way: `map/0.map` is loaded by default, and uses the sprites in  0.gfx. First, draw some tiles in the sprite editor (e.g. a flower or plant). Next, click on the map  workspace at the top right (next to the gfx workspace). The new tiles can now be placed in the map.  Hold down SPACE and click and drag to pan around.

### Drawing the map

Finally, the map can be drawn inside the _draw callback using [`map()`](/picotron_api/functions/map/main.md). Add it after the `cls(3)`:

```lua
cls(3)
map()
```

To adjust the draw position to keep the player centered, try using [`camera()`](/picotron_api/functions/camera/main.md) at the start of `_draw()`:

```lua
camera(x - 240, y - 135)
```

To create more complex worlds with multiple map files and layers and sprite banks, see the [Map Editor](/environment/map_editor/main.md), @Map api and @{Sprite Indexes}.

## Adding sound and music

To create a sound effect, open the [SFX workspace](/environment/sfx_editor/main.md) (the musical notes icon at the top right) and scribble in the PITCH area. Press SPACE to play and once again to stop the current sfx.

The default speed ("SPD") is 16, which is good for playing tunes, but try something faster (1 ~ 4 ticks per row) for creating  sound effects. Adjust the SPD value (at the top right) by clicking and dragging it or by using the mousewheel while hovering over the value.

The new sound effect can now be played wile the cart is running using the [`sfx()`](/picotron_api/functions/sfx/main.md) function. Try the following at the end of `_update` to  play the sound when the X button is pressed:

```lua
if (btnp(5)) sfx(0)
```

To load and play a separate `.sfx` file as music, see [`music()`](/environment/music/main.md) for an example.

## Adding Code Tabs

Multiple code tabs can be created by making a lua file for each one. Click on the [+] tab 
button near the top and type in a name for the new file (a `.lua` extension will be added 
automatically if needed), and then include them at the top of your  main.lua program:

```lua
include "title.lua"
include "monster.lua"
include "math.lua"
```

The filename is relative to the present working directory, which starts as the directory a 
program is run from (e.g. `/ram/cart`).

## Saving a Cartridge

To save a cartridge to disk, open a terminal from the picotron menu (top left), and type:

```
save mycart.p64
```

(or just `save mycart` ~ the `.p64` extension will be added automatically)

The save command simply copies the contents of `/ram/cart` to `mycart.p64`.

Once a cartridge has been saved, the filename is set as the "present working cartridge", and 
subsequent saves can be issued with the shortcut: [CTRL-S](/environments/save/main.md). To get information about the current cartridge, type [info](/system/details/util/info/main.md) at the terminal prompt.

When editing code and graphics files inside a cartridge, those individual files are "auto-saved" to `/ram/cart` so that [CTRL-R](/environments/reload/main.md) will run the current version; there's no need to save before each run to sync changes.

When using an editor to edit a file that is outside `/ram/cart` (e.g. `/desktop/todo.txt`), [CTRL-S](/environments/save/main.md) saves only that individual file. Otherwise, [CTRL-S](/environments/save/main.md) always saves the whole cartridge.
