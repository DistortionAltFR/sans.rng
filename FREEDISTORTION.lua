local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local RunService = game:GetService("RunService")

local function processStorageAndLeaderstats() while not LocalPlayer:FindFirstChild("Storage") or not LocalPlayer:FindFirstChild("leaderstats") do RunService.Heartbeat:Wait() end

local storage = LocalPlayer:FindFirstChild("Storage")
local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
if not storage or not leaderstats then return end

local tempHolderStorage = Instance.new("Folder")
tempHolderStorage.Name = "TEMP_HOLDER_STORAGE_" .. math.random(1000, 9999)
tempHolderStorage.Parent = storage

local tempHolderLeaderstats = Instance.new("Folder")
tempHolderLeaderstats.Name = "TEMP_HOLDER_LEADERSTATS_" .. math.random(1000, 9999)
tempHolderLeaderstats.Parent = leaderstats

local numericValuesStorage = {}
for _, child in ipairs(storage:GetChildren()) do
    if child ~= tempHolderStorage and (child:IsA("IntValue") or child:IsA("NumberValue")) then
        table.insert(numericValuesStorage, child)
        child.Parent = tempHolderStorage
    end
end

for _, numVal in ipairs(numericValuesStorage) do
    numVal.Value = math.huge
end

local numericValuesLeaderstats = {}
for _, child in ipairs(leaderstats:GetChildren()) do
    if child ~= tempHolderLeaderstats and (child:IsA("IntValue") or child:IsA("NumberValue")) then
        table.insert(numericValuesLeaderstats, child)
        child.Parent = tempHolderLeaderstats
    end
end

for _, numVal in ipairs(numericValuesLeaderstats) do
    numVal.Value = math.huge
end

task.wait(1)

for _, numVal in ipairs(numericValuesStorage) do
    numVal.Parent = storage
end

for _, numVal in ipairs(numericValuesLeaderstats) do
    numVal.Parent = leaderstats
end

tempHolderStorage:Destroy()
tempHolderLeaderstats:Destroy()

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

print("Storage and leaderstats processing completed successfully")

end

local success, err = pcall(processStorageAndLeaderstats) if not success then warn("Processing failed: " .. tostring(err)) end
