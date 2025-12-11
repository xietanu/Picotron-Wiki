# camera(x,y)

## Overview

camera() allows for you to set the relative 0,0 of all graphical operations.

Source: [source.lua](source.lua)

## Arguments

### x

x coordinate to set

### y

y coordinate to set

## Examples

Sets a player object to be in the middle of the screen
```lua

--player object
player={
    x=0,
    y=0
}

--set the player to be in the middle of the screen

screen={
    width=480,
    height=270
}

function _update()
    camera={
        x=player.x-(screen.width/2),
        y=player.y-(screen.height/2),
    }

    camera(x,y)
end
```

This can be paired with `mid()` to clamp it to the viewable area, e.g: the map.

## Returns

Returns the previous camera's x,y positions.