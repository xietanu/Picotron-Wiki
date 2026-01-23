# t()

## Overview

Returns the number of seconds elapsed since the cartridge started.

NOTE: This is based on the number of times that `_update()` has been called, which means that calling it multiple times in the same frame will give the same result and that if your program drops below ~15fps, it will start to be inaccurate.

Source: [source.lua](source.lua)

## Returns

The number of seconds since the cartridge started.

