# Terminal Commands

## Overview

This guide is sourced from the [Picotron Manual](https://www.lexaloffle.com/dl/docs/picotron_manual.html).

This displays example usage of commands you can use in the terminal.

Note that a "directory" is a folder.

## Commands

### `ls`
List the current directory

### `cd foo`
change directory (e.g. `cd /desktop`)

### `mkdir foo`
create a directory 

### `folder`
open the current directory in your Host OS

### `open .`
open the current directory in filenav

### `open fn`
open a file with an associated editor

### `rm filename`
remove a file or directory (be careful!)

### `cp f0 f1`
copy file / directory from f0 to f1

### `mv f0 f1`
move file / directory from f0 to f1

### `info`
information about the current cartridge

### `load cart`
load a cartridge into /ram/cart

### `save cart`
save a cartridge 

## Custom Commands

To create your own terminal commands, put `.p64` or `.lua` files in `/appdata/system/util`.

When a command is used from commandline (e.g. [`ls`](/system/details/util/ls/main.md)), terminal first looks for it in `/system/util` and `/system/apps`, before looking in `/appdata/system/util` and finally the current directory for a matching `.lua` or `.p64` file.

The present working directory when a program starts is the same directory as the program's entry point (e.g. where main.lua is, or where the stand-alone Lua file is). This is normally not desireable for commandline programs, which can instead change to the directory the command was issued from using env().path. For example:

```lua
cd(env().path)
print("args: "..pod(env().argv))
print("pwd: "..pwd())
```

Save it as `/appdata/system/util/foo.lua`, and then run it from anywhere by typing "foo".