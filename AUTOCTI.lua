local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local BINDParts = {}

local function tryAddBIND(part)
	if part:IsA("BasePart") and part.Name == "BIND" then
		local detector = part:FindFirstChildOfClass("ClickDetector")
		if detector then
			BINDParts[part] = true
		else
			part.ChildAdded:Connect(function(child)
				if child:IsA("ClickDetector") then
					BINDParts[part] = true
				end
			end)
		end
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

for _, part in ipairs(workspace:GetDescendants()) do
	tryAddBIND(part)
end

workspace.DescendantAdded:Connect(function(part)
	tryAddBIND(part)
end)

workspace.DescendantRemoving:Connect(function(part)
	BINDParts[part] = nil
end)

LocalPlayer.CharacterAdded:Connect(function(newCharacter)
	Character = newCharacter
	HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
	for _, child in ipairs(newCharacter:GetChildren()) do
		if child:IsA("BasePart") then
			child.CanTouch = false
		end
	end
end)

RunService.Heartbeat:Connect(function()
	if not HumanoidRootPart or not HumanoidRootPart.Parent then return end

	for part in pairs(BINDParts) do
		if part and part.Parent and part:FindFirstChildOfClass("ClickDetector") then
			fireclickdetector(part:FindFirstChildOfClass("ClickDetector"))
		else
			BINDParts[part] = nil
		end
	end
end)

DisableCharacterTouch()
LocalPlayer.CharacterAdded:Connect(DisableCharacterTouch)
