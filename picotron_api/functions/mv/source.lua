--[[
	mv(src, dest)

	to do: rename / relocate using host operations if possible

	to do: currently moving a mount copies it into a regular file and removes the mount;
		-> should be possible to rename/move mounts around?
]]
function mv(src_p, dest_p)

	-- special case: moving a file from (read-only) protocol; treat as a copy (e.g. drag and drop from bbs)
	-- cp() handles that case
	if (src_p:prot()) return cp(src_p, dest_p)

	local src  = _userland_to_kernal_path(src_p, "W") 
	local dest = _userland_to_kernal_path(dest_p, "W")
	if (not src) return "could not resolve source path"
	if (not dest) return "could not resolve destination path"
	if (dest:prot()) return "can not write to "..dest:prot().."://" -- protocols don't support writing yet 

	-- skip mv if src and dest are the same (is a NOP but not an error. to do: should it be?)
	if (_fullpath(src) == _fullpath(dest)) return

	-- special case: when copying from bbs://, retain .bbs_id .sandbox as metadata
	local bbs_id = (src_p:prot(true) == "bbs" and src_p:ext() == "p64") and src_p:basename():sub(1,-5) or nil

	_signal(40) -- 0.1.1e compound op lock (prevent flushing cart halfway through moving)
		local res = _cp(src, dest, true, nil, bbs_id) -- atomic operation
	_signal(41)
	if (res) return res -- copy failed

	-- copy completed -- safe to delete src
	_signal(40)
		_rm(src)
	_signal(41)
end