local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()

local Window = redzlib:MakeWindow({
    Title = "typical.rng | Easy Farm",
    SubTitle = "Made by DistortionAltFR",
    SaveFolder = "typical_rng_AutoFarmConfig"
})

local Tab1 = Window:MakeTab({"Main", "settings"})
local Tab2 = Window:MakeTab({"Credits"})
local Tab3 = Window:MakeTab({"Misc"})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
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

local function SendNotification(title, text)
    Window:Dialog({
        Title = title,
        Text = text,
        Options = {{"OK", function() end}}
    })
end

if game.PlaceId ~= 91694942823334 then
    SendNotification("SCRIPT BLOCKED", "This script can only run in the correct game!")
    return
end

task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DistortionAltFR/sans.rng/refs/heads/main/antiafk.lua"))()
    print("External scripts loaded successfully.")
end)

SendNotification("AUTO-FARM LOADED!", "Made by DistortionAltFR | typical.rng")

local AutoClickToggle = Tab1:AddToggle({
    Name = "AutoClick",
    Description = "Automatically clicks Sans detectors.",
    Default = false,
    Callback = function(Value)
        if Value then
            AutoClickConnection = RunService.RenderStepped:Connect(function()
                UpdateDetectors()
                FireDetectors()
            end)
            SendNotification("AutoClick Enabled", "AutoClick has been turned ON.")
        else
            if AutoClickConnection then
                AutoClickConnection:Disconnect()
                AutoClickConnection = nil
            end
            SendNotification("AutoClick Disabled", "AutoClick has been turned OFF.")
        end
    end
})

Tab2:AddSection({"Credits"})
Tab2:AddParagraph({"Version:", "1.0"})
Tab2:AddParagraph({"Made by:", "DistortionAltFR"})

local MiscButton = Tab3:AddButton({"Grinding Mode", function()
    SendNotification("Grinding Mode Activated", "Enjoy.")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DistortionAltFR/sans.rng/refs/heads/main/ExtremeGrindMode.lua"))()
end})

Tab3:AddParagraph({"Disclaimer:", "Enabling this will remove all UI, unnecessary models, replacing them with a black screen for maximum CPU efficiency. Ideal for overnight farming."})

Window:SelectTab(Tab1)
RunService.Heartbeat:Connect(UpdateDetectors)
DisableCharacterTouch()
LocalPlayer.CharacterAdded:Connect(DisableCharacterTouch)
