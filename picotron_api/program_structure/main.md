# Program Structure

## Overview

This information is sourced from the [Picotron Manual](https://www.lexaloffle.com/dl/docs/picotron_manual.html)

This goes over the structure of Picotron Cartridges.

## Optional functions for the cart-loop

A Picotron program can optionally provide 3 functions:

```lua
function _init()
-- called once just before the main loop
end

function _update()
-- called 60 times per second
end

function _draw()
-- called each time the window manager asks for a frame
-- (normally 60, 30 or 20 times per second)
end
```

## Running Programs in the background

A program that only contains `_update` (but no `_draw`) will continue to run in the background by default, but with a lower cpu priority.

When `_draw` is also defined (and the program has a window or fullscreen display), the `_draw` and `_update` functions are only called when the program is at least partially visible. This allows Picotron to keep many tabs and workspaces open without impacting performance. In this case, the `_update` and/or `_draw` functions can be manually set to run in the background with:

```lua
window{background_updates = true}
```

or:
```lua
window{background_draws=true}
```

respectively.