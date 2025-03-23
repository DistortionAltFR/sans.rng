-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

-- Prevent execution outside of the intended game
if game.PlaceId ~= 91694942823334 then
    warn("SCRIPT BLOCKED: Incorrect Game")
    return
end

-- Load external scripts
task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DistortionAltFR/sans.rng/refs/heads/main/antiafk.lua"))()
    print("External scripts loaded successfully.")
end)

-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
if not Rayfield then
    warn("Failed to load Rayfield UI")
    return
end

-- Create Window UI
local Window = Rayfield:CreateWindow({
    Name = "AutoClickerPro",
    LoadingTitle = "AutoClicker",
    LoadingSubtitle = "Optimized for performance",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false }
})

-- Single Tab
local AutoFarmTab = Window:CreateTab("Main")

-- AutoClick Toggle Variable
local AutoClickActive = false
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

-- Function to update ClickDetectors
local function UpdateDetectors()
    if not SansesFolder then return end
    for _, sansModel in pairs(SansesFolder:GetChildren()) do
        local clickHitbox = sansModel:FindFirstChild("ClickHitbox")
        if clickHitbox then
            local clickDetector = clickHitbox:FindFirstChildOfClass("ClickDetector")
            if clickDetector and not ClickDetectors[clickDetector] then
                ClickDetectors[clickDetector] = setmetatable({ Instance = clickDetector }, DetectorMT)
            end
        end
    end
end

-- Function to fire ClickDetectors
local function FireDetectors()
    for _, data in pairs(ClickDetectors) do
        task.spawn(data.Fire, data)
    end
end

-- Function to toggle AutoClick
local function ToggleAutoClick(state)
    AutoClickActive = state
    if AutoClickActive then
        AutoClickConnection = RunService.RenderStepped:Connect(function()
            UpdateDetectors()
            FireDetectors()
        end)
    else
        if AutoClickConnection then
            AutoClickConnection:Disconnect()
            AutoClickConnection = nil
        end
    end
end

-- Add Toggle Button to Rayfield UI
AutoFarmTab:CreateToggle({
    Name = "AutoClicker",
    CurrentValue = false,
    Flag = "AutoClickToggle",
    Callback = ToggleAutoClick
})

-- Disable Character `CanTouch`
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

-- Minimized Mode (Draggable Icon)
local Minimized = false
local MinimizeButton = Window:CreateButton({
    Name = "⏷ Minimize UI",
    Callback = function()
        Minimized = not Minimized
        if Minimized then
            Window:Minimize()
        else
            Window:Maximize()
        end
    end
})

-- Keep Detectors Updated
RunService.Heartbeat:Connect(UpdateDetectors)
LocalPlayer.CharacterAdded:Connect(DisableCharacterTouch)
DisableCharacterTouch()
