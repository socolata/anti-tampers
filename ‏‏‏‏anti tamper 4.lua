-- by socolata
local integrityState = true
local secureKey = "REALTIME_VALIDATION"
local function verifyCore()
local ok1, a1 = pcall(debug.info, task.spawn, "a")
local ok2, a2 = pcall(debug.info, print, "a")
if not ok1 or not ok2 or a1 ~= 0 or a2 ~= 0 then return false end
if getfenv(task.spawn) ~= getfenv(0) or getfenv(print) ~= getfenv(0) then return false end
return true
end
local function performStaticChecks()
if not verifyCore() then return false end
local isStackValid = true
local _, stackErr = pcall(function()
local function checkStack(depth)
if depth > 0 then checkStack(depth - 1) else error("stack_marker") end
end
checkStack(3)
end)
if not stackErr or not string.find(stackErr, "stack_marker") then isStackValid = false end
if not isStackValid then return false end
local isNativeBehavior = true
local sampleTable = {x = 10, y = 20}
if #sampleTable ~= 0 or table.find(sampleTable, 10) ~= nil then isNativeBehavior = false end
if not isNativeBehavior then return false end
local isStringSecure = true
local _, strCheck = pcall(string.sub, "luau_secure", 1, 4)
if strCheck ~= "luau" then isStringSecure = false end
if not isStringSecure then return false end
local isTypeSecure = true
if type(pcall) ~= "function" or type(print) ~= "function" then isTypeSecure = false end
if not isTypeSecure then return false end
local isMathSecure = true
if math.sqrt(16) ~= 4 or math.ceil(4.2) ~= 5 then isMathSecure = false end
if not isMathSecure then return false end
local stringIntegrity = true
if string.lower("ABC") ~= "abc" or string.upper("abc") ~= "ABC" or string.len("123") ~= 3 then stringIntegrity = false end
if not stringIntegrity then return false end
local tableFunctions = true
if type(table.insert) ~= "function" or type(table.remove) ~= "function" or type(table.concat) ~= "function" then tableFunctions = false end
if not tableFunctions then return false end
local luauPackCheck = true
if type(table.pack) ~= "function" or type(table.unpack) ~= "function" then luauPackCheck = false end
if not luauPackCheck then return false end
local stringFormatCheck = true
if string.format("%d", 100) ~= "100" or string.format("%s", "test") ~= "test" then stringFormatCheck = false end
if not stringFormatCheck then return false end
local bitwiseCheck = true
if bit32.band(5, 3) ~= 1 or bit32.bor(4, 2) ~= 6 or bit32.bxor(5, 3) ~= 6 then bitwiseCheck = false end
if not bitwiseCheck then return false end
local tableClearCheck = true
local clearTable = {1, 2, 3}
table.clear(clearTable)
if next(clearTable) ~= nil then tableClearCheck = false end
if not tableClearCheck then return false end
return true
end
local function runRealTimeMonitor()
while integrityState do
if not verifyCore() then integrityState = false end
local envCheck = pcall(function()
local testEnv = getfenv(0)
if testEnv ~= getfenv(1) then integrityState = false end
end)
if not envCheck then integrityState = false end
local tableIntegrity = pcall(function()
local t = {A = 1}
if next(t) ~= "A" or #t ~= 0 then integrityState = false end
end)
if not tableIntegrity then integrityState = false end
local clockCheck = pcall(function()
local t1 = os.clock()
local t2 = os.clock()
if t2 < t1 then integrityState = false end
end)
if not clockCheck then integrityState = false end
local typeVerification = pcall(function()
if type(integrityState) ~= "boolean" or type(secureKey) ~= "string" then integrityState = false end
end)
if not typeVerification then integrityState = false end
local pcallBehavior = pcall(function()
local s, e = pcall(function() error("loop_test") end)
if s or not e or not string.find(e, "loop_test") then integrityState = false end
end)
if not pcallBehavior then integrityState = false end
local mathLoopCheck = pcall(function()
if math.abs(-5) ~= 5 or math.max(1, 10) ~= 10 or math.min(1, 10) ~= 1 then integrityState = false end
end)
if not mathLoopCheck then integrityState = false end
local stringMatchCheck = pcall(function()
if string.match("hello", "ell") ~= "ell" or string.gsub("apple", "p", "b") ~= "abble" then integrityState = false end
end)
if not stringMatchCheck then integrityState = false end
local pairsBehavior = pcall(function()
local count = 0
for k, v in pairs({1, 2, 3}) do count = count + 1 end
if count ~= 3 then integrityState = false end
end)
if not pairsBehavior then integrityState = false end
local coroutineBehavior = pcall(function()
local co = coroutine.create(function() coroutine.yield("running") end)
local _, res = coroutine.resume(co)
if res ~= "running" or coroutine.status(co) ~= "suspended" then integrityState = false end
end)
if not coroutineBehavior then integrityState = false end
local xpcallBehavior = pcall(function()
local handled = false
xpcall(function() error("xpcall_test") end, function(err) if string.find(err, "xpcall_test") then handled = true end end)
if not handled then integrityState = false end
end)
if not xpcallBehavior then integrityState = false end
local stringByteCheck = pcall(function()
if string.byte("A") ~= 65 or string.char(66) ~= "B" then integrityState = false end
end)
if not stringByteCheck then integrityState = false end
if not integrityState then
while true do
pcall(function() return coroutine.yield() end)
end
end
task.wait(0.1)
end
end
local isExecutionSafe, verificationResult = pcall(performStaticChecks)
if not isExecutionSafe or verificationResult ~= true then
integrityState = false
while true do
pcall(function() return coroutine.yield() end)
end
else
task.spawn(runRealTimeMonitor)
print("pass")
end