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
speedLabel.Text = "WalkSpeed: 16"
speedLabel.TextColor3 = Color3.fromRGB(180, 160, 220)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 12
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = mainPage

local sliderBg = Instance.new("Frame")
sliderBg.Size = UDim2.new(1, -20, 0, 6)
sliderBg.Position = UDim2.new(0, 10, 0, 115)
sliderBg.BackgroundColor3 = Color3.fromRGB(40, 30, 65)
sliderBg.BorderSizePixel = 0
sliderBg.Parent = mainPage
Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.16, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(140, 80, 255)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderBg
Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

local sliderKnob = Instance.new("Frame")
sliderKnob.Size = UDim2.new(0, 14, 0, 14)
sliderKnob.Position = UDim2.new(0.16, -7, 0.5, -7)
sliderKnob.BackgroundColor3 = Color3.fromRGB(210, 180, 255)
sliderKnob.BorderSizePixel = 0
sliderKnob.Parent = sliderBg
Instance.new("UICorner", sliderKnob).CornerRadius = UDim.new(1, 0)

-- WalkSpeed dauerhaft halten
local function applyWalkSpeed()
    if speedConn then
        speedConn:Disconnect()
        speedConn = nil
    end
    speedConn = RunService.Heartbeat:Connect(function()
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed ~= walkSpeed then
            hum.WalkSpeed = walkSpeed
        end
    end)
end

local sliding = false
sliderKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliding = true
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliding = false
    end
end)
UIS.InputChanged:Connect(function(input)
    if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
        local rel = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        sliderFill.Size = UDim2.new(rel, 0, 1, 0)
        sliderKnob.Position = UDim2.new(rel, -7, 0.5, -7)
        walkSpeed = math.max(1, math.floor(rel * 100))
        speedLabel.Text = "WalkSpeed: " .. walkSpeed
        applyWalkSpeed()
    end
end)

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -10, 0, 30)
searchBox.Position = UDim2.new(0, 5, 0, 135)
searchBox.BackgroundColor3 = Color3.fromRGB(28, 22, 45)
searchBox.PlaceholderText = "Suche Spieler..."
searchBox.Text = ""
searchBox.TextColor3 = Color3.fromRGB(220, 210, 255)
searchBox.PlaceholderColor3 = Color3.fromRGB(120, 110, 150)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 13
searchBox.Parent = mainPage
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 7)

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    searchText = searchBox.Text:lower()
    updateList()
end)

local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(1, -10, 1, -175)
list.Position = UDim2.new(0, 5, 0, 172)
list.BackgroundColor3 = Color3.fromRGB(22, 17, 38)
list.BorderSizePixel = 0
list.ScrollBarThickness = 3
list.ScrollBarImageColor3 = Color3.fromRGB(130, 80, 255)
list.Parent = mainPage
Instance.new("UICorner", list).CornerRadius = UDim.new(0, 8)

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 4)
listLayout.Parent = list

-- ========== INFO PAGE ==========
local infoSearchBox = Instance.new("TextBox")
infoSearchBox.Size = UDim2.new(1, -10, 0, 30)
infoSearchBox.Position = UDim2.new(0, 5, 0, 5)
infoSearchBox.BackgroundColor3 = Color3.fromRGB(28, 22, 45)
infoSearchBox.PlaceholderText = "Suche Spieler..."
infoSearchBox.Text = ""
infoSearchBox.TextColor3 = Color3.fromRGB(220, 210, 255)
infoSearchBox.PlaceholderColor3 = Color3.fromRGB(120, 110, 150)
infoSearchBox.Font = Enum.Font.Gotham
infoSearchBox.TextSize = 13
infoSearchBox.Parent = infoPage
Instance.new("UICorner", infoSearchBox).CornerRadius = UDim.new(0, 7)

local infoList = Instance.new("ScrollingFrame")
infoList.Size = UDim2.new(0.42, 0, 1, -45)
infoList.Position = UDim2.new(0, 5, 0, 42)
infoList.BackgroundColor3 = Color3.fromRGB(22, 17, 38)
infoList.BorderSizePixel = 0
infoList.ScrollBarThickness = 3
infoList.Parent = infoPage
Instance.new("UICorner", infoList).CornerRadius = UDim.new(0, 8)

local infoListLayout = Instance.new("UIListLayout")
infoListLayout.Padding = UDim.new(0, 4)
infoListLayout.Parent = infoList

local infoPanel = Instance.new("Frame")
infoPanel.Size = UDim2.new(0.55, -10, 1, -45)
infoPanel.Position = UDim2.new(0.45, 0, 0, 42)
infoPanel.BackgroundColor3 = Color3.fromRGB(26, 20, 42)
infoPanel.BorderSizePixel = 0
infoPanel.Parent = infoPage
Instance.new("UICorner", infoPanel).CornerRadius = UDim.new(0, 8)

local infoTitle = Instance.new("TextLabel")
infoTitle.Size = UDim2.new(1, -16, 0, 28)
infoTitle.Position = UDim2.new(0, 8, 0, 8)
infoTitle.BackgroundTransparency = 1
infoTitle.Text = "Spieler auswählen"
infoTitle.TextColor3 = Color3.fromRGB(200, 170, 255)
infoTitle.Font = Enum.Font.GothamBold
infoTitle.TextSize = 14
infoTitle.TextXAlignment = Enum.TextXAlignment.Left
infoTitle.Parent = infoPanel

local infoContent = Instance.new("TextLabel")
infoContent.Size = UDim2.new(1, -16, 1, -45)
infoContent.Position = UDim2.new(0, 8, 0, 40)
infoContent.BackgroundTransparency = 1
infoContent.Text = "Klicke links auf einen Spieler,\num Infos zu sehen."
infoContent.TextColor3 = Color3.fromRGB(180, 170, 210)
infoContent.Font = Enum.Font.Gotham
infoContent.TextSize = 13
infoContent.TextXAlignment = Enum.TextXAlignment.Left
infoContent.TextYAlignment = Enum.TextYAlignment.Top
infoContent.TextWrapped = true
infoContent.Parent = infoPanel

local function showPlayerInfo(plr)
    if not plr then return end
    infoSelected = plr
    infoTitle.Text = plr.DisplayName

    local membership = "None"
    pcall(function()
        membership = tostring(plr.MembershipType):gsub("Enum.MembershipType.", "")
    end)

    local teamName = plr.Team and plr.Team.Name or "Kein Team"
    local age = plr.AccountAge or 0

    infoContent.Text = string.format(
        "Username: %s\nDisplayName: %s\nUserId: %s\nAccount Age: %s Tage\nMembership: %s\nTeam: %s",
        plr.Name,
        plr.DisplayName,
        plr.UserId,
        age,
        membership,
        teamName
    )
end

local function updateInfoList()
    for _, c in pairs(infoList:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP then
            local fullName = plr.DisplayName
            if plr.DisplayName ~= plr.Name then
                fullName = plr.DisplayName .. " (@" .. plr.Name .. ")"
            end
            if infoSearch == "" or fullName:lower():find(infoSearch) or plr.Name:lower():find(infoSearch) then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -6, 0, 30)
                btn.BackgroundColor3 = (infoSelected == plr) and Color3.fromRGB(50, 32, 90) or Color3.fromRGB(30, 24, 50)
                btn.Text = "  " .. fullName
                btn.TextColor3 = Color3.fromRGB(220, 210, 255)
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 12
                btn.TextXAlignment = Enum.TextXAlignment.Left
                btn.Parent = infoList
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
                btn.MouseButton1Click:Connect(function()
                    showPlayerInfo(plr)
                    updateInfoList()
                end)
            end
        end
    end
    task.wait()
    infoList.CanvasSize = UDim2.new(0, 0, 0, infoListLayout.AbsoluteContentSize.Y + 8)
end

infoSearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    infoSearch = infoSearchBox.Text:lower()
    updateInfoList()
end)

-- ========== EMOTE + TOOLS ==========
local comingSoon = Instance.new("TextLabel")
comingSoon.Size = UDim2.new(1, 0, 1, 0)
comingSoon.BackgroundTransparency = 1
comingSoon.Text = "Coming Soon"
comingSoon.TextColor3 = Color3.fromRGB(150, 130, 190)
comingSoon.Font = Enum.Font.GothamBold
comingSoon.TextSize = 20
comingSoon.Parent = emotePage

local jerkCard = Instance.new("Frame")
jerkCard.Size = UDim2.new(1, -10, 0, 70)
jerkCard.Position = UDim2.new(0, 5, 0, 5)
jerkCard.BackgroundColor3 = Color3.fromRGB(28, 22, 45)
jerkCard.BorderSizePixel = 0
jerkCard.Parent = toolsPage
Instance.new("UICorner", jerkCard).CornerRadius = UDim.new(0, 10)

local jerkTitle = Instance.new("TextLabel")
jerkTitle.Size = UDim2.new(1, -20, 0, 26)
jerkTitle.Position = UDim2.new(0, 12, 0, 8)
jerkTitle.BackgroundTransparency = 1
jerkTitle.Text = "Jerk Tool"
jerkTitle.TextColor3 = Color3.fromRGB(220, 210, 255)
jerkTitle.Font = Enum.Font.GothamBold
jerkTitle.TextSize = 14
jerkTitle.TextXAlignment = Enum.TextXAlignment.Left
jerkTitle.Parent = jerkCard

local giveBtn = Instance.new("TextButton")
giveBtn.Size = UDim2.new(0, 110, 0, 26)
giveBtn.Position = UDim2.new(0, 12, 0, 36)
giveBtn.BackgroundColor3 = Color3.fromRGB(110, 60, 210)
giveBtn.Text = "Give Tool"
giveBtn.TextColor3 = Color3.new(1,1,1)
giveBtn.Font = Enum.Font.GothamBold
giveBtn.TextSize = 12
giveBtn.Parent = jerkCard
Instance.new("UICorner", giveBtn).CornerRadius = UDim.new(0, 7)

giveBtn.MouseButton1Click:Connect(function()
    local tool = Instance.new("Tool")
    tool.Name = "Jerk Tool"
    tool.RequiresHandle = false
    tool.CanBeDropped = false
    tool.Parent = LP.Backpack
    tool.Activated:Connect(function()
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum:PlayEmote("Dance") end) end
    end)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = "Acehub", Text = "Jerk Tool gegeben", Duration = 3})
    end)
end)

-- ========== UPDATE PAGE ==========
local updateTitle = Instance.new("TextLabel")
updateTitle.Size = UDim2.new(1, -20, 0, 30)
updateTitle.Position = UDim2.new(0, 10, 0, 20)
updateTitle.BackgroundTransparency = 1
updateTitle.Text = "Script Update"
updateTitle.TextColor3 = Color3.fromRGB(200, 170, 255)
updateTitle.Font = Enum.Font.GothamBold
updateTitle.TextSize = 18
updateTitle.TextXAlignment = Enum.TextXAlignment.Left
updateTitle.Parent = updatePage

local passBox = Instance.new("TextBox")
passBox.Size = UDim2.new(1, -20, 0, 36)
passBox.Position = UDim2.new(0, 10, 0, 70)
passBox.BackgroundColor3 = Color3.fromRGB(28, 22, 45)
passBox.PlaceholderText = "Passwort eingeben..."
passBox.Text = ""
passBox.TextColor3 = Color3.fromRGB(220, 210, 255)
passBox.PlaceholderColor3 = Color3.fromRGB(120, 110, 150)
passBox.Font = Enum.Font.Gotham
passBox.TextSize = 14
passBox.Parent = updatePage
Instance.new("UICorner", passBox).CornerRadius = UDim.new(0, 8)

local updateStatus = Instance.new("TextLabel")
updateStatus.Size = UDim2.new(1, -20, 0, 20)
updateStatus.Position = UDim2.new(0, 10, 0, 115)
updateStatus.BackgroundTransparency = 1
updateStatus.Text = ""
updateStatus.TextColor3 = Color3.fromRGB(180, 160, 220)
updateStatus.Font = Enum.Font.Gotham
updateStatus.TextSize = 13
updateStatus.TextXAlignment = Enum.TextXAlignment.Left
updateStatus.Parent = updatePage

local doUpdateBtn = Instance.new("TextButton")
doUpdateBtn.Size = UDim2.new(1, -20, 0, 40)
doUpdateBtn.Position = UDim2.new(0, 10, 0, 150)
doUpdateBtn.BackgroundColor3 = Color3.fromRGB(110, 60, 210)
doUpdateBtn.Text = "Script updaten"
doUpdateBtn.TextColor3 = Color3.new(1,1,1)
doUpdateBtn.Font = Enum.Font.GothamBold
doUpdateBtn.TextSize = 15
doUpdateBtn.Parent = updatePage
Instance.new("UICorner", doUpdateBtn).CornerRadius = UDim.new(0, 8)

doUpdateBtn.MouseButton1Click:Connect(function()
    if passBox.Text == UPDATE_PASSWORD then
        updateStatus.Text = "Update wird geladen..."
        updateStatus.TextColor3 = Color3.fromRGB(0, 220, 140)
        task.spawn(function()
            local success, err = pcall(function()
                local source = game:HttpGet(UPDATE_URL)
                if gui then gui:Destroy() end
                loadstring(source)()
            end)
            if not success then
                updateStatus.Text = "Fehler: " .. tostring(err)
                updateStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
            end
        end)
    else
        updateStatus.Text = "Falsches Passwort"
        updateStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
        passBox.Text = ""
    end
end)

-- ========== FUNCTIONS ==========
local function clearDraw()
    for _, d in pairs(draws) do pcall(function() d:Remove() end) end
    draws = {}
end

local function removeExpand()
    for _, c in pairs(conns) do c:Disconnect() end
    conns = {}
    if expand then pcall(function() expand:Destroy() end) expand = nil end
    pcall(function() game:GetService("SoundService"):SetListener(Enum.ListenerType.Camera) end)
end

local function createExpand(char)
    removeExpand()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    expand = Instance.new("Part")
    expand.Size = Vector3.new(1,1,1)
    expand.Transparency = 1
    expand.Anchored = true
    expand.CanCollide = false
    expand.Parent = workspace
    expand.CFrame = hrp.CFrame
    game:GetService("SoundService"):SetListener(Enum.ListenerType.ObjectPosition, expand)
    table.insert(conns, RunService.Heartbeat:Connect(function()
        if hrp and hrp.Parent then expand.CFrame = hrp.CFrame end
    end))
end

local function teleportTo(plr)
    if not plr or not plr.Character then return end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if hrp and myHRP then
        myHRP.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
    end
end

function updateList()
    for _, child in pairs(list:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP then
            local fullName = plr.DisplayName
            if plr.DisplayName ~= plr.Name then
                fullName = plr.DisplayName .. "  (@" .. plr.Name .. ")"
            end
            if searchText == "" or fullName:lower():find(searchText) or plr.Name:lower():find(searchText) then
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, -6, 0, 32)
                row.BackgroundColor3 = (selected == plr) and Color3.fromRGB(50, 32, 90) or Color3.fromRGB(30, 24, 50)
                row.Parent = list
                Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)

                local nameBtn = Instance.new("TextButton")
                nameBtn.Size = UDim2.new(1, -52, 1, 0)
                nameBtn.BackgroundTransparency = 1
                nameBtn.Text = "  " .. fullName
                nameBtn.TextColor3 = Color3.fromRGB(220, 210, 255)
                nameBtn.Font = Enum.Font.Gotham
                nameBtn.TextSize = 12
                nameBtn.TextXAlignment = Enum.TextXAlignment.Left
                nameBtn.Parent = row

                local tpBtn = Instance.new("TextButton")
                tpBtn.Size = UDim2.new(0, 42, 0, 22)
                tpBtn.Position = UDim2.new(1, -46, 0.5, -11)
                tpBtn.BackgroundColor3 = Color3.fromRGB(100, 55, 200)
                tpBtn.Text = "TP"
                tpBtn.TextColor3 = Color3.new(1,1,1)
                tpBtn.Font = Enum.Font.GothamBold
                tpBtn.TextSize = 11
                tpBtn.Parent = row
                Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 5)

                nameBtn.MouseButton1Click:Connect(function()
                    selected = plr
                    updateList()
                    -- Sofort umschalten wenn Listening an ist
                    if hear then
                        if plr.Character then
                            createExpand(plr.Character)
                        else
                            removeExpand()
                        end
                    end
                end)
                tpBtn.MouseButton1Click:Connect(function()
                    teleportTo(plr)
                end)
            end
        end
    end
    task.wait()
    list.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 8)
end

local function drawESP()
    clearDraw()
    if not (espOn and selected and selected.Character) then return end
    local hrp = selected.Character:FindFirstChild("HumanoidRootPart")
    local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not myHRP then return end
    if (hrp.Position - myHRP.Position).Magnitude < 18 then return end

    local pos, onScreen = Cam:WorldToViewportPoint(hrp.Position)
    if not onScreen then return end

    local t = Drawing.new("Text")
    t.Text = selected.DisplayName
    t.Size = 14
    t.Center = true
    t.Outline = true
    t.Color = Color3.fromRGB(180, 130, 255)
    t.Position = Vector2.new(pos.X, pos.Y - 40)
    t.Visible = true
    table.insert(draws, t)

    local l = Drawing.new("Line")
    l.From = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y)
    l.To = Vector2.new(pos.X, pos.Y)
    l.Color = Color3.fromRGB(140, 90, 255)
    l.Thickness = 1.3
    l.Visible = true
    table.insert(draws, l)

    local s = Drawing.new("Square")
    s.Size = Vector2.new(34, 52)
    s.Position = Vector2.new(pos.X - 17, pos.Y - 26)
    s.Color = Color3.fromRGB(0, 220, 140)
    s.Thickness = 1.3
    s.Filled = false
    s.Visible = true
    table.insert(draws, s)
end

local function switchTab(tab)
    currentTab = tab
    mainPage.Visible   = tab == "Main"
    infoPage.Visible   = tab == "Info"
    emotePage.Visible  = tab == "Emote"
    toolsPage.Visible  = tab == "Tools"
    updatePage.Visible = tab == "Update"

    mainBtn.BackgroundColor3   = tab == "Main"   and Color3.fromRGB(55, 35, 100) or Color3.fromRGB(32, 24, 52)
    infoBtn.BackgroundColor3   = tab == "Info"   and Color3.fromRGB(55, 35, 100) or Color3.fromRGB(32, 24, 52)
    emoteBtn.BackgroundColor3  = tab == "Emote"  and Color3.fromRGB(55, 35, 100) or Color3.fromRGB(32, 24, 52)
    toolsBtn.BackgroundColor3  = tab == "Tools"  and Color3.fromRGB(55, 35, 100) or Color3.fromRGB(32, 24, 52)
    updateBtn.BackgroundColor3 = tab == "Update" and Color3.fromRGB(55, 35, 100) or Color3.fromRGB(32, 24, 52)
end

mainBtn.MouseButton1Click:Connect(function() switchTab("Main") end)
infoBtn.MouseButton1Click:Connect(function() switchTab("Info") end)
emoteBtn.MouseButton1Click:Connect(function() switchTab("Emote") end)
toolsBtn.MouseButton1Click:Connect(function() switchTab("Tools") end)
updateBtn.MouseButton1Click:Connect(function() switchTab("Update") end)

local function setToggle(on, toggle, knob)
    toggle.BackgroundColor3 = on and Color3.fromRGB(120, 70, 220) or Color3.fromRGB(50, 40, 70)
    knob.Position = on and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
end

espBtn.MouseButton1Click:Connect(function()
    espOn = not espOn
    setToggle(espOn, espToggle, espKnob)
    if not espOn then clearDraw() end
end)

hearBtn.MouseButton1Click:Connect(function()
    hear = not hear
    setToggle(hear, hearToggle, hearKnob)
    if hear then
        if selected and selected.Character then
            createExpand(selected.Character)
        end
    else
        removeExpand()
    end
end)

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        uiVisible = not uiVisible
        main.Visible = uiVisible
    end
end)

Players.PlayerAdded:Connect(function()
    updateList()
    updateInfoList()
end)
Players.PlayerRemoving:Connect(function(p)
    if selected == p then
        selected = nil
        removeExpand()
        clearDraw()
    end
    if infoSelected == p then
        infoSelected = nil
        infoTitle.Text = "Spieler auswählen"
        infoContent.Text = "Klicke links auf einen Spieler,\num Infos zu sehen."
    end
    updateList()
    updateInfoList()
end)

LP.CharacterAdded:Connect(function()
    task.wait(1)
    applyWalkSpeed()
end)

updateList()
updateInfoList()
applyWalkSpeed()
switchTab("Main")

RunService.RenderStepped:Connect(function()
    if espOn and selected then
        drawESP()
    else
        clearDraw()
    end
end)

-- Drag
local dragging, dragStart, startPos = false, nil, nil
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)
titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("Acehub geladen | Left Ctrl = UI ein/aus")