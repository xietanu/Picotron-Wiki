function include(filename)
    local filename = hf.fullpath(filename)
    if (not filename) return nil

    local src = hf.fetch(filename)
    if (not src) return nil

    -- temporary safety: each file can only be included up to 256 times
    -- to do: why do recursive includes cause a system-level out of memory before a process memory error?
    if (included_files[filename] and included_files[filename] > 256) then
        --printh("** too many includes of "..filename)
        --printh(_stat(0))
        return nil
    end
    included_files[filename] = included_files[filename] and included_files[filename]+1 or 1


    if (type(src) ~= "string") then 
        if (_pidval <= 3) printh("** could not include "..filename)
        _notify("could not include "..filename)
        _stop()
    end

    -- https://www.lua.org/manual/5.4/manual.html#pdf-load
    -- chunk name (for error reporting), mode ("t" for text only -- no binary chunk loading), _ENV upvalue
    -- @ is a special character that tells debugger the string is a filename
    local func,err = _load(src, "@"..filename, "t", _ENV)

    -- syntax error while loading
    if (not func) then 
        _send_message(3, {event="report_error", content = "*syntax error"})
        _send_message(3, {event="report_error", content = "(could not include: "..filename..")"})
        _send_message(3, {event="report_error", content = _tostring(err)})
        _stop()
    end

    return func() -- 0.1.1e: allow private modules (used to return true)
end