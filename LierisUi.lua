--[[
    Lieris UI Library
    Roblox Executor Script
    Toggle: H key
    All settings are saved automatically
]]

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Variables
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Configuration
local CONFIG_FOLDER = "LierisConfigs"
local DEFAULT_CONFIG = "default"
local TOGGLE_KEY = Enum.KeyCode.H

-- Theme Colors
local Theme = {
    Background = Color3.fromRGB(15, 15, 18),
    Secondary = Color3.fromRGB(22, 22, 28),
    Tertiary = Color3.fromRGB(32, 32, 40),
    Accent = Color3.fromRGB(0, 110, 255),
    AccentHover = Color3.fromRGB(30, 140, 255),
    AccentPressed = Color3.fromRGB(0, 85, 210),
    AccentDark = Color3.fromRGB(0, 70, 180),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(160, 165, 180),
    Border = Color3.fromRGB(45, 45, 55),
    Success = Color3.fromRGB(50, 205, 120),
    Error = Color3.fromRGB(255, 70, 70),
    Glow = Color3.fromRGB(0, 100, 255)
}

-- Animation Settings
local AnimationSpeed = 0.2
local EasingStyle = Enum.EasingStyle.Quint
local EasingDirection = Enum.EasingDirection.Out

-- Saved Data Structure
local SavedData = {
    Toggles = {},
    Sliders = {},
    Keybinds = {},
    Colors = {},
    Dropdowns = {},
    TextInputs = {},
    WindowPosition = {X = 100, Y = 100},
    ActiveTab = "Main",
    LastConfig = DEFAULT_CONFIG
}

-- Utility Functions
local function CreateTween(instance, properties, duration, style, direction)
    duration = duration or AnimationSpeed
    style = style or EasingStyle
    direction = direction or EasingDirection
    local tween = TweenService:Create(instance, TweenInfo.new(duration, style, direction), properties)
    return tween
end

local function Ripple(button)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.Parent = button
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.85
    ripple.BorderSizePixel = 0
    ripple.ZIndex = button.ZIndex + 1
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    local mousePos = UserInputService:GetMouseLocation()
    local buttonPos = button.AbsolutePosition
    local relativeX = mousePos.X - buttonPos.X
    local relativeY = mousePos.Y - buttonPos.Y - 36
    
    ripple.Position = UDim2.new(0, relativeX, 0, relativeY)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    
    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y)
    
    local expandTween = CreateTween(ripple, {Size = UDim2.new(0, maxSize, 0, maxSize), BackgroundTransparency = 1}, 0.35)
    expandTween:Play()
    expandTween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

-- File System Functions
local function EnsureFolder()
    if not isfolder(CONFIG_FOLDER) then
        makefolder(CONFIG_FOLDER)
    end
end

local function SaveConfig(configName)
    EnsureFolder()
    local data = HttpService:JSONEncode(SavedData)
    writefile(CONFIG_FOLDER .. "/" .. configName .. ".json", data)
end

local function LoadConfig(configName)
    EnsureFolder()
    local path = CONFIG_FOLDER .. "/" .. configName .. ".json"
    if isfile(path) then
        local data = readfile(path)
        local success, decoded = pcall(function()
            return HttpService:JSONDecode(data)
        end)
        if success then
            SavedData = decoded
            return true
        end
    end
    return false
end

local function GetConfigs()
    EnsureFolder()
    local configs = {}
    for _, file in pairs(listfiles(CONFIG_FOLDER)) do
        local name = file:match("([^/\\]+)%.json$")
        if name then
            table.insert(configs, name)
        end
    end
    return configs
end

local function DeleteConfig(configName)
    EnsureFolder()
    local path = CONFIG_FOLDER .. "/" .. configName .. ".json"
    if isfile(path) then
        delfile(path)
        return true
    end
    return false
end

-- Main UI Library
local Library = {}
Library.Windows = {}
Library.ToggleKey = TOGGLE_KEY
Library.Visible = true
Library.Elements = {}

function Library:CreateWindow(title)
    -- Destroy existing UI
    if game.CoreGui:FindFirstChild("LierisUI") then
        game.CoreGui:FindFirstChild("LierisUI"):Destroy()
    end
    
    -- Load last config
    LoadConfig(SavedData.LastConfig or DEFAULT_CONFIG)
    
    -- Screen GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LierisUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- Main Window
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0, SavedData.WindowPosition.X, 0, SavedData.WindowPosition.Y)
    MainFrame.Size = UDim2.new(0, 600, 0, 450)
    MainFrame.ClipsDescendants = true
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Theme.Border
    MainStroke.Thickness = 1.5
    MainStroke.Parent = MainFrame
    
    -- Accent line at top
    local AccentLine = Instance.new("Frame")
    AccentLine.Name = "AccentLine"
    AccentLine.Parent = MainFrame
    AccentLine.BackgroundColor3 = Theme.Accent
    AccentLine.BorderSizePixel = 0
    AccentLine.Position = UDim2.new(0, 0, 0, 0)
    AccentLine.Size = UDim2.new(1, 0, 0, 2)
    AccentLine.ZIndex = 10
    
    local AccentLineCorner = Instance.new("UICorner")
    AccentLineCorner.CornerRadius = UDim.new(0, 10)
    AccentLineCorner.Parent = AccentLine
    
    -- Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Parent = MainFrame
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0, -20, 0, -20)
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.ZIndex = -1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.4
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = Theme.Secondary
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 42)
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 10)
    TitleCorner.Parent = TitleBar
    
    local TitleFix = Instance.new("Frame")
    TitleFix.Name = "TitleFix"
    TitleFix.Parent = TitleBar
    TitleFix.BackgroundColor3 = Theme.Secondary
    TitleFix.BorderSizePixel = 0
    TitleFix.Position = UDim2.new(0, 0, 0.5, 0)
    TitleFix.Size = UDim2.new(1, 0, 0.5, 0)
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Parent = TitleBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title or "Lieris"
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.TextSize = 17
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TitleBar
    CloseButton.BackgroundColor3 = Theme.Accent
    CloseButton.BorderSizePixel = 0
    CloseButton.Position = UDim2.new(1, -38, 0.5, -11)
    CloseButton.Size = UDim2.new(0, 22, 0, 22)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Theme.Text
    CloseButton.TextSize = 12
    CloseButton.AutoButtonColor = false
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseEnter:Connect(function()
        CreateTween(CloseButton, {BackgroundColor3 = Theme.AccentHover}):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        CreateTween(CloseButton, {BackgroundColor3 = Theme.Accent}):Play()
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        Library.Visible = false
        CreateTween(MainFrame, {Size = UDim2.new(0, 600, 0, 0)}):Play()
        task.wait(AnimationSpeed)
        MainFrame.Visible = false
    end)
    
    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = TitleBar
    MinimizeButton.BackgroundColor3 = Theme.Accent
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Position = UDim2.new(1, -65, 0.5, -11)
    MinimizeButton.Size = UDim2.new(0, 22, 0, 22)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Theme.Text
    MinimizeButton.TextSize = 16
    MinimizeButton.AutoButtonColor = false
    
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 6)
    MinimizeCorner.Parent = MinimizeButton
    
    MinimizeButton.MouseEnter:Connect(function()
        CreateTween(MinimizeButton, {BackgroundColor3 = Theme.AccentHover}):Play()
    end)
    
    MinimizeButton.MouseLeave:Connect(function()
        CreateTween(MinimizeButton, {BackgroundColor3 = Theme.Accent}):Play()
    end)
    
    -- Minimize State
    local minimized = false
    local normalSize = UDim2.new(0, 600, 0, 450)
    local minimizedSize = UDim2.new(0, 600, 0, 42)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            CreateTween(MainFrame, {Size = minimizedSize}):Play()
            MinimizeButton.Text = "+"
        else
            CreateTween(MainFrame, {Size = normalSize}):Play()
            MinimizeButton.Text = "-"
        end
    end)
    
    -- Dragging
    local dragging, dragInput, dragStart, startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    SavedData.WindowPosition = {X = MainFrame.Position.X.Offset, Y = MainFrame.Position.Y.Offset}
                    SaveConfig(SavedData.LastConfig or DEFAULT_CONFIG)
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Tab Container (Left Side)
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundColor3 = Theme.Secondary
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 0, 0, 42)
    TabContainer.Size = UDim2.new(0, 145, 1, -42)
    
    -- Separator line
    local TabSeparator = Instance.new("Frame")
    TabSeparator.Name = "Separator"
    TabSeparator.Parent = TabContainer
    TabSeparator.BackgroundColor3 = Theme.Border
    TabSeparator.BorderSizePixel = 0
    TabSeparator.Position = UDim2.new(1, -1, 0, 10)
    TabSeparator.Size = UDim2.new(0, 1, 1, -20)
    
    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.Parent = TabContainer
    TabList.BackgroundTransparency = 1
    TabList.BorderSizePixel = 0
    TabList.Position = UDim2.new(0, 8, 0, 12)
    TabList.Size = UDim2.new(1, -16, 1, -24)
    TabList.ScrollBarThickness = 2
    TabList.ScrollBarImageColor3 = Theme.Accent
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabList
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 6)
    
    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabList.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Content Container (Right Side)
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundColor3 = Theme.Background
    ContentContainer.BackgroundTransparency = 0.3
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Position = UDim2.new(0, 150, 0, 50)
    ContentContainer.Size = UDim2.new(1, -160, 1, -60)
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 8)
    ContentCorner.Parent = ContentContainer
    
    -- Window Object
    local Window = {}
    Window.Tabs = {}
    Window.ActiveTab = nil
    Window.GUI = ScreenGui
    Window.Main = MainFrame
    
    -- Toggle Visibility with H key
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Library.ToggleKey then
            Library.Visible = not Library.Visible
            if Library.Visible then
                MainFrame.Visible = true
                MainFrame.Size = UDim2.new(0, 600, 0, 0)
                CreateTween(MainFrame, {Size = UDim2.new(0, 600, 0, 450)}):Play()
            else
                CreateTween(MainFrame, {Size = UDim2.new(0, 600, 0, 0)}):Play()
                task.wait(AnimationSpeed)
                MainFrame.Visible = false
            end
        end
    end)
    
    -- Create Tab Function
    function Window:CreateTab(tabName, icon)
        local Tab = {}
        Tab.Name = tabName
        Tab.Elements = {}
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.Parent = TabList
        TabButton.BackgroundColor3 = Theme.Tertiary
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 0, 36)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = "   " .. tabName
        TabButton.TextColor3 = Theme.TextDark
        TabButton.TextSize = 13
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.AutoButtonColor = false
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 8)
        TabButtonCorner.Parent = TabButton
        
        local TabIndicator = Instance.new("Frame")
        TabIndicator.Name = "Indicator"
        TabIndicator.Parent = TabButton
        TabIndicator.BackgroundColor3 = Theme.Accent
        TabIndicator.BorderSizePixel = 0
        TabIndicator.Position = UDim2.new(0, 0, 0.2, 0)
        TabIndicator.Size = UDim2.new(0, 3, 0.6, 0)
        TabIndicator.Visible = false
        
        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(0, 2)
        IndicatorCorner.Parent = TabIndicator
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "Content"
        TabContent.Parent = ContentContainer
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = Theme.Accent
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = TabContent
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 10)
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.Parent = TabContent
        ContentPadding.PaddingLeft = UDim.new(0, 8)
        ContentPadding.PaddingRight = UDim.new(0, 12)
        ContentPadding.PaddingTop = UDim.new(0, 8)
        
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        Tab.Button = TabButton
        Tab.Content = TabContent
        Tab.Indicator = TabIndicator
        
        -- Select Tab
        local function SelectTab()
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                tab.Indicator.Visible = false
                CreateTween(tab.Button, {BackgroundColor3 = Theme.Tertiary, TextColor3 = Theme.TextDark}):Play()
            end
            
            TabContent.Visible = true
            TabIndicator.Visible = true
            CreateTween(TabButton, {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.Text}):Play()
            Window.ActiveTab = Tab
            
            SavedData.ActiveTab = tabName
            SaveConfig(SavedData.LastConfig or DEFAULT_CONFIG)
        end
        
        TabButton.MouseButton1Click:Connect(function()
            Ripple(TabButton)
            SelectTab()
        end)
        
        TabButton.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then
                CreateTween(TabButton, {BackgroundColor3 = Theme.Border}):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then
                CreateTween(TabButton, {BackgroundColor3 = Theme.Tertiary}):Play()
            end
        end)
        
        -- Auto select first tab or saved tab
        if #Window.Tabs == 0 or SavedData.ActiveTab == tabName then
            task.spawn(SelectTab)
        end
        
        table.insert(Window.Tabs, Tab)
        
        -- Section Function
        function Tab:CreateSection(sectionName)
            local Section = {}
            Section.Name = sectionName
            
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = sectionName
            SectionFrame.Parent = TabContent
            SectionFrame.BackgroundColor3 = Theme.Secondary
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Size = UDim2.new(1, 0, 0, 38)
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 8)
            SectionCorner.Parent = SectionFrame
            
            local SectionStroke = Instance.new("UIStroke")
            SectionStroke.Color = Theme.Border
            SectionStroke.Thickness = 1
            SectionStroke.Transparency = 0.5
            SectionStroke.Parent = SectionFrame
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.Parent = SectionFrame
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 12, 0, 0)
            SectionTitle.Size = UDim2.new(1, -24, 0, 38)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = sectionName
            SectionTitle.TextColor3 = Theme.Text
            SectionTitle.TextSize = 14
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local SectionContent = Instance.new("Frame")
            SectionContent.Name = "Content"
            SectionContent.Parent = SectionFrame
            SectionContent.BackgroundTransparency = 1
            SectionContent.Position = UDim2.new(0, 0, 0, 38)
            SectionContent.Size = UDim2.new(1, 0, 0, 0)
            SectionContent.AutomaticSize = Enum.AutomaticSize.Y
            
            local SectionLayout = Instance.new("UIListLayout")
            SectionLayout.Parent = SectionContent
            SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SectionLayout.Padding = UDim.new(0, 6)
            
            local SectionPadding = Instance.new("UIPadding")
            SectionPadding.Parent = SectionContent
            SectionPadding.PaddingLeft = UDim.new(0, 12)
            SectionPadding.PaddingRight = UDim.new(0, 12)
            SectionPadding.PaddingBottom = UDim.new(0, 12)
            
            -- Toggle
            function Section:CreateToggle(toggleName, default, callback)
                local uniqueId = tabName .. "_" .. sectionName .. "_" .. toggleName
                
                if SavedData.Toggles[uniqueId] ~= nil then
                    default = SavedData.Toggles[uniqueId]
                end
                
                local Toggle = {}
                Toggle.Value = default or false
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = toggleName
                ToggleFrame.Parent = SectionContent
                ToggleFrame.BackgroundColor3 = Theme.Tertiary
                ToggleFrame.BorderSizePixel = 0
                ToggleFrame.Size = UDim2.new(1, 0, 0, 38)
                
                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 6)
                ToggleCorner.Parent = ToggleFrame
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Name = "Label"
                ToggleLabel.Parent = ToggleFrame
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
                ToggleLabel.Size = UDim2.new(1, -65, 1, 0)
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.Text = toggleName
                ToggleLabel.TextColor3 = Theme.Text
                ToggleLabel.TextSize = 13
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local ToggleButton = Instance.new("Frame")
                ToggleButton.Name = "ToggleButton"
                ToggleButton.Parent = ToggleFrame
                ToggleButton.BackgroundColor3 = Toggle.Value and Theme.Accent or Theme.Border
                ToggleButton.BorderSizePixel = 0
                ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
                ToggleButton.Size = UDim2.new(0, 40, 0, 20)
                
                local ToggleButtonCorner = Instance.new("UICorner")
                ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
                ToggleButtonCorner.Parent = ToggleButton
                
                local ToggleCircle = Instance.new("Frame")
                ToggleCircle.Name = "Circle"
                ToggleCircle.Parent = ToggleButton
                ToggleCircle.BackgroundColor3 = Theme.Text
                ToggleCircle.BorderSizePixel = 0
                ToggleCircle.Position = Toggle.Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
                
                local CircleCorner = Instance.new("UICorner")
                CircleCorner.CornerRadius = UDim.new(1, 0)
                CircleCorner.Parent = ToggleCircle
                
                local ToggleClickArea = Instance.new("TextButton")
                ToggleClickArea.Name = "ClickArea"
                ToggleClickArea.Parent = ToggleFrame
                ToggleClickArea.BackgroundTransparency = 1
                ToggleClickArea.Size = UDim2.new(1, 0, 1, 0)
                ToggleClickArea.Text = ""
                
                local function UpdateToggle()
                    if Toggle.Value then
                        CreateTween(ToggleButton, {BackgroundColor3 = Theme.Accent}):Play()
                        CreateTween(ToggleCircle, {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
                    else
                        CreateTween(ToggleButton, {BackgroundColor3 = Theme.Border}):Play()
                        CreateTween(ToggleCircle, {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
                    end
                    
                    SavedData.Toggles[uniqueId] = Toggle.Value
                    SaveConfig(SavedData.LastConfig or DEFAULT_CONFIG)
                    
                    if callback then
                        callback(Toggle.Value)
                    end
                end
                
                ToggleClickArea.MouseButton1Click:Connect(function()
                    Toggle.Value = not Toggle.Value
                    UpdateToggle()
                end)
                
                function Toggle:Set(value)
                    Toggle.Value = value
                    UpdateToggle()
                end
                
                -- Initial callback
                if callback and Toggle.Value then
                    task.spawn(function()
                        callback(Toggle.Value)
                    end)
                end
                
                Library.Elements[uniqueId] = Toggle
                return Toggle
            end
            
            -- Slider
            function Section:CreateSlider(sliderName, min, max, default, callback)
                local uniqueId = tabName .. "_" .. sectionName .. "_" .. sliderName
                
                if SavedData.Sliders[uniqueId] ~= nil then
                    default = SavedData.Sliders[uniqueId]
                end
                
                local Slider = {}
                Slider.Value = default or min
                
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = sliderName
                SliderFrame.Parent = SectionContent
                SliderFrame.BackgroundColor3 = Theme.Tertiary
                SliderFrame.BorderSizePixel = 0
                SliderFrame.Size = UDim2.new(1, 0, 0, 52)
                
                local SliderCorner = Instance.new("UICorner")
                SliderCorner.CornerRadius = UDim.new(0, 6)
                SliderCorner.Parent = SliderFrame
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Name = "Label"
                SliderLabel.Parent = SliderFrame
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Position = UDim2.new(0, 12, 0, 0)
                SliderLabel.Size = UDim2.new(1, -75, 0, 26)
                SliderLabel.Font = Enum.Font.Gotham
                SliderLabel.Text = sliderName
                SliderLabel.TextColor3 = Theme.Text
                SliderLabel.TextSize = 13
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local SliderValue = Instance.new("TextLabel")
                SliderValue.Name = "Value"
                SliderValue.Parent = SliderFrame
                SliderValue.BackgroundTransparency = 1
                SliderValue.Position = UDim2.new(1, -60, 0, 0)
                SliderValue.Size = UDim2.new(0, 48, 0, 26)
                SliderValue.Font = Enum.Font.GothamBold
                SliderValue.Text = tostring(Slider.Value)
                SliderValue.TextColor3 = Theme.Accent
                SliderValue.TextSize = 13
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right
                
                local SliderBar = Instance.new("Frame")
                SliderBar.Name = "Bar"
                SliderBar.Parent = SliderFrame
                SliderBar.BackgroundColor3 = Theme.Border
                SliderBar.BorderSizePixel = 0
                SliderBar.Position = UDim2.new(0, 12, 0, 34)
                SliderBar.Size = UDim2.new(1, -24, 0, 6)
                
                local SliderBarCorner = Instance.new("UICorner")
                SliderBarCorner.CornerRadius = UDim.new(1, 0)
                SliderBarCorner.Parent = SliderBar
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "Fill"
                SliderFill.Parent = SliderBar
                SliderFill.BackgroundColor3 = Theme.Accent
                SliderFill.BorderSizePixel = 0
                SliderFill.Size = UDim2.new((Slider.Value - min) / (max - min), 0, 1, 0)
                
                local SliderFillCorner = Instance.new("UICorner")
                SliderFillCorner.CornerRadius = UDim.new(1, 0)
                SliderFillCorner.Parent = SliderFill
                
                local SliderKnob = Instance.new("Frame")
                SliderKnob.Name = "Knob"
                SliderKnob.Parent = SliderFill
                SliderKnob.BackgroundColor3 = Theme.Text
                SliderKnob.BorderSizePixel = 0
                SliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
                SliderKnob.Position = UDim2.new(1, 0, 0.5, 0)
                SliderKnob.Size = UDim2.new(0, 12, 0, 12)
                
                local SliderKnobCorner = Instance.new("UICorner")
                SliderKnobCorner.CornerRadius = UDim.new(1, 0)
                SliderKnobCorner.Parent = SliderKnob
                
                local draggingSlider = false
                
                local function UpdateSlider(input)
                    local pos = UDim2.new(math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1), 0, 1, 0)
                    SliderFill.Size = pos
                    
                    local value = math.floor(min + ((max - min) * pos.X.Scale))
                    Slider.Value = value
                    SliderValue.Text = tostring(value)
                    
                    SavedData.Sliders[uniqueId] = value
                    SaveConfig(SavedData.LastConfig or DEFAULT_CONFIG)
                    
                    if callback then
                        callback(value)
                    end
                end
                
                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingSlider = true
                        UpdateSlider(input)
                    end
                end)
                
                SliderBar.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingSlider = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
                        UpdateSlider(input)
                    end
                end)
                
                function Slider:Set(value)
                    Slider.Value = math.clamp(value, min, max)
                    SliderFill.Size = UDim2.new((Slider.Value - min) / (max - min), 0, 1, 0)
                    SliderValue.Text = tostring(Slider.Value)
                    
                    SavedData.Sliders[uniqueId] = Slider.Value
                    SaveConfig(SavedData.LastConfig or DEFAULT_CONFIG)
                    
                    if callback then
                        callback(Slider.Value)
                    end
                end
                
                -- Initial callback
                if callback then
                    task.spawn(function()
                        callback(Slider.Value)
                    end)
                end
                
                Library.Elements[uniqueId] = Slider
                return Slider
            end
            
            -- Button
            function Section:CreateButton(buttonName, callback)
                local Button = {}
                
                local ButtonFrame = Instance.new("TextButton")
                ButtonFrame.Name = buttonName
                ButtonFrame.Parent = SectionContent
                ButtonFrame.BackgroundColor3 = Theme.Accent
                ButtonFrame.BorderSizePixel = 0
                ButtonFrame.Size = UDim2.new(1, 0, 0, 38)
                ButtonFrame.Font = Enum.Font.GothamSemibold
                ButtonFrame.Text = buttonName
                ButtonFrame.TextColor3 = Theme.Text
                ButtonFrame.TextSize = 13
                ButtonFrame.AutoButtonColor = false
                ButtonFrame.ClipsDescendants = true
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 6)
                ButtonCorner.Parent = ButtonFrame
                
                ButtonFrame.MouseEnter:Connect(function()
                    CreateTween(ButtonFrame, {BackgroundColor3 = Theme.AccentHover}):Play()
                end)
                
                ButtonFrame.MouseLeave:Connect(function()
                    CreateTween(ButtonFrame, {BackgroundColor3 = Theme.Accent}):Play()
                end)
                
                ButtonFrame.MouseButton1Down:Connect(function()
                    CreateTween(ButtonFrame, {BackgroundColor3 = Theme.AccentPressed}):Play()
                end)
                
                ButtonFrame.MouseButton1Up:Connect(function()
                    CreateTween(ButtonFrame, {BackgroundColor3 = Theme.AccentHover}):Play()
                end)
                
                ButtonFrame.MouseButton1Click:Connect(function()
                    Ripple(ButtonFrame)
                    if callback then
                        callback()
                    end
                end)
                
                return Button
            end
            
            -- Keybind
            function Section:CreateKeybind(keybindName, default, callback)
                local uniqueId = tabName .. "_" .. sectionName .. "_" .. keybindName
                
                if SavedData.Keybinds[uniqueId] ~= nil then
                    default = Enum.KeyCode[SavedData.Keybinds[uniqueId]]
                end
                
                local Keybind = {}
                Keybind.Value = default or Enum.KeyCode.Unknown
                local listening = false
                
                local KeybindFrame = Instance.new("Frame")
                KeybindFrame.Name = keybindName
                KeybindFrame.Parent = SectionContent
                KeybindFrame.BackgroundColor3 = Theme.Tertiary
                KeybindFrame.BorderSizePixel = 0
                KeybindFrame.Size = UDim2.new(1, 0, 0, 38)
                
                local KeybindCorner = Instance.new("UICorner")
                KeybindCorner.CornerRadius = UDim.new(0, 6)
                KeybindCorner.Parent = KeybindFrame
                
                local KeybindLabel = Instance.new("TextLabel")
                KeybindLabel.Name = "Label"
                KeybindLabel.Parent = KeybindFrame
                KeybindLabel.BackgroundTransparency = 1
                KeybindLabel.Position = UDim2.new(0, 12, 0, 0)
                KeybindLabel.Size = UDim2.new(1, -100, 1, 0)
                KeybindLabel.Font = Enum.Font.Gotham
                KeybindLabel.Text = keybindName
                KeybindLabel.TextColor3 = Theme.Text
                KeybindLabel.TextSize = 13
                KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local KeybindButton = Instance.new("TextButton")
                KeybindButton.Name = "Button"
                KeybindButton.Parent = KeybindFrame
                KeybindButton.BackgroundColor3 = Theme.Accent
                KeybindButton.BorderSizePixel = 0
                KeybindButton.Position = UDim2.new(1, -88, 0.5, -13)
                KeybindButton.Size = UDim2.new(0, 76, 0, 26)
                KeybindButton.Font = Enum.Font.GothamSemibold
                KeybindButton.Text = Keybind.Value.Name
                KeybindButton.TextColor3 = Theme.Text
                KeybindButton.TextSize = 11
                KeybindButton.AutoButtonColor = false
                
                local KeybindButtonCorner = Instance.new("UICorner")
                KeybindButtonCorner.CornerRadius = UDim.new(0, 6)
                KeybindButtonCorner.Parent = KeybindButton
                
                KeybindButton.MouseButton1Click:Connect(function()
                    listening = true
                    KeybindButton.Text = "..."
                    CreateTween(KeybindButton, {BackgroundColor3 = Theme.AccentHover}):Play()
                end)
                
                UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if listening then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            listening = false
                            Keybind.Value = input.KeyCode
                            KeybindButton.Text = input.KeyCode.Name
                            CreateTween(KeybindButton, {BackgroundColor3 = Theme.Accent}):Play()
                            
                            SavedData.Keybinds[uniqueId] = input.KeyCode.Name
                            SaveConfig(SavedData.LastConfig or DEFAULT_CONFIG)
                        end
                    else
                        if not gameProcessed and input.KeyCode == Keybind.Value then
                            if callback then
                                callback(Keybind.Value)
                            end
                        end
                    end
                end)
                
                function Keybind:Set(key)
                    Keybind.Value = key
                    KeybindButton.Text = key.Name
                    
                    SavedData.Keybinds[uniqueId] = key.Name
                    SaveConfig(SavedData.LastConfig or DEFAULT_CONFIG)
                end
                
                Library.Elements[uniqueId] = Keybind
                return Keybind
            end
            
            -- Dropdown
            function Section:CreateDropdown(dropdownName, options, default, callback)
                local uniqueId = tabName .. "_" .. sectionName .. "_" .. dropdownName
                
                if SavedData.Dropdowns[uniqueId] ~= nil then
                    default = SavedData.Dropdowns[uniqueId]
                end
                
                local Dropdown = {}
                Dropdown.Value = default or options[1]
                Dropdown.Options = options
                local opened = false
                
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Name = dropdownName
                DropdownFrame.Parent = SectionContent
                DropdownFrame.BackgroundColor3 = Theme.Tertiary
                DropdownFrame.BorderSizePixel = 0
                DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
                DropdownFrame.ClipsDescendants = true
                
                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 4)
                DropdownCorner.Parent = DropdownFrame
                
                local DropdownLabel = Instance.new("TextLabel")
                DropdownLabel.Name = "Label"
                DropdownLabel.Parent = DropdownFrame
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
                DropdownLabel.Size = UDim2.new(0.5, -10, 0, 35)
                DropdownLabel.Font = Enum.Font.Gotham
                DropdownLabel.Text = dropdownName
                DropdownLabel.TextColor3 = Theme.Text
                DropdownLabel.TextSize = 13
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Name = "Button"
                DropdownButton.Parent = DropdownFrame
                DropdownButton.BackgroundColor3 = Theme.Accent
                DropdownButton.BorderSizePixel = 0
                DropdownButton.Position = UDim2.new(0.5, 5, 0, 5)
                DropdownButton.Size = UDim2.new(0.5, -15, 0, 25)
                DropdownButton.Font = Enum.Font.GothamSemibold
                DropdownButton.Text = Dropdown.Value .. "  v"
                DropdownButton.TextColor3 = Theme.Text
                DropdownButton.TextSize = 12
                DropdownButton.AutoButtonColor = false
                
                local DropdownButtonCorner = Instance.new("UICorner")
                DropdownButtonCorner.CornerRadius = UDim.new(0, 4)
                DropdownButtonCorner.Parent = DropdownButton
                
                local DropdownOptions = Instance.new("Frame")
                DropdownOptions.Name = "Options"
                DropdownOptions.Parent = DropdownFrame
                DropdownOptions.BackgroundTransparency = 1
                DropdownOptions.Position = UDim2.new(0, 10, 0, 40)
                DropdownOptions.Size = UDim2.new(1, -20, 0, 0)
                DropdownOptions.AutomaticSize = Enum.AutomaticSize.Y
                
                local OptionsLayout = Instance.new("UIListLayout")
                OptionsLayout.Parent = DropdownOptions
                OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
                OptionsLayout.Padding = UDim.new(0, 3)
                
                for _, option in ipairs(options) do
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Name = option
                    OptionButton.Parent = DropdownOptions
                    OptionButton.BackgroundColor3 = Theme.Border
                    OptionButton.BorderSizePixel = 0
                    OptionButton.Size = UDim2.new(1, 0, 0, 28)
                    OptionButton.Font = Enum.Font.Gotham
                    OptionButton.Text = option
                    OptionButton.TextColor3 = Theme.Text
                    OptionButton.TextSize = 12
                    OptionButton.AutoButtonColor = false
                    
                    local OptionCorner = Instance.new("UICorner")
                    OptionCorner.CornerRadius = UDim.new(0, 4)
                    OptionCorner.Parent = OptionButton
                    
                    OptionButton.MouseEnter:Connect(function()
                        CreateTween(OptionButton, {BackgroundColor3 = Theme.Accent}):Play()
                    end)
                    
                    OptionButton.MouseLeave:Connect(function()
                        CreateTween(OptionButton, {BackgroundColor3 = Theme.Border}):Play()
                    end)
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        Dropdown.Value = option
                        DropdownButton.Text = option .. "  v"
                        opened = false
                        CreateTween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 35)}):Play()
                        
                        SavedData.Dropdowns[uniqueId] = option
                        SaveConfig(SavedData.LastConfig or DEFAULT_CONFIG)
                        
                        if callback then
                            callback(option)
                        end
                    end)
                end
                
                DropdownButton.MouseButton1Click:Connect(function()
                    opened = not opened
                    if opened then
                        local totalHeight = 45 + (#options * 31)
                        CreateTween(DropdownFrame, {Size = UDim2.new(1, 0, 0, totalHeight)}):Play()
                    else
                        CreateTween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 35)}):Play()
                    end
                end)
                
                function Dropdown:Set(value)
                    if table.find(options, value) then
                        Dropdown.Value = value
                        DropdownButton.Text = value .. "  v"
                        
                        SavedData.Dropdowns[uniqueId] = value
                        SaveConfig(SavedData.LastConfig or DEFAULT_CONFIG)
                        
                        if callback then
                            callback(value)
                        end
                    end
                end
                
                function Dropdown:Refresh(newOptions)
                    for _, child in pairs(DropdownOptions:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    Dropdown.Options = newOptions
                    
                    for _, option in ipairs(newOptions) do
                        local OptionButton = Instance.new("TextButton")
                        OptionButton.Name = option
                        OptionButton.Parent = DropdownOptions
                        OptionButton.BackgroundColor3 = Theme.Border
                        OptionButton.BorderSizePixel = 0
                        OptionButton.Size = UDim2.new(1, 0, 0, 28)
                        OptionButton.Font = Enum.Font.Gotham
                        OptionButton.Text = option
                        OptionButton.TextColor3 = Theme.Text
                        OptionButton.TextSize = 12
                        OptionButton.AutoButtonColor = false
                        
                        local OptionCorner = Instance.new("UICorner")
                        OptionCorner.CornerRadius = UDim.new(0, 4)
                        OptionCorner.Parent = OptionButton
                        
                        OptionButton.MouseEnter:Connect(function()
                            CreateTween(OptionButton, {BackgroundColor3 = Theme.Accent}):Play()
                        end)
                        
                        OptionButton.MouseLeave:Connect(function()
                            CreateTween(OptionButton, {BackgroundColor3 = Theme.Border}):Play()
                        end)
                        
                        OptionButton.MouseButton1Click:Connect(function()
                            Dropdown.Value = option
                            DropdownButton.Text = option .. "  v"
                            opened = false
                            CreateTween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 35)}):Play()
                            
                            SavedData.Dropdowns[uniqueId] = option
                            SaveConfig(SavedData.LastConfig or DEFAULT_CONFIG)
                            
                            if callback then
                                callback(option)
                            end
                        end)
                    end
                end
                
                -- Initial callback
                if callback then
                    task.spawn(function()
                        callback(Dropdown.Value)
                    end)
                end
                
                Library.Elements[uniqueId] = Dropdown
                return Dropdown
            end
            
            -- Text Input
            function Section:CreateTextInput(inputName, placeholder, default, callback)
                local uniqueId = tabName .. "_" .. sectionName .. "_" .. inputName
                
                if SavedData.TextInputs[uniqueId] ~= nil then
                    default = SavedData.TextInputs[uniqueId]
                end
                
                local TextInput = {}
                TextInput.Value = default or ""
                
                local InputFrame = Instance.new("Frame")
                InputFrame.Name = inputName
                InputFrame.Parent = SectionContent
                InputFrame.BackgroundColor3 = Theme.Tertiary
                InputFrame.BorderSizePixel = 0
                InputFrame.Size = UDim2.new(1, 0, 0, 35)
                
                local InputCorner = Instance.new("UICorner")
                InputCorner.CornerRadius = UDim.new(0, 4)
                InputCorner.Parent = InputFrame
                
                local InputLabel = Instance.new("TextLabel")
                InputLabel.Name = "Label"
                InputLabel.Parent = InputFrame
                InputLabel.BackgroundTransparency = 1
                InputLabel.Position = UDim2.new(0, 10, 0, 0)
                InputLabel.Size = UDim2.new(0.4, -10, 1, 0)
                InputLabel.Font = Enum.Font.Gotham
                InputLabel.Text = inputName
                InputLabel.TextColor3 = Theme.Text
                InputLabel.TextSize = 13
                InputLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local InputBox = Instance.new("TextBox")
                InputBox.Name = "Input"
                InputBox.Parent = InputFrame
                InputBox.BackgroundColor3 = Theme.Border
                InputBox.BorderSizePixel = 0
                InputBox.Position = UDim2.new(0.4, 5, 0, 5)
                InputBox.Size = UDim2.new(0.6, -15, 1, -10)
                InputBox.Font = Enum.Font.Gotham
                InputBox.Text = TextInput.Value
                InputBox.PlaceholderText = placeholder or ""
                InputBox.PlaceholderColor3 = Theme.TextDark
                InputBox.TextColor3 = Theme.Text
                InputBox.TextSize = 12
                InputBox.ClearTextOnFocus = false
                
                local InputBoxCorner = Instance.new("UICorner")
                InputBoxCorner.CornerRadius = UDim.new(0, 4)
                InputBoxCorner.Parent = InputBox
                
                InputBox.FocusLost:Connect(function()
                    TextInput.Value = InputBox.Text
                    
                    SavedData.TextInputs[uniqueId] = InputBox.Text
                    SaveConfig(SavedData.LastConfig or DEFAULT_CONFIG)
                    
                    if callback then
                        callback(InputBox.Text)
                    end
                end)
                
                function TextInput:Set(value)
                    TextInput.Value = value
                    InputBox.Text = value
                    
                    SavedData.TextInputs[uniqueId] = value
                    SaveConfig(SavedData.LastConfig or DEFAULT_CONFIG)
                    
                    if callback then
                        callback(value)
                    end
                end
                
                Library.Elements[uniqueId] = TextInput
                return TextInput
            end
            
            -- Color Picker
            function Section:CreateColorPicker(pickerName, default, callback)
                local uniqueId = tabName .. "_" .. sectionName .. "_" .. pickerName
                
                if SavedData.Colors[uniqueId] ~= nil then
                    local saved = SavedData.Colors[uniqueId]
                    default = Color3.fromRGB(saved.R, saved.G, saved.B)
                end
                
                local ColorPicker = {}
                ColorPicker.Value = default or Color3.fromRGB(255, 255, 255)
                local pickerOpen = false
                local selectedColor = ColorPicker.Value
                local hue, sat, val = Color3.toHSV(ColorPicker.Value)
                
                local PickerFrame = Instance.new("Frame")
                PickerFrame.Name = pickerName
                PickerFrame.Parent = SectionContent
                PickerFrame.BackgroundColor3 = Theme.Tertiary
                PickerFrame.BorderSizePixel = 0
                PickerFrame.Size = UDim2.new(1, 0, 0, 35)
                PickerFrame.ClipsDescendants = true
                
                local PickerCorner = Instance.new("UICorner")
                PickerCorner.CornerRadius = UDim.new(0, 4)
                PickerCorner.Parent = PickerFrame
                
                local PickerLabel = Instance.new("TextLabel")
                PickerLabel.Name = "Label"
                PickerLabel.Parent = PickerFrame
                PickerLabel.BackgroundTransparency = 1
                PickerLabel.Position = UDim2.new(0, 10, 0, 0)
                PickerLabel.Size = UDim2.new(1, -60, 0, 35)
                PickerLabel.Font = Enum.Font.Gotham
                PickerLabel.Text = pickerName
                PickerLabel.TextColor3 = Theme.Text
                PickerLabel.TextSize = 13
                PickerLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local ColorPreview = Instance.new("TextButton")
                ColorPreview.Name = "Preview"
                ColorPreview.Parent = PickerFrame
                ColorPreview.BackgroundColor3 = ColorPicker.Value
                ColorPreview.BorderSizePixel = 0
                ColorPreview.Position = UDim2.new(1, -45, 0, 7)
                ColorPreview.Size = UDim2.new(0, 35, 0, 21)
                ColorPreview.Text = ""
                ColorPreview.AutoButtonColor = false
                
                local PreviewCorner = Instance.new("UICorner")
                PreviewCorner.CornerRadius = UDim.new(0, 4)
                PreviewCorner.Parent = ColorPreview
                
                local PreviewStroke = Instance.new("UIStroke")
                PreviewStroke.Color = Theme.Border
                PreviewStroke.Thickness = 1
                PreviewStroke.Parent = ColorPreview
                
                -- Color Picker Content
                local PickerContent = Instance.new("Frame")
                PickerContent.Name = "Content"
                PickerContent.Parent = PickerFrame
                PickerContent.BackgroundTransparency = 1
                PickerContent.Position = UDim2.new(0, 10, 0, 40)
                PickerContent.Size = UDim2.new(1, -20, 0, 180)
                
                -- Saturation/Value Box
                local SatValBox = Instance.new("ImageLabel")
                SatValBox.Name = "SatValBox"
                SatValBox.Parent = PickerContent
                SatValBox.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                SatValBox.BorderSizePixel = 0
                SatValBox.Position = UDim2.new(0, 0, 0, 0)
                SatValBox.Size = UDim2.new(0, 150, 0, 150)
                SatValBox.Image = "rbxassetid://4155801252"
                
                local SatValCorner = Instance.new("UICorner")
                SatValCorner.CornerRadius = UDim.new(0, 4)
                SatValCorner.Parent = SatValBox
                
                local SatValCursor = Instance.new("Frame")
                SatValCursor.Name = "Cursor"
                SatValCursor.Parent = SatValBox
                SatValCursor.BackgroundColor3 = Theme.Text
                SatValCursor.BorderSizePixel = 0
                SatValCursor.AnchorPoint = Vector2.new(0.5, 0.5)
                SatValCursor.Position = UDim2.new(sat, 0, 1 - val, 0)
                SatValCursor.Size = UDim2.new(0, 10, 0, 10)
                
                local CursorCorner = Instance.new("UICorner")
                CursorCorner.CornerRadius = UDim.new(1, 0)
                CursorCorner.Parent = SatValCursor
                
                local CursorStroke = Instance.new("UIStroke")
                CursorStroke.Color = Color3.fromRGB(0, 0, 0)
                CursorStroke.Thickness = 2
                CursorStroke.Parent = SatValCursor
                
                -- Hue Slider
                local HueSlider = Instance.new("Frame")
                HueSlider.Name = "HueSlider"
                HueSlider.Parent = PickerContent
                HueSlider.BackgroundColor3 = Theme.Text
                HueSlider.BorderSizePixel = 0
                HueSlider.Position = UDim2.new(0, 160, 0, 0)
                HueSlider.Size = UDim2.new(0, 20, 0, 150)
                
                local HueCorner = Instance.new("UICorner")
                HueCorner.CornerRadius = UDim.new(0, 4)
                HueCorner.Parent = HueSlider
                
                local HueGradient = Instance.new("UIGradient")
                HueGradient.Rotation = 90
                HueGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                })
                HueGradient.Parent = HueSlider
                
                local HueCursor = Instance.new("Frame")
                HueCursor.Name = "Cursor"
                HueCursor.Parent = HueSlider
                HueCursor.BackgroundColor3 = Theme.Text
                HueCursor.BorderSizePixel = 0
                HueCursor.AnchorPoint = Vector2.new(0.5, 0.5)
                HueCursor.Position = UDim2.new(0.5, 0, hue, 0)
                HueCursor.Size = UDim2.new(1, 4, 0, 6)
                
                local HueCursorCorner = Instance.new("UICorner")
                HueCursorCorner.CornerRadius = UDim.new(0, 2)
                HueCursorCorner.Parent = HueCursor
                
                local HueCursorStroke = Instance.new("UIStroke")
                HueCursorStroke.Color = Color3.fromRGB(0, 0, 0)
                HueCursorStroke.Thickness = 1
                HueCursorStroke.Parent = HueCursor
                
                -- RGB Inputs
                local RGBFrame = Instance.new("Frame")
                RGBFrame.Name = "RGBFrame"
                RGBFrame.Parent = PickerContent
                RGBFrame.BackgroundTransparency = 1
                RGBFrame.Position = UDim2.new(0, 190, 0, 0)
                RGBFrame.Size = UDim2.new(1, -190, 0, 150)
                
                local function CreateRGBInput(name, yPos, defaultVal)
                    local InputFrame = Instance.new("Frame")
                    InputFrame.Name = name
                    InputFrame.Parent = RGBFrame
                    InputFrame.BackgroundTransparency = 1
                    InputFrame.Position = UDim2.new(0, 0, 0, yPos)
                    InputFrame.Size = UDim2.new(1, 0, 0, 30)
                    
                    local Label = Instance.new("TextLabel")
                    Label.Parent = InputFrame
                    Label.BackgroundTransparency = 1
                    Label.Size = UDim2.new(0, 20, 1, 0)
                    Label.Font = Enum.Font.GothamBold
                    Label.Text = name
                    Label.TextColor3 = Theme.Text
                    Label.TextSize = 12
                    
                    local Input = Instance.new("TextBox")
                    Input.Name = "Input"
                    Input.Parent = InputFrame
                    Input.BackgroundColor3 = Theme.Border
                    Input.BorderSizePixel = 0
                    Input.Position = UDim2.new(0, 25, 0, 3)
                    Input.Size = UDim2.new(1, -25, 0, 24)
                    Input.Font = Enum.Font.Gotham
                    Input.Text = tostring(defaultVal)
                    Input.TextColor3 = Theme.Text
                    Input.TextSize = 12
                    
                    local InputCorner = Instance.new("UICorner")
                    InputCorner.CornerRadius = UDim.new(0, 4)
                    InputCorner.Parent = Input
                    
                    return Input
                end
                
                local r, g, b = math.floor(ColorPicker.Value.R * 255), math.floor(ColorPicker.Value.G * 255), math.floor(ColorPicker.Value.B * 255)
                local RInput = CreateRGBInput("R", 0, r)
                local GInput = CreateRGBInput("G", 35, g)
                local BInput = CreateRGBInput("B", 70, b)
                
                -- HEX Input
                local HexFrame = Instance.new("Frame")
                HexFrame.Name = "HexFrame"
                HexFrame.Parent = RGBFrame
                HexFrame.BackgroundTransparency = 1
                HexFrame.Position = UDim2.new(0, 0, 0, 110)
                HexFrame.Size = UDim2.new(1, 0, 0, 30)
                
                local HexLabel = Instance.new("TextLabel")
                HexLabel.Parent = HexFrame
                HexLabel.BackgroundTransparency = 1
                HexLabel.Size = UDim2.new(0, 25, 1, 0)
                HexLabel.Font = Enum.Font.GothamBold
                HexLabel.Text = "#"
                HexLabel.TextColor3 = Theme.Text
                HexLabel.TextSize = 12
                
                local HexInput = Instance.new("TextBox")
                HexInput.Name = "Input"
                HexInput.Parent = HexFrame
                HexInput.BackgroundColor3 = Theme.Border
                HexInput.BorderSizePixel = 0
                HexInput.Position = UDim2.new(0, 25, 0, 3)
                HexInput.Size = UDim2.new(1, -25, 0, 24)
                HexInput.Font = Enum.Font.Gotham
                HexInput.Text = string.format("%02X%02X%02X", r, g, b)
                HexInput.TextColor3 = Theme.Text
                HexInput.TextSize = 12
                
                local HexInputCorner = Instance.new("UICorner")
                HexInputCorner.CornerRadius = UDim.new(0, 4)
                HexInputCorner.Parent = HexInput
                
                -- Preview Colors
                local PreviewFrame = Instance.new("Frame")
                PreviewFrame.Name = "PreviewFrame"
                PreviewFrame.Parent = PickerContent
                PreviewFrame.BackgroundTransparency = 1
                PreviewFrame.Position = UDim2.new(0, 0, 0, 155)
                PreviewFrame.Size = UDim2.new(0, 150, 0, 25)
                
                local OldColor = Instance.new("Frame")
                OldColor.Name = "OldColor"
                OldColor.Parent = PreviewFrame
                OldColor.BackgroundColor3 = ColorPicker.Value
                OldColor.BorderSizePixel = 0
                OldColor.Size = UDim2.new(0.5, -2, 1, 0)
                
                local OldCorner = Instance.new("UICorner")
                OldCorner.CornerRadius = UDim.new(0, 4)
                OldCorner.Parent = OldColor
                
                local NewColor = Instance.new("Frame")
                NewColor.Name = "NewColor"
                NewColor.Parent = PreviewFrame
                NewColor.BackgroundColor3 = selectedColor
                NewColor.BorderSizePixel = 0
                NewColor.Position = UDim2.new(0.5, 2, 0, 0)
                NewColor.Size = UDim2.new(0.5, -2, 1, 0)
                
                local NewCorner = Instance.new("UICorner")
                NewCorner.CornerRadius = UDim.new(0, 4)
                NewCorner.Parent = NewColor
                
                -- Buttons
                local ButtonsFrame = Instance.new("Frame")
                ButtonsFrame.Name = "Buttons"
                ButtonsFrame.Parent = PickerContent
                ButtonsFrame.BackgroundTransparency = 1
                ButtonsFrame.Position = UDim2.new(0, 160, 0, 155)
                ButtonsFrame.Size = UDim2.new(1, -160, 0, 25)
                
                local ConfirmButton = Instance.new("TextButton")
                ConfirmButton.Name = "Confirm"
                ConfirmButton.Parent = ButtonsFrame
                ConfirmButton.BackgroundColor3 = Theme.Success
                ConfirmButton.BorderSizePixel = 0
                ConfirmButton.Size = UDim2.new(0.48, 0, 1, 0)
                ConfirmButton.Font = Enum.Font.GothamSemibold
                ConfirmButton.Text = "Confirm"
                ConfirmButton.TextColor3 = Theme.Text
                ConfirmButton.TextSize = 11
                ConfirmButton.AutoButtonColor = false
                
                local ConfirmCorner = Instance.new("UICorner")
                ConfirmCorner.CornerRadius = UDim.new(0, 4)
                ConfirmCorner.Parent = ConfirmButton
                
                local CancelButton = Instance.new("TextButton")
                CancelButton.Name = "Cancel"
                CancelButton.Parent = ButtonsFrame
                CancelButton.BackgroundColor3 = Theme.Error
                CancelButton.BorderSizePixel = 0
                CancelButton.Position = UDim2.new(0.52, 0, 0, 0)
                CancelButton.Size = UDim2.new(0.48, 0, 1, 0)
                CancelButton.Font = Enum.Font.GothamSemibold
                CancelButton.Text = "Cancel"
                CancelButton.TextColor3 = Theme.Text
                CancelButton.TextSize = 11
                CancelButton.AutoButtonColor = false
                
                local CancelCorner = Instance.new("UICorner")
                CancelCorner.CornerRadius = UDim.new(0, 4)
                CancelCorner.Parent = CancelButton
                
                -- Update functions
                local function UpdateColorFromHSV()
                    selectedColor = Color3.fromHSV(hue, sat, val)
                    NewColor.BackgroundColor3 = selectedColor
                    SatValBox.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                    
                    local r, g, b = math.floor(selectedColor.R * 255), math.floor(selectedColor.G * 255), math.floor(selectedColor.B * 255)
                    RInput.Text = tostring(r)
                    GInput.Text = tostring(g)
                    BInput.Text = tostring(b)
                    HexInput.Text = string.format("%02X%02X%02X", r, g, b)
                end
                
                local function UpdateColorFromRGB()
                    local r = math.clamp(tonumber(RInput.Text) or 0, 0, 255)
                    local g = math.clamp(tonumber(GInput.Text) or 0, 0, 255)
                    local b = math.clamp(tonumber(BInput.Text) or 0, 0, 255)
                    
                    selectedColor = Color3.fromRGB(r, g, b)
                    hue, sat, val = Color3.toHSV(selectedColor)
                    
                    NewColor.BackgroundColor3 = selectedColor
                    SatValBox.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                    SatValCursor.Position = UDim2.new(sat, 0, 1 - val, 0)
                    HueCursor.Position = UDim2.new(0.5, 0, hue, 0)
                    HexInput.Text = string.format("%02X%02X%02X", r, g, b)
                end
                
                local function UpdateColorFromHex()
                    local hex = HexInput.Text:gsub("#", "")
                    if #hex == 6 then
                        local r = tonumber(hex:sub(1, 2), 16) or 255
                        local g = tonumber(hex:sub(3, 4), 16) or 255
                        local b = tonumber(hex:sub(5, 6), 16) or 255
                        
                        selectedColor = Color3.fromRGB(r, g, b)
                        hue, sat, val = Color3.toHSV(selectedColor)
                        
                        NewColor.BackgroundColor3 = selectedColor
                        SatValBox.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                        SatValCursor.Position = UDim2.new(sat, 0, 1 - val, 0)
                        HueCursor.Position = UDim2.new(0.5, 0, hue, 0)
                        RInput.Text = tostring(r)
                        GInput.Text = tostring(g)
                        BInput.Text = tostring(b)
                    end
                end
                
                -- Input connections
                RInput.FocusLost:Connect(UpdateColorFromRGB)
                GInput.FocusLost:Connect(UpdateColorFromRGB)
                BInput.FocusLost:Connect(UpdateColorFromRGB)
                HexInput.FocusLost:Connect(UpdateColorFromHex)
                
                -- SatVal dragging
                local draggingSatVal = false
                
                SatValBox.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingSatVal = true
                    end
                end)
                
                SatValBox.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingSatVal = false
                    end
                end)
                
                -- Hue dragging
                local draggingHue = false
                
                HueSlider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingHue = true
                    end
                end)
                
                HueSlider.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingHue = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        if draggingSatVal then
                            local relX = math.clamp((input.Position.X - SatValBox.AbsolutePosition.X) / SatValBox.AbsoluteSize.X, 0, 1)
                            local relY = math.clamp((input.Position.Y - SatValBox.AbsolutePosition.Y) / SatValBox.AbsoluteSize.Y, 0, 1)
                            
                            sat = relX
                            val = 1 - relY
                            
                            SatValCursor.Position = UDim2.new(relX, 0, relY, 0)
                            UpdateColorFromHSV()
                        elseif draggingHue then
                            local relY = math.clamp((input.Position.Y - HueSlider.AbsolutePosition.Y) / HueSlider.AbsoluteSize.Y, 0, 1)
                            
                            hue = relY
                            HueCursor.Position = UDim2.new(0.5, 0, relY, 0)
                            UpdateColorFromHSV()
                        end
                    end
                end)
                
                -- Toggle picker
                ColorPreview.MouseButton1Click:Connect(function()
                    pickerOpen = not pickerOpen
                    if pickerOpen then
                        OldColor.BackgroundColor3 = ColorPicker.Value
                        selectedColor = ColorPicker.Value
                        hue, sat, val = Color3.toHSV(ColorPicker.Value)
                        SatValCursor.Position = UDim2.new(sat, 0, 1 - val, 0)
                        HueCursor.Position = UDim2.new(0.5, 0, hue, 0)
                        UpdateColorFromHSV()
                        CreateTween(PickerFrame, {Size = UDim2.new(1, 0, 0, 230)}):Play()
                    else
                        CreateTween(PickerFrame, {Size = UDim2.new(1, 0, 0, 35)}):Play()
                    end
                end)
                
                -- Confirm button
                ConfirmButton.MouseButton1Click:Connect(function()
                    ColorPicker.Value = selectedColor
                    ColorPreview.BackgroundColor3 = selectedColor
                    pickerOpen = false
                    CreateTween(PickerFrame, {Size = UDim2.new(1, 0, 0, 35)}):Play()
                    
                    SavedData.Colors[uniqueId] = {
                        R = math.floor(selectedColor.R * 255),
                        G = math.floor(selectedColor.G * 255),
                        B = math.floor(selectedColor.B * 255)
                    }
                    SaveConfig(SavedData.LastConfig or DEFAULT_CONFIG)
                    
                    if callback then
                        callback(selectedColor)
                    end
                end)
                
                ConfirmButton.MouseEnter:Connect(function()
                    CreateTween(ConfirmButton, {BackgroundColor3 = Color3.fromRGB(0, 230, 115)}):Play()
                end)
                
                ConfirmButton.MouseLeave:Connect(function()
                    CreateTween(ConfirmButton, {BackgroundColor3 = Theme.Success}):Play()
                end)
                
                -- Cancel button
                CancelButton.MouseButton1Click:Connect(function()
                    selectedColor = ColorPicker.Value
                    hue, sat, val = Color3.toHSV(ColorPicker.Value)
                    pickerOpen = false
                    CreateTween(PickerFrame, {Size = UDim2.new(1, 0, 0, 35)}):Play()
                end)
                
                CancelButton.MouseEnter:Connect(function()
                    CreateTween(CancelButton, {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}):Play()
                end)
                
                CancelButton.MouseLeave:Connect(function()
                    CreateTween(CancelButton, {BackgroundColor3 = Theme.Error}):Play()
                end)
                
                function ColorPicker:Set(color)
                    ColorPicker.Value = color
                    ColorPreview.BackgroundColor3 = color
                    selectedColor = color
                    hue, sat, val = Color3.toHSV(color)
                    
                    SavedData.Colors[uniqueId] = {
                        R = math.floor(color.R * 255),
                        G = math.floor(color.G * 255),
                        B = math.floor(color.B * 255)
                    }
                    SaveConfig(SavedData.LastConfig or DEFAULT_CONFIG)
                    
                    if callback then
                        callback(color)
                    end
                end
                
                -- Initial callback
                if callback then
                    task.spawn(function()
                        callback(ColorPicker.Value)
                    end)
                end
                
                Library.Elements[uniqueId] = ColorPicker
                return ColorPicker
            end
            
            -- Label
            function Section:CreateLabel(text)
                local LabelFrame = Instance.new("TextLabel")
                LabelFrame.Name = "Label"
                LabelFrame.Parent = SectionContent
                LabelFrame.BackgroundTransparency = 1
                LabelFrame.Size = UDim2.new(1, 0, 0, 20)
                LabelFrame.Font = Enum.Font.Gotham
                LabelFrame.Text = text
                LabelFrame.TextColor3 = Theme.TextDark
                LabelFrame.TextSize = 12
                LabelFrame.TextXAlignment = Enum.TextXAlignment.Left
                
                local Label = {}
                
                function Label:Set(newText)
                    LabelFrame.Text = newText
                end
                
                return Label
            end
            
            -- Separator
            function Section:CreateSeparator()
                local Separator = Instance.new("Frame")
                Separator.Name = "Separator"
                Separator.Parent = SectionContent
                Separator.BackgroundColor3 = Theme.Border
                Separator.BorderSizePixel = 0
                Separator.Size = UDim2.new(1, 0, 0, 1)
            end
            
            return Section
        end
        
        return Tab
    end
    
    -- Config Functions
    function Window:SaveConfig(name)
        SavedData.LastConfig = name
        SaveConfig(name)
    end
    
    function Window:LoadConfig(name)
        if LoadConfig(name) then
            SavedData.LastConfig = name
            -- Reload UI to apply config
            Library:Notify("Config Loaded", "Configuration '" .. name .. "' has been loaded. Restart the script to apply all changes.", 3)
            return true
        end
        return false
    end
    
    function Window:GetConfigs()
        return GetConfigs()
    end
    
    function Window:DeleteConfig(name)
        return DeleteConfig(name)
    end
    
    -- Notification System
    function Library:Notify(title, text, duration)
        duration = duration or 3
        
        local NotifGui = Instance.new("ScreenGui")
        NotifGui.Name = "Notification"
        NotifGui.Parent = game.CoreGui
        
        local NotifFrame = Instance.new("Frame")
        NotifFrame.Name = "NotifFrame"
        NotifFrame.Parent = NotifGui
        NotifFrame.BackgroundColor3 = Theme.Secondary
        NotifFrame.BorderSizePixel = 0
        NotifFrame.Position = UDim2.new(1, 10, 0.8, 0)
        NotifFrame.Size = UDim2.new(0, 250, 0, 70)
        
        local NotifCorner = Instance.new("UICorner")
        NotifCorner.CornerRadius = UDim.new(0, 6)
        NotifCorner.Parent = NotifFrame
        
        local NotifStroke = Instance.new("UIStroke")
        NotifStroke.Color = Theme.Accent
        NotifStroke.Thickness = 1
        NotifStroke.Parent = NotifFrame
        
        local NotifTitle = Instance.new("TextLabel")
        NotifTitle.Parent = NotifFrame
        NotifTitle.BackgroundTransparency = 1
        NotifTitle.Position = UDim2.new(0, 10, 0, 5)
        NotifTitle.Size = UDim2.new(1, -20, 0, 25)
        NotifTitle.Font = Enum.Font.GothamBold
        NotifTitle.Text = title
        NotifTitle.TextColor3 = Theme.Accent
        NotifTitle.TextSize = 14
        NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        local NotifText = Instance.new("TextLabel")
        NotifText.Parent = NotifFrame
        NotifText.BackgroundTransparency = 1
        NotifText.Position = UDim2.new(0, 10, 0, 30)
        NotifText.Size = UDim2.new(1, -20, 0, 35)
        NotifText.Font = Enum.Font.Gotham
        NotifText.Text = text
        NotifText.TextColor3 = Theme.Text
        NotifText.TextSize = 12
        NotifText.TextXAlignment = Enum.TextXAlignment.Left
        NotifText.TextWrapped = true
        
        -- Animate in
        CreateTween(NotifFrame, {Position = UDim2.new(1, -260, 0.8, 0)}):Play()
        
        task.wait(duration)
        
        -- Animate out
        CreateTween(NotifFrame, {Position = UDim2.new(1, 10, 0.8, 0)}):Play()
        task.wait(AnimationSpeed)
        NotifGui:Destroy()
    end
    
    -- Initial animation
    MainFrame.Size = UDim2.new(0, 600, 0, 0)
    CreateTween(MainFrame, {Size = UDim2.new(0, 600, 0, 450)}):Play()
    
    table.insert(Library.Windows, Window)
    return Window
end

return Library
