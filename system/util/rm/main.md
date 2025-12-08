# rm filename

## Overview

`rm` deletes a file or directory (including all of the directory's contents).

Attempting to delete `/desktop/host` just causes the Host OS to unmount, rather than deleting the folder and contents.

Source: [source.lua](source.lua)

## filename

The file or folder to delete

## Possible Future

Taken from comments in zep's code
Could be incorrect as zep copy pasted from `cp` command, but didn't rectify the name

```
--[[
	cp src dest

	resulting file should be idential to src (can't just fetch and then store)

	to do:
		-r recursive // rm() is currently recursive by default though
		how to do interactive copying? (prompt for overwrite)
]]
```

## [options]

### `-r`

Recursive remove

Unsure of how to handle overwriting files.