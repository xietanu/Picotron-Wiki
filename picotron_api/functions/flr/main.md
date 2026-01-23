# flr(x)

## Overview

Floors `x`, rounding it down to next lowest integer.

e.g. 3.7 becomes 3, -4.1 becomes -5.

Source: [source.lua](source.lua)

## Arguments

### `x`: number

The value to floor.

## Returns

The floored value.

## Examples

By adding 0.5 before using `flr`, can be used to round to the nearest value.
e.g. Round the current CPU usage to the nearest whole percentage:

```lua
local cpu = flr(stat(1)*100+0.5)
```

