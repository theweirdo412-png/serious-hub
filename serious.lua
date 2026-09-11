-- ====================================================================
-- ANONYMOUS SENSOR LAYOUT
-- ====================================================================
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local Active = true
local Cache = {}

-- Generate a completely randomized name for the UI so the game can't audit it
local function GenerateRandomName()
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    local length = math.random(8, 14)
    local randomString = ""
    for i = 1, length do
        local rand = math.random(1, #chars)
        randomString = randomString .. string.sub(chars, rand, rand)
    end
    return randomString
end

local function CreateAnonymousTag(part)
    if Cache[part] then return end

    local gui = Instance.new("BillboardGui")
    gui.Name = GenerateRandomName() -- Hidden under a random string name
    gui.Size = UDim2.new(0, 80, 0, 20)
    gui.AlwaysOnTop = true
    gui.ExtentsOffset = Vector3.new(0, 2, 0)
    gui.Adornee = part
    
    -- Save it in the player's local character folder instead of the main core GUI
    if LocalPlayer.Character then
        gui.Parent = LocalPlayer.Character
    end

    local text = Instance.new("TextLabel")
    text.Name = GenerateRandomName()
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "•" -- Use a simple generic dot instead of a loud target tag
    text.TextColor3 = Color3.fromRGB(0, 191, 255)
    text.TextSize = 14
    text.Parent = gui

    Cache[part] = gui
end

RunService.RenderStepped:Connect(function()
    if not Active then return end
    
    -- Instead of looping everything, we only check the standard workspace players profile
    local playersList = Players:GetPlayers()
    for i = 1, #playersList do
        local p = playersList[i]
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            CreateAnonymousTag(p.Character.Head)
        end
    end
end)
