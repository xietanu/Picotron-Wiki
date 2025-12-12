-- set preferred size; wm can still override
function window(w, h, attribs)

	-- this function wrangles parameters;
	-- set_window_1 doesn't do any further transformation / validation on parameters

	if (type(w) == "table") then
		attribs = w
		w,h = nil,nil

		-- special case: adjust position by dx, dy
		-- discard other 
		if (attribs.dx or attribs.dy) then
			_send_message(3, {event="move_window", dx=attribs.dx, dy=attribs.dy})
			return
		end

	end

	attribs = attribs or {}
	attribs.width = attribs.width or w
	attribs.height = attribs.height or h
	attribs.parent_pid = _envdat.parent_pid

	return set_window_1(attribs)
end