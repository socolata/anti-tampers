local AS = cloneref and cloneref(game:GetService("AssetService")) or game:GetService("AssetService")
local function checkMeshStability()
    local pass = false
    local success = pcall(function()
        if not AS or not AS.CreateEditableMesh then return end
        local mesh = AS:CreateEditableMesh()
        if not mesh then return end
        local MS911_v1 = mesh:AddVertex(Vector3.new(0, 0, 0))
        local MS911_v2 = mesh:AddVertex(Vector3.new(1, 0, 0))
        local MS911_v3 = mesh:AddVertex(Vector3.new(0, 1, 0))
        local verts = mesh:GetVertices()
        local p1 = mesh:GetPosition(MS911_v1)
        mesh:Destroy()
        if verts and #verts == 3 and p1 and p1.X == 0 then
            pass = true
        end
    end)
    return success and pass
end
if checkMeshStability() then
    print("pass")
else
    print("detected")
end