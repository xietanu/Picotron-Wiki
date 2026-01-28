# SFX Editor > Pattern Editor

## Overview

Information from here is sourced from the [Picotron Manual](https://www.lexaloffle.com/dl/docs/picotron_manual.html)

A pattern is a group of up to 8 tracks that can be played with the @music() function.

Click on the toggle button for each track to activate it, and drag the value to select which SFX index to assign to it.

SFX items can also be dragged and dropped from the navigator on the left into the desired channel.

The toggle buttons at the top right of each pattern control playback flow, which is also observed by [`music()`](/picotron_api/functions/music/main.md):

```
loop0 (right arrow): loop back to this pattern
loop1 (left arrow):  loop back to loop0 after finishing this pattern
stop  (square):      stop playing after this pattern has completed
```

Tracks within the same pattern have different can lengths and play at different speeds. The duration of the pattern is taken to be the duration (`spd * length`) of the left-most, non-looping track.