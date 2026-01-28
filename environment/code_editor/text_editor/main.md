# Code Editor > Text Editor

## Overview

Information from here is sourced from the [Picotron Manual](https://www.lexaloffle.com/dl/docs/picotron_manual.html)

This goes over the details of the text editor.

## Basics

This acts as a typical coding IDE - allowing you to code with syntax highlighting built in.

You can make use of the [keybinds](/environment/code_editor/keybinds/main.md) within the text editor, e.g: `CTRL+B` to comment a line.

## Nested Images

The code editor can render gfx pod snippets (e.g. copied from the gfx editor) embedded in the code. See /system/demos/carpet.p64 for an example of a diagram pasted into the source code.

Those snippets contain a header string using block comments `--[[pod_type=gfx]]`, so can not appear inside the same style of block comments. Instead, use a different block comment form; Lua allows nesting comments by including some matching number of ='s between the square brackets. e.g. [=[...]=]  or  [==[...]==]

```lua
--[==[
a picture:
--[[pod_type="gfx"]]unpod("b64:bHo0AC4AAABGAAAA-wNweHUAQyAQEAQQLFAsIEwwTBAEAAUR3AIAUxwBfAEcBgCg3CBMEUxAPBE8IA==")
]==]
```