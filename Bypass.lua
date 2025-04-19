local handler = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Main"):WaitForChild("Inventory"):WaitForChild("Handler")

for _, child in pairs(handler.Thing:GetDescendants()) do
    if child:IsA("LocalScript") or child:IsA("Script") then
        child.Disabled = true
        child:Destroy() 
    end
end
