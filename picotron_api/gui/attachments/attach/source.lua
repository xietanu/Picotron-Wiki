function GuiElement:attach(child)
    child = child or {}		
    child = GuiElement:new(child)
    child.parent = self
    child.head = self.head or self -- also updated in update_absolute_position (ref: wm manually reattaches subtrees, messing up head)

    -- calculate relative size immediately -- might be used while calculating other elements
    if (child.width_rel)  child.width  = self.width  * child.width_rel  + (child.width_add  and child.width_add  or 0) 
    if (child.height_rel) child.height = self.height * child.height_rel + (child.height_add and child.height_add or 0)

    return add(self.child, child)

end