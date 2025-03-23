--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

--// Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

--// Check Place ID
if game.PlaceId ~= 91694942823334 then
    Rayfield:Notify({
        Title = "SCRIPT BLOCKED",
        Content = "This script can only run in the correct game!",
        Duration = 5,
        Type = "Warning"
    })
    return
end

--// UI Creation
local Window = Rayfield:CreateWindow({
    Name = "AutoClicker Pro",
    LoadingTitle = "AutoClicker Pro",
    LoadingSubtitle = "Made by DistortionAltFR | typical.rng",
    ConfigurationSaving = {
        Enabled = false,
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false
})

local MainTab = Window:CreateTab("AutoClicker", 4483362458) -- Tab Icon (Roblox Click Icon)

--// AutoClick Toggle
local Active = false
local AutoClickConnection
local ClickDetectors = setmetatable({}, {__mode = "k"})

local DetectorMT = {
    __index = {
        Destroy = function(self)
            ClickDetectors[self.Instance] = nil
        end,
        Fire = function(self)
            if self.Instance.Parent then
                fireclickdetector(self.Instance, 1, true)
            end
        end
    }
}

local SansesFolder = workspace:FindFirstChild("Sanses")

local function UpdateDetectors()
    if not SansesFolder then return end

    for _, sansModel in pairs(SansesFolder:GetChildren()) do
        local clickHitbox = sansModel:FindFirstChild("ClickHitbox")
        if clickHitbox then
            local clickDetector = clickHitbox:FindFirstChildOfClass("ClickDetector")
            if clickDetector and not ClickDetectors[clickDetector] then
                ClickDetectors[clickDetector] = setmetatable({Instance = clickDetector}, DetectorMT)
            end
        end
    end
end

local function FireDetectors()
    for _, data in pairs(ClickDetectors) do
        task.spawn(data.Fire, data)
    end
end

local ToggleButton = MainTab:CreateToggle({
    Name = "AutoClicker",
    CurrentValue = false,
    Flag = "AutoClickToggle",
    Callback = function(Value)
        Active = Value
        if Active then
            AutoClickConnection = RunService.RenderStepped:Connect(function()
                UpdateDetectors()
                FireDetectors()
            end)
            Rayfield:Notify({
                Title = "AutoClicker Activated",
                Content = "AutoClicker is now ON!",
                Duration = 3,
                Type = "Success"
            })
        else
            if AutoClickConnection then
                AutoClickConnection:Disconnect()
                AutoClickConnection = nil
            end
            Rayfield:Notify({
                Title = "AutoClicker Deactivated",
                Content = "AutoClicker is now OFF!",
                Duration = 3,
                Type = "Warning"
            })
        end
    end
})

--// Disable CanTouch for Player
local function DisableCharacterTouch()
    local character = LocalPlayer.Character
    if character then
        for _, descendant in pairs(character:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.CanTouch = false
            end
        end
    end
end

LocalPlayer.CharacterAdded:Connect(DisableCharacterTouch)
DisableCharacterTouch()

--// Auto-Update ClickDetectors on new Sanses
if SansesFolder then
    SansesFolder.ChildAdded:Connect(function()
        task.defer(UpdateDetectors)
    end)

    SansesFolder.ChildRemoved:Connect(function()
        task.defer(function()
            for detector, data in pairs(ClickDetectors) do
                if detector.Parent == nil or detector.Parent.Parent == nil then
                    data:Destroy()
                end
            end
        end)
    end)
end

RunService.Heartbeat:Connect(UpdateDetectors)

Rayfield:Notify({
    Title = "AutoClicker Pro Loaded!",
    Content = "Your script is now ready to use!",
    Duration = 5,
    Type = "Success"
})
