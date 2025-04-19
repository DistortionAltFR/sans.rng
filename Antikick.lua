local function log(message)
    print("[AntiKick] " .. tostring(message))
end

log("Initializing anti-kick...")

local mt = getrawmetatable(game)
local original_namecall = mt.__namecall

if setreadonly then
    setreadonly(mt, false)
else
    log("Warning: setreadonly not available. Script may fail.")
end

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" and self == game:GetService("Players").LocalPlayer then
        log("Blocked client-side kick attempt! Reason: " .. tostring(({...})[1] or "No reason"))
        return wait(9e9)
    end
    return original_namecall(self, ...)
end)

if setreadonly then
    setreadonly(mt, true)
end

log("Anti-kick loaded successfully. Tamper away!")
