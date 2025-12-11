# printh(str)

## Overview

printh() allows for you to print text to the Host OS Terminal.

This allows for you to do more informative debugging of your program, alongside allowing stuff like logs in your program.

[Setting up a Host OS terminal for Picotron](/guides/host_os_terminal/main.md)

Source: [source.lua](source.lua)

## Arguments

### str

String to print

## Examples

Prints the CPU usage every time the frame updates
```lua
function _update()
    printh(stat(1)*100 .."% cpu usage")
end
```

## Returns

Unknown