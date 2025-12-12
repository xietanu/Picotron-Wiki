# window([width,height],attribs)

## Overview

Create a window and/or set the window's attributes.

Source: [source.lua](source.lua)

## Arguments

### [width,height]

Proportions of the window

### attribs

Table of desired attributes of the window

Cannot overwrite `parent_pid`

#### width

width in pixels (not including the frame)

#### height

height in pixels

#### title

set a title displayed on the window's titlebar

#### pauseable

false to turn off the app menu that normally comes up with ENTER/START button

#### tabbed

true to open in a tabbed workspace (like the code editor)

#### has_frame

Default: true

Whether to have a frame around the window

#### moveable

Default: true

Whether to allow the window to be dragged

#### resizeable

Default: true
Whether to allow the window to be resized

#### wallpaper

acts as a wallpaper (z Defaults to -1000 in that case)

#### autoclose

close window when is no longer in focus or when press escape

#### z    

windows with higher z are drawn on top. Defaults to 0

#### cursor

0 for no cursor

1 for Default

userdata for a custom cursor

#### squashable

window resizes itself to stay within the desktop region

#### background_updates

allow _update() callbacks when parent window is not visible

#### background_draws

allow _draw() callbacks when parent window is not visible