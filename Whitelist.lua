local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Set new identity directly
LocalPlayer.Name = "Nicegail2222ALT"
LocalPlayer.DisplayName = "Nicegail2222ALT"

-- Optional: spoof character name on spawn
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    char.Name = "Nicegail2222ALT"
end)

-- Spoof current character if already spawned
if LocalPlayer.Character then
    LocalPlayer.Character.Name = "Nicegail2222ALT"
end

print("Direct spoof done.")
