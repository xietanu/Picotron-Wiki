# Simple grid based game

This is a short guide designed to teach you to create a simple game on a grid.

## Step 1. Creating the sprites

To begin, you should draw the following sprites:

* a player
* a ground tile
* a solid tile

Do this through the GFX Editor in `gfx/0.gfx`, and have all sprites the same size (e.g: 16x16).

## Step 2. Creating the map

You will need the map that your player will be on, this can be done with the map editor at `map/0.map`.

Using the ground tiles and solid tiles, draw out the terrain.

## Step 3. Drawing the screen

In your `main.lua` is the main code for your cartridge. This is called when your cartridge is run, allowing you to import other `lua` files and create the basis of your game.

To create the main loop, you can create the `_init`, `_update` and `_draw` functions - these are called on startup, every frame, and when a draw is called (less frequent than `_update` if there's lag) respectively.

You will want to have a player variable, a table, and something to draw the player to the screen. Treat the player's positioning as fixed to the grid.

The `_init` function creates the player
```lua
function _init()
    player={
        x=2,
        y=2,
        sprite=0
    }
end
```

You can now access the player with stuff like `player.x`, `player.y` and `player.sprite`.

Your update loop can be ignored for now.

Your draw loop can draw the screen.

The screen will consist of the map and the sprite.

You can draw the map with [`map`](/functions/map/main.md) and draw the sprite with [`spr`](/functions/spr/main.md).

You will need to call `cls()` at the beginning of the draw function - this will clear the screen and avoid drawing ontop of the previous frame continuously.

```lua
function _draw()
    cls()
    map()
    spr(player.sprite,player.x*16,player.y*16)
end
```

By multiplying it by 16, it applies it to a grid where each tile is 16x16. Replace `16` with your custom size if you have a different proportion - this does not affect anything else.

By running this, you will now see the player at (2,2) but you cannot interact with the player.

## Step 4. Moving the player

### Basic movement

Using the `_update` loop, you can add movement to the player.

This can be done with the `btnp` function, which detects button presses every 4 frames.

Create your update loop as such
```lua
function _update()
    if (btnp(0)) then
        player.x-=1
    end
end
```

This will move the player left when you press left on the DPAD or analog joystick (left arrow key)

Adding the following adds the other directions.

```lua
function _update()
    if (btnp(0)) then
        player.x-=1
    end
    if (btnp(1)) then
        player.x+=1
    end
    if (btnp(2)) then
        player.y-=1
    end
    if (btnp(3)) then
        player.y+=1
    end
end
```

This allows you to have full movement control of the player.

If you run it now, it allows you to move along the grid for your game - though, it doesn't include collisions and stop you from leaving the map.

Within Picotron Lua, you can also make use of inline code to clean the functions as seen:
```lua
function _update()
    if (btnp(0)) player.x-=1
    if (btnp(1)) player.x+=1
    if (btnp(2)) player.y-=1
    if (btnp(3)) player.y+=1
end
```

### Collisions

You can add collisions using `mget` by checking if the tile the player wants to move to is a solid tile or not.

```lua
if (mget(nx,ny)==1)
```

You can set this up in the update loop by creating a temporary x,y position that checks the collision before setting the player's true position.

This craetes an x,y identical to the player's position at the start of the function.

```lua
function _update()
    local nx,ny=player.x,player.y
    ...
```

Now, instead of applying the movements to player.x,player.y, you apply it to nx,ny
```lua
function _update()
    local nx,ny=player.x,player.y
    if (btn(0)) nx-=1
    if (btn(1)) nx+=1
    if (btn(2)) ny-=1
    if (btn(3)) ny+=1
    ...
```

This can be continued with:

```lua
function _update()
    local nx,ny=player.x,player.y
    if (btn(0)) nx-=1
    if (btn(1)) nx+=1
    if (btn(2)) ny-=1
    if (btn(3)) ny+=1

    if (mget(nx,ny)==1) then
        player.x,player.y=nx,ny
    end
end
```

This treats tile `1` as a tile the player can walk ontop of & through.

If the tile that the player tries to enter is not tile `1`, it ignores the collision.

### Adding a tile system

You can upgrade the tile system (checking collisions) with tables.

Creating a lookup table with a table allows you to refer to this with the tile the player moves into.

Create a tile registry is as such:

```lua
walkableTiles={
    [1]=true
}
```

Using `[index]`, it allows you to write an index into it, with a `true` value indicating that it is walkable.

You do not need to add `[2]=false` or any other solid tile to this as such as it will default to being seen as false.

Checking the collision is now seen as such:

```lua
local tile=mget(nx,ny)

if (walkableTiles[tile]) then
    player.x,player.y=nx,ny
end
```

If `walkableTiles[tile]` is not set, this fails - indicating that it is solid.
If it is set, it indicates that it is walkable, and allows the player to walk through the tile.

This tile system can be continued for any arbritrary purpose, e.g: if you want another type of tile.

```lua
waterTiles={
    [3]=true
}
```

You can check this in the same way that you checked collisions before, using the `waterTiles` lookup table alongside the `walkableTiles` lookup table

## Step 5. Continue on

You now have a simple player controller and a simple game loop, you can build on top of this yourself (or with any following guides) to create a larger game!