--[[
================================================================================
    LIERIS UI LIBRARY v5.1
    Beautiful UI Library for Roblox Script Injectors
    
    Toggle Key: H (default)
    
    Features:
    - Beautiful dark theme with blue/purple accents
    - Smooth animations and transitions
    - Subtle glow effects
    - Background image support
    - Custom icons for close/minimize buttons
    - Full element set: Buttons, Toggles, Sliders, Dropdowns, etc.
    - Config save/load system
    - Notification system
    - 40+ Built-in Icons
    
    Icons Available:
    Lieris.Icons.Search, Star, StarEmpty, Edit, ArrowLeft, ArrowUp, ArrowRight,
    ArrowDown, Undo, Trash, Key, Plus, Alert, Info, Question, Gear, Settings,
    Database, Document, Folder, Fullscreen, Resize, Padlock, Shield, Eye,
    Gun, GunRifle, Dollar, Briefcase, Discord, Heart, List, Brain, Flame,
    Time, Crown, Camera, Cloud, Lightning
================================================================================
]]

local Lieris = {}
Lieris.Flags = {}
Lieris.ConfigFolder = "LierisConfigs"
Lieris.CurrentConfig = "default"
Lieris._callbacks = {}
Lieris._elements = {}
Lieris.ToggleKey = Enum.KeyCode.H
Lieris.Version = "5.1"

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")

local LocalPlayer = Players.LocalPlayer

-- Asset IDs (Your custom images)
local Assets = {
    -- Main UI Assets
    Background = "rbxassetid://120912477451723",
    Logo = "rbxassetid://93564507432615",
    CloseButton = "rbxassetid://75618206104636",
    MinimizeButton = "rbxassetid://95966901348174",
    Shadow = "rbxassetid://5028857084",
    Glow = "rbxassetid://5028857084",
    Gradient = "rbxassetid://4588631664",
    Circle = "rbxassetid://4156305525",
}

-- Icons Library
local Icons = {
    -- UI Icons
    Lupa = "rbxassetid://132774784825596",
    Search = "rbxassetid://132774784825596",
    Star = "rbxassetid://92707187440072",
    StarEmpty = "rbxassetid://108853802570915",
    Edit = "rbxassetid://79102469506206",
    Pencil = "rbxassetid://79102469506206",
    
    -- Arrow Icons
    ArrowLeft = "rbxassetid://73627730802442",
    ArrowUp = "rbxassetid://86798019032056",
    ArrowRight = "rbxassetid://78259254071491",
    ArrowDown = "rbxassetid://95371614437264",
    
    -- Action Icons
    Undo = "rbxassetid://108718392331342",
    Trash = "rbxassetid://120799379418283",
    Delete = "rbxassetid://120799379418283",
    Key = "rbxassetid://124296337565532",
    Plus = "rbxassetid://113292455067178",
    Add = "rbxassetid://113292455067178",
    
    -- Status Icons
    Alert = "rbxassetid://129002225813257",
    Warning = "rbxassetid://129002225813257",
    Info = "rbxassetid://72675213757354",
    Question = "rbxassetid://136925848170066",
    
    -- Settings/System Icons
    Gear = "rbxassetid://102267096559735",
    Settings = "rbxassetid://102267096559735",
    Database = "rbxassetid://139502699163631",
    Document = "rbxassetid://101184153582665",
    File = "rbxassetid://101184153582665",
    Folder = "rbxassetid://127886922473441",
    Fullscreen = "rbxassetid://140212636469024",
    Resize = "rbxassetid://100459617281310",
    
    -- Security Icons
    Padlock = "rbxassetid://101648628065104",
    Lock = "rbxassetid://101648628065104",
    Shield = "rbxassetid://85965347730498",
    Eye = "rbxassetid://125020341331789",
    
    -- Game/Combat Icons
    Gun = "rbxassetid://131253277679602",
    GunRifle = "rbxassetid://92276134372777",
    Rifle = "rbxassetid://92276134372777",
    
    -- Business/Finance Icons
    Dollar = "rbxassetid://99027619708694",
    Money = "rbxassetid://99027619708694",
    Briefcase = "rbxassetid://138340962857599",
    
    -- Social/Media Icons
    Discord = "rbxassetid://89700473399405",
    Heart = "rbxassetid://86525383749807",
    Like = "rbxassetid://86525383749807",
    
    -- Misc Icons
    List = "rbxassetid://97543050372859",
    WhiteList = "rbxassetid://97543050372859",
    Brain = "rbxassetid://84614763334611",
    Flame = "rbxassetid://73806373761889",
    Fire = "rbxassetid://73806373761889",
    Time = "rbxassetid://92180740914957",
    Clock = "rbxassetid://92180740914957",
    Crown = "rbxassetid://126259774551591",
    Camera = "rbxassetid://125788738236572",
    Cloud = "rbxassetid://109550289152072",
    Lightning = "rbxassetid://113425277383163",
    Bolt = "rbxassetid://113425277383163",
}

-- Colors (Black, White, Blue, Purple theme)
local Colors = {
    -- Backgrounds
    Background = Color3.fromRGB(8, 8, 14),
    BackgroundDark = Color3.fromRGB(4, 4, 8),
    BackgroundLight = Color3.fromRGB(16, 16, 24),
    
    -- Surfaces
    Surface = Color3.fromRGB(14, 14, 22),
    SurfaceLight = Color3.fromRGB(24, 24, 36),
    SurfaceHover = Color3.fromRGB(34, 34, 50),
    SurfaceDark = Color3.fromRGB(10, 10, 16),
    
    -- Accents - Blue
    Blue = Color3.fromRGB(50, 120, 255),
    BlueDark = Color3.fromRGB(35, 90, 200),
    BlueLight = Color3.fromRGB(90, 155, 255),
    BlueGlow = Color3.fromRGB(50, 120, 255),
    
    -- Accents - Purple
    Purple = Color3.fromRGB(140, 70, 255),
    PurpleDark = Color3.fromRGB(110, 50, 200),
    PurpleLight = Color3.fromRGB(175, 115, 255),
    PurpleGlow = Color3.fromRGB(140, 70, 255),
    
    -- Text
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(175, 175, 195),
    TextDark = Color3.fromRGB(110, 110, 140),
    TextMuted = Color3.fromRGB(80, 80, 105),
    
    -- Borders
    Border = Color3.fromRGB(35, 35, 55),
    BorderLight = Color3.fromRGB(55, 55, 85),
    BorderAccent = Color3.fromRGB(70, 90, 160),
    
    -- Status
    Success = Color3.fromRGB(70, 210, 110),
    Error = Color3.fromRGB(255, 75, 75),
    Warning = Color3.fromRGB(255, 195, 70),
    Info = Color3.fromRGB(70, 150, 255),
}

-- Utility: Create Instance with better error handling
local function Create(class, props)
    local success, inst = pcall(function()
        return Instance.new(class)
    end)
    if not success then return nil end
    
    for k, v in pairs(props) do
        if k ~= "Parent" then
            pcall(function() inst[k] = v end)
        end
    end
    if props.Parent then
        inst.Parent = props.Parent
    end
    return inst
end

-- Utility: Smooth Tween with style options
local function Tween(obj, props, duration, style, direction)
    duration = duration or 0.25
    style = style or Enum.EasingStyle.Quint
    direction = direction or Enum.EasingDirection.Out
    local tween = TweenService:Create(obj, TweenInfo.new(duration, style, direction), props)
    tween:Play()
    return tween
end

-- Utility: Add Corner
local function Corner(parent, radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 8),
        Parent = parent
    })
end

-- Utility: Add Stroke
local function Stroke(parent, color, thickness, transparency)
    return Create("UIStroke", {
        Color = color or Colors.Border,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        Parent = parent
    })
end

-- Utility: Add Gradient
local function Gradient(parent, colors, rotation)
    local colorSeq = {}
    for i, col in ipairs(colors) do
        table.insert(colorSeq, ColorSequenceKeypoint.new((i-1)/(math.max(#colors-1, 1)), col))
    end
    return Create("UIGradient", {
        Color = ColorSequence.new(colorSeq),
        Rotation = rotation or 90,
        Parent = parent
    })
end

-- Utility: Add Shadow
local function AddShadow(parent, transparency, size)
    return Create("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, size or 40, 1, size or 40),
        ZIndex = -1,
        Image = Assets.Shadow,
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = transparency or 0.5,
        Parent = parent
    })
end

-- Utility: Add Glow
local function AddGlow(parent, color, transparency, size)
    return Create("ImageLabel", {
        Name = "Glow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, size or 20, 1, size or 20),
        ZIndex = -1,
        Image = Assets.Glow,
        ImageColor3 = color or Colors.BlueGlow,
        ImageTransparency = transparency or 0.88,
        Parent = parent
    })
end

-- Utility: Ripple Effect
local function CreateRipple(parent, x, y)
    local ripple = Create("Frame", {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.75,
        Position = UDim2.new(0, x - parent.AbsolutePosition.X, 0, y - parent.AbsolutePosition.Y),
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = 20,
        Parent = parent
    })
    Corner(ripple, 100)
    
    local maxSize = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2.5
    Tween(ripple, {Size = UDim2.new(0, maxSize, 0, maxSize), BackgroundTransparency = 1}, 0.6)
    
    task.delay(0.6, function()
        if ripple then ripple:Destroy() end
    end)
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
    
    local ok, data = pcall(function()
        return HttpService:JSONDecode(content)
    end)
    
    if not ok then return false end
    
    for flag, info in pairs(data) do
        if info.Type == "Color3" then
            self.Flags[flag] = Color3.new(info.R, info.G, info.B)
        elseif info.Type == "EnumItem" then
            pcall(function()
                self.Flags[flag] = Enum[info.EnumType][info.Name]
            end)
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
        pcall(function()
            for _, file in ipairs(listfiles(self.ConfigFolder)) do
                if file:match("%.json$") then
                    local name = file:match("([^/\\]+)%.json$")
                    if name then
                        table.insert(configs, name)
                    end
                end
            end
        end)
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

-- Notification System
local NotifyGui, NotifyHolder

function Lieris:Notify(options)
    options = options or {}
    local Title = options.Title or "Notification"
    local Content = options.Content or ""
    local Duration = options.Duration or 4
    local Type = options.Type or "Info"
    
    local accentColor = Colors.Blue
    if Type == "Success" then accentColor = Colors.Success
    elseif Type == "Error" then accentColor = Colors.Error
    elseif Type == "Warning" then accentColor = Colors.Warning
    elseif Type == "Purple" then accentColor = Colors.Purple end
    
    if not NotifyGui then
        NotifyGui = Create("ScreenGui", {
            Name = "LierisNotifications",
            ResetOnSpawn = false,
            DisplayOrder = 1001,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        })
        pcall(function() NotifyGui.Parent = CoreGui end)
        if not NotifyGui.Parent then 
            NotifyGui.Parent = LocalPlayer:WaitForChild("PlayerGui") 
        end
        
        NotifyHolder = Create("Frame", {
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -20, 1, -20),
            AnchorPoint = Vector2.new(1, 1),
            Size = UDim2.new(0, 320, 1, -40),
            Parent = NotifyGui
        })
        
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Padding = UDim.new(0, 10),
            Parent = NotifyHolder
        })
    end
    
    -- Notification Frame
    local Notif = Create("Frame", {
        BackgroundColor3 = Colors.Surface,
        Size = UDim2.new(1, 0, 0, 0),
        ClipsDescendants = true,
        Parent = NotifyHolder
    })
    Corner(Notif, 10)
    Stroke(Notif, Colors.Border, 1, 0.4)
    
    -- Glow effect
    AddGlow(Notif, accentColor, 0.9, 20)
    
    -- Accent bar on left
    local AccentBar = Create("Frame", {
        BackgroundColor3 = accentColor,
        Size = UDim2.new(0, 4, 1, -16),
        Position = UDim2.new(0, 8, 0, 8),
        Parent = Notif
    })
    Corner(AccentBar, 2)
    
    -- Title
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 22, 0, 12),
        Size = UDim2.new(1, -32, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = Title,
        TextColor3 = Colors.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Notif
    })
    
    -- Content
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 22, 0, 34),
        Size = UDim2.new(1, -32, 0, 38),
        Font = Enum.Font.Gotham,
        Text = Content,
        TextColor3 = Colors.TextDim,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        Parent = Notif
    })
    
    -- Progress bar at bottom
    local ProgressBg = Create("Frame", {
        BackgroundColor3 = Colors.Border,
        Size = UDim2.new(1, -16, 0, 3),
        Position = UDim2.new(0, 8, 1, -8),
        Parent = Notif
    })
    Corner(ProgressBg, 2)
    
    local ProgressBar = Create("Frame", {
        BackgroundColor3 = accentColor,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = ProgressBg
    })
    Corner(ProgressBar, 2)
    
    -- Animate in
    Tween(Notif, {Size = UDim2.new(1, 0, 0, 85)}, 0.35, Enum.EasingStyle.Back)
    
    -- Progress animation
    task.delay(0.1, function()
        Tween(ProgressBar, {Size = UDim2.new(0, 0, 1, 0)}, Duration - 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
    end)
    
    -- Animate out
    task.delay(Duration, function()
        Tween(Notif, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.delay(0.35, function()
            if Notif then Notif:Destroy() end
        end)
    end)
end

-- Main Window Creation
function Lieris:CreateWindow(options)
    options = options or {}
    local Title = options.Name or options.Title or "Lieris UI"
    local ConfigFolder = options.ConfigFolder or "LierisConfigs"
    local Size = options.Size or UDim2.new(0, 680, 0, 450)
    
    Lieris.ConfigFolder = ConfigFolder
    EnsureFolder()
    
    local savedPos = nil
    local minimized = false
    local originalSize = Size
    
    -- Screen GUI
    local ScreenGui = Create("ScreenGui", {
        Name = "LierisUI_" .. HttpService:GenerateGUID(false),
        ResetOnSpawn = false,
        DisplayOrder = 100,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then 
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") 
    end
    
    -- Main Container
    local Main = Create("Frame", {
        Name = "Main",
        BackgroundColor3 = Colors.Background,
        Position = UDim2.new(0.5, -Size.X.Offset/2, 0.5, -Size.Y.Offset/2),
        Size = Size,
        Parent = ScreenGui
    })
    Corner(Main, 14)
    
    -- Big soft shadow
    AddShadow(Main, 0.35, 70)
    
    -- Outer glow (subtle blue/purple)
    local OuterGlow = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, 100, 1, 100),
        ZIndex = -2,
        Image = Assets.Glow,
        ImageColor3 = Colors.Blue,
        ImageTransparency = 0.92,
        Parent = Main
    })
    
    -- Background Image (with overlay)
    local BGContainer = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ClipsDescendants = true,
        ZIndex = 0,
        Parent = Main
    })
    Corner(BGContainer, 14)
    
    local BGImage = Create("ImageLabel", {
        Name = "BackgroundImage",
        BackgroundTransparency = 1,
        Size = UDim2.new(1.1, 0, 1.1, 0),
        Position = UDim2.new(-0.05, 0, -0.05, 0),
        Image = Assets.Background,
        ImageTransparency = 0.88,
        ScaleType = Enum.ScaleType.Crop,
        ZIndex = 0,
        Parent = BGContainer
    })
    
    -- Gradient overlay for depth
    local GradientOverlay = Create("Frame", {
        BackgroundColor3 = Colors.Background,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 1,
        Parent = Main
    })
    Corner(GradientOverlay, 14)
    Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.15),
            NumberSequenceKeypoint.new(0.5, 0.4),
            NumberSequenceKeypoint.new(1, 0.15)
        }),
        Rotation = 45,
        Parent = GradientOverlay
    })
    
    -- Border with gradient
    local BorderFrame = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 100,
        Parent = Main
    })
    Corner(BorderFrame, 14)
    local BorderStroke = Stroke(BorderFrame, Colors.Border, 1.5, 0.2)
    Gradient(BorderStroke, {Colors.Blue, Colors.Purple, Colors.Blue}, 45)
    
    -- Title Bar
    local TitleBar = Create("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = Colors.Surface,
        BackgroundTransparency = 0.2,
        Size = UDim2.new(1, 0, 0, 54),
        ZIndex = 10,
        Parent = Main
    })
    Create("UICorner", {
        CornerRadius = UDim.new(0, 14),
        Parent = TitleBar
    })
    
    -- Fix title bar bottom corners
    local TitleBarBottom = Create("Frame", {
        BackgroundColor3 = Colors.Surface,
        BackgroundTransparency = 0.2,
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 0, 1, -14),
        ZIndex = 10,
        Parent = TitleBar
    })
    
    -- Dragging functionality
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
    
    -- Logo with glow
    local LogoContainer = Create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 14, 0, 12),
        Size = UDim2.new(0, 30, 0, 30),
        ZIndex = 11,
        Parent = TitleBar
    })
    
    local LogoGlow = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, 16, 1, 16),
        Image = Assets.Glow,
        ImageColor3 = Colors.Blue,
        ImageTransparency = 0.7,
        ZIndex = 11,
        Parent = LogoContainer
    })
    
    local Logo = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Image = Assets.Logo,
        ZIndex = 12,
        Parent = LogoContainer
    })
    Corner(Logo, 6)
    
    -- Title Text
    local TitleLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 52, 0, 0),
        Size = UDim2.new(1, -160, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = Title,
        TextColor3 = Colors.Text,
        TextSize = 17,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 12,
        Parent = TitleBar
    })
    
    -- Window Buttons Container
    local ButtonsContainer = Create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -95, 0, 12),
        Size = UDim2.new(0, 80, 0, 30),
        ZIndex = 11,
        Parent = TitleBar
    })
    
    -- Minimize Button
    local MinBtn = Create("ImageButton", {
        BackgroundColor3 = Colors.SurfaceLight,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 34, 0, 30),
        Image = Assets.MinimizeButton,
        ImageColor3 = Colors.TextDim,
        ZIndex = 12,
        Parent = ButtonsContainer
    })
    Corner(MinBtn, 8)
    
    MinBtn.MouseEnter:Connect(function()
        Tween(MinBtn, {BackgroundTransparency = 0.4, ImageColor3 = Colors.Text}, 0.2)
    end)
    MinBtn.MouseLeave:Connect(function()
        Tween(MinBtn, {BackgroundTransparency = 1, ImageColor3 = Colors.TextDim}, 0.2)
    end)
    
    -- Close Button
    local CloseBtn = Create("ImageButton", {
        BackgroundColor3 = Colors.Error,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 42, 0, 0),
        Size = UDim2.new(0, 34, 0, 30),
        Image = Assets.CloseButton,
        ImageColor3 = Colors.TextDim,
        ZIndex = 12,
        Parent = ButtonsContainer
    })
    Corner(CloseBtn, 8)
    
    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, {BackgroundTransparency = 0.2, ImageColor3 = Colors.Text}, 0.2)
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, {BackgroundTransparency = 1, ImageColor3 = Colors.TextDim}, 0.2)
    end)
    
    -- Title Bar Accent Line
    local AccentLine = Create("Frame", {
        BackgroundColor3 = Colors.Blue,
        Position = UDim2.new(0, 0, 1, -2),
        Size = UDim2.new(1, 0, 0, 2),
        ZIndex = 11,
        Parent = TitleBar
    })
    Gradient(AccentLine, {Colors.Blue, Colors.Purple, Colors.Blue}, 0)
    
    -- Content Area
    local ContentArea = Create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 54),
        Size = UDim2.new(1, 0, 1, -54),
        ZIndex = 5,
        Parent = Main
    })
    
    -- Tab Container (Left side)
    local TabContainer = Create("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = Colors.Surface,
        BackgroundTransparency = 0.4,
        Position = UDim2.new(0, 10, 0, 8),
        Size = UDim2.new(0, 145, 1, -16),
        ZIndex = 6,
        Parent = ContentArea
    })
    Corner(TabContainer, 12)
    Stroke(TabContainer, Colors.Border, 1, 0.6)
    
    local TabScroll = Create("ScrollingFrame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 6, 0, 8),
        Size = UDim2.new(1, -12, 1, -16),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Colors.Border,
        ScrollBarImageTransparency = 0.4,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 7,
        Parent = TabContainer
    })
    
    Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        Parent = TabScroll
    })
    
    -- Content Container (Right side)
    local ContentContainer = Create("Frame", {
        Name = "ContentContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 165, 0, 8),
        Size = UDim2.new(1, -175, 1, -16),
        ZIndex = 6,
        Parent = ContentArea
    })
    
    -- Window Object
    local Window = {}
    local Tabs = {}
    local CurrentTab = nil
    
    -- Toggle UI
    function Window:ToggleUI()
        Main.Visible = not Main.Visible
        if Main.Visible and savedPos then
            Main.Position = savedPos
        end
    end
    
    -- Destroy
    function Window:Destroy()
        ScreenGui:Destroy()
    end
    
    -- Minimize handler
    MinBtn.MouseButton1Click:Connect(function()
        CreateRipple(MinBtn, UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
        minimized = not minimized
        if minimized then
            Tween(Main, {Size = UDim2.new(0, originalSize.X.Offset, 0, 54)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        else
            Tween(Main, {Size = originalSize}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end
    end)
    
    -- Close handler
    CloseBtn.MouseButton1Click:Connect(function()
        CreateRipple(CloseBtn, UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
        savedPos = Main.Position
        Tween(Main, {Size = UDim2.new(0, originalSize.X.Offset, 0, 0), BackgroundTransparency = 1}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.delay(0.3, function()
            Main.Visible = false
            Main.Size = originalSize
            Main.BackgroundTransparency = 0
        end)
    end)
    
    -- Toggle hotkey
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Lieris.ToggleKey then
            if not Main.Visible then
                Main.Visible = true
                Main.Size = UDim2.new(0, originalSize.X.Offset, 0, 0)
                Main.BackgroundTransparency = 0
                if savedPos then Main.Position = savedPos end
                Tween(Main, {Size = originalSize}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            else
                savedPos = Main.Position
                Tween(Main, {Size = UDim2.new(0, originalSize.X.Offset, 0, 0)}, 0.28, Enum.EasingStyle.Quint)
                task.delay(0.28, function()
                    Main.Visible = false
                    Main.Size = originalSize
                end)
            end
        end
    end)
    
    -- Create Tab Function
    function Window:CreateTab(tabOptions)
        tabOptions = tabOptions or {}
        local TabName = tabOptions.Name or "Tab"
        local TabIcon = tabOptions.Icon
        
        -- Tab Button
        local TabBtn = Create("TextButton", {
            BackgroundColor3 = Colors.Blue,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 38),
            Text = "",
            AutoButtonColor = false,
            ZIndex = 8,
            ClipsDescendants = true,
            Parent = TabScroll
        })
        Corner(TabBtn, 8)
        
        -- Tab Icon (if provided)
        local IconLabel
        if TabIcon then
            IconLabel = Create("ImageLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0.5, -9),
                Size = UDim2.new(0, 18, 0, 18),
                Image = TabIcon,
                ImageColor3 = Colors.TextDim,
                ZIndex = 9,
                Parent = TabBtn
            })
        end
        
        -- Tab Text
        local TabText = Create("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, TabIcon and 36 or 14, 0, 0),
            Size = UDim2.new(1, TabIcon and -48 or -28, 1, 0),
            Font = Enum.Font.GothamMedium,
            Text = TabName,
            TextColor3 = Colors.TextDim,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 9,
            Parent = TabBtn
        })
        
        -- Active indicator (left bar)
        local Indicator = Create("Frame", {
            BackgroundColor3 = Colors.Blue,
            Position = UDim2.new(0, 0, 0.5, -12),
            Size = UDim2.new(0, 3, 0, 24),
            ZIndex = 9,
            Visible = false,
            Parent = TabBtn
        })
        Corner(Indicator, 2)
        Gradient(Indicator, {Colors.Blue, Colors.Purple}, 90)
        
        -- Tab Page
        local TabPage = Create("ScrollingFrame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Colors.Blue,
            ScrollBarImageTransparency = 0.4,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            ZIndex = 7,
            Parent = ContentContainer
        })
        
        Create("UIListLayout", {
            Padding = UDim.new(0, 10),
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Parent = TabPage
        })
        
        Create("UIPadding", {
            PaddingTop = UDim.new(0, 4),
            PaddingBottom = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 6),
            Parent = TabPage
        })
        
        -- Tab Activation
        local function Activate()
            for _, t in pairs(Tabs) do
                t.Page.Visible = false
                Tween(t.Button, {BackgroundTransparency = 1}, 0.2)
                Tween(t.Text, {TextColor3 = Colors.TextDim}, 0.2)
                if t.Icon then Tween(t.Icon, {ImageColor3 = Colors.TextDim}, 0.2) end
                t.Indicator.Visible = false
            end
            
            TabPage.Visible = true
            Tween(TabBtn, {BackgroundTransparency = 0.82}, 0.25)
            Tween(TabText, {TextColor3 = Colors.Text}, 0.25)
            if IconLabel then Tween(IconLabel, {ImageColor3 = Colors.Text}, 0.25) end
            Indicator.Visible = true
            CurrentTab = TabName
        end
        
        TabBtn.MouseButton1Click:Connect(function()
            CreateRipple(TabBtn, UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
            Activate()
        end)
        
        TabBtn.MouseEnter:Connect(function()
            if CurrentTab ~= TabName then
                Tween(TabBtn, {BackgroundTransparency = 0.88}, 0.15)
                Tween(TabText, {TextColor3 = Colors.TextDim}, 0.15)
            end
        end)
        
        TabBtn.MouseLeave:Connect(function()
            if CurrentTab ~= TabName then
                Tween(TabBtn, {BackgroundTransparency = 1}, 0.15)
            end
        end)
        
        table.insert(Tabs, {
            Button = TabBtn, 
            Page = TabPage, 
            Text = TabText, 
            Icon = IconLabel, 
            Indicator = Indicator, 
            Name = TabName
        })
        
        if #Tabs == 1 then
            task.defer(Activate)
        end
        
        -- Tab Object
        local Tab = {}
        
        -- Create Section
        function Tab:CreateSection(sectionName)
            sectionName = sectionName or "Section"
            
            local Section = Create("Frame", {
                BackgroundColor3 = Colors.Surface,
                BackgroundTransparency = 0.3,
                Size = UDim2.new(1, 0, 0, 45),
                ZIndex = 8,
                Parent = TabPage
            })
            Corner(Section, 12)
            Stroke(Section, Colors.Border, 1, 0.4)
            
            -- Subtle glow
            AddGlow(Section, Colors.Blue, 0.94, 12)
            
            -- Header
            local Header = Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 38),
                ZIndex = 9,
                Parent = Section
            })
            
            -- Section title with subtle accent
            local TitleBg = Create("Frame", {
                BackgroundColor3 = Colors.Blue,
                BackgroundTransparency = 0.9,
                Position = UDim2.new(0, 12, 0, 8),
                Size = UDim2.new(0, 0, 0, 22),
                ZIndex = 9,
                Parent = Header
            })
            Corner(TitleBg, 6)
            
            local SectionTitle = Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 16, 0, 8),
                Size = UDim2.new(1, -32, 0, 22),
                Font = Enum.Font.GothamBold,
                Text = sectionName,
                TextColor3 = Colors.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 10,
                Parent = Header
            })
            
            -- Auto-size title background
            task.defer(function()
                local textSize = TextService:GetTextSize(sectionName, 14, Enum.Font.GothamBold, Vector2.new(1000, 22))
                Tween(TitleBg, {Size = UDim2.new(0, textSize.X + 18, 0, 22)}, 0.3)
            end)
            
            -- Content holder
            local Content = Create("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 38),
                Size = UDim2.new(1, 0, 0, 0),
                ZIndex = 9,
                Parent = Section
            })
            
            local ContentLayout = Create("UIListLayout", {
                Padding = UDim.new(0, 7),
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Parent = Content
            })
            
            Create("UIPadding", {
                PaddingBottom = UDim.new(0, 14),
                PaddingLeft = UDim.new(0, 14),
                PaddingRight = UDim.new(0, 14),
                Parent = Content
            })
            
            -- Auto resize section
            ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Content.Size = UDim2.new(1, 0, 0, ContentLayout.AbsoluteContentSize.Y + 14)
                Section.Size = UDim2.new(1, 0, 0, 38 + ContentLayout.AbsoluteContentSize.Y + 14)
            end)
            
            -- Elements object
            local Elements = {}
            
            -- LABEL
            function Elements:CreateLabel(text)
                local Label = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 22),
                    Font = Enum.Font.Gotham,
                    Text = text or "Label",
                    TextColor3 = Colors.TextDim,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 10,
                    Parent = Content
                })
                
                local Obj = {}
                function Obj:Set(t) Label.Text = t end
                function Obj:Get() return Label.Text end
                return Obj
            end
            
            -- BUTTON
            function Elements:CreateButton(props)
                props = props or {}
                local Name = props.Name or "Button"
                local Callback = props.Callback or function() end
                
                local Btn = Create("TextButton", {
                    BackgroundColor3 = Colors.SurfaceLight,
                    Size = UDim2.new(1, 0, 0, 36),
                    Font = Enum.Font.GothamMedium,
                    Text = Name,
                    TextColor3 = Colors.Text,
                    TextSize = 13,
                    AutoButtonColor = false,
                    ZIndex = 10,
                    ClipsDescendants = true,
                    Parent = Content
                })
                Corner(Btn, 8)
                Stroke(Btn, Colors.Border, 1, 0.5)
                
                -- Hover gradient effect
                local HoverGrad = Gradient(Btn, {Colors.SurfaceLight, Colors.SurfaceLight}, 0)
                
                Btn.MouseEnter:Connect(function()
                    Tween(Btn, {BackgroundColor3 = Colors.Blue}, 0.25)
                    HoverGrad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Colors.Blue),
                        ColorSequenceKeypoint.new(1, Colors.Purple)
                    })
                end)
                Btn.MouseLeave:Connect(function()
                    Tween(Btn, {BackgroundColor3 = Colors.SurfaceLight}, 0.25)
                    HoverGrad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Colors.SurfaceLight),
                        ColorSequenceKeypoint.new(1, Colors.SurfaceLight)
                    })
                end)
                Btn.MouseButton1Click:Connect(function()
                    CreateRipple(Btn, UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                    pcall(Callback)
                end)
                
                local Obj = {}
                function Obj:SetText(t) Btn.Text = t end
                return Obj
            end
            
            -- TOGGLE
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
                    Size = UDim2.new(1, 0, 0, 36),
                    ZIndex = 10,
                    Parent = Content
                })
                Corner(Frame, 8)
                Stroke(Frame, Colors.Border, 1, 0.5)
                
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 0),
                    Size = UDim2.new(1, -70, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = Name,
                    TextColor3 = Colors.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 11,
                    Parent = Frame
                })
                
                local Toggle = Create("Frame", {
                    BackgroundColor3 = Value and Colors.Blue or Colors.Background,
                    Position = UDim2.new(1, -56, 0.5, -12),
                    Size = UDim2.new(0, 44, 0, 24),
                    ZIndex = 11,
                    Parent = Frame
                })
                Corner(Toggle, 12)
                local ToggleStroke = Stroke(Toggle, Value and Colors.Blue or Colors.Border, 1, 0.3)
                
                -- Add glow when on
                local ToggleGlow = AddGlow(Toggle, Colors.Blue, Value and 0.7 or 1, 12)
                
                local Circle = Create("Frame", {
                    BackgroundColor3 = Colors.Text,
                    Position = Value and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10),
                    Size = UDim2.new(0, 20, 0, 20),
                    ZIndex = 12,
                    Parent = Toggle
                })
                Corner(Circle, 10)
                AddShadow(Circle, 0.6, 6)
                
                local ToggleBtn = Create("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    ZIndex = 13,
                    Parent = Frame
                })
                
                local function Update()
                    Tween(Toggle, {BackgroundColor3 = Value and Colors.Blue or Colors.Background}, 0.25)
                    Tween(Circle, {Position = Value and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}, 0.25, Enum.EasingStyle.Back)
                    Tween(ToggleStroke, {Color = Value and Colors.Blue or Colors.Border}, 0.25)
                    Tween(ToggleGlow, {ImageTransparency = Value and 0.7 or 1}, 0.25)
                end
                
                ToggleBtn.MouseButton1Click:Connect(function()
                    Value = not Value
                    Lieris.Flags[Flag] = Value
                    Update()
                    pcall(Callback, Value)
                end)
                
                Frame.MouseEnter:Connect(function()
                    Tween(Frame, {BackgroundColor3 = Colors.SurfaceHover}, 0.15)
                end)
                Frame.MouseLeave:Connect(function()
                    Tween(Frame, {BackgroundColor3 = Colors.SurfaceLight}, 0.15)
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
            
            -- SLIDER
            function Elements:CreateSlider(props)
                props = props or {}
                local Name = props.Name or "Slider"
                local Min = props.Min or 0
                local Max = props.Max or 100
                local Default = props.Default or Min
                local Increment = props.Increment or 1
                local Flag = props.Flag or Name
                local Suffix = props.Suffix or ""
                local Callback = props.Callback or function() end
                
                local Value = Default
                Lieris.Flags[Flag] = Value
                Lieris._callbacks[Flag] = Callback
                
                local Frame = Create("Frame", {
                    BackgroundColor3 = Colors.SurfaceLight,
                    Size = UDim2.new(1, 0, 0, 56),
                    ZIndex = 10,
                    Parent = Content
                })
                Corner(Frame, 8)
                Stroke(Frame, Colors.Border, 1, 0.5)
                
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 8),
                    Size = UDim2.new(0.6, 0, 0, 18),
                    Font = Enum.Font.Gotham,
                    Text = Name,
                    TextColor3 = Colors.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 11,
                    Parent = Frame
                })
                
                local ValueLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.6, 0, 0, 8),
                    Size = UDim2.new(0.4, -14, 0, 18),
                    Font = Enum.Font.GothamBold,
                    Text = tostring(Value) .. Suffix,
                    TextColor3 = Colors.Blue,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    ZIndex = 11,
                    Parent = Frame
                })
                
                local Bar = Create("Frame", {
                    BackgroundColor3 = Colors.Background,
                    Position = UDim2.new(0, 14, 0, 34),
                    Size = UDim2.new(1, -28, 0, 10),
                    ZIndex = 11,
                    Parent = Frame
                })
                Corner(Bar, 5)
                
                local Fill = Create("Frame", {
                    BackgroundColor3 = Colors.Blue,
                    Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0),
                    ZIndex = 12,
                    Parent = Bar
                })
                Corner(Fill, 5)
                Gradient(Fill, {Colors.Blue, Colors.Purple}, 0)
                
                -- Glow on fill
                local FillGlow = Create("Frame", {
                    BackgroundColor3 = Colors.Blue,
                    BackgroundTransparency = 0.5,
                    Size = UDim2.new(1, 0, 1, 4),
                    Position = UDim2.new(0, 0, 0, -2),
                    ZIndex = 11,
                    Parent = Fill
                })
                Corner(FillGlow, 5)
                
                local Knob = Create("Frame", {
                    BackgroundColor3 = Colors.Text,
                    Position = UDim2.new((Default - Min) / (Max - Min), -9, 0.5, -9),
                    Size = UDim2.new(0, 18, 0, 18),
                    ZIndex = 13,
                    Parent = Bar
                })
                Corner(Knob, 9)
                AddShadow(Knob, 0.5, 10)
                Stroke(Knob, Colors.Blue, 2, 0.3)
                
                local isDragging = false
                
                local function UpdateSlider(input)
                    local percent = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    local raw = Min + ((Max - Min) * percent)
                    Value = math.floor(raw / Increment + 0.5) * Increment
                    Value = math.clamp(Value, Min, Max)
                    
                    local p = (Value - Min) / (Max - Min)
                    Lieris.Flags[Flag] = Value
                    ValueLabel.Text = tostring(Value) .. Suffix
                    Tween(Fill, {Size = UDim2.new(p, 0, 1, 0)}, 0.05)
                    Tween(Knob, {Position = UDim2.new(p, -9, 0.5, -9)}, 0.05)
                    
                    pcall(Callback, Value)
                end
                
                Bar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        isDragging = true
                        UpdateSlider(input)
                    end
                end)
                
                Knob.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        isDragging = true
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        UpdateSlider(input)
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
                    ValueLabel.Text = tostring(Value) .. Suffix
                    Fill.Size = UDim2.new(p, 0, 1, 0)
                    Knob.Position = UDim2.new(p, -9, 0.5, -9)
                end
                function Obj:Get() return Value end
                
                Lieris._elements[Flag] = Obj
                return Obj
            end
            
            -- INPUT
            function Elements:CreateInput(props)
                props = props or {}
                local Name = props.Name or "Input"
                local Default = props.Default or ""
                local Placeholder = props.PlaceholderText or "Type here..."
                local Flag = props.Flag or Name
                local Callback = props.Callback or function() end
                
                Lieris.Flags[Flag] = Default
                Lieris._callbacks[Flag] = Callback
                
                local Frame = Create("Frame", {
                    BackgroundColor3 = Colors.SurfaceLight,
                    Size = UDim2.new(1, 0, 0, 36),
                    ZIndex = 10,
                    Parent = Content
                })
                Corner(Frame, 8)
                Stroke(Frame, Colors.Border, 1, 0.5)
                
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 0),
                    Size = UDim2.new(0.4, 0, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = Name,
                    TextColor3 = Colors.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 11,
                    Parent = Frame
                })
                
                local Box = Create("TextBox", {
                    BackgroundColor3 = Colors.Background,
                    Position = UDim2.new(0.4, 6, 0.5, -14),
                    Size = UDim2.new(0.6, -20, 0, 28),
                    Font = Enum.Font.Gotham,
                    PlaceholderText = Placeholder,
                    PlaceholderColor3 = Colors.TextDark,
                    Text = Default,
                    TextColor3 = Colors.Text,
                    TextSize = 12,
                    ClearTextOnFocus = false,
                    ZIndex = 11,
                    Parent = Frame
                })
                Corner(Box, 6)
                Stroke(Box, Colors.Border, 1, 0.6)
                
                Box.Focused:Connect(function()
                    Tween(Box, {BackgroundColor3 = Colors.BackgroundLight}, 0.15)
                    local stroke = Box:FindFirstChildOfClass("UIStroke")
                    if stroke then Tween(stroke, {Color = Colors.Blue, Transparency = 0}, 0.15) end
                end)
                Box.FocusLost:Connect(function()
                    Tween(Box, {BackgroundColor3 = Colors.Background}, 0.15)
                    local stroke = Box:FindFirstChildOfClass("UIStroke")
                    if stroke then Tween(stroke, {Color = Colors.Border, Transparency = 0.6}, 0.15) end
                    Lieris.Flags[Flag] = Box.Text
                    pcall(Callback, Box.Text)
                end)
                
                local Obj = {}
                function Obj:Set(t) Box.Text = t; Lieris.Flags[Flag] = t end
                function Obj:Get() return Box.Text end
                
                Lieris._elements[Flag] = Obj
                return Obj
            end
            
            -- DROPDOWN
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
                    Size = UDim2.new(1, 0, 0, 36),
                    ClipsDescendants = true,
                    ZIndex = 10,
                    Parent = Content
                })
                Corner(Frame, 8)
                Stroke(Frame, Colors.Border, 1, 0.5)
                
                local Header = Create("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 36),
                    Text = "",
                    ZIndex = 11,
                    Parent = Frame
                })
                
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 0),
                    Size = UDim2.new(0.5, 0, 0, 36),
                    Font = Enum.Font.Gotham,
                    Text = Name,
                    TextColor3 = Colors.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 12,
                    Parent = Header
                })
                
                local SelectedLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0, 0),
                    Size = UDim2.new(0.5, -36, 0, 36),
                    Font = Enum.Font.GothamMedium,
                    Text = Selected,
                    TextColor3 = Colors.Blue,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    ZIndex = 12,
                    Parent = Header
                })
                
                local Arrow = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -30, 0, 0),
                    Size = UDim2.new(0, 22, 0, 36),
                    Font = Enum.Font.GothamBold,
                    Text = "v",
                    TextColor3 = Colors.TextDim,
                    TextSize = 12,
                    ZIndex = 12,
                    Parent = Header
                })
                
                local OptionsList = Create("Frame", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0, 42),
                    Size = UDim2.new(1, -16, 0, #Options * 32),
                    ZIndex = 11,
                    Parent = Frame
                })
                
                Create("UIListLayout", {
                    Padding = UDim.new(0, 4),
                    Parent = OptionsList
                })
                
                local function CreateOption(optName)
                    local OptBtn = Create("TextButton", {
                        BackgroundColor3 = Colors.Background,
                        BackgroundTransparency = optName == Selected and 0 or 1,
                        Size = UDim2.new(1, 0, 0, 28),
                        Font = Enum.Font.Gotham,
                        Text = optName,
                        TextColor3 = optName == Selected and Colors.Blue or Colors.TextDim,
                        TextSize = 12,
                        AutoButtonColor = false,
                        ZIndex = 12,
                        Parent = OptionsList
                    })
                    Corner(OptBtn, 6)
                    
                    OptBtn.MouseEnter:Connect(function()
                        if Selected ~= optName then
                            Tween(OptBtn, {BackgroundTransparency = 0.5, TextColor3 = Colors.Text}, 0.12)
                        end
                    end)
                    
                    OptBtn.MouseLeave:Connect(function()
                        if Selected ~= optName then
                            Tween(OptBtn, {BackgroundTransparency = 1, TextColor3 = Colors.TextDim}, 0.12)
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
                                    TextColor3 = isSel and Colors.Blue or Colors.TextDim
                                }, 0.15)
                            end
                        end
                        
                        isOpen = false
                        Tween(Frame, {Size = UDim2.new(1, 0, 0, 36)}, 0.25, Enum.EasingStyle.Back)
                        Tween(Arrow, {Rotation = 0}, 0.2)
                        
                        pcall(Callback, Selected)
                    end)
                end
                
                for _, opt in ipairs(Options) do
                    CreateOption(opt)
                end
                
                Header.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    if isOpen then
                        Tween(Frame, {Size = UDim2.new(1, 0, 0, 48 + #Options * 32)}, 0.3, Enum.EasingStyle.Back)
                        Tween(Arrow, {Rotation = 180}, 0.2)
                    else
                        Tween(Frame, {Size = UDim2.new(1, 0, 0, 36)}, 0.25)
                        Tween(Arrow, {Rotation = 0}, 0.2)
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
                            c.TextColor3 = isSel and Colors.Blue or Colors.TextDim
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
                    OptionsList.Size = UDim2.new(1, -16, 0, #Options * 32)
                    if isOpen then
                        Frame.Size = UDim2.new(1, 0, 0, 48 + #Options * 32)
                    end
                end
                
                Lieris._elements[Flag] = Obj
                return Obj
            end
            
            -- KEYBIND
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
                    Size = UDim2.new(1, 0, 0, 36),
                    ZIndex = 10,
                    Parent = Content
                })
                Corner(Frame, 8)
                Stroke(Frame, Colors.Border, 1, 0.5)
                
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 0),
                    Size = UDim2.new(1, -100, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = Name,
                    TextColor3 = Colors.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 11,
                    Parent = Frame
                })
                
                local KeyBtn = Create("TextButton", {
                    BackgroundColor3 = Colors.Background,
                    Position = UDim2.new(1, -86, 0.5, -14),
                    Size = UDim2.new(0, 72, 0, 28),
                    Font = Enum.Font.GothamBold,
                    Text = Key.Name,
                    TextColor3 = Colors.Blue,
                    TextSize = 11,
                    ZIndex = 11,
                    Parent = Frame
                })
                Corner(KeyBtn, 6)
                Stroke(KeyBtn, Colors.Border, 1, 0.5)
                
                KeyBtn.MouseButton1Click:Connect(function()
                    listening = true
                    KeyBtn.Text = "..."
                    Tween(KeyBtn, {TextColor3 = Colors.Warning, BackgroundColor3 = Colors.SurfaceHover}, 0.15)
                    local stroke = KeyBtn:FindFirstChildOfClass("UIStroke")
                    if stroke then Tween(stroke, {Color = Colors.Warning}, 0.15) end
                end)
                
                UserInputService.InputBegan:Connect(function(input, processed)
                    if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                        Key = input.KeyCode
                        Lieris.Flags[Flag] = Key
                        KeyBtn.Text = Key.Name
                        Tween(KeyBtn, {TextColor3 = Colors.Blue, BackgroundColor3 = Colors.Background}, 0.15)
                        local stroke = KeyBtn:FindFirstChildOfClass("UIStroke")
                        if stroke then Tween(stroke, {Color = Colors.Border}, 0.15) end
                        listening = false
                    elseif not processed and not listening and input.KeyCode == Key then
                        pcall(Callback)
                    end
                end)
                
                local Obj = {}
                function Obj:Set(k) Key = k; Lieris.Flags[Flag] = k; KeyBtn.Text = k.Name end
                function Obj:Get() return Key end
                
                Lieris._elements[Flag] = Obj
                return Obj
            end
            
            -- COLOR PICKER
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
                    Size = UDim2.new(1, 0, 0, 36),
                    ClipsDescendants = true,
                    ZIndex = 10,
                    Parent = Content
                })
                Corner(Frame, 8)
                Stroke(Frame, Colors.Border, 1, 0.5)
                
                local Header = Create("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 36),
                    Text = "",
                    ZIndex = 11,
                    Parent = Frame
                })
                
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 0),
                    Size = UDim2.new(1, -65, 0, 36),
                    Font = Enum.Font.Gotham,
                    Text = Name,
                    TextColor3 = Colors.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 12,
                    Parent = Header
                })
                
                local Preview = Create("Frame", {
                    BackgroundColor3 = Color,
                    Position = UDim2.new(1, -52, 0.5, -13),
                    Size = UDim2.new(0, 40, 0, 26),
                    ZIndex = 12,
                    Parent = Header
                })
                Corner(Preview, 6)
                Stroke(Preview, Colors.Border, 1, 0.3)
                AddGlow(Preview, Color, 0.6, 8)
                
                -- Picker Panel
                local Panel = Create("Frame", {
                    BackgroundColor3 = Colors.Background,
                    Position = UDim2.new(0, 10, 0, 44),
                    Size = UDim2.new(1, -20, 0, 170),
                    ZIndex = 11,
                    Parent = Frame
                })
                Corner(Panel, 10)
                
                -- SV Picker
                local SVPicker = Create("ImageLabel", {
                    BackgroundColor3 = Color3.fromHSV(H, 1, 1),
                    Position = UDim2.new(0, 10, 0, 10),
                    Size = UDim2.new(1, -58, 0, 115),
                    Image = "rbxassetid://4155801252",
                    ZIndex = 12,
                    Parent = Panel
                })
                Corner(SVPicker, 8)
                
                local SVCursor = Create("Frame", {
                    BackgroundColor3 = Colors.Text,
                    Position = UDim2.new(S, -7, 1 - V, -7),
                    Size = UDim2.new(0, 14, 0, 14),
                    ZIndex = 13,
                    Parent = SVPicker
                })
                Corner(SVCursor, 7)
                Stroke(SVCursor, Color3.new(0, 0, 0), 2)
                AddShadow(SVCursor, 0.5, 6)
                
                -- Hue Bar
                local HueBar = Create("Frame", {
                    BackgroundColor3 = Colors.Text,
                    Position = UDim2.new(1, -40, 0, 10),
                    Size = UDim2.new(0, 22, 0, 115),
                    ZIndex = 12,
                    Parent = Panel
                })
                Corner(HueBar, 6)
                
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
                    Position = UDim2.new(0.5, -9, H, -6),
                    Size = UDim2.new(0, 18, 0, 12),
                    ZIndex = 13,
                    Parent = HueBar
                })
                Corner(HueCursor, 4)
                Stroke(HueCursor, Color3.new(0, 0, 0), 2)
                
                -- Confirm Button
                local ConfirmBtn = Create("TextButton", {
                    BackgroundColor3 = Colors.Blue,
                    Position = UDim2.new(0, 10, 1, -38),
                    Size = UDim2.new(1, -20, 0, 30),
                    Font = Enum.Font.GothamBold,
                    Text = "Confirm",
                    TextColor3 = Colors.Text,
                    TextSize = 12,
                    AutoButtonColor = false,
                    ZIndex = 12,
                    ClipsDescendants = true,
                    Parent = Panel
                })
                Corner(ConfirmBtn, 8)
                Gradient(ConfirmBtn, {Colors.Blue, Colors.Purple}, 0)
                
                local function UpdateTemp()
                    TempColor = Color3.fromHSV(H, S, V)
                    SVPicker.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
                    Preview.BackgroundColor3 = TempColor
                    local glow = Preview:FindFirstChild("Glow")
                    if glow then glow.ImageColor3 = TempColor end
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
                            SVCursor.Position = UDim2.new(S, -7, 1 - V, -7)
                            UpdateTemp()
                        elseif draggingHue then
                            H = math.clamp((input.Position.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
                            HueCursor.Position = UDim2.new(0.5, -9, H, -6)
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
                        SVCursor.Position = UDim2.new(S, -7, 1 - V, -7)
                        HueCursor.Position = UDim2.new(0.5, -9, H, -6)
                        SVPicker.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
                        Tween(Frame, {Size = UDim2.new(1, 0, 0, 225)}, 0.3, Enum.EasingStyle.Back)
                    else
                        Preview.BackgroundColor3 = Color
                        local glow = Preview:FindFirstChild("Glow")
                        if glow then glow.ImageColor3 = Color end
                        Tween(Frame, {Size = UDim2.new(1, 0, 0, 36)}, 0.25)
                    end
                end)
                
                ConfirmBtn.MouseButton1Click:Connect(function()
                    CreateRipple(ConfirmBtn, UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                    Color = TempColor
                    Lieris.Flags[Flag] = Color
                    Preview.BackgroundColor3 = Color
                    local glow = Preview:FindFirstChild("Glow")
                    if glow then glow.ImageColor3 = Color end
                    isOpen = false
                    Tween(Frame, {Size = UDim2.new(1, 0, 0, 36)}, 0.25)
                    pcall(Callback, Color)
                end)
                
                ConfirmBtn.MouseEnter:Connect(function()
                    Tween(ConfirmBtn, {BackgroundColor3 = Colors.BlueDark}, 0.15)
                end)
                ConfirmBtn.MouseLeave:Connect(function()
                    Tween(ConfirmBtn, {BackgroundColor3 = Colors.Blue}, 0.15)
                end)
                
                local Obj = {}
                function Obj:Set(c)
                    Color = c
                    Lieris.Flags[Flag] = Color
                    Preview.BackgroundColor3 = Color
                    local glow = Preview:FindFirstChild("Glow")
                    if glow then glow.ImageColor3 = Color end
                end
                function Obj:Get() return Color end
                
                Lieris._elements[Flag] = Obj
                return Obj
            end
            
            -- PARAGRAPH
            function Elements:CreateParagraph(props)
                props = props or {}
                local Title = props.Title or "Title"
                local ContentText = props.Content or props.Text or ""
                
                local PFrame = Create("Frame", {
                    BackgroundColor3 = Colors.Background,
                    BackgroundTransparency = 0.3,
                    Size = UDim2.new(1, 0, 0, 58),
                    ZIndex = 10,
                    Parent = Content
                })
                Corner(PFrame, 8)
                
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 10),
                    Size = UDim2.new(1, -28, 0, 18),
                    Font = Enum.Font.GothamBold,
                    Text = Title,
                    TextColor3 = Colors.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 11,
                    Parent = PFrame
                })
                
                local ContentLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 30),
                    Size = UDim2.new(1, -28, 0, 22),
                    Font = Enum.Font.Gotham,
                    Text = ContentText,
                    TextColor3 = Colors.TextDim,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    ZIndex = 11,
                    Parent = PFrame
                })
                
                local Obj = {}
                function Obj:Set(title, content)
                    if title then PFrame:FindFirstChild("TextLabel").Text = title end
                    if content then ContentLabel.Text = content end
                end
                return Obj
            end
            
            -- DIVIDER
            function Elements:CreateDivider()
                local Div = Create("Frame", {
                    BackgroundColor3 = Colors.Border,
                    Size = UDim2.new(1, 0, 0, 2),
                    ZIndex = 10,
                    Parent = Content
                })
                Corner(Div, 1)
                Gradient(Div, {Color3.new(0,0,0), Colors.Blue, Colors.Purple, Colors.Blue, Color3.new(0,0,0)}, 0)
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
                if #configs > 0 then
                    ConfigDropdown:Refresh(configs)
                    ConfigDropdown:Set(Lieris.CurrentConfig)
                end
                Lieris:Notify({Title = "Config Saved", Content = "Saved: " .. Lieris.CurrentConfig, Type = "Success"})
            end
        end
    })
    
    ConfigSection:CreateButton({
        Name = "Load Config",
        Callback = function()
            if Lieris:LoadConfig(Lieris.CurrentConfig) then
                Lieris:Notify({Title = "Config Loaded", Content = "Loaded: " .. Lieris.CurrentConfig, Type = "Success"})
            end
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
                Lieris:Notify({Title = "Config Deleted", Content = "Config removed", Type = "Warning"})
            end
        end
    })
    
    local UISection = SettingsTab:CreateSection("Interface")
    
    UISection:CreateKeybind({
        Name = "Toggle UI",
        Default = Enum.KeyCode.H,
        Flag = "ToggleKey",
        Callback = function()
            -- Keybind visual only
        end
    })
    
    UISection:CreateParagraph({
        Title = "Lieris UI v" .. Lieris.Version,
        Content = "Press H to toggle the interface."
    })
    
    return Window
end

-- Export
Lieris.Colors = Colors
Lieris.Assets = Assets
Lieris.Icons = Icons

return Lieris
