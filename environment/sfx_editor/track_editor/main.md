# SFX Editor > Track Editor

## Overview

Information from here is sourced from the [Picotron Manual](https://www.lexaloffle.com/dl/docs/picotron_manual.html)

A single track (or "SFX") is a sequence of up to 64 notes that can be played by the [`sfx()`](/picotron_api/functions/sfx/main.md) function.

SFX can be be played slowly as part of a musical pattern, or more quickly to function as a sound effect.

## SFX Details

The SPD parameter determines how many ticks (~1/120ths of a second) to play each row for.

Each row of a track has a pitch (C,C#,D..), instrument, volume, effect, and effect parameter. Instrument and  volume are written in hexadecimal (instrument "1f" means 31 in decimal). Volume `0x40` (64) means 100% volume, but larger values can be used.

The pitch, instrument and volume can each be set to "none" (internally: `0xff`) by typing a dot ("."). This means that the channel state is not touched for that attribute, and the existing value carries over.

An instrument's playback state is reset (or "retriggered") each time the instrument index is set, and either the pitch or instrument changes. `When RETRIG` flag is set on the instrument (node 0), only the instrument attribute index to be set for it to retrigger, even if the pitch is the same as the previous row  (e.g. for a hihat played on every row at the same pitch).

## Pitch Entry

Notes can be entered using a workstation keyboard using a layout similar to a musical keyboard. For a QWERTY keyboard, the 12 notes C..B can be played with the following keys (the top row are the black keys):

```
  2   3  5   6   7
Q   W   E  R   T   Y   U
```

An additional octave is also available lower down on the keyboard:

```
  S   D  G   H   J
Z   X   C  V   B   N   M
```

Use these keys to preview an instrument, or to enter notes in the SFX or pattern editing modes.

Notes are played relative to the global octave (`OCT`) and volume (`VOL`) sliders at the top left.

Some instruments do not stop playing by themselves -- press `SPACE` in any editor mode to kill any active sound generation.

## Effects

Each effect command takes either a single 8-bit parameter or two 4-bit parameters.

PICO-8 effects 1..7 can be entered in the tracker using numbers, but are replaced with s, v, -, <, >, a and b respectively. The behaviour for those effects matches PICO-8 when the parameter is 0x00 (for example, a-00 uses pitches from the row's group of 4).

```
 s slide to pitch and volume (speed)
 v vibrato (speed, depth)
 - slide down from note (speed)
 + slide up from note (speed)
 > fade out (end_%, speed)
 a fast arp: 4 ticks (pitch0, pitch1)
 b slow arp: 8 ticks (pitch0, pitch1)
 n nimble arp: 2 ticks (pitch0, pitch1)
 o ornament (pitch0, ticks)
 t tremelo (speed, depth)
 w wibble (speed, depth) // v + t
 r retrigger (every n ticks)
 d delayed trigger (after n ticks)
 c cut (after n ticks)
 p set channel panning offset
 f fade to volume (speed)
 $ reserved for program use
```

The meaning of "speed" varies, but higher is faster except for 0 which means "fit to track speed". For  example, a vibrato at speed 0 will repeat exactly once per row, and a slide at speed 0 will reach its  destination exactly in one row.

Non-zero speeds are applied per-tick and are not relative to the track speed. A single +10 (slide up at speed 0x10)  command will rise one semitone every tick, and so playing at a slower track speed will cause the slide to reach a higher top pitch.

Arpeggio and ornament pitches are in number of semitones above the channel pitch. The following plays a c major triad (slow down the track to hear it more easily):

```
c 3 00 30 a47
```

Ornament pitches work the same way, but alternates between only two notes and uses the second parameter as a tick speed. When the ornament pitch offset is 0, silence is generated instead for those ticks. They can be used to implement things like trills, grace notes, swung accepts and other forms of articulation.

All of the arpeggio commands a,b,m,n,o have an uppercase counterpart (A,B,M,N,O) that behaves the same, except they are played downwards (the highest pitch is played first).

Slides and fades alter the channel's state; the altered values persist until they are modified by another command. They can be used even when there is are no pitch or volume values on the same row; in that case they continue slide towards the last pitch / volume row values.

The slide command can also be used to fade to a volume when there is one set in the same row:

```
c 3 00 30 ...  -- play c 3 with instrument 0x00 at volume 0x30, with no effect
c 5 00 .. s20  -- start sliding towards c 5 at a speed of 0x20
... .. .. s20  -- continue sliding towards c 5
... .. 10 s20  -- slide to volume 10 for one row (and continue pitch slide)
... .. .. ...  -- whatever pitch/vol is reached will continue playing
```