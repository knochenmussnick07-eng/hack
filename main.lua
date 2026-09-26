-- [[ POWER BY SECERTCHIP - ULTIMATE PRO EDITION ]] --
-- [[ FEATURES: TOGGLE KEY (INSERT), DRAGGABLE, MINIMIZABLE ]] --

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- [[ KONFIGURATION ]]
local CONFIG = {
    Key = "1234", -- DEIN PASSWORT
    MyName = "SecertChip", 
    AccentColor = Color3.fromRGB(255, 215, 0), -- Gold
    BgColor = Color3.fromRGB(15, 15, 18),
    ToggleKey = Enum.KeyCode.Insert -- DIE TASTE ZUM ÖFFNEN/SCHLIESSEN
}

local Features = {
    Noclip = false,
    Fly = false,
    Speed = false
}

-- [[ UI ERSTELLUNG ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PowerBy_SecertChip"
ScreenGui.Parent = playerGui
ScreenGui.ResetOnSpawn = false

-- 1. LOGIN FENSTER (Wird zuerst angezeigt)
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

-- 2. HAUPTMENÜ (Wird erst nach Login gezeigt)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
MainFrame.BackgroundColor3 = CONFIG.BgColor
MainFrame.Visible = false -- Startet unsichtbar
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

-- Header (Verschiebbar & Minimize)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "POWER BY " .. CONFIG.MyName:upper()
Title.TextColor3 = CONFIG.AccentColor
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- MINIMIZE BUTTON
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -40, 0, 10)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.new(1, 1, 1)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinimizeBtn

-- Content Area
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -60)
ContentFrame.Position = UDim2.new(0, 0, 0, 60)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -20)
ScrollFrame.Position = UDim2.new(0, 10, 0, 0)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 2
ScrollFrame.ScrollBarImageColor3 = CONFIG.AccentColor
ScrollFrame.Parent = ContentFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = ScrollFrame
ListLayout.Padding = UDim.new(0, 8)

-- [[ FUNKTIONEN ]]

-- 1. DRAGGABLE (Verschieben)
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

-- 2. TOGGLE SYSTEM (Öffnen/Schließen mit Taste)
local MenuOpen = true
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == CONFIG.ToggleKey then
        MenuOpen = not MenuOpen
        MainFrame.Visible = MenuOpen
        print("Menü: " .. (MenuOpen and "An" or "Aus"))
    end
end)

-- 3. MINIMIZE (Einklappen des Inhalts)
local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        ContentFrame.Visible = false
        MainFrame.Size = UDim2.new(0, 350, 0, 50)
        MinimizeBtn.Text = "+"
    else
        ContentFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 350, 0, 450)
        MinimizeBtn.Text = "-"
    end
end)

-- 4. BUTTON CREATOR
local function CreateBtn(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.Parent = ScrollFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = name .. (active and ": ON" or ": OFF")
        btn.TextColor3 = active and CONFIG.AccentColor or Color3.new(1, 1, 1)
        callback(active)
    end)
end

-- [[ FEATURES ]]
CreateBtn("Noclip", function(s)
    Features.Noclip = s
    RunService.Stepped:Connect(function()
        if Features.Noclip and LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

CreateBtn("Speed Boost", function(s)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = s and 100 or 16
    end
end)

CreateBtn("Fly (Speed)", function(s)
    Features.Fly = s
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = s and 150 or 16
    end
end)

-- LOGIN PROZESS
LoginBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CONFIG.Key then
        KeyFrame.Visible = false
        MainFrame.Visible = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "FALSCH!"
    end
end)

print("Power By SecertChip Ultimate Ready!")