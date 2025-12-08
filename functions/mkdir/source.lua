--[[
	mkdir()
	returns string on error
]]
function mkdir(p)
	p = _userland_to_kernal_path(p, "W")
	if (not p) return "could not access path"

	if (p:prot()) return -- protocols don't support mkdir / writes yet

	if (_fstat(p)) return -- is already a file or directory

	-- create new folder
	local ret = _mkdir(p)

	-- couldn't create
	if (ret) return ret

	-- can store starting metadata to file directly because no existing fields to preserve
	-- // 0.1.0f: replaced "stored" with modified; not useful as a separate concept
	_store_metadata_str_to_file(p.."/.info.pod", _generate_meta_str{created = date(), modified = date()})
end