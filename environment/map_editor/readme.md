# Map Editor

## Overview

Information from here is sourced from the [Picotron Manual](https://www.lexaloffle.com/dl/docs/picotron_manual.html)

The map editor is open on boot in the first workspace, defaulting to `/ram/cart/map/0.map`.

Like all of the standard tools, it runs in a tabbed workspace, where each tab is a separate process editing a single file.

## Sections

[Keybinds](keybinds/main.md)

## Usage

The map editor uses similar shortcuts to the [GFX Editor](/environment/gfx_editor/keybinds/main.md), with a few changes in meaning.

The F, V and R keys flip and rotate selected tiles, by setting special bits on those tiles that are also observed by the [`map()`](/picotron_api/functions/map/main.md) drawing function.

To select a single tile (e.g. to flip it), use the picker tool (crosshair icon) or hold S  for the section tool and use right mouse button. For larger selections, hold S and click and drag with either mouse button. When there is no selection (press ENTER to de-deselect), F, V, R can  also be used to set the bits on the curret item before it is placed.

Sprites can be selected from any files in gfx/ that start with a number and thus assigned @{Sprite Indexes}.  Use the left and right arrow buttons above the sprite navigator to switch between gfx files.

Sprite 0 means "empty", and that tile is not drawn. The default sprite 0 is a small white x to indicate that it is reserved with that special meaning. This can be disabled; see [`map()`](/picotron_api/functions/map/main.md).

## Map Layers

@{Map Files} can contain multiple layers which are managed at the top right using the add layer (`+`) button and the delete (skull icon) button. Currently only a single undo step is available when deleting layers, so be careful!

Layers can be re-ordered using the up and down arrow icon buttons, named using the pencil icon button, and hidden using the toggle button that looks like an eye.

Each layer can have its own size, and is drawn in the map editor centered. See the @Map api for examples of loading and drawing multiple map files and layers.

## Tile Sizes

A global tile size is used for all layers of a map file, taken from the size of sprite 0. The width and height do not need to match.

Sprites that do not match the global tile size are still drawn, but stretched to fill the target size using something equivalent to a [`sspr()`](/picotron_api/functions/sspr/main.md) call.