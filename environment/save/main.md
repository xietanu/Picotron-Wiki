# Saving

## Overview

You can save the currently loaded cartridge or save the active file with `CTRL+S`.

## Saving rules

`CTRL+S` saves the currently loaded cartridge if the active file is located within `/ram/cart` (the current loaded cartridge).

Otherwise, `CTRL+S` saves the current file.

## Limitations

If you attempt to save to `/system`, the changes are only temporary and are lost on reboot.
This can be counteracted if you have a [persistent system](/system/persistence/main.md).

You cannot save to the loaded cart if it is not in your picotron drive, e.g: loaded from the bbs.