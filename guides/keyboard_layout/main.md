# Keyboard Layout

## Overview

This guide is sourced from the [Picotron Manual](https://www.lexaloffle.com/dl/docs/picotron_manual.html).

This goes over how keyboard inputs are handled, and changing them.

## Input

Text input (using @peektext() / @readtext()) defaults to the host OS keyboard layout / text entry method.

Key states used for things like CTRL-key shortcuts (e.g. [key("ctrl")](/picotron_api/functions/key/main.md) and [keyp("c")](/picotron_api/functions/keyp/main.md)) are also mapped to the host OS keyboard layout by default.

## Configuring keycodes

The keyboard layout can be further configured by creating a file called `/appdata/system/keycodes.pod` which assigns each keyname to a new scancode. The raw names of keys (same as US layout) can alternatively be used on the RHS of each assignment, as shown in this example that patches a US layout with AZERTY mappings:

```lua
store("/appdata/system/keycodes.pod", {a="q",z="w",q="a",w="z",m=";",[";"]=",",[","]="m"})
```

You probably do not need need to do this! The default layout should work in most cases. 

Raw scancodes themselves can also be remapped in a similar way using /appdata/system/scancodes.pod, but is also normally not needed. The raw mapping is used in situations where the physical location  of the key matters, such as the piano-like keyboard layout in the tracker. See /system/lib/events.lua  for more details.