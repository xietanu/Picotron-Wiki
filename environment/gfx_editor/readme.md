# GFX Editor

## Overview

Information from here is sourced from the [Picotron Manual](https://www.lexaloffle.com/dl/docs/picotron_manual.html)

The second workspace is a sprite and general-purpose image editor. Each .gfx file contains up to 256 sprites,  and if the filename starts with a number (like "gfx/0.gfx"), they are automatically assigned @{Sprite Indexes} when the cartridge is run.

Don't forget to save your cartridge after drawing something

The default filenames all point to `/ram/cart` and isn't actually stored to disk until you use the [`save`](/system/details/utils/save/main.md) command (or [`ctrl-s`](/environment/save/main.md) to save the current cartridge)

## Sections

[Keybinds](keybinds/main.md)

[GFX Tools](text_editor/main.md)

## Multiple Sprite Selections

To select multiple sprites at once, hold shift and click and drag in the navigator. Resizing and modifying sprite flags apply to all sprites in that region.

Each sprite has its own undo stack. Operations that modify more than one sprite at once (paste multiple, batch resize) create a checkpoint in each individual undo stack, and can only be undone once ([ctrl-z](keybinds/main.md) as a group immediately after the operation.

## Importing Spritesheets

From the app menu (top left), choose "Spritesheet Importer" and either drag and drop a png file, or paste an image that was copied from PICO-8 or Picotron.

To select the 128x128 entire spritesheet in PICO-8, press CTRL-C twice.

There are a few manual options that can be adjusted: the size (in pixels) of each tile, the sprite index that the  imported sprites should start at, and "trim" removes that number of pixels from the right and bottom of each sprite (allowing the spritesheet to have a bit of empty space between each sprite).

Spritesheets are colour-fitted to the current display palette.

Once hitting "Slice and Dice", it is possible to undo just once. After that, undo can still be used on each sprite's separate undo stack.