# Default Apps

## Overview

This guide is sourced from the [Picotron Manual](https://www.lexaloffle.com/dl/docs/picotron_manual.html).

This guide goes over how default apps work in Picotron and how to change them.

## How default apps work

When opening a file via filenav or the open command, an application to open it with is selected based on the extension. 

To change or add the default application for an extension, use the [`default_app`](/system/details/util/default_app/main.md) command. The following will associate files ending with `.sparkle` with the program located at `/apps/tools/sparklepaint.p64`:

```
default_app sparkle /apps/tools/sparklepaint.p64
```

The table of associations is stored in: /appdata/system/default_apps.pod. Delete that file to reset to defaults, or reset a particular extension to default with:

```
default_app lua
```

### Using Sandboxed Tools

Although bbs:// carts always run sandboxed, they can be set as default apps with little practical difference.  They do not need to be "installed" locally, and are cached forever for offline use. For example, to use Strawberry Src as the default app for txt files:

```
default_app txt #strawberry_src
```

or

```
default_app txt bbs://strawberry_src.p64
```

BBS carts can still be used to access any file on the drive when there is clear intent: via the filenav file  chooser, when loading/saving carts, or when using the open command. In each of these cases, the sandoxed view of the file system is expanded to include the requested file(s). For more technical details, see @{File Sandboxing}.

The advantages of using BBS carts directly without unsandboxing them:

1. They do not need to be as trusted. BBS carts can do limited damage to your system *
2. The latest version is always used (when no version number is given)
3. They don't take any space on your picotron drive (but are cached for offline use).
4. Files authored with a BBS cart are automatically associated with that tool +

Editors for lua files are a special case; tools that edit e.g. `/ram/cart/main.lua` could maliciously inject arbitrary code that is then run unsandboxed. But the risk only extends to anything mounted inside the Picotron drive.

When a `bbs://` cartridge is used to create or edit a file, the location of that cartridge is stored in the file's metadata as `metadata.prog`. When a default app can not be found to open a file, `metadata.prog` is used instead when it is available.
