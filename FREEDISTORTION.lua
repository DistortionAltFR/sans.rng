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

local success, err = pcall(processStorageAndLeaderstats) if not success then warn("Processing failed: " .. tostring(err)) end
