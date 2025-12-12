# clip_to_parent

## Overview

Clips an element to the parent

Events are also not clipped.

Useful for UI elements that need to 'overhang' a parent window, for example.

## Values

Default value: true

Valid values: true, false

### If true

the element will be clipped to the size of the parent.

This also prevents events from triggering on the parts of the element outside the parent bounds.

### If false

the element will not be clipped to the size of the parent and can be positioned outside the parent.