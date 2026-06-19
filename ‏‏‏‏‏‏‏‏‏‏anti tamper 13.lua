local function validateTraceback()
    local function analyze(target)
        local leaked = false
        local ok = xpcall(function()
            target() 
        end, function(err)
            local trace = debug.traceback()
            if not string.find(trace, "C function") and not string.find(trace, "[C]") then
                leaked = true
            end
        end)
        return not leaked
    end
    return analyze(math.abs) and analyze(string.len) and analyze(table.insert)
end

if validateTraceback() then
    print("passed")
else
    print("detected")
end