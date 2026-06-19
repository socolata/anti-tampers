-- by socolata
local launchClock = os.clock()
local mainRegistry = setmetatable({}, {
    __index = function() return "secured" end,
    __newindex = function(t, k, v) rawset(t, k, v) end,
    __metatable = "ProtectedRegistry"
})
local function scanMemory()
    if getfenv(1) ~= getfenv(0) or not pcall(function() return game:GetService("LogService") end) then return false end
    local forbidden = {"hookfunction", "hookmetamethod", "decompile", "getgc", "getloadedmodules"}
    for _, name in ipairs(forbidden) do
        if rawget(getfenv(), name) or rawget(_G, name) then return false end
    end
    return true
end
local function verifyCaller()
    local success, name, line = pcall(debug.info, 2, "nl")
    if not success or (name and string.find(string.lower(name), "hook")) then return false end
    local trace = debug.traceback()
    if string.find(trace, "spy") or string.find(trace, "logger") or string.find(trace, "anonymous") then return false end
    return true
end
local function executeCheck()
    local t0 = os.clock()
    for i = 1, 1000 do local x = math.sqrt(i) * math.sin(i) end
    if (os.clock() - t0) > 0.02 then return false end
    if not scanMemory() or not verifyCaller() then return false end
    if getmetatable(mainRegistry) ~= "ProtectedRegistry" or mainRegistry.AnyKey ~= "secured" then return false end
    if (os.clock() - launchClock) > 1.5 then return false end
    return true
end
local status, result = pcall(executeCheck)
if status and result == true then
    print("pass")
else
    print("detected")
end