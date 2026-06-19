local p = Instance.new("Part")     
local e = 0                       


for i = 1, 25 do
    if p.Anchored == false then
        e = e + 1
    end
end

if e ~= 25 then
    print("dtc")
end