
--[[
    Lieris UI Library v1.0
    Modern Dark Theme with Customizable Accent
    
    Toggle Key: RightControl (по умолчанию)
    
    Автор: LierisV1
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

-- Цветовая схема (Modern Dark Theme)
local Colors = {
    Background = Color3.fromRGB(18, 18, 24),
    Secondary = Color3.fromRGB(25, 25, 35),
    Tertiary = Color3.fromRGB(32, 32, 45),
    Accent = Color3.fromRGB(99, 102, 241),
    AccentHover = Color3.fromRGB(79, 82, 200),
    AccentDark = Color3.fromRGB(67, 56, 202),
    Text = Color3.fromRGB(250, 250, 255),
    TextDark = Color3.fromRGB(140, 140, 160),
    TextMuted = Color3.fromRGB(100, 100, 120),
    Border = Color3.fromRGB(45, 45, 60),
    Success = Color3.fromRGB(34, 197, 94),
    Error = Color3.fromRGB(239, 68, 68),
    Warning = Color3.fromRGB(234, 179, 8),
    Info = Color3.fromRGB(59, 130, 246)
}

-- Иконки
local Icons = {
    Home = "rbxassetid://7733960981",
    Settings = "rbxassetid://7734053495",
    User = "rbxassetid://7743875962",
    Shield = "rbxassetid://7733717504",
    Star = "rbxassetid://7734068334",
    Heart = "rbxassetid://7733715400",
    Fire = "rbxassetid://7733696953",
    Lightning = "rbxassetid://7733756584",
    Eye = "rbxassetid://7733658504",
    Lock = "rbxassetid://7733756584",
    Unlock = "rbxassetid://7733756584",
    Target = "rbxassetid://7734068334",
    Sword = "rbxassetid://7734053495",
    Magic = "rbxassetid://7733696953",
    Close = "rbxassetid://7743878857",
    Menu = "rbxassetid://7743878326",
    Check = "rbxassetid://7743875962",
    Play = "rbxassetid://7733960981",
    Pause = "rbxassetid://7733960981"
}

-- Утилиты
local function CreateTween(instance, duration, properties, easingStyle, easingDirection)
    easingStyle = easingStyle or Enum.EasingStyle.Quart
    easingDirection = easingDirection or Enum.EasingDirection.Out
    return TweenService:Create(instance, TweenInfo.new(duration, easingStyle, easingDirection), properties)
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Colors.Border
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.Parent = parent
    return stroke
end

local function CreatePadding(parent, top, bottom, left, right)
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, top or 0)
    padding.PaddingBottom = UDim.new(0, bottom or 0)
    padding.PaddingLeft = UDim.new(0, left or 0)
    padding.PaddingRight = UDim.new(0, right or 0)
    padding.Parent = parent
    return padding
end

local function Ripple(button)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundColor3 = Color3.new(1, 1, 1)
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel = 0
    ripple.ZIndex = button.ZIndex + 1
    ripple.Parent = button
    
    CreateCorner(ripple, 100)
    
    local mouse = UserInputService:GetMouseLocation()
    local buttonPos = button.AbsolutePosition
    local relativeX = mouse.X - buttonPos.X
    local relativeY = mouse.Y - buttonPos.Y - 36
    
    ripple.Position = UDim2.new(0, relativeX, 0, relativeY)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    
    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2.5
    
    CreateTween(ripple, 0.6, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        Position = UDim2.new(0, relativeX - maxSize/2, 0, relativeY - maxSize/2),
        BackgroundTransparency = 1
    }):Play()
    
    task.delay(0.6, function()
        ripple:Destroy()
    end)
end

-- Основная функция создания окна
function Lieris:CreateWindow(config)
    config = config or {}
    local title = config.Title or "Lieris UI"
    local subtitle = config.Subtitle or "v1.0"
    local size = config.Size or UDim2.new(0, 580, 0, 420)
    local toggleKey = config.ToggleKey or Enum.KeyCode.RightControl
    local accentColor = config.AccentColor or Colors.Accent
    
    -- Обновить цвет акцента если задан
    if accentColor then
        Colors.Accent = accentColor
    end
    
    local Window = {}
    local Tabs = {}
    local CurrentTab = nil
    local Minimized = false
    local GUI = {}
    
    -- Создание ScreenGui
    GUI.ScreenGui = Instance.new("ScreenGui")
    GUI.ScreenGui.Name = "LierisUI_" .. HttpService:GenerateGUID(false)
    GUI.ScreenGui.ResetOnSpawn = false
    GUI.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Родитель GUI
    local success = pcall(function()
        GUI.ScreenGui.Parent = CoreGui
    end)
    if not success then
        GUI.ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    end
    
    -- Главный фрейм
    GUI.MainFrame = Instance.new("Frame")
    GUI.MainFrame.Name = "MainFrame"
    GUI.MainFrame.Size = size
    GUI.MainFrame.Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2)
    GUI.MainFrame.BackgroundColor3 = Colors.Background
    GUI.MainFrame.BorderSizePixel = 0
    GUI.MainFrame.ClipsDescendants = true
    GUI.MainFrame.Parent = GUI.ScreenGui
    
    CreateCorner(GUI.MainFrame, 12)
    
    local mainStroke = CreateStroke(GUI.MainFrame, Colors.Accent, 1.5)
    mainStroke.Transparency = 0.5
    
    -- Тень
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 60, 1, 60)
    Shadow.Position = UDim2.new(0, -30, 0, -30)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.4
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.ZIndex = -1
    Shadow.Parent = GUI.MainFrame
    
    -- Заголовок
    GUI.TitleBar = Instance.new("Frame")
    GUI.TitleBar.Name = "TitleBar"
    GUI.TitleBar.Size = UDim2.new(1, 0, 0, 50)
    GUI.TitleBar.BackgroundColor3 = Colors.Secondary
    GUI.TitleBar.BorderSizePixel = 0
    GUI.TitleBar.Parent = GUI.MainFrame
    
    CreateCorner(GUI.TitleBar, 12)
    
    -- Исправление углов заголовка
    local TitleBarFix = Instance.new("Frame")
    TitleBarFix.Name = "CornerFix"
    TitleBarFix.Size = UDim2.new(1, 0, 0, 15)
    TitleBarFix.Position = UDim2.new(0, 0, 1, -15)
    TitleBarFix.BackgroundColor3 = Colors.Secondary
    TitleBarFix.BorderSizePixel = 0
    TitleBarFix.Parent = GUI.TitleBar
    
    -- Логотип
    local LogoContainer = Instance.new("Frame")
    LogoContainer.Name = "Logo"
    LogoContainer.Size = UDim2.new(0, 32, 0, 32)
    LogoContainer.Position = UDim2.new(0, 12, 0.5, -16)
    LogoContainer.BackgroundColor3 = Colors.Accent
    LogoContainer.BorderSizePixel = 0
    LogoContainer.Parent = GUI.TitleBar
    
    CreateCorner(LogoContainer, 8)
    
    local LogoText = Instance.new("TextLabel")
    LogoText.Name = "LogoText"
    LogoText.Size = UDim2.new(1, 0, 1, 0)
    LogoText.BackgroundTransparency = 1
    LogoText.Text = "L"
    LogoText.TextColor3 = Colors.Text
    LogoText.TextSize = 20
    LogoText.Font = Enum.Font.GothamBlack
    LogoText.Parent = LogoContainer
    
    -- Заголовок текст
    GUI.TitleLabel = Instance.new("TextLabel")
    GUI.TitleLabel.Name = "Title"
    GUI.TitleLabel.Size = UDim2.new(1, -180, 0, 22)
    GUI.TitleLabel.Position = UDim2.new(0, 55, 0, 8)
    GUI.TitleLabel.BackgroundTransparency = 1
    GUI.TitleLabel.Text = title
    GUI.TitleLabel.TextColor3 = Colors.Text
    GUI.TitleLabel.TextSize = 16
    GUI.TitleLabel.Font = Enum.Font.GothamBold
    GUI.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    GUI.TitleLabel.Parent = GUI.TitleBar
    
    -- Подзаголовок
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Name = "Subtitle"
    SubtitleLabel.Size = UDim2.new(1, -180, 0, 16)
    SubtitleLabel.Position = UDim2.new(0, 55, 0, 28)
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Text = subtitle
    SubtitleLabel.TextColor3 = Colors.TextDark
    SubtitleLabel.TextSize = 11
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleLabel.Parent = GUI.TitleBar
    
    -- Кнопка закрытия
    GUI.CloseButton = Instance.new("TextButton")
    GUI.CloseButton.Name = "Close"
    GUI.CloseButton.Size = UDim2.new(0, 34, 0, 34)
    GUI.CloseButton.Position = UDim2.new(1, -44, 0.5, -17)
    GUI.CloseButton.BackgroundColor3 = Colors.Error
    GUI.CloseButton.Text = "✕"
    GUI.CloseButton.TextColor3 = Colors.Text
    GUI.CloseButton.TextSize = 14
    GUI.CloseButton.Font = Enum.Font.GothamBold
    GUI.CloseButton.BorderSizePixel = 0
    GUI.CloseButton.AutoButtonColor = false
    GUI.CloseButton.Parent = GUI.TitleBar
    
    CreateCorner(GUI.CloseButton, 8)
    
    GUI.CloseButton.MouseEnter:Connect(function()
        CreateTween(GUI.CloseButton, 0.15, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
    end)
    GUI.CloseButton.MouseLeave:Connect(function()
        CreateTween(GUI.CloseButton, 0.15, {BackgroundColor3 = Colors.Error}):Play()
    end)
    GUI.CloseButton.MouseButton1Click:Connect(function()
        CreateTween(GUI.MainFrame, 0.3, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
        task.delay(0.3, function()
            GUI.ScreenGui:Destroy()
        end)
    end)
    
    -- Кнопка минимизации
    GUI.MinimizeButton = Instance.new("TextButton")
    GUI.MinimizeButton.Name = "Minimize"
    GUI.MinimizeButton.Size = UDim2.new(0, 34, 0, 34)
    GUI.MinimizeButton.Position = UDim2.new(1, -86, 0.5, -17)
    GUI.MinimizeButton.BackgroundColor3 = Colors.Accent
    GUI.MinimizeButton.Text = "—"
    GUI.MinimizeButton.TextColor3 = Colors.Text
    GUI.MinimizeButton.TextSize = 16
    GUI.MinimizeButton.Font = Enum.Font.GothamBold
    GUI.MinimizeButton.BorderSizePixel = 0
    GUI.MinimizeButton.AutoButtonColor = false
    GUI.MinimizeButton.Parent = GUI.TitleBar
    
    CreateCorner(GUI.MinimizeButton, 8)
    
    GUI.MinimizeButton.MouseEnter:Connect(function()
        CreateTween(GUI.MinimizeButton, 0.15, {BackgroundColor3 = Colors.AccentHover}):Play()
    end)
    GUI.MinimizeButton.MouseLeave:Connect(function()
        CreateTween(GUI.MinimizeButton, 0.15, {BackgroundColor3 = Colors.Accent}):Play()
    end)
    GUI.MinimizeButton.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            CreateTween(GUI.MainFrame, 0.3, {Size = UDim2.new(0, size.X.Offset, 0, 50)}):Play()
            GUI.MinimizeButton.Text = "+"
        else
            CreateTween(GUI.MainFrame, 0.3, {Size = size}):Play()
            GUI.MinimizeButton.Text = "—"
        end
    end)
    
    -- Контейнер вкладок (слева)
    GUI.TabContainer = Instance.new("Frame")
    GUI.TabContainer.Name = "TabContainer"
    GUI.TabContainer.Size = UDim2.new(0, 130, 1, -60)
    GUI.TabContainer.Position = UDim2.new(0, 8, 0, 55)
    GUI.TabContainer.BackgroundColor3 = Colors.Secondary
    GUI.TabContainer.BorderSizePixel = 0
    GUI.TabContainer.Parent = GUI.MainFrame
    
    CreateCorner(GUI.TabContainer, 10)
    
    -- Скролл для вкладок
    GUI.TabScroll = Instance.new("ScrollingFrame")
    GUI.TabScroll.Name = "TabScroll"
    GUI.TabScroll.Size = UDim2.new(1, -10, 1, -10)
    GUI.TabScroll.Position = UDim2.new(0, 5, 0, 5)
    GUI.TabScroll.BackgroundTransparency = 1
    GUI.TabScroll.ScrollBarThickness = 2
    GUI.TabScroll.ScrollBarImageColor3 = Colors.Accent
    GUI.TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    GUI.TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    GUI.TabScroll.Parent = GUI.TabContainer
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 4)
    TabLayout.Parent = GUI.TabScroll
    
    -- Контейнер содержимого (справа)
    GUI.ContentContainer = Instance.new("Frame")
    GUI.ContentContainer.Name = "Content"
    GUI.ContentContainer.Size = UDim2.new(1, -155, 1, -60)
    GUI.ContentContainer.Position = UDim2.new(0, 145, 0, 55)
    GUI.ContentContainer.BackgroundTransparency = 1
    GUI.ContentContainer.Parent = GUI.MainFrame
    
    -- Перетаскивание окна
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
    
    -- Горячая клавиша для скрытия/показа
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == toggleKey then
            GUI.MainFrame.Visible = not GUI.MainFrame.Visible
        end
    end)
    
    -- Анимация открытия
    GUI.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    GUI.MainFrame.BackgroundTransparency = 1
    
    task.spawn(function()
        task.wait(0.05)
        CreateTween(GUI.MainFrame, 0.4, {Size = size, BackgroundTransparency = 0}, Enum.EasingStyle.Back):Play()
    end)
    
    -- Функция создания вкладки
    function Window:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or "Tab"
        local tabIcon = tabConfig.Icon
        
        local Tab = {}
        
        -- Кнопка вкладки
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Button"
        TabButton.Size = UDim2.new(1, 0, 0, 36)
        TabButton.BackgroundColor3 = Colors.Background
        TabButton.Text = ""
        TabButton.BorderSizePixel = 0
        TabButton.AutoButtonColor = false
        TabButton.Parent = GUI.TabScroll
        
        CreateCorner(TabButton, 8)
        
        -- Иконка вкладки
        if tabIcon and Icons[tabIcon] then
            local IconImage = Instance.new("ImageLabel")
            IconImage.Name = "Icon"
            IconImage.Size = UDim2.new(0, 16, 0, 16)
            IconImage.Position = UDim2.new(0, 10, 0.5, -8)
            IconImage.BackgroundTransparency = 1
            IconImage.Image = Icons[tabIcon]
            IconImage.ImageColor3 = Colors.TextDark
            IconImage.Parent = TabButton
        end
        
        -- Текст вкладки
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Name = "Label"
        TabLabel.Size = UDim2.new(1, tabIcon and -35 or -20, 1, 0)
        TabLabel.Position = UDim2.new(0, tabIcon and 32 or 10, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = tabName
        TabLabel.TextColor3 = Colors.TextDark
        TabLabel.TextSize = 12
        TabLabel.Font = Enum.Font.GothamMedium
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.TextTruncate = Enum.TextTruncate.AtEnd
        TabLabel.Parent = TabButton
        
        -- Фрейм содержимого вкладки
        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Name = tabName .. "Content"
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.BackgroundTransparency = 1
        TabFrame.ScrollBarThickness = 3
        TabFrame.ScrollBarImageColor3 = Colors.Accent
        TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabFrame.Visible = false
        TabFrame.Parent = GUI.ContentContainer
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Padding = UDim.new(0, 8)
        ContentLayout.Parent = TabFrame
        
        CreatePadding(TabFrame, 5, 10, 5, 5)
        
        Tabs[tabName] = {
            Button = TabButton,
            Frame = TabFrame,
            Label = TabLabel,
            Icon = TabButton:FindFirstChild("Icon")
        }
        
        -- Ховер эффект
        TabButton.MouseEnter:Connect(function()
            if CurrentTab ~= tabName then
                CreateTween(TabButton, 0.15, {BackgroundColor3 = Colors.Tertiary}):Play()
            end
        end)
        TabButton.MouseLeave:Connect(function()
            if CurrentTab ~= tabName then
                CreateTween(TabButton, 0.15, {BackgroundColor3 = Colors.Background}):Play()
            end
        end)
        
        -- Клик по вкладке
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
        
        -- Автовыбор первой вкладки
        if not CurrentTab then
            TabButton.MouseButton1Click:Fire()
        end
        
        -- Функция создания секции
        function Tab:CreateSection(sectionName)
            local Section = {}
            
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = sectionName or "Section"
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            SectionFrame.BackgroundColor3 = Colors.Secondary
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Parent = TabFrame
            
            CreateCorner(SectionFrame, 10)
            
            -- Заголовок секции
            local SectionHeader = Instance.new("Frame")
            SectionHeader.Name = "Header"
            SectionHeader.Size = UDim2.new(1, 0, 0, 30)
            SectionHeader.BackgroundTransparency = 1
            SectionHeader.Parent = SectionFrame
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.Size = UDim2.new(1, -20, 1, 0)
            SectionTitle.Position = UDim2.new(0, 12, 0, 0)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = sectionName or "Section"
            SectionTitle.TextColor3 = Colors.Accent
            SectionTitle.TextSize = 13
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionHeader
            
            -- Разделитель
            local Separator = Instance.new("Frame")
            Separator.Name = "Separator"
            Separator.Size = UDim2.new(1, -20, 0, 1)
            Separator.Position = UDim2.new(0, 10, 1, -1)
            Separator.BackgroundColor3 = Colors.Border
            Separator.BackgroundTransparency = 0.5
            Separator.BorderSizePixel = 0
            Separator.Parent = SectionHeader
            
            -- Контент секции
            local SectionContent = Instance.new("Frame")
            SectionContent.Name = "Content"
            SectionContent.Size = UDim2.new(1, -10, 0, 0)
            SectionContent.Position = UDim2.new(0, 5, 0, 34)
            SectionContent.AutomaticSize = Enum.AutomaticSize.Y
            SectionContent.BackgroundTransparency = 1
            SectionContent.Parent = SectionFrame
            
            local ContentLayout = Instance.new("UIListLayout")
            ContentLayout.Padding = UDim.new(0, 5)
            ContentLayout.Parent = SectionContent
            
            CreatePadding(SectionContent, 0, 8, 0, 0)
            
            -- Toggle
            function Section:CreateToggle(toggleConfig)
                toggleConfig = toggleConfig or {}
                local toggleName = toggleConfig.Name or "Toggle"
                local toggleDefault = toggleConfig.Default or false
                local toggleCallback = toggleConfig.Callback or function() end
                
                local enabled = toggleDefault
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = toggleName
                ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
                ToggleFrame.BackgroundColor3 = Colors.Background
                ToggleFrame.BorderSizePixel = 0
                ToggleFrame.Parent = SectionContent
                
                CreateCorner(ToggleFrame, 8)
                
                -- Hover
                ToggleFrame.MouseEnter:Connect(function()
                    CreateTween(ToggleFrame, 0.15, {BackgroundColor3 = Colors.Tertiary}):Play()
                end)
                ToggleFrame.MouseLeave:Connect(function()
                    CreateTween(ToggleFrame, 0.15, {BackgroundColor3 = Colors.Background}):Play()
                end)
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Name = "Label"
                ToggleLabel.Size = UDim2.new(1, -65, 1, 0)
                ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Text = toggleName
                ToggleLabel.TextColor3 = Colors.Text
                ToggleLabel.TextSize = 13
                ToggleLabel.Font = Enum.Font.GothamMedium
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleFrame
                
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Name = "Button"
                ToggleButton.Size = UDim2.new(0, 46, 0, 24)
                ToggleButton.Position = UDim2.new(1, -56, 0.5, -12)
                ToggleButton.BackgroundColor3 = enabled and Colors.Accent or Colors.Border
                ToggleButton.Text = ""
                ToggleButton.BorderSizePixel = 0
                ToggleButton.AutoButtonColor = false
                ToggleButton.Parent = ToggleFrame
                
                CreateCorner(ToggleButton, 12)
                
                local ToggleCircle = Instance.new("Frame")
                ToggleCircle.Name = "Circle"
                ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
                ToggleCircle.Position = enabled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
                ToggleCircle.BackgroundColor3 = Colors.Text
                ToggleCircle.BorderSizePixel = 0
                ToggleCircle.Parent = ToggleButton
                
                CreateCorner(ToggleCircle, 10)
                
                ToggleButton.MouseButton1Click:Connect(function()
                    enabled = not enabled
                    local targetPos = enabled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
                    local targetColor = enabled and Colors.Accent or Colors.Border
                    
                    CreateTween(ToggleCircle, 0.2, {Position = targetPos}):Play()
                    CreateTween(ToggleButton, 0.2, {BackgroundColor3 = targetColor}):Play()
                    
                    pcall(toggleCallback, enabled)
                end)
                
                if toggleDefault then
                    pcall(toggleCallback, toggleDefault)
                end
                
                return {
                    Set = function(value)
                        enabled = value
                        local targetPos = enabled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
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
                Button.Size = UDim2.new(1, 0, 0, 38)
                Button.BackgroundColor3 = Colors.Accent
                Button.Text = buttonName
                Button.TextColor3 = Colors.Text
                Button.TextSize = 13
                Button.Font = Enum.Font.GothamBold
                Button.BorderSizePixel = 0
                Button.AutoButtonColor = false
                Button.ClipsDescendants = true
                Button.Parent = SectionContent
                
                CreateCorner(Button, 8)
                
                Button.MouseEnter:Connect(function()
                    CreateTween(Button, 0.15, {BackgroundColor3 = Colors.AccentHover}):Play()
                end)
                Button.MouseLeave:Connect(function()
                    CreateTween(Button, 0.15, {BackgroundColor3 = Colors.Accent}):Play()
                end)
                
                Button.MouseButton1Click:Connect(function()
                    Ripple(Button)
                    CreateTween(Button, 0.05, {Size = UDim2.new(1, -4, 0, 36)}):Play()
                    task.wait(0.05)
                    CreateTween(Button, 0.1, {Size = UDim2.new(1, 0, 0, 38)}):Play()
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
                SliderFrame.Size = UDim2.new(1, 0, 0, 55)
                SliderFrame.BackgroundColor3 = Colors.Background
                SliderFrame.BorderSizePixel = 0
                SliderFrame.Parent = SectionContent
                
                CreateCorner(SliderFrame, 8)
                
                -- Hover
                SliderFrame.MouseEnter:Connect(function()
                    CreateTween(SliderFrame, 0.15, {BackgroundColor3 = Colors.Tertiary}):Play()
                end)
                SliderFrame.MouseLeave:Connect(function()
                    CreateTween(SliderFrame, 0.15, {BackgroundColor3 = Colors.Background}):Play()
                end)
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Name = "Label"
                SliderLabel.Size = UDim2.new(1, -70, 0, 20)
                SliderLabel.Position = UDim2.new(0, 12, 0, 6)
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Text = sliderName
                SliderLabel.TextColor3 = Colors.Text
                SliderLabel.TextSize = 13
                SliderLabel.Font = Enum.Font.GothamMedium
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = SliderFrame
                
                -- Значение
                local ValueBg = Instance.new("Frame")
                ValueBg.Name = "ValueBg"
                ValueBg.Size = UDim2.new(0, 50, 0, 20)
                ValueBg.Position = UDim2.new(1, -60, 0, 6)
                ValueBg.BackgroundColor3 = Colors.Secondary
                ValueBg.BorderSizePixel = 0
                ValueBg.Parent = SliderFrame
                
                CreateCorner(ValueBg, 5)
                
                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Name = "Value"
                ValueLabel.Size = UDim2.new(1, 0, 1, 0)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Text = tostring(value)
                ValueLabel.TextColor3 = Colors.Accent
                ValueLabel.TextSize = 11
                ValueLabel.Font = Enum.Font.GothamBold
                ValueLabel.Parent = ValueBg
                
                -- Трек слайдера
                local SliderBg = Instance.new("Frame")
                SliderBg.Name = "Track"
                SliderBg.Size = UDim2.new(1, -24, 0, 6)
                SliderBg.Position = UDim2.new(0, 12, 0, 36)
                SliderBg.BackgroundColor3 = Colors.Border
                SliderBg.BorderSizePixel = 0
                SliderBg.Parent = SliderFrame
                
                CreateCorner(SliderBg, 3)
                
                -- Заполнение
                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "Fill"
                SliderFill.Size = UDim2.new((value - sliderMin) / (sliderMax - sliderMin), 0, 1, 0)
                SliderFill.BackgroundColor3 = Colors.Accent
                SliderFill.BorderSizePixel = 0
                SliderFill.Parent = SliderBg
                
                CreateCorner(SliderFill, 3)
                
                -- Ручка
                local SliderKnob = Instance.new("Frame")
                SliderKnob.Name = "Knob"
                SliderKnob.Size = UDim2.new(0, 14, 0, 14)
                SliderKnob.Position = UDim2.new((value - sliderMin) / (sliderMax - sliderMin), -7, 0.5, -7)
                SliderKnob.BackgroundColor3 = Colors.Text
                SliderKnob.BorderSizePixel = 0
                SliderKnob.ZIndex = 2
                SliderKnob.Parent = SliderBg
                
                CreateCorner(SliderKnob, 7)
                
                -- Кнопка для ввода
                local SliderButton = Instance.new("TextButton")
                SliderButton.Name = "Input"
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
                DropdownFrame.Size = UDim2.new(1, 0, 0, 65)
                DropdownFrame.BackgroundColor3 = Colors.Background
                DropdownFrame.BorderSizePixel = 0
                DropdownFrame.ClipsDescendants = true
                DropdownFrame.Parent = SectionContent
                
                CreateCorner(DropdownFrame, 8)
                
                local DropdownLabel = Instance.new("TextLabel")
                DropdownLabel.Name = "Label"
                DropdownLabel.Size = UDim2.new(1, -20, 0, 22)
                DropdownLabel.Position = UDim2.new(0, 12, 0, 5)
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Text = dropdownName
                DropdownLabel.TextColor3 = Colors.Text
                DropdownLabel.TextSize = 13
                DropdownLabel.Font = Enum.Font.GothamMedium
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropdownLabel.Parent = DropdownFrame
                
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Name = "Button"
                DropdownButton.Size = UDim2.new(1, -24, 0, 30)
                DropdownButton.Position = UDim2.new(0, 12, 0, 30)
                DropdownButton.BackgroundColor3 = Colors.Secondary
                DropdownButton.Text = ""
                DropdownButton.BorderSizePixel = 0
                DropdownButton.AutoButtonColor = false
                DropdownButton.Parent = DropdownFrame
                
                CreateCorner(DropdownButton, 6)
                CreateStroke(DropdownButton, Colors.Border, 1)
                
                local SelectedLabel = Instance.new("TextLabel")
                SelectedLabel.Name = "Selected"
                SelectedLabel.Size = UDim2.new(1, -35, 1, 0)
                SelectedLabel.Position = UDim2.new(0, 10, 0, 0)
                SelectedLabel.BackgroundTransparency = 1
                SelectedLabel.Text = selected
                SelectedLabel.TextColor3 = Colors.Text
                SelectedLabel.TextSize = 12
                SelectedLabel.Font = Enum.Font.Gotham
                SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
                SelectedLabel.TextTruncate = Enum.TextTruncate.AtEnd
                SelectedLabel.Parent = DropdownButton
                
                local ArrowLabel = Instance.new("TextLabel")
                ArrowLabel.Name = "Arrow"
                ArrowLabel.Size = UDim2.new(0, 20, 1, 0)
                ArrowLabel.Position = UDim2.new(1, -25, 0, 0)
                ArrowLabel.BackgroundTransparency = 1
                ArrowLabel.Text = "▼"
                ArrowLabel.TextColor3 = Colors.TextDark
                ArrowLabel.TextSize = 10
                ArrowLabel.Font = Enum.Font.GothamBold
                ArrowLabel.Parent = DropdownButton
                
                -- Контейнер опций
                local OptionsFrame = Instance.new("Frame")
                OptionsFrame.Name = "Options"
                OptionsFrame.Size = UDim2.new(1, -24, 0, 0)
                OptionsFrame.Position = UDim2.new(0, 12, 0, 64)
                OptionsFrame.BackgroundColor3 = Colors.Secondary
                OptionsFrame.BorderSizePixel = 0
                OptionsFrame.ClipsDescendants = true
                OptionsFrame.Parent = DropdownFrame
                
                CreateCorner(OptionsFrame, 6)
                
                local OptionsLayout = Instance.new("UIListLayout")
                OptionsLayout.Padding = UDim.new(0, 2)
                OptionsLayout.Parent = OptionsFrame
                
                local function CreateOption(optionText)
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Name = optionText
                    OptionButton.Size = UDim2.new(1, 0, 0, 28)
                    OptionButton.BackgroundColor3 = Colors.Secondary
                    OptionButton.BackgroundTransparency = 1
                    OptionButton.Text = optionText
                    OptionButton.TextColor3 = Colors.Text
                    OptionButton.TextSize = 12
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
                        
                        open = false
                        CreateTween(DropdownFrame, 0.2, {Size = UDim2.new(1, 0, 0, 65)}):Play()
                        CreateTween(OptionsFrame, 0.2, {Size = UDim2.new(1, -24, 0, 0)}):Play()
                        ArrowLabel.Text = "▼"
                    end)
                end
                
                for _, option in ipairs(dropdownOptions) do
                    CreateOption(option)
                end
                
                DropdownButton.MouseButton1Click:Connect(function()
                    open = not open
                    if open then
                        local optionsHeight = #dropdownOptions * 30
                        CreateTween(DropdownFrame, 0.2, {Size = UDim2.new(1, 0, 0, 70 + optionsHeight)}):Play()
                        CreateTween(OptionsFrame, 0.2, {Size = UDim2.new(1, -24, 0, optionsHeight)}):Play()
                        ArrowLabel.Text = "▲"
                    else
                        CreateTween(DropdownFrame, 0.2, {Size = UDim2.new(1, 0, 0, 65)}):Play()
                        CreateTween(OptionsFrame, 0.2, {Size = UDim2.new(1, -24, 0, 0)}):Play()
                        ArrowLabel.Text = "▼"
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
                    Refresh = function(newOptions)
                        for _, child in ipairs(OptionsFrame:GetChildren()) do
                            if child:IsA("TextButton") then
                                child:Destroy()
                            end
                        end
                        dropdownOptions = newOptions
                        for _, option in ipairs(newOptions) do
                            CreateOption(option)
                        end
                    end
                }
            end
            
            -- Input
            function Section:CreateInput(inputConfig)
                inputConfig = inputConfig or {}
                local inputName = inputConfig.Name or "Input"
                local inputPlaceholder = inputConfig.Placeholder or "Enter text..."
                local inputDefault = inputConfig.Default or ""
                local inputCallback = inputConfig.Callback or function() end
                
                local InputFrame = Instance.new("Frame")
                InputFrame.Name = inputName
                InputFrame.Size = UDim2.new(1, 0, 0, 65)
                InputFrame.BackgroundColor3 = Colors.Background
                InputFrame.BorderSizePixel = 0
                InputFrame.Parent = SectionContent
                
                CreateCorner(InputFrame, 8)
                
                local InputLabel = Instance.new("TextLabel")
                InputLabel.Name = "Label"
                InputLabel.Size = UDim2.new(1, -20, 0, 22)
                InputLabel.Position = UDim2.new(0, 12, 0, 5)
                InputLabel.BackgroundTransparency = 1
                InputLabel.Text = inputName
                InputLabel.TextColor3 = Colors.Text
                InputLabel.TextSize = 13
                InputLabel.Font = Enum.Font.GothamMedium
                InputLabel.TextXAlignment = Enum.TextXAlignment.Left
                InputLabel.Parent = InputFrame
                
                local InputBoxFrame = Instance.new("Frame")
                InputBoxFrame.Name = "InputBox"
                InputBoxFrame.Size = UDim2.new(1, -24, 0, 30)
                InputBoxFrame.Position = UDim2.new(0, 12, 0, 30)
                InputBoxFrame.BackgroundColor3 = Colors.Secondary
                InputBoxFrame.BorderSizePixel = 0
                InputBoxFrame.Parent = InputFrame
                
                CreateCorner(InputBoxFrame, 6)
                local inputStroke = CreateStroke(InputBoxFrame, Colors.Border, 1)
                
                local InputBox = Instance.new("TextBox")
                InputBox.Name = "TextBox"
                InputBox.Size = UDim2.new(1, -16, 1, 0)
                InputBox.Position = UDim2.new(0, 8, 0, 0)
                InputBox.BackgroundTransparency = 1
                InputBox.Text = inputDefault
                InputBox.PlaceholderText = inputPlaceholder
                InputBox.PlaceholderColor3 = Colors.TextDark
                InputBox.TextColor3 = Colors.Text
                InputBox.TextSize = 12
                InputBox.Font = Enum.Font.Gotham
                InputBox.TextXAlignment = Enum.TextXAlignment.Left
                InputBox.ClearTextOnFocus = false
                InputBox.Parent = InputBoxFrame
                
                InputBox.Focused:Connect(function()
                    CreateTween(inputStroke, 0.15, {Color = Colors.Accent}):Play()
                end)
                
                InputBox.FocusLost:Connect(function()
                    CreateTween(inputStroke, 0.15, {Color = Colors.Border}):Play()
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
            
            -- Label
            function Section:CreateLabel(labelText)
                local Label = Instance.new("TextLabel")
                Label.Name = "Label"
                Label.Size = UDim2.new(1, 0, 0, 28)
                Label.BackgroundColor3 = Colors.Background
                Label.BorderSizePixel = 0
                Label.Text = labelText or "Label"
                Label.TextColor3 = Colors.TextDark
                Label.TextSize = 12
                Label.Font = Enum.Font.Gotham
                Label.Parent = SectionContent
                
                CreateCorner(Label, 6)
                
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
                KeybindFrame.Size = UDim2.new(1, 0, 0, 40)
                KeybindFrame.BackgroundColor3 = Colors.Background
                KeybindFrame.BorderSizePixel = 0
                KeybindFrame.Parent = SectionContent
                
                CreateCorner(KeybindFrame, 8)
                
                local KeybindLabel = Instance.new("TextLabel")
                KeybindLabel.Name = "Label"
                KeybindLabel.Size = UDim2.new(1, -80, 1, 0)
                KeybindLabel.Position = UDim2.new(0, 12, 0, 0)
                KeybindLabel.BackgroundTransparency = 1
                KeybindLabel.Text = keybindName
                KeybindLabel.TextColor3 = Colors.Text
                KeybindLabel.TextSize = 13
                KeybindLabel.Font = Enum.Font.GothamMedium
                KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
                KeybindLabel.Parent = KeybindFrame
                
                local KeybindButton = Instance.new("TextButton")
                KeybindButton.Name = "Button"
                KeybindButton.Size = UDim2.new(0, 65, 0, 26)
                KeybindButton.Position = UDim2.new(1, -75, 0.5, -13)
                KeybindButton.BackgroundColor3 = Colors.Secondary
                KeybindButton.Text = currentKey.Name
                KeybindButton.TextColor3 = Colors.Accent
                KeybindButton.TextSize = 11
                KeybindButton.Font = Enum.Font.GothamBold
                KeybindButton.BorderSizePixel = 0
                KeybindButton.AutoButtonColor = false
                KeybindButton.Parent = KeybindFrame
                
                CreateCorner(KeybindButton, 6)
                
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
            
            return Section
        end
        
        return Tab
    end
    
    -- Уведомления
    function Window:Notify(notifyConfig)
        notifyConfig = notifyConfig or {}
        local notifyTitle = notifyConfig.Title or "Notification"
        local notifyContent = notifyConfig.Content or ""
        local notifyDuration = notifyConfig.Duration or 3
        local notifyType = notifyConfig.Type or "Info"
        
        local typeColors = {
            Info = Colors.Info,
            Success = Colors.Success,
            Warning = Colors.Warning,
            Error = Colors.Error
        }
        
        local NotifyFrame = Instance.new("Frame")
        NotifyFrame.Name = "Notification"
        NotifyFrame.Size = UDim2.new(0, 260, 0, 65)
        NotifyFrame.Position = UDim2.new(1, 0, 1, -75)
        NotifyFrame.BackgroundColor3 = Colors.Secondary
        NotifyFrame.BorderSizePixel = 0
        NotifyFrame.Parent = GUI.ScreenGui
        
        CreateCorner(NotifyFrame, 10)
        
        local notifyStroke = CreateStroke(NotifyFrame, typeColors[notifyType] or Colors.Info, 1.5)
        
        -- Акцент бар
        local AccentBar = Instance.new("Frame")
        AccentBar.Name = "AccentBar"
        AccentBar.Size = UDim2.new(0, 4, 1, -10)
        AccentBar.Position = UDim2.new(0, 5, 0, 5)
        AccentBar.BackgroundColor3 = typeColors[notifyType] or Colors.Info
        AccentBar.BorderSizePixel = 0
        AccentBar.Parent = NotifyFrame
        
        CreateCorner(AccentBar, 2)
        
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Name = "Title"
        TitleLabel.Size = UDim2.new(1, -25, 0, 20)
        TitleLabel.Position = UDim2.new(0, 16, 0, 8)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = notifyTitle
        TitleLabel.TextColor3 = Colors.Text
        TitleLabel.TextSize = 13
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Parent = NotifyFrame
        
        local ContentLabel = Instance.new("TextLabel")
        ContentLabel.Name = "Content"
        ContentLabel.Size = UDim2.new(1, -25, 0, 30)
        ContentLabel.Position = UDim2.new(0, 16, 0, 30)
        ContentLabel.BackgroundTransparency = 1
        ContentLabel.Text = notifyContent
        ContentLabel.TextColor3 = Colors.TextDark
        ContentLabel.TextSize = 11
        ContentLabel.Font = Enum.Font.Gotham
        ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
        ContentLabel.TextWrapped = true
        ContentLabel.Parent = NotifyFrame
        
        -- Анимация входа
        CreateTween(NotifyFrame, 0.3, {Position = UDim2.new(1, -270, 1, -75)}, Enum.EasingStyle.Back):Play()
        
        -- Анимация выхода
        task.delay(notifyDuration, function()
            CreateTween(NotifyFrame, 0.3, {Position = UDim2.new(1, 0, 1, -75)}):Play()
            task.delay(0.3, function()
                NotifyFrame:Destroy()
            end)
        end)
    end
    
    return Window
end

-- Возврат библиотеки
Lieris.Colors = Colors
Lieris.Icons = Icons
Lieris.Version = "1.0"

return Lieris
