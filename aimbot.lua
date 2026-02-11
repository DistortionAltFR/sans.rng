--!strict
--!optimize 2

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local mousePositionRemote = ReplicatedStorage:WaitForChild("mouseposition")

local currentTarget = nil
local targetButtons = {}
local trackedNPCs = {}
local npcMovementData = {}

print("[Aimbot] Starting initialization...")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AimbotGUI"
ScreenGui.ResetOnSpawn = false
if syn and syn.protect_gui then
	syn.protect_gui(ScreenGui)
	ScreenGui.Parent = CoreGui
else
	ScreenGui.Parent = CoreGui
end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 360)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(60, 60, 70)
UIStroke.Thickness = 1
UIStroke.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 12)
TopBarCorner.Parent = TopBar

local TopBarCover = Instance.new("Frame")
TopBarCover.Size = UDim2.new(1, 0, 0, 20)
TopBarCover.Position = UDim2.new(0, 0, 1, -20)
TopBarCover.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
TopBarCover.BorderSizePixel = 0
TopBarCover.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Aimbot"
Title.TextColor3 = Color3.fromRGB(240, 240, 250)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Position = UDim2.new(1, -34, 0, 6)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 50, 60)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.Parent = TopBar

local CloseButtonCorner = Instance.new("UICorner")
CloseButtonCorner.CornerRadius = UDim.new(0, 6)
CloseButtonCorner.Parent = CloseButton

local TargetLabel = Instance.new("TextLabel")
TargetLabel.Size = UDim2.new(1, -20, 0, 35)
TargetLabel.Position = UDim2.new(0, 10, 0, 45)
TargetLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
TargetLabel.BorderSizePixel = 0
TargetLabel.Text = "Target: None"
TargetLabel.TextColor3 = Color3.fromRGB(255, 85, 85)
TargetLabel.Font = Enum.Font.GothamBold
TargetLabel.TextSize = 14
TargetLabel.Parent = MainFrame

local TargetLabelCorner = Instance.new("UICorner")
TargetLabelCorner.CornerRadius = UDim.new(0, 8)
TargetLabelCorner.Parent = TargetLabel

local TargetLabelStroke = Instance.new("UIStroke")
TargetLabelStroke.Color = Color3.fromRGB(255, 85, 85)
TargetLabelStroke.Thickness = 1
TargetLabelStroke.Transparency = 0.7
TargetLabelStroke.Parent = TargetLabel

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -20, 1, -95)
ScrollingFrame.Position = UDim2.new(0, 10, 0, 85)
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
ScrollingFrame.Parent = MainFrame

local ScrollCorner = Instance.new("UICorner")
ScrollCorner.CornerRadius = UDim.new(0, 8)
ScrollCorner.Parent = ScrollingFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.Parent = ScrollingFrame

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 8)
UIPadding.PaddingBottom = UDim.new(0, 8)
UIPadding.PaddingLeft = UDim.new(0, 8)
UIPadding.PaddingRight = UDim.new(0, 8)
UIPadding.Parent = ScrollingFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 50, 0, 50)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "◎"
ToggleButton.TextColor3 = Color3.fromRGB(240, 240, 250)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 22
ToggleButton.Visible = false
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(60, 60, 70)
ToggleStroke.Thickness = 2
ToggleStroke.Parent = ToggleButton

local function toggleGUI()
	local isVisible = MainFrame.Visible
	MainFrame.Visible = not isVisible
	ToggleButton.Visible = isVisible
end

CloseButton.MouseButton1Click:Connect(toggleGUI)
ToggleButton.MouseButton1Click:Connect(toggleGUI)

CloseButton.MouseEnter:Connect(function()
	TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(240, 60, 70)}):Play()
end)

CloseButton.MouseLeave:Connect(function()
	TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 50, 60)}):Play()
end)

ToggleButton.MouseEnter:Connect(function()
	TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 48)}):Play()
end)

ToggleButton.MouseLeave:Connect(function()
	TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 38)}):Play()
end)

local function updateTargetLabel()
	if currentTarget and currentTarget.Parent then
		local npcName = currentTarget.Name or "Unknown"
		TargetLabel.Text = "Target: " .. npcName
		TargetLabel.TextColor3 = Color3.fromRGB(85, 255, 85)
		TargetLabelStroke.Color = Color3.fromRGB(85, 255, 85)
	else
		TargetLabel.Text = "Target: None"
		TargetLabel.TextColor3 = Color3.fromRGB(255, 85, 85)
		TargetLabelStroke.Color = Color3.fromRGB(255, 85, 85)
	end
end

local function updateButtonStates()
	for model, button in pairs(targetButtons) do
		local stroke = button:FindFirstChildOfClass("UIStroke")
		if model == currentTarget then
			button.BackgroundColor3 = Color3.fromRGB(85, 255, 85)
			if stroke then
				stroke.Color = Color3.fromRGB(85, 255, 85)
				stroke.Transparency = 0
			end
		else
			button.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
			if stroke then
				stroke.Color = Color3.fromRGB(50, 50, 60)
				stroke.Transparency = 0.5
			end
		end
	end
end

local function setTarget(npcModel)
	if currentTarget == npcModel then
		return
	end
	
	currentTarget = npcModel
	updateButtonStates()
	updateTargetLabel()
end

local function clearTarget()
	currentTarget = nil
	updateButtonStates()
	updateTargetLabel()
end

local function createTargetButton(npcModel)
	if targetButtons[npcModel] then 
		return 
	end
	
	local npcName = npcModel.Name or "Unknown NPC"
	
	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(1, -16, 0, 38)
	Button.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
	Button.BorderSizePixel = 0
	Button.Text = npcName
	Button.TextColor3 = Color3.fromRGB(220, 220, 230)
	Button.Font = Enum.Font.Gotham
	Button.TextSize = 13
	Button.Parent = ScrollingFrame
	
	local ButtonCorner = Instance.new("UICorner")
	ButtonCorner.CornerRadius = UDim.new(0, 6)
	ButtonCorner.Parent = Button
	
	local ButtonStroke = Instance.new("UIStroke")
	ButtonStroke.Color = Color3.fromRGB(50, 50, 60)
	ButtonStroke.Thickness = 1
	ButtonStroke.Transparency = 0.5
	ButtonStroke.Parent = Button
	
	Button.MouseButton1Click:Connect(function()
		setTarget(npcModel)
	end)
	
	Button.MouseEnter:Connect(function()
		if currentTarget ~= npcModel then
			local stroke = Button:FindFirstChildOfClass("UIStroke")
			TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 65)}):Play()
			if stroke then
				TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
			end
		end
	end)
	
	Button.MouseLeave:Connect(function()
		if currentTarget ~= npcModel then
			local stroke = Button:FindFirstChildOfClass("UIStroke")
			TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
			if stroke then
				TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
			end
		end
	end)
	
	targetButtons[npcModel] = Button
	trackedNPCs[npcModel] = true
end

local function removeTargetButton(npcModel)
	if targetButtons[npcModel] then
		targetButtons[npcModel]:Destroy()
		targetButtons[npcModel] = nil
		trackedNPCs[npcModel] = nil
		npcMovementData[npcModel] = nil
		
		if currentTarget == npcModel then
			clearTarget()
		end
	end
end

local function updateScrollingFrame()
	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 16)
end

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateScrollingFrame)

local function isPlayerCharacter(model)
	for _, player in pairs(Players:GetPlayers()) do
		if player.Character == model then
			return true
		end
	end
	return false
end

local function isValidNPC(model)
	if not model:IsA("Model") then return false end
	if isPlayerCharacter(model) then return false end
	
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	if not humanoid then return false end
	if humanoid.Health <= 0 then return false end
	
	local hrp = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
	if not hrp then return false end
	
	return true
end

local function scanForNPCs()
	for _, descendant in pairs(workspace:GetDescendants()) do
		if descendant:IsA("Model") and not trackedNPCs[descendant] then
			if isValidNPC(descendant) then
				createTargetButton(descendant)
			end
		end
	end
end

workspace.DescendantAdded:Connect(function(descendant)
	if descendant:IsA("Model") then
		task.wait(0.1)
		if isValidNPC(descendant) and not trackedNPCs[descendant] then
			createTargetButton(descendant)
		end
	elseif descendant:IsA("Humanoid") then
		local model = descendant.Parent
		if model and isValidNPC(model) and not trackedNPCs[model] then
			createTargetButton(model)
		end
	end
end)

workspace.DescendantRemoving:Connect(function(descendant)
	if descendant:IsA("Model") and targetButtons[descendant] then
		removeTargetButton(descendant)
	elseif descendant:IsA("Humanoid") then
		local model = descendant.Parent
		if model and targetButtons[model] then
			removeTargetButton(model)
		end
	end
end)

scanForNPCs()

RunService.Heartbeat:Connect(function()
	if currentTarget then
		if not currentTarget.Parent or not isValidNPC(currentTarget) then
			removeTargetButton(currentTarget)
		else
			-- Auto-fire mouse position to server when target is active
			local targetPart = currentTarget.PrimaryPart or currentTarget:FindFirstChild("HumanoidRootPart")
			if targetPart then
				local targetPos = targetPart.Position
				local args = {
					vector.create(targetPos.X, targetPos.Y, targetPos.Z)
				}
				mousePositionRemote:FireServer(unpack(args))
				
				-- Rotate player HRP to face target (Y-axis only)
				local character = LocalPlayer.Character
				if character then
					local playerHRP = character:FindFirstChild("HumanoidRootPart")
					if playerHRP then
						local playerPos = playerHRP.Position
						local direction = (targetPos - playerPos) * Vector3.new(1, 0, 1) -- Flatten Y component
						
						if direction.Magnitude > 0 then
							local lookCFrame = CFrame.lookAt(playerPos, playerPos + direction)
							playerHRP.CFrame = CFrame.new(playerPos) * (lookCFrame - lookCFrame.Position)
						end
					end
				end
			end
		end
	end
end)

local mouse = LocalPlayer:GetMouse()
local realMouseHit = mouse.Hit

local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, key)
	if self == mouse and key == "Hit" then
		if currentTarget and currentTarget.Parent and isValidNPC(currentTarget) then
			local targetPart = currentTarget.PrimaryPart or currentTarget:FindFirstChild("HumanoidRootPart")
			if targetPart then
				local targetPos = targetPart.Position
				local fakeHit = {}
				
				local mt = {
					__index = function(_, k)
						if k == "Position" then
							return targetPos
						elseif k == "p" then
							return targetPos
						elseif k == "X" or k == "Y" or k == "Z" then
							return targetPos[k]
						end
						local success, result = pcall(function()
							return realMouseHit[k]
						end)
						if success then
							return result
						end
						return nil
					end
				}
				
				setmetatable(fakeHit, mt)
				return fakeHit
			end
		end
	end
	return oldIndex(self, key)
end)

print("[Aimbot] Loaded successfully")
print("[Aimbot] Auto-detecting NPCs with: Humanoid + HumanoidRootPart")
print("[Aimbot] Mouse position remote hook active")
updateTargetLabel()
