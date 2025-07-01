local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function applyGodmode(char)
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanTouch = false

			part:GetPropertyChangedSignal("CanTouch"):Connect(function()
				if part.CanTouch then
					part.CanTouch = false
				end
			end)
		end
	end
end

local function setup()
	if player.Character then
		applyGodmode(player.Character)
	end

	player.CharacterAdded:Connect(function(char)
		char:WaitForChild("HumanoidRootPart", 5)
		applyGodmode(char)
	end)
end

setup()
