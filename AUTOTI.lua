local Players = game:GetService("Players")  
local Workspace = game:GetService("Workspace")  
local RunService = game:GetService("RunService")  
local StarterGui = game:GetService("StarterGui")
local antiafk = loadstring(game:HttpGet("https://raw.githubusercontent.com/DistortionAltFR/sans.rng/refs/heads/main/Antiafk.lua"))() 
local antilag = loadstring(game:HttpGet("https://raw.githubusercontent.com/DistortionAltFR/sans.rng/refs/heads/main/Antilag.lua"))()
local antikick = loadstring(game:HttpGet("https://raw.githubusercontent.com/DistortionAltFR/sans.rng/refs/heads/main/Antikick.lua"))()
local TARGET_PLACE_IDS = {  
    87841196505389,
    99198920478418, 
    82501772303548
}  

local DESTROY_FOLDERS = {"Attacks", "AttacksStuff"}  
local FIGHT_BUTTON_NAME = "FightButton"  

local LocalPlayer = Players.LocalPlayer  
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()  
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")  

local function sendNotification(title, message)  
    StarterGui:SetCore("SendNotification", {  
        Title = title,  
        Text = message,  
        Duration = 5  
    })  
end  

local function isTargetPlace()  
    return table.find(TARGET_PLACE_IDS, game.PlaceId) ~= nil  
end  

local function destroyTargetFolders()  
    for _, folderName in ipairs(DESTROY_FOLDERS) do  
        local folder = Workspace:FindFirstChild(folderName)  
        if folder then  
            folder:Destroy()  
            sendNotification("DESTROYED", folderName.." folder removed!")  
        end  
    end  
end  

local function hookFolderDestruction()  
    for _, folderName in ipairs(DESTROY_FOLDERS) do  
        Workspace.ChildAdded:Connect(function(child)  
            if child.Name == folderName then  
                task.wait(0.1)  
                child:Destroy()  
                sendNotification("BLOCKED", "New "..folderName.." destroyed!")  
            end  
        end)  
    end  
end  

local function clickAllButtons()  
    local Signals = {"Activated", "MouseButton1Down", "MouseButton2Down", "MouseButton1Click", "MouseButton2Click"}  
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")  
    if not playerGui then return false end  

    for _, button in ipairs(playerGui:GetDescendants()) do  
        if button:IsA("TextButton") or button:IsA("ImageButton") then  
            for _, signal in ipairs(Signals) do  
                if button[signal] then  
                    firesignal(button[signal])  
                end  
            end  
        end  
    end  

    sendNotification("FIGHT", "All buttons activated!")  
    return true  
end  

local function autoClickVoteButton()  
    if clickAllButtons() then return true end  
    
    local voteChecker  
    voteChecker = RunService.Heartbeat:Connect(function()  
        if clickAllButtons() then  
            voteChecker:Disconnect()  
        end  
    end)  
end  

local function setupFightTeleport()  
    local fightButton = Workspace:FindFirstChild(FIGHT_BUTTON_NAME)  
    if not fightButton then return end  

    local function teleportToTarget(target)  
        if target:IsA("BasePart") then  
            HumanoidRootPart.CFrame = target.CFrame  
        elseif target:IsA("Model") and target.PrimaryPart then  
            HumanoidRootPart.CFrame = target.PrimaryPart.CFrame  
        end  
        sendNotification("TELEPORT", "Moved to fight position!")  
    end  

    -- Handle existing targets  
    for _, child in ipairs(fightButton:GetChildren()) do  
        teleportToTarget(child)  
    end  

    -- Hook new targets  
    fightButton.ChildAdded:Connect(function(child)  
        task.wait(0.3)  
        teleportToTarget(child)  
    end)  
end  

-- Main Execution  
if isTargetPlace() then  
    sendNotification("SYSTEM ONLINE", "Auto-fight engaged!")  

    -- Destruction System  
    destroyTargetFolders()  
    hookFolderDestruction()  

    -- Fight Activation  
    autoClickVoteButton()  

    -- Teleport System  
    setupFightTeleport()  
else  
    sendNotification("SYSTEM OFFLINE", "Wrong game detected")  
end
