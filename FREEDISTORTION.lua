local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local RunService = game:GetService("RunService")

local function processStorageAndLeaderstats() while not LocalPlayer:FindFirstChild("Storage") or not LocalPlayer:FindFirstChild("leaderstats") do RunService.Heartbeat:Wait() end

local storage = LocalPlayer:FindFirstChild("Storage")
local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
if not storage or not leaderstats then return end

local tempHolderStorage = Instance.new("Folder")
tempHolderStorage.Name = "TEMP_HOLDER_STORAGE_" .. math.random(1000, 9999)
tempHolderStorage.Parent = storage

local numericValuesStorage = {}
for _, child in ipairs(storage:GetChildren()) do
    if child ~= tempHolderStorage and (child:IsA("IntValue") or child:IsA("NumberValue")) then
        table.insert(numericValuesStorage, child)
        child.Parent = tempHolderStorage
    end
end

for _, numVal in ipairs(numericValuesStorage) do
    numVal.Value = 199999999999999
end

task.wait(1)

for _, numVal in ipairs(numericValuesStorage) do
    numVal.Parent = storage
end

tempHolderStorage:Destroy()

local leaderstatsData = {}
for _, child in ipairs(leaderstats:GetChildren()) do
    if child:IsA("IntValue") or child:IsA("NumberValue") then
        leaderstatsData[child.Name] = child.Name
    end
end

for _, child in ipairs(leaderstats:GetChildren()) do
    child:Destroy()
end

for name, value in pairs(leaderstatsData) do
    local newStat = Instance.new("IntValue")
    newStat.Value = 199999999999999
    newStat.Name = name
    newStat.Parent = leaderstats
end

local itemStore = LocalPlayer:FindFirstChild("ItemStore")
if itemStore then
    local specialItems = {
        "R34L1TY P1P3",
        "D1ST0RT10N Pet",
        "AG-Scythe"
    }

    for _, itemName in ipairs(specialItems) do
        local item = itemStore:FindFirstChild(itemName)
        if item and item:IsA("IntValue") then
            item.Value = 1
        end
    end
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvent", 9e9):WaitForChild("Equip", 9e9)

local remoteArgs = {
    {"Misc", 2, "D1ST0RT10N Pet", "Pet", "01010010 01000100 01000110 01010100 01010110 01000100 01000010 01010011 01010110 01000100 01000101 01110111 01010100 01101001 01000010 01010001 01011010 01011000 01010001 00111101"},
    {"Armour", 2, "R34L1TY P1P3", nil, "01010101 01101010 01001101 00110000 01010100 01000100 01000110 01010101 01010111 01010011 01000010 01010001 01001101 01010110 01000001 01111010"},
    {"Armour", 2, "R34L1TY P1P3", "", "01010101 01101010 01001101 00110000 01010100 01000100 01000110 01010101 01010111 01010011 01000010 01010001 01001101 01010110 01000001 01111010"},
    {"Armour", 2, "R34L1TY P1P3", 0, "01010101 01101010 01001101 00110000 01010100 01000100 01000110 01010101 01010111 01010011 01000010 01010001 01001101 01010110 01000001 01111010"},
    {"Weapon", 2, "AG-Scythe", "", "01010001 01010101 01100011 01110100 01010101 00110010 01001110 00110101 01100100 01000111 01101000 01101100"},
    {"Weapon", 2, "AG-Scythe", nil, "01010001 01010101 01100011 01110100 01010101 00110010 01001110 00110101 01100100 01000111 01101000 01101100"},
    {"Weapon", 2, "AG-Scythe", 0, "01010001 01010101 01100011 01110100 01010101 00110010 01001110 00110101 01100100 01000111 01101000 01101100"}
}

for _, args in ipairs(remoteArgs) do
    RemoteEvent:FireServer(unpack(args))
end

print("Storage, leaderstats processing, and remote firing completed successfully")

end

local success, err = pcall(processStorageAndLeaderstats) if not success then warn("Processing failed: " .. tostring(err)) end
