# mkdir(p)

## Overview

`mkdir` creates a new directory (empty folder) at the path `p`

This does not support protocols (e.g: bbs://)

Source: [source.lua](source.lua)

## Arguments

### p

The path for the new directory

## Returns

This function returns an error in the form of a string if the function fails.
Otherwise, returns nil

## Future

Ability to write to protocols