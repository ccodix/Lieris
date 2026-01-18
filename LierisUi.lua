--[[
    Lieris UI Library v7.0
    Two-Column Layout with Real Icons
    Toggle Key: H
]]

local Lieris = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer

-- Colors
local Colors = {
    Background = Color3.fromRGB(15, 15, 20),
    Secondary = Color3.fromRGB(22, 22, 30),
    Tertiary = Color3.fromRGB(28, 28, 38),
    Accent = Color3.fromRGB(99, 102, 241),
    AccentHover = Color3.fromRGB(79, 82, 200),
    Text = Color3.fromRGB(250, 250, 255),
    TextDark = Color3.fromRGB(140, 140, 160),
    Border = Color3.fromRGB(45, 45, 55),
    Success = Color3.fromRGB(34, 197, 94),
    Error = Color3.fromRGB(239, 68, 68),
    Warning = Color3.fromRGB(234, 179, 8)
}

-- Real Icon Assets (from user)
local Icons = {
    Lupa = "rbxassetid://132774784825596",
    Star = "rbxassetid://92707187440072",
    StarEmpty = "rbxassetid://108853802570915",
    Edit = "rbxassetid://79102469506206",
    ArrowLeft = "rbxassetid://73627730802442",
    ArrowUp = "rbxassetid://86798019032056",
    ArrowRight = "rbxassetid://78259254071491",
    ArrowDown = "rbxassetid://95371614437264",
    Undo = "rbxassetid://108718392331342",
    Trash = "rbxassetid://120799379418283",
    Key = "rbxassetid://124296337565532",
    Plus = "rbxassetid://113292455067178",
    Alert = "rbxassetid://129002225813257",
    Info = "rbxassetid://72675213757354",
    Gear = "rbxassetid://102267096559735",
    Settings = "rbxassetid://102267096559735",
    Gun = "rbxassetid://131253277679602",
    GunRifle = "rbxassetid://92276134372777",
    Whitelist = "rbxassetid://97543050372859",
    Dollar = "rbxassetid://99027619708694",
    Database = "rbxassetid://139502699163631",
    Question = "rbxassetid://136925848170066",
    Brain = "rbxassetid://84614763334611",
    Document = "rbxassetid://101184153582665",
    Padlock = "rbxassetid://101648628065104",
    Lock = "rbxassetid://101648628065104",
    Fullscreen = "rbxassetid://140212636469024",
    Folder = "rbxassetid://127886922473441",
    Heart = "rbxassetid://86525383749807",
    Flame = "rbxassetid://73806373761889",
    Fire = "rbxassetid://73806373761889",
    Time = "rbxassetid://92180740914957",
    Clock = "rbxassetid://92180740914957",
    Crown = "rbxassetid://126259774551591",
    Camera = "rbxassetid://125788738236572",
    Cloud = "rbxassetid://109550289152072",
    Discord = "rbxassetid://89700473399405",
    Resize = "rbxassetid://100459617281310",
    Lightning = "rbxassetid://113425277383163",
    Briefcase = "rbxassetid://138340962857599",
    Shield = "rbxassetid://85965347730498",
    Eye = "rbxassetid://125020341331789",
    Target = "rbxassetid://132774784825596",
    Search = "rbxassetid://132774784825596",
    -- UI Assets
    Background = "rbxassetid://120912477451723",
    Logo = "rbxassetid://93564507432615",
    CloseBtn = "rbxassetid://75618206104636",
    MinimizeBtn = "rbxassetid://95966901348174"
}

-- Utility
local function Tween(obj, time, props)
    local tween = TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

-- Main Function
function Lieris:CreateWindow(config)
    config = config or {}
    local title = config.Title or "Lieris UI"
    local size = config.Size or UDim2.new(0, 700, 0, 500)
    local toggleKey = config.ToggleKey or Enum.KeyCode.H
    
    local Window = {}
    local Tabs = {}
    local CurrentTab = nil
    local Minimized = false
    
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LierisUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    end
    
    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = size
    Main.Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2)
    Main.BackgroundColor3 = Colors.Background
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = Main
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Colors.Accent
    MainStroke.Thickness = 2
    MainStroke.Transparency = 0.5
    MainStroke.Parent = Main
    
    -- Background Image
    local BgImage = Instance.new("ImageLabel")
    BgImage.Name = "Background"
    BgImage.Size = UDim2.new(1, 0, 1, 0)
    BgImage.BackgroundTransparency = 1
    BgImage.Image = Icons.Background
    BgImage.ImageTransparency = 0.95
    BgImage.ScaleType = Enum.ScaleType.Tile
    BgImage.TileSize = UDim2.new(0, 100, 0, 100)
    BgImage.ZIndex = 0
    BgImage.Parent = Main
    
    local BgCorner = Instance.new("UICorner")
    BgCorner.CornerRadius = UDim.new(0, 10)
    BgCorner.Parent = BgImage
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Colors.Secondary
    TitleBar.BorderSizePixel = 0
    TitleBar.ZIndex = 2
    TitleBar.Parent = Main
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 10)
    TitleCorner.Parent = TitleBar
    
    local TitleFix = Instance.new("Frame")
    TitleFix.Size = UDim2.new(1, 0, 0, 10)
    TitleFix.Position = UDim2.new(0, 0, 1, -10)
    TitleFix.BackgroundColor3 = Colors.Secondary
    TitleFix.BorderSizePixel = 0
    TitleFix.ZIndex = 2
    TitleFix.Parent = TitleBar
    
    -- Logo
    local LogoImg = Instance.new("ImageLabel")
    LogoImg.Name = "Logo"
    LogoImg.Size = UDim2.new(0, 26, 0, 26)
    LogoImg.Position = UDim2.new(0, 10, 0.5, -13)
    LogoImg.BackgroundTransparency = 1
    LogoImg.Image = Icons.Logo
    LogoImg.ZIndex = 3
    LogoImg.Parent = TitleBar
    
    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, -120, 1, 0)
    TitleLabel.Position = UDim2.new(0, 45, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Colors.Text
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 3
    TitleLabel.Parent = TitleBar
    
    -- Close Button
    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.Name = "Close"
    CloseBtn.Size = UDim2.new(0, 24, 0, 24)
    CloseBtn.Position = UDim2.new(1, -35, 0.5, -12)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Image = Icons.CloseBtn
    CloseBtn.ZIndex = 3
    CloseBtn.Parent = TitleBar
    
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, 0.15, {ImageColor3 = Colors.Error})
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, 0.15, {ImageColor3 = Color3.new(1,1,1)})
    end)
    
    -- Minimize Button
    local MinBtn = Instance.new("ImageButton")
    MinBtn.Name = "Minimize"
    MinBtn.Size = UDim2.new(0, 24, 0, 24)
    MinBtn.Position = UDim2.new(1, -65, 0.5, -12)
    MinBtn.BackgroundTransparency = 1
    MinBtn.Image = Icons.MinimizeBtn
    MinBtn.ZIndex = 3
    MinBtn.Parent = TitleBar
    
    MinBtn.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            Tween(Main, 0.3, {Size = UDim2.new(0, size.X.Offset, 0, 40)})
        else
            Tween(Main, 0.3, {Size = size})
        end
    end)
    
    MinBtn.MouseEnter:Connect(function()
        Tween(MinBtn, 0.15, {ImageColor3 = Colors.Accent})
    end)
    MinBtn.MouseLeave:Connect(function()
        Tween(MinBtn, 0.15, {ImageColor3 = Color3.new(1,1,1)})
    end)
    
    -- Tab Bar (Horizontal)
    local TabBar = Instance.new("Frame")
    TabBar.Name = "TabBar"
    TabBar.Size = UDim2.new(1, -20, 0, 35)
    TabBar.Position = UDim2.new(0, 10, 0, 45)
    TabBar.BackgroundColor3 = Colors.Secondary
    TabBar.BorderSizePixel = 0
    TabBar.ZIndex = 2
    TabBar.Parent = Main
    
    local TabBarCorner = Instance.new("UICorner")
    TabBarCorner.CornerRadius = UDim.new(0, 8)
    TabBarCorner.Parent = TabBar
    
    local TabBarScroll = Instance.new("ScrollingFrame")
    TabBarScroll.Name = "Scroll"
    TabBarScroll.Size = UDim2.new(1, -10, 1, -6)
    TabBarScroll.Position = UDim2.new(0, 5, 0, 3)
    TabBarScroll.BackgroundTransparency = 1
    TabBarScroll.ScrollBarThickness = 0
    TabBarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabBarScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
    TabBarScroll.ScrollingDirection = Enum.ScrollingDirection.X
    TabBarScroll.ZIndex = 3
    TabBarScroll.Parent = TabBar
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.Parent = TabBarScroll
    
    -- Content Area (Two Columns)
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "Content"
    ContentArea.Size = UDim2.new(1, -20, 1, -95)
    ContentArea.Position = UDim2.new(0, 10, 0, 85)
    ContentArea.BackgroundTransparency = 1
    ContentArea.ZIndex = 2
    ContentArea.Parent = Main
    
    -- Dragging
    local dragging, dragStart, startPos = false, nil, nil
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    
    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Toggle Key
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == toggleKey then
            Main.Visible = not Main.Visible
        end
    end)
    
    -- Create Tab
    function Window:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or "Tab"
        local tabIcon = tabConfig.Icon
        
        local Tab = {}
        
        -- Tab Button
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = tabName
        TabBtn.Size = UDim2.new(0, 0, 1, -4)
        TabBtn.AutomaticSize = Enum.AutomaticSize.X
        TabBtn.BackgroundColor3 = Colors.Background
        TabBtn.BorderSizePixel = 0
        TabBtn.Text = ""
        TabBtn.ZIndex = 4
        TabBtn.Parent = TabBarScroll
        
        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 6)
        TabBtnCorner.Parent = TabBtn
        
        local TabPadding = Instance.new("UIPadding")
        TabPadding.PaddingLeft = UDim.new(0, 10)
        TabPadding.PaddingRight = UDim.new(0, 10)
        TabPadding.Parent = TabBtn
        
        -- Icon
        local iconOffset = 0
        if tabIcon and Icons[tabIcon] then
            local TabIcon = Instance.new("ImageLabel")
            TabIcon.Name = "Icon"
            TabIcon.Size = UDim2.new(0, 16, 0, 16)
            TabIcon.Position = UDim2.new(0, 0, 0.5, -8)
            TabIcon.BackgroundTransparency = 1
            TabIcon.Image = Icons[tabIcon]
            TabIcon.ImageColor3 = Colors.TextDark
            TabIcon.ZIndex = 5
            TabIcon.Parent = TabBtn
            iconOffset = 22
        end
        
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Name = "Label"
        TabLabel.Size = UDim2.new(0, 0, 1, 0)
        TabLabel.Position = UDim2.new(0, iconOffset, 0, 0)
        TabLabel.AutomaticSize = Enum.AutomaticSize.X
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = tabName
        TabLabel.TextColor3 = Colors.TextDark
        TabLabel.TextSize = 13
        TabLabel.Font = Enum.Font.GothamMedium
        TabLabel.ZIndex = 5
        TabLabel.Parent = TabBtn
        
        -- Two Column Content
        local TabContent = Instance.new("Frame")
        TabContent.Name = tabName .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.ZIndex = 2
        TabContent.Parent = ContentArea
        
        -- Left Panel
        local LeftPanel = Instance.new("ScrollingFrame")
        LeftPanel.Name = "Left"
        LeftPanel.Size = UDim2.new(0.5, -5, 1, 0)
        LeftPanel.Position = UDim2.new(0, 0, 0, 0)
        LeftPanel.BackgroundColor3 = Colors.Secondary
        LeftPanel.BorderSizePixel = 0
        LeftPanel.ScrollBarThickness = 4
        LeftPanel.ScrollBarImageColor3 = Colors.Accent
        LeftPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
        LeftPanel.AutomaticCanvasSize = Enum.AutomaticSize.Y
        LeftPanel.ZIndex = 3
        LeftPanel.Parent = TabContent
        
        local LeftCorner = Instance.new("UICorner")
        LeftCorner.CornerRadius = UDim.new(0, 8)
        LeftCorner.Parent = LeftPanel
        
        local LeftLayout = Instance.new("UIListLayout")
        LeftLayout.Padding = UDim.new(0, 8)
        LeftLayout.Parent = LeftPanel
        
        local LeftPadding = Instance.new("UIPadding")
        LeftPadding.PaddingTop = UDim.new(0, 8)
        LeftPadding.PaddingBottom = UDim.new(0, 8)
        LeftPadding.PaddingLeft = UDim.new(0, 8)
        LeftPadding.PaddingRight = UDim.new(0, 8)
        LeftPadding.Parent = LeftPanel
        
        -- Right Panel
        local RightPanel = Instance.new("ScrollingFrame")
        RightPanel.Name = "Right"
        RightPanel.Size = UDim2.new(0.5, -5, 1, 0)
        RightPanel.Position = UDim2.new(0.5, 5, 0, 0)
        RightPanel.BackgroundColor3 = Colors.Secondary
        RightPanel.BorderSizePixel = 0
        RightPanel.ScrollBarThickness = 4
        RightPanel.ScrollBarImageColor3 = Colors.Accent
        RightPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
        RightPanel.AutomaticCanvasSize = Enum.AutomaticSize.Y
        RightPanel.ZIndex = 3
        RightPanel.Parent = TabContent
        
        local RightCorner = Instance.new("UICorner")
        RightCorner.CornerRadius = UDim.new(0, 8)
        RightCorner.Parent = RightPanel
        
        local RightLayout = Instance.new("UIListLayout")
        RightLayout.Padding = UDim.new(0, 8)
        RightLayout.Parent = RightPanel
        
        local RightPadding = Instance.new("UIPadding")
        RightPadding.PaddingTop = UDim.new(0, 8)
        RightPadding.PaddingBottom = UDim.new(0, 8)
        RightPadding.PaddingLeft = UDim.new(0, 8)
        RightPadding.PaddingRight = UDim.new(0, 8)
        RightPadding.Parent = RightPanel
        
        Tabs[tabName] = {
            Button = TabBtn,
            Content = TabContent,
            Label = TabLabel,
            Icon = TabBtn:FindFirstChild("Icon"),
            Left = LeftPanel,
            Right = RightPanel
        }
        
        -- Tab Selection
        TabBtn.MouseEnter:Connect(function()
            if CurrentTab ~= tabName then
                Tween(TabBtn, 0.15, {BackgroundColor3 = Colors.Tertiary})
            end
        end)
        
        TabBtn.MouseLeave:Connect(function()
            if CurrentTab ~= tabName then
                Tween(TabBtn, 0.15, {BackgroundColor3 = Colors.Background})
            end
        end)
        
        TabBtn.MouseButton1Click:Connect(function()
            if CurrentTab then
                local old = Tabs[CurrentTab]
                old.Content.Visible = false
                Tween(old.Button, 0.2, {BackgroundColor3 = Colors.Background})
                Tween(old.Label, 0.2, {TextColor3 = Colors.TextDark})
                if old.Icon then
                    Tween(old.Icon, 0.2, {ImageColor3 = Colors.TextDark})
                end
            end
            
            CurrentTab = tabName
            TabContent.Visible = true
            Tween(TabBtn, 0.2, {BackgroundColor3 = Colors.Accent})
            Tween(TabLabel, 0.2, {TextColor3 = Colors.Text})
            if Tabs[tabName].Icon then
                Tween(Tabs[tabName].Icon, 0.2, {ImageColor3 = Colors.Text})
            end
        end)
        
        if not CurrentTab then
            task.defer(function()
                TabBtn.MouseButton1Click:Fire()
            end)
        end
        
        -- Section Creator
        function Tab:CreateSection(sectionName, side)
            side = side or "Left"
            local parent = side == "Right" and RightPanel or LeftPanel
            
            local Section = {}
            
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = sectionName or "Section"
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            SectionFrame.BackgroundColor3 = Colors.Background
            SectionFrame.BorderSizePixel = 0
            SectionFrame.ZIndex = 4
            SectionFrame.Parent = parent
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 8)
            SectionCorner.Parent = SectionFrame
            
            -- Header
            local Header = Instance.new("Frame")
            Header.Name = "Header"
            Header.Size = UDim2.new(1, 0, 0, 28)
            Header.BackgroundTransparency = 1
            Header.ZIndex = 5
            Header.Parent = SectionFrame
            
            local Title = Instance.new("TextLabel")
            Title.Name = "Title"
            Title.Size = UDim2.new(1, -16, 1, 0)
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.BackgroundTransparency = 1
            Title.Text = sectionName or "Section"
            Title.TextColor3 = Colors.Accent
            Title.TextSize = 13
            Title.Font = Enum.Font.GothamBold
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.ZIndex = 6
            Title.Parent = Header
            
            local Line = Instance.new("Frame")
            Line.Size = UDim2.new(1, -16, 0, 1)
            Line.Position = UDim2.new(0, 8, 1, -1)
            Line.BackgroundColor3 = Colors.Border
            Line.BorderSizePixel = 0
            Line.ZIndex = 5
            Line.Parent = Header
            
            -- Content
            local Content = Instance.new("Frame")
            Content.Name = "Content"
            Content.Size = UDim2.new(1, -12, 0, 0)
            Content.Position = UDim2.new(0, 6, 0, 32)
            Content.AutomaticSize = Enum.AutomaticSize.Y
            Content.BackgroundTransparency = 1
            Content.ZIndex = 5
            Content.Parent = SectionFrame
            
            local ContentLayout = Instance.new("UIListLayout")
            ContentLayout.Padding = UDim.new(0, 6)
            ContentLayout.Parent = Content
            
            local ContentPad = Instance.new("UIPadding")
            ContentPad.PaddingBottom = UDim.new(0, 8)
            ContentPad.Parent = Content
            
            -- Toggle
            function Section:CreateToggle(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Toggle"
                local default = cfg.Default or false
                local callback = cfg.Callback or function() end
                
                local enabled = default
                
                local Frame = Instance.new("Frame")
                Frame.Name = name
                Frame.Size = UDim2.new(1, 0, 0, 36)
                Frame.BackgroundColor3 = Colors.Tertiary
                Frame.BorderSizePixel = 0
                Frame.ZIndex = 6
                Frame.Parent = Content
                
                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 6)
                Corner.Parent = Frame
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -60, 1, 0)
                Label.Position = UDim2.new(0, 10, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = Colors.Text
                Label.TextSize = 13
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 7
                Label.Parent = Frame
                
                local ToggleBtn = Instance.new("TextButton")
                ToggleBtn.Size = UDim2.new(0, 44, 0, 22)
                ToggleBtn.Position = UDim2.new(1, -52, 0.5, -11)
                ToggleBtn.BackgroundColor3 = enabled and Colors.Accent or Colors.Border
                ToggleBtn.BorderSizePixel = 0
                ToggleBtn.Text = ""
                ToggleBtn.ZIndex = 7
                ToggleBtn.Parent = Frame
                
                local BtnCorner = Instance.new("UICorner")
                BtnCorner.CornerRadius = UDim.new(1, 0)
                BtnCorner.Parent = ToggleBtn
                
                local Circle = Instance.new("Frame")
                Circle.Size = UDim2.new(0, 18, 0, 18)
                Circle.Position = enabled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                Circle.BackgroundColor3 = Colors.Text
                Circle.BorderSizePixel = 0
                Circle.ZIndex = 8
                Circle.Parent = ToggleBtn
                
                local CircleCorner = Instance.new("UICorner")
                CircleCorner.CornerRadius = UDim.new(1, 0)
                CircleCorner.Parent = Circle
                
                ToggleBtn.MouseButton1Click:Connect(function()
                    enabled = not enabled
                    Tween(Circle, 0.2, {Position = enabled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)})
                    Tween(ToggleBtn, 0.2, {BackgroundColor3 = enabled and Colors.Accent or Colors.Border})
                    pcall(callback, enabled)
                end)
                
                if default then pcall(callback, default) end
                
                return {
                    Set = function(v)
                        enabled = v
                        Circle.Position = enabled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                        ToggleBtn.BackgroundColor3 = enabled and Colors.Accent or Colors.Border
                        pcall(callback, enabled)
                    end,
                    Get = function() return enabled end
                }
            end
            
            -- Button
            function Section:CreateButton(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Button"
                local callback = cfg.Callback or function() end
                
                local Btn = Instance.new("TextButton")
                Btn.Name = name
                Btn.Size = UDim2.new(1, 0, 0, 36)
                Btn.BackgroundColor3 = Colors.Accent
                Btn.BorderSizePixel = 0
                Btn.Text = name
                Btn.TextColor3 = Colors.Text
                Btn.TextSize = 13
                Btn.Font = Enum.Font.GothamBold
                Btn.ZIndex = 6
                Btn.Parent = Content
                
                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 6)
                Corner.Parent = Btn
                
                Btn.MouseEnter:Connect(function()
                    Tween(Btn, 0.15, {BackgroundColor3 = Colors.AccentHover})
                end)
                Btn.MouseLeave:Connect(function()
                    Tween(Btn, 0.15, {BackgroundColor3 = Colors.Accent})
                end)
                Btn.MouseButton1Click:Connect(function()
                    pcall(callback)
                end)
                
                return Btn
            end
            
            -- Slider
            function Section:CreateSlider(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Slider"
                local min = cfg.Min or 0
                local max = cfg.Max or 100
                local default = cfg.Default or min
                local callback = cfg.Callback or function() end
                
                local value = default
                
                local Frame = Instance.new("Frame")
                Frame.Name = name
                Frame.Size = UDim2.new(1, 0, 0, 50)
                Frame.BackgroundColor3 = Colors.Tertiary
                Frame.BorderSizePixel = 0
                Frame.ZIndex = 6
                Frame.Parent = Content
                
                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 6)
                Corner.Parent = Frame
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -60, 0, 20)
                Label.Position = UDim2.new(0, 10, 0, 4)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = Colors.Text
                Label.TextSize = 12
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 7
                Label.Parent = Frame
                
                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Size = UDim2.new(0, 45, 0, 20)
                ValueLabel.Position = UDim2.new(1, -55, 0, 4)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Text = tostring(value)
                ValueLabel.TextColor3 = Colors.Accent
                ValueLabel.TextSize = 12
                ValueLabel.Font = Enum.Font.GothamBold
                ValueLabel.ZIndex = 7
                ValueLabel.Parent = Frame
                
                local Track = Instance.new("Frame")
                Track.Size = UDim2.new(1, -20, 0, 6)
                Track.Position = UDim2.new(0, 10, 0, 32)
                Track.BackgroundColor3 = Colors.Border
                Track.BorderSizePixel = 0
                Track.ZIndex = 7
                Track.Parent = Frame
                
                local TrackCorner = Instance.new("UICorner")
                TrackCorner.CornerRadius = UDim.new(1, 0)
                TrackCorner.Parent = Track
                
                local Fill = Instance.new("Frame")
                Fill.Size = UDim2.new((value-min)/(max-min), 0, 1, 0)
                Fill.BackgroundColor3 = Colors.Accent
                Fill.BorderSizePixel = 0
                Fill.ZIndex = 8
                Fill.Parent = Track
                
                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = Fill
                
                local Knob = Instance.new("Frame")
                Knob.Size = UDim2.new(0, 12, 0, 12)
                Knob.Position = UDim2.new((value-min)/(max-min), -6, 0.5, -6)
                Knob.BackgroundColor3 = Colors.Text
                Knob.BorderSizePixel = 0
                Knob.ZIndex = 9
                Knob.Parent = Track
                
                local KnobCorner = Instance.new("UICorner")
                KnobCorner.CornerRadius = UDim.new(1, 0)
                KnobCorner.Parent = Knob
                
                local SliderBtn = Instance.new("TextButton")
                SliderBtn.Size = UDim2.new(1, 0, 1, 8)
                SliderBtn.Position = UDim2.new(0, 0, 0, -4)
                SliderBtn.BackgroundTransparency = 1
                SliderBtn.Text = ""
                SliderBtn.ZIndex = 10
                SliderBtn.Parent = Track
                
                local dragging = false
                
                local function Update(input)
                    local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                    value = math.floor(min + (max - min) * pos)
                    Fill.Size = UDim2.new(pos, 0, 1, 0)
                    Knob.Position = UDim2.new(pos, -6, 0.5, -6)
                    ValueLabel.Text = tostring(value)
                    pcall(callback, value)
                end
                
                SliderBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        Update(input)
                    end
                end)
                
                SliderBtn.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        Update(input)
                    end
                end)
                
                pcall(callback, value)
                
                return {
                    Set = function(v)
                        value = math.clamp(v, min, max)
                        local pos = (value-min)/(max-min)
                        Fill.Size = UDim2.new(pos, 0, 1, 0)
                        Knob.Position = UDim2.new(pos, -6, 0.5, -6)
                        ValueLabel.Text = tostring(value)
                        pcall(callback, value)
                    end,
                    Get = function() return value end
                }
            end
            
            -- Dropdown
            function Section:CreateDropdown(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Dropdown"
                local options = cfg.Options or {}
                local default = cfg.Default or options[1] or ""
                local callback = cfg.Callback or function() end
                
                local selected = default
                local open = false
                local optionBtns = {}
                
                local Frame = Instance.new("Frame")
                Frame.Name = name
                Frame.Size = UDim2.new(1, 0, 0, 60)
                Frame.BackgroundColor3 = Colors.Tertiary
                Frame.BorderSizePixel = 0
                Frame.ClipsDescendants = true
                Frame.ZIndex = 6
                Frame.Parent = Content
                
                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 6)
                Corner.Parent = Frame
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -16, 0, 20)
                Label.Position = UDim2.new(0, 10, 0, 4)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = Colors.Text
                Label.TextSize = 12
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 7
                Label.Parent = Frame
                
                local DropBtn = Instance.new("TextButton")
                DropBtn.Size = UDim2.new(1, -16, 0, 28)
                DropBtn.Position = UDim2.new(0, 8, 0, 26)
                DropBtn.BackgroundColor3 = Colors.Background
                DropBtn.BorderSizePixel = 0
                DropBtn.Text = ""
                DropBtn.ZIndex = 7
                DropBtn.Parent = Frame
                
                local DropCorner = Instance.new("UICorner")
                DropCorner.CornerRadius = UDim.new(0, 4)
                DropCorner.Parent = DropBtn
                
                local SelectedLabel = Instance.new("TextLabel")
                SelectedLabel.Size = UDim2.new(1, -30, 1, 0)
                SelectedLabel.Position = UDim2.new(0, 8, 0, 0)
                SelectedLabel.BackgroundTransparency = 1
                SelectedLabel.Text = selected
                SelectedLabel.TextColor3 = Colors.Text
                SelectedLabel.TextSize = 12
                SelectedLabel.Font = Enum.Font.Gotham
                SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
                SelectedLabel.TextTruncate = Enum.TextTruncate.AtEnd
                SelectedLabel.ZIndex = 8
                SelectedLabel.Parent = DropBtn
                
                local Arrow = Instance.new("ImageLabel")
                Arrow.Size = UDim2.new(0, 14, 0, 14)
                Arrow.Position = UDim2.new(1, -20, 0.5, -7)
                Arrow.BackgroundTransparency = 1
                Arrow.Image = Icons.ArrowDown
                Arrow.ImageColor3 = Colors.TextDark
                Arrow.ZIndex = 8
                Arrow.Parent = DropBtn
                
                local OptionsContainer = Instance.new("Frame")
                OptionsContainer.Name = "Options"
                OptionsContainer.Size = UDim2.new(1, -16, 0, 0)
                OptionsContainer.Position = UDim2.new(0, 8, 0, 58)
                OptionsContainer.BackgroundColor3 = Colors.Background
                OptionsContainer.BorderSizePixel = 0
                OptionsContainer.ClipsDescendants = true
                OptionsContainer.ZIndex = 9
                OptionsContainer.Parent = Frame
                
                local OptCorner = Instance.new("UICorner")
                OptCorner.CornerRadius = UDim.new(0, 4)
                OptCorner.Parent = OptionsContainer
                
                local OptLayout = Instance.new("UIListLayout")
                OptLayout.Padding = UDim.new(0, 2)
                OptLayout.Parent = OptionsContainer
                
                local function CreateOption(text)
                    local OptBtn = Instance.new("TextButton")
                    OptBtn.Size = UDim2.new(1, 0, 0, 26)
                    OptBtn.BackgroundTransparency = 1
                    OptBtn.BackgroundColor3 = Colors.Accent
                    OptBtn.BorderSizePixel = 0
                    OptBtn.Text = text
                    OptBtn.TextColor3 = Colors.Text
                    OptBtn.TextSize = 12
                    OptBtn.Font = Enum.Font.Gotham
                    OptBtn.ZIndex = 10
                    OptBtn.Parent = OptionsContainer
                    
                    OptBtn.MouseEnter:Connect(function()
                        Tween(OptBtn, 0.1, {BackgroundTransparency = 0})
                    end)
                    OptBtn.MouseLeave:Connect(function()
                        Tween(OptBtn, 0.1, {BackgroundTransparency = 1})
                    end)
                    
                    OptBtn.MouseButton1Click:Connect(function()
                        selected = text
                        SelectedLabel.Text = selected
                        pcall(callback, selected)
                        
                        open = false
                        local closedHeight = 60
                        Tween(Frame, 0.2, {Size = UDim2.new(1, 0, 0, closedHeight)})
                        Tween(OptionsContainer, 0.2, {Size = UDim2.new(1, -16, 0, 0)})
                        Tween(Arrow, 0.2, {Rotation = 0})
                    end)
                    
                    table.insert(optionBtns, OptBtn)
                end
                
                for _, opt in ipairs(options) do
                    CreateOption(opt)
                end
                
                DropBtn.MouseButton1Click:Connect(function()
                    open = not open
                    if open then
                        local optHeight = #options * 28
                        Tween(Frame, 0.2, {Size = UDim2.new(1, 0, 0, 64 + optHeight)})
                        Tween(OptionsContainer, 0.2, {Size = UDim2.new(1, -16, 0, optHeight)})
                        Tween(Arrow, 0.2, {Rotation = 180})
                    else
                        Tween(Frame, 0.2, {Size = UDim2.new(1, 0, 0, 60)})
                        Tween(OptionsContainer, 0.2, {Size = UDim2.new(1, -16, 0, 0)})
                        Tween(Arrow, 0.2, {Rotation = 0})
                    end
                end)
                
                return {
                    Set = function(v)
                        selected = v
                        SelectedLabel.Text = selected
                        pcall(callback, selected)
                    end,
                    Get = function() return selected end,
                    Refresh = function(newOpts)
                        for _, btn in ipairs(optionBtns) do
                            btn:Destroy()
                        end
                        optionBtns = {}
                        options = newOpts
                        for _, opt in ipairs(options) do
                            CreateOption(opt)
                        end
                    end
                }
            end
            
            -- Input
            function Section:CreateInput(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Input"
                local placeholder = cfg.Placeholder or ""
                local default = cfg.Default or ""
                local callback = cfg.Callback or function() end
                
                local Frame = Instance.new("Frame")
                Frame.Name = name
                Frame.Size = UDim2.new(1, 0, 0, 60)
                Frame.BackgroundColor3 = Colors.Tertiary
                Frame.BorderSizePixel = 0
                Frame.ZIndex = 6
                Frame.Parent = Content
                
                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 6)
                Corner.Parent = Frame
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -16, 0, 20)
                Label.Position = UDim2.new(0, 10, 0, 4)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = Colors.Text
                Label.TextSize = 12
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 7
                Label.Parent = Frame
                
                local InputBox = Instance.new("TextBox")
                InputBox.Size = UDim2.new(1, -16, 0, 28)
                InputBox.Position = UDim2.new(0, 8, 0, 26)
                InputBox.BackgroundColor3 = Colors.Background
                InputBox.BorderSizePixel = 0
                InputBox.Text = default
                InputBox.PlaceholderText = placeholder
                InputBox.PlaceholderColor3 = Colors.TextDark
                InputBox.TextColor3 = Colors.Text
                InputBox.TextSize = 12
                InputBox.Font = Enum.Font.Gotham
                InputBox.ClearTextOnFocus = false
                InputBox.ZIndex = 7
                InputBox.Parent = Frame
                
                local InputCorner = Instance.new("UICorner")
                InputCorner.CornerRadius = UDim.new(0, 4)
                InputCorner.Parent = InputBox
                
                local InputPad = Instance.new("UIPadding")
                InputPad.PaddingLeft = UDim.new(0, 8)
                InputPad.PaddingRight = UDim.new(0, 8)
                InputPad.Parent = InputBox
                
                InputBox.FocusLost:Connect(function()
                    pcall(callback, InputBox.Text)
                end)
                
                return {
                    Set = function(v) InputBox.Text = v pcall(callback, v) end,
                    Get = function() return InputBox.Text end
                }
            end
            
            -- Label
            function Section:CreateLabel(text)
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 0, 24)
                Label.BackgroundTransparency = 1
                Label.Text = text or ""
                Label.TextColor3 = Colors.TextDark
                Label.TextSize = 12
                Label.Font = Enum.Font.Gotham
                Label.ZIndex = 6
                Label.Parent = Content
                
                return {
                    Set = function(t) Label.Text = t end
                }
            end
            
            -- Keybind
            function Section:CreateKeybind(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Keybind"
                local default = cfg.Default or Enum.KeyCode.E
                local callback = cfg.Callback or function() end
                
                local key = default
                local listening = false
                
                local Frame = Instance.new("Frame")
                Frame.Name = name
                Frame.Size = UDim2.new(1, 0, 0, 36)
                Frame.BackgroundColor3 = Colors.Tertiary
                Frame.BorderSizePixel = 0
                Frame.ZIndex = 6
                Frame.Parent = Content
                
                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 6)
                Corner.Parent = Frame
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -80, 1, 0)
                Label.Position = UDim2.new(0, 10, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = Colors.Text
                Label.TextSize = 13
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 7
                Label.Parent = Frame
                
                local KeyBtn = Instance.new("TextButton")
                KeyBtn.Size = UDim2.new(0, 60, 0, 24)
                KeyBtn.Position = UDim2.new(1, -68, 0.5, -12)
                KeyBtn.BackgroundColor3 = Colors.Background
                KeyBtn.BorderSizePixel = 0
                KeyBtn.Text = key.Name
                KeyBtn.TextColor3 = Colors.Accent
                KeyBtn.TextSize = 11
                KeyBtn.Font = Enum.Font.GothamBold
                KeyBtn.ZIndex = 7
                KeyBtn.Parent = Frame
                
                local KeyCorner = Instance.new("UICorner")
                KeyCorner.CornerRadius = UDim.new(0, 4)
                KeyCorner.Parent = KeyBtn
                
                KeyBtn.MouseButton1Click:Connect(function()
                    listening = true
                    KeyBtn.Text = "..."
                    Tween(KeyBtn, 0.15, {BackgroundColor3 = Colors.Accent})
                end)
                
                UserInputService.InputBegan:Connect(function(input, gp)
                    if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                        key = input.KeyCode
                        KeyBtn.Text = key.Name
                        listening = false
                        Tween(KeyBtn, 0.15, {BackgroundColor3 = Colors.Background})
                    elseif not gp and input.KeyCode == key then
                        pcall(callback)
                    end
                end)
                
                return {
                    Set = function(k) key = k KeyBtn.Text = k.Name end,
                    Get = function() return key end
                }
            end
            
            return Section
        end
        
        return Tab
    end
    
    -- Notify
    function Window:Notify(cfg)
        cfg = cfg or {}
        local title = cfg.Title or "Notification"
        local content = cfg.Content or ""
        local duration = cfg.Duration or 3
        local ntype = cfg.Type or "Info"
        
        local colors = {
            Info = Colors.Accent,
            Success = Colors.Success,
            Warning = Colors.Warning,
            Error = Colors.Error
        }
        
        local Notif = Instance.new("Frame")
        Notif.Size = UDim2.new(0, 260, 0, 60)
        Notif.Position = UDim2.new(1, 10, 1, -70)
        Notif.BackgroundColor3 = Colors.Secondary
        Notif.BorderSizePixel = 0
        Notif.ZIndex = 100
        Notif.Parent = ScreenGui
        
        local NCorner = Instance.new("UICorner")
        NCorner.CornerRadius = UDim.new(0, 8)
        NCorner.Parent = Notif
        
        local NStroke = Instance.new("UIStroke")
        NStroke.Color = colors[ntype] or Colors.Accent
        NStroke.Thickness = 1.5
        NStroke.Parent = Notif
        
        local Bar = Instance.new("Frame")
        Bar.Size = UDim2.new(0, 3, 1, -10)
        Bar.Position = UDim2.new(0, 5, 0, 5)
        Bar.BackgroundColor3 = colors[ntype] or Colors.Accent
        Bar.BorderSizePixel = 0
        Bar.ZIndex = 101
        Bar.Parent = Notif
        
        local BarCorner = Instance.new("UICorner")
        BarCorner.CornerRadius = UDim.new(0, 2)
        BarCorner.Parent = Bar
        
        local TitleLbl = Instance.new("TextLabel")
        TitleLbl.Size = UDim2.new(1, -20, 0, 20)
        TitleLbl.Position = UDim2.new(0, 15, 0, 5)
        TitleLbl.BackgroundTransparency = 1
        TitleLbl.Text = title
        TitleLbl.TextColor3 = Colors.Text
        TitleLbl.TextSize = 13
        TitleLbl.Font = Enum.Font.GothamBold
        TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
        TitleLbl.ZIndex = 101
        TitleLbl.Parent = Notif
        
        local ContentLbl = Instance.new("TextLabel")
        ContentLbl.Size = UDim2.new(1, -20, 0, 30)
        ContentLbl.Position = UDim2.new(0, 15, 0, 26)
        ContentLbl.BackgroundTransparency = 1
        ContentLbl.Text = content
        ContentLbl.TextColor3 = Colors.TextDark
        ContentLbl.TextSize = 11
        ContentLbl.Font = Enum.Font.Gotham
        ContentLbl.TextXAlignment = Enum.TextXAlignment.Left
        ContentLbl.TextWrapped = true
        ContentLbl.ZIndex = 101
        ContentLbl.Parent = Notif
        
        Tween(Notif, 0.3, {Position = UDim2.new(1, -270, 1, -70)})
        
        task.delay(duration, function()
            Tween(Notif, 0.3, {Position = UDim2.new(1, 10, 1, -70)})
            task.wait(0.3)
            Notif:Destroy()
        end)
    end
    
    return Window
end

Lieris.Colors = Colors
Lieris.Icons = Icons
Lieris.Version = "7.0"

return Lieris
