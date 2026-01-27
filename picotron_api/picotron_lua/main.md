# Picotron Lua

## Overview

This information is sourced from the [Picotron Manual](https://www.lexaloffle.com/dl/docs/picotron_manual.html)

Picotron uses a slightly extended version of Lua 5.4, and most of the standard Lua libraries are available. For more details, or to find out about Lua, see www.lua.org.

## A Quick Introduction to Lua

This section a primer for getting started with standard Lua syntax.

### Comments

```lua
-- use two dashes like this to write a comment
--[[ multi-line
comments ]]
```

To create nested multi-line comments, add a matching number of ='s between the opening and 
closing square brackets:

```lua
--[===[
--[[
this comment can appear inside another multi-line comment 
]]
]===]
```

### Types and assignment

Types in Lua are numbers, strings, booleans, tables, functions and nil:

```lua
num = 12/100
s = "this is a string"
b = false
t = {1,2,3}
f = function(a) print("a:"..a) end
n = nil
```

Numbers can be either doubles or 64-bit integers, and are converted automatically between the 
two when needed.

### Conditionals

A block of code can be executed when some condition is true, by using if {condition} then {code} end:

```lua
if (4 == 4) then print("equal") end
if (4 ~= 3) then print("not equal") end
if (4 <= 4) then print("less than or equal") end
if (4 > 3) then print("more than") end
```

Use "else" for code that should be executed when the condition is false:

```lua
if not b then
    print("b is false")
else
    print("b is not false")
end
```

"elseif" can be used when there is more than one conditional block:

```lua
if x == 0 then
    print("x is 0")
elseif x < 0 then
    print("x is negative")
else
    print("x is positive")
end
```

### Loops

Loop ranges are inclusive:

```lua
-- print 1,2,3,4,5
for x=1,5 do
    print(x)
end
```

The same with a while loop:

```lua
x = 1
while x <= 5 do
    print(x)
    x = x + 1
end
```

The default for loop step value is 1. To jump a different amount or to loop backwards:

```lua
for x = 1, 10, 3 do print(x) end   -- 1,4,7,10

for x = 5, 1, -2 do print(x) end   -- 5,3,1
```

### Functions and Local Variables

Variables declared as local are scoped to their containing block of code (for example, inside a function, for loop, or if then end statement).

```lua
y = 0
function plusone(x)
    local y = x
    y = y + 1
    return y
end
print(plusone(2)) -- 3
print(y)  -- still 0
```

Functions can take and return any number of values:

```lua
function swap(x, y)
    return y, x
end
a,b = swap(1,2)
?a -- 2
?b -- 1
```

### Lua Tables

In Lua, tables are a collection of key-value pairs where the key and value types can both be mixed. They can be used as arrays by indexing them with integers.

```lua
a={} -- create an empty table
a[1] = "blah"
a[2] = 42
a["foo"] = {1,2,3}
```

Arrays use 1-based indexing by default:

```lua
a = {11,12,13,14}
print(a[2]) -- 12
```

For a 0-based array, set the zeroth slot by providing an explicit index: (or use [Userdata](/picotron_api/userdata/readme.md)):

```lua
a = {[0]=10,11,12,13,14}
```

Tables with 1-based integer indexes are special though. The length of such a table can be found with the # operator, and Picotron uses such arrays to implement the [add](/picotron_api/functions/add/main.md), [del](/picotron_api/functions/del/main.md), [deli](/picotron_api/functions/deli/main.md), [all](/picotron_api/functions/all/main.md) and [foreach](/picotron_api/functions/foreach/main.md) functions.

```lua
print(#a)   -- 4
add(a, 15)
print(#a)   -- 5
```

Indexes that are strings can be written using dot notation

```lua
player = {}
player.x = 2 -- is equivalent to player["x"]
player.y = 3
```

## Picotron Shorthand

Picotron offers some shorthand forms following PICO-8's dialect of Lua, that are not standard Lua.

### Shorthand if / while statements

"if .. then  .. end" statements, and "while .. then .. end" can be written on a single line:

```lua
if (not b) i=1 j=2
```

Is equivalent to:

```lua
if not b then i=1 j=2 end
```

Note that brackets around the short-hand condition are required, unlike the expanded version.

### Shorthand Assignment Operators

Shorthand assignment operators can be constructed by appending a '=' to any binary operator, including arithmetic (+=, -= ..), bitwise (&=, |= ..) or the string concatenation operator (..=)

```lua
a += 2   -- equivalent to: a = a + 2
```

### Integer divide

Picotron accepts `\` as well as `//` for integer divide, which is equivalent to [`flr(x/y)`](/picotron_api/functions/flr/main.md):

```lua
print(5 / 2)  -- 2.5
print(5 // 2) -- 2 (standard Lua)
print(5 \ 2)  -- 2 (same as the PICO-8 operator)
```

### != operator

Not shorthand, but Picotron also accepts != instead of ~= for "not equal to"

```lua
print(1 != 2) -- true
```