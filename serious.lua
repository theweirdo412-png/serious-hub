-- ====================================================================
-- serious ARCHITECTURE v3.0 - METRIC MATRIX & ACTIVE ENGINE
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
-- CORE FUNCTIONAL STATE
------------------------------------------------------------
local ESP_Settings = {
    Boxes = false,
    Names = false,
    Tracers = false,
    Color = Color3.fromRGB(0, 191, 255) -- Neon Azure Blue
}

local activeTrackers = {}

-- Main CanvasGroup (Forces clean fade-in execution transitions)
local Window = Instance.new("CanvasGroup")
Window.Name = "MainWindow"
Window.Size = UDim2.new(0, 520, 0, 440)
Window.Position = UDim2.new(0.5, -260, 0.5, -220)
Window.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Window.BorderSizePixel = 1
Window.BorderColor3 = Color3.fromRGB(255, 255, 255)
Window.GroupTransparency = 1
Window.Parent = serious_matrix_hub

-- Dragging Core Engine
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
Window.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true dragStart = input.Position startPos = Window.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
Window.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)

-- Top Library Window Identifier
local ScriptTitle = Instance.new("TextLabel")
ScriptTitle.Text = " serious architecture // framework.ui"
ScriptTitle.Size = UDim2.new(1, 0, 0, 22)
ScriptTitle.Position = UDim2.new(0, 5, 0, 2)
ScriptTitle.TextColor3 = Color3.fromRGB(140, 140, 140)
ScriptTitle.Font = Enum.Font.Code
ScriptTitle.TextSize = 11
ScriptTitle.TextXAlignment = Enum.TextXAlignment.Left
ScriptTitle.BackgroundTransparency = 1
ScriptTitle.Parent = Window

-- Horizontal Navbar
local TabsPanel = Instance.new("Frame")
TabsPanel.Size = UDim2.new(1, -16, 0, 25)
TabsPanel.Position = UDim2.new(0, 8, 0, 24)
TabsPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TabsPanel.BorderColor3 = Color3.fromRGB(60, 60, 60)
TabsPanel.Parent = Window

local TabButtonsLayout = Instance.new("UIListLayout")
TabButtonsLayout.FillDirection = Enum.FillDirection.Horizontal
TabButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabButtonsLayout.Padding = UDim.new(0, 2)
TabButtonsLayout.Parent = TabsPanel

-- Pages Deck Container
local Deck = Instance.new("Frame")
Deck.Size = UDim2.new(1, -16, 1, -64)
Deck.Position = UDim2.new(0, 8, 0, 56)
Deck.BackgroundTransparency = 1
Deck.Parent = Window

local pages = {}
local activePage = nil

local function CreatePage(name, order)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 70, 1, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Btn.BorderColor3 = Color3.fromRGB(45, 45, 45)
    Btn.Text = string.upper(name)
    Btn.TextColor3 = Color3.fromRGB(160, 160, 160)
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
    local LL = Instance.new("UIListLayout") LL.Padding = UDim.new(0, 10) LL.Parent = Left

    local Right = Instance.new("Frame") Right.Name = "Right" Right.Size = UDim2.new(0.5, -4, 1, 0) Right.Position = UDim2.new(0.5, 4, 0, 0) Right.BackgroundTransparency = 1 Right.Parent = ContentFrame
    local RL = Instance.new("UIListLayout") RL.Padding = UDim.new(0, 10) RL.Parent = Right

    Btn.MouseButton1Click:Connect(function()
        if activePage then activePage.Visible = false end
        for _, b in pairs(TabsPanel:GetChildren()) do if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(160, 160, 160) b.BorderColor3 = Color3.fromRGB(45, 45, 45) end end
        Btn.TextColor3 = Color3.fromRGB(0, 191, 255)
        Btn.BorderColor3 = Color3.fromRGB(0, 191, 255)
        ContentFrame.Visible = true activePage = ContentFrame
    end)

    pages[name] = {Left = Left, Right = Right, Button = Btn}
end

local function CreateSection(parentCol, titleText, height)
    local Sec = Instance.new("Frame")
    Sec.Size = UDim2.new(1, 0, 0, height)
    Sec.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Sec.BorderColor3 = Color3.fromRGB(255, 255, 255)
    Sec.Parent = parentCol

    local Head = Instance.new("TextLabel")
    Head.Text = "  " .. string.lower(titleText)
    Head.Size = UDim2.new(1, 0, 0, 16)
    Head.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
    Head.BorderColor3 = Color3.fromRGB(255, 255, 255)
    Head.TextColor3 = Color3.fromRGB(255, 255, 255)
    Head.Font = Enum.Font.Code
    Head.TextSize = 11
    Head.TextXAlignment = Enum.TextXAlignment.Left
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

local function AddToggle(sec, text, callback)
    local F = Instance.new("Frame") F.Size = UDim2.new(1, 0, 0, 18) F.BackgroundTransparency = 1 F.Parent = sec
    local Box = Instance.new("TextButton") Box.Size = UDim2.new(0, 10, 0, 10) Box.Position = UDim2.new(0, 0, 0.5, -5) Box.BackgroundColor3 = Color3.fromRGB(20, 20, 20) Box.BorderColor3 = Color3.fromRGB(255, 255, 255) Box.Text = "" Box.Parent = F
    local L = Instance.new("TextLabel") L.Text = text L.Size = UDim2.new(1, -16, 1, 0) L.Position = UDim2.new(0, 16, 0, 0) L.TextColor3 = Color3.fromRGB(200, 200, 200) L.Font = Enum.Font.Code L.TextSize = 11 L.TextXAlignment = Enum.TextXAlignment.Left L.BackgroundTransparency = 1 L.Parent = F
    
    local active = false Box.MouseButton1Click:Connect(function()
        active = not active
        Box.BackgroundColor3 = active and Color3.fromRGB(0, 191, 255) or Color3.fromRGB(20, 20, 20)
        Box.BorderColor3 = active and Color3.fromRGB(0, 191, 255) or Color3.fromRGB(255, 255, 255)
        callback(active)
    end)
    
    Box.MouseEnter:Connect(function() TweenService:Create(L, TweenInfo.new(0.12), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play() end)
    Box.MouseLeave:Connect(function() TweenService:Create(L, TweenInfo.new(0.12), {TextColor3 = Color3.fromRGB(200, 200, 200)}):Play() end)
end

local function AddDropdown(sec, text, optionText)
    local F = Instance.new("Frame") F.Size = UDim2.new(1, 0, 0, 32) F.BackgroundTransparency = 1 F.Parent = sec
    local L = Instance.new("TextLabel") L.Text = text L.Size = UDim2.new(1, 0, 0, 14) L.TextColor3 = Color3.fromRGB(150, 150, 150) L.Font = Enum.Font.Code L.TextSize = 10 L.TextXAlignment = Enum.TextXAlignment.Left L.BackgroundTransparency = 1 L.Parent = F
    local D = Instance.new("TextButton") D.Size = UDim2.new(1, 0, 0, 16) D.Position = UDim2.new(0, 0, 0, 14) D.BackgroundColor3 = Color3.fromRGB(15, 15, 15) D.BorderColor3 = Color3.fromRGB(255, 255, 255) D.Text = " " .. optionText .. "  ▼" D.TextColor3 = Color3.fromRGB(255, 255, 255) D.Font = Enum.Font.Code D.TextSize = 11 D.TextXAlignment = Enum.TextXAlignment.Left D.Parent = F
end

-- POPULATING PAGES
CreatePage("main", 1)
CreatePage("world", 2)
CreatePage("esp", 3)
CreatePage("visuals", 4)
CreatePage("settings", 5)

------------------------------------------------------------
-- PAGE 1: MAIN
------------------------------------------------------------
local MainLeft, MainRight = pages["main"].Left, pages["main"].Right
local SilentAimSec = CreateSection(MainLeft, "silent aim / aimbot", 130)
AddToggle(SilentAimSec, "enabled", function(v) end)
AddToggle(SilentAimSec, "manipulation", function(v) end)
AddToggle(SilentAimSec, "closest part", function(v) end)
AddToggle(SilentAimSec, "visualize", function(v) end)

local TargetingSec = CreateSection(MainLeft, "targeting parameters", 200)
AddToggle(TargetingSec, "visible only", function(v) end)
AddToggle(TargetingSec, "ignore protector", function(v) end)
AddDropdown(TargetingSec, "ignore if", "shield, katana")
AddToggle(TargetingSec, "limit distance", function(v) end)
AddDropdown(TargetingSec, "target part selection", "Head")

local TriggerSec = CreateSection(MainRight, "triggerbot core", 45)
AddToggle(TriggerSec, "enabled", function(v) end)

local WeaponSec = CreateSection(MainRight, "weapon configuration", 115)
AddToggle(WeaponSec, "no spread", function(v) end)
AddToggle(WeaponSec, "full auto", function(v) end)
AddToggle(WeaponSec, "always backstab", function(v) end)
AddDropdown(WeaponSec, "grenade options", "none")

local RageSec = CreateSection(MainRight, "ragebot configuration", 140)
AddToggle(RageSec, "enabled", function(v) end)
AddToggle(RageSec, "void spam", function(v) end)AddDropdown(RageSec, "attack matrix mode", "gun")AddDropdown(RageSec, "preferred asset slot", "primary")

-- PAGE 3: ESP (FUNCTIONAL BACKEND INTERFACES)local ESPLeft, ESPRight = pages["esp"].Left, pages["esp"].Rightlocal EnemyESP = CreateSection(ESPLeft, "enemy tracking settings", 110)AddToggle(EnemyESP, "bounding boxes", function(state)ESP_Settings.Boxes = stateend)AddToggle(EnemyESP, "name tags", function(state)ESP_Settings.Names = stateend)AddToggle(EnemyESP, "line tracers", function(state)ESP_Settings.Tracers = stateend)-- VISUAL TRACKING ACTIVE RENDERING PIPELINElocal function createTrackerGui(instance, name)if activeTrackers[instance] then return endlocal bbGui = Instance.new("BillboardGui")bbGui.Name = "ActiveMatrixNode"bbGui.Size = UDim2.new(0, 130, 0, 45)bbGui.AlwaysOnTop = truebbGui.ExtentsOffset = Vector3.new(0, 1.5, 0)bbGui.Adornee = instancebbGui.Parent = serious_matrix_hub-- Custom Retro 2D Box Outlinelocal borderBox = Instance.new("Frame")borderBox.Size = UDim2.new(1, 0, 1, 0)borderBox.BackgroundTransparency = 1borderBox.BorderSizePixel = 1borderBox.BorderColor3 = ESP_Settings.ColorborderBox.Visible = falseborderBox.Parent = bbGui-- Tag Labellocal label = Instance.new("TextLabel")label.Size = UDim2.new(1, 0, 0, 12)label.Position = UDim2.new(0, 0, 0, -14)label.BackgroundTransparency = 1label.Text = string.upper(name)label.TextColor3 = Color3.fromRGB(255, 255, 255)label.Font = Enum.Font.Codelabel.TextSize = 10label.Visible = falselabel.Parent = bbGuiactiveTrackers[instance] = {Gui = bbGui, Box = borderBox, Label = label}endRunService.RenderStepped:Connect(function()-- Deep scan map elements to support both Firing Range bots and Public Userslocal targets = workspace:GetDescendants()for i = 1, #targets dolocal obj = targets[i]if obj:IsA("BasePart") and (obj.Name == "Target" or (obj.Name == "Head" and not Players:GetPlayerFromCharacter(obj.Parent))) thenif not obj:IsDescendantOf(LocalPlayer.Character) thencreateTrackerGui(obj, obj.Parent.Name or "Target")local element = activeTrackers[obj]if element thenelement.Box.Visible = ESP_Settings.Boxeselement.Label.Visible = ESP_Settings.Nameselement.Box.BorderColor3 = ESP_Settings.Colorendendendend-- Clean up despawned elementsfor part, element in pairs(activeTrackers) doif not part or not part.Parent thenif element.Gui then element.Gui:Destroy() endactiveTrackers[part] = nilendendend)-- Boot Configurationpages["main"].Button.TextColor3 = Color3.fromRGB(0, 191, 255)pages["main"].Button.BorderColor3 = Color3.fromRGB(0, 191, 255)pages["main"].Left.Parent.Visible = true activePage = pages["main"].Left.Parent-- Initialization AnimationWindow.Size = UDim2.new(0, 480, 0, 400)Window.Position = UDim2.new(0.5, -240, 0.5, -200)TweenService:Create(Window, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 0, Size = UDim2.new(0, 520, 0, 440), Position = UDim2.new(0.5, -260, 0.5, -220)}):Play()-- Open/Close keybind handlerlocal windowOpen = trueUserInputService.InputBegan:Connect(function(input, processed)if not processed and input.KeyCode == Enum.KeyCode.LeftControl thenwindowOpen = not windowOpen Window.Visible = windowOpenendend)
