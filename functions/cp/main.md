# cp(src_p, dest_p)

## Overview

`cp` copies the file or folder from `src_p` to the location `dest_p`.

If `dest_p` is a file, it overwrites the file.

Source: [source.lua](source.lua)

## Arguments

## src_p

The path to the source file/folder

## dest_p

Path to a folder/file to replace

## Returns

If src is nil > "could not resolve source path"
If dest is nil > "could not resolve destination path"
If using a protocol (e.g: `bbs://`) > "can not write to {protocol you attempted}://"

Other failures:
    fstat of the source fails > "could not read source location"
    copying a folder inside of itself > "can not copy inside self"
    copying `/` inside of itself > "can not copy /"

## Future

Ability to write to protocols