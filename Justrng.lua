local OrionLib = loadstring(game:HttpGet(("https://raw.githubusercontent.com/Giangplay/Script/main/Orion_Library_PE_V2.lua")))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local function SendNotification(title, text, duration)
    OrionLib:MakeNotification({
        Name = title,
        Content = text,
        Time = duration or 5
    })
end

local MAIN_PLACE_ID = 114283239905753

if game.PlaceId ~= MAIN_PLACE_ID then
    SendNotification("SCRIPT BLOCKED", "This script can only run in supported games!", 5)
    return
end

task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DistortionAltFR/sans.rng/refs/heads/main/Antilag.lua"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DistortionAltFR/sans.rng/refs/heads/main/Antiafk.lua"))()
    print("External scripts loaded successfully.")
end)

SendNotification("AUTO-FARM LOADED!", "Made by DistortionAltFR | JUST RNG", 5)

local ClickDetectors = setmetatable({}, {__mode = "k"})
local DetectorMT = {
    __index = {
        Destroy = function(self)
            ClickDetectors[self.Instance] = nil
        end,
        Fire = function(self)
            if self.Instance.Parent then
                fireclickdetector(self.Instance)
            end
        end
    }
}

local EntitiesFolder = workspace:FindFirstChild("Sans")

local function UpdateDetectors()
    if not EntitiesFolder then return end
    
    for detector, data in pairs(ClickDetectors) do
        if not detector.Parent or not detector.Parent.Parent or detector.Parent == nil or detector.Parent.Parent == nil then
            data:Destroy()
        end
    end
    
    for _, entity in pairs(EntitiesFolder:GetChildren()) do
        local mainPart = entity:FindFirstChild("Main")
        if mainPart then
            local clickDetector = mainPart:FindFirstChildOfClass("ClickDetector")
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

local Window = OrionLib:MakeWindow({
    Name = "JUST RNG| Easy Farm",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "CrazySkeletonRandomizer"
})

local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

local AutoClickToggle = MainTab:AddToggle({
    Name = "AutoClick",
    Default = false,
    Callback = function(Value)
        if Value then
            AutoClickConnection = RunService.RenderStepped:Connect(function()
                UpdateDetectors()
                FireDetectors()
            end)
            SendNotification("AutoClick Enabled", "AutoClick has been turned ON.", 3)
        else
            if AutoClickConnection then
                AutoClickConnection:Disconnect()
                AutoClickConnection = nil
            end
            SendNotification("AutoClick Disabled", "AutoClick has been turned OFF.", 3)
        end
    end,
    Flag = "AutoClickToggle",
    Save = true
})

local CreditsTab = Window:MakeTab({
    Name = "Credits",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

CreditsTab:AddSection({
    Name = "Credits"
})

CreditsTab:AddLabel("Version: 1.0")
CreditsTab:AddLabel("Made by DistortionAltFR")

OrionLib:Init()
RunService.Heartbeat:Connect(UpdateDetectors)
DisableCharacterTouch()
LocalPlayer.CharacterAdded:Connect(DisableCharacterTouch) 
