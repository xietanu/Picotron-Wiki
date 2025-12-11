local function _store_metadata(filename, meta)

	local old_meta = _fetch_metadata(filename)
	
	if (type(old_meta) == "table") then
		if (type(meta) == "table") then			
			-- merge with existing metadata.   // to do: how to remove an item? maybe can't! just recreate from scratch if really needed.
			for k,v in pairs(meta) do
				old_meta[k] = v
			end
		end
		meta = old_meta
	end

	if (type(meta) != "table") meta = {}
	meta.modified = date() -- 0.1.0f: was ".stored", but nicer just to have a single, more general "file was modified" value.


	local meta_str = _generate_meta_str(meta)

	if (_fstat(filename) == "folder") then
		-- directory: write the .info.pod
		_store_metadata_str_to_file(filename.."/.info.pod", meta_str)
	else
		-- file: modify the metadata fork
		_store_metadata_str_to_file(filename, meta_str)
	end
end

function store_metadata(filename, meta)
	return _store_metadata(_userland_to_kernal_path(filename, "W"), meta)
end