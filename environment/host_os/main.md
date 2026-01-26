# Host OS

## Overview

The Host OS is the operating system that is running Picotron.

e.g: if you are on Windows:

* the host OS is your windows system
* the virtual OS is Picotron

## Virtual OS

The Host OS stores the Virtual OS (Picotron)

### Config Files

The configuration files for picotron are created here:

* Windows: `C:/Users/Yourname/AppData/Roaming/Picotron/picotron_config.txt`
* OSX:     `/Users/Yourname/Library/Application Support/Picotron/picotron_config.txt`
* Linux:   `~/.lexaloffle/Picotron/picotron_config.txt`

### Virtual Drive location

The virtual drive for picotron is found here:

* Windows: `C:/Users/Yourname/AppData/Roaming/Picotron/drive/`
* OSX:     `/Users/Yourname/Library/Application Support/Picotron/drive/`
* Linux:   `~/.lexaloffle/Picotron/drive/`

This can be edited in the config file.

### Interacting with the Host OS

Files from inside of Picotron can be told to open in the Host OS.
This is typically done from within the system filenav by right clicking a file and selecting `View in Host OS`.

The code equivalent of this is:

```lua
send_message(2,{event="open_host_path",path="path/to/open"})
```