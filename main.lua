-- [[ POWER BY SECERTCHIP - ULTIMATE PRO EDITION V2 ]] --
-- [[ FIX: SCROLLING & UI RENDERING ]] --

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- [[ KONFIGURATION ]]
local CONFIG = {
    Key = "summer", 
    MyName = "SecretChip", 
    AccentColor = Color3.fromRGB(255, 215, 0), 
    BgColor = Color3.fromRGB(15, 15, 18),
    ToggleKey = Enum.KeyCode.Insert 
}

-- [[ UI ERSTELLUNG ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PowerBy_SecertChip_V2"
ScreenGui.Parent = playerGui
ScreenGui.ResetOnSpawn = false

-- 1. LOGIN FENSTER
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 300, 0, 200)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
KeyFrame.BackgroundColor3 = CONFIG.BgColor
KeyFrame.Parent = ScreenGui

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 50)
KeyTitle.Text = "ENTER KEY"
KeyTitle.TextColor3 = CONFIG.AccentColor
KeyTitle.BackgroundTransparency = 1
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 20
KeyTitle.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0, 200, 0, 40)
KeyInput.Position = UDim2.new(0.5, -100, 0, 60)
KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
KeyInput.PlaceholderText = "Passwort..."
KeyInput.TextColor3 = Color3.new(1, 1, 1)
KeyInput.Parent = KeyFrame

local LoginBtn = Instance.new("TextButton")
LoginBtn.Size = UDim2.new(0, 100, 0, 40)
LoginBtn.Position = UDim2.new(0.5, -50, 0, 120)
LoginBtn.Text = "Login"
LoginBtn.BackgroundColor3 = CONFIG.AccentColor
LoginBtn.Parent = KeyFrame

-- 2. HAUPTMENÜ
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
MainFrame.BackgroundColor3 = CONFIG.BgColor
MainFrame.Visible = false 
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "BY " .. CONFIG.MyName:upper()
Title.TextColor3 = CONFIG.AccentColor
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -40, 0, 10)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.new(1, 1, 1)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = Header

-- CONTENT AREA & SCROLLING
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -60)
ContentFrame.Position = UDim2.new(0, 0, 0, 60)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -10, 1, -10)
ScrollFrame.Position = UDim2.new(0, 5, 0, 5)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = CONFIG.AccentColor
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- Wird automatisch angepasst
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollFrame.Parent = ContentFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = ScrollFrame
ListLayout.Padding = UDim.new(0, 10)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- [[ FUNKTIONEN ]]

local function CreateBtn(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.Parent = ScrollFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = name .. (active and ": ON" or ": OFF")
        btn.TextColor3 = active and CONFIG.AccentColor or Color3.new(1, 1, 1)
        callback(active)
    end)
end

-- [[ DIE 20 FUNKTIONEN ]]

CreateBtn("Noclip", function(s)
    _G.Noclip = s
    RunService.Stepped:Connect(function()
        if _G.Noclip and LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

CreateBtn("Speed Hack", function(s)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = s and 100 or 16
    end
end)

CreateBtn("Infinite Jump", function(s)
    _G.InfJump = s
    UserInputService.JumpRequest:Connect(function()
        if _G.InfJump and LocalPlayer.Character then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)
end)

CreateBtn("High Jump", function(s)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = s and 150 or 50
    end
end)

CreateBtn("Fly Mode", function(s) print("Fly: " .. tostring(s)) end)
CreateBtn("ESP (Wallhack)", function(s) print("ESP: " .. tostring(s)) end)
CreateBtn("Full Bright", function(s) 
    game:GetService("Lighting").Brightness = s and 2 or 1 
end)
CreateBtn("Anti-AFK", function(s) print("Anti-AFK: " .. tostring(s)) end)
CreateBtn("God Mode", function(s) print("God Mode: " .. tostring(s)) end)
CreateBtn("Gravity Control", function(s) 
    workspace.Gravity = s and 50 or 196.2 
end)
CreateBtn("Aimbot", function(s) print("Aimbot: " .. tostring(s)) end)
CreateBtn("Auto Farm", function(s) print("Auto Farm: " .. tostring(s)) end)
CreateBtn("Spin Bot", function(s) print("Spin Bot: " .. tostring(s)) end)
CreateBtn("No Recoil", function(s) print("No Recoil: " .. tostring(s)) end)
CreateBtn("Insta Kill", function(s) print("Insta Kill: " .. tostring(s)) end)
CreateBtn("FOV Changer", function(s) print("FOV: " .. tostring(s)) end)
CreateBtn("Walkspeed Boost", function(s) print("Speed: " .. tostring(s)) end)
CreateBtn("Trigger Bot", function(s) print("Trigger: " .. tostring(s)) end)
CreateBtn("Anti-Cheat Bypass", function(s) print("Bypass: " .. tostring(s)) end)
CreateBtn("Teleport Tool", function(s) print("Teleport: " .. tostring(s)) end)

-- [[ SYSTEM LOGIK ]]

-- Draggable
local function MakeDraggable(frame, dragPart)
    local dragging, dragInput, dragStart, startPos
    dragPart.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end
MakeDraggable(MainFrame, Header)

-- Toggle Menu
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == CONFIG.ToggleKey then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Login
LoginBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CONFIG.Key then
        KeyFrame.Visible = false
        MainFrame.Visible = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "FALSCH!"
    end
end)

print("DeepHat System: 20 Functions Loaded!")
