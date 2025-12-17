# function stat(n,[...])

## Overview

Greatly helped by [@akd-io and @Maxine](https://github.com/akd-io/picotron/blob/ccb6d34d8594cd4c2d45930cf8723c241f5aa6e9/drive/projects/stat/stats.md?plain=1#L80)
Returns information about the system and can sometimes do actions such as garbage collection.

## Arguments

### n: `number`

The id for the information you want to fetch

### [...]: `arbritrary`

Arbritrary arguments, sometimes used in stat, e.g: with `stat(302,keycode)`

### Valid usage

Where the first number is `n` and any other arguments, if present, are `[...]`

`Unknown` signifies that it returns values, but what they mean is unknown.

@Astralsparv's [Picotron Logger Distribution](https://github.com/Astralsparv/Picotron-Logger-Distribution) will be updated to help document this, fed the arbritrary values seen in unknown stats and detecting any change in the stat per frame in hopes of finding a cause and reproducing it.

#### Stats
* 0 - memory usage (bytes), also triggers a garbage collection
* 1 - cpu usage (decimal)
* 2 - reserved
* 3 - raw memory usage (bytes), no garbage collection
* 5 - runtime, system version
     `runtime,system_version=stat(5)`
* 7 - operating fps (60, 30, 20, 15)
* 86 - epoch time
* 87 - timezone delta (seconds)
* 101 - web: player cart id (when playing a bbs cart; nil otherwise)
* 150 - web: window.location.href
* 151 - web: stat(150) up to the end of the window.location.pathname
* 152 - web: window.location.host
* 153 - web: window.location.hash
* 301 - total CPU usage
* 302, keycode - returns human readable name for the keycode, surface [SDL's GetKeyName](https://wiki.libsdl.org/SDL2/SDL_GetKeyName)
* 307 - 1.0 if current working path is `/system` (including if the cartridge is located in `/system/`)
* 308 - Unknown
* 309 - Unknown
* 310 - Unknown
* 311 - Unknown
* 312 - Unknown
* 313 - Unknown
* 314 - Pi as `3..1415926535898`
* 315 - Presence of `-x` CLI argument when running Picotron headless
* 316 - Path specified when running headless
* 317 - `3.0` when a binary or html export, `1.0` when running on the BBS web player, `0.0` otherwise
* 318 - `1.0` when a html export (including BBS web player), `0.0` otherwise
* 320 - `1.0` when recording a gif, `0.0` otherwise
* 321 - amount of frames that the active gif capture has, `0.0` otherwise
* 322 - `1.0` when you're actively capturing a gif, `0.0` otherwise
* 330 - `1.0` when Picotron's battery saver is active, `0.0` otherwise

where c is a channel, addr is an address, n is a node:
* 400+c,0 - `1.0` when a note is held, `0.0` otherwise
* 400+c,1 - channel instrument
* 400+c,2 - channel volume
* 400+c,3 - channel pan
* 400+c,4 - channel pitch
* 400+c,5 - channel bend
* 400+c,6 - channel effect
* 400+c,7 - channel effect_p
* 400+c,8 - channel tick length
* 400+c,9 - channel row
* 400+c,10 - channel row tick
* 400+c,11 - channel sfx tick
* 400+c,12 - channel sfx index, `-1` if no sfx playing
* 400+c,13 - channel last played sfx index
* 400+c,19,addr - stereo output of buffer (returns number of samples)
* 400+c,20+n,addr - mono output of buffer for a node (0..7)
* 464 - bitfield indicating which channels are playing (sfx)
* 465, addr - copy last mixer stereo output buffer output is written as int16's to addr. (returns number of samples written)
* 466 - which pattern is playing (-1 when no music is playing)
* 467 - index of the left-most non-looping music channel
* 985 - Unknown
* 987 - Unknown
* 988 - `1.0` if both left and right control keys are held, `0.0` otherwise

## Returns

The queried information from the stat, unique to `n`, see the valid stats above for information on specific stats.
