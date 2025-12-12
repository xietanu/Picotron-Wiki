function mouse(new_mx, new_my)
    if (new_mx or new_my) then
        new_mx = new_mx or mouse_x
        new_my = new_my or mouse_y
        _warp_mouse(new_mx, new_my);
    end
    return mouse_x, mouse_y, mouse_b, wheel_x, wheel_y -- wheel
end