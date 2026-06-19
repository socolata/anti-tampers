local secret = {}
local t = setmetatable({}, {
    __index = function(_, k) return k == "MS911" and secret or "detected" end,
    __metatable = "Locked",
    __tostring = function() return "pass" end
})
local function verifyStack()
    local trace = debug.traceback()
    if string.find(trace, "hook") or string.find(trace, "logger") then
        return false
    end
    return true
end
local success, result = pcall(function() 
    local mt = getmetatable(t)
    if typeof(t) ~= "table" or mt ~= "Locked" or #mt ~= 6 or typeof(mt) ~= "string" then
        return "detected"
    end
    if tostring(t) ~= "pass" or tostring(t) ~= "pass" then
        return "detected"
    end
    if #t ~= 0 then return "detected" end
    if typeof(verifyStack) ~= "function" or iscclosure(verifyStack) then return "detected" end
    if getfenv(1) ~= getfenv(0) and getfenv(1) == nil then return "detected" end
    if pcall(function() return game:GetService("LogService") end) and debug.info(1, "f") == nil then return "detected" end
    if rawget(getfenv(), "getgenv") or rawget(getfenv(), "getreg") then return "detected" end
    if not rawequal(t.MS911, secret) or not verifyStack() then 
        return "detected" 
    end
    return "pass"
end)
if success and result == "pass" then
    print("pass")
else
    print("detected")
end