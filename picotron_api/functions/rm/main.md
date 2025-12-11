# rm(f0)

## Overview

`rm` deletes `f0`, a file or directory (including all of the directory's contents).

Attempting to delete `/desktop/host` just causes the Host OS to unmount, rather than deleting the folder and contents.

Source: [source.lua](source.lua)

## Arguments

### f0

The path to the file or directory to delete

## Returns

Returns something, unknown what it returns