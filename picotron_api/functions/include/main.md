# include(filename)

## Overview

The `include` function allows you to attach scripting files to your program (`lua`).

If the source has a syntax error, it reports errors to the console, listing the syntax error and location
If the source file is not a text file, it notifies that it cannot include it.

Source: [source.lua](source.lua)

## Arguments

### filename

The relative or absolute path to the file.

## Examples

Example `module.lua` which returns a version number and creates two helper functions for drawing sprites.

```lua
function sprFlippedX(s,x,y)
    spr(s,x,y,true)
end

function sprFlippedY(s,x,y)
    spr(s,x,y,nil,true)
end

return "1.0"
```

Cartridge that includes this

```lua
local version=include("module.lua")
if (version != latestVersion){
    notify("module.lua is not the running the latest version.")
}

sprFlippedX(1,0,0)
```

This warns you if the version is not the latest version (e.g: taken from a webpage), then proceeds to draw sprite 1 at 0,0 using the helper function.

## Returns

Returns `func()`, so that the imported file can return something - this also runs the file with `func()`
256 file limit > `nil`
Can't fetch the file > `nil`

## Limitations

There is an arbritrary limit where only 256 of the same files can be included.