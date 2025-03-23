local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Rayfield Window
local Window = Rayfield:CreateWindow({
    Name = "typical.rng | AutoClicker",
    LoadingTitle = "Loading AutoClicker...",
    LoadingSubtitle = "by DistortionAltFR",
    ConfigurationSaving = {
        Enabled = false,
    },
    KeySystem = false,
})

-- Create Tab
local Tab = Window:CreateTab("AutoClicker", 4483362458)

-- Create Section
local Section = Tab:CreateSection("AutoClicker Settings")

-- Initialize ClickDetectors
local ClickDetectors = setmetatable({}, {__mode = "k"})
local DetectorMT = {
    __index = {
        Destroy = function(self)
            ClickDetectors[self.Instance] = nil
        end,
        Fire = function(self)
            if self.Instance and self.Instance.Parent then
                fireclickdetector(self.Instance, 1, true)
            end
        end
    }
}

-- Function to update detectors
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

-- Function to fire detectors
local function FireDetectors()
    for _, data in pairs(ClickDetectors) do
        task.spawn(data.Fire, data)
    end
end

-- Toggle for AutoClick
local Active = false
local AutoClickConnection

local AutoClickToggle = Tab:CreateToggle({
    Name = "AutoClick",
    CurrentValue = false,
    Flag = "AutoClickToggle",
    Callback = function(Value)
        Active = Value
        if Active then
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
    end,
})

-- Function to disable character touch
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

-- Initialize SansesFolder
local SansesFolder = workspace:FindFirstChild("Sanses")

if SansesFolder then
    SansesFolder.ChildAdded:Connect(function(child)
        task.defer(UpdateDetectors)
    end)

    SansesFolder.ChildRemoved:Connect(function(child)
        task.defer(function()
            for detector, data in pairs(ClickDetectors) do
                if detector.Parent == nil or detector.Parent.Parent == nil then
                    data:Destroy()
                end
            end
        end)
    end)
end

-- Disable character touch on character added
LocalPlayer.CharacterAdded:Connect(DisableCharacterTouch)

-- Initial disable character touch
DisableCharacterTouch()

-- Notify user
Rayfield:Notify({
    Title = "AUTO-FARM LOADED!",
    Content = "Made by DistortionAltFR | typical.rng",
    Duration = 5,
    Image = 4483362458,
})
