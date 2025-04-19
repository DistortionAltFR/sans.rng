-- Full identity spoof script
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Target spoofed identity
local SPOOFED_NAME = "Nicegail2222ALT"

-- Backup original names (just in case)
local originalName = LocalPlayer.Name
local originalDisplayName = LocalPlayer.DisplayName

-- Get and hook the raw metatable
local mt = getrawmetatable(game)
setreadonly(mt, false)

local oldIndex = mt.__index

mt.__index = newcclosure(function(self, key)
    if self == LocalPlayer then
        if key == "Name" or key == "DisplayName" then
            return SPOOFED_NAME
        end
    end

    -- Character name spoof
    if typeof(self) == "Instance" and self:IsA("Model") and self == LocalPlayer.Character then
        if key == "Name" then
            return SPOOFED_NAME
        end
    end

    return oldIndex(self, key)
end)

setreadonly(mt, true)
print("Successfully spoofed name to:", SPOOFED_NAME)

-- Hook character name on spawn
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1) -- Wait for character to load
    char.Name = SPOOFED_NAME
end)

-- If character already exists, spoof it immediately
if LocalPlayer.Character then
    LocalPlayer.Character.Name = SPOOFED_NAME
end
