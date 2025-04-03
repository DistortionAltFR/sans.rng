local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local RunService = game:GetService("RunService")

local function processStorage()
while not LocalPlayer:FindFirstChild("Storage") do RunService.Heartbeat:Wait() end

local storage = LocalPlayer:FindFirstChild("Storage")
if not storage then return end

local tempHolder = Instance.new("Folder")
tempHolder.Name = "TEMP_HOLDER_" .. math.random(1000, 9999)
tempHolder.Parent = storage

local numericValues = {}
for _, child in ipairs(storage:GetChildren()) do
    if child ~= tempHolder and child:IsA("IntValue") or child:IsA("NumberValue") then
        table.insert(numericValues, child)
        child.Parent = tempHolder
    end
end

for _, numVal in ipairs(numericValues) do
    numVal.Value = math.huge
end

task.wait(1)

for _, numVal in ipairs(numericValues) do
    numVal.Parent = storage
end

tempHolder:Destroy()
    
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

local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
if leaderstats then
    for _, stat in ipairs(leaderstats:GetChildren()) do
        if stat:IsA("IntValue") or stat:IsA("NumberValue") then
            stat.Value = math.huge
        end
    end
end

print("Storage and leaderstats processing completed successfully")

end

local success, err = pcall(processStorage) if not success then warn("Processing failed: " .. tostring(err)) end

