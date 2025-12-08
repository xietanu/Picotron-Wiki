# mv(src_p, dest_p)

## Overview

`mv` moves the file or folder from `src_p` to `dest_p`.

Source: [source.lua](source.lua)

## Arguments

## src_p

The path to the source file/folder

## dest_p

Path to a folder to put the source file/folder into

## Returns

If src is nil > "could not resolve source path"
If dest is nil > "could not resolve destination path"
If using a protocol (e.g: `bbs://`) > "can not write to {protocol you attempted}://"

More returns are for other failures, unknown.

## Future

Ability to write to protocols