-- by socolata
local function runAdvancedDiagnostic()
local startTime = os.clock()
for i = 1, 1000 do 
local _ = math.sin(i) 
end
local duration = os.clock() - startTime
if duration > 0.05 then 
return false 
end
local callerOk, callerSource = pcall(function() 
return debug.info(3, "s") 
end)
if callerOk and callerSource then
if string.find(callerSource, "=\[") or string.find(callerSource, "string") then 
return false 
end
end
local _, err = pcall(function() 
return loadstring("local a = 1")() 
end)
if err and (string.find(string.lower(err), "log") or string.find(string.lower(err), "env")) then
return false 
end
local testFunc = math.random
local isNative = pcall(function() 
return debug.info(testFunc, "a") == 0 
end)
if not isNative then 
return false 
end
return true
end
local success, state = pcall(runAdvancedDiagnostic)
if not success or state ~= true then
while true do 
pcall(function() 
return coroutine.yield() 
end) 
end
else
print("pass")
end