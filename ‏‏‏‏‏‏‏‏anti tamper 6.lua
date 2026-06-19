local result = (function()
    if not debug or not debug.info then return "SKIP" end

    local checks = {
        { lib = math,      key = "abs",    member = math.abs },
        { lib = string,    key = "byte",   member = string.byte },
        { lib = table,     key = "sort",   member = table.sort },
        { lib = coroutine, key = "resume", member = coroutine.resume },
    }

    for _, item in ipairs(checks) do
        local raw = rawget(item.lib, item.key)
        if raw == nil then return false end
        if not rawequal(raw, item.member) then return false end

        local ok1, info1 = pcall(debug.info, raw, "sn")
        local ok2, info2 = pcall(debug.info, item.member, "sn")
        if not ok1 or not ok2 then return false end

        if tostring(info1) ~= "[C]" or tostring(info2) ~= "[C]" then return false end
        if type(info1) == "table" and type(info2) == "table" then
            if info1.name ~= info2.name then return false end
            if tostring(info1.source) ~= tostring(info2.source) then return false end
        end
    end

    return true
end)()

if result == true then
    print("passed")
elseif result == "SKIP" then
    print("SKIP")
else
    print("detected")
end