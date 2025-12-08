--[[	
	internal; f0, f1 are raw (kernal) paths 

	handles anywhen:// and bbs:// by using userland functions
	(when kernal path has protocol, always same as canonical userland path)

	if dest (f1) exists, is deleted!  (cp util / filenav copy operations can do safety)
]]
function _cp(f0, f1, moving, depth, bbs_id)

	depth = depth or 0
	f0 = _fullpath(f0)
	f1 = _fullpath(f1)

	if (not f0)   return "could not resolve source path"
	if (not f1)   return "could not resolve destination path"
	if (f0 == f1) return "can not copy over self"

	local f0_prot = f0:prot()

	local f0_type = f0_prot and fstat(f0) or _fstat(f0) -- need to use userland function for protocol source path (e.g. copy from anywhen)
	local f1_type = _fstat(f1)

	if (not f0_type) then
		--print(tostring(f0).." does not exist") 
		return "could not read source location"
	end

	-- explicitly delete in case is a folder -- want to make sure contents are removed
	-- to do: should be an internal detail of delete_path()?
	-- 0.1.0e: 0x1 to keep dest as a folder when copying a folder over a folder
	-- (e.g. dest.p64/ is a folder on host; preferable to keep it that way for some workflows)
	if (f1_type == "folder" and depth == 0) _rm(f1, f0_type == "folder" and 0x1 or 0x0) 

	-- folder: recurse
	if (f0_type == "folder") then

		-- 0.1.0c: can not copy inside itself   "cp /ram/cart /ram/cart/foo" or "cp /ram/cart/foo /ram/cart" 
		-- 0.1.1:  but cp foo foo2/ is ok (or cp foo2 foo/)
		local minlen = min(#f0, #f1)
		if (sub(f1, 1, minlen) == sub(f0, 1, minlen) and (f0[minlen+1] == "/" or f1[minlen+1] == "/")) then
			return "can not copy inside self" -- 2 different meanings!
		end
		-- 0.1.1e: special case for /  --  is technically also "can not copy inside self", but might as well be more specific
		if (f0 == "/" or f1 == "/") then
			return "can not copy /"
		end

		-- get a cleared out root folder with empty metadata
		-- (this allows host folders to stay as folders even when named with .p64 extension -- some people use that workflow)
		_mkdir(f1)

		-- copy each item (could also be a folder)

		local l = (f0_prot and ls or _ls)(f0)
		for k,fn in pairs(l) do
			local res = _cp(f0.."/"..fn, f1.."/"..fn, moving, depth+1)
			if (res) return res
		end

		-- copy metadata over if it exists (ls does not return dotfiles)
		-- 0.1.0f: also set initial modified / created values 

		local meta = (f0_prot and fetch_metadata or _fetch_metadata)(f0) or {}

		-- also set date [and created when not being used by mv())
		meta.modified = date()
		if (not moving) meta.created = meta.created or meta.modified -- don't want to clobber .created when moving

		-- when copying / moving from bbs:// -> local, carry over bbs_id and sandbox. copy over existing values! (in particular, dev bbs_id)
		if (bbs_id) then
			-- printh("@@ carrying over bbs_id as metadata"..bbs_id)
			meta.bbs_id = bbs_id
			meta.sandbox = "bbs"
		end

		-- store it back at target location. can just store file directly because no existing fields to preserve
		_store_metadata_str_to_file(f1.."/.info.pod", _generate_meta_str(meta))

		return
	end

	-- copy a single file

	if (f0_prot) then
		-- from a protocol: need to do a userland fetch and store
		local obj, meta = _fetch_userland(f0)
		_store_userland(f1, obj, meta)
	else
		-- local -> local: can do a raw binary copy
		_fcopy(f0, f1)
	end

	-- 0.2.1c notify program manager (handles subscribers to file changes)
	if (true) then -- to do: check file could actually be stored
		_send_message(2, {
			event = "_file_stored",
			filename = f1, -- is already kernal fullpath like pm expects
			proc_id = pid()
		})
	end

end

function cp(src_p, dest_p)
	local src  = _userland_to_kernal_path(src_p)
	local dest = _userland_to_kernal_path(dest_p, "W")
	if (not src) return "could not resolve source path"
	if (not dest) return "could not resolve destination path"
	if (dest:prot()) return "can not write to "..dest:prot().."://" -- protocols don't support writing yet 

	-- special case: copying a file from protocol; read file via userdata fetch / store (avoid duplicated logic)
	-- happens when source is an anywhen file (so not mounted inside /ram/anywhen) // cp("anywhen://...","1.txt")
	if (src_p:prot() and fstat(src_p) == "file") then
		local dat,meta = _fetch_userland(src_p)
		_store_userland(dest_p, dat, meta)
	end

	-- special case: when copying from bbs://, retain .bbs_id .sandbox as metadata
	local bbs_id = (src_p:prot(true) == "bbs" and src_p:ext() == "p64") and src_p:basename():sub(1,-5) or nil

	_signal(40) -- 0.1.1e: lock flushing for compound operation; don't want to e.g. store a cart on host that is halfway through being copied
		local ret0, ret1 = _cp(src, dest, nil, nil, bbs_id) -- atomic operation   (to do: remove ret1; never used?)
	_signal(41) -- unlock 
	return ret0, ret1
end