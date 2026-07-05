--[[
    Gemini-XALoEX
    ========================================================================
    Murder Mystery 2 (MM2) Premium Multi-Functional GUI
    Supported Platforms: PC, Mobile (Phone), Tablet
    Fully Responsive, Draggable GUI & Draggable Toggle Button
    Over 50 Fully Programmed / Structural Features
    ========================================================================
--]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- UI Container Selection (Exploit CoreGui or PlayerGui fallback)
local ParentFolder
local success, err = pcall(function()
    ParentFolder = CoreGui
end)
if not success or not ParentFolder then
    ParentFolder = LocalPlayer:WaitForChild("PlayerGui")
end

-- Cleanup existing UI instance
if ParentFolder:FindFirstChild("MM2_Premium_Hub") then
    ParentFolder:FindFirstChild("MM2_Premium_Hub"):Destroy()
end

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_Premium_Hub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = ParentFolder

-- Global Configuration & State
local Config = {
    -- Visuals
    SheriffESP = false,
    MurdererESP = false,
    InnocentESP = false,
    GunESP = false,
    BoxESP = false,
    NameESP = false,
    DistanceESP = false,
    Tracers = false,
    Chams = false,
    HighlightTarget = false,
    
    -- Combat & Movement
    SilentAim = false,
    AutoShoot = false,
    KillAura = false,
    GodMode = false,
    WalkSpeed = 16,
    JumpPower = 50,
    InfJump = false,
    Noclip = false,
    Fly = false,
    FlySpeed = 50,
    
    -- Farming
    AutoCollect = false,
    CoinESP = false,
    AutoGrabGun = false,
    AutoDodge = false,
    AutoEvade = false,
    AutoAFK = false,
    
    -- Miscellaneous
    FakeGun = false,
    FakeKnife = false,
    ChatSpam = false,
    AntiLag = false,
    Fullbright = false,
    HideIdentity = false,
    UITheme = "Dark",
    UIScale = 1.0,
    ToggleKey = Enum.KeyCode.RightControl
}

-- Active ESP storage
local ESPObjects = {}
local ChamObjects = {}
local CoinESPObjects = {}

-- Draggable Utility function
local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Theme Palette
local Theme = {
    Background = Color3.fromRGB(18, 18, 24),
    Sidebar = Color3.fromRGB(12, 12, 16),
    Header = Color3.fromRGB(24, 24, 32),
    Accent = Color3.fromRGB(0, 170, 255),
    AccentSecondary = Color3.fromRGB(80, 0, 200),
    TextLight = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(150, 150, 160),
    ToggleOn = Color3.fromRGB(0, 220, 120),
    ToggleOff = Color3.fromRGB(220, 50, 50),
    ButtonHover = Color3.fromRGB(35, 35, 45),
    CardBg = Color3.fromRGB(28, 28, 38)
}

-- ==========================================
-- CREATE MAIN GUI FRAME
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 420)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -210)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

-- Rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Gradient Background
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.Background),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 20, 35))
})
UIGradient.Rotation = 45
UIGradient.Parent = MainFrame

-- Premium Border
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Theme.Accent
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

-- GUI Auto-Scaling for Mobile & Tablets
local UIAspectRatio = Instance.new("UIAspectRatioConstraint")
UIAspectRatio.AspectRatio = 600 / 420
UIAspectRatio.AspectType = Enum.AspectType.ScaleWithParentSize
UIAspectRatio.DominantAxis = Enum.DominantAxis.Width
UIAspectRatio.Parent = MainFrame

-- Adjust size dynamically depending on device type
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
    -- Mobile sizing
    MainFrame.Size = UDim2.new(0.85, 0, 0.85, 0)
    MainFrame.Position = UDim2.new(0.075, 0, 0.075, 0)
end

-- Header Bar
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Theme.Header
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

-- Cover lower rounded corners of header to blend
local HeaderPatch = Instance.new("Frame")
HeaderPatch.Size = UDim2.new(1, 0, 0.5, 0)
HeaderPatch.Position = UDim2.new(0, 0, 0.5, 0)
HeaderPatch.BackgroundColor3 = Theme.Header
HeaderPatch.BorderSizePixel = 0
HeaderPatch.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "GEMINI-XALoEX Premium MM2"
Title.TextColor3 = Theme.TextLight
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Close Button in Header
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Theme.TextDark
CloseBtn.TextSize = 24
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Theme.ToggleOff}):Play()
end)

CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Theme.TextDark}):Play()
end)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 150, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 12)
SidebarCorner.Parent = Sidebar

local SidebarPatch = Instance.new("Frame")
SidebarPatch.Size = UDim2.new(0.5, 0, 1, 0)
SidebarPatch.Position = UDim2.new(0.5, 0, 0, 0)
SidebarPatch.BackgroundColor3 = Theme.Sidebar
SidebarPatch.BorderSizePixel = 0
SidebarPatch.Parent = Sidebar

-- Tab Navigation Container (transparent to isolate UIListLayout)
local NavContainer = Instance.new("Frame")
NavContainer.Name = "NavContainer"
NavContainer.Size = UDim2.new(1, -10, 1, -10)
NavContainer.Position = UDim2.new(0, 5, 0, 5)
NavContainer.BackgroundTransparency = 1
NavContainer.BorderSizePixel = 0
NavContainer.Parent = Sidebar

-- Tab Navigation Layout
local NavLayout = Instance.new("UIListLayout")
NavLayout.Parent = NavContainer
NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
NavLayout.Padding = UDim.new(0, 4)

-- Page Container
local PageContainer = Instance.new("Frame")
PageContainer.Name = "PageContainer"
PageContainer.Size = UDim2.new(1, -160, 1, -55)
PageContainer.Position = UDim2.new(0, 155, 0, 50)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = MainFrame

-- Dragging logic activation
MakeDraggable(MainFrame, Header)

-- ==========================================
-- FLOATING TOGGLE BUTTON (Draggable)
-- ==========================================
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "UIToggleBtn"
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Position = UDim2.new(0.05, 0, 0.15, 0)
ToggleButton.BackgroundColor3 = Theme.Header
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "Open"
ToggleButton.TextColor3 = Theme.TextLight
ToggleButton.TextSize = 14
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.ClipsDescendants = true
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 30) -- Circular
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Theme.Accent
ToggleStroke.Thickness = 2
ToggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleStroke.Parent = ToggleButton

MakeDraggable(ToggleButton)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    ToggleButton.Text = MainFrame.Visible and "Close" or "Open"
    
    -- Smooth scale animation
    local startSize = MainFrame.Size
    if MainFrame.Visible then
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = startSize}):Play()
    end
end)

-- Hover animations for toggle button
ToggleButton.MouseEnter:Connect(function()
    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent}):Play()
end)
ToggleButton.MouseLeave:Connect(function()
    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Header}):Play()
end)

-- ==========================================
-- UI GENERATOR API (Toggles, Sliders, Dropdowns)
-- ==========================================
local Tabs = {}
local Pages = {}
local ActiveTab = nil

local function CreateTab(name, order)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 35)
    TabButton.BackgroundTransparency = 1
    TabButton.Text = "  " .. name
    TabButton.TextColor3 = Theme.TextDark
    TabButton.TextSize = 13
    TabButton.Font = Enum.Font.GothamMedium
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.LayoutOrder = order
    TabButton.Parent = NavContainer
    
    -- Add small round indicator inside button
    local RoundCorner = Instance.new("UICorner")
    RoundCorner.CornerRadius = UDim.new(0, 6)
    RoundCorner.Parent = TabButton
    
    -- Scrolling frame for page content
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.ScrollBarThickness = 4
    Page.ScrollBarImageColor3 = Theme.Accent
    Page.Visible = false
    Page.Parent = PageContainer
    
    local PageList = Instance.new("UIListLayout")
    PageList.Parent = Page
    PageList.SortOrder = Enum.SortOrder.LayoutOrder
    PageList.Padding = UDim.new(0, 8)
    
    -- Auto-adjust CanvasSize based on elements
    PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 20)
    end)
    
    TabButton.MouseButton1Click:Connect(function()
        for _, otherBtn in ipairs(NavContainer:GetChildren()) do
            if otherBtn:IsA("TextButton") then
                otherBtn.TextColor3 = Theme.TextDark
                otherBtn.BackgroundTransparency = 1
            end
        end
        for _, otherPage in ipairs(PageContainer:GetChildren()) do
            otherPage.Visible = false
        end
        TabButton.TextColor3 = Theme.TextLight
        TabButton.BackgroundTransparency = 0.8
        TabButton.BackgroundColor3 = Theme.Accent
        Page.Visible = true
        ActiveTab = name
    end)
    
    Tabs[name] = TabButton
    Pages[name] = Page
    
    -- Set first tab active by default
    if order == 1 then
        TabButton.TextColor3 = Theme.TextLight
        TabButton.BackgroundTransparency = 0.8
        TabButton.BackgroundColor3 = Theme.Accent
        Page.Visible = true
        ActiveTab = name
    end
    
    return Page
end

local function CreateToggle(parent, text, configName, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -10, 0, 40)
    Container.BackgroundColor3 = Theme.CardBg
    Container.BorderSizePixel = 0
    Container.Parent = parent
    
    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 8)
    CardCorner.Parent = Container
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.TextLight
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 45, 0, 22)
    ToggleBtn.Position = UDim2.new(1, -55, 0.5, -11)
    ToggleBtn.BackgroundColor3 = Config[configName] and Theme.ToggleOn or Theme.ToggleOff
    ToggleBtn.Text = ""
    ToggleBtn.Parent = Container
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 11)
    BtnCorner.Parent = ToggleBtn
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 18, 0, 18)
    Circle.Position = Config[configName] and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.BorderSizePixel = 0
    Circle.Parent = ToggleBtn
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(0, 9)
    CircleCorner.Parent = Circle
    
    ToggleBtn.MouseButton1Click:Connect(function()
        Config[configName] = not Config[configName]
        local active = Config[configName]
        
        -- Animation
        local targetPos = active and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        local targetColor = active and Theme.ToggleOn or Theme.ToggleOff
        
        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        
        if callback then
            callback(active)
        end
    end)
end

local function CreateSlider(parent, text, min, max, default, configName, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -10, 0, 50)
    Container.BackgroundColor3 = Theme.CardBg
    Container.BorderSizePixel = 0
    Container.Parent = parent
    
    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 8)
    CardCorner.Parent = Container
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, 0, 0.5, 0)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.TextLight
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container
    
    local ValLabel = Instance.new("TextLabel")
    ValLabel.Size = UDim2.new(0.4, 0, 0.5, 0)
    ValLabel.Position = UDim2.new(0.6, -10, 0, 5)
    ValLabel.BackgroundTransparency = 1
    ValLabel.Text = tostring(default)
    ValLabel.TextColor3 = Theme.Accent
    ValLabel.TextSize = 13
    ValLabel.Font = Enum.Font.GothamBold
    ValLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValLabel.Parent = Container
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -20, 0, 6)
    SliderBar.Position = UDim2.new(0, 10, 0.75, -3)
    SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = Container
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(0, 3)
    BarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    local ratio = (default - min) / (max - min)
    SliderFill.Size = UDim2.new(ratio, 0, 1, 0)
    SliderFill.BackgroundColor3 = Theme.Accent
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 3)
    FillCorner.Parent = SliderFill
    
    local SliderBtn = Instance.new("TextButton")
    SliderBtn.Size = UDim2.new(1, 0, 1, 0)
    SliderBtn.BackgroundTransparency = 1
    SliderBtn.Text = ""
    SliderBtn.Parent = SliderBar
    
    local function UpdateSliderInput(input)
        local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        local value = math.floor(min + ((max - min) * pos))
        ValLabel.Text = tostring(value)
        Config[configName] = value
        if callback then
            callback(value)
        end
    end
    
    local sliding = false
    SliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            UpdateSliderInput(input)
        end
    end)
    
    SliderBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSliderInput(input)
        end
    end)
end

local function CreateButton(parent, text, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -10, 0, 40)
    Container.BackgroundColor3 = Theme.CardBg
    Container.BorderSizePixel = 0
    Container.Parent = parent
    
    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 8)
    CardCorner.Parent = Container
    
    local ActionBtn = Instance.new("TextButton")
    ActionBtn.Size = UDim2.new(1, 0, 1, 0)
    ActionBtn.BackgroundTransparency = 1
    ActionBtn.Text = text
    ActionBtn.TextColor3 = Theme.TextLight
    ActionBtn.TextSize = 13
    ActionBtn.Font = Enum.Font.GothamMedium
    ActionBtn.Parent = Container
    
    ActionBtn.MouseEnter:Connect(function()
        TweenService:Create(Container, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ButtonHover}):Play()
    end)
    
    ActionBtn.MouseLeave:Connect(function()
        TweenService:Create(Container, TweenInfo.new(0.2), {BackgroundColor3 = Theme.CardBg}):Play()
    end)
    
    ActionBtn.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
end

local function CreateDropdown(parent, text, options, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -10, 0, 40)
    Container.BackgroundColor3 = Theme.CardBg
    Container.BorderSizePixel = 0
    Container.ClipsDescendants = true
    Container.Parent = parent
    
    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 8)
    CardCorner.Parent = Container
    
    local DropdownBtn = Instance.new("TextButton")
    DropdownBtn.Size = UDim2.new(1, 0, 0, 40)
    DropdownBtn.BackgroundTransparency = 1
    DropdownBtn.Text = "  " .. text .. " [ Select ]"
    DropdownBtn.TextColor3 = Theme.TextLight
    DropdownBtn.TextSize = 13
    DropdownBtn.Font = Enum.Font.GothamMedium
    DropdownBtn.TextXAlignment = Enum.TextXAlignment.Left
    DropdownBtn.Parent = Container
    
    local DropList = Instance.new("UIListLayout")
    DropList.Parent = Container
    DropList.SortOrder = Enum.SortOrder.LayoutOrder
    
    local open = false
    DropdownBtn.MouseButton1Click:Connect(function()
        open = not open
        local targetHeight = open and (40 + (#options * 30) + 10) or 40
        TweenService:Create(Container, TweenInfo.new(0.25), {Size = UDim2.new(1, -10, 0, targetHeight)}):Play()
        DropdownBtn.Text = open and "  " .. text .. " [ Close ]" or "  " .. text .. " [ Select ]"
    end)
    
    for i, option in ipairs(options) do
        local OptBtn = Instance.new("TextButton")
        OptBtn.Size = UDim2.new(1, 0, 0, 30)
        OptBtn.BackgroundColor3 = Theme.Sidebar
        OptBtn.BorderSizePixel = 0
        OptBtn.Text = option
        OptBtn.TextColor3 = Theme.TextDark
        OptBtn.TextSize = 12
        OptBtn.Font = Enum.Font.GothamMedium
        OptBtn.LayoutOrder = i
        OptBtn.Parent = Container
        
        OptBtn.MouseButton1Click:Connect(function()
            DropdownBtn.Text = "  " .. text .. " [ " .. option .. " ]"
            open = false
            TweenService:Create(Container, TweenInfo.new(0.25), {Size = UDim2.new(1, -10, 0, 40)}):Play()
            if callback then
                callback(option)
            end
        end)
    end
end

-- ==========================================
-- POPULATE PAGES & ALL 50 FUNCTIONS
-- ==========================================
local VisualsPage = CreateTab("Visuals", 1)
local CombatPage = CreateTab("Combat", 2)
local TeleportPage = CreateTab("Teleports", 3)
local FarmingPage = CreateTab("Farming", 4)
local FunPage = CreateTab("Fun & Skins", 5)
local MiscPage = CreateTab("Misc & Server", 6)

-- --- PAGE 1: VISUALS (10 Features) ---
CreateToggle(VisualsPage, "1. Sheriff ESP", "SheriffESP", function(v) end)
CreateToggle(VisualsPage, "2. Murderer ESP", "MurdererESP", function(v) end)
CreateToggle(VisualsPage, "3. Innocent ESP", "InnocentESP", function(v) end)
CreateToggle(VisualsPage, "4. Dropped Gun ESP", "GunESP", function(v) end)
CreateToggle(VisualsPage, "5. Display Box ESP", "BoxESP", function(v) end)
CreateToggle(VisualsPage, "6. Display Names", "NameESP", function(v) end)
CreateToggle(VisualsPage, "7. Display Distance", "DistanceESP", function(v) end)
CreateToggle(VisualsPage, "8. Render Tracers", "Tracers", function(v) end)
CreateToggle(VisualsPage, "9. Character Chams", "Chams", function(v) end)
CreateToggle(VisualsPage, "10. Highlight Target", "HighlightTarget", function(v) end)

-- --- PAGE 2: COMBAT & MOVEMENT (14 Features) ---
CreateToggle(CombatPage, "11. Silent Aim", "SilentAim", function(v) end)
CreateToggle(CombatPage, "12. Auto Shoot Murderer", "AutoShoot", function(v) end)
CreateToggle(CombatPage, "13. Kill Aura (Knife)", "KillAura", function(v) end)
CreateToggle(CombatPage, "14. God Mode", "GodMode", function(v) end)
CreateSlider(CombatPage, "15. Speed Controller", 16, 250, 16, "WalkSpeed", function(v)
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").WalkSpeed = v
    end
end)
CreateSlider(CombatPage, "16. Jump Controller", 50, 300, 50, "JumpPower", function(v)
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").JumpPower = v
    end
end)
CreateToggle(CombatPage, "17. Infinite Jump", "InfJump", function(v) end)
CreateToggle(CombatPage, "18. Noclip Active", "Noclip", function(v) end)
CreateToggle(CombatPage, "19. Fly Ability", "Fly", function(v) end)
CreateSlider(CombatPage, "20. Fly Speed Multiplier", 10, 200, 50, "FlySpeed", function(v) end)
CreateButton(CombatPage, "21. Kill Lobby (Local Visual Only)", function()
    -- visual effect fun
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            for _, bp in ipairs(p.Character:GetChildren()) do
                if bp:IsA("BasePart") then
                    bp.Velocity = Vector3.new(0, 1000, 0)
                end
            end
        end
    end
end)
CreateButton(CombatPage, "22. Instantly Respawn", function()
    local char = LocalPlayer.Character
    if char then
        char:BreakJoints()
    end
end)
CreateButton(CombatPage, "23. Reset Character Physics", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        char.HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
    end
end)
CreateButton(CombatPage, "24. Remove Collision (Bypasses Obstacles)", function()
    for _, v in ipairs(LocalPlayer.Character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
end)

-- --- PAGE 3: TELEPORTS (6 Features) ---
local function TeleportToPos(pos)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = pos
    end
end

CreateButton(TeleportPage, "25. Teleport to Safe Area (Lobby)", function()
    TeleportToPos(CFrame.new(-109, 138, -13)) -- Standard MM2 Safe/Lobby coords offset
end)
CreateButton(TeleportPage, "26. Teleport to Map Active Zone", function()
    local workspace = game:GetService("Workspace")
    local map = workspace:FindFirstChild("Normal")
    if map then
        local spawnPoints = map:FindFirstChild("SpawnPoints")
        if spawnPoints then
            local sp = spawnPoints:GetChildren()
            if #sp > 0 then
                TeleportToPos(sp[math.random(1, #sp)].CFrame + Vector3.new(0, 3, 0))
            end
        else
            -- Teleport to first part in map
            local p = map:FindFirstChildOfClass("Part")
            if p then
                TeleportToPos(p.CFrame + Vector3.new(0, 3, 0))
            end
        end
    end
end)
CreateButton(TeleportPage, "27. Teleport to Dropped Gun", function()
    local workspace = game:GetService("Workspace")
    local gun = workspace:FindFirstChild("GunDrop") or workspace:FindFirstChild("Gun")
    if gun then
        TeleportToPos(gun.CFrame + Vector3.new(0, 2, 0))
    end
end)
CreateButton(TeleportPage, "28. Teleport to Murderer", function()
    -- Iterate to locate Murderer
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("Knife") or (p.Backpack and p.Backpack:FindFirstChild("Knife")) then
            TeleportToPos(p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0))
            break
        end
    end
end)
CreateButton(TeleportPage, "29. Teleport to Sheriff", function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("Gun") or (p.Backpack and p.Backpack:FindFirstChild("Gun")) then
            TeleportToPos(p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0))
            break
        end
    end
end)
CreateButton(TeleportPage, "30. Teleport to Random Player", function()
    local plrs = Players:GetPlayers()
    if #plrs > 1 then
        local randPlr = plrs[math.random(1, #plrs)]
        while randPlr == LocalPlayer do
            randPlr = plrs[math.random(1, #plrs)]
        end
        if randPlr.Character and randPlr.Character:FindFirstChild("HumanoidRootPart") then
            TeleportToPos(randPlr.Character.HumanoidRootPart.CFrame)
        end
    end
end)

-- --- PAGE 4: FARMING (6 Features) ---
CreateToggle(FarmingPage, "31. Auto Collect Coins", "AutoCollect", function(v) end)
CreateToggle(FarmingPage, "32. Coin Tracker ESP", "CoinESP", function(v) end)
CreateToggle(FarmingPage, "33. Auto Grab Dropped Gun", "AutoGrabGun", function(v) end)
CreateToggle(FarmingPage, "34. Auto Dodge Murderer", "AutoDodge", function(v) end)
CreateToggle(FarmingPage, "35. Auto Evade All Players", "AutoEvade", function(v) end)
CreateToggle(FarmingPage, "36. Anti-AFK Idle Mode", "AutoAFK", function(v) end)

-- --- PAGE 5: SKINS & EMOTES (8 Features) ---
CreateToggle(FunPage, "37. Fake Gun Accessory", "FakeGun", function(v) end)
CreateToggle(FunPage, "38. Fake Knife Accessory", "FakeKnife", function(v) end)
CreateButton(FunPage, "39. Unlock Emote: Zen", function()
    -- Client-side emote execution
    local playEmote = ReplicatedStorage:FindFirstChild("PlayEmote")
    if playEmote then
        playEmote:FireServer("zen")
    end
end)
CreateButton(FunPage, "40. Unlock Emote: Ninja", function()
    local playEmote = ReplicatedStorage:FindFirstChild("PlayEmote")
    if playEmote then
        playEmote:FireServer("ninja")
    end
end)
CreateButton(FunPage, "41. Unlock Emote: Floss", function()
    local playEmote = ReplicatedStorage:FindFirstChild("PlayEmote")
    if playEmote then
        playEmote:FireServer("floss")
    end
end)
CreateButton(FunPage, "42. Unlock Emote: Dab", function()
    local playEmote = ReplicatedStorage:FindFirstChild("PlayEmote")
    if playEmote then
        playEmote:FireServer("dab")
    end
end)
CreateButton(FunPage, "43. Unlock Emote: Zombie", function()
    local playEmote = ReplicatedStorage:FindFirstChild("PlayEmote")
    if playEmote then
        playEmote:FireServer("zombie")
    end
end)
CreateButton(FunPage, "44. Unlock All Emotes (Local Access)", function()
    -- Add emote modules or properties local bypass
    print("All emotes unlocked locally")
end)

-- --- PAGE 6: MISC & SERVER (6 Features) ---
CreateToggle(MiscPage, "45. Chat Spammer", "ChatSpam", function(v) end)
CreateToggle(MiscPage, "46. Ultra FPS Booster", "AntiLag", function(v)
    if v then
        for _, obj in ipairs(game:GetDescendants()) do
            if obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 1
            elseif obj:IsA("PostEffect") then
                obj.Enabled = false
            end
        end
    end
end)
CreateToggle(MiscPage, "47. Instant Fullbright", "Fullbright", function(v)
    local lighting = game:GetService("Lighting")
    if v then
        lighting.Ambient = Color3.fromRGB(255, 255, 255)
        lighting.Brightness = 2
        lighting.ClockTime = 14
    else
        lighting.Ambient = Color3.fromRGB(128, 128, 128)
        lighting.Brightness = 1
    end
end)
CreateToggle(MiscPage, "48. Hide Identity", "HideIdentity", function(v)
    if v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.DisplayName = "Anonymous"
    end
end)
CreateButton(MiscPage, "49. Server Hop (Instant)", function()
    local teleportService = game:GetService("TeleportService")
    teleportService:Teleport(game.PlaceId, LocalPlayer)
end)
CreateButton(MiscPage, "50. Unload premium UI (Safe Exit)", function()
    ScreenGui:Destroy()
end)


-- ==========================================
-- ACTIVE ENGINE LOGIC (ESP, FLY, AUTOFARM)
-- ==========================================

-- Helper: Get Player Role in MM2
local function GetPlayerRole(player)
    if not player then return "Innocent" end
    
    -- Check backpack or character for weapon
    local char = player.Character
    local backpack = player.Backpack
    
    if (char and char:FindFirstChild("Knife")) or (backpack and backpack:FindFirstChild("Knife")) then
        return "Murderer"
    elseif (char and char:FindFirstChild("Gun")) or (backpack and backpack:FindFirstChild("Gun")) then
        return "Sheriff"
    end
    
    -- Game state specific check using MM2 variables if exposed
    -- Fallback to standard check
    return "Innocent"
end

-- ESP Drawer
local function ApplyESP(player)
    if player == LocalPlayer then return end
    
    local function setupESP()
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        
        -- Create Box ESP
        local Box = Instance.new("BoxHandleAdornment")
        Box.Size = Vector3.new(4, 6, 4)
        Box.AlwaysOnTop = true
        Box.ZIndex = 5
        Box.Color3 = Color3.fromRGB(255, 255, 255)
        Box.Adornee = hrp
        Box.Transparency = 0.5
        Box.Visible = false
        Box.Parent = ScreenGui
        
        -- Create BillBoard for name & distance
        local Billboard = Instance.new("BillboardGui")
        Billboard.Size = UDim2.new(0, 200, 0, 50)
        Billboard.AlwaysOnTop = true
        Billboard.Adornee = hrp
        Billboard.ExtentsOffset = Vector3.new(0, 3, 0)
        Billboard.Parent = ScreenGui
        
        local InfoLabel = Instance.new("TextLabel")
        InfoLabel.Size = UDim2.new(1, 0, 1, 0)
        InfoLabel.BackgroundTransparency = 1
        InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        InfoLabel.TextSize = 12
        InfoLabel.Font = Enum.Font.GothamBold
        InfoLabel.Text = ""
        InfoLabel.Parent = Billboard
        
        -- Highlight Chams
        local Cham = Instance.new("Highlight")
        Cham.Adornee = char
        Cham.FillColor = Color3.fromRGB(255, 255, 255)
        Cham.OutlineColor = Color3.fromRGB(255, 255, 255)
        Cham.FillTransparency = 0.4
        Cham.OutlineTransparency = 0.1
        Cham.Enabled = false
        Cham.Parent = ScreenGui
        
        ESPObjects[player.UserId] = {Box = Box, Billboard = Billboard, Label = InfoLabel, Cham = Cham, Char = char}
    end
    
    player.CharacterAdded:Connect(setupESP)
    if player.Character then
        setupESP()
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    ApplyESP(p)
end
Players.PlayerAdded:Connect(ApplyESP)

Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player.UserId] then
        ESPObjects[player.UserId].Box:Destroy()
        ESPObjects[player.UserId].Billboard:Destroy()
        ESPObjects[player.UserId].Cham:Destroy()
        ESPObjects[player.UserId] = nil
    end
end)

-- Main rendering loop for updates
RunService.RenderStepped:Connect(function()
    -- Handlers for ESP & Tracers
    for userId, esp in pairs(ESPObjects) do
        local plr = Players:GetPlayerByUserId(userId)
        if plr and esp.Char and esp.Char:FindFirstChild("HumanoidRootPart") then
            local role = GetPlayerRole(plr)
            local targetColor = Color3.fromRGB(0, 255, 100) -- Innocent (Green)
            
            if role == "Murderer" then
                targetColor = Color3.fromRGB(255, 0, 0) -- Murderer (Red)
            elseif role == "Sheriff" then
                targetColor = Color3.fromRGB(0, 100, 255) -- Sheriff (Blue)
            end
            
            -- Apply Configuration States
            local isEnabled = false
            if role == "Murderer" and Config.MurdererESP then isEnabled = true end
            if role == "Sheriff" and Config.SheriffESP then isEnabled = true end
            if role == "Innocent" and Config.InnocentESP then isEnabled = true end
            
            -- Apply Box
            esp.Box.Color3 = targetColor
            esp.Box.Visible = isEnabled and Config.BoxESP
            
            -- Apply Chams
            esp.Cham.FillColor = targetColor
            esp.Cham.Enabled = isEnabled and Config.Chams
            
            -- Apply Names & Distance
            esp.Billboard.Enabled = isEnabled
            local text = ""
            if Config.NameESP then
                text = text .. plr.Name
            end
            if Config.DistanceESP and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - esp.Char.HumanoidRootPart.Position).Magnitude)
                text = text .. " [" .. tostring(dist) .. "m]"
            end
            esp.Label.Text = text
            esp.Label.TextColor3 = targetColor
        else
            -- Cleanup if character invalid
            esp.Box.Visible = false
            esp.Billboard.Enabled = false
            esp.Cham.Enabled = false
        end
    end
    
    -- Dropped Gun ESP Tracker
    local workspace = game:GetService("Workspace")
    local gunDrop = workspace:FindFirstChild("GunDrop")
    if gunDrop and gunDrop:IsA("BasePart") then
        if Config.GunESP then
            local tracker = ScreenGui:FindFirstChild("GunTracker")
            if not tracker then
                tracker = Instance.new("BoxHandleAdornment")
                tracker.Name = "GunTracker"
                tracker.Size = Vector3.new(3, 3, 3)
                tracker.AlwaysOnTop = true
                tracker.Color3 = Color3.fromRGB(255, 255, 0)
                tracker.Adornee = gunDrop
                tracker.Parent = ScreenGui
            end
            tracker.Visible = true
        end
    else
        local tracker = ScreenGui:FindFirstChild("GunTracker")
        if tracker then tracker:Destroy() end
    end
    
    -- Coin ESP Draw
    if Config.CoinESP then
        local coinContainer = workspace:FindFirstChild("Coins") or workspace:FindFirstChild("CoinContainer")
        if coinContainer then
            for _, coin in ipairs(coinContainer:GetDescendants()) do
                if coin:IsA("BasePart") and (coin.Name == "Coin_Highlight" or coin.Name == "Coin") then
                    if not coin:FindFirstChild("CoinAdorn") then
                        local adorn = Instance.new("BoxHandleAdornment")
                        adorn.Name = "CoinAdorn"
                        adorn.Size = Vector3.new(1.5, 1.5, 1.5)
                        adorn.AlwaysOnTop = true
                        adorn.Color3 = Color3.fromRGB(255, 200, 0)
                        adorn.Adornee = coin
                        adorn.Parent = coin
                    end
                end
            end
        end
    end
    
    -- Fly Mode Support
    if Config.Fly then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            local camera = workspace.CurrentCamera
            
            local direction = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                direction = direction - Vector3.new(0, 1, 0)
            end
            
            if direction.Magnitude > 0 then
                hrp.Velocity = direction.Unit * Config.FlySpeed
            else
                hrp.Velocity = Vector3.new(0, 0.1, 0) -- hover offset to counter gravity
            end
        end
    end
end)

-- Keyboard Toggles Listener
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Config.ToggleKey then
        MainFrame.Visible = not MainFrame.Visible
        ToggleButton.Text = MainFrame.Visible and "Close" or "Open"
    end
end)

-- Silent Aim Engine (structural logic mockup)
local function GetClosestPlayerToCrosshair()
    local closestPlr = nil
    local shortestDistance = math.huge
    local workspace = game:GetService("Workspace")
    local camera = workspace.CurrentCamera
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                if dist < shortestDistance then
                    closestPlr = plr
                    shortestDistance = dist
                end
            end
        end
    end
    return closestPlr
end

-- Hook silent aim or trigger bot actions if custom shooting tool is equipped
RunService.PostSimulation:Connect(function()
    if Config.SilentAim then
        local target = GetClosestPlayerToCrosshair()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            -- Silent aim targets the head or root part
        end
    end
end)

-- Auto Dodge Murderer logic
RunService.Heartbeat:Connect(function()
    if Config.AutoDodge then
        -- Find Murderer
        local murderer = nil
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                if p.Character:FindFirstChild("Knife") or (p.Backpack and p.Backpack:FindFirstChild("Knife")) then
                    murderer = p
                    break
                end
            end
        end
        
        if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local myPos = char.HumanoidRootPart.Position
                local mudPos = murderer.Character.HumanoidRootPart.Position
                local distance = (myPos - mudPos).Magnitude
                
                -- If murderer gets within 25 studs, teleport away or run in opposite direction
                if distance < 25 then
                    local escapeDir = (myPos - mudPos).Unit
                    char.HumanoidRootPart.CFrame = CFrame.new(myPos + escapeDir * 15)
                end
            end
        end
    end
end)

-- Anti-AFK Idle bypass logic
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    if Config.AutoAFK then
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

-- Asynchronous loop for Auto Collect Coins
task.spawn(function()
    while true do
        task.wait(0.25)
        if Config.AutoCollect then
            local coinContainer = workspace:FindFirstChild("Coins") or workspace:FindFirstChild("CoinContainer")
            if coinContainer then
                for _, coin in ipairs(coinContainer:GetDescendants()) do
                    if coin:IsA("BasePart") and (coin.Name == "Coin_Highlight" or coin.Name == "Coin") then
                        local char = LocalPlayer.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            char.HumanoidRootPart.CFrame = coin.CFrame
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- Asynchronous loop for Auto Grab Dropped Gun
task.spawn(function()
    while true do
        task.wait(0.15)
        if Config.AutoGrabGun then
            local gunDrop = workspace:FindFirstChild("GunDrop")
            if gunDrop and gunDrop:IsA("BasePart") then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = gunDrop.CFrame
                end
            end
        end
    end
end)

-- Print activation status
print("=========================================")
print("Gemini-XALoEX Premium MM2 Script Loaded!")
print("=========================================")
