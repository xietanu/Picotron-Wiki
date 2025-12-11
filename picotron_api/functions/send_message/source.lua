--[[
	send_message()

	security concern: 
	userland apps may perform dangerous actions in response to messages, not realising they can be triggered by arbitrary bbs carts
		// also: userland apps currently observe "mouse", "textinput" etc in events.lua without filtering (desirable, but not for sandboxed apps)
	-> sandboxed processes can only send messages to self, or to /system processes (0.1.1e)
		-- e.g. sandboxed terminal can send terminal set_haltable_proc_id to wm, or request a screenshot capture
		-- assumption: /system programs can all handle arbitrary messages safely
		-- to do: should accept message going to process 2, but then reject most/all of them from those handlers. clearer
]]
function send_message(proc_id, msg, on_responce)

	if 
		not _envdat.sandbox or                         -- userland processes can send messages anywhere
		proc_id == _pidval or                          -- can always send message to self
		(_stat(307) & 0x1) == 1 or                     -- can always send message if is bundled /system app (e.g. sandboxed filenav)
		proc_id == 3 or                               -- can always send message to wm
		-- special case: sandboxed app can set map/gfx palette via pm; (to do: how to generalise this safely?)
		msg.event == "set_palette" or -- used by #okpal
		(msg.event == "broadcast" and msg.msg and msg.msg.event == "set_palette") -- not sure if used in the wild
	then

		if type(on_responce) == "function" then
			local repy_id = "msg"..flr(_stat(333)) -- unique id
			hf.on_event(repy_id, function(msg1)
				on_responce(msg1)
				hf.on_event(repy_id, nil) -- remove the callback 
			end)
			msg._reply_id = repy_id
			_send_message(proc_id, msg)
		elseif on_responce then
			-- blocking			
			if (proc_id == _pid) return nil, "can not send a blocking message to self" 
			local ret
			local repy_id = "msg"..flr(_stat(333)) -- unique id
			hf.on_event(repy_id, function(msg1)
				ret = msg1
				hf.on_event(repy_id, nil) -- remove the callback 
			end)
			msg._reply_id = repy_id
			_send_message(proc_id, msg)
			while (ret == nil) do hf.flip(0x5) end -- same as input(): 0x1 superyield (no time advance or frame end)  0x4 to process messages
			return ret
		else
			-- fire and forget
			_send_message(proc_id, msg)
		end
	else
		--printh("send_message() declined: "..pod(msg))
	end

end