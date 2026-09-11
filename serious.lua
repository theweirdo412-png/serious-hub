-- ====================================================================
-- serious COMPACT MATRIX BUILD v3.2 - FINAL SYNCHRONIZED MASTER
-- ====================================================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("serious_matrix_hub") then
    PlayerGui.serious_matrix_hub:Destroy()
end

local serious_matrix_hub = Instance.new("ScreenGui")
serious_matrix_hub.Name = "serious_matrix_hub"
serious_matrix_hub.Parent = PlayerGui
serious_matrix_hub.ResetOnSpawn = false

------------------------------------------------------------
-- STATE CONFIGURATIONS
------------------------------------------------------------
local Config = {
    Boxes = false,
    Names = false,
    TrackerColor = Color3.fromRGB(0, 191, 255) -- Neon Azure Blue
}

local activeTrackers = {}

-- Compact Frame Base
local Window = Instance.new("Frame")
Window.Name = "MainWindow"
Window.Size = UDim2.new(0, 320, 0, 220)
Window.Position = UDim2.new(0.5, -160, 0.5, -110)
Window.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Window.BorderSizePixel = 1
Window.BorderColor3 = Color3.fromRGB(255, 255, 255) -- Sharp Retro White Outline
Window.Active = true
Window.Draggable = true
Window.Parent = serious_matrix_hub

-- Header
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
TopBar.BorderSizePixel = 0
TopBar.Parent = Window

local Title = Instance.new("TextLabel")
Title.Text = "  serious v3.2 // compact node"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.Code
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = TopBar

-- Section Outlines
local Section = Instance.new("Frame")
Section.Size = UDim2.new(1, -20, 1, -50)
Section.Position = UDim2.new(0, 10, 0, 40)
Section.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Section.BorderColor3 = Color3.fromRGB(255, 255, 255)
Section.Parent = Window

local SecTitle = Instance.new("TextLabel")
SecTitle.Text = "  tracking / diagnostics matrix"
SecTitle.Size = UDim2.new(1, 0, 0, 16)
SecTitle.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
SecTitle.BorderColor3 = Color3.fromRGB(255, 255, 255)
SecTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SecTitle.Font = Enum.Font.Code
SecTitle.TextSize = 11
SecTitle.TextXAlignment = Enum.TextXAlignment.Left
SecTitle.Parent = Section

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -12, 1, -24)
Container.Position = UDim2.new(0, 6, 0, 20)
Container.BackgroundTransparency = 1
Container.Parent = Section

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.Parent = Container

-- Micro Macro Helper for Checkboxes
local function CreateCheckbox(labelText, property)
    local F = Instance.new("Frame") F.Size = UDim2.new(1, 0, 0, 20) F.BackgroundTransparency = 1 F.Parent = Container
    local Box = Instance.new("TextButton") Box.Size = UDim2.new(0, 12, 0, 12) Box.Position = UDim2.new(0, 0, 0.5, -6) Box.BackgroundColor3 = Color3.fromRGB(20, 20, 20) Box.BorderColor3 = Color3.fromRGB(255, 255, 255) Box.Text = "" Box.Parent = F
    local L = Instance.new("TextLabel") L.Text = labelText L.Size = UDim2.new(1, -20, 1, 0) L.Position = UDim2.new(0, 20, 0, 0) L.TextColor3 = Color3.fromRGB(200, 200, 200) L.Font = Enum.Font.Code L.TextSize = 11 L.TextXAlignment = Enum.TextXAlignment.Left L.BackgroundTransparency = 1 L.Parent = F
    
    Box.MouseButton1Click:Connect(function()
        Config[property] = not Config[property]
        Box.Text = Config[property] and "✓" or ""
        Box.BackgroundColor3 = Config[property] and Color3.fromRGB(0, 191, 255) or Color3.fromRGB(20, 20, 20)
        Box.BorderColor3 = Config[property] and Color3.fromRGB(0, 191, 255) or Color3.fromRGB(25, 25, 25)
    end)
end

CreateCheckbox("enable bounding esp boxes", "Boxes")
CreateCheckbox("enable dynamic overhead tags", "Names")

-- Footnote
local Footer = Instance.new("TextLabel")
Footer.Text = "[PRESS LEFT CONTROL TO DROP MENUS]"
Footer.Size = UDim2.new(1, 0, 0, 15)
Footer.Position = UDim2.new(0, 0, 1, -15)
Footer.TextColor3 = Color3.fromRGB(120, 120, 120)
Footer.Font = Enum.Font.Code
Footer.TextSize = 10
Footer.BackgroundTransparency = 1
Footer.Parent = Window

------------------------------------------------------------
-- VISUAL TRACKING ACTIVE RENDERING PIPELINE
------------------------------------------------------------
local function createTrackerGui(instance, name)
    if activeTrackers[instance] then return end

    local bbGui = Instance.new("BillboardGui")
    bbGui.Name = "ActiveMatrixNode"
    bbGui.Size = UDim2.new(0, 50, 0, 50) -- Box shape profile
    bbGui.AlwaysOnTop = true
    bbGui.Adornee = instance
    bbGui.Parent = serious_matrix_hub

    local borderBox = Instance.new("Frame")
    borderBox.Size = UDim2.new(1, 0, 1, 0)
    borderBox.BackgroundTransparency = 1
    borderBox.BorderSizePixel = 1
    borderBox.BorderColor3 = Config.TrackerColor
    borderBox.Visible = false
    borderBox.Parent = bbGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 12)
    label.Position = UDim2.new(0, 0, 0, -14)
    label.BackgroundTransparency = 1
    label.Text = string.upper(name)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Code
    label.TextSize = 10
    label.Visible = false
    label.Parent = bbGui

    activeTrackers[instance] = {Gui = bbGui, Box = borderBox, Label = label}
end

RunService.RenderStepped:Connect(function()
    local targets = workspace:GetDescendants()
    for i = 1, #targets do
        local obj = targets[i]
        if obj:IsA("BasePart") and (obj.Name == "Target" or (obj.Name == "Head" and not Players:GetPlayerFromCharacter(obj.Parent))) then
            if not obj:IsDescendantOf(LocalPlayer.Character) then
                createTrackerGui(obj, obj.Parent.Name or "Target")
                
                local element = activeTrackers[obj]
                if element then
                    element.Box.Visible = Config.Boxes
                    element.Label.Visible = Config.Names
                end
            end
        end
    end

    for part, element in pairs(activeTrackers) do
        if not part or not part.Parent then
            if element.Gui then element.Gui:Destroy() end
            activeTrackers[part] = nil
        end
    end
end)

-- Absolute Override Keyboard Toggle
local windowOpen = true
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftControl then
        windowOpen = not windowOpen
        Window.Visible = windowOpen
    end
end)
