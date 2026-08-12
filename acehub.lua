--[[
    Acehub - Final Version
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera
local PG = LP:WaitForChild("PlayerGui")
local StarterGui = game:GetService("StarterGui")

pcall(function()
    if PG:FindFirstChild("AcehubUI") then
        PG.AcehubUI:Destroy()
    end
end)

-- State
local selected = nil
local infoSelected = nil
local hear = false
local espOn = true
local uiVisible = true
local currentTab = "Main"
local expand, conns, draws = nil, {}, {}
local searchText = ""
local infoSearch = ""
local walkSpeed = 16
local speedConn = nil

local UPDATE_URL = "https://raw.githubusercontent.com/acid-alt/Ace-hub/main/acehub.lua"
local UPDATE_PASSWORD = "malaki@2017"

-- UI
local gui = Instance.new("ScreenGui")
gui.Name = "AcehubUI"
gui.ResetOnSpawn = false
gui.Parent = PG

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 460, 0, 520)
main.Position = UDim2.new(0.5, -230, 0.5, -260)
main.BackgroundColor3 = Color3.fromRGB(18, 14, 28)
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundColor3 = Color3.fromRGB(24, 18, 38)
titleBar.BorderSizePixel = 0
titleBar.Parent = main
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.new(0, 14, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Acehub"
title.TextColor3 = Color3.fromRGB(200, 160, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 52, 1, -36)
sidebar.Position = UDim2.new(0, 0, 0, 36)
sidebar.BackgroundColor3 = Color3.fromRGB(22, 16, 36)
sidebar.BorderSizePixel = 0
sidebar.Parent = main

local function createSideBtn(icon, y)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 42)
    btn.Position = UDim2.new(0, 5, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(32, 24, 52)
    btn.Text = icon
    btn.TextColor3 = Color3.fromRGB(180, 140, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Parent = sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

local mainBtn   = createSideBtn("◉", 12)
local infoBtn   = createSideBtn("ℹ", 64)
local emoteBtn  = createSideBtn("☺", 116)
local toolsBtn  = createSideBtn("⚒", 168)
local updateBtn = createSideBtn("⟳", 220)

-- Content
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -60, 1, -44)
content.Position = UDim2.new(0, 56, 0, 40)
content.BackgroundTransparency = 1
content.Parent = main

local mainPage = Instance.new("Frame")
mainPage.Size = UDim2.new(1, 0, 1, 0)
mainPage.BackgroundTransparency = 1
mainPage.Visible = true
mainPage.Parent = content

local infoPage = Instance.new("Frame")
infoPage.Size = UDim2.new(1, 0, 1, 0)
infoPage.BackgroundTransparency = 1
infoPage.Visible = false
infoPage.Parent = content

local emotePage = Instance.new("Frame")
emotePage.Size = UDim2.new(1, 0, 1, 0)
emotePage.BackgroundTransparency = 1
emotePage.Visible = false
emotePage.Parent = content

local toolsPage = Instance.new("Frame")
toolsPage.Size = UDim2.new(1, 0, 1, 0)
toolsPage.BackgroundTransparency = 1
toolsPage.Visible = false
toolsPage.Parent = content

local updatePage = Instance.new("Frame")
updatePage.Size = UDim2.new(1, 0, 1, 0)
updatePage.BackgroundTransparency = 1
updatePage.Visible = false
updatePage.Parent = content

-- ========== MAIN PAGE ==========
local function createToggleRow(parent, text, y, defaultOn)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 36)
    row.Position = UDim2.new(0, 5, 0, y)
    row.BackgroundColor3 = Color3.fromRGB(28, 22, 45)
    row.BorderSizePixel = 0
    row.Parent = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 210, 255)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 34, 0, 18)
    toggle.Position = UDim2.new(1, -46, 0.5, -9)
    toggle.BackgroundColor3 = defaultOn and Color3.fromRGB(120, 70, 220) or Color3.fromRGB(50, 40, 70)
    toggle.BorderSizePixel = 0
    toggle.Parent = row
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = defaultOn and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(240, 230, 255)
    knob.BorderSizePixel = 0
    knob.Parent = toggle
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = row

    return row, toggle, knob, btn
end

local espRow, espToggle, espKnob, espBtn = createToggleRow(mainPage, "ESP", 5, true)
local hearRow, hearToggle, hearKnob, hearBtn = createToggleRow(mainPage, "Listening", 46, false)

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -10, 0, 18)
speedLabel.Position = UDim2.new(0, 8, 0, 92)
speedLabel.BackgroundTransparency = 1