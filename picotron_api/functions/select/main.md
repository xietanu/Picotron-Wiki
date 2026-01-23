# select(index, ...)

## Overview

Returns all arguments at and after `index` from `...` (the arguments following `index`).

A negative number indexes from the end (e.g. -1 returns the last argument).

If `index` is the string "#", the total number of arguments is returned instead.

Source: [source.lua](source.lua)

## Arguments

### `index`

The index of the argument to return, or the string "#"

### `...`

Any number of arguments of any type.

## Returns

The `index`th argument from `...`, or the total number of arguments in `...` if `index` == "#".

## Examples

Select is useful to use with functions that can accept any number of arguments.

```lua
function example(...)
    print(select(1, ...)) -- prints the first argument
    print(select("#", ...)) -- prints the total number of arguments
end

function("a", "b", "c", "d")
-- Output:
-- a
-- 4
```
