--[[
    attach_scrollbars() // to do: horizontal bar (or generalise to 2d)

    assume that self is a container element, where 
        child[1] is the element to be scrolled
        child[2] is the scrollbar

    example:

    g = create_gui()
    my_container = g:attach(my_container_attribs)
    my_container:attach(my_contents)
    my_container:attach_scrollbars()

    to allow mousewheel scrolling, still need to process messages from contents:

        function contents:mousewheel(msg)
            self.y += msg.wheel_y * 32 -- scroll speed is arbitrary
        end

        ** to do: mousewheel event should propagate up to parent though (if not defined)
]]

function GuiElement:attach_scrollbars(attribs)

    --if no children, attach to parent! to do: standardise
    local container = self

    local bar_w = 8

    local attribs = attribs or {} 

    -- pick out only attributes relevant to scrollbar (autohide)
    -- caller could adjust them after though -- to do: perhaps should just spill everything in attribs as starting values
    local scrollbar = {
        x = 0, justify = "right",
        y = 0,
        width = bar_w,
        height = container.height,
        height_rel = 1.0,
        autohide = attribs.autohide,
        bar_y = 0,
        bar_h = 0,
        cursor = "grab",

        update = function(self, msg)
            local container = self.parent
            local contents  = container.child[1]
            local h0 = self.height
            local h1 = contents.height
            local bar_h = max(9, h0 / h1 * h0)\1  -- bar height; minimum 9 pixels
            local emp_h = h0 - bar_h - 1          -- empty height (-1 for 1px boundary at bottom)
            local max_y = max(0, contents.height - container.height)

            self.scroll_spd = max_y / emp_h
            if (max_y > 0) then
                self.bar_y = flr(- emp_h * contents.y / max_y)
                self.bar_h = bar_h
            else
                self.bar_y = 0
                self.bar_h = 0
            end

            if (self.autohide) then
                self.hidden = contents.height <= container.height
            end

            -- hack: match update height same frame 
            -- otherwise /almost/ works because gets squashed by virtue of height being relative to container, but a frame behind
            -- (doesn't work in some cases! to do: nicer way to solve this?)
            -- self.squash_to_clip = container.squash_to_clip 

            -- 0.1.1e: always clamp
            contents.x = mid(0, contents.x, container.width  - contents.width)
            contents.y = mid(0, contents.y, container.height - contents.height)

        end,
        
        draw = function(self, msg)
            local bgcol = 13
            local fgcol = 6

            rectfill(0, 0, self.width-1, self.height-1, bgcol | (fgcol << 8))
            if (self.bar_h > 0) rrectfill(1, self.bar_y+1, self.width-2, self.bar_h-1, 1, fgcol)

            -- lil grip thing; same colour as background
            local yy = self.bar_y + self.bar_h/2
            line(2, yy-1, self.width-3, yy-1, bgcol)
            line(2, yy+1, self.width-3, yy+1, bgcol)

        end,
        drag = function(self, msg)
            local content = self.parent.child[1]
            content.y -= msg.dy * self.scroll_spd
            -- clamp
            content.y = mid(0, content.y, -max(0, content.height - container.height))

        end,
        click = function(self, msg)
            local content = self.parent.child[1]
            
            -- click above / below to pageup / pagedown
            if (msg.my < self.bar_y) content.y += self.parent.height
            if (msg.my > self.bar_y + self.bar_h) content.y -= self.parent.height
        end
    }

    -- standard mousewheel support when attach scroll bar
    -- speed: 32 pixels // to do: maybe should be a system setting?
    function container:mousewheel(msg)
        local content = self.child[1]
        if (not content) return

        local old_x = content.x
        local old_y = content.y

        if (key("ctrl")) then
            content.x += msg.wheel_y * 32 
        else
            content.y += msg.wheel_y * 32 
        end

        -- clamp
        content.y = mid(0, content.y, -max(0, content.height - container.height))


        -- 0.1.1e: consume event (e.g. for nested scrollables)
        return true

        -- experimental: consume only if scrolled
        --if (old_x ~= content.x or old_y ~= content.y) return true 
        
    end

    return container:attach(scrollbar)

end