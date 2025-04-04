local VirtualUser = game:GetService('VirtualUser')

game:GetService('Players').LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "AntiAFK loaded!",
    Text = "FRFR",
    Button1 = "OK",
    Duration = 5
})
