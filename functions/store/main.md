# store(location, obj, [metadata])

## Overview

`store` allows you to store files, typically used for save files by storing tables in the `pod` file format.

Source: [source.lua](source.lua)

## Arguments

### location

The location you want to store a file at, e.g: `/appdata/mypod.pod`

### obj

The file data, e.g: a table for a `.pod` file.

### [metadata]

Optional metadata of the file, e.g: `{mymetadatavalue="grapes"}`

## Returns

This function does not return anything