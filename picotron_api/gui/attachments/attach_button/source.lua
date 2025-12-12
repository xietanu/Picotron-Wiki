function GuiElement:attach_button(el)
    el.label = el.label or "[label]"
    el.width = el.width or #el.label * 5 + 10 -- to do: calculate width with current font
    el.height = el.height or 14
    el.cursor = el.cursor or "pointer"

    -- 0.2.1c: set default attributes on creation
    -- later: can define a "class" or "style" at system-wide level or gui level that has these default values
    el.bgcol  = el.bgcol  or (el.highlight and 0x0606 or 0x0706)
    el.fgcol  = el.fgcol  or (el.highlight and 0x0201 or 0x0e01)
    el.border = el.border or (el.highlight and 0x0d0d or el.bgcol)

    local b = self:attach(el)

    function b:draw(msg)
        local bgcol  = el.bgcol or 0x0706
        local fgcol  = el.fgcol or 0x0e01
        local border = el.border or bgcol
        if (msg.has_pointer) then
            bgcol  >>= 8
            fgcol  >>= 8
            border >>= 8
        end

        local yy = 0
        if (msg.mb > 0 and msg.has_pointer) yy = yy + 1

        local x0,y0,x1,y1 = 0,yy,self.width-1,yy+self.height-2

        if (el.border) then
            -- border: default corner radius 2 
            rrectfill(x0,y0,self.width,self.height-1,2,bgcol)
            rrect    (x0,y0,self.width,self.height-1,2,border)
            --[[ test: skeuomorphic button  //  result: ._.
            if (el.highlight) then
                local a,b,c,d
                if (msg.mb > 0 and msg.has_pointer) then
                    a,b,c,d = clip(self.sx - 2, self.sy+3,self.width,self.height,true)
                else
                    a,b,c,d = clip(self.sx + 2, self.sy-3,self.width,self.height,true)
                end
                rrect(x0,y0,self.width,self.height-1,2,el.highlight)
                clip(a,b,c,d)
            end
            ]]
        else
            -- no border; default corner radius 1
            rrectfill(0,0,self.width,self.height,1,bgcol)
        end

        print(self.label, self.width/2 - #self.label * 2.5, 3 + yy, fgcol)
    end

    return b

end