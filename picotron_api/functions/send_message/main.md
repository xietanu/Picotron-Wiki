# send_message(proc_id, msg, [response])

## Overview

`send_message` allows you to communicate with other processes.

This is useful for communication between processes

Source: [source.lua](source.lua)

## Arguments

### proc_id

The process ID of which to send the message to

### msg

The message, a table, to send to the process `proc_id`.

A message must have the key `event`, being a string that is sent to the process as its event.

This can be any arbritrary string - handled by the process that receives it.

### [response]

Optional argument

By setting `[response]` to `true`, it causes the function to stall the entire program until it receives a response from the other process.

Note that blocking in this way can be quite slow - it is intended to be used in situations where it is acceptable to skip a frame or two while waiting for a reply.

When `[response]` is a function, the event handler of the receiving process can reply with another message that is handled by that function.

## Examples

> From the Picotron Manual

When reply is true, send_message blocks until the process responds with a reply. For example, paste the following in to terminal to set up a headless process that responds to "get_id" messages:

```lua
store("/ram/get_id.lua", [[
    id = 1
    function _update() end
    on_event("get_id", function() 
        id += 1
        return {id = id} 
    end)
]])
pid2 = create_process("/ram/get_id.lua")
```

A unique id can be fetched from this process with:

```lua
?send_message(pid2, {event = "get_id"}, true).id
```

The true argument for `[response]` causes the message to be blocking - waiting for the response from `pid2`, being the data including the `id` it requests.

## Sandboxed Nature

Sandboxed processes can send messages to:

* itself
* /system/
* wm

alongside sending certain events:

* "set_palette"
* "broadcast" *if* it has a contained event of `set_palette`

## Returns

This function returns nothing, unless you have a response, where it instead returns the response of the event.