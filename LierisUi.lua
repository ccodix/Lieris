--[[
================================================================================
    LIERIS UI LIBRARY v3.0
    A Clean, Smooth UI Library for Roblox Script Interfaces
================================================================================

    DOCUMENTATION & USAGE GUIDE
    
================================================================================
    TABLE OF CONTENTS
================================================================================
    1. GETTING STARTED
    2. CREATING A WINDOW
    3. CREATING TABS
    4. CREATING SECTIONS
    5. UI ELEMENTS
        5.1  Button
        5.2  Toggle
        5.3  Slider
        5.4  Dropdown
        5.5  Input (TextBox)
        5.6  Keybind
        5.7  Color Picker
        5.8  Label
        5.9  Paragraph
        5.10 Divider
    6. NOTIFICATIONS
    7. CONFIG SYSTEM
    8. THEME CUSTOMIZATION
    9. FLAGS SYSTEM
    10. UTILITY FUNCTIONS
    
================================================================================
    1. GETTING STARTED
================================================================================

    To use Lieris UI Library, load it using loadstring:
    
    local Lieris = loadstring(game:HttpGet("YOUR_RAW_URL_HERE"))()
    
    Or if you have the file locally:
    
    local Lieris = loadstring(readfile("Lieris.lua"))()

================================================================================
    2. CREATING A WINDOW
================================================================================

    The Window is the main container for your entire UI.
    
    SYNTAX:
        local Window = Lieris:CreateWindow(options)
    
    OPTIONS TABLE:
        Name            : string    - The title displayed in the window header
        ConfigFolder    : string    - Folder name for saving configurations
        SaveConfig      : boolean   - Enable auto-save functionality
        
    EXAMPLE:
        local Window = Lieris:CreateWindow({
            Name = "My Script Hub",
            ConfigFolder = "MyScriptConfigs",
            SaveConfig = true
        })
    
    WINDOW METHODS:
        Window:ToggleUI()           - Toggle window visibility
        Window:SetVisible(bool)     - Set window visibility explicitly
        Window:Destroy()            - Completely remove the UI

================================================================================
    3. CREATING TABS
================================================================================

    Tabs organize your UI into different pages/categories.
    
    SYNTAX:
        local Tab = Window:CreateTab(options)
    
    OPTIONS TABLE:
        Name    : string    - The name displayed on the tab button
        Icon    : string    - Asset ID for the tab icon (optional)
        
    EXAMPLE:
        local MainTab = Window:CreateTab({
            Name = "Main",
            Icon = "rbxassetid://102267096559735"
        })
        
        local SettingsTab = Window:CreateTab({
            Name = "Settings"
        })

================================================================================
    4. CREATING SECTIONS
================================================================================

    Sections group related elements within a tab.
    
    SYNTAX:
        local Section = Tab:CreateSection(sectionName)
    
    PARAMETERS:
        sectionName : string    - The header text for the section
        
    EXAMPLE:
        local CombatSection = MainTab:CreateSection("Combat Features")
        local VisualsSection = MainTab:CreateSection("Visual Settings")

================================================================================
    5. UI ELEMENTS
================================================================================

--------------------------------------------------------------------------------
    5.1 BUTTON
--------------------------------------------------------------------------------
    Creates a clickable button that executes a callback function.
    
    SYNTAX:
        Section:CreateButton(options)
    
    OPTIONS TABLE:
        Name        : string    - Button display text
        Callback    : function  - Function called when button is clicked
        
    EXAMPLE:
        Section:CreateButton({
            Name = "Kill All Enemies",
            Callback = function()
                print("Button clicked!")
                -- Your code here
            end
        })

--------------------------------------------------------------------------------
    5.2 TOGGLE
--------------------------------------------------------------------------------
    Creates an on/off switch with state persistence.
    
    SYNTAX:
        local Toggle = Section:CreateToggle(options)
    
    OPTIONS TABLE:
        Name        : string    - Toggle display text
        Default     : boolean   - Initial state (true/false)
        Flag        : string    - Unique identifier for config saving
        Callback    : function  - Called when toggle state changes
        
    RETURNS:
        Toggle object with methods:
            Toggle:Set(boolean)     - Set toggle state programmatically
            Toggle:Get()            - Get current toggle state
        
    EXAMPLE:
        local GodMode = Section:CreateToggle({
            Name = "God Mode",
            Default = false,
            Flag = "GodModeEnabled",
            Callback = function(Value)
                print("God Mode:", Value)
                -- Enable/disable god mode based on Value
            end
        })
        
        -- Later in code:
        GodMode:Set(true)
        print(GodMode:Get())

--------------------------------------------------------------------------------
    5.3 SLIDER
--------------------------------------------------------------------------------
    Creates a draggable slider for numeric value selection.
    
    SYNTAX:
        local Slider = Section:CreateSlider(options)
    
    OPTIONS TABLE:
        Name        : string    - Slider display text
        Min         : number    - Minimum value
        Max         : number    - Maximum value
        Default     : number    - Initial value
        Increment   : number    - Step increment (default: 1)
        Flag        : string    - Unique identifier for config saving
        Callback    : function  - Called when value changes
        
    RETURNS:
        Slider object with methods:
            Slider:Set(number)      - Set slider value programmatically
            Slider:Get()            - Get current slider value
        
    EXAMPLE:
        local SpeedSlider = Section:CreateSlider({
            Name = "Walk Speed",
            Min = 16,
            Max = 500,
            Default = 16,
            Increment = 1,
            Flag = "WalkSpeedValue",
            Callback = function(Value)
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
            end
        })

--------------------------------------------------------------------------------
    5.4 DROPDOWN
--------------------------------------------------------------------------------
    Creates a dropdown menu for selecting from a list of options.
    
    SYNTAX:
        local Dropdown = Section:CreateDropdown(options)
    
    OPTIONS TABLE:
        Name        : string    - Dropdown display text
        Options     : table     - Array of option strings
        Default     : string    - Initially selected option
        Multi       : boolean   - Allow multiple selections (default: false)
        Flag        : string    - Unique identifier for config saving
        Callback    : function  - Called when selection changes
        
    RETURNS:
        Dropdown object with methods:
            Dropdown:Set(string/table)  - Set selection programmatically
            Dropdown:Get()              - Get current selection
            Dropdown:Refresh(table)     - Update options list
            Dropdown:Add(string)        - Add new option
            Dropdown:Remove(string)     - Remove an option
        
    EXAMPLE:
        local TeamDropdown = Section:CreateDropdown({
            Name = "Select Team",
            Options = {"Red Team", "Blue Team", "Green Team"},
            Default = "Red Team",
            Flag = "SelectedTeam",
            Callback = function(Value)
                print("Selected:", Value)
            end
        })
        
        -- Multi-select example:
        local WeaponsDropdown = Section:CreateDropdown({
            Name = "Select Weapons",
            Options = {"Pistol", "Rifle", "Shotgun", "Sniper"},
            Multi = true,
            Flag = "SelectedWeapons",
            Callback = function(Values)
                for weapon, enabled in pairs(Values) do
                    print(weapon, ":", enabled)
                end
            end
        })

--------------------------------------------------------------------------------
    5.5 INPUT (TEXTBOX)
--------------------------------------------------------------------------------
    Creates a text input field.
    
    SYNTAX:
        local Input = Section:CreateInput(options)
    
    OPTIONS TABLE:
        Name            : string    - Input display text
        Default         : string    - Initial text value
        PlaceholderText : string    - Placeholder when empty
        Numeric         : boolean   - Only allow numbers (default: false)
        Finished        : boolean   - Only fire callback on enter (default: true)
        Flag            : string    - Unique identifier for config saving
        Callback        : function  - Called when text changes/submits
        
    RETURNS:
        Input object with methods:
            Input:Set(string)       - Set text programmatically
            Input:Get()             - Get current text value
        
    EXAMPLE:
        local PlayerInput = Section:CreateInput({
            Name = "Target Player",
            Default = "",
            PlaceholderText = "Enter username...",
            Flag = "TargetPlayer",
            Callback = function(Text)
                print("Targeting:", Text)
            end
        })

--------------------------------------------------------------------------------
    5.6 KEYBIND
--------------------------------------------------------------------------------
    Creates a customizable keyboard shortcut binding.
    
    SYNTAX:
        local Keybind = Section:CreateKeybind(options)
    
    OPTIONS TABLE:
        Name        : string            - Keybind display text
        Default     : Enum.KeyCode      - Default key binding
        Hold        : boolean           - Require holding (default: false)
        Flag        : string            - Unique identifier for config saving
        Callback    : function          - Called when key is pressed
        ChangedCallback : function      - Called when keybind is changed
        
    RETURNS:
        Keybind object with methods:
            Keybind:Set(Enum.KeyCode)   - Set keybind programmatically
            Keybind:Get()               - Get current keybind
        
    EXAMPLE:
        local TeleportKey = Section:CreateKeybind({
            Name = "Teleport Hotkey",
            Default = Enum.KeyCode.T,
            Hold = false,
            Flag = "TeleportKeybind",
            Callback = function()
                print("Teleport activated!")
            end,
            ChangedCallback = function(New)
                print("Keybind changed to:", New.Name)
            end
        })

--------------------------------------------------------------------------------
    5.7 COLOR PICKER
--------------------------------------------------------------------------------
    Creates a color selection interface.
    
    SYNTAX:
        local ColorPicker = Section:CreateColorPicker(options)
    
    OPTIONS TABLE:
        Name        : string    - Color picker display text
        Default     : Color3    - Initial color value
        Flag        : string    - Unique identifier for config saving
        Callback    : function  - Called when color changes
        
    RETURNS:
        ColorPicker object with methods:
            ColorPicker:Set(Color3)     - Set color programmatically
            ColorPicker:Get()           - Get current color value
        
    EXAMPLE:
        local ESPColor = Section:CreateColorPicker({
            Name = "ESP Color",
            Default = Color3.fromRGB(255, 0, 0),
            Flag = "ESPColorValue",
            Callback = function(Color)
                print("New color:", Color.R, Color.G, Color.B)
            end
        })

--------------------------------------------------------------------------------
    5.8 LABEL
--------------------------------------------------------------------------------
    Creates a simple text label for information display.
    
    SYNTAX:
        local Label = Section:CreateLabel(text)
    
    RETURNS:
        Label object with methods:
            Label:Set(string)       - Update label text
            Label:Get()             - Get current label text
        
    EXAMPLE:
        local StatusLabel = Section:CreateLabel("Status: Ready")
        
        -- Update later:
        StatusLabel:Set("Status: Running")

--------------------------------------------------------------------------------
    5.9 PARAGRAPH
--------------------------------------------------------------------------------
    Creates a multi-line text block for descriptions.
    
    SYNTAX:
        local Paragraph = Section:CreateParagraph(options)
    
    OPTIONS TABLE:
        Title   : string    - Paragraph header text
        Content : string    - Main paragraph content
        
    RETURNS:
        Paragraph object with methods:
            Paragraph:Set(options)  - Update paragraph content
        
    EXAMPLE:
        Section:CreateParagraph({
            Title = "About This Script",
            Content = "This script provides various features for enhanced gameplay. Use responsibly and enjoy!"
        })

--------------------------------------------------------------------------------
    5.10 DIVIDER
--------------------------------------------------------------------------------
    Creates a visual separator line between elements.
    
    SYNTAX:
        Section:CreateDivider()
        
    EXAMPLE:
        Section:CreateButton({Name = "Button 1", Callback = function() end})
        Section:CreateDivider()
        Section:CreateButton({Name = "Button 2", Callback = function() end})

================================================================================
    6. NOTIFICATIONS
================================================================================

    Display toast notifications to the user.
    
    SYNTAX:
        Lieris:Notify(options)
    
    OPTIONS TABLE:
        Title       : string    - Notification header
        Content     : string    - Notification message
        Duration    : number    - Display time in seconds (default: 3)
        Icon        : string    - Asset ID for icon (optional)
        Type        : string    - "Info", "Success", "Error", "Warning"
        
    EXAMPLE:
        Lieris:Notify({
            Title = "Success",
            Content = "Configuration saved successfully!",
            Duration = 5,
            Type = "Success",
            Icon = Lieris.Icons.Document
        })

================================================================================
    7. CONFIG SYSTEM
================================================================================

    Save and load user configurations automatically.
    
    SAVE CONFIG:
        Lieris:SaveConfig(configName)
        
    LOAD CONFIG:
        Lieris:LoadConfig(configName)
        
    GET CONFIGS:
        local configs = Lieris:GetConfigs()
        
    DELETE CONFIG:
        Lieris:DeleteConfig(configName)
        
    EXAMPLE:
        -- Save current settings
        Lieris:SaveConfig("MySettings")
        
        -- Load saved settings
        Lieris:LoadConfig("MySettings")
        
        -- Get all saved configs
        for _, name in ipairs(Lieris:GetConfigs()) do
            print("Found config:", name)
        end

================================================================================
    8. THEME CUSTOMIZATION
================================================================================

    Customize the UI appearance through the Colors table.
    
    AVAILABLE COLORS:
        Lieris.Colors.Main          - Main background color
        Lieris.Colors.Secondary     - Secondary elements color
        Lieris.Colors.Accent1       - Primary accent (Blue)
        Lieris.Colors.Accent2       - Secondary accent (Purple)
        Lieris.Colors.Text          - Primary text color
        Lieris.Colors.TextDark      - Secondary text color
        Lieris.Colors.Outline       - Border/outline color
        
    EXAMPLE:
        Lieris.Colors.Accent1 = Color3.fromRGB(255, 0, 128)
        Lieris.Colors.Accent2 = Color3.fromRGB(128, 0, 255)

================================================================================
    9. FLAGS SYSTEM
================================================================================

    Access element values globally through the Flags table.
    
    USAGE:
        -- After creating a toggle with Flag = "MyToggle"
        print(Lieris.Flags.MyToggle)  -- true or false
        
        -- After creating a slider with Flag = "MySlider"
        print(Lieris.Flags.MySlider)  -- current number value
        
    This is useful for accessing values from different parts of your script
    without needing to store references to each element.

================================================================================
    10. UTILITY FUNCTIONS
================================================================================

    TOGGLE UI:
        Lieris:ToggleUI()   - Toggle the entire UI visibility
        
    DESTROY:
        Lieris:Destroy()    - Remove all UI elements completely

================================================================================
    FULL EXAMPLE SCRIPT
================================================================================

    local Lieris = loadstring(game:HttpGet("URL_HERE"))()
    
    local Window = Lieris:CreateWindow({
        Name = "Example Script",
        ConfigFolder = "ExampleConfigs"
    })
    
    local MainTab = Window:CreateTab({
        Name = "Main",
        Icon = Lieris.Icons.Star
    })
    
    local CombatSection = MainTab:CreateSection("Combat")
    
    CombatSection:CreateToggle({
        Name = "Kill Aura",
        Default = false,
        Flag = "KillAura",
        Callback = function(Value)
            -- Kill aura logic
        end
    })
    
    CombatSection:CreateSlider({
        Name = "Attack Range",
        Min = 5,
        Max = 50,
        Default = 15,
        Flag = "AttackRange",
        Callback = function(Value)
            -- Update attack range
        end
    })
    
    local SettingsTab = Window:CreateTab({
        Name = "Settings",
        Icon = Lieris.Icons.Settings
    })
    
    local ConfigSection = SettingsTab:CreateSection("Configuration")
    
    ConfigSection:CreateButton({
        Name = "Save Settings",
        Callback = function()
            Lieris:SaveConfig("default")
            Lieris:Notify({
                Title = "Saved",
                Content = "Settings saved successfully!",
                Type = "Success"
            })
        end
    })

================================================================================
    END OF DOCUMENTATION
================================================================================
]]

-- ============================================================================
-- LIBRARY INITIALIZATION
-- ============================================================================

local Lieris = {}
Lieris.Flags = {}
Lieris.ConfigFolder = "LierisConfigs"
Lieris.CurrentConfig = "default"
Lieris._callbacks = {}
Lieris._elements = {}

-- ============================================================================
-- SERVICES
-- ============================================================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ============================================================================
-- ASSETS
-- ============================================================================

local Assets = {
    Background = "rbxassetid://120912477451723",
    Logo = "rbxassetid://93564507432615",
    CloseButton = "rbxassetid://75618206104636",
    MinimizeButton = "rbxassetid://95966901348174",
    Font = Enum.Font.Gotham,
    FontBold = Enum.Font.GothamBold,
    FontSemiBold = Enum.Font.GothamSemibold,
    
    Icons = {
        -- Navigation
        Home = "rbxassetid://92707187440072",
        
        -- Arrows
        ArrowUp = "rbxassetid://86798019032056",
        ArrowDown = "rbxassetid://95371614437264",
        ArrowLeft = "rbxassetid://73627730802442",
        ArrowRight = "rbxassetid://78259254071491",
        
        -- Actions
        Paw = "rbxassetid://132774784825596",
        Edit = "rbxassetid://79102469506206",
        Undo = "rbxassetid://108718392331342",
        Trash = "rbxassetid://120799379418283",
        Plus = "rbxassetid://113292455067178",
        Resize = "rbxassetid://100459617281310",
        Fullscreen = "rbxassetid://140212636469024",
        
        -- Status
        Star = "rbxassetid://92707187440072",
        StarHalf = "rbxassetid://108853802570915",
        Heart = "rbxassetid://86525383749807",
        Crown = "rbxassetid://126259774551591",
        
        -- Alerts
        Alert = "rbxassetid://129002225813257",
        Info = "rbxassetid://72675213757354",
        Question = "rbxassetid://136925848170066",
        
        -- System
        Settings = "rbxassetid://102267096559735",
        Key = "rbxassetid://124296337565532",
        Padlock = "rbxassetid://101648628065104",
        Shield = "rbxassetid://85965347730498",
        Eye = "rbxassetid://125020341331789",
        
        -- Files
        Document = "rbxassetid://101184153582665",
        Folder = "rbxassetid://127886922473441",
        Database = "rbxassetid://139502699163631",
        List = "rbxassetid://97543050372859",
        
        -- Combat
        Gun = "rbxassetid://131253277679602",
        Rifle = "rbxassetid://92276134372777",
        Target = "rbxassetid://131253277679602",
        
        -- Finance
        Dollar = "rbxassetid://99027619708694",
        Briefcase = "rbxassetid://138340962857599",
        
        -- Nature
        Flame = "rbxassetid://73806373761889",
        Lightning = "rbxassetid://113425277383163",
        Cloud = "rbxassetid://109550289152072",
        
        -- Tech
        Brain = "rbxassetid://84614763334611",
        Camera = "rbxassetid://125788738236572",
        Discord = "rbxassetid://89700473399405",
        Code = "rbxassetid://84614763334611",
        
        -- Time
        Time = "rbxassetid://92180740914957",
        
        -- Player
        Player = "rbxassetid://85965347730498",
        
        -- Misc
        Misc = "rbxassetid://102267096559735",
        
        -- UI Controls
        Check = "rbxassetid://93564507432615",
        Cross = "rbxassetid://75618206104636",
    }
}

-- ============================================================================
-- COLORS
-- ============================================================================

local Colors = {
    Main = Color3.fromRGB(8, 8, 12),
    Secondary = Color3.fromRGB(14, 14, 20),
    Tertiary = Color3.fromRGB(22, 22, 32),
    Accent1 = Color3.fromRGB(80, 120, 255),
    Accent2 = Color3.fromRGB(150, 80, 255),
    Text = Color3.fromRGB(250, 250, 255),
    TextDark = Color3.fromRGB(150, 150, 175),
    TextDarker = Color3.fromRGB(100, 100, 125),
    Outline = Color3.fromRGB(35, 35, 50),
    Success = Color3.fromRGB(80, 220, 140),
    Error = Color3.fromRGB(255, 90, 90),
    Warning = Color3.fromRGB(255, 190, 70),
    Glow = Color3.fromRGB(100, 140, 255),
}

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

local function Create(class, properties)
    local instance = Instance.new(class)
    for k, v in pairs(properties) do
        if k ~= "Parent" then
            instance[k] = v
        end
    end
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

local function Tween(instance, properties, duration, easingStyle, easingDirection)
    local info = TweenInfo.new(
        duration or 0.2,
        easingStyle or Enum.EasingStyle.Quint,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

local function TweenSmooth(instance, properties, duration)
    local info = TweenInfo.new(
        duration or 0.35,
        Enum.EasingStyle.Exponential,
        Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

local function TweenBounce(instance, properties, duration)
    local info = TweenInfo.new(
        duration or 0.4,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

local function AddCorner(parent, radius)
    return Create("UICorner", {
        CornerRadius = radius or UDim.new(0, 8),
        Parent = parent
    })
end

local function AddStroke(parent, color, thickness, transparency)
    return Create("UIStroke", {
        Color = color or Colors.Outline,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent
    })
end

local function AddGradient(parent, color1, color2, rotation)
    return Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, color1 or Colors.Accent1),
            ColorSequenceKeypoint.new(1, color2 or Colors.Accent2)
        }),
        Rotation = rotation or 45,
        Parent = parent
    })
end

local function AddPadding(parent, top, bottom, left, right)
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, top or 0),
        PaddingBottom = UDim.new(0, bottom or top or 0),
        PaddingLeft = UDim.new(0, left or top or 0),
        PaddingRight = UDim.new(0, right or left or top or 0),
        Parent = parent
    })
end

local function AddShadow(parent, transparency)
    local shadow = Create("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 6),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, 50, 1, 50),
        ZIndex = parent.ZIndex - 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = transparency or 0.5,
        Parent = parent
    })
    return shadow
end

local function AddGlow(parent, color, size, transparency)
    local glow = Create("ImageLabel", {
        Name = "Glow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, size or 30, 1, size or 30),
        ZIndex = parent.ZIndex - 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = color or Colors.Accent1,
        ImageTransparency = transparency or 0.85,
        Parent = parent
    })
    return glow
end

local function MakeDraggable(frame, dragHandle)
    local dragging, dragInput, dragStart, startPos
    
    local function Update(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
        Tween(frame, {Position = newPos}, 0.08)
    end
    
    dragHandle.InputBegan:Connect(function(input)
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
    
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            Update(input)
        end
    end)
end

local function CreateRipple(parent, position)
    local ripple = Create("Frame", {
        Name = "Ripple",
        BackgroundColor3 = Colors.Text,
        BackgroundTransparency = 0.8,
        Position = position or UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 0, 0, 0),
        ZIndex = parent.ZIndex + 5,
        Parent = parent
    })
    AddCorner(ripple, UDim.new(1, 0))
    
    local maxSize = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2.8
    
    TweenSmooth(ripple, {Size = UDim2.new(0, maxSize, 0, maxSize), BackgroundTransparency = 1}, 0.6)
    
    task.delay(0.6, function()
        if ripple then
            ripple:Destroy()
        end
    end)
end

local function CreatePulse(element, color)
    local originalColor = element.BackgroundColor3
    Tween(element, {BackgroundColor3 = color or Colors.Accent1}, 0.1)
    task.delay(0.1, function()
        TweenSmooth(element, {BackgroundColor3 = originalColor}, 0.3)
    end)
end

-- ============================================================================
-- CONFIG SYSTEM
-- ============================================================================

local function EnsureConfigFolder()
    if not isfolder then return false end
    if not isfolder(Lieris.ConfigFolder) then
        makefolder(Lieris.ConfigFolder)
    end
    return true
end

function Lieris:SaveConfig(name)
    name = name or self.CurrentConfig
    if not EnsureConfigFolder() then return false end
    
    local data = {}
    for flag, value in pairs(self.Flags) do
        if typeof(value) == "Color3" then
            data[flag] = {Type = "Color3", R = value.R, G = value.G, B = value.B}
        elseif typeof(value) == "EnumItem" then
            data[flag] = {Type = "EnumItem", EnumType = tostring(value.EnumType), Name = value.Name}
        elseif typeof(value) == "table" then
            data[flag] = {Type = "Table", Value = value}
        else
            data[flag] = {Type = typeof(value), Value = value}
        end
    end
    
    local success, json = pcall(function()
        return HttpService:JSONEncode(data)
    end)
    
    if not success then return false end
    
    local path = self.ConfigFolder .. "/" .. name .. ".json"
    
    local writeSuccess = pcall(function()
        writefile(path, json)
    end)
    
    return writeSuccess
end

function Lieris:LoadConfig(name)
    name = name or self.CurrentConfig
    if not EnsureConfigFolder() then return false end
    
    local path = self.ConfigFolder .. "/" .. name .. ".json"
    
    local exists = pcall(function()
        return isfile(path)
    end)
    
    if not exists then return false end
    
    local success, content = pcall(function()
        return readfile(path)
    end)
    
    if not success then return false end
    
    local decodeSuccess, data = pcall(function()
        return HttpService:JSONDecode(content)
    end)
    
    if not decodeSuccess then return false end
    
    for flag, info in pairs(data) do
        if info.Type == "Color3" then
            self.Flags[flag] = Color3.new(info.R, info.G, info.B)
        elseif info.Type == "EnumItem" then
            pcall(function()
                self.Flags[flag] = Enum[info.EnumType][info.Name]
            end)
        elseif info.Type == "Table" then
            self.Flags[flag] = info.Value
        else
            self.Flags[flag] = info.Value
        end
        
        if self._callbacks and self._callbacks[flag] then
            pcall(function()
                self._callbacks[flag](self.Flags[flag])
            end)
        end
        
        if self._elements and self._elements[flag] and self._elements[flag].Set then
            pcall(function()
                self._elements[flag]:Set(self.Flags[flag])
            end)
        end
    end
    
    return true
end

function Lieris:GetConfigs()
    if not EnsureConfigFolder() then return {} end
    
    local configs = {}
    local success, files = pcall(function()
        return listfiles(Lieris.ConfigFolder)
    end)
    
    if not success then return {} end
    
    for _, file in ipairs(files) do
        if file:match("%.json$") then
            local name = file:match("([^/\\]+)%.json$")
            table.insert(configs, name)
        end
    end
    return configs
end

function Lieris:DeleteConfig(name)
    if not EnsureConfigFolder() then return false end
    
    local path = self.ConfigFolder .. "/" .. name .. ".json"
    
    local success = pcall(function()
        if isfile(path) then
            delfile(path)
        end
    end)
    
    return success
end

-- ============================================================================
-- NOTIFICATION SYSTEM
-- ============================================================================

local NotificationHolder

function Lieris:Notify(options)
    options = options or {}
    local Title = options.Title or "Notification"
    local Content = options.Content or ""
    local Duration = options.Duration or 3
    local Icon = options.Icon or Assets.Icons.Info
    local Type = options.Type or "Info"
    
    local accentColor = Colors.Accent1
    if Type == "Success" then
        accentColor = Colors.Success
    elseif Type == "Error" then
        accentColor = Colors.Error
    elseif Type == "Warning" then
        accentColor = Colors.Warning
    end
    
    if not NotificationHolder then
        local NotificationGui = Create("ScreenGui", {
            Name = "LierisNotifications",
            ResetOnSpawn = false,
            DisplayOrder = 999,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        })
        
        local success = pcall(function()
            NotificationGui.Parent = CoreGui
        end)
        if not success then
            NotificationGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        end
        
        NotificationHolder = Create("Frame", {
            Name = "NotifyHolder",
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -25, 1, -25),
            AnchorPoint = Vector2.new(1, 1),
            Size = UDim2.new(0, 340, 1, -50),
            Parent = NotificationGui
        })
        
        Create("UIListLayout", {
            Parent = NotificationHolder,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 12),
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Bottom
        })
    end
    
    local Notification = Create("Frame", {
        Name = "Notification",
        BackgroundColor3 = Colors.Secondary,
        Size = UDim2.new(1, 0, 0, 0),
        ClipsDescendants = true,
        Parent = NotificationHolder
    })
    AddCorner(Notification, UDim.new(0, 12))
    AddStroke(Notification, accentColor, 1, 0.4)
    AddShadow(Notification, 0.65)
    
    local AccentLine = Create("Frame", {
        Name = "Accent",
        BackgroundColor3 = accentColor,
        Size = UDim2.new(0, 4, 1, 0),
        Parent = Notification
    })
    AddCorner(AccentLine, UDim.new(0, 2))
    
    if Icon then
        Create("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 16, 0, 16),
            Size = UDim2.new(0, 30, 0, 30),
            Image = Icon,
            ImageColor3 = accentColor,
            Parent = Notification
        })
    end
    
    Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, Icon and 58 or 22, 0, 14),
        Size = UDim2.new(1, Icon and -70 or -34, 0, 22),
        Font = Assets.FontBold,
        Text = Title,
        TextColor3 = Colors.Text,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Notification
    })
    
    Create("TextLabel", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, Icon and 58 or 22, 0, 38),
        Size = UDim2.new(1, Icon and -70 or -34, 0, 42),
        Font = Assets.Font,
        Text = Content,
        TextColor3 = Colors.TextDark,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        Parent = Notification
    })
    
    local ProgressBar = Create("Frame", {
        Name = "Progress",
        BackgroundColor3 = accentColor,
        BackgroundTransparency = 0.4,
        Position = UDim2.new(0, 0, 1, -4),
        Size = UDim2.new(1, 0, 0, 4),
        Parent = Notification
    })
    AddCorner(ProgressBar, UDim.new(0, 2))
    
    TweenBounce(Notification, {Size = UDim2.new(1, 0, 0, 90)}, 0.35)
    
    task.delay(0.35, function()
        TweenSmooth(ProgressBar, {Size = UDim2.new(0, 0, 0, 4)}, Duration)
    end)
    
    task.delay(Duration + 0.35, function()
        TweenSmooth(Notification, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.delay(0.25, function()
            if Notification then
                Notification:Destroy()
            end
        end)
    end)
end

-- ============================================================================
-- MAIN WINDOW
-- ============================================================================

function Lieris:CreateWindow(options)
    options = options or {}
    local Name = options.Name or "Lieris UI"
    local ConfigFolder = options.ConfigFolder or "LierisConfigs"
    
    Lieris.ConfigFolder = ConfigFolder
    EnsureConfigFolder()
    
    local ScreenGui = Create("ScreenGui", {
        Name = "LierisUI_" .. HttpService:GenerateGUID(false),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100
    })
    
    local success = pcall(function()
        ScreenGui.Parent = CoreGui
    end)
    if not success then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    
    local MainFrame = Create("ImageLabel", {
        Name = "MainFrame",
        BackgroundColor3 = Colors.Main,
        Position = UDim2.new(0.5, -375, 0.5, -250),
        Size = UDim2.new(0, 750, 0, 500),
        Image = Assets.Background,
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        ImageTransparency = 0.97,
        ScaleType = Enum.ScaleType.Crop,
        ClipsDescendants = true,
        Parent = ScreenGui
    })
    AddCorner(MainFrame, UDim.new(0, 14))
    AddShadow(MainFrame, 0.4)
    AddGlow(MainFrame, Colors.Accent1, 60, 0.92)
    
    local BorderGlow = AddStroke(MainFrame, Colors.Accent1, 1.5, 0.4)
    AddGradient(BorderGlow, Colors.Accent1, Colors.Accent2, 135)
    
    MakeDraggable(MainFrame, MainFrame)
    
    -- TOP BAR
    local TopBar = Create("Frame", {
        Name = "TopBar",
        BackgroundColor3 = Colors.Secondary,
        BackgroundTransparency = 0.2,
        Size = UDim2.new(1, 0, 0, 52),
        Parent = MainFrame
    })
    AddCorner(TopBar, UDim.new(0, 14))
    
    Create("Frame", {
        Name = "TopBarFix",
        BackgroundColor3 = Colors.Secondary,
        BackgroundTransparency = 0.2,
        Position = UDim2.new(0, 0, 1, -14),
        Size = UDim2.new(1, 0, 0, 14),
        ZIndex = 0,
        Parent = TopBar
    })
    
    local TopAccent = Create("Frame", {
        Name = "TopAccent",
        BackgroundColor3 = Colors.Accent1,
        Position = UDim2.new(0, 0, 1, -2),
        Size = UDim2.new(1, 0, 0, 2),
        Parent = TopBar
    })
    AddGradient(TopAccent, Colors.Accent1, Colors.Accent2, 0)
    
    local LogoGlow = Create("ImageLabel", {
        Name = "LogoGlow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 5, 0.5, -20),
        Size = UDim2.new(0, 50, 0, 50),
        Image = "rbxassetid://5028857084",
        ImageColor3 = Colors.Accent1,
        ImageTransparency = 0.9,
        Parent = TopBar
    })
    
    Create("ImageLabel", {
        Name = "Logo",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 16, 0.5, -15),
        Size = UDim2.new(0, 30, 0, 30),
        Image = Assets.Logo,
        Parent = TopBar
    })
    
    Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 55, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        Font = Assets.FontBold,
        Text = Name,
        TextColor3 = Colors.Text,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    })
    
    local ControlsFrame = Create("Frame", {
        Name = "Controls",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -90, 0, 0),
        Size = UDim2.new(0, 80, 1, 0),
        Parent = TopBar
    })
    
    local MinimizeBtn = Create("ImageButton", {
        Name = "Minimize",
        BackgroundColor3 = Colors.Tertiary,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0.5, -15),
        Size = UDim2.new(0, 32, 0, 32),
        Image = Assets.MinimizeButton,
        ImageColor3 = Colors.TextDark,
        Parent = ControlsFrame
    })
    AddCorner(MinimizeBtn, UDim.new(0, 8))
    
    local CloseBtn = Create("ImageButton", {
        Name = "Close",
        BackgroundColor3 = Colors.Tertiary,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -32, 0.5, -15),
        Size = UDim2.new(0, 32, 0, 32),
        Image = Assets.CloseButton,
        ImageColor3 = Colors.TextDark,
        Parent = ControlsFrame
    })
    AddCorner(CloseBtn, UDim.new(0, 8))
    
    MinimizeBtn.MouseEnter:Connect(function()
        TweenSmooth(MinimizeBtn, {BackgroundTransparency = 0.4, ImageColor3 = Colors.Accent1}, 0.2)
    end)
    MinimizeBtn.MouseLeave:Connect(function()
        TweenSmooth(MinimizeBtn, {BackgroundTransparency = 1, ImageColor3 = Colors.TextDark}, 0.2)
    end)
    
    CloseBtn.MouseEnter:Connect(function()
        TweenSmooth(CloseBtn, {BackgroundTransparency = 0.4, ImageColor3 = Colors.Error}, 0.2)
    end)
    CloseBtn.MouseLeave:Connect(function()
        TweenSmooth(CloseBtn, {BackgroundTransparency = 1, ImageColor3 = Colors.TextDark}, 0.2)
    end)
    
    -- TAB CONTAINER
    local TabContainer = Create("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = Colors.Secondary,
        BackgroundTransparency = 0.4,
        Position = UDim2.new(0, 12, 0, 66),
        Size = UDim2.new(0, 165, 1, -78),
        Parent = MainFrame
    })
    AddCorner(TabContainer, UDim.new(0, 10))
    AddStroke(TabContainer, Colors.Outline, 1, 0.7)
    
    local TabScroll = Create("ScrollingFrame", {
        Name = "TabScroll",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 8),
        Size = UDim2.new(1, 0, 1, -16),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Colors.Accent2,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = TabContainer
    })
    
    Create("UIListLayout", {
        Parent = TabScroll,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6),
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    })
    AddPadding(TabScroll, 5, 5, 8, 8)
    
    -- PAGES CONTAINER
    local PagesContainer = Create("Frame", {
        Name = "PagesContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 190, 0, 66),
        Size = UDim2.new(1, -202, 1, -78),
        Parent = MainFrame
    })
    
    -- WINDOW OBJECT
    local WindowObj = {}
    WindowObj.Visible = true
    WindowObj.ScreenGui = ScreenGui
    WindowObj.MainFrame = MainFrame
    
    local Tabs = {}
    local FirstTab = true
    local minimized = false
    local originalSize = MainFrame.Size
    
    function WindowObj:ToggleUI()
        WindowObj.Visible = not WindowObj.Visible
        if WindowObj.Visible then
            MainFrame.Visible = true
            TweenBounce(MainFrame, {
                Size = originalSize,
                Position = UDim2.new(0.5, -375, 0.5, -250)
            }, 0.45)
        else
            TweenSmooth(MainFrame, {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }, 0.3)
            task.delay(0.3, function()
                MainFrame.Visible = false
            end)
        end
    end
    
    function WindowObj:SetVisible(visible)
        WindowObj.Visible = visible
        if visible then
            MainFrame.Visible = true
            TweenBounce(MainFrame, {
                Size = originalSize,
                Position = UDim2.new(0.5, -375, 0.5, -250)
            }, 0.45)
        else
            TweenSmooth(MainFrame, {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }, 0.3)
            task.delay(0.3, function()
                MainFrame.Visible = false
            end)
        end
    end
    
    function WindowObj:Destroy()
        TweenSmooth(MainFrame, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, 0.35)
        task.delay(0.35, function()
            ScreenGui:Destroy()
        end)
    end
    
    MinimizeBtn.MouseButton1Click:Connect(function()
        CreateRipple(MinimizeBtn)
        minimized = not minimized
        
        if minimized then
            TweenSmooth(MainFrame, {Size = UDim2.new(0, 750, 0, 52)}, 0.35)
            task.delay(0.1, function()
                TabContainer.Visible = false
                PagesContainer.Visible = false
            end)
        else
            TweenBounce(MainFrame, {Size = originalSize}, 0.4)
            task.delay(0.2, function()
                TabContainer.Visible = true
                PagesContainer.Visible = true
            end)
        end
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        CreateRipple(CloseBtn)
        WindowObj:Destroy()
    end)
    
    -- Opening Animation
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenBounce(MainFrame, {
        Size = UDim2.new(0, 750, 0, 500),
        Position = UDim2.new(0.5, -375, 0.5, -250)
    }, 0.55)
    
    -- CREATE TAB FUNCTION
    function WindowObj:CreateTab(tabOptions)
        tabOptions = tabOptions or {}
        local TabName = tabOptions.Name or "Tab"
        local TabIcon = tabOptions.Icon
        
        local TabPage = Create("ScrollingFrame", {
            Name = TabName .. "_Page",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Colors.Accent2,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = PagesContainer
        })
        
        Create("UIListLayout", {
            Parent = TabPage,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10),
            HorizontalAlignment = Enum.HorizontalAlignment.Center
        })
        AddPadding(TabPage, 5, 15, 5, 10)
        
        local TabButton = Create("TextButton", {
            Name = TabName .. "_Btn",
            BackgroundColor3 = Colors.Tertiary,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 40),
            Text = "",
            AutoButtonColor = false,
            Parent = TabScroll
        })
        AddCorner(TabButton, UDim.new(0, 8))
        
        local TabIndicator = Create("Frame", {
            Name = "Indicator",
            BackgroundColor3 = Colors.Accent1,
            Position = UDim2.new(0, 0, 0.15, 0),
            Size = UDim2.new(0, 3, 0.7, 0),
            Visible = false,
            Parent = TabButton
        })
        AddCorner(TabIndicator, UDim.new(0, 2))
        AddGradient(TabIndicator, Colors.Accent1, Colors.Accent2, 90)
        
        local TabIconImage
        if TabIcon then
            TabIconImage = Create("ImageLabel", {
                Name = "Icon",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0.5, -9),
                Size = UDim2.new(0, 18, 0, 18),
                Image = TabIcon,
                ImageColor3 = Colors.TextDark,
                Parent = TabButton
            })
        end
        
        local TabLabel = Create("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, TabIcon and 38 or 15, 0, 0),
            Size = UDim2.new(1, TabIcon and -45 or -20, 1, 0),
            Font = Assets.Font,
            Text = TabName,
            TextColor3 = Colors.TextDark,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = TabButton
        })
        
        local function ActivateTab()
            for _, t in pairs(Tabs) do
                TweenSmooth(t.Button, {BackgroundTransparency = 1}, 0.2)
                if t.Icon then TweenSmooth(t.Icon, {ImageColor3 = Colors.TextDark}, 0.2) end
                TweenSmooth(t.Label, {TextColor3 = Colors.TextDark}, 0.2)
                t.Indicator.Visible = false
                t.Page.Visible = false
            end
            
            TweenSmooth(TabButton, {BackgroundTransparency = 0.6}, 0.2)
            if TabIconImage then TweenSmooth(TabIconImage, {ImageColor3 = Colors.Accent1}, 0.2) end
            TweenSmooth(TabLabel, {TextColor3 = Colors.Text}, 0.2)
            TabIndicator.Visible = true
            TabPage.Visible = true
        end
        
        TabButton.MouseButton1Click:Connect(function()
            CreateRipple(TabButton)
            ActivateTab()
        end)
        
        TabButton.MouseEnter:Connect(function()
            if not TabPage.Visible then
                TweenSmooth(TabButton, {BackgroundTransparency = 0.8}, 0.2)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if not TabPage.Visible then
                TweenSmooth(TabButton, {BackgroundTransparency = 1}, 0.2)
            end
        end)
        
        table.insert(Tabs, {
            Button = TabButton,
            Page = TabPage,
            Icon = TabIconImage,
            Label = TabLabel,
            Indicator = TabIndicator
        })
        
        if FirstTab then
            FirstTab = false
            ActivateTab()
        end
        
        -- TAB OBJECT
        local TabObj = {}
        
        -- CREATE SECTION
        function TabObj:CreateSection(sectionName)
            sectionName = sectionName or "Section"
            
            local SectionFrame = Create("Frame", {
                Name = sectionName .. "_Section",
                BackgroundColor3 = Colors.Secondary,
                BackgroundTransparency = 0.3,
                Size = UDim2.new(1, -10, 0, 45),
                Parent = TabPage
            })
            AddCorner(SectionFrame, UDim.new(0, 10))
            AddStroke(SectionFrame, Colors.Outline, 1, 0.7)
            
            local SectionHeader = Create("Frame", {
                Name = "Header",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 38),
                Parent = SectionFrame
            })
            
            local SectionAccent = Create("Frame", {
                Name = "Accent",
                BackgroundColor3 = Colors.Accent1,
                Position = UDim2.new(0, 12, 0.5, -10),
                Size = UDim2.new(0, 3, 0, 20),
                Parent = SectionHeader
            })
            AddCorner(SectionAccent, UDim.new(0, 2))
            AddGradient(SectionAccent, Colors.Accent1, Colors.Accent2, 90)
            
            Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 22, 0, 0),
                Size = UDim2.new(1, -34, 1, 0),
                Font = Assets.FontBold,
                Text = sectionName,
                TextColor3 = Colors.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SectionHeader
            })
            
            local SectionContent = Create("Frame", {
                Name = "Content",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 42),
                Size = UDim2.new(1, 0, 0, 0),
                Parent = SectionFrame
            })
            
            local ContentLayout = Create("UIListLayout", {
                Parent = SectionContent,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 10),
                HorizontalAlignment = Enum.HorizontalAlignment.Center
            })
            AddPadding(SectionContent, 0, 14, 14, 14)
            
            ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionContent.Size = UDim2.new(1, 0, 0, ContentLayout.AbsoluteContentSize.Y + 14)
                SectionFrame.Size = UDim2.new(1, -10, 0, ContentLayout.AbsoluteContentSize.Y + 56)
            end)
            
            -- SECTION ELEMENTS
            local Elements = {}
            
            -- LABEL
            function Elements:CreateLabel(text)
                text = text or "Label"
                
                local Label = Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 24),
                    Font = Assets.Font,
                    Text = text,
                    TextColor3 = Colors.TextDark,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = SectionContent
                })
                
                local LabelObj = {}
                function LabelObj:Set(newText)
                    Label.Text = newText
                end
                function LabelObj:Get()
                    return Label.Text
                end
                
                return LabelObj
            end
            
            -- PARAGRAPH
            function Elements:CreateParagraph(props)
                props = props or {}
                local Title = props.Title or "Title"
                local Content = props.Content or props.Text or ""
                
                local ParagraphFrame = Create("Frame", {
                    Name = "Paragraph",
                    BackgroundColor3 = Colors.Tertiary,
                    BackgroundTransparency = 0.3,
                    Size = UDim2.new(1, 0, 0, 65),
                    Parent = SectionContent
                })
                AddCorner(ParagraphFrame, UDim.new(0, 8))
                AddStroke(ParagraphFrame, Colors.Outline, 1, 0.5)
                
                local ParagraphTitle = Create("TextLabel", {
                    Name = "Title",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 10),
                    Size = UDim2.new(1, -28, 0, 18),
                    Font = Assets.FontBold,
                    Text = Title,
                    TextColor3 = Colors.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = ParagraphFrame
                })
                
                local ParagraphContent = Create("TextLabel", {
                    Name = "Content",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 30),
                    Size = UDim2.new(1, -28, 0, 28),
                    Font = Assets.Font,
                    Text = Content,
                    TextColor3 = Colors.TextDark,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    TextWrapped = true,
                    Parent = ParagraphFrame
                })
                
                local success, textBounds = pcall(function()
                    return TextService:GetTextSize(
                        Content,
                        12,
                        Assets.Font,
                        Vector2.new(ParagraphFrame.AbsoluteSize.X - 24, math.huge)
                    )
                end)
                
                if success then
                    ParagraphContent.Size = UDim2.new(1, -24, 0, math.max(20, textBounds.Y + 5))
                    ParagraphFrame.Size = UDim2.new(1, 0, 0, 35 + math.max(20, textBounds.Y + 5))
                end
                
                local ParagraphObj = {}
                function ParagraphObj:Set(newProps)
                    if newProps.Title then ParagraphTitle.Text = newProps.Title end
                    if newProps.Content then 
                        ParagraphContent.Text = newProps.Content
                        local s, bounds = pcall(function()
                            return TextService:GetTextSize(
                                newProps.Content,
                                12,
                                Assets.Font,
                                Vector2.new(ParagraphFrame.AbsoluteSize.X - 24, math.huge)
                            )
                        end)
                        if s then
                            ParagraphContent.Size = UDim2.new(1, -24, 0, math.max(20, bounds.Y + 5))
                            ParagraphFrame.Size = UDim2.new(1, 0, 0, 35 + math.max(20, bounds.Y + 5))
                        end
                    end
                end
                
                return ParagraphObj
            end
            
            -- DIVIDER
            function Elements:CreateDivider()
                local DividerFrame = Create("Frame", {
                    Name = "Divider",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 14),
                    Parent = SectionContent
                })
                
                local Line = Create("Frame", {
                    Name = "Line",
                    BackgroundColor3 = Colors.Accent1,
                    BackgroundTransparency = 0.7,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.new(0.92, 0, 0, 1),
                    Parent = DividerFrame
                })
                AddCorner(Line, UDim.new(0, 1))
                
                return DividerFrame
            end
            
            -- BUTTON
            function Elements:CreateButton(props)
                props = props or {}
                local ButtonName = props.Name or "Button"
                local Callback = props.Callback or function() end
                
                local Button = Create("TextButton", {
                    Name = ButtonName,
                    BackgroundColor3 = Colors.Tertiary,
                    Size = UDim2.new(1, 0, 0, 38),
                    Font = Assets.Font,
                    Text = "",
                    AutoButtonColor = false,
                    ClipsDescendants = true,
                    Parent = SectionContent
                })
                AddCorner(Button, UDim.new(0, 8))
                AddStroke(Button, Colors.Outline, 1, 0.6)
                
                Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 0),
                    Size = UDim2.new(1, -45, 1, 0),
                    Font = Assets.Font,
                    Text = ButtonName,
                    TextColor3 = Colors.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Button
                })
                
                local ButtonArrow = Create("ImageLabel", {
                    Name = "Arrow",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -30, 0.5, -8),
                    Size = UDim2.new(0, 16, 0, 16),
                    Image = Assets.Icons.ArrowRight,
                    ImageColor3 = Colors.Accent1,
                    Parent = Button
                })
                
                Button.MouseEnter:Connect(function()
                    TweenSmooth(Button, {BackgroundColor3 = Colors.Accent1}, 0.2)
                    TweenSmooth(ButtonArrow, {ImageColor3 = Colors.Text}, 0.2)
                end)
                
                Button.MouseLeave:Connect(function()
                    TweenSmooth(Button, {BackgroundColor3 = Colors.Tertiary}, 0.2)
                    TweenSmooth(ButtonArrow, {ImageColor3 = Colors.Accent1}, 0.2)
                end)
                
                Button.MouseButton1Click:Connect(function()
                    CreateRipple(Button)
                    CreatePulse(Button, Colors.Accent2)
                    pcall(Callback)
                end)
            end
            
            -- TOGGLE
            function Elements:CreateToggle(props)
                props = props or {}
                local ToggleName = props.Name or "Toggle"
                local Default = props.Default or false
                local Flag = props.Flag or ToggleName
                local Callback = props.Callback or function() end
                
                local Toggled = Default
                Lieris.Flags[Flag] = Toggled
                Lieris._callbacks[Flag] = Callback
                
                local ToggleFrame = Create("Frame", {
                    Name = ToggleName,
                    BackgroundColor3 = Colors.Tertiary,
                    Size = UDim2.new(1, 0, 0, 38),
                    Parent = SectionContent
                })
                AddCorner(ToggleFrame, UDim.new(0, 8))
                AddStroke(ToggleFrame, Colors.Outline, 1, 0.6)
                
                Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 0),
                    Size = UDim2.new(1, -70, 1, 0),
                    Font = Assets.Font,
                    Text = ToggleName,
                    TextColor3 = Colors.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = ToggleFrame
                })
                
                local ToggleButton = Create("TextButton", {
                    Name = "Toggle",
                    BackgroundColor3 = Toggled and Colors.Accent1 or Colors.Main,
                    Position = UDim2.new(1, -54, 0.5, -12),
                    Size = UDim2.new(0, 46, 0, 24),
                    Text = "",
                    AutoButtonColor = false,
                    Parent = ToggleFrame
                })
                AddCorner(ToggleButton, UDim.new(1, 0))
                AddStroke(ToggleButton, Toggled and Colors.Accent1 or Colors.Outline, 1, 0.5)
                
                local ToggleCircle = Create("Frame", {
                    Name = "Circle",
                    BackgroundColor3 = Colors.Text,
                    Position = Toggled and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9),
                    Size = UDim2.new(0, 18, 0, 18),
                    Parent = ToggleButton
                })
                AddCorner(ToggleCircle, UDim.new(1, 0))
                
                local ToggleStroke = ToggleButton:FindFirstChildOfClass("UIStroke")
                
                local function UpdateToggle()
                    if Toggled then
                        TweenSmooth(ToggleButton, {BackgroundColor3 = Colors.Accent1}, 0.25)
                        TweenSmooth(ToggleCircle, {Position = UDim2.new(1, -22, 0.5, -9)}, 0.25)
                        if ToggleStroke then TweenSmooth(ToggleStroke, {Color = Colors.Accent1}, 0.25) end
                    else
                        TweenSmooth(ToggleButton, {BackgroundColor3 = Colors.Main}, 0.25)
                        TweenSmooth(ToggleCircle, {Position = UDim2.new(0, 4, 0.5, -9)}, 0.25)
                        if ToggleStroke then TweenSmooth(ToggleStroke, {Color = Colors.Outline}, 0.25) end
                    end
                end
                
                local function DoToggle()
                    Toggled = not Toggled
                    Lieris.Flags[Flag] = Toggled
                    UpdateToggle()
                    pcall(Callback, Toggled)
                end
                
                ToggleButton.MouseButton1Click:Connect(DoToggle)
                
                ToggleFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        DoToggle()
                    end
                end)
                
                local ToggleObj = {}
                function ToggleObj:Set(value)
                    if Toggled ~= value then
                        Toggled = value
                        Lieris.Flags[Flag] = Toggled
                        UpdateToggle()
                        pcall(Callback, Toggled)
                    end
                end
                function ToggleObj:Get()
                    return Toggled
                end
                
                Lieris._elements[Flag] = ToggleObj
                return ToggleObj
            end
            
            -- SLIDER
            function Elements:CreateSlider(props)
                props = props or {}
                local SliderName = props.Name or "Slider"
                local Min = props.Min or 0
                local Max = props.Max or 100
                local Default = props.Default or Min
                local Increment = props.Increment or 1
                local Flag = props.Flag or SliderName
                local Callback = props.Callback or function() end
                
                local Value = Default
                Lieris.Flags[Flag] = Value
                Lieris._callbacks[Flag] = Callback
                
                local SliderFrame = Create("Frame", {
                    Name = SliderName,
                    BackgroundColor3 = Colors.Tertiary,
                    Size = UDim2.new(1, 0, 0, 58),
                    Parent = SectionContent
                })
                AddCorner(SliderFrame, UDim.new(0, 8))
                AddStroke(SliderFrame, Colors.Outline, 1, 0.6)
                
                Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 8),
                    Size = UDim2.new(0.7, -14, 0, 20),
                    Font = Assets.Font,
                    Text = SliderName,
                    TextColor3 = Colors.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = SliderFrame
                })
                
                local SliderValue = Create("TextLabel", {
                    Name = "Value",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.7, 0, 0, 8),
                    Size = UDim2.new(0.3, -14, 0, 20),
                    Font = Assets.FontBold,
                    Text = tostring(Value),
                    TextColor3 = Colors.Accent1,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = SliderFrame
                })
                
                local SliderBar = Create("Frame", {
                    Name = "Bar",
                    BackgroundColor3 = Colors.Main,
                    Position = UDim2.new(0, 14, 0, 38),
                    Size = UDim2.new(1, -28, 0, 10),
                    Parent = SliderFrame
                })
                AddCorner(SliderBar, UDim.new(1, 0))
                
                local SliderFill = Create("Frame", {
                    Name = "Fill",
                    BackgroundColor3 = Colors.Accent1,
                    Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0),
                    Parent = SliderBar
                })
                AddCorner(SliderFill, UDim.new(1, 0))
                AddGradient(SliderFill, Colors.Accent1, Colors.Accent2, 0)
                
                local SliderKnob = Create("Frame", {
                    Name = "Knob",
                    BackgroundColor3 = Colors.Text,
                    Position = UDim2.new((Default - Min) / (Max - Min), -9, 0.5, -9),
                    Size = UDim2.new(0, 18, 0, 18),
                    ZIndex = 5,
                    Parent = SliderBar
                })
                AddCorner(SliderKnob, UDim.new(1, 0))
                AddShadow(SliderKnob, 0.6)
                
                local isDragging = false
                
                local function UpdateSlider(input)
                    local percent = math.clamp(
                        (input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X,
                        0, 1
                    )
                    local raw = Min + ((Max - Min) * percent)
                    Value = math.floor(raw / Increment + 0.5) * Increment
                    Value = math.clamp(Value, Min, Max)
                    
                    local displayPercent = (Value - Min) / (Max - Min)
                    
                    Lieris.Flags[Flag] = Value
                    SliderValue.Text = tostring(Value)
                    Tween(SliderFill, {Size = UDim2.new(displayPercent, 0, 1, 0)}, 0.05)
                    Tween(SliderKnob, {Position = UDim2.new(displayPercent, -8, 0.5, -8)}, 0.05)
                    
                    pcall(Callback, Value)
                end
                
                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        isDragging = true
                        UpdateSlider(input)
                    end
                end)
                
                SliderKnob.InputBegan:Connect(function(input)
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
                
                local SliderObj = {}
                function SliderObj:Set(newValue)
                    Value = math.clamp(newValue, Min, Max)
                    Lieris.Flags[Flag] = Value
                    local percent = (Value - Min) / (Max - Min)
                    SliderValue.Text = tostring(Value)
                    TweenSmooth(SliderFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.2)
                    TweenSmooth(SliderKnob, {Position = UDim2.new(percent, -9, 0.5, -9)}, 0.2)
                    pcall(Callback, Value)
                end
                function SliderObj:Get()
                    return Value
                end
                
                Lieris._elements[Flag] = SliderObj
                return SliderObj
            end
            
            -- INPUT
            function Elements:CreateInput(props)
                props = props or {}
                local InputName = props.Name or "Input"
                local Default = props.Default or ""
                local Placeholder = props.PlaceholderText or "Enter text..."
                local Numeric = props.Numeric or false
                local Finished = props.Finished ~= false
                local Flag = props.Flag or InputName
                local Callback = props.Callback or function() end
                
                Lieris.Flags[Flag] = Default
                Lieris._callbacks[Flag] = Callback
                
                local InputFrame = Create("Frame", {
                    Name = InputName,
                    BackgroundColor3 = Colors.Tertiary,
                    Size = UDim2.new(1, 0, 0, 38),
                    Parent = SectionContent
                })
                AddCorner(InputFrame, UDim.new(0, 8))
                AddStroke(InputFrame, Colors.Outline, 1, 0.6)
                
                Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 0),
                    Size = UDim2.new(0.4, -14, 1, 0),
                    Font = Assets.Font,
                    Text = InputName,
                    TextColor3 = Colors.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = InputFrame
                })
                
                local InputBox = Create("TextBox", {
                    Name = "Box",
                    BackgroundColor3 = Colors.Main,
                    Position = UDim2.new(0.4, 5, 0.5, -14),
                    Size = UDim2.new(0.6, -19, 0, 28),
                    Font = Assets.Font,
                    PlaceholderText = Placeholder,
                    PlaceholderColor3 = Colors.TextDarker,
                    Text = Default,
                    TextColor3 = Colors.Text,
                    TextSize = 13,
                    ClearTextOnFocus = false,
                    Parent = InputFrame
                })
                AddCorner(InputBox, UDim.new(0, 6))
                
                local InputStroke = AddStroke(InputBox, Colors.Outline, 1, 0.6)
                
                InputBox.Focused:Connect(function()
                    TweenSmooth(InputStroke, {Color = Colors.Accent1, Transparency = 0}, 0.2)
                end)
                
                InputBox.FocusLost:Connect(function(enterPressed)
                    TweenSmooth(InputStroke, {Color = Colors.Outline, Transparency = 0.6}, 0.2)
                    
                    local text = InputBox.Text
                    if Numeric then
                        text = text:gsub("[^%d%.%-]", "")
                        InputBox.Text = text
                    end
                    
                    Lieris.Flags[Flag] = text
                    
                    if Finished then
                        if enterPressed then
                            pcall(Callback, text)
                        end
                    else
                        pcall(Callback, text)
                    end
                end)
                
                if not Finished then
                    InputBox:GetPropertyChangedSignal("Text"):Connect(function()
                        local text = InputBox.Text
                        if Numeric then
                            text = text:gsub("[^%d%.%-]", "")
                        end
                        Lieris.Flags[Flag] = text
                        pcall(Callback, text)
                    end)
                end
                
                local InputObj = {}
                function InputObj:Set(text)
                    InputBox.Text = text
                    Lieris.Flags[Flag] = text
                end
                function InputObj:Get()
                    return InputBox.Text
                end
                
                Lieris._elements[Flag] = InputObj
                return InputObj
            end
            
            -- DROPDOWN
            function Elements:CreateDropdown(props)
                props = props or {}
                local DropdownName = props.Name or "Dropdown"
                local Options = props.Options or {"Option 1", "Option 2"}
                local Default = props.Default or Options[1]
                local Multi = props.Multi or false
                local Flag = props.Flag or DropdownName
                local Callback = props.Callback or function() end
                
                local Selected = Multi and {} or Default
                if Multi then
                    for _, opt in ipairs(Options) do
                        Selected[opt] = false
                    end
                end
                
                Lieris.Flags[Flag] = Selected
                Lieris._callbacks[Flag] = Callback
                
                local DropdownFrame = Create("Frame", {
                    Name = DropdownName,
                    BackgroundColor3 = Colors.Tertiary,
                    Size = UDim2.new(1, 0, 0, 38),
                    ClipsDescendants = true,
                    Parent = SectionContent
                })
                AddCorner(DropdownFrame, UDim.new(0, 8))
                AddStroke(DropdownFrame, Colors.Outline, 1, 0.6)
                
                local DropdownButton = Create("TextButton", {
                    Name = "Button",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 38),
                    Text = "",
                    Parent = DropdownFrame
                })
                
                Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 0),
                    Size = UDim2.new(0.5, -14, 1, 0),
                    Font = Assets.Font,
                    Text = DropdownName,
                    TextColor3 = Colors.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = DropdownButton
                })
                
                local function GetDisplayText()
                    if Multi then
                        local selectedItems = {}
                        for opt, sel in pairs(Selected) do
                            if sel then table.insert(selectedItems, opt) end
                        end
                        if #selectedItems == 0 then return "None" end
                        if #selectedItems > 2 then return #selectedItems .. " selected" end
                        return table.concat(selectedItems, ", ")
                    else
                        return Selected or "None"
                    end
                end
                
                local DropdownSelected = Create("TextLabel", {
                    Name = "Selected",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0, 0),
                    Size = UDim2.new(0.5, -35, 1, 0),
                    Font = Assets.Font,
                    Text = GetDisplayText(),
                    TextColor3 = Colors.Accent1,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    Parent = DropdownButton
                })
                
                local DropdownArrow = Create("ImageLabel", {
                    Name = "Arrow",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -28, 0.5, -8),
                    Size = UDim2.new(0, 16, 0, 16),
                    Image = Assets.Icons.ArrowDown,
                    ImageColor3 = Colors.TextDark,
                    Rotation = 0,
                    Parent = DropdownButton
                })
                
                local OptionsContainer = Create("Frame", {
                    Name = "Options",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0, 42),
                    Size = UDim2.new(1, -16, 0, #Options * 30),
                    Parent = DropdownFrame
                })
                
                local OptionsLayout = Create("UIListLayout", {
                    Parent = OptionsContainer,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 4)
                })
                
                local isOpen = false
                
                local function CreateOption(optionName)
                    local OptionButton = Create("TextButton", {
                        Name = optionName,
                        BackgroundColor3 = Colors.Main,
                        Size = UDim2.new(1, 0, 0, 26),
                        Font = Assets.Font,
                        Text = optionName,
                        TextColor3 = Colors.TextDark,
                        TextSize = 13,
                        AutoButtonColor = false,
                        Parent = OptionsContainer
                    })
                    AddCorner(OptionButton, UDim.new(0, 4))
                    
                    local function UpdateOptionVisual()
                        local isSelected = Multi and Selected[optionName] or Selected == optionName
                        if isSelected then
                            Tween(OptionButton, {BackgroundColor3 = Colors.Accent1, TextColor3 = Colors.Text}, 0.15)
                        else
                            Tween(OptionButton, {BackgroundColor3 = Colors.Main, TextColor3 = Colors.TextDark}, 0.15)
                        end
                    end
                    
                    OptionButton.MouseEnter:Connect(function()
                        local isSelected = Multi and Selected[optionName] or Selected == optionName
                        if not isSelected then
                            Tween(OptionButton, {BackgroundColor3 = Colors.Secondary}, 0.1)
                        end
                    end)
                    
                    OptionButton.MouseLeave:Connect(function()
                        local isSelected = Multi and Selected[optionName] or Selected == optionName
                        if not isSelected then
                            Tween(OptionButton, {BackgroundColor3 = Colors.Main}, 0.1)
                        end
                    end)
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        if Multi then
                            Selected[optionName] = not Selected[optionName]
                            Lieris.Flags[Flag] = Selected
                            UpdateOptionVisual()
                            DropdownSelected.Text = GetDisplayText()
                            pcall(Callback, Selected)
                        else
                            Selected = optionName
                            Lieris.Flags[Flag] = Selected
                            DropdownSelected.Text = GetDisplayText()
                            
                            for _, child in ipairs(OptionsContainer:GetChildren()) do
                                if child:IsA("TextButton") then
                                    if child.Name == optionName then
                                        Tween(child, {BackgroundColor3 = Colors.Accent1, TextColor3 = Colors.Text}, 0.15)
                                    else
                                        Tween(child, {BackgroundColor3 = Colors.Main, TextColor3 = Colors.TextDark}, 0.15)
                                    end
                                end
                            end
                            
                            isOpen = false
                            Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 36)}, 0.2)
                            Tween(DropdownArrow, {Rotation = 0}, 0.2)
                            
                            pcall(Callback, Selected)
                        end
                    end)
                    
                    UpdateOptionVisual()
                    return OptionButton
                end
                
                for _, opt in ipairs(Options) do
                    CreateOption(opt)
                end
                
                DropdownButton.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    
                    local optionsHeight = OptionsLayout.AbsoluteContentSize.Y
                    
                    if isOpen then
                        TweenSmooth(DropdownFrame, {Size = UDim2.new(1, 0, 0, 50 + optionsHeight)}, 0.3)
                        TweenSmooth(DropdownArrow, {Rotation = 180}, 0.3)
                    else
                        TweenSmooth(DropdownFrame, {Size = UDim2.new(1, 0, 0, 38)}, 0.25)
                        TweenSmooth(DropdownArrow, {Rotation = 0}, 0.25)
                    end
                end)
                
                local DropdownObj = {}
                
                function DropdownObj:Set(value)
                    if Multi then
                        if typeof(value) == "table" then
                            Selected = value
                        end
                    else
                        Selected = value
                    end
                    Lieris.Flags[Flag] = Selected
                    DropdownSelected.Text = GetDisplayText()
                    
                    for _, child in ipairs(OptionsContainer:GetChildren()) do
                        if child:IsA("TextButton") then
                            local isSelected = Multi and Selected[child.Name] or Selected == child.Name
                            if isSelected then
                                child.BackgroundColor3 = Colors.Accent1
                                child.TextColor3 = Colors.Text
                            else
                                child.BackgroundColor3 = Colors.Main
                                child.TextColor3 = Colors.TextDark
                            end
                        end
                    end
                    
                    pcall(Callback, Selected)
                end
                
                function DropdownObj:Get()
                    return Selected
                end
                
                function DropdownObj:Refresh(newOptions)
                    Options = newOptions
                    
                    for _, child in ipairs(OptionsContainer:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    if Multi then
                        Selected = {}
                        for _, opt in ipairs(Options) do
                            Selected[opt] = false
                        end
                    else
                        Selected = Options[1]
                    end
                    
                    for _, opt in ipairs(Options) do
                        CreateOption(opt)
                    end
                    
                    Lieris.Flags[Flag] = Selected
                    DropdownSelected.Text = GetDisplayText()
                    
                    if isOpen then
                        local optionsHeight = #Options * 30
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 48 + optionsHeight)}, 0.2)
                    end
                end
                
                function DropdownObj:Add(option)
                    table.insert(Options, option)
                    if Multi then
                        Selected[option] = false
                    end
                    CreateOption(option)
                    
                    if isOpen then
                        local optionsHeight = OptionsLayout.AbsoluteContentSize.Y
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 48 + optionsHeight)}, 0.2)
                    end
                end
                
                function DropdownObj:Remove(option)
                    for i, opt in ipairs(Options) do
                        if opt == option then
                            table.remove(Options, i)
                            break
                        end
                    end
                    
                    if Multi then
                        Selected[option] = nil
                    elseif Selected == option then
                        Selected = Options[1]
                    end
                    
                    local optBtn = OptionsContainer:FindFirstChild(option)
                    if optBtn then
                        optBtn:Destroy()
                    end
                    
                    Lieris.Flags[Flag] = Selected
                    DropdownSelected.Text = GetDisplayText()
                    
                    if isOpen then
                        local optionsHeight = OptionsLayout.AbsoluteContentSize.Y
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 48 + optionsHeight)}, 0.2)
                    end
                end
                
                Lieris._elements[Flag] = DropdownObj
                return DropdownObj
            end
            
            -- KEYBIND
            function Elements:CreateKeybind(props)
                props = props or {}
                local KeybindName = props.Name or "Keybind"
                local Default = props.Default or Enum.KeyCode.E
                local Hold = props.Hold or false
                local Flag = props.Flag or KeybindName
                local Callback = props.Callback or function() end
                local ChangedCallback = props.ChangedCallback or function() end
                
                local CurrentKey = Default
                local Listening = false
                local Holding = false
                
                Lieris.Flags[Flag] = CurrentKey
                Lieris._callbacks[Flag] = Callback
                
                local KeybindFrame = Create("Frame", {
                    Name = KeybindName,
                    BackgroundColor3 = Colors.Tertiary,
                    Size = UDim2.new(1, 0, 0, 38),
                    Parent = SectionContent
                })
                AddCorner(KeybindFrame, UDim.new(0, 8))
                AddStroke(KeybindFrame, Colors.Outline, 1, 0.6)
                
                Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 0),
                    Size = UDim2.new(1, -105, 1, 0),
                    Font = Assets.Font,
                    Text = KeybindName,
                    TextColor3 = Colors.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = KeybindFrame
                })
                
                local KeybindButton = Create("TextButton", {
                    Name = "Button",
                    BackgroundColor3 = Colors.Main,
                    Position = UDim2.new(1, -90, 0.5, -14),
                    Size = UDim2.new(0, 80, 0, 28),
                    Font = Assets.FontBold,
                    Text = CurrentKey.Name,
                    TextColor3 = Colors.Accent1,
                    TextSize = 12,
                    AutoButtonColor = false,
                    Parent = KeybindFrame
                })
                AddCorner(KeybindButton, UDim.new(0, 6))
                AddStroke(KeybindButton, Colors.Outline, 1, 0.6)
                
                KeybindButton.MouseButton1Click:Connect(function()
                    if Listening then return end
                    Listening = true
                    KeybindButton.Text = "..."
                    TweenSmooth(KeybindButton, {TextColor3 = Colors.Accent2, BackgroundColor3 = Colors.Tertiary}, 0.2)
                end)
                
                UserInputService.InputBegan:Connect(function(input, processed)
                    if Listening then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            CurrentKey = input.KeyCode
                            Lieris.Flags[Flag] = CurrentKey
                            KeybindButton.Text = CurrentKey.Name
                            TweenSmooth(KeybindButton, {TextColor3 = Colors.Accent1, BackgroundColor3 = Colors.Main}, 0.2)
                            Listening = false
                            pcall(ChangedCallback, CurrentKey)
                        end
                    elseif not processed then
                        if input.KeyCode == CurrentKey then
                            if Hold then
                                Holding = true
                                pcall(Callback, true)
                            else
                                pcall(Callback)
                            end
                        end
                    end
                end)
                
                if Hold then
                    UserInputService.InputEnded:Connect(function(input)
                        if input.KeyCode == CurrentKey and Holding then
                            Holding = false
                            pcall(Callback, false)
                        end
                    end)
                end
                
                local KeybindObj = {}
                function KeybindObj:Set(key)
                    CurrentKey = key
                    Lieris.Flags[Flag] = CurrentKey
                    KeybindButton.Text = CurrentKey.Name
                    pcall(ChangedCallback, CurrentKey)
                end
                function KeybindObj:Get()
                    return CurrentKey
                end
                
                Lieris._elements[Flag] = KeybindObj
                return KeybindObj
            end
            
            -- COLOR PICKER
            function Elements:CreateColorPicker(props)
                props = props or {}
                local ColorName = props.Name or "Color Picker"
                local Default = props.Default or Color3.fromRGB(255, 255, 255)
                local Flag = props.Flag or ColorName
                local Callback = props.Callback or function() end
                
                local CurrentColor = Default
                local H, S, V = Color3.toHSV(Default)
                local isOpen = false
                
                Lieris.Flags[Flag] = CurrentColor
                Lieris._callbacks[Flag] = Callback
                
                local ColorFrame = Create("Frame", {
                    Name = ColorName,
                    BackgroundColor3 = Colors.Tertiary,
                    Size = UDim2.new(1, 0, 0, 38),
                    ClipsDescendants = true,
                    Parent = SectionContent
                })
                AddCorner(ColorFrame, UDim.new(0, 8))
                AddStroke(ColorFrame, Colors.Outline, 1, 0.6)
                
                local ColorButton = Create("TextButton", {
                    Name = "Button",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 38),
                    Text = "",
                    Parent = ColorFrame
                })
                
                Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 14, 0, 0),
                    Size = UDim2.new(1, -70, 1, 0),
                    Font = Assets.Font,
                    Text = ColorName,
                    TextColor3 = Colors.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = ColorButton
                })
                
                local ColorDisplay = Create("Frame", {
                    Name = "Display",
                    BackgroundColor3 = CurrentColor,
                    Position = UDim2.new(1, -52, 0.5, -12),
                    Size = UDim2.new(0, 42, 0, 24),
                    Parent = ColorButton
                })
                AddCorner(ColorDisplay, UDim.new(0, 6))
                AddStroke(ColorDisplay, Color3.fromRGB(255, 255, 255), 1, 0.2)
                
                local PickerPanel = Create("Frame", {
                    Name = "Panel",
                    BackgroundColor3 = Colors.Main,
                    Position = UDim2.new(0, 10, 0, 46),
                    Size = UDim2.new(1, -20, 0, 150),
                    Parent = ColorFrame
                })
                AddCorner(PickerPanel, UDim.new(0, 8))
                AddStroke(PickerPanel, Colors.Outline, 1, 0.4)
                
                local SVPicker = Create("ImageLabel", {
                    Name = "SVPicker",
                    BackgroundColor3 = Color3.fromHSV(H, 1, 1),
                    Position = UDim2.new(0, 10, 0, 10),
                    Size = UDim2.new(1, -55, 1, -20),
                    Image = "rbxassetid://4155801252",
                    Parent = PickerPanel
                })
                AddCorner(SVPicker, UDim.new(0, 6))
                
                local SVCursor = Create("Frame", {
                    Name = "Cursor",
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    Position = UDim2.new(S, -6, 1 - V, -6),
                    Size = UDim2.new(0, 12, 0, 12),
                    ZIndex = 5,
                    Parent = SVPicker
                })
                AddCorner(SVCursor, UDim.new(1, 0))
                AddStroke(SVCursor, Color3.new(0, 0, 0), 2, 0)
                
                local HueBar = Create("Frame", {
                    Name = "HueBar",
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    Position = UDim2.new(1, -35, 0, 10),
                    Size = UDim2.new(0, 24, 1, -20),
                    Parent = PickerPanel
                })
                AddCorner(HueBar, UDim.new(0, 6))
                
                Create("UIGradient", {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                        ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
                        ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                        ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
                        ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                    }),
                    Rotation = 90,
                    Parent = HueBar
                })
                
                local HueCursor = Create("Frame", {
                    Name = "Cursor",
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    Position = UDim2.new(0.5, -8, H, -4),
                    Size = UDim2.new(0, 16, 0, 8),
                    ZIndex = 5,
                    Parent = HueBar
                })
                AddCorner(HueCursor, UDim.new(0, 3))
                AddStroke(HueCursor, Color3.new(0, 0, 0), 2, 0)
                
                local function UpdateColor()
                    CurrentColor = Color3.fromHSV(H, S, V)
                    Lieris.Flags[Flag] = CurrentColor
                    ColorDisplay.BackgroundColor3 = CurrentColor
                    SVPicker.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
                    pcall(Callback, CurrentColor)
                end
                
                local draggingSV = false
                local draggingHue = false
                
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
                            S = pos.X
                            V = 1 - pos.Y
                            SVCursor.Position = UDim2.new(S, -6, 1 - V, -6)
                            UpdateColor()
                        elseif draggingHue then
                            local pos = math.clamp((input.Position.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
                            H = pos
                            HueCursor.Position = UDim2.new(0.5, -8, H, -4)
                            UpdateColor()
                        end
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingSV = false
                        draggingHue = false
                    end
                end)
                
                ColorButton.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    
                    if isOpen then
                        TweenSmooth(ColorFrame, {Size = UDim2.new(1, 0, 0, 210)}, 0.3)
                    else
                        TweenSmooth(ColorFrame, {Size = UDim2.new(1, 0, 0, 38)}, 0.25)
                    end
                end)
                
                local ColorObj = {}
                function ColorObj:Set(color)
                    CurrentColor = color
                    H, S, V = Color3.toHSV(color)
                    Lieris.Flags[Flag] = CurrentColor
                    ColorDisplay.BackgroundColor3 = CurrentColor
                    SVPicker.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
                    SVCursor.Position = UDim2.new(S, -6, 1 - V, -6)
                    HueCursor.Position = UDim2.new(0.5, -8, H, -4)
                end
                function ColorObj:Get()
                    return CurrentColor
                end
                
                Lieris._elements[Flag] = ColorObj
                return ColorObj
            end
            
            return Elements
        end
        
        return TabObj
    end
    
    -- BUILT-IN CONFIG MANAGER TAB
    local ConfigManagerTab = WindowObj:CreateTab({
        Name = "Config Manager",
        Icon = Assets.Icons.Settings
    })
    
    -- ========================================
    -- CONFIGURATION SECTION
    -- ========================================
    local ConfigSection = ConfigManagerTab:CreateSection("Configuration")
    
    ConfigSection:CreateParagraph({
        Title = "Save & Load Settings",
        Content = "Manage your configurations. Save current settings, load previously saved configs, or delete unwanted ones."
    })
    
    local ConfigDropdown
    
    local function RefreshConfigList()
        local configs = Lieris:GetConfigs()
        if #configs == 0 then
            configs = {"default"}
        end
        if ConfigDropdown then
            ConfigDropdown:Refresh(configs)
        end
        return configs
    end
    
    ConfigDropdown = ConfigSection:CreateDropdown({
        Name = "Select Config",
        Options = RefreshConfigList(),
        Default = "default",
        Flag = "SelectedConfig",
        Callback = function(value)
            Lieris.CurrentConfig = value
        end
    })
    
    ConfigSection:CreateInput({
        Name = "New Config Name",
        Default = "",
        PlaceholderText = "Enter new config name...",
        Flag = "NewConfigName",
        Callback = function() end
    })
    
    ConfigSection:CreateButton({
        Name = "Create & Save New Config",
        Callback = function()
            local newName = Lieris.Flags.NewConfigName
            if newName and newName ~= "" then
                Lieris.CurrentConfig = newName
                local success = Lieris:SaveConfig(newName)
                if success then
                    RefreshConfigList()
                    ConfigDropdown:Set(newName)
                    Lieris:Notify({
                        Title = "Config Created",
                        Content = "Created and saved: " .. newName,
                        Type = "Success",
                        Duration = 3
                    })
                else
                    Lieris:Notify({
                        Title = "Failed",
                        Content = "Could not create config",
                        Type = "Error",
                        Duration = 3
                    })
                end
            else
                Lieris:Notify({
                    Title = "Error",
                    Content = "Please enter a config name",
                    Type = "Warning",
                    Duration = 3
                })
            end
        end
    })
    
    ConfigSection:CreateDivider()
    
    ConfigSection:CreateButton({
        Name = "Save Current Config",
        Callback = function()
            local success = Lieris:SaveConfig(Lieris.CurrentConfig)
            if success then
                Lieris:Notify({
                    Title = "Saved",
                    Content = "Configuration saved: " .. Lieris.CurrentConfig,
                    Type = "Success",
                    Duration = 3
                })
            else
                Lieris:Notify({
                    Title = "Save Failed",
                    Content = "Could not save configuration",
                    Type = "Error",
                    Duration = 3
                })
            end
        end
    })
    
    ConfigSection:CreateButton({
        Name = "Load Selected Config",
        Callback = function()
            local success = Lieris:LoadConfig(Lieris.CurrentConfig)
            if success then
                Lieris:Notify({
                    Title = "Loaded",
                    Content = "Configuration loaded: " .. Lieris.CurrentConfig,
                    Type = "Success",
                    Duration = 3
                })
            else
                Lieris:Notify({
                    Title = "Load Failed",
                    Content = "Could not find configuration",
                    Type = "Error",
                    Duration = 3
                })
            end
        end
    })
    
    ConfigSection:CreateButton({
        Name = "Delete Selected Config",
        Callback = function()
            if Lieris.CurrentConfig == "default" then
                Lieris:Notify({
                    Title = "Warning",
                    Content = "Cannot delete default config",
                    Type = "Warning",
                    Duration = 3
                })
                return
            end
            local success = Lieris:DeleteConfig(Lieris.CurrentConfig)
            if success then
                Lieris:Notify({
                    Title = "Deleted",
                    Content = "Configuration deleted: " .. Lieris.CurrentConfig,
                    Type = "Warning",
                    Duration = 3
                })
                Lieris.CurrentConfig = "default"
                RefreshConfigList()
                ConfigDropdown:Set("default")
            else
                Lieris:Notify({
                    Title = "Delete Failed",
                    Content = "Could not delete configuration",
                    Type = "Error",
                    Duration = 3
                })
            end
        end
    })
    
    ConfigSection:CreateButton({
        Name = "Refresh Config List",
        Callback = function()
            RefreshConfigList()
            Lieris:Notify({
                Title = "Refreshed",
                Content = "Config list updated",
                Type = "Info",
                Duration = 2
            })
        end
    })
    
    -- ========================================
    -- THEME COLORS SECTION
    -- ========================================
    local ThemeSection = ConfigManagerTab:CreateSection("Theme Colors")
    
    ThemeSection:CreateParagraph({
        Title = "Customize Colors",
        Content = "Personalize the interface by changing accent colors. Changes apply in real-time."
    })
    
    ThemeSection:CreateColorPicker({
        Name = "Primary Accent",
        Default = Colors.Accent1,
        Flag = "ThemeAccent1",
        Callback = function(color)
            Colors.Accent1 = color
        end
    })
    
    ThemeSection:CreateColorPicker({
        Name = "Secondary Accent",
        Default = Colors.Accent2,
        Flag = "ThemeAccent2",
        Callback = function(color)
            Colors.Accent2 = color
        end
    })
    
    ThemeSection:CreateColorPicker({
        Name = "Text Color",
        Default = Colors.Text,
        Flag = "ThemeText",
        Callback = function(color)
            Colors.Text = color
        end
    })
    
    ThemeSection:CreateColorPicker({
        Name = "Secondary Text",
        Default = Colors.TextDark,
        Flag = "ThemeTextDark",
        Callback = function(color)
            Colors.TextDark = color
        end
    })
    
    ThemeSection:CreateButton({
        Name = "Reset to Default Colors",
        Callback = function()
            Colors.Accent1 = Color3.fromRGB(80, 120, 255)
            Colors.Accent2 = Color3.fromRGB(150, 80, 255)
            Colors.Text = Color3.fromRGB(250, 250, 255)
            Colors.TextDark = Color3.fromRGB(145, 145, 165)
            
            Lieris.Flags.ThemeAccent1 = Colors.Accent1
            Lieris.Flags.ThemeAccent2 = Colors.Accent2
            Lieris.Flags.ThemeText = Colors.Text
            Lieris.Flags.ThemeTextDark = Colors.TextDark
            
            Lieris:Notify({
                Title = "Colors Reset",
                Content = "Theme colors restored to defaults",
                Type = "Info",
                Duration = 3
            })
        end
    })
    
    -- ========================================
    -- INTERFACE SETTINGS SECTION
    -- ========================================
    local InterfaceSection = ConfigManagerTab:CreateSection("Interface Settings")
    
    InterfaceSection:CreateKeybind({
        Name = "Toggle UI Hotkey",
        Default = Enum.KeyCode.RightShift,
        Flag = "UIToggleKey",
        Callback = function()
            WindowObj:ToggleUI()
        end,
        ChangedCallback = function(key)
            Lieris:Notify({
                Title = "Hotkey Changed",
                Content = "UI toggle key set to: " .. key.Name,
                Type = "Info",
                Duration = 2
            })
        end
    })
    
    InterfaceSection:CreateToggle({
        Name = "Show Notifications",
        Default = true,
        Flag = "ShowNotifications",
        Callback = function(value)
            Lieris.NotificationsEnabled = value
        end
    })
    
    InterfaceSection:CreateSlider({
        Name = "Notification Duration",
        Min = 1,
        Max = 10,
        Default = 3,
        Increment = 0.5,
        Flag = "NotificationDuration",
        Callback = function(value)
            Lieris.DefaultNotificationDuration = value
        end
    })
    
    InterfaceSection:CreateToggle({
        Name = "Auto-Load Last Config",
        Default = false,
        Flag = "AutoLoadConfig",
        Callback = function(value)
            Lieris.AutoLoadConfig = value
        end
    })
    
    InterfaceSection:CreateToggle({
        Name = "Auto-Save on Close",
        Default = false,
        Flag = "AutoSaveOnClose",
        Callback = function(value)
            Lieris.AutoSaveOnClose = value
        end
    })
    
    -- ========================================
    -- PRESETS SECTION
    -- ========================================
    local PresetsSection = ConfigManagerTab:CreateSection("Color Presets")
    
    PresetsSection:CreateParagraph({
        Title = "Quick Themes",
        Content = "Apply pre-made color schemes with one click."
    })
    
    PresetsSection:CreateButton({
        Name = "Blue Theme",
        Callback = function()
            Colors.Accent1 = Color3.fromRGB(80, 120, 255)
            Colors.Accent2 = Color3.fromRGB(100, 150, 255)
            Lieris:Notify({Title = "Theme Applied", Content = "Blue theme activated", Type = "Success", Duration = 2})
        end
    })
    
    PresetsSection:CreateButton({
        Name = "Purple Theme",
        Callback = function()
            Colors.Accent1 = Color3.fromRGB(150, 80, 255)
            Colors.Accent2 = Color3.fromRGB(180, 120, 255)
            Lieris:Notify({Title = "Theme Applied", Content = "Purple theme activated", Type = "Success", Duration = 2})
        end
    })
    
    PresetsSection:CreateButton({
        Name = "Green Theme",
        Callback = function()
            Colors.Accent1 = Color3.fromRGB(60, 200, 120)
            Colors.Accent2 = Color3.fromRGB(100, 230, 150)
            Lieris:Notify({Title = "Theme Applied", Content = "Green theme activated", Type = "Success", Duration = 2})
        end
    })
    
    PresetsSection:CreateButton({
        Name = "Red Theme",
        Callback = function()
            Colors.Accent1 = Color3.fromRGB(255, 80, 80)
            Colors.Accent2 = Color3.fromRGB(255, 120, 100)
            Lieris:Notify({Title = "Theme Applied", Content = "Red theme activated", Type = "Success", Duration = 2})
        end
    })
    
    PresetsSection:CreateButton({
        Name = "Orange Theme",
        Callback = function()
            Colors.Accent1 = Color3.fromRGB(255, 140, 50)
            Colors.Accent2 = Color3.fromRGB(255, 180, 80)
            Lieris:Notify({Title = "Theme Applied", Content = "Orange theme activated", Type = "Success", Duration = 2})
        end
    })
    
    PresetsSection:CreateButton({
        Name = "Pink Theme",
        Callback = function()
            Colors.Accent1 = Color3.fromRGB(255, 100, 150)
            Colors.Accent2 = Color3.fromRGB(255, 150, 200)
            Lieris:Notify({Title = "Theme Applied", Content = "Pink theme activated", Type = "Success", Duration = 2})
        end
    })
    
    PresetsSection:CreateButton({
        Name = "Cyan Theme",
        Callback = function()
            Colors.Accent1 = Color3.fromRGB(60, 200, 220)
            Colors.Accent2 = Color3.fromRGB(100, 230, 250)
            Lieris:Notify({Title = "Theme Applied", Content = "Cyan theme activated", Type = "Success", Duration = 2})
        end
    })
    
    -- ========================================
    -- INFO SECTION
    -- ========================================
    local InfoSection = ConfigManagerTab:CreateSection("Information")
    
    InfoSection:CreateParagraph({
        Title = "Lieris UI Library v3.0",
        Content = "A modern, feature-rich UI library designed for creating beautiful and functional script interfaces. Documentation is included at the top of this file."
    })
    
    InfoSection:CreateButton({
        Name = "Copy GitHub Link",
        Callback = function()
            if setclipboard then
                setclipboard("https://github.com/ccodix/Lieris")
                Lieris:Notify({
                    Title = "Copied",
                    Content = "GitHub link copied to clipboard",
                    Type = "Success",
                    Duration = 2
                })
            end
        end
    })
    
    InfoSection:CreateLabel("Created with care for the community")
    
    return WindowObj
end

-- ============================================================================
-- EXPOSE LIBRARY
-- ============================================================================

Lieris.Icons = Assets.Icons
Lieris.Assets = Assets
Lieris.Colors = Colors

return Lieris
