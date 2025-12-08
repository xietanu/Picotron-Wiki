_rm = function(f0, flags, depth)

	flags = flags or 0x0
	depth = depth or 0

	local attribs, size, origin = _fstat(f0)

	if (not attribs) then
		-- does not exist
		return
	end

	if (attribs == "folder") then

		-- folder: first delete each entry using this function
		-- dont recurse into origin! (0.1.0h: unless it is cartridge contents)
		-- e.g. rm /desktop/host will just unmount that host folder, not delete its contents
		if (not origin or (origin:sub(1,11) == "/ram/mount/")) then 
			local l = ls(f0)
			if (type(l) == "table") then
				for k,fn in pairs(l) do
					_rm(f0.."/"..fn, flags, depth+1)
				end
			end
		end
		-- remove metadata (not listed)
		_rm(f0.."/.info.pod", flags, depth+1)

		-- flag 0x1: remove everything except the folder itself (used by cp when copying folder -> folder)
		-- for two reasons:

		-- leave top level folder empty but stripped of metadata; used by cp to preserve .p64 that are folders on host
		if (flags & 0x1 > 0 and depth == 0) then
			return
		end

	end


	-- delete single file / now-empty folder
	
	-- _printh("_fdelete: "..f0)
	return _fdelete(f0)
end

function rm(f0)
	local f1 = _userland_to_kernal_path(f0, "W")
	if (not f1) return "could not resolve"
	if (f1:prot()) return "can not modify "..f1:prot() -- protocols don't support writing yet 

	-- 0.2.1e: deleting /ram/mount* is dangerous -- contents of mounted carts deleted and flushed to origin
	if (f1 == "/ram") return "can not delete ram"
	if (f1 == "/ram/mount") return "can not modify ram/mount"
	if (f1:sub(1,11) == "/ram/mount/") return "can not modify ram/mount"

	_signal(40)
		local ret = _rm(f1, 0, 0) -- atomic operation
	_signal(41)
	return ret
end