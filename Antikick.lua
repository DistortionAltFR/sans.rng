local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    if getnamecallmethod() == "Kick" and self == LocalPlayer then
        warn("[AntiKick] Blocked a kick attempt:", ...)
        return
    end
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

print("[AntiKick] Ready. Kick attempts will be ignored.")
