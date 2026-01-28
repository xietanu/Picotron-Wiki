# SFX Editor > Instrument Editor

## Overview

Information from here is sourced from the [Picotron Manual](https://www.lexaloffle.com/dl/docs/picotron_manual.html)

An instrument is a mini-synthesizer that generates sound each time a note is played. It is made from a tree of up to 8 nodes, each of which either generates, modifies or mixes an audio signal.

For example, a bass pluck instrument might have a white noise OSC node that fades out rapidly, plus a saw wave OSC node that fades out more slowly.

The default instrument is a simple triangle wave. To adjust the waveform used, click and drag the "WAVE" knob. In many cases this is all that is needed, but the instrument editor can produce a variety of sounds given some experimentation. 
Alternatively, check the BBS for some instruments that you can copy and paste to get started!

## Instrument Structure

The root node at the top is used to control general attributes of the instrument. It has an instrument name field (up to 16 chars), and toggle boxes `RETRIG` (reset every time it is played), and `WIDE` (give child nodes separate stereo outputs).

To add a node, use one of the buttons on the top right of the parent:

```
+OSC: Add an oscillator (sound generator) to the parent.
+MOD: Modulate the parent signal using either frequency modulation or ring modulation.
+FX:  Modify the parent signal with a FILTER, ECHO, or SHAPE effect.
```

An instrument that has two oscillators, each with their own FX applied to it before sending to the mix might look like this:

```
ROOT
OSC
FX:FILTER
OSC
FX:ECHO
```

During playback, the tree is evaluated from leaves to root. In this case, first the FX nodes are each applied to their parents, and then the two `OSC`s are mixed together to produce the output signal for that instrument.

Sibling nodes (a group with the same parent) can be reordered using the up and down triangle buttons. When a node is moved, it brings  the whole sub-tree with it (e.g. if there is a filter attached to it, it will remain attached). Likewise, deleting a node will also delete all of its children.

### Node Parameters

The parameters for each node (`VOL`, `TUNE` etc) can be adjusted by clicking and dragging the corresponding knob. Each knob has two values that define a range used by @Envelopes; use the left and right mouse button to adjust the upper and lower bounds, and the  range between them will light up as a pink arc inside the knob.

### Parameter Operators

Parameters can be evaluated relative to their parents. For example, a node might use a tuning one octave higher than its parent, in which case the `TUNE` will be "+ 12". The operator can be changed by clicking to cycle through the available operators for that knob: + means add, * means multiply by parent.

### Parameter Multipliers

Below the numeric value of each knob there is a hidden multiplier button. Click it to cycle between *4, /4 and none. This can be used to alter the scale of that knobs's values. For example, using *4 on the `BEND` knob will give a range of -/+ 1 tone instead of -/+ 1/2 semitone. There are more extreme multipliers available using CTRL-click (*16, *64), which can produce extremely noisy results in some cases.

The default parameter space available in the instrument designer (without large multipliers) shouldn't produce anything too harsh, but it is still possible to produce sounds that will damage your eardrums especially over long periods of time. Please  consider taking off your headphones and/or turning down the volume when experimenting with volatile sounds!

### Wide Instruments

By default, instruments are rendered to a mono buffer that is finally split and mixed to each stereo channel  based on panning position. To get stereo separation of voices within an instrument, `WIDE` mode can be used. It is a toggle button in the root node at the top of the instrument editor.

When `WIDE` mode is enabled, `OSC` nodes that are children of `ROOT` node have their own stereo buffers and panning position. `FX` nodes that are attached to `ROOT` are also split into 2 separate nodes during playback: one to handle each channel.

This can give a much richer sound and movement between channels, at the cost of such FX nodes costing double towards the channel maximum (8) and global maxmimum (64).

## Instrument Nodes

### OSC

There is only one type of oscillator (OSC), which reads data from a table of waveforms (a "wavetable"),  where each entry in the table stores a short looping waveform. Common waveforms such as sine wave  and square wave are all implemented in this way rather than having special dedicated oscillator types.

```
VOL    volume of a node's output
PAN    panning position
TUNE   pitch in semitones (48 is middle C)
BEND   fine pitch control (-,+ 1/2 semitone)
WAVE   position in wavetable. e.g. sin -> tri -> saw
PHASE  offset of wave sample
```

### Generating Noise

Noise is also implemented as a wavetable containing a single entry of a random sample of noise. Every process starts with 64k of random numbers at 0xf78000 that is used to form `WT-1`. Click the wavetable index (`WT-0`) in the oscilloscope to cycle through the 4 wavetables. `WT-2` and `WT-3` are unused by default.

At higher pitches, the fact that the noise is a repeating loop is audible. A cheap way to add more variation is to set the BEND knob's range to `-/+` maximum and then assign an envelope to it. An @LFO (freq:~40) or @DATA envelope (LP1:16, LERP:ON, scribble some noisey data points) both work well.

### FM MOD

A frequency modulator can be added to any oscillator. This produces a signal in the same way as a regular oscillator, but instead of sending the result to the mix, it is used to rapidly alter the  pitch of its parent OSC.

For example, a sine wave that is modulating its parent `OSC` at a low frequency will sound like vibrato (quickly bending the pitch up and down by 1/4 of a semitone or so). The volume of the `FM MOD` signal determines the maximum alteration of pitch in the parent.

As the modulating frequency (the `TUNE` of the `FM:MOD`) increases, the changes in pitch of the parent `OSC` are too fast to hear and are instead perceived as changes in timbre, or the "colour" of the sound.

### RING MOD

Similar to `FM`, but instead of modulating frequency, `RING MOD` modulates amplitude: the result of this oscillator is multiplied by its parent. At low frequencies, this is perceived as fluctuation in the parent's volume and gives a temelo-like effect.

The name "ring" comes from the original implementation in analogue circuits, which uses a ring of diodes.

### FILTER FX

The filter FX node can be used to filter low or high frequencies, or used in combination to keep only mid-range frequencies. Both LOW and HIGH knobs do nothing at 0, and remove all frequencies when set to maximum.

```
LOW    Low pass filter
HIGH   High pass filter
RES    Resonance for the LPF
```

### ECHO FX

Copy the signal back over itself from some time in the past, producing an echo effect. At very short DELAY values this can also be used to modify the timbre, giving a string or wind instrument feeling. At reasonably short delays (and layered with a second echo node) it can be used to approximate reverb.

```
DELAY  How far back to copy from; max is around 3/4 of a second
VOL    The relative volume of the duplicated siginal. 255 means no decay at all (!)
```

A global maximum of 16 echo nodes can be active at any one time. Echo only applies while the instrument is active; swtiching to a different instrument on a given channel resets the echo buffer.

### SHAPE FX

Modify the shape of the signal by running the amplitude through a gain function. This can be used to control clipping, or to produce distortion when a low `CUT` (and high `MIX`) value is used. `CUT` is an absolute value, so the response of the shape node is sensitive to the volume of the input signal.

```
GAIN   Multiply the amplitude
ELBOW  Controls the gradient above CUT. 64 means hard clip. > 64 for foldback!
CUT    The amplitude threshold above which shaping should take effect
MIX    Level of output back into the mix (64 == 1.0)
```

## Envelopes

Envelopes (on the right of the instrument designer) can be used to alter the value of a node parameter over time. For example, an oscillator might start out producing a triangle wave and then soften into a sine wave over 1 second. This is achieved by setting an upper and lower value for the `WAVE` knob, and then assigning an evelope  that moves the parameter within that range over time.

To assign an envelope to a particular node parameter, drag the "ENV-n" label and drop it onto 
the knob. Once an envelope has been assigned, it will show up as a blue number on the right of 
the knob's numeric field.  Click again remove it, or right click it to toggle "continue" mode 
(three little dots) which means the envelope  is not reset each time the instrument is 
triggered.

When an envelope is evaluated, it takes the time in ticks from when the instrument started 
playing (or when it was retriggered), and returns a value from 0 to 1.0 which is then mapped to 
the knob's range of values.

Click on the type to cycle through the three types:

### ADSR

ADSR (Attack Decay Sustain Release) envelopes are a common way to describe the change in volume in response to a note being played, held and released.

When the note is played, the envelope ramps up from 0 to maximum and then falls back down to a "sustain" level which is used until the note is released, at which point it falls back down to 0.

```
............................. 255  knob max
       /\
      /  \
     /    \______     ....... Ssustain level
    /            \
   /              \
../................\......... 0knob min
 
  |-----|--||--|
     A    D   R 
```

```
Attack:  How long to reach maximum. Larger values mean fade in slowly.
Decay:   How long to fall back down to sustain level
Sustain: Stay on this value while the note is held
Release: How long to fall down to 0 from current value after release
```

For a linear fade in over 8 ticks, use: 8 0 255 0

For a linear fade out over 8 ticks: 0 8 0 0

The duration values are not linear. 0..8 maps to 0..8 ticks, but after that the actual durations start jumping up faster. 128 means around 5.5 seconds and 255 means around 23 seconds.

### LFO

Low frequency oscillator. Returns values from a sine wave with a given phase and frequency.

```
freq:  duration to repeat // 0 == track speed
phase: phase offset
```

### DATA

A custom envelope shape defined by 16 values. Indexes that are out of range return 0.

```
LERP: lerp smoothly between values instead of jumping
RND:  choose a random starting point between 0 and T0 (tick 0 .. T0*SPD-1)
SPD:  duration of each index // 0 == track speed
LP0:  loop back to this index (0..)
LP1:  loop back to LP0 just before reaching this index when note is held
T0:   starting index (when RND is not checked)
```

These attributes that control playback of data envelopes are also available to ADSR and LFO, accessible via the fold-out button that looks like three grey dots.

### Random Values

This is not an envelope, but works in a similar way. Right clicking on an envelope button (to the right of the knob's numeric field) when no envelope is assigned toggles random mode. When this mode is active, a pink R is shown in that spot, and a random value within the knob's range is used every time the instrument is triggered. This can be used to produce chaotic unexpected sounds that change wildly on every playthrough, or subtle variation to things like drum hits and plucks for a more natural sound.