local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local WHITELIST = {
    "Nicegail2222ALT",
    "MaybeV3n",
    "Akoiiv",
    "bro_gaming26",
    "ImADankMemeXD",
    "WolfTalks",
    "saadgame26z",
    "bibeo1j",
    "Hog_RiderGamer",
    "TheTrueSigmaOfAllat",
    "Mihail_dmitrovich",
    "Nekomat3Okayu",
    "dldPwnsd123123",
    "utrsezeg",
    "BEEM3020",
    "i_idkfrfr123testalt",
    "chaosfloo12"
}

local randomUser = WHITELIST[math.random(1, #WHITELIST)]
print("Selected whitelisted user:", randomUser)

local originalName = LocalPlayer.Name
local originalDisplay = LocalPlayer.DisplayName

local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = newcclosure(function(self, key)
    if self == LocalPlayer then
        if key == "Name" then
            return randomUser
        elseif key == "DisplayName" then
            return randomUser
        end
    end
    return oldIndex(self, key)
end)

setreadonly(mt, true)
print("Spoofed LocalPlayer as:", randomUser)
