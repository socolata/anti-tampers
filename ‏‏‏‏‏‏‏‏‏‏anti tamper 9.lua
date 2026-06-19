local secret = {}
local t = setmetatable({}, {
    __index = function(_, k) return k == "MS911" and secret or "detected" end,
    __metatable = "Locked",
    __tostring = function() return "pass" end
})
local function verifyStack()
    local trace = debug.traceback()
    if string.find(trace, "dump") or string.find(trace, "exploit") then return false end
    return true
end
local protections = {
    function() return rawequal(getmetatable(t), "Locked") end,
    function() return typeof(tostring(t)) == "string" end,
    function() return rawget(t, "MS911") == nil end,
    function() return (debug.info(verifyStack, "s") ~= "[C]") end,
    function() return (xpcall(function() return true end, function() return false end) == true) end,
    function() return not rawget(_G, "shared") or typeof(_G.shared) == "table" end,
    function() return (not rawget(getfenv(), "getrenv") and not rawget(getfenv(), "getscenv")) end,
    function() local val = t.MS911 return val == secret end,
    function() return verifyStack() end,
    function() return pcall(function() return t.UnknownKey end) end
}
local success, result = pcall(function()
    for i = 1, #protections do if not protections[i]() then return "detected" end end
    return "pass"
end)
if success and result == "pass" then print("pass") else print("detected") end