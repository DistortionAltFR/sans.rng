local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/refs/heads/main/source.lua"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local function SendNotification(title, text, duration)
    Rayfield:Notify({
        Title = title,
        Content = text,
        Duration = duration or 5,
        Actions = {
            Ignore = {
                Name = "OK",
                Callback = function() end
            }
        }
    })
end

if game.PlaceId ~= 91694942823334 then
    SendNotification("SCRIPT BLOCKED", "This script can only run in the correct game!", 5)
    return
end

task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DistortionAltFR/sans.rng/refs/heads/main/Antilag.lua"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DistortionAltFR/sans.rng/refs/heads/main/Antiafk.lua"))()
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

local Window = Rayfield:CreateWindow({
    Name = "typical.rng | Easy Farm",
    LoadingTitle = "typical.rng | AutoFarm",
    LoadingSubtitle = "Made by DistortionAltFR",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "typical.rng",
        FileName = "AutoFarmConfig"
    },
    KeySystem = false,
    Theme = "DarkBlue"
})

local MainTab = Window:CreateTab("Main", 4483362458)
local AutoClickToggle = MainTab:CreateToggle({
    Name = "AutoClick",
    CurrentValue = false,
    Flag = "AutoClickToggle",
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
})

local CreditsTab = Window:CreateTab("Credits", 4483362458)
CreditsTab:CreateSection("Credits")
CreditsTab:CreateLabel("Version: 1.0")
CreditsTab:CreateLabel("Made by DistortionAltFR")

local MiscTab = Window:CreateTab("Misc", 4483362458)
local MiscButton = MiscTab:CreateButton({
    Name = "Grinding Mode",
    Callback = function()
        SendNotification("Grinding Mode Activated", "Enjoy.", 3)
        loadstring(game:HttpGet('https://raw.githubusercontent.com/DistortionAltFR/sans.rng/refs/heads/main/ExtremeGrindMode.lua'))()
    end,
})

MiscTab:CreateParagraph({
    Title = "Disclaimer:",
    Content = "Enabling this will remove all UI, unnecessary models, replacing them with a black screen for maximum CPU efficiency. Ideal for overnight farming."
})

Rayfield:LoadConfiguration()
RunService.Heartbeat:Connect(UpdateDetectors)
DisableCharacterTouch()
LocalPlayer.CharacterAdded:Connect(DisableCharacterTouch)
