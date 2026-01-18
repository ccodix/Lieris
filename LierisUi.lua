--[[
    Lieris UI Library v6.0
    Modern Design Inspired by LierisDm
    Clean, Dark Theme with Indigo Accent
    
    Toggle Key: H
]]

local Lieris = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer

-- Colors (Modern Dark Theme with Indigo Accent)
local Colors = {
    Background = Color3.fromRGB(15, 15, 20),
    Secondary = Color3.fromRGB(22, 22, 30),
    Accent = Color3.fromRGB(99, 102, 241),
    AccentHover = Color3.fromRGB(79, 82, 200),
    AccentDark = Color3.fromRGB(67, 56, 202),
    Text = Color3.fromRGB(250, 250, 255),
    TextDark = Color3.fromRGB(140, 140, 160),
    Border = Color3.fromRGB(45, 45, 55),
    Success = Color3.fromRGB(34, 197, 94),
    Error = Color3.fromRGB(239, 68, 68),
    Warning = Color3.fromRGB(234, 179, 8)
}

-- Icon Assets
local Icons = {
    Search = "rbxassetid://3926305904",
    Star = "rbxassetid://3926307971",
    Gear = "rbxassetid://3926307971",
    Shield = "rbxassetid://3926307971",
    Heart = "rbxassetid://3926305904",
    Crown = "rbxassetid://3926307971",
    Fire = "rbxassetid://3926305904",
    Lightning = "rbxassetid://3926305904",
    Eye = "rbxassetid://3926305904",
    Lock = "rbxassetid://3926307971",
    Unlock = "rbxassetid://3926307971",
    Home = "rbxassetid://3926307971",
    User = "rbxassetid://3926307971",
    Users = "rbxassetid://3926307971",
    Settings = "rbxassetid://3926307971",
    Info = "rbxassetid://3926305904",
    Warning = "rbxassetid://3926305904",
    Error = "rbxassetid://3926305904",
    Check = "rbxassetid://3926305904",
    Close = "rbxassetid://3926305904",
    Plus = "rbxassetid://3926305904",
    Minus = "rbxassetid://3926305904",
    ArrowRight = "rbxassetid://3926305904",
    ArrowLeft = "rbxassetid://3926305904",
    ArrowUp = "rbxassetid://3926305904",
    ArrowDown = "rbxassetid://3926305904",
    Refresh = "rbxassetid://3926307971",
    Download = "rbxassetid://3926305904",
    Upload = "rbxassetid://3926305904",
    Folder = "rbxassetid://3926307971",
    File = "rbxassetid://3926307971",
    Copy = "rbxassetid://3926305904",
    Paste = "rbxassetid://3926305904",
    Trash = "rbxassetid://3926307971",
    Edit = "rbxassetid://3926305904",
    Save = "rbxassetid://3926305904",
    Play = "rbxassetid://3926305904",
    Pause = "rbxassetid://3926305904",
    Stop = "rbxassetid://3926305904",
    Music = "rbxassetid://3926305904",
    Volume = "rbxassetid://3926305904",
    Mute = "rbxassetid://3926305904",
    Camera = "rbxassetid://3926305904",
    Image = "rbxassetid://3926305904",
    Video = "rbxassetid://3926305904",
    Map = "rbxassetid://3926307971",
    Location = "rbxassetid://3926307971",
    Calendar = "rbxassetid://3926307971",
    Clock = "rbxassetid://3926305904",
    Bell = "rbxassetid://3926305904",
    Mail = "rbxassetid://3926305904",
    Phone = "rbxassetid://3926307971",
    Chat = "rbxassetid://3926305904",
    Send = "rbxassetid://3926305904",
    Link = "rbxassetid://3926305904",
    Globe = "rbxassetid://3926307971",
    Wifi = "rbxassetid://3926305904",
    Bluetooth = "rbxassetid://3926305904",
    Battery = "rbxassetid://3926305904",
    Power = "rbxassetid://3926305904",
    Sun = "rbxassetid://3926305904",
    Moon = "rbxassetid://3926305904",
    Cloud = "rbxassetid://3926305904",
    Rain = "rbxassetid://3926305904",
    Snow = "rbxassetid://3926305904",
    Wind = "rbxassetid://3926305904",
    Thermometer = "rbxassetid://3926305904",
    Compass = "rbxassetid://3926307971",
    Target = "rbxassetid://3926307971",
    Crosshair = "rbxassetid://3926307971",
    Aim = "rbxassetid://3926307971",
    Sword = "rbxassetid://3926307971",
    Magic = "rbxassetid://3926307971",
    Potion = "rbxassetid://3926307971",
    Chest = "rbxassetid://3926307971",
    Key = "rbxassetid://3926307971",
    Coin = "rbxassetid://3926307971",
    Gem = "rbxassetid://3926307971",
    Trophy = "rbxassetid://3926307971",
    Medal = "rbxassetid://3926307971",
    Flag = "rbxassetid://3926307971",
    Rocket = "rbxassetid://3926305904",
    Robot = "rbxassetid://3926307971",
    Ghost = "rbxassetid://3926307971",
    Skull = "rbxassetid://3926307971",
    Bomb = "rbxassetid://3926307971",
    Gift = "rbxassetid://3926307971",
    Tag = "rbxassetid://3926307971",
    Bookmark = "rbxassetid://3926307971",
    Pin = "rbxassetid://3926307971",
    Filter = "rbxassetid://3926307971",
    Sort = "rbxassetid://3926305904",
    List = "rbxassetid://3926307971",
    Grid = "rbxassetid://3926307971",
    Menu = "rbxassetid://3926305904",
    MoreVertical = "rbxassetid://3926305904",
    MoreHorizontal = "rbxassetid://3926305904"
}

-- Utility functions
local function CreateTween(instance, time, properties, style, direction)
    style = style or Enum.EasingStyle.Quart
    direction = direction or Enum.EasingDirection.Out
    return TweenService:Create(instance, TweenInfo.new(time, style, direction), properties)
end

local function Ripple(button)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundColor3 = Color3.new(1, 1, 1)
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel = 0
    ripple.ZIndex = button.ZIndex + 1
    ripple.Parent = button
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    local mouse = UserInputService:GetMouseLocation()
    local buttonPos = button.AbsolutePosition
    local relativeX = mouse.X - buttonPos.X
    local relativeY = mouse.Y - buttonPos.Y - 36
    
    ripple.Position = UDim2.new(0, relativeX, 0, relativeY)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    
    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    
    CreateTween(ripple, 0.5, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        Position = UDim2.new(0, relativeX - maxSize/2, 0, relativeY - maxSize/2),
        BackgroundTransparency = 1
    }):Play()
    
    task.delay(0.5, function()
        ripple:Destroy()
    end)
end

-- Main Library Function
function Lieris:CreateWindow(config)
    config = config or {}
    local title = config.Title or "Lieris UI"
    local size = config.Size or UDim2.new(0, 650, 0, 480)
    local toggleKey = config.ToggleKey or Enum.KeyCode.H
    
    local Window = {}
    local Tabs = {}
    local CurrentTab = nil
    local Minimized = false
    local GUI = {}
    
    -- Create ScreenGui
    GUI.ScreenGui = Instance.new("ScreenGui")
    GUI.ScreenGui.Name = "LierisUI_" .. HttpService:GenerateGUID(false)
    GUI.ScreenGui.ResetOnSpawn = false
    GUI.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Try to parent to CoreGui, fallback to PlayerGui
    local success, err = pcall(function()
        GUI.ScreenGui.Parent = CoreGui
    end)
    if not success then
        GUI.ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    end
    
    -- Main Frame
    GUI.MainFrame = Instance.new("Frame")
    GUI.MainFrame.Name = "MainFrame"
    GUI.MainFrame.Size = size
    GUI.MainFrame.Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2)
    GUI.MainFrame.BackgroundColor3 = Colors.Background
    GUI.MainFrame.BorderSizePixel = 0
    GUI.MainFrame.ClipsDescendants = true
    GUI.MainFrame.Parent = GUI.ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = GUI.MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Colors.Accent
    MainStroke.Thickness = 1.5
    MainStroke.Transparency = 0.5
    MainStroke.Parent = GUI.MainFrame
    
    -- Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 50, 1, 50)
    Shadow.Position = UDim2.new(0, -25, 0, -25)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.ZIndex = -1
    Shadow.Parent = GUI.MainFrame
    
    -- Title Bar
    GUI.TitleBar = Instance.new("Frame")
    GUI.TitleBar.Name = "TitleBar"
    GUI.TitleBar.Size = UDim2.new(1, 0, 0, 45)
    GUI.TitleBar.BackgroundColor3 = Colors.Secondary
    GUI.TitleBar.BorderSizePixel = 0
    GUI.TitleBar.Parent = GUI.MainFrame
    
    local TitleBarCorner = Instance.new("UICorner")
    TitleBarCorner.CornerRadius = UDim.new(0, 12)
    TitleBarCorner.Parent = GUI.TitleBar
    
    -- Fix bottom corners of title bar
    local TitleBarFix = Instance.new("Frame")
    TitleBarFix.Name = "CornerFix"
    TitleBarFix.Size = UDim2.new(1, 0, 0, 15)
    TitleBarFix.Position = UDim2.new(0, 0, 1, -15)
    TitleBarFix.BackgroundColor3 = Colors.Secondary
    TitleBarFix.BorderSizePixel = 0
    TitleBarFix.Parent = GUI.TitleBar
    
    -- Logo Icon
    local LogoIcon = Instance.new("Frame")
    LogoIcon.Name = "LogoIcon"
    LogoIcon.Size = UDim2.new(0, 28, 0, 28)
    LogoIcon.Position = UDim2.new(0, 12, 0.5, -14)
    LogoIcon.BackgroundColor3 = Colors.Accent
    LogoIcon.BorderSizePixel = 0
    LogoIcon.Parent = GUI.TitleBar
    
    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(0, 6)
    LogoCorner.Parent = LogoIcon
    
    local LogoText = Instance.new("TextLabel")
    LogoText.Name = "LogoText"
    LogoText.Size = UDim2.new(1, 0, 1, 0)
    LogoText.BackgroundTransparency = 1
    LogoText.Text = "L"
    LogoText.TextColor3 = Colors.Text
    LogoText.TextSize = 18
    LogoText.Font = Enum.Font.GothamBlack
    LogoText.Parent = LogoIcon
    
    -- Title Label
    GUI.TitleLabel = Instance.new("TextLabel")
    GUI.TitleLabel.Name = "TitleLabel"
    GUI.TitleLabel.Size = UDim2.new(1, -150, 1, 0)
    GUI.TitleLabel.Position = UDim2.new(0, 50, 0, 0)
    GUI.TitleLabel.BackgroundTransparency = 1
    GUI.TitleLabel.Text = title
    GUI.TitleLabel.TextColor3 = Colors.Text
    GUI.TitleLabel.TextSize = 18
    GUI.TitleLabel.Font = Enum.Font.GothamBold
    GUI.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    GUI.TitleLabel.Parent = GUI.TitleBar
    
    -- Close Button
    GUI.CloseButton = Instance.new("TextButton")
    GUI.CloseButton.Name = "CloseButton"
    GUI.CloseButton.Size = UDim2.new(0, 32, 0, 32)
    GUI.CloseButton.Position = UDim2.new(1, -42, 0.5, -16)
    GUI.CloseButton.BackgroundColor3 = Colors.Error
    GUI.CloseButton.Text = "X"
    GUI.CloseButton.TextColor3 = Colors.Text
    GUI.CloseButton.TextSize = 14
    GUI.CloseButton.Font = Enum.Font.GothamBold
    GUI.CloseButton.BorderSizePixel = 0
    GUI.CloseButton.AutoButtonColor = false
    GUI.CloseButton.Parent = GUI.TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = GUI.CloseButton
    
    GUI.CloseButton.MouseEnter:Connect(function()
        CreateTween(GUI.CloseButton, 0.15, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
    end)
    GUI.CloseButton.MouseLeave:Connect(function()
        CreateTween(GUI.CloseButton, 0.15, {BackgroundColor3 = Colors.Error}):Play()
    end)
    GUI.CloseButton.MouseButton1Click:Connect(function()
        GUI.ScreenGui:Destroy()
    end)
    
    -- Minimize Button
    GUI.MinimizeButton = Instance.new("TextButton")
    GUI.MinimizeButton.Name = "MinimizeButton"
    GUI.MinimizeButton.Size = UDim2.new(0, 32, 0, 32)
    GUI.MinimizeButton.Position = UDim2.new(1, -82, 0.5, -16)
    GUI.MinimizeButton.BackgroundColor3 = Colors.Accent
    GUI.MinimizeButton.Text = "-"
    GUI.MinimizeButton.TextColor3 = Colors.Text
    GUI.MinimizeButton.TextSize = 20
    GUI.MinimizeButton.Font = Enum.Font.GothamBold
    GUI.MinimizeButton.BorderSizePixel = 0
    GUI.MinimizeButton.AutoButtonColor = false
    GUI.MinimizeButton.Parent = GUI.TitleBar
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 8)
    MinCorner.Parent = GUI.MinimizeButton
    
    GUI.MinimizeButton.MouseEnter:Connect(function()
        CreateTween(GUI.MinimizeButton, 0.15, {BackgroundColor3 = Colors.AccentHover}):Play()
    end)
    GUI.MinimizeButton.MouseLeave:Connect(function()
        CreateTween(GUI.MinimizeButton, 0.15, {BackgroundColor3 = Colors.Accent}):Play()
    end)
    GUI.MinimizeButton.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            CreateTween(GUI.MainFrame, 0.3, {Size = UDim2.new(0, size.X.Offset, 0, 45)}):Play()
            GUI.MinimizeButton.Text = "+"
        else
            CreateTween(GUI.MainFrame, 0.3, {Size = size}):Play()
            GUI.MinimizeButton.Text = "-"
        end
    end)
    
    -- Tab Container (Left Side)
    GUI.TabContainer = Instance.new("Frame")
    GUI.TabContainer.Name = "TabContainer"
    GUI.TabContainer.Size = UDim2.new(0, 140, 1, -55)
    GUI.TabContainer.Position = UDim2.new(0, 5, 0, 50)
    GUI.TabContainer.BackgroundColor3 = Colors.Secondary
    GUI.TabContainer.BorderSizePixel = 0
    GUI.TabContainer.Parent = GUI.MainFrame
    
    local TabContainerCorner = Instance.new("UICorner")
    TabContainerCorner.CornerRadius = UDim.new(0, 10)
    TabContainerCorner.Parent = GUI.TabContainer
    
    -- Tab Scroll Frame
    GUI.TabScroll = Instance.new("ScrollingFrame")
    GUI.TabScroll.Name = "TabScroll"
    GUI.TabScroll.Size = UDim2.new(1, -10, 1, -10)
    GUI.TabScroll.Position = UDim2.new(0, 5, 0, 5)
    GUI.TabScroll.BackgroundTransparency = 1
    GUI.TabScroll.ScrollBarThickness = 3
    GUI.TabScroll.ScrollBarImageColor3 = Colors.Accent
    GUI.TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    GUI.TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    GUI.TabScroll.Parent = GUI.TabContainer
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.Parent = GUI.TabScroll
    
    -- Content Container (Right Side)
    GUI.ContentContainer = Instance.new("Frame")
    GUI.ContentContainer.Name = "ContentContainer"
    GUI.ContentContainer.Size = UDim2.new(1, -160, 1, -55)
    GUI.ContentContainer.Position = UDim2.new(0, 150, 0, 50)
    GUI.ContentContainer.BackgroundTransparency = 1
    GUI.ContentContainer.Parent = GUI.MainFrame
    
    -- Dragging
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    GUI.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = GUI.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            GUI.MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Toggle Key
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == toggleKey then
            GUI.MainFrame.Visible = not GUI.MainFrame.Visible
        end
    end)
    
    -- Open animation
    GUI.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    GUI.MainFrame.BackgroundTransparency = 1
    
    task.spawn(function()
        task.wait(0.05)
        CreateTween(GUI.MainFrame, 0.4, {Size = size, BackgroundTransparency = 0}, Enum.EasingStyle.Back):Play()
    end)
    
    -- Create Tab Function
    function Window:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or "Tab"
        local tabIcon = tabConfig.Icon
        
        local Tab = {}
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Button"
        TabButton.Size = UDim2.new(1, 0, 0, 38)
        TabButton.BackgroundColor3 = Colors.Background
        TabButton.Text = ""
        TabButton.BorderSizePixel = 0
        TabButton.AutoButtonColor = false
        TabButton.Parent = GUI.TabScroll
        
        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 8)
        TabBtnCorner.Parent = TabButton
        
        -- Tab Icon
        if tabIcon and Icons[tabIcon] then
            local IconImage = Instance.new("ImageLabel")
            IconImage.Name = "Icon"
            IconImage.Size = UDim2.new(0, 18, 0, 18)
            IconImage.Position = UDim2.new(0, 10, 0.5, -9)
            IconImage.BackgroundTransparency = 1
            IconImage.Image = Icons[tabIcon]
            IconImage.ImageColor3 = Colors.TextDark
            IconImage.Parent = TabButton
        end
        
        -- Tab Label
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Name = "Label"
        TabLabel.Size = UDim2.new(1, tabIcon and -40 or -20, 1, 0)
        TabLabel.Position = UDim2.new(0, tabIcon and 35 or 10, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = tabName
        TabLabel.TextColor3 = Colors.TextDark
        TabLabel.TextSize = 13
        TabLabel.Font = Enum.Font.GothamMedium
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.TextTruncate = Enum.TextTruncate.AtEnd
        TabLabel.Parent = TabButton
        
        -- Tab Content Frame
        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Name = tabName .. "Content"
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.BackgroundTransparency = 1
        TabFrame.ScrollBarThickness = 4
        TabFrame.ScrollBarImageColor3 = Colors.Accent
        TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabFrame.Visible = false
        TabFrame.Parent = GUI.ContentContainer
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Padding = UDim.new(0, 8)
        ContentLayout.Parent = TabFrame
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingTop = UDim.new(0, 5)
        ContentPadding.PaddingBottom = UDim.new(0, 5)
        ContentPadding.PaddingLeft = UDim.new(0, 5)
        ContentPadding.PaddingRight = UDim.new(0, 5)
        ContentPadding.Parent = TabFrame
        
        Tabs[tabName] = {
            Button = TabButton,
            Frame = TabFrame,
            Label = TabLabel,
            Icon = TabButton:FindFirstChild("Icon")
        }
        
        -- Tab Button Click
        TabButton.MouseEnter:Connect(function()
            if CurrentTab ~= tabName then
                CreateTween(TabButton, 0.15, {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}):Play()
            end
        end)
        TabButton.MouseLeave:Connect(function()
            if CurrentTab ~= tabName then
                CreateTween(TabButton, 0.15, {BackgroundColor3 = Colors.Background}):Play()
            end
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            if CurrentTab then
                local oldTab = Tabs[CurrentTab]
                oldTab.Frame.Visible = false
                CreateTween(oldTab.Button, 0.2, {BackgroundColor3 = Colors.Background}):Play()
                CreateTween(oldTab.Label, 0.2, {TextColor3 = Colors.TextDark}):Play()
                if oldTab.Icon then
                    CreateTween(oldTab.Icon, 0.2, {ImageColor3 = Colors.TextDark}):Play()
                end
            end
            
            CurrentTab = tabName
            TabFrame.Visible = true
            CreateTween(TabButton, 0.2, {BackgroundColor3 = Colors.Accent}):Play()
            CreateTween(TabLabel, 0.2, {TextColor3 = Colors.Text}):Play()
            if Tabs[tabName].Icon then
                CreateTween(Tabs[tabName].Icon, 0.2, {ImageColor3 = Colors.Text}):Play()
            end
        end)
        
        -- Auto-select first tab
        if not CurrentTab then
            TabButton.MouseButton1Click:Fire()
        end
        
        -- Section Function
        function Tab:CreateSection(sectionName)
            local Section = {}
            
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = sectionName or "Section"
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            SectionFrame.BackgroundColor3 = Colors.Secondary
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Parent = TabFrame
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 10)
            SectionCorner.Parent = SectionFrame
            
            -- Section Header
            local SectionHeader = Instance.new("Frame")
            SectionHeader.Name = "Header"
            SectionHeader.Size = UDim2.new(1, 0, 0, 32)
            SectionHeader.BackgroundTransparency = 1
            SectionHeader.Parent = SectionFrame
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.Size = UDim2.new(1, -20, 1, 0)
            SectionTitle.Position = UDim2.new(0, 14, 0, 0)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = sectionName or "Section"
            SectionTitle.TextColor3 = Colors.Accent
            SectionTitle.TextSize = 14
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionHeader
            
            -- Separator
            local Separator = Instance.new("Frame")
            Separator.Name = "Separator"
            Separator.Size = UDim2.new(1, -20, 0, 1)
            Separator.Position = UDim2.new(0, 10, 1, -1)
            Separator.BackgroundColor3 = Colors.Border
            Separator.BackgroundTransparency = 0.5
            Separator.BorderSizePixel = 0
            Separator.Parent = SectionHeader
            
            -- Section Content
            local SectionContent = Instance.new("Frame")
            SectionContent.Name = "Content"
            SectionContent.Size = UDim2.new(1, -10, 0, 0)
            SectionContent.Position = UDim2.new(0, 5, 0, 36)
            SectionContent.AutomaticSize = Enum.AutomaticSize.Y
            SectionContent.BackgroundTransparency = 1
            SectionContent.Parent = SectionFrame
            
            local ContentLayout = Instance.new("UIListLayout")
            ContentLayout.Padding = UDim.new(0, 6)
            ContentLayout.Parent = SectionContent
            
            local ContentPadding = Instance.new("UIPadding")
            ContentPadding.PaddingBottom = UDim.new(0, 10)
            ContentPadding.Parent = SectionContent
            
            -- Toggle
            function Section:CreateToggle(toggleConfig)
                toggleConfig = toggleConfig or {}
                local toggleName = toggleConfig.Name or "Toggle"
                local toggleDefault = toggleConfig.Default or false
                local toggleCallback = toggleConfig.Callback or function() end
                
                local enabled = toggleDefault
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = toggleName
                ToggleFrame.Size = UDim2.new(1, 0, 0, 42)
                ToggleFrame.BackgroundColor3 = Colors.Background
                ToggleFrame.BorderSizePixel = 0
                ToggleFrame.Parent = SectionContent
                
                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 10)
                ToggleCorner.Parent = ToggleFrame
                
                -- Hover effect
                ToggleFrame.MouseEnter:Connect(function()
                    CreateTween(ToggleFrame, 0.15, {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}):Play()
                end)
                ToggleFrame.MouseLeave:Connect(function()
                    CreateTween(ToggleFrame, 0.15, {BackgroundColor3 = Colors.Background}):Play()
                end)
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Name = "Label"
                ToggleLabel.Size = UDim2.new(1, -70, 1, 0)
                ToggleLabel.Position = UDim2.new(0, 14, 0, 0)
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Text = toggleName
                ToggleLabel.TextColor3 = Colors.Text
                ToggleLabel.TextSize = 14
                ToggleLabel.Font = Enum.Font.GothamMedium
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleFrame
                
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Name = "Button"
                ToggleButton.Size = UDim2.new(0, 50, 0, 26)
                ToggleButton.Position = UDim2.new(1, -60, 0.5, -13)
                ToggleButton.BackgroundColor3 = enabled and Colors.Accent or Colors.Border
                ToggleButton.Text = ""
                ToggleButton.BorderSizePixel = 0
                ToggleButton.AutoButtonColor = false
                ToggleButton.Parent = ToggleFrame
                
                local ToggleBtnCorner = Instance.new("UICorner")
                ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
                ToggleBtnCorner.Parent = ToggleButton
                
                local ToggleCircle = Instance.new("Frame")
                ToggleCircle.Name = "Circle"
                ToggleCircle.Size = UDim2.new(0, 20, 0, 20)
                ToggleCircle.Position = enabled and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
                ToggleCircle.BackgroundColor3 = Colors.Text
                ToggleCircle.BorderSizePixel = 0
                ToggleCircle.Parent = ToggleButton
                
                local CircleCorner = Instance.new("UICorner")
                CircleCorner.CornerRadius = UDim.new(1, 0)
                CircleCorner.Parent = ToggleCircle
                
                ToggleButton.MouseButton1Click:Connect(function()
                    enabled = not enabled
                    local targetPos = enabled and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
                    local targetColor = enabled and Colors.Accent or Colors.Border
                    
                    CreateTween(ToggleCircle, 0.2, {Position = targetPos}, Enum.EasingStyle.Quart):Play()
                    CreateTween(ToggleButton, 0.2, {BackgroundColor3 = targetColor}):Play()
                    
                    pcall(toggleCallback, enabled)
                end)
                
                -- Initial callback
                if toggleDefault then
                    pcall(toggleCallback, toggleDefault)
                end
                
                return {
                    Set = function(value)
                        enabled = value
                        local targetPos = enabled and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
                        local targetColor = enabled and Colors.Accent or Colors.Border
                        ToggleCircle.Position = targetPos
                        ToggleButton.BackgroundColor3 = targetColor
                        pcall(toggleCallback, enabled)
                    end,
                    Get = function()
                        return enabled
                    end
                }
            end
            
            -- Button
            function Section:CreateButton(buttonConfig)
                buttonConfig = buttonConfig or {}
                local buttonName = buttonConfig.Name or "Button"
                local buttonCallback = buttonConfig.Callback or function() end
                
                local Button = Instance.new("TextButton")
                Button.Name = buttonName
                Button.Size = UDim2.new(1, 0, 0, 42)
                Button.BackgroundColor3 = Colors.Accent
                Button.Text = buttonName
                Button.TextColor3 = Colors.Text
                Button.TextSize = 14
                Button.Font = Enum.Font.GothamBold
                Button.BorderSizePixel = 0
                Button.AutoButtonColor = false
                Button.ClipsDescendants = true
                Button.Parent = SectionContent
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 10)
                ButtonCorner.Parent = Button
                
                Button.MouseEnter:Connect(function()
                    CreateTween(Button, 0.15, {BackgroundColor3 = Colors.AccentHover}):Play()
                end)
                Button.MouseLeave:Connect(function()
                    CreateTween(Button, 0.15, {BackgroundColor3 = Colors.Accent}):Play()
                end)
                
                Button.MouseButton1Click:Connect(function()
                    Ripple(Button)
                    -- Press animation
                    CreateTween(Button, 0.05, {Size = UDim2.new(1, -6, 0, 40)}):Play()
                    task.wait(0.05)
                    CreateTween(Button, 0.1, {Size = UDim2.new(1, 0, 0, 42)}):Play()
                    pcall(buttonCallback)
                end)
                
                return Button
            end
            
            -- Slider
            function Section:CreateSlider(sliderConfig)
                sliderConfig = sliderConfig or {}
                local sliderName = sliderConfig.Name or "Slider"
                local sliderMin = sliderConfig.Min or 0
                local sliderMax = sliderConfig.Max or 100
                local sliderDefault = sliderConfig.Default or sliderMin
                local sliderCallback = sliderConfig.Callback or function() end
                
                local value = sliderDefault
                
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = sliderName
                SliderFrame.Size = UDim2.new(1, 0, 0, 60)
                SliderFrame.BackgroundColor3 = Colors.Background
                SliderFrame.BorderSizePixel = 0
                SliderFrame.Parent = SectionContent
                
                local SliderCorner = Instance.new("UICorner")
                SliderCorner.CornerRadius = UDim.new(0, 10)
                SliderCorner.Parent = SliderFrame
                
                -- Hover effect
                SliderFrame.MouseEnter:Connect(function()
                    CreateTween(SliderFrame, 0.15, {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}):Play()
                end)
                SliderFrame.MouseLeave:Connect(function()
                    CreateTween(SliderFrame, 0.15, {BackgroundColor3 = Colors.Background}):Play()
                end)
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Name = "Label"
                SliderLabel.Size = UDim2.new(1, -90, 0, 24)
                SliderLabel.Position = UDim2.new(0, 14, 0, 6)
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Text = sliderName
                SliderLabel.TextColor3 = Colors.Text
                SliderLabel.TextSize = 14
                SliderLabel.Font = Enum.Font.GothamMedium
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = SliderFrame
                
                -- Value Display
                local ValueBg = Instance.new("Frame")
                ValueBg.Name = "ValueBg"
                ValueBg.Size = UDim2.new(0, 55, 0, 22)
                ValueBg.Position = UDim2.new(1, -65, 0, 6)
                ValueBg.BackgroundColor3 = Colors.Secondary
                ValueBg.BorderSizePixel = 0
                ValueBg.Parent = SliderFrame
                
                local ValueBgCorner = Instance.new("UICorner")
                ValueBgCorner.CornerRadius = UDim.new(0, 5)
                ValueBgCorner.Parent = ValueBg
                
                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Name = "Value"
                ValueLabel.Size = UDim2.new(1, 0, 1, 0)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Text = tostring(value)
                ValueLabel.TextColor3 = Colors.Accent
                ValueLabel.TextSize = 12
                ValueLabel.Font = Enum.Font.GothamBold
                ValueLabel.Parent = ValueBg
                
                -- Slider Track
                local SliderBg = Instance.new("Frame")
                SliderBg.Name = "Track"
                SliderBg.Size = UDim2.new(1, -24, 0, 6)
                SliderBg.Position = UDim2.new(0, 12, 0, 38)
                SliderBg.BackgroundColor3 = Colors.Border
                SliderBg.BorderSizePixel = 0
                SliderBg.Parent = SliderFrame
                
                local TrackCorner = Instance.new("UICorner")
                TrackCorner.CornerRadius = UDim.new(1, 0)
                TrackCorner.Parent = SliderBg
                
                -- Slider Fill
                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "Fill"
                SliderFill.Size = UDim2.new((value - sliderMin) / (sliderMax - sliderMin), 0, 1, 0)
                SliderFill.BackgroundColor3 = Colors.Accent
                SliderFill.BorderSizePixel = 0
                SliderFill.Parent = SliderBg
                
                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = SliderFill
                
                -- Slider Knob
                local SliderKnob = Instance.new("Frame")
                SliderKnob.Name = "Knob"
                SliderKnob.Size = UDim2.new(0, 14, 0, 14)
                SliderKnob.Position = UDim2.new((value - sliderMin) / (sliderMax - sliderMin), -7, 0.5, -7)
                SliderKnob.BackgroundColor3 = Colors.Text
                SliderKnob.BorderSizePixel = 0
                SliderKnob.ZIndex = 2
                SliderKnob.Parent = SliderBg
                
                local KnobCorner = Instance.new("UICorner")
                KnobCorner.CornerRadius = UDim.new(1, 0)
                KnobCorner.Parent = SliderKnob
                
                -- Slider Button (for input)
                local SliderButton = Instance.new("TextButton")
                SliderButton.Name = "SliderInput"
                SliderButton.Size = UDim2.new(1, 0, 1, 10)
                SliderButton.Position = UDim2.new(0, 0, 0, -5)
                SliderButton.BackgroundTransparency = 1
                SliderButton.Text = ""
                SliderButton.ZIndex = 3
                SliderButton.Parent = SliderBg
                
                local dragging = false
                
                local function UpdateSlider(input)
                    local pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
                    value = math.floor(sliderMin + (sliderMax - sliderMin) * pos)
                    
                    CreateTween(SliderFill, 0.08, {Size = UDim2.new(pos, 0, 1, 0)}):Play()
                    CreateTween(SliderKnob, 0.08, {Position = UDim2.new(pos, -7, 0.5, -7)}):Play()
                    ValueLabel.Text = tostring(value)
                    
                    pcall(sliderCallback, value)
                end
                
                SliderButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        CreateTween(SliderKnob, 0.15, {Size = UDim2.new(0, 16, 0, 16), BackgroundColor3 = Colors.Accent}):Play()
                        UpdateSlider(input)
                    end
                end)
                
                SliderButton.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                        CreateTween(SliderKnob, 0.15, {Size = UDim2.new(0, 14, 0, 14), BackgroundColor3 = Colors.Text}):Play()
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateSlider(input)
                    end
                end)
                
                -- Initial callback
                pcall(sliderCallback, value)
                
                return {
                    Set = function(newValue)
                        value = math.clamp(newValue, sliderMin, sliderMax)
                        local pos = (value - sliderMin) / (sliderMax - sliderMin)
                        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                        SliderKnob.Position = UDim2.new(pos, -7, 0.5, -7)
                        ValueLabel.Text = tostring(value)
                        pcall(sliderCallback, value)
                    end,
                    Get = function()
                        return value
                    end
                }
            end
            
            -- Input (TextBox)
            function Section:CreateInput(inputConfig)
                inputConfig = inputConfig or {}
                local inputName = inputConfig.Name or "Input"
                local inputPlaceholder = inputConfig.Placeholder or "Enter text..."
                local inputDefault = inputConfig.Default or ""
                local inputCallback = inputConfig.Callback or function() end
                
                local InputFrame = Instance.new("Frame")
                InputFrame.Name = inputName
                InputFrame.Size = UDim2.new(1, 0, 0, 70)
                InputFrame.BackgroundColor3 = Colors.Background
                InputFrame.BorderSizePixel = 0
                InputFrame.Parent = SectionContent
                
                local InputCorner = Instance.new("UICorner")
                InputCorner.CornerRadius = UDim.new(0, 10)
                InputCorner.Parent = InputFrame
                
                local InputLabel = Instance.new("TextLabel")
                InputLabel.Name = "Label"
                InputLabel.Size = UDim2.new(1, -20, 0, 24)
                InputLabel.Position = UDim2.new(0, 14, 0, 6)
                InputLabel.BackgroundTransparency = 1
                InputLabel.Text = inputName
                InputLabel.TextColor3 = Colors.Text
                InputLabel.TextSize = 14
                InputLabel.Font = Enum.Font.GothamMedium
                InputLabel.TextXAlignment = Enum.TextXAlignment.Left
                InputLabel.Parent = InputFrame
                
                local InputBoxFrame = Instance.new("Frame")
                InputBoxFrame.Name = "InputBoxFrame"
                InputBoxFrame.Size = UDim2.new(1, -24, 0, 32)
                InputBoxFrame.Position = UDim2.new(0, 12, 0, 32)
                InputBoxFrame.BackgroundColor3 = Colors.Secondary
                InputBoxFrame.BorderSizePixel = 0
                InputBoxFrame.Parent = InputFrame
                
                local InputBoxCorner = Instance.new("UICorner")
                InputBoxCorner.CornerRadius = UDim.new(0, 8)
                InputBoxCorner.Parent = InputBoxFrame
                
                local InputBoxStroke = Instance.new("UIStroke")
                InputBoxStroke.Color = Colors.Border
                InputBoxStroke.Thickness = 1
                InputBoxStroke.Parent = InputBoxFrame
                
                local InputBox = Instance.new("TextBox")
                InputBox.Name = "TextBox"
                InputBox.Size = UDim2.new(1, -16, 1, 0)
                InputBox.Position = UDim2.new(0, 8, 0, 0)
                InputBox.BackgroundTransparency = 1
                InputBox.Text = inputDefault
                InputBox.PlaceholderText = inputPlaceholder
                InputBox.PlaceholderColor3 = Colors.TextDark
                InputBox.TextColor3 = Colors.Text
                InputBox.TextSize = 13
                InputBox.Font = Enum.Font.Gotham
                InputBox.TextXAlignment = Enum.TextXAlignment.Left
                InputBox.ClearTextOnFocus = false
                InputBox.Parent = InputBoxFrame
                
                InputBox.Focused:Connect(function()
                    CreateTween(InputBoxStroke, 0.15, {Color = Colors.Accent}):Play()
                end)
                
                InputBox.FocusLost:Connect(function(enterPressed)
                    CreateTween(InputBoxStroke, 0.15, {Color = Colors.Border}):Play()
                    pcall(inputCallback, InputBox.Text)
                end)
                
                return {
                    Set = function(text)
                        InputBox.Text = text
                        pcall(inputCallback, text)
                    end,
                    Get = function()
                        return InputBox.Text
                    end
                }
            end
            
            -- Dropdown
            function Section:CreateDropdown(dropdownConfig)
                dropdownConfig = dropdownConfig or {}
                local dropdownName = dropdownConfig.Name or "Dropdown"
                local dropdownOptions = dropdownConfig.Options or {}
                local dropdownDefault = dropdownConfig.Default
                local dropdownCallback = dropdownConfig.Callback or function() end
                
                local selected = dropdownDefault or (dropdownOptions[1] or "Select...")
                local open = false
                
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Name = dropdownName
                DropdownFrame.Size = UDim2.new(1, 0, 0, 70)
                DropdownFrame.BackgroundColor3 = Colors.Background
                DropdownFrame.BorderSizePixel = 0
                DropdownFrame.ClipsDescendants = true
                DropdownFrame.Parent = SectionContent
                
                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 10)
                DropdownCorner.Parent = DropdownFrame
                
                local DropdownLabel = Instance.new("TextLabel")
                DropdownLabel.Name = "Label"
                DropdownLabel.Size = UDim2.new(1, -20, 0, 24)
                DropdownLabel.Position = UDim2.new(0, 14, 0, 6)
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Text = dropdownName
                DropdownLabel.TextColor3 = Colors.Text
                DropdownLabel.TextSize = 14
                DropdownLabel.Font = Enum.Font.GothamMedium
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropdownLabel.Parent = DropdownFrame
                
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Name = "Button"
                DropdownButton.Size = UDim2.new(1, -24, 0, 32)
                DropdownButton.Position = UDim2.new(0, 12, 0, 32)
                DropdownButton.BackgroundColor3 = Colors.Secondary
                DropdownButton.Text = ""
                DropdownButton.BorderSizePixel = 0
                DropdownButton.AutoButtonColor = false
                DropdownButton.Parent = DropdownFrame
                
                local DropdownBtnCorner = Instance.new("UICorner")
                DropdownBtnCorner.CornerRadius = UDim.new(0, 8)
                DropdownBtnCorner.Parent = DropdownButton
                
                local DropdownBtnStroke = Instance.new("UIStroke")
                DropdownBtnStroke.Color = Colors.Border
                DropdownBtnStroke.Thickness = 1
                DropdownBtnStroke.Parent = DropdownButton
                
                local SelectedLabel = Instance.new("TextLabel")
                SelectedLabel.Name = "Selected"
                SelectedLabel.Size = UDim2.new(1, -40, 1, 0)
                SelectedLabel.Position = UDim2.new(0, 12, 0, 0)
                SelectedLabel.BackgroundTransparency = 1
                SelectedLabel.Text = selected
                SelectedLabel.TextColor3 = Colors.Text
                SelectedLabel.TextSize = 13
                SelectedLabel.Font = Enum.Font.Gotham
                SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
                SelectedLabel.TextTruncate = Enum.TextTruncate.AtEnd
                SelectedLabel.Parent = DropdownButton
                
                local ArrowLabel = Instance.new("TextLabel")
                ArrowLabel.Name = "Arrow"
                ArrowLabel.Size = UDim2.new(0, 20, 1, 0)
                ArrowLabel.Position = UDim2.new(1, -28, 0, 0)
                ArrowLabel.BackgroundTransparency = 1
                ArrowLabel.Text = "v"
                ArrowLabel.TextColor3 = Colors.TextDark
                ArrowLabel.TextSize = 12
                ArrowLabel.Font = Enum.Font.GothamBold
                ArrowLabel.Parent = DropdownButton
                
                -- Options Container
                local OptionsFrame = Instance.new("Frame")
                OptionsFrame.Name = "Options"
                OptionsFrame.Size = UDim2.new(1, -24, 0, 0)
                OptionsFrame.Position = UDim2.new(0, 12, 0, 68)
                OptionsFrame.BackgroundColor3 = Colors.Secondary
                OptionsFrame.BorderSizePixel = 0
                OptionsFrame.ClipsDescendants = true
                OptionsFrame.Parent = DropdownFrame
                
                local OptionsCorner = Instance.new("UICorner")
                OptionsCorner.CornerRadius = UDim.new(0, 8)
                OptionsCorner.Parent = OptionsFrame
                
                local OptionsLayout = Instance.new("UIListLayout")
                OptionsLayout.Padding = UDim.new(0, 2)
                OptionsLayout.Parent = OptionsFrame
                
                local function CreateOption(optionText)
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Name = optionText
                    OptionButton.Size = UDim2.new(1, 0, 0, 30)
                    OptionButton.BackgroundColor3 = Colors.Secondary
                    OptionButton.BackgroundTransparency = 1
                    OptionButton.Text = optionText
                    OptionButton.TextColor3 = Colors.Text
                    OptionButton.TextSize = 13
                    OptionButton.Font = Enum.Font.Gotham
                    OptionButton.BorderSizePixel = 0
                    OptionButton.AutoButtonColor = false
                    OptionButton.Parent = OptionsFrame
                    
                    OptionButton.MouseEnter:Connect(function()
                        CreateTween(OptionButton, 0.1, {BackgroundTransparency = 0, BackgroundColor3 = Colors.Accent}):Play()
                    end)
                    OptionButton.MouseLeave:Connect(function()
                        CreateTween(OptionButton, 0.1, {BackgroundTransparency = 1}):Play()
                    end)
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        selected = optionText
                        SelectedLabel.Text = selected
                        pcall(dropdownCallback, selected)
                        
                        -- Close dropdown
                        open = false
                        CreateTween(DropdownFrame, 0.2, {Size = UDim2.new(1, 0, 0, 70)}):Play()
                        CreateTween(OptionsFrame, 0.2, {Size = UDim2.new(1, -24, 0, 0)}):Play()
                        ArrowLabel.Text = "v"
                    end)
                end
                
                for _, option in ipairs(dropdownOptions) do
                    CreateOption(option)
                end
                
                DropdownButton.MouseButton1Click:Connect(function()
                    open = not open
                    if open then
                        local optionsHeight = #dropdownOptions * 32
                        CreateTween(DropdownFrame, 0.2, {Size = UDim2.new(1, 0, 0, 74 + optionsHeight)}):Play()
                        CreateTween(OptionsFrame, 0.2, {Size = UDim2.new(1, -24, 0, optionsHeight)}):Play()
                        ArrowLabel.Text = "^"
                    else
                        CreateTween(DropdownFrame, 0.2, {Size = UDim2.new(1, 0, 0, 70)}):Play()
                        CreateTween(OptionsFrame, 0.2, {Size = UDim2.new(1, -24, 0, 0)}):Play()
                        ArrowLabel.Text = "v"
                    end
                end)
                
                return {
                    Set = function(value)
                        selected = value
                        SelectedLabel.Text = selected
                        pcall(dropdownCallback, selected)
                    end,
                    Get = function()
                        return selected
                    end,
                    Refresh = function(newOptions, keepSelected)
                        for _, child in ipairs(OptionsFrame:GetChildren()) do
                            if child:IsA("TextButton") then
                                child:Destroy()
                            end
                        end
                        dropdownOptions = newOptions
                        for _, option in ipairs(newOptions) do
                            CreateOption(option)
                        end
                        if not keepSelected then
                            selected = newOptions[1] or "Select..."
                            SelectedLabel.Text = selected
                        end
                    end
                }
            end
            
            -- Label
            function Section:CreateLabel(labelText)
                local Label = Instance.new("TextLabel")
                Label.Name = "Label"
                Label.Size = UDim2.new(1, 0, 0, 30)
                Label.BackgroundColor3 = Colors.Background
                Label.BorderSizePixel = 0
                Label.Text = labelText or "Label"
                Label.TextColor3 = Colors.TextDark
                Label.TextSize = 13
                Label.Font = Enum.Font.Gotham
                Label.Parent = SectionContent
                
                local LabelCorner = Instance.new("UICorner")
                LabelCorner.CornerRadius = UDim.new(0, 8)
                LabelCorner.Parent = Label
                
                return {
                    Set = function(text)
                        Label.Text = text
                    end
                }
            end
            
            -- Keybind
            function Section:CreateKeybind(keybindConfig)
                keybindConfig = keybindConfig or {}
                local keybindName = keybindConfig.Name or "Keybind"
                local keybindDefault = keybindConfig.Default or Enum.KeyCode.E
                local keybindCallback = keybindConfig.Callback or function() end
                
                local currentKey = keybindDefault
                local listening = false
                
                local KeybindFrame = Instance.new("Frame")
                KeybindFrame.Name = keybindName
                KeybindFrame.Size = UDim2.new(1, 0, 0, 42)
                KeybindFrame.BackgroundColor3 = Colors.Background
                KeybindFrame.BorderSizePixel = 0
                KeybindFrame.Parent = SectionContent
                
                local KeybindCorner = Instance.new("UICorner")
                KeybindCorner.CornerRadius = UDim.new(0, 10)
                KeybindCorner.Parent = KeybindFrame
                
                local KeybindLabel = Instance.new("TextLabel")
                KeybindLabel.Name = "Label"
                KeybindLabel.Size = UDim2.new(1, -90, 1, 0)
                KeybindLabel.Position = UDim2.new(0, 14, 0, 0)
                KeybindLabel.BackgroundTransparency = 1
                KeybindLabel.Text = keybindName
                KeybindLabel.TextColor3 = Colors.Text
                KeybindLabel.TextSize = 14
                KeybindLabel.Font = Enum.Font.GothamMedium
                KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
                KeybindLabel.Parent = KeybindFrame
                
                local KeybindButton = Instance.new("TextButton")
                KeybindButton.Name = "Button"
                KeybindButton.Size = UDim2.new(0, 70, 0, 28)
                KeybindButton.Position = UDim2.new(1, -80, 0.5, -14)
                KeybindButton.BackgroundColor3 = Colors.Secondary
                KeybindButton.Text = currentKey.Name
                KeybindButton.TextColor3 = Colors.Accent
                KeybindButton.TextSize = 12
                KeybindButton.Font = Enum.Font.GothamBold
                KeybindButton.BorderSizePixel = 0
                KeybindButton.AutoButtonColor = false
                KeybindButton.Parent = KeybindFrame
                
                local KeybindBtnCorner = Instance.new("UICorner")
                KeybindBtnCorner.CornerRadius = UDim.new(0, 6)
                KeybindBtnCorner.Parent = KeybindButton
                
                KeybindButton.MouseButton1Click:Connect(function()
                    listening = true
                    KeybindButton.Text = "..."
                    CreateTween(KeybindButton, 0.15, {BackgroundColor3 = Colors.Accent}):Play()
                end)
                
                UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if listening then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            currentKey = input.KeyCode
                            KeybindButton.Text = currentKey.Name
                            listening = false
                            CreateTween(KeybindButton, 0.15, {BackgroundColor3 = Colors.Secondary}):Play()
                        end
                    else
                        if not gameProcessed and input.KeyCode == currentKey then
                            pcall(keybindCallback)
                        end
                    end
                end)
                
                return {
                    Set = function(key)
                        currentKey = key
                        KeybindButton.Text = key.Name
                    end,
                    Get = function()
                        return currentKey
                    end
                }
            end
            
            -- Color Picker
            function Section:CreateColorPicker(colorConfig)
                colorConfig = colorConfig or {}
                local colorName = colorConfig.Name or "Color Picker"
                local colorDefault = colorConfig.Default or Color3.fromRGB(255, 255, 255)
                local colorCallback = colorConfig.Callback or function() end
                
                local currentColor = colorDefault
                local open = false
                
                local ColorFrame = Instance.new("Frame")
                ColorFrame.Name = colorName
                ColorFrame.Size = UDim2.new(1, 0, 0, 42)
                ColorFrame.BackgroundColor3 = Colors.Background
                ColorFrame.BorderSizePixel = 0
                ColorFrame.ClipsDescendants = true
                ColorFrame.Parent = SectionContent
                
                local ColorCorner = Instance.new("UICorner")
                ColorCorner.CornerRadius = UDim.new(0, 10)
                ColorCorner.Parent = ColorFrame
                
                local ColorLabel = Instance.new("TextLabel")
                ColorLabel.Name = "Label"
                ColorLabel.Size = UDim2.new(1, -70, 0, 42)
                ColorLabel.Position = UDim2.new(0, 14, 0, 0)
                ColorLabel.BackgroundTransparency = 1
                ColorLabel.Text = colorName
                ColorLabel.TextColor3 = Colors.Text
                ColorLabel.TextSize = 14
                ColorLabel.Font = Enum.Font.GothamMedium
                ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
                ColorLabel.Parent = ColorFrame
                
                local ColorPreview = Instance.new("TextButton")
                ColorPreview.Name = "Preview"
                ColorPreview.Size = UDim2.new(0, 50, 0, 28)
                ColorPreview.Position = UDim2.new(1, -60, 0, 7)
                ColorPreview.BackgroundColor3 = currentColor
                ColorPreview.Text = ""
                ColorPreview.BorderSizePixel = 0
                ColorPreview.AutoButtonColor = false
                ColorPreview.Parent = ColorFrame
                
                local PreviewCorner = Instance.new("UICorner")
                PreviewCorner.CornerRadius = UDim.new(0, 6)
                PreviewCorner.Parent = ColorPreview
                
                local PreviewStroke = Instance.new("UIStroke")
                PreviewStroke.Color = Colors.Border
                PreviewStroke.Thickness = 1
                PreviewStroke.Parent = ColorPreview
                
                -- Color Picker Panel
                local PickerPanel = Instance.new("Frame")
                PickerPanel.Name = "PickerPanel"
                PickerPanel.Size = UDim2.new(1, -24, 0, 120)
                PickerPanel.Position = UDim2.new(0, 12, 0, 48)
                PickerPanel.BackgroundColor3 = Colors.Secondary
                PickerPanel.BorderSizePixel = 0
                PickerPanel.Visible = false
                PickerPanel.Parent = ColorFrame
                
                local PanelCorner = Instance.new("UICorner")
                PanelCorner.CornerRadius = UDim.new(0, 8)
                PanelCorner.Parent = PickerPanel
                
                -- RGB Sliders
                local function CreateRGBSlider(name, yPos, defaultValue, color)
                    local SliderBg = Instance.new("Frame")
                    SliderBg.Name = name
                    SliderBg.Size = UDim2.new(1, -20, 0, 6)
                    SliderBg.Position = UDim2.new(0, 10, 0, yPos)
                    SliderBg.BackgroundColor3 = Colors.Border
                    SliderBg.BorderSizePixel = 0
                    SliderBg.Parent = PickerPanel
                    
                    local SliderBgCorner = Instance.new("UICorner")
                    SliderBgCorner.CornerRadius = UDim.new(1, 0)
                    SliderBgCorner.Parent = SliderBg
                    
                    local SliderFill = Instance.new("Frame")
                    SliderFill.Name = "Fill"
                    SliderFill.Size = UDim2.new(defaultValue / 255, 0, 1, 0)
                    SliderFill.BackgroundColor3 = color
                    SliderFill.BorderSizePixel = 0
                    SliderFill.Parent = SliderBg
                    
                    local FillCorner = Instance.new("UICorner")
                    FillCorner.CornerRadius = UDim.new(1, 0)
                    FillCorner.Parent = SliderFill
                    
                    local SliderBtn = Instance.new("TextButton")
                    SliderBtn.Size = UDim2.new(1, 0, 1, 10)
                    SliderBtn.Position = UDim2.new(0, 0, 0, -5)
                    SliderBtn.BackgroundTransparency = 1
                    SliderBtn.Text = ""
                    SliderBtn.Parent = SliderBg
                    
                    local SliderLabel = Instance.new("TextLabel")
                    SliderLabel.Size = UDim2.new(0, 40, 0, 20)
                    SliderLabel.Position = UDim2.new(0, 10, 0, yPos - 18)
                    SliderLabel.BackgroundTransparency = 1
                    SliderLabel.Text = name .. ": " .. math.floor(defaultValue)
                    SliderLabel.TextColor3 = Colors.Text
                    SliderLabel.TextSize = 11
                    SliderLabel.Font = Enum.Font.Gotham
                    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                    SliderLabel.Parent = PickerPanel
                    
                    return {Bg = SliderBg, Fill = SliderFill, Button = SliderBtn, Label = SliderLabel}
                end
                
                local RSlider = CreateRGBSlider("R", 25, math.floor(currentColor.R * 255), Color3.fromRGB(255, 100, 100))
                local GSlider = CreateRGBSlider("G", 55, math.floor(currentColor.G * 255), Color3.fromRGB(100, 255, 100))
                local BSlider = CreateRGBSlider("B", 85, math.floor(currentColor.B * 255), Color3.fromRGB(100, 100, 255))
                
                local function UpdateColor()
                    local r = RSlider.Fill.Size.X.Scale * 255
                    local g = GSlider.Fill.Size.X.Scale * 255
                    local b = BSlider.Fill.Size.X.Scale * 255
                    currentColor = Color3.fromRGB(r, g, b)
                    ColorPreview.BackgroundColor3 = currentColor
                    pcall(colorCallback, currentColor)
                end
                
                local function SetupSlider(slider, name)
                    local dragging = false
                    
                    slider.Button.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = true
                        end
                    end)
                    
                    slider.Button.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = false
                        end
                    end)
                    
                    UserInputService.InputChanged:Connect(function(input)
                        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                            local pos = math.clamp((input.Position.X - slider.Bg.AbsolutePosition.X) / slider.Bg.AbsoluteSize.X, 0, 1)
                            slider.Fill.Size = UDim2.new(pos, 0, 1, 0)
                            slider.Label.Text = name .. ": " .. math.floor(pos * 255)
                            UpdateColor()
                        end
                    end)
                end
                
                SetupSlider(RSlider, "R")
                SetupSlider(GSlider, "G")
                SetupSlider(BSlider, "B")
                
                ColorPreview.MouseButton1Click:Connect(function()
                    open = not open
                    if open then
                        CreateTween(ColorFrame, 0.2, {Size = UDim2.new(1, 0, 0, 175)}):Play()
                        PickerPanel.Visible = true
                    else
                        CreateTween(ColorFrame, 0.2, {Size = UDim2.new(1, 0, 0, 42)}):Play()
                        task.delay(0.2, function()
                            PickerPanel.Visible = false
                        end)
                    end
                end)
                
                return {
                    Set = function(color)
                        currentColor = color
                        ColorPreview.BackgroundColor3 = color
                        RSlider.Fill.Size = UDim2.new(color.R, 0, 1, 0)
                        GSlider.Fill.Size = UDim2.new(color.G, 0, 1, 0)
                        BSlider.Fill.Size = UDim2.new(color.B, 0, 1, 0)
                        pcall(colorCallback, color)
                    end,
                    Get = function()
                        return currentColor
                    end
                }
            end
            
            return Section
        end
        
        return Tab
    end
    
    -- Notification System
    function Window:Notify(notifyConfig)
        notifyConfig = notifyConfig or {}
        local notifyTitle = notifyConfig.Title or "Notification"
        local notifyContent = notifyConfig.Content or ""
        local notifyDuration = notifyConfig.Duration or 3
        local notifyType = notifyConfig.Type or "Info"
        
        local typeColors = {
            Info = Colors.Accent,
            Success = Colors.Success,
            Warning = Colors.Warning,
            Error = Colors.Error
        }
        
        local NotifyFrame = Instance.new("Frame")
        NotifyFrame.Name = "Notification"
        NotifyFrame.Size = UDim2.new(0, 280, 0, 70)
        NotifyFrame.Position = UDim2.new(1, 0, 1, -80)
        NotifyFrame.BackgroundColor3 = Colors.Secondary
        NotifyFrame.BorderSizePixel = 0
        NotifyFrame.Parent = GUI.ScreenGui
        
        local NotifyCorner = Instance.new("UICorner")
        NotifyCorner.CornerRadius = UDim.new(0, 10)
        NotifyCorner.Parent = NotifyFrame
        
        local NotifyStroke = Instance.new("UIStroke")
        NotifyStroke.Color = typeColors[notifyType] or Colors.Accent
        NotifyStroke.Thickness = 1.5
        NotifyStroke.Parent = NotifyFrame
        
        local AccentBar = Instance.new("Frame")
        AccentBar.Name = "AccentBar"
        AccentBar.Size = UDim2.new(0, 4, 1, -10)
        AccentBar.Position = UDim2.new(0, 5, 0, 5)
        AccentBar.BackgroundColor3 = typeColors[notifyType] or Colors.Accent
        AccentBar.BorderSizePixel = 0
        AccentBar.Parent = NotifyFrame
        
        local AccentBarCorner = Instance.new("UICorner")
        AccentBarCorner.CornerRadius = UDim.new(0, 2)
        AccentBarCorner.Parent = AccentBar
        
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Name = "Title"
        TitleLabel.Size = UDim2.new(1, -30, 0, 22)
        TitleLabel.Position = UDim2.new(0, 18, 0, 8)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = notifyTitle
        TitleLabel.TextColor3 = Colors.Text
        TitleLabel.TextSize = 14
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Parent = NotifyFrame
        
        local ContentLabel = Instance.new("TextLabel")
        ContentLabel.Name = "Content"
        ContentLabel.Size = UDim2.new(1, -30, 0, 32)
        ContentLabel.Position = UDim2.new(0, 18, 0, 32)
        ContentLabel.BackgroundTransparency = 1
        ContentLabel.Text = notifyContent
        ContentLabel.TextColor3 = Colors.TextDark
        ContentLabel.TextSize = 12
        ContentLabel.Font = Enum.Font.Gotham
        ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
        ContentLabel.TextWrapped = true
        ContentLabel.Parent = NotifyFrame
        
        -- Animate in
        CreateTween(NotifyFrame, 0.3, {Position = UDim2.new(1, -290, 1, -80)}, Enum.EasingStyle.Back):Play()
        
        -- Animate out after duration
        task.delay(notifyDuration, function()
            CreateTween(NotifyFrame, 0.3, {Position = UDim2.new(1, 0, 1, -80)}):Play()
            task.delay(0.3, function()
                NotifyFrame:Destroy()
            end)
        end)
    end
    
    return Window
end

-- Return Library
Lieris.Colors = Colors
Lieris.Icons = Icons
Lieris.Version = "6.0"

return Lieris
