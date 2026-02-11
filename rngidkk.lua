local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local rgbMachine = workspace:WaitForChild("RGBMachine")
local surfaceGui = rgbMachine:WaitForChild("SurfaceGui")
local refFrame = surfaceGui:WaitForChild("Frame")
local scrollingFrame = refFrame:WaitForChild("ScrollingFrame")

local enabled = false
local hunting = false
local promptShown = false

local StatusLabel
local PromptFrame
local startButton
local yesButton
local noButton
local yesFrame
local noFrame

local function getDifficultyLevel()
	for _, child in ipairs(scrollingFrame:GetChildren()) do
		if child:IsA("TextLabel") then
			local text = child.Text or ""
			local level = text:match("Difficulty level:%s*(%d+)")
			if level then return tonumber(level) end
			level = text:match("Difficulty level:%s*<font[^>]->?(%d+)</font>")
			if level then return tonumber(level) end
			level = text:match("Difficulty level:%s*<font[^>]->?%((%d+)%)</font>")
			if level then return tonumber(level) end
		end
	end
	return nil
end

local function fireRNGEvent()
	local args = {"batman"}
	workspace:WaitForChild("RGBMachine"):WaitForChild("SurfaceGui"):WaitForChild("Script"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
end

local gui = Instance.new("ScreenGui")
gui.Name = "RNGFinderUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.35, 0.2)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(150, 124, 255)
stroke.Transparency = 0.3
local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 38)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 28))
}
gradient.Rotation = 45

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1, 0.28)
title.Position = UDim2.fromScale(0, 0)
title.BackgroundTransparency = 1
title.Text = "RNG FIND"
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(150, 124, 255)

local button = Instance.new("TextButton", frame)
button.Size = UDim2.fromScale(0.8, 0.38)
button.Position = UDim2.fromScale(0.5, 0.55)
button.AnchorPoint = Vector2.new(0.5, 0.5)
button.Text = "START HUNTING"
button.Font = Enum.Font.GothamBold
button.TextScaled = true
button.TextColor3 = Color3.new(1, 1, 1)
button.BackgroundColor3 = Color3.fromRGB(150, 124, 255)
button.BorderSizePixel = 0
startButton = button
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 12)

StatusLabel = Instance.new("TextLabel", frame)
StatusLabel.Size = UDim2.fromScale(0.9, 0.18)
StatusLabel.Position = UDim2.fromScale(0.5, 0.92)
StatusLabel.AnchorPoint = Vector2.new(0.5, 0.5)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Idle"
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextScaled = true
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)

PromptFrame = Instance.new("Frame", gui)
PromptFrame.Size = UDim2.fromScale(0.34, 0.24)
PromptFrame.Position = UDim2.fromScale(0.5, 0.5)
PromptFrame.AnchorPoint = Vector2.new(0.5, 0.5)
PromptFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
PromptFrame.BorderSizePixel = 0
PromptFrame.Visible = false
PromptFrame.Active = true
PromptFrame.Draggable = true

Instance.new("UICorner", PromptFrame).CornerRadius = UDim.new(0, 16)
local pStroke = Instance.new("UIStroke", PromptFrame)
pStroke.Thickness = 2
pStroke.Color = Color3.fromRGB(85, 255, 85)
pStroke.Transparency = 0.3
local pGradient = Instance.new("UIGradient", PromptFrame)
pGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 38)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 28))
}
pGradient.Rotation = 45

local promptTitle = Instance.new("TextLabel", PromptFrame)
promptTitle.Size = UDim2.fromScale(1, 0.36)
promptTitle.Position = UDim2.fromScale(0, 0)
promptTitle.BackgroundTransparency = 1
promptTitle.Text = "Keep Hunting?"
promptTitle.Font = Enum.Font.GothamBlack
promptTitle.TextScaled = true
promptTitle.TextColor3 = Color3.fromRGB(85, 255, 85)

yesFrame = Instance.new("Frame", PromptFrame)
yesFrame.Size = UDim2.fromScale(0.42, 0.34)
yesFrame.Position = UDim2.fromScale(0.22, 0.66)
yesFrame.AnchorPoint = Vector2.new(0.5, 0.5)
yesFrame.BackgroundColor3 = Color3.fromRGB(85, 255, 85)
yesFrame.BorderSizePixel = 0
Instance.new("UICorner", yesFrame).CornerRadius = UDim.new(0, 12)

yesButton = Instance.new("TextButton", yesFrame)
yesButton.Size = UDim2.fromScale(1, 1)
yesButton.Position = UDim2.fromScale(0, 0)
yesButton.BackgroundTransparency = 1
yesButton.Text = "YES"
yesButton.Font = Enum.Font.GothamBold
yesButton.TextScaled = true
yesButton.TextColor3 = Color3.new(1, 1, 1)
yesButton.BorderSizePixel = 0

noFrame = Instance.new("Frame", PromptFrame)
noFrame.Size = UDim2.fromScale(0.42, 0.34)
noFrame.Position = UDim2.fromScale(0.78, 0.66)
noFrame.AnchorPoint = Vector2.new(0.5, 0.5)
noFrame.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
noFrame.BorderSizePixel = 0
Instance.new("UICorner", noFrame).CornerRadius = UDim.new(0, 12)

noButton = Instance.new("TextButton", noFrame)
noButton.Size = UDim2.fromScale(1, 1)
noButton.Position = UDim2.fromScale(0, 0)
noButton.BackgroundTransparency = 1
noButton.Text = "NO"
noButton.Font = Enum.Font.GothamBold
noButton.TextScaled = true
noButton.TextColor3 = Color3.new(1, 1, 1)
noButton.BorderSizePixel = 0

button.MouseEnter:Connect(function()
	TweenService:Create(button, TweenInfo.new(0.18), {Size = UDim2.fromScale(0.85, 0.41)}):Play()
end)
button.MouseLeave:Connect(function()
	TweenService:Create(button, TweenInfo.new(0.18), {Size = UDim2.fromScale(0.8, 0.38)}):Play()
end)

yesButton.MouseEnter:Connect(function()
	TweenService:Create(yesFrame, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(105, 255, 105)}):Play()
end)
yesButton.MouseLeave:Connect(function()
	TweenService:Create(yesFrame, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(85, 255, 85)}):Play()
end)

noButton.MouseEnter:Connect(function()
	TweenService:Create(noFrame, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255, 105, 105)}):Play()
end)
noButton.MouseLeave:Connect(function()
	TweenService:Create(noFrame, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255, 85, 85)}):Play()
end)

button.MouseButton1Click:Connect(function()
	if promptShown then return end
	enabled = not enabled
	hunting = enabled
	if enabled then
		startButton.Text = "STOP HUNTING"
		startButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
		StatusLabel.Text = "Status: Hunting..."
		StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 85)
	else
		startButton.Text = "START HUNTING"
		startButton.BackgroundColor3 = Color3.fromRGB(150, 124, 255)
		StatusLabel.Text = "Status: Idle"
		StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
	end
end)

yesButton.MouseButton1Click:Connect(function()
	PromptFrame.Visible = false
	promptShown = false
	enabled = true
	hunting = true
	startButton.Text = "STOP HUNTING"
	startButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
	StatusLabel.Text = "Status: Hunting..."
	StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 85)
end)

noButton.MouseButton1Click:Connect(function()
	PromptFrame.Visible = false
	promptShown = false
	enabled = false
	hunting = false
	startButton.Text = "START HUNTING"
	startButton.BackgroundColor3 = Color3.fromRGB(150, 124, 255)
	StatusLabel.Text = "Status: Stopped"
	StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
end)

local fireInterval = 0.5
local accumulator = 0

RunService.Heartbeat:Connect(function(dt)
	if not enabled or not hunting or promptShown then return end
	accumulator = accumulator + dt
	if accumulator < fireInterval then return end
	accumulator = accumulator - fireInterval
	local ok, err = pcall(fireRNGEvent)
	if not ok then
		StatusLabel.Text = "Status: Error firing"
		StatusLabel.TextColor3 = Color3.fromRGB(255, 85, 85)
		return
	end
	hunting = false
	coroutine.wrap(function()
		local confirmWindow = 0.6
		local checkInterval = 0.08
		local elapsed = 0
		while elapsed <= confirmWindow do
			local difficulty = getDifficultyLevel()
			if difficulty and difficulty >= 6 then
				promptShown = true
				enabled = false
				hunting = false
				PromptFrame.Visible = true
				StatusLabel.Text = "Status: Found difficulty " .. difficulty .. "!"
				StatusLabel.TextColor3 = Color3.fromRGB(85, 255, 85)
				return
			end
			elapsed = elapsed + checkInterval
			wait(checkInterval)
		end
		hunting = true
		enabled = true
		StatusLabel.Text = "Status: Hunting..."
		StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 85)
	end)()
end)

print("[RNG FIND] Loaded")
