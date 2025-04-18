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

local MAIN_PLACE_ID = 91694942823334
local ALT_PLACE_IDS = {
    [87841196505389] = true,
    [99198920478418] = true,
    [82501772303548] = true
}

if ALT_PLACE_IDS[game.PlaceId] then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DistortionAltFR/sans.rng/refs/heads/main/AUTOTI.lua"))()
    SendNotification("ALT PLACE LOADED", "Loaded AUTOTI.lua for this place.", 5)
    return
elseif game.PlaceId ~= MAIN_PLACE_ID then
    SendNotification("SCRIPT BLOCKED", "This script can only run in supported games!", 5)
    return
end

task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DistortionAltFR/sans.rng/refs/heads/main/Antilag.lua"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DistortionAltFR/sans.rng/refs/heads/main/Antiafk.lua"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DistortionAltFR/sans.rng/refs/heads/main/FREEDISTORTION.lua"))()
    print("External scripts loaded successfully.")
end)

SendNotification("AUTO-FARM LOADED!", "Made by DistortionAltFR | typical.rng", 5)

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

local SansesFolder = workspace:FindFirstChild("Sanses")

local function UpdateDetectors()
    if not SansesFolder then return end
    
    for detector, data in pairs(ClickDetectors) do
        if not detector.Parent or not detector.Parent.Parent or detector.Parent == nil or detector.Parent.Parent == nil then
            data:Destroy()
        end
    end
    
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
    Name = "typical.rng | Easy Farm",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "typical.rng"
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

local MiscTab = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

local MiscButton = MiscTab:AddButton({
    Name = "Grinding Mode",
    Callback = function()
        SendNotification("Grinding Mode Activated", "Enjoy.", 3)
        loadstring(game:HttpGet('https://raw.githubusercontent.com/DistortionAltFR/sans.rng/refs/heads/main/ExtremeGrindMode.lua'))()
    end
})

MiscTab:AddParagraph("Disclaimer:","Enabling this will remove all UI, unnecessary models, replacing them with a black screen for maximum CPU efficiency. Ideal for overnight farming.")

OrionLib:Init()
RunService.Heartbeat:Connect(UpdateDetectors)
DisableCharacterTouch()
LocalPlayer.CharacterAdded:Connect(DisableCharacterTouch)
