# create_process(prog_name_p, [env_patch])

## Overview

`create_process` runs a process, `prog_name_p`, with optional env data patched in through `[env_patch]`;

This can be done to package multiple pieces of software into one, alongside allowing for multi-process software.

Source: [source.lua](source.lua)

## Arguments

### prog_name_p

The filepath to the file of which to create a process from.

This is typically a picotron cartridge or a `.lua` file.

### [env_path]

Optional argument

This allows you to patch environmental information to the process in the form of a table.

## Examples

This creates a process, running `app.p64` where `app.p64` prints the text that was fed into it.

When this process runs `env()`, it contains the argument `text`.

```lua
create_process("app.p64",{text="Hi!"})
```

Within `app.p64`:

```lua
print(env().text);
```

## Sandboxed Nature

Sandboxed apps can only create processes of:

* /system/apps/filenav.p64
* /system/apps/notebook.p64
* /system/util/open.lua
* /system/util/ls.lua
* files stored within the sandboxed app
* apps from `bbs://`

All apps run through this are also sandboxed

## Returns

This function returns the process id of the created process & an error string.

If the process created is a process that they cannot create > nil, "sandboxed process can not create_process()"

If the process creates more than 20 processes in a single minute > return nil, "sandboxed process can not create_process() more than 20 / minute"