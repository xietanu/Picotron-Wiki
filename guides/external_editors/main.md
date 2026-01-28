# Using External Editors

## Overview

This guide is sourced from the [Picotron Manual](https://www.lexaloffle.com/dl/docs/picotron_manual.html).

## Simple Include

This goes over using external editors for Picotron.

The simplest way to use a text editor outside of Picotron to edit a cartridge's `.lua` files is to copy them into the  cartridge every time it is run, and then to [`include()`](/picotron_api/functions/include/main.md) them. For example, at the top of `main.lua`:

```lua
-- main.lua in the cart's root folder --
cp("/myproj/src", ".") -- comment this line out before releasing
include("src/draw.lua") -- a copy of the file that is in the same folder as the cartridge
```

`src/` is a regular folder on host that can be opened with the folder command and populated with `.lua` files using any text editor.

An advantage of this approach is that the cartridge remains self-contained, and if the first line is accidentally left in it will still run fine from the bbs (the [`cp()`](/picotron_api/functions/cp/main.md) will just silently fail while running sandboxed).

As a general rule, released Picotron cartridges should be self-contained and not depend on anything except for `/system`.

## Direct Includes

A slightly riskier alternative is to include `.lua` files directly from outside of the cartridge during development,  in which case care should be taken when releasing it to copy them somewhere inside the cart, and to adjust the include  path accordingly:

```lua
-- main.lua in the cart's root folder --
cd("/myproj")  -- comment before releasing (to start in the cart's path)
include("src/draw.lua")-- /myproj/src/draw.lua during development
include("src/monster.lua") -- /myproj/src/monster.lua
```

In that case, manually copy the source files before releasing. From terminal:

```
> cp -f /myproj/src /ram/cart/src
> save
```

When a cartridge is run, the present working directory for that process always starts in the root of the cart. To record that path, use

```lua
cart_root = pwd()
```

before [`cd("/myproj")`](/picotron_api/functions/cd/main.md), for example to load some `.map` files later in the program that are bundled inside the cart:

```lua
m = fetch(cart_root.."/map/forest.map")
```

## Editing .p64 Files Directly

A third approach is to edit the .p64 file directly with a text editor. 

From 0.2.1c, [CTRL-R](/environment/reload/main.md) looks for external changes in the cartridge file and copies only the files that have changed (so as to not clobber other files that were edited inside the picotron editors). To check which files inside the currently loaded cartridges have changed in the `.p64` file on disk, use the [`info`](/system/details/util/main.md) command.

When editing a `.p64` file directly, the binary data files (`.pogfx` etc) are all stored at the end, and should be left unmodified so that the cartridge format remains valid.