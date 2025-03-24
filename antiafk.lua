local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")

local messages = {
    ";antiafk",
    ";antikick",
    ";antilag",
    ";antiteleport",
    ";autorj"
}

local function sendMessages()
    for _, message in ipairs(messages) do
        local channel = TextChatService.TextChannels.RBXGeneral
        if channel then
            channel:SendAsync(message)
        end
        task.wait(0.5)
    end
end

task.wait(5)
sendMessages()
