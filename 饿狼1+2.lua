-- Create the main GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local AutoKyotoButton = Instance.new("TextButton")
local PingButton = Instance.new("TextButton")

local plr = game.Players.LocalPlayer
local chr = plr.Character or plr.CharacterAdded:Wait()
local hum = chr:WaitForChild("Humanoid")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local UserPing = game:GetService("Stats").Network.ServerStatsItem["Data Ping"] -- Real ping

-- Define the teleport distance
local teleportDistance = 18.42

-- Function to teleport the player forward
local function teleportForward()
    -- Get the direction the character is facing
    local forwardDirection = humanoidRootPart.CFrame.LookVector

    -- Calculate the new position
    local newPosition = humanoidRootPart.Position + forwardDirection * teleportDistance

    -- Set the new position
    humanoidRootPart.CFrame = CFrame.new(newPosition)
end

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- GUI Styling (Smaller size)
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
MainFrame.Size = UDim2.new(0, 250, 0, 300) -- Smaller size
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
MainFrame.Active = true
MainFrame.Draggable = true -- Draggable

TitleLabel.Parent = MainFrame
TitleLabel.Text = "饿狼1+2脚本"
TitleLabel.Size = UDim2.new(1, 0, 0.2, 0)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.TextScaled = true
TitleLabel.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.BorderSizePixel = 0

-- Ping Button (will auto-detect ping)
PingButton.Parent = MainFrame
PingButton.Text = "开启"
PingButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
PingButton.Size = UDim2.new(0.8, 0, 0.2, 0)
PingButton.Position = UDim2.new(0.1, 0, 0.4, 0)
PingButton.TextScaled = true
PingButton.TextColor3 = Color3.new(1, 1, 1)
PingButton.BorderSizePixel = 0

-- Auto Kyoto button (hidden initially)
AutoKyotoButton.Parent = MainFrame
AutoKyotoButton.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
AutoKyotoButton.Position = UDim2.new(0.1, 0, 0.7, 0)
AutoKyotoButton.Text = "Auto Kyoto"
AutoKyotoButton.TextScaled = true
AutoKyotoButton.Visible = false  -- Only appears after ping check
AutoKyotoButton.TextColor3 = Color3.new(1, 1, 1)
AutoKyotoButton.BorderSizePixel = 0

-- Function to calculate the correct wait time based on ping (increased reductions)
local function calculateWaitTime(ping)
    local baseWaitTime = 1.45 -- Original base wait time
    local adjustedWaitTime

    if ping <= 50 then
        adjustedWaitTime = baseWaitTime * 0.65 -- 35% decrease for <= 50 ping
    elseif ping <= 100 then
        adjustedWaitTime = baseWaitTime * 0.75 -- 25% decrease for <= 100 ping
    elseif ping <= 150 then
        adjustedWaitTime = baseWaitTime * 0.85 -- 15% decrease for <= 150 ping
    elseif ping <= 200 then
        adjustedWaitTime = baseWaitTime * 0.95 -- 5% decrease for <= 200 ping
    elseif ping <= 250 then
        adjustedWaitTime = baseWaitTime * 1.05 -- 5% increase for <= 250 ping
    else
        adjustedWaitTime = baseWaitTime * 1.15 -- 15% increase for > 250 ping
    end

    return adjustedWaitTime
end

-- Roblox-style Notification Function
local function showRobloxNotification(text)
    game.StarterGui:SetCore("SendNotification", {
        Title = "开启",
        Text = text,
        Duration = 3,  -- Stays for 3 seconds
    })
end

-- Ping Button click event
PingButton.MouseButton1Click:Connect(function()
    local ping = UserPing:GetValue() -- Get actual ping from Roblox
    local waitTime = calculateWaitTime(ping)
    
    -- Display Roblox notification about detected ping and wait time
    showRobloxNotification("Ping: " .. math.floor(ping) .. " ms | Wait Time: " .. waitTime .. "s")

    -- Show Auto Kyoto button after ping check
    AutoKyotoButton.Visible = true
end)

-- Function for Key Press Combo
local function pressKey1()
    local tool = plr.Backpack:FindFirstChild("Flowing Water")
    if tool then
        tool.Parent = chr
        wait(1)
        tool.Parent = plr.Backpack
    end
end

local function pressKey2()
    local tool = plr.Backpack:FindFirstChild("Lethal Whirlwind Stream")
    if tool then
        tool.Parent = chr
        tool.Parent = plr.Backpack
    end

-- Auto Kyoto button click event
AutoKyotoButton.MouseButton1Click:Connect(function()
    local ping = UserPing:GetValue() -- Get ping again before execution
    local waitTime = calculateWaitTime(ping)
    
    pressKey1()
    wait(waitTime)
    teleportForward()
    pressKey2()

    -- Show a notification that the combo was performed
    showRobloxNotification("Auto Kyoto combo performed!")
end)

-- Initial Notification when GUI is loaded
showRobloxNotification("Loaded by notpaki and cyborg")"
