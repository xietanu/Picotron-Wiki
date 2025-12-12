--[[

    g = create_gui()
    p = g:attach_pulldown({x = ..})
    p:attach_pulldown_item("Hey", func)

]]
function GuiElement:attach_pulldown(el)

    local p = self:attach(el)

    function p:draw(ev)

        local flat_top = false -- when false, can generalise to dismissable dialogue. probably too leaky though.
        local x0 = 1
        local y0 = flat_top and -1 or 1
        local x1 = self.width-2
        local y1 = self.height-2
        
        rectfill(x0,y0, x1,y1, 7)

        local border_col = 1
        
        line(x0+1, y1+1, x1-1, y1+1, border_col)
        line(x0-1, y0+1, x0-1, y1-1, border_col)
        line(x1+1, y0+1, x1+1, y1-1, border_col)
        if (not flat_top) then
            -- top border and corners
            line(x0+1, y0-1, x1-1, y0-1, border_col)
            pset(x0,y0,border_col)
            pset(x1,y0,border_col)
        end
        -- bottom corners
        pset(x0,y1,border_col)
        pset(x1,y1,border_col)

    end

    -- no items yet
    p.item_y = 4
    p.item_h = 12
    p.height = 10 -- extra 2px at the bottom feels better

    return p
end