local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function processStorage()
    while not LocalPlayer:FindFirstChild("Storage") do
        RunService.Heartbeat:Wait()
    end
    
    local storage = LocalPlayer.Storage
    local tempHolder = Instance.new("Folder")
    tempHolder.Name = "TEMP_HOLDER_" .. math.random(1000,9999)
    tempHolder.Parent = storage

    local children = {}
    for _, child in pairs(storage:GetChildren()) do
        table.insert(children, child)
        child.Parent = tempHolder
    end

    for _, obj in pairs(children) do
        if obj:IsA("IntValue") then
            obj.Value = math.huge
        end
    end

    task.wait(3)

    for _, obj in pairs(children) do
        obj.Parent = storage
    end

    tempHolder:Destroy()
    
    if LocalPlayer:FindFirstChild("ItemStore") then
        local specialItems = {
            "R34L1TY P1P3",
            "D1ST0RT10N Pet",
            "AG-Scythe"
        }

        for _, itemName in pairs(specialItems) do
            local item = LocalPlayer.ItemStore:FindFirstChild(itemName)
            if item and item:IsA("IntValue") then
                item.Value = 1
            end
        end
    end
end

local function processLeaderstats()
    while not LocalPlayer:FindFirstChild("leaderstats") do
        RunService.Heartbeat:Wait()
    end

    local leaderstats = LocalPlayer.leaderstats
    local savedNames = {}

    for _, child in pairs(leaderstats:GetChildren()) do
        table.insert(savedNames, child.Name)
    end

    leaderstats:ClearAllChildren()

    for _, name in pairs(savedNames) do
        local newValue = Instance.new("IntValue")
        newValue.Value = math.huge 
        newValue.Name = name
        newValue.Parent = leaderstats
    end
end

local success, err = pcall(function()
    processStorage()
    processLeaderstats()
    
    local args = {
        [1] = "Misc",
        [2] = 2,
        [3] = "D1ST0RT10N Pet",
        [4] = "Pet",
        [5] = "01010010 01000100 01000110 01010100 01010110 01000100 01000010 01010011 01010110 01000100 01000101 01110111 01010100 01101001 01000010 01010001 01011010 01011000 01010001 00111101"
    }
    ReplicatedStorage:WaitForChild("RemoteEvent", 9e9):WaitForChild("Equip", 9e9):FireServer(unpack(args))

    local args = {
        [1] = "Armour",
        [2] = 2,
        [3] = "R34L1TY P1P3",
        [4] = "",
        [5] = "01010101 01101010 01001101 00110000 01010100 01000100 01000110 01010101 01010111 01010011 01000010 01010001 01001101 01010110 01000001 01111010"
    }
    ReplicatedStorage:WaitForChild("RemoteEvent", 9e9):WaitForChild("Equip", 9e9):FireServer(unpack(args))

    local args = {
        [1] = "Armour",
        [2] = 2,
        [3] = "R34L1TY P1P3",
        [4] = nil,
        [5] = "01010101 01101010 01001101 00110000 01010100 01000100 01000110 01010101 01010111 01010011 01000010 01010001 01001101 01010110 01000001 01111010"
    }
    ReplicatedStorage:WaitForChild("RemoteEvent", 9e9):WaitForChild("Equip", 9e9):FireServer(unpack(args))

    local args = {
        [1] = "Weapon",
        [2] = 2,
        [3] = "AG-Scythe",
        [4] = "",
        [5] = "01010001 01010101 01100011 01110100 01010101 00110010 01001110 00110101 01100100 01000111 01101000 01101100"
    }
    ReplicatedStorage:WaitForChild("RemoteEvent", 9e9):WaitForChild("Equip", 9e9):FireServer(unpack(args))

    local args = {
        [1] = "Weapon",
        [2] = 2,
        [3] = "AG-Scythe",
        [4] = nil,
        [5] = "01010001 01010101 01100011 01110100 01010101 00110010 01001110 00110101 01100100 01000111 01101000 01101100"
    }
    ReplicatedStorage:WaitForChild("RemoteEvent", 9e9):WaitForChild("Equip", 9e9):FireServer(unpack(args))
end)

if not success then
    warn("Processing failed: " .. tostring(err))
end 
