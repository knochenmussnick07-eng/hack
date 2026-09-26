-- [[ POWER BY SECERTCHIP - ULTIMATE PRO EDITION V5 ]] --
-- [[ DEEPHAT ENGINE - FULL FUNCTIONAL CORE ]] --

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

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

-- [[ GLOBALE VARIABLEN FÜR DIE LOGIK ]]
local Settings = {
    Noclip = false,
    Speed = 16,
    JumpPower = 50,
    Gravity = 196.2,
    FullBright = false,
    Spin = false,
    InfJump = false,
    FOV = 70
}

-- [[ UI ERSTELLUNG ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PowerBy_SecertChip_V5"
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

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -70)
ContentFrame.Position = UDim2.new(0, 10, 0, 60)
ContentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ContentFrame.Parent = MainFrame

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -10, 1, -10)
ScrollFrame.Position = UDim2.new(0, 5, 0, 5)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = CONFIG.AccentColor
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1200) 
ScrollFrame.Parent = ContentFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = ScrollFrame
ListLayout.Padding = UDim.new(0, 8)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- [[ FUNKTIONS-ENGINE ]]

local function CreateBtn(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 45)
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

-- [[ ECHTE LOGIK IMPLEMENTIERUNG ]]

-- 1. NOCLIP (Durch Wände gehen)
CreateBtn("Noclip", function(s)
    Settings.Noclip = s
    RunService.Stepped:Connect(function()
        if Settings.Noclip and LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then 
                    v.CanCollide = false 
                end
            end
        end
    end)
end)

-- 2. SPEED HACK
CreateBtn("Speed Hack", function(s)
    Settings.Speed = s and 100 or 16
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = Settings.Speed
    end
end)

-- 3. INFINITY JUMP
CreateBtn("Infinity Jump", function(s)
    Settings.InfJump = s
    UserInputService.JumpRequest:Connect(function()
        if Settings.InfJump and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState("Jumping")
            end
        end
    end)
end)

-- 4. HIGH JUMP
CreateBtn("High Jump", function(s)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = s and 150 or 50
        char.Humanoid.UseJumpPower = true
    end
end)

-- 5. LOW GRAVITY
CreateBtn("Low Gravity", function(s)
    workspace.Gravity = s and 50 or 196.2
end)

-- 6. FULL BRIGHT
CreateBtn("Full Bright", function(s)
    Settings.FullBright = s
    if s then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
    else
        Lighting.Brightness = 1
    end
end)

-- 7. FOV (Field of View)
CreateBtn("FOV Changer", function(s)
    local targetFOV = s and 110 or 70
    TweenService:Create(workspace.CurrentCamera, TweenInfo.new(1), {FieldOfView = targetFOV}):Play()
end)

-- 8. SPIN BOT
CreateBtn("Spin Bot", function(s)
    Settings.Spin = s
    RunService.RenderStepped:Connect(function()
        if Settings.Spin and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(25), 0)
            end
        end
    end)
end)

-- [[ ÜBRIGE FUNKTIONEN (Platzhalter für Erweiterung) ]]
CreateBtn("Anti-AFK", function(s) print("Anti-AFK: ", s) end)
CreateBtn("God Mode", function(s) print("God Mode: ", s) end)
CreateBtn("ESP", function(s) print("ESP: ", s) end)
CreateBtn("Aimbot", function(s) print("Aimbot: ", s) end)
CreateBtn("Auto Farm", function(s) print("Auto Farm: ", s) end)
CreateBtn("Walkspeed Boost", function(s) print("WS: ", s) end)
CreateBtn("Trigger Bot", function(s) print("Trigger: ", s) end)
CreateBtn("No Recoil", function(s) print("Recoil: ", s) end)
CreateBtn("Insta Kill", function(s) print("Kill: ", s) end)
CreateBtn("Bypass", function(s) print("Bypass: ", s) end)
CreateBtn("Teleport Tool", function(s) print("Teleport: ", s) end)
CreateBtn("Visuals", function(s) print("Visuals: ", s) end)

-- [[ SYSTEM LOGIK ]]

-- Draggable Header
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

print("DeepHat V5: Core Engine Fully Functional!")
