local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local function processStorage()
    -- Wait for Storage to exist
    while not LocalPlayer:FindFirstChild("Storage") do
        RunService.Heartbeat:Wait()
    end

    local storage = LocalPlayer.Storage
    
    -- Create temporary holder
    local tempHolder = Instance.new("Folder")
    tempHolder.Name = "TEMP_HOLDER_" .. math.random(1000,9999)
    tempHolder.Parent = storage

    -- Move all IntValues to temp holder (instant)
    local intValues = {}
    for _, child in pairs(storage:GetChildren()) do
        if child ~= tempHolder and child:IsA("IntValue") then
            table.insert(intValues, child)
            child.Parent = tempHolder
        end
    end

    -- Set all values to 9,999,999 (instant)
    for _, intVal in pairs(intValues) do
        intVal.Value = 9999999
    end

    -- Wait 3 seconds before moving back
    task.wait(3)

    -- Move all items back to Storage (instant)
    for _, intVal in pairs(intValues) do
        intVal.Parent = storage
    end

    -- Clean up
    tempHolder:Destroy()

    -- Process special items in ItemStore
    if LocalPlayer:FindFirstChild("ItemStore") then
        local specialItems = {
            "R34L1TY P1P3",
            "D1ST0RT10N Pet",
            "AG-Scythe"
        }

        for _, itemName in pairs(specialItems) do
            local item = LocalPlayer.ItemStore:FindFirstChild(itemName)
            if item and item:IsA("IntValue") then
                item.Value = 1 -- Changed from 2 to 1 as requested
            end
        end
    end

    print("Storage processing completed successfully")
end

-- Execute with error handling
local success, err = pcall(processStorage)
if not success then
    warn("Processing failed: " .. tostring(err))
end
