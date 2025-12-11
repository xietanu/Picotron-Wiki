# pid()

## Overview

`pid` returns the process id of the process calling it.

This is useful for communication between processes

Source: [source.lua](source.lua)

## Usage Example

Using the filenav with the intention to save a file.

```lua
create_process("/system/apps/filenav.p64", {
    open_with = pid(), --shows the id of the process that opened it
    intention = "save_file_as",
    path="/desktop/",
    use_ext="spr",
    window_attribs = {
        workspace="current",
        autoclose=true
    }
})
```

## Returns

The process ID