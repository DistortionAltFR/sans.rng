local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

LocalPlayer.Name = "Nicegail2222ALT"
LocalPlayer.DisplayName = "Nicegail2222ALT"

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    char.Name = "Nicegail2222ALT"
end)

if LocalPlayer.Character then
    LocalPlayer.Character.Name = "Nicegail2222ALT"
end

print("Direct spoof done.")
