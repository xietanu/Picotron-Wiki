# foreach(table, func)

## Overview

Calls the function `func` on each item in `table` (that has a 1-based integer index).

Any items with keys instead of integer indexes will be ignored.

Each item will be passed as the first and only argument to `func`.

Source: [source.lua](source.lua)

## Arguments

### `table`: table

Table of items to pass.

### `func`: function

Function that should operate on the table's items.

## Examples

This acts as a simpler and shorter way of doing:

```lua
for item in all(table) do
    func(item)
end
```
Can be useful in updating or drawing a list of items/enemies/etc.

```lua
enemies = {enemy_a, enemy_b, enemy_c}

foreach(enemy, update_enemy)
```
