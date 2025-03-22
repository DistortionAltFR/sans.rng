local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

-- Function to send notifications with a fallback
local function SendNotification(title, text, duration, buttonText)
    if StarterGui.SetCore then
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Button1 = buttonText or "OK",
            Duration = duration or 5
        })
    else
        -- Fallback method if SetCore is not available
        warn("Notification: " .. title .. " - " .. text)
    end
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

SendNotification("AUTO-FARM LOADED!", "Made by DistortionAltFR | typical.rng", 5, "OK")

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

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoClickerPro"
ScreenGui.Parent = CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 50)
Frame.Position = UDim2.new(0.5, -100, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BackgroundTransparency = 0.1
Frame.Active = true

local UIStroke = Instance.new("UIStroke")
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(100, 100, 100)
UIStroke.Parent = Frame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
})
UIGradient.Parent = Frame

local UIDragDetector = Instance.new("UIDragDetector")
UIDragDetector.Parent = Frame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.9, 0, 0.8, 0)
ToggleButton.Position = UDim2.new(0.05, 0, 0.1, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
ToggleButton.Text = "AutoClick: OFF"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.ZIndex = 2

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = ToggleButton

ToggleButton.Parent = Frame

local Active = false
local AutoClickConnection

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

local function Toggle()
    Active = not Active
    ToggleButton.Text = "AutoClick: " .. (Active and "ON" or "OFF")
    ToggleButton.BackgroundColor3 = Active and Color3.fromRGB(60, 200, 60) or Color3.fromRGB(200, 60, 60)

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

ToggleButton.MouseButton1Click:Connect(Toggle)
RunService.Heartbeat:Connect(UpdateDetectors)

Frame.Parent = ScreenGui
DisableCharacterTouch()
LocalPlayer.CharacterAdded:Connect(DisableCharacterTouch)
