# Anywhen

## Overview

This information is sourced from the [Picotron Manual](https://www.lexaloffle.com/dl/docs/picotron_manual.html)

Anywhen is a tool for viewing the state of cartridges, files and folders at any point in time.

## Details

When a file is modified inside Picotron, the file system records a delta between the previous version on disk and the new version being written. This allows changes to be listed and viewed at exactly the moment they happened.

Past versions of a file are not stored inside the file itself, but in a separate read-only storage area outside of the Picotron drive.

Anywhen logging can be disabled in settings by un-checking the Anywhen checkbox in settings. While disabled, file changes will not be recorded (but past changes are still accessible).

Anywhen paths (that contain `/@/`) are not visible to sandboxed cartridges.

## Anywhen Paths

Paths on the local drive can be appened with "/@/" to access a list of days that the path changed (`yyyy-mm-dd`), and a version of that file or folder at each point in time (`hh:mm:ss.ext`). All times are in GMT.

For example, a cartridge sitting on the desktop that had changes saved in April and June might look like this:

```
> ls /desktop/mycart.p64/@
2025-04-19
2025-04-24
2025-06-11
```

Inside each `day` folder is a collection cartridges: one for each moment in time the cartridge was modified:

```
>ls /desktop/mycart.p64/@/2025-04-19
09:23:55.p64
11:40:23.p64
```

Each item can be run directly, loaded or explored as if it were a regular cartridge. The same works for separate files. For example, to view a text file as it was at a particular point in time:

```
> edit /desktop/todo.txt/@/2025-01-01/00:00:00.txt
```

Anywhen paths include `:` character to make times more readable, but `_` can be used instead. 
Local file paths do not support `:`, so `_` is used when e.g. copying a file from the past into the 
present:

```
> cp /desktop/todo.txt/@/2025-01-01/00:00:00.txt .
> ls
00_00_00.txt
```

Folders can also be viewed at any time. A "change" to the folder is marked when the folder was created or an item was added to it.

To view all version of `/desktop` in filenav:

```
> open /desktop/@
```

## Logging And Access Rules

Anywhen only stores changes made to files from within Picotron; it does not proactively look for changes made in external editors except when generating the first log file per day. 

It does not store any changes made to `/ram/`.

Changes made to paths that include ".bin" are never recored to save space (binary exports are very large compared with typical Picotron files, and normally do not need to be logged).

Anywhen paths are not available to sandboxed cartridges

## Anywhen Storage

The modification history is stored outside of the Picotron drive, and can be managed in the host OS if desired. The default storage location is in the same folder as `picotron_config.txt`: use "folder /" to open the drive in the Host OS, and go up one folder.

Change logs are organised by month, and it is safe to remove a month folder (e.g. "2024-09") if it is no longer needed. Doing so means that any changes made during that month will no longer be visible, but the rest of the history will work as normal.

Newer versions of Picotron (from 0.2.0i) store binary blobs in a shared folder called "anywhen/blob",  which is shared between all months to avoid redundancy and save space. These are currently not possible to be removed by month, but a tool to sweep "dangling blob references" will be available in the future.