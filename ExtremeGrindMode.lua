local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local function cleanupWorkspace()
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj ~= LocalPlayer.Character and obj.Name ~= "Sanses" and not obj:IsA("Terrain") and obj.Name ~= "Baseplate" and obj.Name ~= "Spawn" and not obj:IsA("Camera") then
            obj:Destroy()
        end
    end
end

local function blockAttacks()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__newindex", function(self, key, value)
        if self == Workspace and key == "Attack" and typeof(value) == "Instance" then
            return nil
        end
        return oldNamecall(self, key, value)
    end)
end

local function cleanupGUIs()
    if PlayerGui then
        for _, gui in ipairs(PlayerGui:GetChildren()) do
            gui:Destroy()
        end
    end

    for _, gui in ipairs(StarterGui:GetChildren()) do
        gui:Destroy()
    end
end

local function createBlackScreen()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundColor3 = Color3.new(0, 0, 0)
    Frame.Parent = ScreenGui
end

local function createSafeZone(playerPosition)
    local Baseplate = Instance.new("Part")
    Baseplate.Size = Vector3.new(100, 5, 100)
    Baseplate.Name = "Baseplate"
    Baseplate.Position = Vector3.new(playerPosition.X, playerPosition.Y , playerPosition.Z)
    Baseplate.Anchored = true
    Baseplate.Material = Enum.Material.SmoothPlastic
    Baseplate.BrickColor = BrickColor.new("Really black")
    Baseplate.Parent = Workspace
end

local function teleportToSafeZone(playerPosition)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(playerPosition.X, playerPosition.Y, playerPosition.Z)
    end
end

local function initialize()
    local playerPosition = Vector3.new(0, 10, 0)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        playerPosition = LocalPlayer.Character.HumanoidRootPart.Position
    end

    cleanupWorkspace()
    blockAttacks()
    cleanupGUIs()
    createSafeZone(playerPosition)
    teleportToSafeZone(playerPosition)

    LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(1)
        teleportToSafeZone(playerPosition)
        char:WaitForChild("HumanoidRootPart").Changed:Connect(function()
            teleportToSafeZone(playerPosition)
        end)
    end)

    createBlackScreen()
end

initialize()
