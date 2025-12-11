--[[

	create_process(prog, env)

	returns process id on success, otherwise: nil, err_msg

	prog: the cartridge or lua file to run
	env: a table of environment attributes that is merged with the new process environment

]]
-- 
function create_process(prog_name_p, env_patch)

	env_patch = env_patch or {}

	-- 1. sandboxed programs can not create processes

	if _envdat.sandbox and ((_stat(307) & 0x1) == 0) then -- sandboxed program that is not a trusted system app

		local grant_exception = false

		-- 1.a can run /system apps as a "bbs_companion"  --  ** has full fileview ** (except for /appdata)

		if ({
			["/system/apps/filenav.p64"] = true, -- bbs carts can use filenav to gain access to open any file on disk (e.g. strawberry_src
			["/system/apps/notebook.p64"] = true, -- some carts already use this for opening documentation, I think. could open() instead
			["/system/util/open.lua"] = true, -- #picocalendar uses this to open text files
			["/system/util/ls.lua"] = true -- for sandboxed terminal; doesn't modify system and parent can't get information back
		})[prog_name_p] then
			grant_exception = true
			env_patch.sandbox = "bbs_companion"
			env_patch.bbs_id = _envdat.bbs_id
		end

		-- 1.b can run bundled carts in same sandbox

		local pp = _envdat.corun_program and _dirname(_envdat.corun_program) or _envdat.argv[0]
		local pp1 = hf.fullpath(prog_name_p)
		if (pp and _sub(pp1,1,#pp) == pp and pp1[#pp+1] == "/") then
			grant_exception = true
			env_patch.sandbox = "bbs"
			env_patch.bbs_id = _envdat.bbs_id
		end
		
		-- 1.c can run anything from bbs:// (including sub-carts)

		if (get_bbs_id_from_location(prog_name_p)) then
			grant_exception = true 
			env_patch.sandbox = "bbs"
			env_patch.bbs_id = get_bbs_id_from_location(prog_name_p)
		end

		--> fail if no grounds to allow creating process while sandboxed

		if (not grant_exception) then
			-- printh("[create_process] denied from sandboxed program: "..prog_name_p)
			return nil, "sandboxed process can not create_process()"
		end
		-- printh("[create_process] granting exception in sandbox: "..prog_name_p)


		-- rate limiting // prevent bbs cart from process-bombing
		if (time() > create_process_t + 60) create_process_t, create_process_n = time(), 0 -- reset every minute
		if (create_process_n >= 20) return nil, "sandboxed process can not create_process() more than 20 / minute"
		create_process_n += 1

		-- rate limiting for picocalendar (bug in cart that didn't show up earlier when find_existing_window was always implicitly true)
		-- to do: stealth patch cart and delete this
		if (_envdat.argv[0]:sub(1,18) == "bbs://picocalendar") then
			if (last_picocalendar_t and time() < last_picocalendar_t + 0.5) return nil, "picocalendar window spam workaround"
			last_picocalendar_t = time()
		end

	end


	------------------------------------------ resolve program path -------------------------------------

	local prog_name = hf.fullpath(prog_name_p)

	-- normalise bbs paths: remove "new/0/" etc
	if get_bbs_id_from_location(prog_name) then
		-- printh("normalising bbs prog: "..pod{prog_name, normalise_bbs_path(prog_name), get_bbs_id_from_location(prog_name)})
		prog_name = normalise_bbs_path(prog_name)
	end

	------------------------------------------ locate boot file -----------------------------------------
	
	-- .p64 files: find boot file in root of .p64 (and thus set default path there too)
	local boot_file = prog_name
	if (_is_cart_ext(_ext(prog_name))) boot_file ..= "/main.lua"

	------------------------------------------ locate metadata ------------------------------------------

	-- look for metadata inside p64 / folder  (never use metadata from a single .lua file in this context)
	local metadata = _fetch_metadata_from_file(prog_name.."/.info.pod")

	-- special case: co-running /ram/cart from terminal
	if env_patch.corun_program == "/ram/cart/main.lua" then
		metadata = _fetch_metadata_from_file("/ram/cart/.info.pod")
	end
	
	-- running main.lua directly from inside a cart -> should look at attributes of parent directory
	if (not metadata and _basename(prog_name) == "main.lua") then
		metadata = _fetch_metadata_from_file(_dirname(boot_file).."/.info.pod")
	end

	-- no metadata found -> default is {}
	if (not metadata) metadata = {}

	-- check for future cartridge (applies to carts / folders -- lua files don't have this metadata)
	if (type(metadata.runtime) == "number" and metadata.runtime > _stat(5)) then
		_notify("** cartridge has future runtime version: "..prog_name_p)
		return -- to do: settings.allow_future
	end

	------------------------------------------ construct new_env ------------------------------------------

	local new_env = {} -- don't inherit anything from parent 

	-- .. but add new attributes from env_patch (note: can copy trees)
	for k,v in pairs(env_patch) do
		new_env[k] = v
	end

	-- decide program path: same as boot file, or corun program
	local program_path = new_env.corun_program and 
		_dirname(hf.fullpath(new_env.corun_program)) or
		_dirname(boot_file)

	-- standard environment values: pid, argv, argv[0]
	new_env.parent_pid = _pidval
	new_env.argv = type(new_env.argv) == "table" and new_env.argv or {} -- guaranteed to exist at least as an empty table
	new_env.argv[0] = prog_name -- e.g. /system/apps/gfx.p64

	------------------------------------------------------------------------------------------------------------------------------------------------
	-- sandbox validation
	------------------------------------------------------------------------------------------------------------------------------------------------

	-- safety: prog that starts with bbs:// MUST be bbs-sandboxed w/ cart_id derived from that location
	-- for bbs://foo-0.p64/subcart/hoge.p64 --> id should be foo, not hoge
	if get_bbs_id_from_location(prog_name) then
		new_env.sandbox = "bbs"
		new_env.bbs_id = get_bbs_id_from_location(prog_name)
	end

	-- grab sandbox from cartridge metadata if not already set in environment
	-- (can opt to turn sandboxing off in env_patch with {sandbox=false}; or otherwise override sandbox specified in metadata)
	if (not new_env.sandbox and metadata.sandbox and metadata.bbs_id) then
		new_env.sandbox = metadata.sandbox -- "bbs"
		new_env.bbs_id = metadata.bbs_id
	end

--[[
	deleteme ~ set when granting

	-- created by sandboxed program -> MUST be bbs_companion with the same bbs_id (unless already determined to be a bbs cart)
	-- --> ignore metadata or new_env.sandox
	-- means inherit fileview  (e.g. open filenav -> should have same /appdata mapping)
	if (new_env.sandbox ~= "bbs" and _envdat.sandbox == "bbs") then
		new_env.sandbox = "bbs_companion"
		new_env.bbs_id = _envdat.bbs_id
--		printh("create_process bbs_companion: ".._envdat.bbs_id)
	end
]]

	-- sandboxes should be only bbs / bbs_companion, and must have a bbs_id
	if new_env.sandbox and new_env.sandbox ~= "bbs" and new_env.sandbox ~= "bbs_companion" then
		return nil, "only bbs, bbs_companion sandbox profiles are currently supported"
	end

	if (new_env.sandbox and not new_env.bbs_id) then
		return nil, "bad bbs_id -- can not sandbox"
	end


	------------------------------------------------------------------------------------------------------------------------------------------------
	-- construct fileview
	------------------------------------------------------------------------------------------------------------------------------------------------

	if (_stat(307) & 0x1) > 0 then
		-- trusted apps (/system/*) can grant a custom fileview (including to a sandboxed process)
		new_env.fileview = new_env.fileview or {}
	else
		-- otherwise the fileview is derived entirely from new_env.sandbox / new_env.bbs_id
		new_env.fileview = {}
	end

	-- 0.2.0e: fileview rules should not include hash part. but called "location" (and not "path") because should be allowed to pass in a location
	-- (e.g. open.lua does it -- sometimes includes the hash part. callers shouldn't need to know / remember to do that)

	for i=#new_env.fileview,1,-1 do
		if type(new_env.fileview[i].location) == "string" and type(new_env.fileview[i].mode) == "string" then
			-- remove the hash part -- just want the path
			new_env.fileview[i].location = _path(new_env.fileview[i].location) 
		else
			-- invalid rule
			del(new_env.fileview,new_env.fileview[i])
		end
	end

	-- printh("creating process "..prog_name_p.." with starting fileview: "..pod{new_env.fileview})
	-- printh("creating process "..prog_name_p.." with sandbox: "..pod{new_env.sandbox})
	
	-- create fileview / rules for sandbox

	if (new_env.sandbox == "bbs") then

		-- read system libraries and resources
		add(new_env.fileview, {location = "/system", mode = "R"})

		-- cart/program can read itself; includes running main.lua directly, and co-run programs. program_path is same as initial pwd
		-- note: this never happens for stand-alone .lua files as it is not possible to sandbox them separately (only parent .info.pod is observed in this context)
		add(new_env.fileview, {location = program_path, mode = "R"})

		-- partial view of processes.pod and /desktop metadata (only icon x,y available; ref: bbs://desktop_pet.p64)
		add(new_env.fileview, {location = "/ram/system/processes.pod", mode = "X"})
		add(new_env.fileview, {location = "/desktop/.info.pod", mode = "X"})
		
		-- (dev) read/write mounted bbs:// cart while sandboxed
		-- deleteme -- only needed in kernal space in fs.lua
--		add(new_env.fileview, {location = "/ram/bbs/"..new_env.bbs_id..".p64.png", mode = "RW"})
		-- experimental: should be allowed to read mount? seems harmless but shouldn't ever be needed so do not allow
		--add(new_env.fileview, {location = "/ram/bbs/"..new_env.bbs_id..".p64.png", mode = "R"}) 

		-- any carts can read/write /appdata/shared \m/
		add(new_env.fileview, {location = "/ram/shared", mode = "R"})
		add(new_env.fileview, {location = "/appdata/shared", mode = "RW"})

		-- any other /appdata path should be mapped to /appdata/bbs/bbs_id
		local bbs_id_base = split(new_env.bbs_id, "-", false)[1] -- don't include the version part
		_mkdir("/appdata/bbs") -- safety; should already exist (boot creates)
		--_mkdir("/appdata/bbs/"..bbs_id_base) -- to do: only create when actually about to write something?
		add(new_env.fileview, {location = "/appdata", mode = "RW", target="/appdata/bbs/"..bbs_id_base})

	end

	-- bbs_comapnion e.g. open filenav / notebook from bbs cart. always a trusted app from /system
	-- the companion program has full access, except should have same /appdata mapping as parent process
	if (new_env.sandbox == "bbs_companion") then

		new_env.fileview={}

		-- same /appdata mapping as parent process
		local bbs_id_base = split(_envdat.bbs_id, "-", false)[1] -- don't include the version part
		_mkdir("/appdata/bbs")
		_mkdir("/appdata/bbs/"..bbs_id_base) -- create on launch in case want to browse it with filenav
		add(new_env.fileview, {location = "/appdata", mode = "RW", target="/appdata/bbs/"..bbs_id_base})

		-- printh("created companion mapping for /appdata: ".."/appdata/bbs/"..bbs_id_base)

		-- everything else is allowed (e.g. filenav can freely browse drive and choose where to load / save file)
		add(new_env.fileview, {location = "*", mode = "RW"})
	end

	--printh("new_env.fileview: "..pod{new_env.fileview})

	
	
	----


	local str = [[

		-- environment for new process; use _pod to generate immutable version
		-- (generates new table every time it is called)
		env = function() 
			return ]].._pod(new_env,0x0)..[[
		end
		_env = env

		local head_code = load(fetch("/system/lib/head.lua"), "@/system/lib/head.lua", "t", _ENV)
		if (not head_code) then printh"*** ERROR: could not load head. borked file system / out of pfile slots? ***" end
		head_code()

		-- order matters // fs.lua uses on_event
		_include_lib("/system/lib/api.lua")
		_include_lib("/system/lib/mem.lua")
		_include_lib("/system/lib/window.lua")
		_include_lib("/system/lib/coroutine.lua")
		_include_lib("/system/lib/print.lua")
		_include_lib("/system/lib/events.lua")
		_include_lib("/system/lib/fs.lua")
		_include_lib("/system/lib/socket.lua")
		_include_lib("/system/lib/gui.lua")
		_include_lib("/system/lib/app_menu.lua")
		_include_lib("/system/lib/wrangle.lua")
		_include_lib("/system/lib/undo.lua")
		_include_lib("/system/lib/theme.lua")

		_signal(38) -- start of userland code (for memory accounting)
		_signal(15) -- give audio priority to this process; can steal PFX6416 control on note() / sfx() / music()

		-- clear out globals that shouldn't be exposed to userland
		include("/system/lib/jettison.lua")
		
		-- always start in program path
		cd("]]..program_path..[[")

		-- autoload resources (must be after setting pwd)
		-- 0.2.0e: when running /ram/cart, this also blocks to save any files open in editors
		include("/system/lib/resources.lua")

		-- to do: preprocess_file() here // update: no need!
		include("]]..boot_file..[[")

		-- footer; includes mainloop
		include("/system/lib/foot.lua")

	]]


	local proc_id = _create_process_from_code(str, get_short_prog_name(prog_name), prog_name, new_env.sandbox)

	if (not proc_id) then
		return nil
	end

	if (env_patch.window_attribs and env_patch.window_attribs.pwc_output) then
		hf.store("/ram/system/pop.pod", proc_id) -- present output process
	end

	if (env_patch.blocking) then
		-- this process should stop running until proc_id is completed
		-- (update: is that actually useful?)
	end


--	printh("$ created process "..proc_id..": "..prog_name.." ppath:"..program_path)
--	printh("  new_env: "..pod(new_env))

	return proc_id

end