local f = false                

game:GetPropertyChangedSignal("Name"):Connect(function()
    f = true
end)


if f == true then
    print("dtc")
end