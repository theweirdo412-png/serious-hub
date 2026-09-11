-- ====================================================================
-- serious CORE ENGINE v4.0 - HIGH DENSITY ENHANCEMENTS ARCHITECTURE
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
-- INTERFACE GLOBAL STATE VALUES
------------------------------------------------------------
local Config = {
    Boxes = false,
    Names = false,
    TrackerColor = Color3.fromRGB(0, 191, 255)
}

local activeTrackers = {}

-- Main Canvas Base Frame (Matches your reference image layout)
local Window = Instance.new("Frame")
Window.Name = "MainWindow"
Window.Size = UDim2.new(0, 560, 0, 480)
Window.Position = UDim2.new(0.5, -280, 0.5, -240)
Window.BackgroundColor3 = Color3.fromRGB(11, 16, 14) -- Deep Forest Dark Gray Vibe
Window.BorderSizePixel = 1
Window.BorderColor3 = Color3.fromRGB(255, 255, 255) -- White Primary Border Outline
Window.Active = true
Window.Draggable = true
Window.Parent = serious_matrix_hub

-- Header Watermark Strip
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 24)
TopBar.BackgroundColor3 = Color3.fromRGB(7, 10, 9)
TopBar.BorderSizePixel = 0
TopBar.Parent = Window

local Title = Instance.new("TextLabel")
Title.Text = "  Unnamed Enhancements - discord.gg/enhancements     Rivals"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.TextColor3 = Color3.fromRGB(180, 40, 40) -- Crimson Red Identity Label
Title.Font = Enum.Font.Code
Title.TextSize = 11
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = TopBar

-- Top Tab Bar Frame Layout Container
local TabsPanel = Instance.new("Frame")
TabsPanel.Size = UDim2.new(1, -16, 0, 24)
TabsPanel.Position = UDim2.new(0, 8, 0, 32)
TabsPanel.BackgroundColor3 = Color3.fromRGB(15, 20, 18)
TabsPanel.BorderColor3 = Color3.fromRGB(40, 50, 45)
TabsPanel.Parent = Window

local TabButtonsLayout = Instance.new("UIListLayout")
TabButtonsLayout.FillDirection = Enum.FillDirection.Horizontal
TabButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabButtonsLayout.Padding = UDim.new(0, 4)
TabButtonsLayout.Parent = TabsPanel

-- Pages Content Viewer Deck
local Deck = Instance.new("Frame")
Deck.Size = UDim2.new(1, -16, 1, -72)
Deck.Position = UDim2.new(0, 8, 0, 64)
Deck.BackgroundTransparency = 1
Deck.Parent = Window

local pages = {}
local activePage = nil

local function CreatePage(name, order)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 68, 1, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 25, 22)
    Btn.BorderColor3 = Color3.fromRGB(50, 60, 55)
    Btn.Text = string.lower(name)
    Btn.TextColor3 = Color3.fromRGB(140, 140, 140)
    Btn.Font = Enum.Font.Code
    Btn.TextSize = 11
    Btn.LayoutOrder = order
    Btn.Parent = TabsPanel

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, 0, 1, 0)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Visible = false
    ContentFrame.Parent = Deck

    -- Left Column Layout Grid
    local Left = Instance.new("ScrollingFrame") Left.Name = "Left" Left.Size = UDim2.new(0.5, -4, 1, 0) Left.BackgroundTransparency = 1 Left.ScrollBarThickness = 1 Left.CanvasSize = UDim2.new(0,0,1.5,0) Left.Parent = ContentFrame
    local LL = Instance.new("UIListLayout") LL.Padding = UDim.new(0, 10) LL.Parent = Left

    -- Right Column Layout Grid
    local Right = Instance.new("ScrollingFrame") Right.Name = "Right" Right.Size = UDim2.new(0.5, -4, 1, 0) Right.Position = UDim2.new(0.5, 4, 0, 0) Right.BackgroundTransparency = 1 Right.ScrollBarThickness = 1 Right.CanvasSize = UDim2.new(0,0,1.5,0) Right.Parent = ContentFrame
    local RL = Instance.new("UIListLayout") RL.Padding = UDim.new(0, 10) RL.Parent = Right

    Btn.MouseButton1Click:Connect(function()
        if activePage then activePage.Visible = false end
        for _, b in pairs(TabsPanel:GetChildren()) do if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(140, 140, 140) b.BackgroundColor3 = Color3.fromRGB(20, 25, 22) end end
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Btn.BackgroundColor3 = Color3.fromRGB(30, 40, 35)
        ContentFrame.Visible = true activePage = ContentFrame
    end)

    pages[name] = {Left = Left, Right = Right, Button = Btn}
end

-- Modular High-Density Section Outline Box (Matches your image sections perfectly)
local function CreateSection(parentCol, titleText, height)
    local Sec = Instance.new("Frame")
    Sec.Size = UDim2.new(1, -4, 0, height)
    Sec.BackgroundColor3 = Color3.fromRGB(12, 18, 15)
    Sec.BorderColor3 = Color3.fromRGB(255, 255, 255) -- White nested outline profile
    Sec.Parent = parentCol

    local Head = Instance.new("TextLabel")
    Head.Text = "          " .. string.lower(titleText)
    Head.Size = UDim2.new(1, 0, 0, 16)
    Head.BackgroundColor3 = Color3.fromRGB(7, 10, 9)
    Head.BorderColor3 = Color3.fromRGB(255, 255, 255)
    Head.TextColor3 = Color3.fromRGB(180, 40, 40) -- Section Titles are Dark Neon Red
    Head.Font = Enum.Font.Code
    Head.TextSize = 11
    Head.TextXAlignment = Enum.TextXAlignment.Center
    Head.Parent = Sec

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -12, 1, -24)
    Container.Position = UDim2.new(0, 6, 0, 20)
    Container.BackgroundTransparency = 1
    Container.Parent = Sec

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 6)
    Layout.Parent = Container

    return Container
end

-- Custom Sub-Injectors for Nested Buttons
local function AddToggle(sec, text, property)
    local F = Instance.new("Frame") F.Size = UDim2.new(1, 0, 0, 18) F.BackgroundTransparency = 1 F.Parent = sec
    local Box = Instance.new("TextButton") Box.Size = UDim2.new(0, 10, 0, 10) Box.Position = UDim2.new(0, 0, 0.5, -5) Box.BackgroundColor3 = Color3.fromRGB(25, 30, 28) Box.BorderColor3 = Color3.fromRGB(255, 255, 255) Box.Text = "" Box.Parent = F
    local L = Instance.new("TextLabel") L.Text = text L.Size = UDim2.new(1, -16, 1, 0) L.Position = UDim2.new(0, 16, 0, 0) L.TextColor3 = Color3.fromRGB(200, 200, 200) L.Font = Enum.Font.Code L.TextSize = 11 L.TextXAlignment = Enum.TextXAlignment.Left L.BackgroundTransparency = 1 L.Parent = F
    
    Box.MouseButton1Click:Connect(function()
        Config[property] = not Config[property]
        Box.Text = Config[property] and "✓" or ""
        Box.BackgroundColor3 = Config[property] and Color3.fromRGB(0, 191, 255) or Color3.fromRGB(25, 30, 28) -- Blue fill highlights
        Box.BorderColor3 = Config[property] and Color3.fromRGB(0, 191, 255) or Color3.fromRGB(255, 255, 255)
    end)
end

local function AddSlider(sec, text, valueText)
    local F = Instance.new("Frame") F.Size = UDim2.new(1, 0, 0, 26) F.BackgroundTransparency = 1 F.Parent = sec
    local S = Instance.new("Frame") S.Size = UDim2.new(1, 0, 0, 14) S.Position = UDim2.new(0, 0, 0, 6) S.BackgroundColor3 = Color3.fromRGB(20, 25, 22) S.BorderColor3 = Color3.fromRGB(255, 255, 255) S.Parent = F
    local Fill = Instance.new("Frame") Fill.Size = UDim2.new(0.65, 0, 1, 0) Fill.BackgroundColor3 = Color3.fromRGB(0, 191, 255) Fill.BorderSizePixel = 0 Fill.Parent = S
    local L = Instance.new("TextLabel") L.Text = text .. ": " .. valueText L.Size = UDim2.new(1, 0, 1, 0) L.TextColor3 = Color3.fromRGB(255, 255, 255) L.Font = Enum.Font.Code L.TextSize = 10 L.BackgroundTransparency = 1 L.Parent = S
end

local function AddDropdown(sec, text, optionText)
    local F = Instance.new("Frame") F.Size = UDim2.new(1, 0, 0, 32) F.BackgroundTransparency = 1 F.Parent = sec
    local L = Instance.new("TextLabel") L.Text = text L.Size = UDim2.new(1, 0, 0, 12) L.TextColor3 = Color3.fromRGB(140, 140, 140) L.Font = Enum.Font.Code L.TextSize = 10 L.TextXAlignment = Enum.TextXAlignment.Left L.BackgroundTransparency = 1 L.Parent = F
    local D = Instance.new("TextButton") D.Size = UDim2.new(1, 0, 0, 16) D.Position = UDim2.new(0, 0, 0, 14) D.BackgroundColor3 = Color3.fromRGB(15, 20, 18) D.BorderColor3 = Color3.fromRGB(255, 255, 255) D.Text = " " .. optionText .. "  >" D.TextColor3 = Color3.fromRGB(255, 255, 255) D.Font = Enum.Font.Code D.TextSize = 11 D.TextXAlignment = Enum.TextXAlignment.Left D.Parent = F
end

-- GENERATING ALL TABS FROM CAPTURED IMAGES
CreatePage("main", 1)
CreatePage("world", 2)
CreatePage("esp", 3)
CreatePage("visuals", 4)
CreatePage("character", 5)
CreatePage("misc", 6)
CreatePage("settings", 7)

------------------------------------------------------------
-- TAB CONTENT: MAIN
------------------------------------------------------------
local M_Left, M_Right = pages["main"].Left, pages["main"].Right
local SilentAimSec = CreateSection(M_Left, "silent aim / aimbot", 130)
AddToggle(SilentAimSec, "enabled", "SilentAim")
AddToggle(SilentAimSec, "closest part", "ClosestPart")
AddToggle(SilentAimSec, "closest position", "ClosestPos")
AddToggle(SilentAimSec, "delay position", "DelayPos")
AddSlider(SilentAimSec, "radius", "100px")
AddSlider(SilentAimSec, "smoothing", "100%")

local TargetingSec = CreateSection(M_Left, "targeting", 170)
AddToggle(TargetingSec, "visible only", "VisOnly")
AddToggle(TargetingSec, "ignore protected", "IgnoreProt")
AddToggle(TargetingSec, "disable on flash", "DisFlash")
AddToggle(TargetingSec, "limit distance", "LimitDist")
AddSlider(TargetingSec, "reaction time", "0ms")
AddSlider(TargetingSec, "forget time", "1s")
AddDropdown(TargetingSec, "target part", "Head")local TriggerSec = CreateSection(M_Right, "triggerbot", 145)AddToggle(TriggerSec, "enabled", "Trigger")AddSlider(TriggerSec, "reaction time", "100ms")AddSlider(TriggerSec, "reaction time offset", "0ms")AddSlider(TriggerSec, "forget time", "0.5s")AddSlider(TriggerSec, "shoot delay", "0ms")AddSlider(TriggerSec, "max distance", "100s")local WeaponSec = CreateSection(M_Right, "weapons", 110)AddToggle(WeaponSec, "no spread", "NoSpread")AddToggle(WeaponSec, "full auto", "FullAuto")AddToggle(WeaponSec, "always backstab", "Backstab")AddDropdown(WeaponSec, "grenade options", "...")AddSlider(WeaponSec, "firerate", "100%")
-- TAB CONTENT: WORLDlocal W_Left = pages["world"].Leftlocal CameraSec = CreateSection(W_Left, "camera", 130)AddToggle(CameraSec, "anti flashbang", "AntiFlash")AddToggle(CameraSec, "fov changer", "FovChanger")AddSlider(CameraSec, "fov", "103")AddToggle(CameraSec, "aspect ratio", "Aspect")AddSlider(CameraSec, "ratio x", "1")AddSlider(CameraSec, "ratio y", "1")local SkyboxSec = CreateSection(W_Left, "skybox", 100)AddToggle(SkyboxSec, "enabled", "SkyEnabled")AddDropdown(SkyboxSec, "selected", "Afternoon")AddDropdown(SkyboxSec, "disable", "visible only during")-- TAB CONTENT: ESP (FUNCTIONAL ACTIVE SENSORS)local E_Left = pages["esp"].Leftlocal DiagnosticsSec = CreateSection(E_Left, "matrix configurations", 90)AddToggle(DiagnosticsSec, "enable bounding esp boxes", "Boxes")AddToggle(DiagnosticsSec, "enable dynamic overhead tags", "Names")-- TAB CONTENT: SETTINGSlocal S_Left, S_Right = pages["settings"].Left, pages["settings"].Rightlocal MenuSec = CreateSection(S_Left, "menu", 90)AddDropdown(MenuSec, "menu bind", "RightShift")AddToggle(MenuSec, "keybind menu", "KbMenu")AddSlider(MenuSec, "menu transparency", "42%")local ThemeSec = CreateSection(S_Left, "themes", 140)AddDropdown(ThemeSec, "theme list", "Default")local ConfigSec = CreateSection(S_Right, "configuration", 160)AddDropdown(ConfigSec, "config list", "...")AddDropdown(ConfigSec, "import from clipboard", "Paste config here...")-- VISUAL TRACKING ACTIVE RENDERING PIPELINE (3D BOX ENGINE)local function createTrackerGui(instance, name)if activeTrackers[instance] then return endlocal selectionBox = Instance.new("SelectionBox")selectionBox.Name = "serious_3d_box"selectionBox.Color3 = Config.TrackerColorselectionBox.LineThickness = 0.05selectionBox.AlwaysOnTop = trueselectionBox.Visible = falseselectionBox.Adornee = instanceselectionBox.Parent = serious_matrix_hublocal bbGui = Instance.new("BillboardGui")bbGui.Name = "serious_tag"bbGui.Size = UDim2.new(0, 100, 0, 20)bbGui.AlwaysOnTop = truebbGui.ExtentsOffset = Vector3.new(0, 2, 0)bbGui.Adornee = instancebbGui.Parent = serious_matrix_hublocal label = Instance.new("TextLabel")label.Size = UDim2.new(1, 0, 1, 0)label.BackgroundTransparency = 1label.Text = string.upper(name)label.TextColor3 = Color3.fromRGB(255, 255, 255)label.Font = Enum.Font.Codelabel.TextSize = 11label.Visible = falselabel.Parent = bbGuiactiveTrackers[instance] = {Box = selectionBox, Gui = bbGui, Label = label}endRunService.RenderStepped:Connect(function()local targets = workspace:GetDescendants()for i = 1, #targets dolocal obj = targets[i]if obj:IsA("BasePart") and (obj.Name == "Target" or (obj.Name == "Head" and not Players:GetPlayerFromCharacter(obj.Parent))) thenif not obj:IsDescendantOf(LocalPlayer.Character) thencreateTrackerGui(obj, obj.Parent.Name or "Target")local element = activeTrackers[obj]if element thenelement.Box.Visible = Config.Boxeselement.Label.Visible = Config.Namesendendendendfor part, element in pairs(activeTrackers) doif not part or not part.Parent thenif element.Box then element.Box:Destroy() endif element.Gui then element.Gui:Destroy() endactiveTrackers[part] = nilendendend)
