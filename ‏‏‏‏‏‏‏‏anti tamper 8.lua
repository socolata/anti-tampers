local AS = cloneref and cloneref(game:GetService("AssetService")) or game:GetService("AssetService")
local function checkMeshStability()
    local pass = false
    local success = pcall(function()
        if not AS or not AS.CreateEditableMesh then return end
        local mesh = AS:CreateEditableMesh()
        if not mesh then return end
        local randX = math.random(5, 50) + math.random()
        local randY = math.random(5, 50) + math.random()
        local randZ = math.random(5, 50) + math.random()
        local extraVertsCount = math.random(2, 5)
        local MS911_v1 = mesh:AddVertex(Vector3.new(0, 0, 0))
        local MS911_v2 = mesh:AddVertex(Vector3.new(randX, randY, randZ))
        for i = 1, extraVertsCount do
            mesh:AddVertex(Vector3.new(i, i, i))
        end
        local verts = mesh:GetVertices()
        if not verts or #verts ~= (2 + extraVertsCount) then 
            mesh:Destroy()
            return 
        end
        local p2 = mesh:GetPosition(MS911_v2)
        mesh:Destroy()
        if p2 and math.abs(p2.X - randX) < 1e-4 and math.abs(p2.Y - randY) < 1e-4 and math.abs(p2.Z - randZ) < 1e-4 then
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