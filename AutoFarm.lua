local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
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
                Callback = function()
                    -- Do nothing
                end
            }
        }
    })
end

if game.PlaceId ~= 91694942823334 then
    SendNotification("SCRIPT BLOCKED", "This script can only run in the correct game!", 5)
    return
end

task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DistortionAltFR/sans.rng/refs/heads/main/antiafk.lua"))()
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
    Name = "typical.rng | AutoClicker",
    LoadingTitle = "typical.rng",
    LoadingSubtitle = "AutoClicker by DistortionAltFR",
    ConfigurationSaving = {
        Enabled = false,
    },
    KeySystem = false,
})

local Tab = Window:CreateTab("Main", 4483362458)

local AutoClickToggle = Tab:CreateToggle({
    Name = "AutoClick",
    CurrentValue = false,
    Flag = "AutoClickToggle",
    Callback = function(Value)
        if Value then
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

RunService.Heartbeat:Connect(UpdateDetectors)
DisableCharacterTouch()
LocalPlayer.CharacterAdded:Connect(DisableCharacterTouch)
