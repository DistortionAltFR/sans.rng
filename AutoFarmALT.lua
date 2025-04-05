local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local function FindRealOrionUI()
    for _, gui in ipairs(CoreGui:GetChildren()) do
        if gui.Name == "RobloxGui" then
            local orion = gui:FindFirstChild("Orion")
            if orion then
                -- Check for visible frames
                for _, frame in ipairs(orion:GetDescendants()) do
                    if frame:IsA("Frame") and frame.Visible == false then
                        return orion
                    end
                end
            end
        end
    end
    return nil
end

-- Create toggle UI button
local ToggleUI = Instance.new("ScreenGui")
local ToggleButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")
local UIDrag = Instance.new("UIDragDetector")

ToggleUI.Name = "OrionToggleUI"
ToggleUI.Parent = gethui() or LocalPlayer.PlayerGui
ToggleUI.ResetOnSpawn = false
ToggleUI.Enabled = false -- Start hidden since Orion is open initially

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ToggleUI
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Position = UDim2.new(0, 10, 0.5, -22)
ToggleButton.Image = "rbxassetid://15315284749"
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 186, 117)
ToggleButton.BorderColor3 = Color3.fromRGB(255, 186, 117)

UICorner.Parent = ToggleButton
UICorner.CornerRadius = UDim.new(0.2, 0)

UIDrag.Parent = ToggleButton


-- Function to update toggle button visibility
local function UpdateToggleVisibility()
    local orionUI = FindRealOrionUI()
    if orionUI then
        local anyVisible = false
        for _, frame in ipairs(orionUI:GetDescendants()) do
            if frame:IsA("Frame") then
                if frame.Visible then
                    anyVisible = true
                    break
                end
            end
        end
        ToggleUI.Enabled = not anyVisible
    else
        ToggleUI.Enabled = true
    end
end

-- Connect visibility changed events
local function SetupVisibilityTracking()
    local orionUI = FindRealOrionUI()
    if orionUI then
        for _, frame in ipairs(orionUI:GetDescendants()) do
            if frame:IsA("Frame") then
                frame:GetPropertyChangedSignal("Visible"):Connect(UpdateToggleVisibility)
            end
        end
    end
end

-- Toggle Orion UI visibility
ToggleButton.MouseButton1Click:Connect(function()
    local orionUI = FindRealOrionUI()
    if orionUI then
        local currentState = false
        for _, frame in ipairs(orionUI:GetDescendants()) do
            if frame:IsA("Frame") and frame.Visible then
                currentState = true
                break
            end
        end
        
        for _, frame in ipairs(orionUI:GetDescendants()) do
            if frame:IsA("Frame") then
                frame.Visible = not currentState
            end
        end
        UpdateToggleVisibility()
    end
end)

-- Initial setup
task.spawn(function()
    repeat task.wait(1) until FindRealOrionUI()
    SetupVisibilityTracking()
    UpdateToggleVisibility()
end)


local function SendNotification(title, text, duration)
    OrionLib:MakeNotification({
        Name = title,
        Content = text,
        Time = duration or 5
    })
end

if game.PlaceId ~= 91694942823334 then
    SendNotification("SCRIPT BLOCKED", "This script can only run in the correct game!", 5)
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

local whitelist = loadstring(game:HttpGet("https://raw.githubusercontent.com/DistortionAltFR/sans.rng/main/Whitelist.lua"))()

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
