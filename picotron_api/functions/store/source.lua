-- to do: errors
function store(location, obj, meta)

	if (type(location) != "string") return nil

	-- currently no writeable protocols
	if (location:prot()) then
		return "can not write "..location
	end

	location = _userland_to_kernal_path(location, "W")

	if (not location) return "could not store to path"

	-- special case: can write raw .p64 / .p64.rom / .p64.png binary data out to host file without mounting it
	local ext = location:ext()

	if (type(obj) == "string" and ext and ext:is_cart()) then
		_signal(40)
			_rm(location:path()) -- unmount existing cartridge // to do: be more efficient
		_signal(41)
		return _store_local(location, obj)
	end

	-- ignore location string
	local filename = _split(location, "#", false)[1]
	
	-- grab old metadata
	local old_meta = _fetch_metadata(filename)
	
	if (type(old_meta) == "table") then
		if (type(meta) == "table") then			
			-- merge with existing metadata.   // to do: how to remove an item?			
			for k,v in pairs(meta) do
				old_meta[k] = v
			end
		end
		meta = old_meta
	end

	if (type(meta) != "table") meta = {}
	if (not meta.created) meta.created = date()
	if (not meta.revision or type(meta.revision) ~= "number") meta.revision = -1
	meta.revision += 1   -- starts at 0
	meta.modified = date()


	-- 0.1.1e: store "prog" when is bbs:// -- the program that was used to create the file can be used to open it again
	if (_env().argv[0]:prot(true) == "bbs") then
		meta.prog = _env().argv[0]
	end

	-- use pod_format=="raw" if is just a string
	-- (_store_local()  will see this and use the host-friendly file format)

	if (type(obj) == "string") then
		meta.pod_format = "raw"
	else
		-- default pod format otherwise
		-- (remove pod_format="raw", otherwise the pod data will be read in as a string!)
		meta.pod_format = nil 
	end


	local err_str = _store_local(filename, obj, _generate_meta_str(meta))

	-- notify program manager (handles subscribers to file changes)
	if (not err_str) then
		_send_message(2, {
			event = "_file_stored",
			filename = _fullpath(filename), -- pm expects raw path
			proc_id = pid()
		})
	end

	-- nil if no error
	return err_str

end