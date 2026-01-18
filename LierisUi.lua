--[[
================================================================================
    LIERIS UI LIBRARY v4.0
    UI Library for Roblox Script Injectors
    
    Toggle Key: H (default)
    
    Features:
    - Tabs and Sections
    - Buttons, Toggles, Sliders
    - Dropdowns, Inputs, Keybinds
    - Color Picker with Confirm
    - Config Save/Load System
    - Notifications
    - Smooth Animations
================================================================================
]]

local Lieris = {}
Lieris.Flags = {}
Lieris.ConfigFolder = "LierisConfigs"
Lieris.CurrentConfig = "default"
Lieris._callbacks = {}
Lieris._elements = {}
Lieris.ToggleKey = Enum.KeyCode.H

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

-- Asset IDs
local Assets = {
    Background = "rbxassetid://120912477451723",
    Logo = "rbxassetid://93564507432615",
    CloseButton = "rbxassetid://75618206104636",
    MinimizeButton = "rbxassetid://95966901348174",
}

-- Colors (Black, White, Blue, Purple theme)
local Colors = {
    Background = Color3.fromRGB(12, 12, 18),
    BackgroundDark = Color3.fromRGB(8, 8, 12),
    Surface = Color3.fromRGB(18, 18, 26),
    SurfaceLight = Color3.fromRGB(28, 28, 38),
    SurfaceHover = Color3.fromRGB(35, 35, 48),
    
    Accent = Color3.fromRGB(90, 120, 255),
    AccentDark = Color3.fromRGB(70, 95, 200),
    AccentLight = Color3.fromRGB(120, 150, 255),
    
    Purple = Color3.fromRGB(140, 90, 255),
    PurpleDark = Color3.fromRGB(110, 70, 200),
    PurpleLight = Color3.fromRGB(170, 130, 255),
    
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(180, 180, 195),
    TextDark = Color3.fromRGB(120, 120, 140),
    
    Border = Color3.fromRGB(50, 50, 70),
    BorderLight = Color3.fromRGB(70, 70, 95),
    
    Glow = Color3.fromRGB(90, 120, 255),
    GlowPurple = Color3.fromRGB(140, 90, 255),
    
    Success = Color3.fromRGB(80, 200, 120),
    Error = Color3.fromRGB(255, 90, 90),
    Warning = Color3.fromRGB(255, 190, 70),
}

-- Simple Create function
local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then
            inst[k] = v
        end
    end
    if props.Parent then
        inst.Parent = props.Parent
    end
    return inst
end

-- Simple Tween
local function Tween(obj, props, time)
    time = time or 0.15
    local tween = TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

-- Add corner
local function Corner(parent, radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 6),
        Parent = parent
    })
end

-- Add stroke
local function Stroke(parent, color, thickness)
    return Create("UIStroke", {
        Color = color or Colors.Border,
        Thickness = thickness or 1,
        Parent = parent
    })
end

-- Config System
local function EnsureFolder()
    if isfolder and not isfolder(Lieris.ConfigFolder) then
        makefolder(Lieris.ConfigFolder)
    end
end

function Lieris:SaveConfig(name)
    name = name or self.CurrentConfig
    EnsureFolder()
    
    local data = {}
    for flag, value in pairs(self.Flags) do
        if typeof(value) == "Color3" then
            data[flag] = {Type = "Color3", R = value.R, G = value.G, B = value.B}
        elseif typeof(value) == "EnumItem" then
            data[flag] = {Type = "EnumItem", EnumType = tostring(value.EnumType), Name = value.Name}
        else
            data[flag] = {Type = typeof(value), Value = value}
        end
    end
    
    local success, json = pcall(function()
        return HttpService:JSONEncode(data)
    end)
    
    if success and writefile then
        pcall(function()
            writefile(self.ConfigFolder .. "/" .. name .. ".json", json)
        end)
        return true
    end
    return false
end

function Lieris:LoadConfig(name)
    name = name or self.CurrentConfig
    
    local path = self.ConfigFolder .. "/" .. name .. ".json"
    if not isfile or not isfile(path) then return false end
    
    local success, content = pcall(function()
        return readfile(path)
    end)
    
    if not success then return false end
    
    local data = HttpService:JSONDecode(content)
    
    for flag, info in pairs(data) do
        if info.Type == "Color3" then
            self.Flags[flag] = Color3.new(info.R, info.G, info.B)
        elseif info.Type == "EnumItem" then
            self.Flags[flag] = Enum[info.EnumType][info.Name]
        else
            self.Flags[flag] = info.Value
        end
        
        if self._elements[flag] then
            pcall(function()
                self._elements[flag]:Set(self.Flags[flag])
            end)
        end
    end
    
    return true
end

function Lieris:GetConfigs()
    EnsureFolder()
    local configs = {}
    
    if listfiles then
        for _, file in ipairs(listfiles(self.ConfigFolder)) do
            if file:match("%.json$") then
                local name = file:match("([^/\\]+)%.json$")
                if name then
                    table.insert(configs, name)
                end
            end
        end
    end
    
    return configs
end

function Lieris:DeleteConfig(name)
    if delfile then
        pcall(function()
            delfile(self.ConfigFolder .. "/" .. name .. ".json")
        end)
        return true
    end
    return false
end

-- Notification System (Simple, non-intrusive)
local NotifyGui, NotifyHolder

function Lieris:Notify(options)
    options = options or {}
    local Title = options.Title or "Notification"
    local Content = options.Content or ""
    local Duration = options.Duration or 3
    local Type = options.Type or "Info"
    
    local color = Colors.Accent
    if Type == "Success" then color = Colors.Success
    elseif Type == "Error" then color = Colors.Error
    elseif Type == "Warning" then color = Colors.Warning end
    
    if not NotifyGui then
        NotifyGui = Create("ScreenGui", {
            Name = "LierisNotify",
            ResetOnSpawn = false,
            DisplayOrder = 1000
        })
        pcall(function() NotifyGui.Parent = CoreGui end)
        if not NotifyGui.Parent then NotifyGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
        
        NotifyHolder = Create("Frame", {
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -15, 1, -15),
            AnchorPoint = Vector2.new(1, 1),
            Size = UDim2.new(0, 280, 0, 400),
            Parent = NotifyGui
        })
        
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Padding = UDim.new(0, 8),
            Parent = NotifyHolder
        })
    end
    
    local Notif = Create("Frame", {
        BackgroundColor3 = Colors.Surface,
        Size = UDim2.new(1, 0, 0, 0),
        ClipsDescendants = true,
        Parent = NotifyHolder
    })
    Corner(Notif, 8)
    Stroke(Notif, color)
    
    Create("Frame", {
        BackgroundColor3 = color,
        Size = UDim2.new(0, 3, 1, 0),
        BorderSizePixel = 0,
        Parent = Notif
    })
    
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 10),
        Size = UDim2.new(1, -25, 0, 18),
        Font = Enum.Font.GothamBold,
        Text = Title,
        TextColor3 = Colors.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Notif
    })
    
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 30),
        Size = UDim2.new(1, -25, 0, 30),
        Font = Enum.Font.Gotham,
        Text = Content,
        TextColor3 = Colors.TextDim,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = Notif
    })
    
    Tween(Notif, {Size = UDim2.new(1, 0, 0, 68)}, 0.2)
    
    task.delay(Duration, function()
        Tween(Notif, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
        task.delay(0.2, function()
            Notif:Destroy()
        end)
    end)
end

-- Main Window
function Lieris:CreateWindow(options)
    options = options or {}
    local Title = options.Name or options.Title or "Lieris"
    local ConfigFolder = options.ConfigFolder or "LierisConfigs"
    
    Lieris.ConfigFolder = ConfigFolder
    EnsureFolder()
    
    -- Remember position
    local savedPos = nil
    
    local ScreenGui = Create("ScreenGui", {
        Name = "LierisUI",
        ResetOnSpawn = false,
        DisplayOrder = 100
    })
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    
    -- Main Window
    local Main = Create("Frame", {
        Name = "Main",
        BackgroundColor3 = Colors.Background,
        Position = UDim2.new(0.5, -300, 0.5, -200),
        Size = UDim2.new(0, 600, 0, 400),
        ClipsDescendants = true,
        Parent = ScreenGui
    })
    Corner(Main, 10)
    Stroke(Main, Colors.Border)
    
    -- Background Image
    local BackgroundImage = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Image = Assets.Background,
        ImageTransparency = 0.95,
        ScaleType = Enum.ScaleType.Tile,
        TileSize = UDim2.new(0, 100, 0, 100),
        ZIndex = 0,
        Parent = Main
    })
    Corner(BackgroundImage, 10)
    
    -- Shadow
    local Shadow = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 4),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, 40, 1, 40),
        ZIndex = -1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.5,
        Parent = Main
    })
    
    -- Subtle glow effect
    local Glow = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0, -20),
        AnchorPoint = Vector2.new(0.5, 0),
        Size = UDim2.new(0.6, 0, 0, 40),
        ZIndex = 0,
        Image = "rbxassetid://5028857084",
        ImageColor3 = Colors.Glow,
        ImageTransparency = 0.85,
        Parent = Main
    })
    
    -- Dragging (only from title bar)
    local TitleBar = Create("Frame", {
        Name = "TitleBar",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 45),
        ZIndex = 2,
        Parent = Main
    })
    
    local dragging, dragStart, startPos
    
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
            savedPos = Main.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Logo
    local Logo = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 10),
        Size = UDim2.new(0, 24, 0, 24),
        Image = Assets.Logo,
        ZIndex = 3,
        Parent = TitleBar
    })
    
    -- Title
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 42, 0, 0),
        Size = UDim2.new(1, -130, 0, 45),
        Font = Enum.Font.GothamBold,
        Text = Title,
        TextColor3 = Colors.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3,
        Parent = TitleBar
    })
    
    -- Close Button with Image
    local CloseBtn = Create("ImageButton", {
        BackgroundColor3 = Colors.SurfaceLight,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -40, 0, 8),
        Size = UDim2.new(0, 28, 0, 28),
        Image = Assets.CloseButton,
        ImageColor3 = Colors.TextDim,
        ZIndex = 3,
        Parent = TitleBar
    })
    Corner(CloseBtn, 6)
    
    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, {BackgroundTransparency = 0, ImageColor3 = Colors.Error}, 0.15)
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, {BackgroundTransparency = 1, ImageColor3 = Colors.TextDim}, 0.15)
    end)
    
    -- Minimize Button with Image
    local MinBtn = Create("ImageButton", {
        BackgroundColor3 = Colors.SurfaceLight,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -72, 0, 8),
        Size = UDim2.new(0, 28, 0, 28),
        Image = Assets.MinimizeButton,
        ImageColor3 = Colors.TextDim,
        ZIndex = 3,
        Parent = TitleBar
    })
    Corner(MinBtn, 6)
    
    MinBtn.MouseEnter:Connect(function()
        Tween(MinBtn, {BackgroundTransparency = 0, ImageColor3 = Colors.Text}, 0.15)
    end)
    MinBtn.MouseLeave:Connect(function()
        Tween(MinBtn, {BackgroundTransparency = 1, ImageColor3 = Colors.TextDim}, 0.15)
    end)
    
    -- Divider
    Create("Frame", {
        BackgroundColor3 = Colors.Border,
        Position = UDim2.new(0, 0, 0, 45),
        Size = UDim2.new(1, 0, 0, 1),
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = Main
    })
    
    -- Tab Container
    local TabList = Create("Frame", {
        BackgroundColor3 = Colors.Surface,
        Position = UDim2.new(0, 0, 0, 46),
        Size = UDim2.new(0, 140, 1, -46),
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = Main
    })
    
    Create("Frame", {
        BackgroundColor3 = Colors.Border,
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0, 1, 1, 0),
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = TabList
    })
    
    local TabScroll = Create("ScrollingFrame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, 8),
        Size = UDim2.new(1, -16, 1, -16),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Colors.Border,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 2,
        Parent = TabList
    })
    
    Create("UIListLayout", {
        Padding = UDim.new(0, 4),
        Parent = TabScroll
    })
    
    -- Content Container
    local Content = Create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 141, 0, 46),
        Size = UDim2.new(1, -141, 1, -46),
        ZIndex = 2,
        Parent = Main
    })
    
    -- Window Object
    local Window = {}
    local Tabs = {}
    local CurrentTab = nil
    local minimized = false
    
    function Window:ToggleUI()
        Main.Visible = not Main.Visible
        if Main.Visible and savedPos then
            Main.Position = savedPos
        end
    end
    
    function Window:Destroy()
        ScreenGui:Destroy()
    end
    
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(Main, {Size = UDim2.new(0, 600, 0, 45)}, 0.2)
        else
            Tween(Main, {Size = UDim2.new(0, 600, 0, 400)}, 0.2)
        end
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        savedPos = Main.Position
        Main.Visible = false
    end)
    
    -- Toggle hotkey (default: H)
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Lieris.ToggleKey then
            Window:ToggleUI()
        end
    end)
    
    -- Create Tab
    function Window:CreateTab(tabOptions)
        tabOptions = tabOptions or {}
        local TabName = tabOptions.Name or "Tab"
        
        -- Tab Button
        local TabBtn = Create("TextButton", {
            BackgroundColor3 = Colors.Accent,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 32),
            Text = TabName,
            Font = Enum.Font.Gotham,
            TextColor3 = Colors.TextDim,
            TextSize = 13,
            ZIndex = 3,
            Parent = TabScroll
        })
        Corner(TabBtn, 6)
        
        -- Gradient for tab button
        local TabGradient = Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Colors.Accent),
                ColorSequenceKeypoint.new(1, Colors.Purple)
            }),
            Rotation = 90,
            Parent = TabBtn
        })
        
        -- Tab Page
        local TabPage = Create("ScrollingFrame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Colors.Border,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            ZIndex = 2,
            Parent = Content
        })
        
        Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Parent = TabPage
        })
        
        Create("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            Parent = TabPage
        })
        
        local function Activate()
            for _, t in pairs(Tabs) do
                t.Page.Visible = false
                Tween(t.Button, {BackgroundTransparency = 1, TextColor3 = Colors.TextDim}, 0.1)
            end
            TabPage.Visible = true
            Tween(TabBtn, {BackgroundTransparency = 0.85, TextColor3 = Colors.Text}, 0.1)
            CurrentTab = TabName
        end
        
        TabBtn.MouseButton1Click:Connect(Activate)
        
        TabBtn.MouseEnter:Connect(function()
            if CurrentTab ~= TabName then
                Tween(TabBtn, {BackgroundTransparency = 0.9}, 0.1)
            end
        end)
        
        TabBtn.MouseLeave:Connect(function()
            if CurrentTab ~= TabName then
                Tween(TabBtn, {BackgroundTransparency = 1}, 0.1)
            end
        end)
        
        table.insert(Tabs, {Button = TabBtn, Page = TabPage, Name = TabName})
        
        if #Tabs == 1 then
            Activate()
        end
        
        -- Tab Object
        local Tab = {}
        
        function Tab:CreateSection(name)
            name = name or "Section"
            
            local Section = Create("Frame", {
                BackgroundColor3 = Colors.Surface,
                Size = UDim2.new(1, 0, 0, 35),
                Parent = TabPage
            })
            Corner(Section, 8)
            
            local Header = Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -24, 0, 35),
                Font = Enum.Font.GothamBold,
                Text = name,
                TextColor3 = Colors.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Section
            })
            
            local ContentFrame = Create("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 35),
                Size = UDim2.new(1, 0, 0, 0),
                Parent = Section
            })
            
            local Layout = Create("UIListLayout", {
                Padding = UDim.new(0, 6),
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Parent = ContentFrame
            })
            
            Create("UIPadding", {
                PaddingBottom = UDim.new(0, 10),
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10),
                Parent = ContentFrame
            })
            
            Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                ContentFrame.Size = UDim2.new(1, 0, 0, Layout.AbsoluteContentSize.Y + 10)
                Section.Size = UDim2.new(1, 0, 0, 35 + Layout.AbsoluteContentSize.Y + 10)
            end)
            
            -- Elements
            local Elements = {}
            
            -- Label
            function Elements:CreateLabel(text)
                local Label = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    Font = Enum.Font.Gotham,
                    Text = text or "Label",
                    TextColor3 = Colors.TextDim,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = ContentFrame
                })
                
                local Obj = {}
                function Obj:Set(t) Label.Text = t end
                function Obj:Get() return Label.Text end
                return Obj
            end
            
            -- Button
            function Elements:CreateButton(props)
                props = props or {}
                local Name = props.Name or "Button"
                local Callback = props.Callback or function() end
                
                local Btn = Create("TextButton", {
                    BackgroundColor3 = Colors.SurfaceLight,
                    Size = UDim2.new(1, 0, 0, 32),
                    Font = Enum.Font.Gotham,
                    Text = Name,
                    TextColor3 = Colors.Text,
                    TextSize = 13,
                    AutoButtonColor = false,
                    Parent = ContentFrame
                })
                Corner(Btn, 6)
                
                Btn.MouseEnter:Connect(function()
                    Tween(Btn, {BackgroundColor3 = Colors.Accent}, 0.1)
                end)
                Btn.MouseLeave:Connect(function()
                    Tween(Btn, {BackgroundColor3 = Colors.SurfaceLight}, 0.1)
                end)
                Btn.MouseButton1Click:Connect(function()
                    pcall(Callback)
                end)
            end
            
            -- Toggle
            function Elements:CreateToggle(props)
                props = props or {}
                local Name = props.Name or "Toggle"
                local Default = props.Default or false
                local Flag = props.Flag or Name
                local Callback = props.Callback or function() end
                
                local Value = Default
                Lieris.Flags[Flag] = Value
                Lieris._callbacks[Flag] = Callback
                
                local Frame = Create("Frame", {
                    BackgroundColor3 = Colors.SurfaceLight,
                    Size = UDim2.new(1, 0, 0, 32),
                    Parent = ContentFrame
                })
                Corner(Frame, 6)
                
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -60, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = Name,
                    TextColor3 = Colors.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Frame
                })
                
                local Toggle = Create("Frame", {
                    BackgroundColor3 = Value and Colors.Accent or Colors.Background,
                    Position = UDim2.new(1, -48, 0.5, -10),
                    Size = UDim2.new(0, 38, 0, 20),
                    Parent = Frame
                })
                Corner(Toggle, 10)
                
                local Circle = Create("Frame", {
                    BackgroundColor3 = Colors.Text,
                    Position = Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                    Size = UDim2.new(0, 16, 0, 16),
                    Parent = Toggle
                })
                Corner(Circle, 8)
                
                local ToggleBtn = Create("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    Parent = Frame
                })
                
                local function Update()
                    Tween(Toggle, {BackgroundColor3 = Value and Colors.Accent or Colors.Background}, 0.15)
                    Tween(Circle, {Position = Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.15)
                end
                
                ToggleBtn.MouseButton1Click:Connect(function()
                    Value = not Value
                    Lieris.Flags[Flag] = Value
                    Update()
                    pcall(Callback, Value)
                end)
                
                local Obj = {}
                function Obj:Set(v)
                    Value = v
                    Lieris.Flags[Flag] = Value
                    Update()
                end
                function Obj:Get() return Value end
                
                Lieris._elements[Flag] = Obj
                return Obj
            end
            
            -- Slider
            function Elements:CreateSlider(props)
                props = props or {}
                local Name = props.Name or "Slider"
                local Min = props.Min or 0
                local Max = props.Max or 100
                local Default = props.Default or Min
                local Increment = props.Increment or 1
                local Flag = props.Flag or Name
                local Callback = props.Callback or function() end
                
                local Value = Default
                Lieris.Flags[Flag] = Value
                Lieris._callbacks[Flag] = Callback
                
                local Frame = Create("Frame", {
                    BackgroundColor3 = Colors.SurfaceLight,
                    Size = UDim2.new(1, 0, 0, 50),
                    Parent = ContentFrame
                })
                Corner(Frame, 6)
                
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 5),
                    Size = UDim2.new(0.6, 0, 0, 20),
                    Font = Enum.Font.Gotham,
                    Text = Name,
                    TextColor3 = Colors.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Frame
                })
                
                local ValueLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.6, 0, 0, 5),
                    Size = UDim2.new(0.4, -10, 0, 20),
                    Font = Enum.Font.GothamBold,
                    Text = tostring(Value),
                    TextColor3 = Colors.Accent,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = Frame
                })
                
                local Bar = Create("Frame", {
                    BackgroundColor3 = Colors.Background,
                    Position = UDim2.new(0, 10, 0, 32),
                    Size = UDim2.new(1, -20, 0, 8),
                    Parent = Frame
                })
                Corner(Bar, 4)
                
                local Fill = Create("Frame", {
                    BackgroundColor3 = Colors.Accent,
                    Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0),
                    Parent = Bar
                })
                Corner(Fill, 4)
                
                local Knob = Create("Frame", {
                    BackgroundColor3 = Colors.Text,
                    Position = UDim2.new((Default - Min) / (Max - Min), -7, 0.5, -7),
                    Size = UDim2.new(0, 14, 0, 14),
                    Parent = Bar
                })
                Corner(Knob, 7)
                
                local isDragging = false
                
                local function Update(input)
                    local percent = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    local raw = Min + ((Max - Min) * percent)
                    Value = math.floor(raw / Increment + 0.5) * Increment
                    Value = math.clamp(Value, Min, Max)
                    
                    local p = (Value - Min) / (Max - Min)
                    Lieris.Flags[Flag] = Value
                    ValueLabel.Text = tostring(Value)
                    Fill.Size = UDim2.new(p, 0, 1, 0)
                    Knob.Position = UDim2.new(p, -7, 0.5, -7)
                    
                    pcall(Callback, Value)
                end
                
                Bar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        isDragging = true
                        Update(input)
                    end
                end)
                
                Knob.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        isDragging = true
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        Update(input)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        isDragging = false
                    end
                end)
                
                local Obj = {}
                function Obj:Set(v)
                    Value = math.clamp(v, Min, Max)
                    Lieris.Flags[Flag] = Value
                    local p = (Value - Min) / (Max - Min)
                    ValueLabel.Text = tostring(Value)
                    Fill.Size = UDim2.new(p, 0, 1, 0)
                    Knob.Position = UDim2.new(p, -7, 0.5, -7)
                end
                function Obj:Get() return Value end
                
                Lieris._elements[Flag] = Obj
                return Obj
            end
            
            -- Input
            function Elements:CreateInput(props)
                props = props or {}
                local Name = props.Name or "Input"
                local Default = props.Default or ""
                local Placeholder = props.PlaceholderText or "Enter..."
                local Flag = props.Flag or Name
                local Callback = props.Callback or function() end
                
                Lieris.Flags[Flag] = Default
                Lieris._callbacks[Flag] = Callback
                
                local Frame = Create("Frame", {
                    BackgroundColor3 = Colors.SurfaceLight,
                    Size = UDim2.new(1, 0, 0, 32),
                    Parent = ContentFrame
                })
                Corner(Frame, 6)
                
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(0.4, 0, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = Name,
                    TextColor3 = Colors.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Frame
                })
                
                local Box = Create("TextBox", {
                    BackgroundColor3 = Colors.Background,
                    Position = UDim2.new(0.4, 5, 0.5, -12),
                    Size = UDim2.new(0.6, -15, 0, 24),
                    Font = Enum.Font.Gotham,
                    PlaceholderText = Placeholder,
                    PlaceholderColor3 = Colors.TextDark,
                    Text = Default,
                    TextColor3 = Colors.Text,
                    TextSize = 12,
                    ClearTextOnFocus = false,
                    Parent = Frame
                })
                Corner(Box, 4)
                
                Box.FocusLost:Connect(function()
                    Lieris.Flags[Flag] = Box.Text
                    pcall(Callback, Box.Text)
                end)
                
                local Obj = {}
                function Obj:Set(t) Box.Text = t; Lieris.Flags[Flag] = t end
                function Obj:Get() return Box.Text end
                
                Lieris._elements[Flag] = Obj
                return Obj
            end
            
            -- Dropdown
            function Elements:CreateDropdown(props)
                props = props or {}
                local Name = props.Name or "Dropdown"
                local Options = props.Options or {"Option 1", "Option 2"}
                local Default = props.Default or Options[1]
                local Flag = props.Flag or Name
                local Callback = props.Callback or function() end
                
                local Selected = Default
                local isOpen = false
                Lieris.Flags[Flag] = Selected
                Lieris._callbacks[Flag] = Callback
                
                local Frame = Create("Frame", {
                    BackgroundColor3 = Colors.SurfaceLight,
                    Size = UDim2.new(1, 0, 0, 32),
                    ClipsDescendants = true,
                    Parent = ContentFrame
                })
                Corner(Frame, 6)
                
                local Header = Create("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 32),
                    Text = "",
                    Parent = Frame
                })
                
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(0.5, 0, 0, 32),
                    Font = Enum.Font.Gotham,
                    Text = Name,
                    TextColor3 = Colors.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Header
                })
                
                local SelectedLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0, 0),
                    Size = UDim2.new(0.5, -30, 0, 32),
                    Font = Enum.Font.Gotham,
                    Text = Selected,
                    TextColor3 = Colors.Accent,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = Header
                })
                
                local Arrow = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -25, 0, 0),
                    Size = UDim2.new(0, 20, 0, 32),
                    Font = Enum.Font.GothamBold,
                    Text = "▼",
                    TextColor3 = Colors.TextDim,
                    TextSize = 10,
                    Parent = Header
                })
                
                local OptionsList = Create("Frame", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 5, 0, 36),
                    Size = UDim2.new(1, -10, 0, #Options * 28),
                    Parent = Frame
                })
                
                Create("UIListLayout", {
                    Padding = UDim.new(0, 2),
                    Parent = OptionsList
                })
                
                local function CreateOption(optName)
                    local OptBtn = Create("TextButton", {
                        BackgroundColor3 = Colors.Background,
                        BackgroundTransparency = optName == Selected and 0 or 1,
                        Size = UDim2.new(1, 0, 0, 26),
                        Font = Enum.Font.Gotham,
                        Text = optName,
                        TextColor3 = optName == Selected and Colors.Accent or Colors.TextDim,
                        TextSize = 12,
                        AutoButtonColor = false,
                        Parent = OptionsList
                    })
                    Corner(OptBtn, 4)
                    
                    OptBtn.MouseEnter:Connect(function()
                        if Selected ~= optName then
                            Tween(OptBtn, {BackgroundTransparency = 0.5}, 0.1)
                        end
                    end)
                    
                    OptBtn.MouseLeave:Connect(function()
                        if Selected ~= optName then
                            Tween(OptBtn, {BackgroundTransparency = 1}, 0.1)
                        end
                    end)
                    
                    OptBtn.MouseButton1Click:Connect(function()
                        Selected = optName
                        Lieris.Flags[Flag] = Selected
                        SelectedLabel.Text = Selected
                        
                        for _, c in ipairs(OptionsList:GetChildren()) do
                            if c:IsA("TextButton") then
                                local isSel = c.Text == Selected
                                Tween(c, {
                                    BackgroundTransparency = isSel and 0 or 1,
                                    TextColor3 = isSel and Colors.Accent or Colors.TextDim
                                }, 0.1)
                            end
                        end
                        
                        isOpen = false
                        Tween(Frame, {Size = UDim2.new(1, 0, 0, 32)}, 0.15)
                        Arrow.Text = "▼"
                        
                        pcall(Callback, Selected)
                    end)
                end
                
                for _, opt in ipairs(Options) do
                    CreateOption(opt)
                end
                
                Header.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    if isOpen then
                        Tween(Frame, {Size = UDim2.new(1, 0, 0, 40 + #Options * 28)}, 0.15)
                        Arrow.Text = "▲"
                    else
                        Tween(Frame, {Size = UDim2.new(1, 0, 0, 32)}, 0.15)
                        Arrow.Text = "▼"
                    end
                end)
                
                local Obj = {}
                function Obj:Set(v)
                    Selected = v
                    Lieris.Flags[Flag] = Selected
                    SelectedLabel.Text = Selected
                    for _, c in ipairs(OptionsList:GetChildren()) do
                        if c:IsA("TextButton") then
                            local isSel = c.Text == Selected
                            c.BackgroundTransparency = isSel and 0 or 1
                            c.TextColor3 = isSel and Colors.Accent or Colors.TextDim
                        end
                    end
                end
                function Obj:Get() return Selected end
                function Obj:Refresh(newOptions)
                    Options = newOptions
                    for _, c in ipairs(OptionsList:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                    for _, opt in ipairs(Options) do
                        CreateOption(opt)
                    end
                    OptionsList.Size = UDim2.new(1, -10, 0, #Options * 28)
                end
                
                Lieris._elements[Flag] = Obj
                return Obj
            end
            
            -- Keybind
            function Elements:CreateKeybind(props)
                props = props or {}
                local Name = props.Name or "Keybind"
                local Default = props.Default or Enum.KeyCode.E
                local Flag = props.Flag or Name
                local Callback = props.Callback or function() end
                
                local Key = Default
                local listening = false
                Lieris.Flags[Flag] = Key
                Lieris._callbacks[Flag] = Callback
                
                local Frame = Create("Frame", {
                    BackgroundColor3 = Colors.SurfaceLight,
                    Size = UDim2.new(1, 0, 0, 32),
                    Parent = ContentFrame
                })
                Corner(Frame, 6)
                
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -80, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = Name,
                    TextColor3 = Colors.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Frame
                })
                
                local KeyBtn = Create("TextButton", {
                    BackgroundColor3 = Colors.Background,
                    Position = UDim2.new(1, -70, 0.5, -12),
                    Size = UDim2.new(0, 60, 0, 24),
                    Font = Enum.Font.GothamBold,
                    Text = Key.Name,
                    TextColor3 = Colors.Accent,
                    TextSize = 11,
                    Parent = Frame
                })
                Corner(KeyBtn, 4)
                
                KeyBtn.MouseButton1Click:Connect(function()
                    listening = true
                    KeyBtn.Text = "..."
                    Tween(KeyBtn, {TextColor3 = Colors.Warning}, 0.1)
                end)
                
                UserInputService.InputBegan:Connect(function(input, processed)
                    if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                        Key = input.KeyCode
                        Lieris.Flags[Flag] = Key
                        KeyBtn.Text = Key.Name
                        Tween(KeyBtn, {TextColor3 = Colors.Accent}, 0.1)
                        listening = false
                    elseif not processed and input.KeyCode == Key then
                        pcall(Callback)
                    end
                end)
                
                local Obj = {}
                function Obj:Set(k) Key = k; Lieris.Flags[Flag] = k; KeyBtn.Text = k.Name end
                function Obj:Get() return Key end
                
                Lieris._elements[Flag] = Obj
                return Obj
            end
            
            -- Color Picker (with confirm button)
            function Elements:CreateColorPicker(props)
                props = props or {}
                local Name = props.Name or "Color"
                local Default = props.Default or Color3.fromRGB(255, 255, 255)
                local Flag = props.Flag or Name
                local Callback = props.Callback or function() end
                
                local Color = Default
                local TempColor = Default
                local H, S, V = Color3.toHSV(Default)
                local isOpen = false
                
                Lieris.Flags[Flag] = Color
                Lieris._callbacks[Flag] = Callback
                
                local Frame = Create("Frame", {
                    BackgroundColor3 = Colors.SurfaceLight,
                    Size = UDim2.new(1, 0, 0, 32),
                    ClipsDescendants = true,
                    Parent = ContentFrame
                })
                Corner(Frame, 6)
                
                local Header = Create("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 32),
                    Text = "",
                    Parent = Frame
                })
                
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -60, 0, 32),
                    Font = Enum.Font.Gotham,
                    Text = Name,
                    TextColor3 = Colors.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Header
                })
                
                local Preview = Create("Frame", {
                    BackgroundColor3 = Color,
                    Position = UDim2.new(1, -45, 0.5, -10),
                    Size = UDim2.new(0, 35, 0, 20),
                    Parent = Header
                })
                Corner(Preview, 4)
                Stroke(Preview, Colors.Border)
                
                -- Picker Panel
                local Panel = Create("Frame", {
                    BackgroundColor3 = Colors.Background,
                    Position = UDim2.new(0, 8, 0, 38),
                    Size = UDim2.new(1, -16, 0, 150),
                    Parent = Frame
                })
                Corner(Panel, 6)
                
                -- SV Picker
                local SVPicker = Create("ImageLabel", {
                    BackgroundColor3 = Color3.fromHSV(H, 1, 1),
                    Position = UDim2.new(0, 8, 0, 8),
                    Size = UDim2.new(1, -50, 0, 100),
                    Image = "rbxassetid://4155801252",
                    Parent = Panel
                })
                Corner(SVPicker, 4)
                
                local SVCursor = Create("Frame", {
                    BackgroundColor3 = Colors.Text,
                    Position = UDim2.new(S, -5, 1 - V, -5),
                    Size = UDim2.new(0, 10, 0, 10),
                    Parent = SVPicker
                })
                Corner(SVCursor, 5)
                Stroke(SVCursor, Color3.new(0, 0, 0), 2)
                
                -- Hue Bar
                local HueBar = Create("Frame", {
                    BackgroundColor3 = Colors.Text,
                    Position = UDim2.new(1, -32, 0, 8),
                    Size = UDim2.new(0, 18, 0, 100),
                    Parent = Panel
                })
                Corner(HueBar, 4)
                
                Create("UIGradient", {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                    }),
                    Rotation = 90,
                    Parent = HueBar
                })
                
                local HueCursor = Create("Frame", {
                    BackgroundColor3 = Colors.Text,
                    Position = UDim2.new(0.5, -7, H, -4),
                    Size = UDim2.new(0, 14, 0, 8),
                    Parent = HueBar
                })
                Corner(HueCursor, 3)
                Stroke(HueCursor, Color3.new(0, 0, 0), 2)
                
                -- Confirm Button
                local ConfirmBtn = Create("TextButton", {
                    BackgroundColor3 = Colors.Accent,
                    Position = UDim2.new(0, 8, 1, -32),
                    Size = UDim2.new(1, -16, 0, 26),
                    Font = Enum.Font.GothamBold,
                    Text = "Confirm",
                    TextColor3 = Colors.Text,
                    TextSize = 12,
                    AutoButtonColor = false,
                    Parent = Panel
                })
                Corner(ConfirmBtn, 4)
                
                local function UpdateTemp()
                    TempColor = Color3.fromHSV(H, S, V)
                    SVPicker.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
                end
                
                local draggingSV, draggingHue = false, false
                
                SVPicker.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingSV = true
                    end
                end)
                
                HueBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingHue = true
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        if draggingSV then
                            local pos = Vector2.new(
                                math.clamp((input.Position.X - SVPicker.AbsolutePosition.X) / SVPicker.AbsoluteSize.X, 0, 1),
                                math.clamp((input.Position.Y - SVPicker.AbsolutePosition.Y) / SVPicker.AbsoluteSize.Y, 0, 1)
                            )
                            S, V = pos.X, 1 - pos.Y
                            SVCursor.Position = UDim2.new(S, -5, 1 - V, -5)
                            UpdateTemp()
                        elseif draggingHue then
                            H = math.clamp((input.Position.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
                            HueCursor.Position = UDim2.new(0.5, -7, H, -4)
                            UpdateTemp()
                        end
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingSV, draggingHue = false, false
                    end
                end)
                
                Header.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    if isOpen then
                        TempColor = Color
                        H, S, V = Color3.toHSV(Color)
                        SVCursor.Position = UDim2.new(S, -5, 1 - V, -5)
                        HueCursor.Position = UDim2.new(0.5, -7, H, -4)
                        SVPicker.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
                        Tween(Frame, {Size = UDim2.new(1, 0, 0, 195)}, 0.15)
                    else
                        Tween(Frame, {Size = UDim2.new(1, 0, 0, 32)}, 0.15)
                    end
                end)
                
                ConfirmBtn.MouseButton1Click:Connect(function()
                    Color = TempColor
                    Lieris.Flags[Flag] = Color
                    Preview.BackgroundColor3 = Color
                    isOpen = false
                    Tween(Frame, {Size = UDim2.new(1, 0, 0, 32)}, 0.15)
                    pcall(Callback, Color)
                end)
                
                ConfirmBtn.MouseEnter:Connect(function()
                    Tween(ConfirmBtn, {BackgroundColor3 = Colors.AccentDark}, 0.1)
                end)
                ConfirmBtn.MouseLeave:Connect(function()
                    Tween(ConfirmBtn, {BackgroundColor3 = Colors.Accent}, 0.1)
                end)
                
                local Obj = {}
                function Obj:Set(c)
                    Color = c
                    Lieris.Flags[Flag] = Color
                    Preview.BackgroundColor3 = Color
                end
                function Obj:Get() return Color end
                
                Lieris._elements[Flag] = Obj
                return Obj
            end
            
            -- Paragraph
            function Elements:CreateParagraph(props)
                props = props or {}
                local Title = props.Title or "Title"
                local Content = props.Content or ""
                
                local PFrame = Create("Frame", {
                    BackgroundColor3 = Colors.Background,
                    Size = UDim2.new(1, 0, 0, 55),
                    Parent = ContentFrame
                })
                Corner(PFrame, 6)
                
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 8),
                    Size = UDim2.new(1, -20, 0, 16),
                    Font = Enum.Font.GothamBold,
                    Text = Title,
                    TextColor3 = Colors.Text,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = PFrame
                })
                
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 26),
                    Size = UDim2.new(1, -20, 0, 24),
                    Font = Enum.Font.Gotham,
                    Text = Content,
                    TextColor3 = Colors.TextDim,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    Parent = PFrame
                })
            end
            
            -- Divider
            function Elements:CreateDivider()
                Create("Frame", {
                    BackgroundColor3 = Colors.Border,
                    Size = UDim2.new(1, 0, 0, 1),
                    Parent = ContentFrame
                })
            end
            
            return Elements
        end
        
        return Tab
    end
    
    -- Built-in Settings Tab
    local SettingsTab = Window:CreateTab({Name = "Settings"})
    
    local ConfigSection = SettingsTab:CreateSection("Configurations")
    
    local configList = Lieris:GetConfigs()
    if #configList == 0 then configList = {"default"} end
    
    local ConfigDropdown
    local ConfigInput
    
    ConfigDropdown = ConfigSection:CreateDropdown({
        Name = "Config",
        Options = configList,
        Default = configList[1] or "default",
        Flag = "SelectedConfig",
        Callback = function(v)
            Lieris.CurrentConfig = v
        end
    })
    
    ConfigInput = ConfigSection:CreateInput({
        Name = "Config Name",
        Default = "",
        PlaceholderText = "New config name...",
        Flag = "NewConfigName"
    })
    
    ConfigSection:CreateButton({
        Name = "Save Config",
        Callback = function()
            local name = Lieris.Flags.NewConfigName
            if name and name ~= "" then
                Lieris.CurrentConfig = name
            end
            if Lieris:SaveConfig(Lieris.CurrentConfig) then
                local configs = Lieris:GetConfigs()
                ConfigDropdown:Refresh(configs)
                ConfigDropdown:Set(Lieris.CurrentConfig)
            end
        end
    })
    
    ConfigSection:CreateButton({
        Name = "Load Config",
        Callback = function()
            Lieris:LoadConfig(Lieris.CurrentConfig)
        end
    })
    
    ConfigSection:CreateButton({
        Name = "Delete Config",
        Callback = function()
            if Lieris.CurrentConfig ~= "default" then
                Lieris:DeleteConfig(Lieris.CurrentConfig)
                local configs = Lieris:GetConfigs()
                if #configs == 0 then configs = {"default"} end
                ConfigDropdown:Refresh(configs)
                ConfigDropdown:Set(configs[1])
                Lieris.CurrentConfig = configs[1]
            end
        end
    })
    
    local UISection = SettingsTab:CreateSection("Interface")
    
    UISection:CreateKeybind({
        Name = "Toggle UI",
        Default = Enum.KeyCode.H,
        Flag = "ToggleKey",
        Callback = function()
            Window:ToggleUI()
        end
    })
    
    UISection:CreateParagraph({
        Title = "Lieris UI v4.0",
        Content = "Press H to toggle UI visibility"
    })
    
    return Window
end

Lieris.Colors = Colors
Lieris.Assets = Assets

return Lieris
