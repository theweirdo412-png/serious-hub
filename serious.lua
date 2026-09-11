-- ====================================================================
-- serious CORE ENGINE v4.1 - LINORIA ARCHITECTURE PROFILE
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
-- GLOBAL STATE SYSTEM
------------------------------------------------------------
local Config = {
    Boxes = false,
    Names = false,
    TrackerColor = Color3.fromRGB(59, 122, 219) -- Slate Blue Accent from image
}

local activeTrackers = {}

-- Main Core Window (Linoria High-Density Bounding Box Style)
local Window = Instance.new("Frame")
Window.Name = "MainWindow"
Window.Size = UDim2.new(0, 560, 0, 480)
Window.Position = UDim2.new(0.5, -280, 0.5, -240)
Window.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Dark Slate Gray base background
Window.BorderSizePixel = 1
Window.BorderColor3 = Color3.fromRGB(0, 0, 0) -- Outer technical border outline
Window.Active = true
Window.Draggable = true
Window.Parent = serious_matrix_hub

local OuterBorder = Instance.new("Frame")
OuterBorder.Size = UDim2.new(1, 2, 1, 2)
OuterBorder.Position = UDim2.new(0, -1, 0, -1)
OuterBorder.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
OuterBorder.BorderSizePixel = 1
OuterBorder.BorderColor3 = Color3.fromRGB(0, 0, 0)
OuterBorder.ZIndex = 0
OuterBorder.Parent = Window

-- Script Title Text Header Banner Strip
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 20)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TopBar.BorderSizePixel = 0
TopBar.Parent = Window

local Title = Instance.new("TextLabel")
Title.Text = "  Unnamed Enhancements - discord.gg/enhancements     Rivals"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.TextColor3 = Color3.fromRGB(220, 220, 220)
Title.Font = Enum.Font.Code
Title.TextSize = 11
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = TopBar

-- Horizontal Tabs Bar Navigation Deck Strip (Matches image tab design layout)
local TabsPanel = Instance.new("Frame")
TabsPanel.Size = UDim2.new(1, -12, 0, 22)
TabsPanel.Position = UDim2.new(0, 6, 0, 26)
TabsPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TabsPanel.BorderColor3 = Color3.fromRGB(45, 45, 45)
TabsPanel.Parent = Window

local TabButtonsLayout = Instance.new("UIListLayout")
TabButtonsLayout.FillDirection = Enum.FillDirection.Horizontal
TabButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabButtonsLayout.Padding = UDim.new(0, 2)
TabButtonsLayout.Parent = TabsPanel

-- Content Viewer Canvas Deck Panels Container
local Deck = Instance.new("Frame")
Deck.Size = UDim2.new(1, -12, 1, -56)
Deck.Position = UDim2.new(0, 6, 0, 50)
Deck.BackgroundTransparency = 1
Deck.Parent = Window

local pages = {}
local activePage = nil

local function CreatePage(name, order)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 72, 1, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Btn.BorderColor3 = Color3.fromRGB(40, 40, 40)
    Btn.Text = string.lower(name)
    Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    Btn.Font = Enum.Font.Code
    Btn.TextSize = 11
    Btn.LayoutOrder = order
    Btn.Parent = TabsPanel

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, 0, 1, 0)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Visible = false
    ContentFrame.Parent = Deck

    local Left = Instance.new("Frame") Left.Name = "Left" Left.Size = UDim2.new(0.5, -4, 1, 0) Left.BackgroundTransparency = 1 Left.Parent = ContentFrame
    local LL = Instance.new("UIListLayout") LL.Padding = UDim.new(0, 8) LL.Parent = Left

    local Right = Instance.new("Frame") Right.Name = "Right" Right.Size = UDim2.new(0.5, -4, 1, 0) Right.Position = UDim2.new(0.5, 4, 0, 0) Right.BackgroundTransparency = 1 Right.Parent = ContentFrame
    local RL = Instance.new("UIListLayout") RL.Padding = UDim.new(0, 8) RL.Parent = Right

    Btn.MouseButton1Click:Connect(function()
        if activePage then activePage.Visible = false end
        for _, b in pairs(TabsPanel:GetChildren()) do if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(150, 150, 150) b.BackgroundColor3 = Color3.fromRGB(20, 20, 20) b.BorderColor3 = Color3.fromRGB(40, 40, 40) end end
        Btn.TextColor3 = Color3.fromRGB(59, 122, 219) -- Slate blue highlighted text on click
        Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Btn.BorderColor3 = Color3.fromRGB(55, 55, 55)
        ContentFrame.Visible = true 
        activePage = ContentFrame
    end)

    pages[name] = {Left = Left, Right = Right, Button = Btn, Frame = ContentFrame}
end

-- Structural Nested Bounding Box Section Maker
local function CreateSection(parentCol, titleText, height)
    local Sec = Instance.new("Frame")
    Sec.Size = UDim2.new(1, 0, 0, height)
    Sec.BackgroundColor3 = Color3.fromRGB(16, 16, 16) -- Dark charcoal interior container box vibe
    Sec.BorderColor3 = Color3.fromRGB(45, 45, 45) -- White-ish technical divider outline 
    Sec.Parent = parentCol

    local Head = Instance.new("TextLabel")
    Head.Text = "  " .. string.lower(titleText)
    Head.Size = UDim2.new(0, 110, 0, 14)
    Head.Position = UDim2.new(0, 10, 0, -8)
    Head.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
    Head.BorderSizePixel = 0
    Head.TextColor3 = Color3.fromRGB(180, 40, 40) -- Crimson Red Section Head Text Identifiers
    Head.Font = Enum.Font.Code
    Head.TextSize = 11
    Head.TextXAlignment = Enum.TextXAlignment.Left
    Head.Parent = Sec

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -12, 1, -14)
    Container.Position = UDim2.new(0, 6, 0, 8)
    Container.BackgroundTransparency = 1
    Container.Parent = Sec

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 5)
    Layout.Parent = Container

    return Container
end

-- Checkbox Layout Macro Builder
local function AddToggle(sec, text, property)
    local F = Instance.new("Frame") F.Size = UDim2.new(1, 0, 0, 16) F.BackgroundTransparency = 1 F.Parent = sec
    local Box = Instance.new("TextButton") Box.Size = UDim2.new(0, 10, 0, 10) Box.Position = UDim2.new(0, 0, 0.5, -5) Box.BackgroundColor3 = Color3.fromRGB(22, 22, 22) Box.BorderColor3 = Color3.fromRGB(45, 45, 45) Box.Text = "" Box.Parent = F
    local L = Instance.new("TextLabel") L.Text = text L.Size = UDim2.new(1, -16, 1, 0) L.Position = UDim2.new(0, 16, 0, 0) L.TextColor3 = Color3.fromRGB(230, 230, 230) L.Font = Enum.Font.Code L.TextSize = 11 L.TextXAlignment = Enum.TextXAlignment.Left L.BackgroundTransparency = 1 L.Parent = F
    
    Box.MouseButton1Click:Connect(function()
        Config[property] = not Config[property]
        Box.Text = Config[property] and "✓" or ""
        Box.BackgroundColor3 = Config[property] and Color3.fromRGB(59, 122, 219) or Color3.fromRGB(22, 22, 22) -- Bright Slate Blue fill colors
        Box.BorderColor3 = Config[property] and Color3.fromRGB(59, 122, 219) or Color3.fromRGB(45, 45, 45)
    end)
end

local function AddSlider(sec, text, valueText)
    local F = Instance.new("Frame") F.Size = UDim2.new(1, 0, 0, 24) F.BackgroundTransparency = 1 F.Parent = sec
    local S = Instance.new("Frame") S.Size = UDim2.new(1, 0, 0, 12) S.Position = UDim2.new(0, 0, 0, 4) S.BackgroundColor3 = Color3.fromRGB(25, 25, 25) S.BorderColor3 = Color3.fromRGB(40, 40, 40) S.Parent = F
    local Fill = Instance.new("Frame") Fill.Size = UDim2.new(0.65, 0, 1, 0) Fill.BackgroundColor3 = Color3.fromRGB(59, 122, 219) Fill.BorderSizePixel = 0 Fill.Parent = S
    local L = Instance.new("TextLabel") L.Text = text .. ": " .. valueText L.Size = UDim2.new(1, 0, 1, 0) L.TextColor3 = Color3.fromRGB(255, 255, 255) L.Font = Enum.Font.Code L.TextSize = 10 L.BackgroundTransparency = 1 L.Parent = S
end

local function AddDropdown(sec, text, optionText)
    local F = Instance.new("Frame") F.Size = UDim2.new(1, 0, 0, 30) F.BackgroundTransparency = 1 F.Parent = sec
    local L = Instance.new("TextLabel") L.Text = text L.Size = UDim2.new(1, 0, 0, 12) L.TextColor3 = Color3.fromRGB(130, 130, 130) L.Font = Enum.Font.Code L.TextSize = 10 L.TextXAlignment = Enum.TextXAlignment.Left L.BackgroundTransparency = 1 L.Parent = F
    local D = Instance.new("TextButton") D.Size = UDim2.new(1, 0, 0, 14) D.Position = UDim2.new(0, 0, 0, 12) D.BackgroundColor3 = Color3.fromRGB(22, 22, 22) D.BorderColor3 = Color3.fromRGB(45, 45, 45) D.Text = " " .. optionText .. "  >" D.TextColor3 = Color3.fromRGB(240, 240, 240) D.Font = Enum.Font.Code D.TextSize = 11 D.TextXAlignment = Enum.TextXAlignment.Left D.Parent = F
end

-- POPULATING TABS LAYOUT STRUCT
CreatePage("main", 1)
CreatePage("world", 2)
CreatePage("esp", 3)
CreatePage("visuals", 4)
CreatePage("character", 5)
CreatePage("misc", 6)
CreatePage("settings", 7)

------------------------------------------------------------
-- TAB 1: MAIN
------------------------------------------------------------
local M_Left, M_Right = pages["main"].Left, pages["main"].Right
local SilentAimSec = CreateSection(M_Left, "silent aim / aimbot", 130)
AddToggle(SilentAimSec, "enabled", "SilentAim")
AddToggle(SilentAimSec, "closest part", "ClosestPart")
AddToggle(SilentAimSec, "closest position", "ClosestPos")
AddToggle(SilentAimSec, "delay position", "DelayPos")
AddSlider(SilentAimSec, "radius", "100px")
AddSlider(SilentAimSec, "smoothing", "100%")

local TargetingSec = CreateSection(M_Left, "targeting parameters", 155)
local windowOpen = trueUserInputService.InputBegan:Connect(function(input)if input.KeyCode == Enum.KeyCode.LeftControl thenwindowOpen = not windowOpenWindow.Visible = windowOpenendend)
    local selectionBox = Instance.new("SelectionBox")selectionBox.Name = "serious_3d_box"selectionBox.Color3 = Config.TrackerColorselectionBox.LineThickness = 0.05selectionBox.AlwaysOnTop = trueselectionBox.Visible = falseselectionBox.Adornee = instanceselectionBox.Parent = serious_matrix_hublocal bbGui = Instance.new("BillboardGui")bbGui.Name = "serious_tag"bbGui.Size = UDim2.new(0, 100, 0, 20)bbGui.AlwaysOnTop = truebbGui.ExtentsOffset = Vector3.new(0, 2, 0)bbGui.Adornee = instancebbGui.Parent = serious_matrix_hublocal label = Instance.new("TextLabel")label.Size = UDim2.new(1, 0, 1, 0)label.BackgroundTransparency = 1label.Text = string.upper(name)label.TextColor3 = Color3.fromRGB(255, 255, 255)label.Font = Enum.Font.Codelabel.TextSize = 11label.Visible = falselabel.Parent = bbGuiactiveTrackers[instance] = {Box = selectionBox, Gui = bbGui, Label = label}endRunService.RenderStepped:Connect(function()local targets = workspace:GetDescendants()for i = 1, #targets dolocal obj = targets[i]if obj:IsA("BasePart") and (obj.Name == "Target" or (obj.Name == "Head" and not Players:GetPlayerFromCharacter(obj.Parent))) thenif not obj:IsDescendantOf(LocalPlayer.Character) thencreateTrackerGui(obj, obj.Parent.Name or "Target")local element = activeTrackers[obj]if element thenelement.Box.Visible = Config.Boxeselement.Label.Visible = Config.Namesendendendendfor part, element in pairs(activeTrackers) doif not part or not part.Parent thenif element.Box then element.Box:Destroy() endif element.Gui then element.Gui:Destroy() endactiveTrackers[part] = nilendendend)(FIXED blank startup bug)pages["main"].Button.TextColor3 = Color3.fromRGB(59, 122, 219)pages["main"].Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)pages["main"].Frame.Visible = trueactivePage = pages["main"].Frame
         (FIXED toggle freeze)local windowOpen = trueUserInputService.InputBegan:Connect(function(input)if input.KeyCode == Enum.KeyCode.LeftControl thenwindowOpen = not windowOpenWindow.Visible = windowOpenendend)
