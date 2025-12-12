# el:attach_scrollbars()

## Overview

Attaches a scrollbar to the element

assumes that self is a container element, where:
* child[1] is the element to be scrolled
* child[2] is the scrollbar

Source: [source.lua](source.lua)

## Example

```lua
g = create_gui()
my_container = g:attach(my_container_attribs)
my_container:attach(my_contents)
my_container:attach_scrollbars()
```

To allow mousewheel scrolling, you still need to process messages from contents as such:

```lua
function contents:mousewheel(msg)
    self.y += msg.wheel_y * 32 -- scroll speed is arbitrary
end
```

## Future

mousewheel event should propagate up to parent though (if not defined)

horizontal bar (or generalise to 2d)