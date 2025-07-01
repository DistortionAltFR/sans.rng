local OrionLib = loadstring(game:HttpGet(("https://raw.githubusercontent.com/Giangplay/Script/main/Orion_Library_PE_V2.lua")))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local function SendNotification(title, text, duration)
    OrionLib:MakeNotification({
        Name = title,
        Content = text,
        Time = duration or 5
    })
end

SendNotification("AUTO-FARM LOADED!", "Made by DistortionAltFR | unnamed sans.rng", 5)

local ClickDetectors = setmetatable({}, {__mode = "k"})
local DetectorMT = {
    __index = {
        Destroy = function(self)
            ClickDetectors[self.Instance] = nil
        end,
        Fire = function(self, times)
            if self.Instance.Parent then
                for _ = 1, times do
                    local clone = self.Instance:Clone()
                    clone.Parent = self.Instance.Parent
                    fireclickdetector(clone)
                    fireclickdetector(self.Instance)
                    clone:Destroy()
                end
            end
        end
    }
}

local SansesFolder = workspace:FindFirstChild("Enemies")

local function UpdateDetectors()
    if not SansesFolder then return end

    for detector, data in pairs(ClickDetectors) do
        if not detector.Parent or not detector.Parent.Parent then
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

_G.MASSIVE_MODE = false

local function FireDetectors()
    for _, data in pairs(ClickDetectors) do
        if _G.MASSIVE_MODE then
            for _ = 1, 10 do
                task.spawn(function()
                    for _ = 1, 10 do
                        task.spawn(function()
                            data:Fire(1)
                        end)
                    end
                end)
            end
        else
            for _ = 1, 20 do
                task.spawn(function()
                    data:Fire(1)
                end)
            end
        end
    end
end

local function setSetting(settingName, value)
    ReplicatedStorage:WaitForChild("SettingSaver"):FireServer(settingName, value)
end

local Window = OrionLib:MakeWindow({
    Name = "unnamed sans.rng | Easy Farm",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "unnamed sans.rng"
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

local MassiveButton = MiscTab:AddButton({
    Name = "Toggle Massive Mode",
    Callback = function()
        _G.MASSIVE_MODE = not _G.MASSIVE_MODE
        local status = _G.MASSIVE_MODE and "ENABLED" or "DISABLED"
        SendNotification("Massive Mode", "Massive mode is now " .. status, 3)
    end
})

local MiscButton = MiscTab:AddButton({
    Name = "Grinding Mode",
    Callback = function()
        SendNotification("Grinding Mode Activated", "Enjoy.", 3)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/DistortionAltFR/sans.rng/refs/heads/main/ExtremeGrindMode.lua"))()
    end
})

MiscTab:AddParagraph("Disclaimer:", "Enabling this will remove all UI, unnecessary models, replacing them with a black screen for maximum CPU efficiency. Ideal for overnight farming.")

OrionLib:Init()

loadstring(game:HttpGet("https://raw.githubusercontent.com/DistortionAltFR/sans.rng/refs/heads/main/Godmode.lua"))()

RunService.Heartbeat:Connect(UpdateDetectors)

setSetting("Epilepsy", true)
setSetting("LowQuality", true)
