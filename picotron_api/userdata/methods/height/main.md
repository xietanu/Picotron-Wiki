# userdata:height(): height
## Overview
Gets the height of the userdata.

## Returns
### height: integer|nil
The number of rows in the userdata if the userdata is 2D, or nil if the userdata is 1D.

## Example
```lua
-- Be careful when reading the height of a userdata. If you always need a real value, default to 1.
for y = 0, (ud:height() or 1) - 1 do
	for x = 0, ud:width() - 1 do
		?ud:get(x, y)
	end
end
```