-- by socolata
local integrityToken = "MS911_SECURE"
local shadowEnv = setmetatable({}, {
    __index = function(_, k) return k == integrityToken and "valid" or nil end,
    __metatable = false
})
local function runDiagnostic()
    local env = getfenv(0)
    if rawget(env, "getreg") or rawget(env, "getgenv") or rawget(env, "checkcaller") then return false end
    local traceback = debug.traceback()
    if string.find(traceback, "tamper") or string.find(traceback, "dump") or string.find(traceback, "upvalue") then return false end
    local isC = pcall(function() return debug.info(coroutine.wrap(function() end), "s") end)
    if not isC then return false end
    if shadowEnv[integrityToken] ~= "valid" or getmetatable(shadowEnv) ~= false then return false end
    local counter = 0
    while true do
        local ok, name = pcall(debug.info, counter, "n")
        if not ok then break end
        if name and (string.find(name, "hook") or string.find(name, "index")) then return false end
        counter = counter + 1
    end
    return true
end
local success, state = pcall(runDiagnostic)
if success and state == true then
    print("pass")
else
    print("detected")
end