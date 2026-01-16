--[[
    Lieris Ui Library
    Version: 2.0 (Redesign)
    Created for robust and aesthetic Roblox script interfaces.
    
    Credits:
    - Design & Logic: GitHub Copilot / Gemini
    - Assets: Provided by User
]]

local LierisUi = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- [ Assets ] --
local Assets = {
    Background = "rbxassetid://120912477451723",
    Logo = "rbxassetid://93564507432615",
    CloseButton = "rbxassetid://75618206104636",
    MinimizeButton = "rbxassetid://95966901348174",
    Font = Enum.Font.Gotham,
    FontBold = Enum.Font.GothamBold
}

-- [ Colors ] --
local Colors = {
    Main = Color3.fromRGB(15, 15, 15),
    Secondary = Color3.fromRGB(25, 25, 25),
    Text = Color3.fromRGB(240, 240, 240),
    TextDark = Color3.fromRGB(150, 150, 150),
    Accent1 = Color3.fromRGB(0, 120, 255), -- Blue
    Accent2 = Color3.fromRGB(140, 0, 255), -- Purple
    Outline = Color3.fromRGB(40, 40, 40)
}

-- [ Constants ] --
LierisUi.Flags = {}
LierisUi.ConfigFolder = "LierisConfigs"
LierisUi.CurrentConfig = "default"

-- [ Utility Functions ] --
local function Create(class, properties)
    local instance = Instance.new(class)
    for k, v in pairs(properties) do
        instance[k] = v
    end
    return instance
end

local function MakeDraggable(frame, dragHandle)
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

local function Tween(instance, properties, duration)
    local info = TweenInfo.new(duration or 0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

-- [ Save/Load System ] --
function LierisUi:SaveConfig(name)
    local json = game:GetService("HttpService"):JSONEncode(LierisUi.Flags)
    local path = LierisUi.ConfigFolder .. "/" .. name .. ".json"
    if writefile then
        writefile(path, json)
    end
end

function LierisUi:LoadConfig(name)
    local path = LierisUi.ConfigFolder .. "/" .. name .. ".json"
    if isfile and isfile(path) then
        local content = readfile(path)
        local data = game:GetService("HttpService"):JSONDecode(content)
        for flag, value in pairs(data) do
            if LierisUi.Flags[flag] ~= nil then
                -- This assumes elements update LierisUi.Flags directly.
                -- In a real scenario, we need callbacks to update visual state.
                -- For simplicity, we just store data here. A proper implementation needs ValueChanged events.
                LierisUi.Flags[flag] = value
            end
        end
    end
end

local function EnsureConfigSystem()
    if not isfolder then return end
    if not isfolder(LierisUi.ConfigFolder) then
        makefolder(LierisUi.ConfigFolder)
    end
end

-- [ Library Main ] --
function LierisUi:CreateWindow(options)
    options = options or {}
    local Name = options.Name or "Lieris Ui"
    LierisUi.ConfigFolder = options.ConfigFolder or "LierisConfigs"
    EnsureConfigSystem()

    local ScreenGui = Create("ScreenGui", {
        Name = "LierisUI_" .. game:GetService("HttpService"):GenerateGUID(false),
        Parent = CoreGui,
        ResetOnSpawn = false,
        DisplayOrder = 100
    })
    
    local MainFrame = Create("ImageLabel", {
        Name = "MainFrame",
        Parent = ScreenGui,
        Size = UDim2.new(0, 700, 0, 450),
        Position = UDim2.new(0.5, -350, 0.5, -225),
        BackgroundColor3 = Colors.Main,
        BorderSizePixel = 0,
        Image = Assets.Background,
        ScaleType = Enum.ScaleType.Crop,
        ClipsDescendants = true
    })
    
    Create("UICorner", {Parent = MainFrame, CornerRadius = UDim.new(0, 10)})
    MakeDraggable(MainFrame, MainFrame)
    
    -- Subtle Glow
    Create("UIStroke", {
        Parent = MainFrame,
        Color = Colors.Accent1,
        Transparency = 0.8,
        Thickness = 2,
    })

    -- Top Bar
    local TopBar = Create("Frame", {
        Name = "TopBar",
        Parent = MainFrame,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1
    })
    
    local Logo = Create("ImageLabel", {
        Name = "Logo",
        Parent = TopBar,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 10, 0, 5),
        Image = Assets.Logo,
        BackgroundTransparency = 1
    })
    
    local Title = Create("TextLabel", {
        Name = "Title",
        Parent = TopBar,
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 50, 0, 0),
        Text = Name,
        TextColor3 = Colors.Text,
        Font = Assets.FontBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1
    })
    
    -- Window Buttons
    local CloseBtn = Create("ImageButton", {
        Name = "Close",
        Parent = TopBar,
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(1, -35, 0, 7),
        Image = Assets.CloseButton,
        BackgroundTransparency = 1
    })
    
    local MinimizeBtn = Create("ImageButton", {
        Name = "Minimize",
        Parent = TopBar,
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(1, -65, 0, 7),
        Image = Assets.MinimizeButton,
        BackgroundTransparency = 1
    })
    
    -- Interactions
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    local minimized = false
    MinimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(MainFrame, {Size = UDim2.new(0, 700, 0, 40)})
        else
            Tween(MainFrame, {Size = UDim2.new(0, 700, 0, 450)})
        end
    end)
    
    -- Container for Tabs/Sections
    local TabContainer = Create("Frame", {
        Name = "TabContainer",
        Parent = MainFrame,
        Size = UDim2.new(0, 150, 1, -50),
        Position = UDim2.new(0, 10, 0, 45),
        BackgroundColor3 = Colors.Secondary,
        BackgroundTransparency = 0.5
    })
    Create("UICorner", {Parent = TabContainer, CornerRadius = UDim.new(0, 6)})
    
    local TabListLayout = Create("UIListLayout", {
        Parent = TabContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    Create("UIPadding", {Parent = TabContainer, PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5)})
    
    local PagesContainer = Create("Frame", {
        Name = "PagesContainer",
        Parent = MainFrame,
        Size = UDim2.new(1, -175, 1, -55),
        Position = UDim2.new(0, 170, 0, 45),
        BackgroundTransparency = 1
    })

    local WindowObj = {}
    local Tabs = {}
    local FirstTab = true

    function WindowObj:CreateTab(tabOptions)
        tabOptions = tabOptions or {}
        local TabName = tabOptions.Name or "Tab"
        
        local TabButton = Create("TextButton", {
            Name = TabName .. "Btn",
            Parent = TabContainer,
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = Colors.Secondary,
            BackgroundTransparency = 1,
            Text = TabName,
            TextColor3 = Colors.TextDark,
            Font = Assets.Font,
            TextSize = 14
        })
        Create("UICorner", {Parent = TabButton, CornerRadius = UDim.new(0, 6)})
        
        local Page = Create("ScrollingFrame", {
            Name = TabName .. "Page",
            Parent = PagesContainer,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Colors.Accent2,
            Visible = false
        })
        Create("UIListLayout", {
            Parent = Page,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        })
        
        -- Tab Switching
        local function Activate()
            for _, t in pairs(Tabs) do
                Tween(t.Btn, {BackgroundTransparency = 1, TextColor3 = Colors.TextDark})
                t.Page.Visible = false
            end
            Tween(TabButton, {BackgroundTransparency = 0.8, TextColor3 = Colors.Text})
            Page.Visible = true
        end
        
        TabButton.MouseButton1Click:Connect(Activate)
        
        if FirstTab then
            FirstTab = false
            Activate()
        end
        
        table.insert(Tabs, {Btn = TabButton, Page = Page})
        
        local TabObj = {}
        
        function TabObj:CreateSection(sectionName)
            local SectionFrame = Create("Frame", {
                Parent = Page,
                Size = UDim2.new(1, -10, 0, 30), -- Auto scaled height
                BackgroundColor3 = Colors.Secondary,
                BackgroundTransparency = 0.4
            })
            Create("UICorner", {Parent = SectionFrame, CornerRadius = UDim.new(0, 6)})
            
            local SectionTitle = Create("TextLabel", {
                Parent = SectionFrame,
                Size = UDim2.new(1, -20, 0, 30),
                Position = UDim2.new(0, 10, 0, 0),
                Text = sectionName,
                TextColor3 = Colors.Accent1,
                Font = Assets.FontBold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1
            })
            
            local SectionContent = Create("Frame", {
                Parent = SectionFrame,
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 0, 35),
                BackgroundTransparency = 1
            })
            
            local SectionLayout = Create("UIListLayout", {
                Parent = SectionContent,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 5)
            })
            Create("UIPadding", {Parent = SectionContent, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10)})
            
            -- Auto Resize
            SectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionContent.Size = UDim2.new(1, 0, 0, SectionLayout.AbsoluteContentSize.Y)
                SectionFrame.Size = UDim2.new(1, -10, 0, SectionLayout.AbsoluteContentSize.Y + 45)
            end)
            
            local Elements = {}
            
            -- [ LABEL ] --
            function Elements:CreateLabel(text)
                local Label = Create("TextLabel", {
                    Parent = SectionContent,
                    Size = UDim2.new(1, 0, 0, 20),
                    Text = text or "Label",
                    TextColor3 = Colors.TextDark,
                    Font = Assets.Font,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1
                })
            end
            
            -- [ BUTTON ] --
            function Elements:CreateButton(props)
                local Btn = Create("TextButton", {
                    Parent = SectionContent,
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = Colors.Main,
                    Text = props.Name or "Button",
                    TextColor3 = Colors.Text,
                    Font = Assets.Font,
                    TextSize = 14,
                    AutoButtonColor = false
                })
                Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0, 6)})
                Create("UIStroke", {Parent = Btn, Color = Colors.Outline, Thickness = 1})
                
                Btn.MouseEnter:Connect(function() Tween(Btn, {BackgroundColor3 = Colors.Accent1}) end)
                Btn.MouseLeave:Connect(function() Tween(Btn, {BackgroundColor3 = Colors.Main}) end)
                Btn.MouseButton1Click:Connect(function()
                    if props.Callback then props.Callback() end
                end)
            end
            
            -- [ TOGGLE ] --
            function Elements:CreateToggle(props)
                local Current = props.Default or false
                local Flag = props.Flag or props.Name
                LierisUi.Flags[Flag] = Current
                
                local ToggleFrame = Create("Frame", {
                    Parent = SectionContent,
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundTransparency = 1
                })
                
                local Label = Create("TextLabel", {
                    Parent = ToggleFrame,
                    Size = UDim2.new(1, -50, 1, 0),
                    Text = props.Name or "Toggle",
                    TextColor3 = Colors.Text,
                    Font = Assets.Font,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1
                })
                
                local Toggler = Create("TextButton", {
                    Parent = ToggleFrame,
                    Size = UDim2.new(0, 40, 0, 20),
                    Position = UDim2.new(1, -40, 0.5, -10),
                    BackgroundColor3 = Current and Colors.Accent2 or Colors.Main,
                    Text = "",
                    AutoButtonColor = false
                })
                Create("UICorner", {Parent = Toggler, CornerRadius = UDim.new(1, 0)})
                
                local Circle = Create("Frame", {
                    Parent = Toggler,
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = Current and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                    BackgroundColor3 = Colors.Text,
                })
                Create("UICorner", {Parent = Circle, CornerRadius = UDim.new(1, 0)})
                
                Toggler.MouseButton1Click:Connect(function()
                    Current = not Current
                    LierisUi.Flags[Flag] = Current
                    
                    if Current then
                        Tween(Toggler, {BackgroundColor3 = Colors.Accent2})
                        Tween(Circle, {Position = UDim2.new(1, -18, 0.5, -8)})
                    else
                        Tween(Toggler, {BackgroundColor3 = Colors.Main})
                        Tween(Circle, {Position = UDim2.new(0, 2, 0.5, -8)})
                    end
                    
                    if props.Callback then props.Callback(Current) end
                end)
            end
            
            -- [ SLIDER ] --
            function Elements:CreateSlider(props)
                local Min = props.Min or 0
                local Max = props.Max or 100
                local Default = props.Default or Min
                local Flag = props.Flag or props.Name
                LierisUi.Flags[Flag] = Default
                
                local SliderFrame = Create("Frame", {
                    Parent = SectionContent,
                    Size = UDim2.new(1, 0, 0, 50),
                    BackgroundTransparency = 1
                })
                
                local Label = Create("TextLabel", {
                    Parent = SliderFrame,
                    Size = UDim2.new(1, 0, 0, 20),
                    Text = props.Name or "Slider",
                    TextColor3 = Colors.Text,
                    Font = Assets.Font,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1
                })
                
                local ValueLabel = Create("TextLabel", {
                    Parent = SliderFrame,
                    Size = UDim2.new(1, 0, 0, 20),
                    Text = tostring(Default),
                    TextColor3 = Colors.TextDark,
                    Font = Assets.Font,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    BackgroundTransparency = 1
                })
                
                local SliderBar = Create("Frame", {
                    Parent = SliderFrame,
                    Size = UDim2.new(1, 0, 0, 6),
                    Position = UDim2.new(0, 0, 0, 30),
                    BackgroundColor3 = Colors.Main
                })
                Create("UICorner", {Parent = SliderBar, CornerRadius = UDim.new(1, 0)})
                
                local Fill = Create("Frame", {
                    Parent = SliderBar,
                    Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0),
                    BackgroundColor3 = Colors.Accent1
                })
                Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(1, 0)})
                
                local isDragging = false
                
                local function Update(input)
                    local SizeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    local NewValue = math.floor(Min + ((Max - Min) * SizeX))
                    
                    LierisUi.Flags[Flag] = NewValue
                    ValueLabel.Text = tostring(NewValue)
                    Tween(Fill, {Size = UDim2.new(SizeX, 0, 1, 0)}, 0.05)
                    
                    if props.Callback then props.Callback(NewValue) end
                end
                
                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        isDragging = true
                        Update(input)
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
            end

            -- [ TEXTBOX ] --
            function Elements:CreateInput(props)
                local Flag = props.Flag or props.Name
                
                local InputFrame = Create("Frame", {
                    Parent = SectionContent,
                    Size = UDim2.new(1, 0, 0, 40),
                    BackgroundTransparency = 1
                })
                
                local Label = Create("TextLabel", {
                    Parent = InputFrame,
                    Size = UDim2.new(1, 0, 0, 20),
                    Text = props.Name or "Input",
                    TextColor3 = Colors.Text,
                    Font = Assets.Font,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1
                })
                
                local Box = Create("TextBox", {
                    Parent = InputFrame,
                    Size = UDim2.new(1, 0, 0, 20),
                    Position = UDim2.new(0, 0, 0, 20),
                    BackgroundColor3 = Colors.Main,
                    Text = "",
                    PlaceholderText = props.PlaceholderText or "...",
                    TextColor3 = Colors.Text,
                    Font = Assets.Font,
                    TextSize = 14,
                    ClearTextOnFocus = false
                })
                Create("UICorner", {Parent = Box, CornerRadius = UDim.new(0, 4)})
                
                Box.FocusLost:Connect(function(enter)
                    LierisUi.Flags[Flag] = Box.Text
                    if props.Callback then props.Callback(Box.Text) end
                end)
            end

            -- [ DROPDOWN ] --
            function Elements:CreateDropdown(props)
                local Flag = props.Flag or props.Name
                local Options = props.Options or {"Option 1", "Option 2"}
                local Default = props.Default or Options[1]
                LierisUi.Flags[Flag] = Default
                
                local DropdownFrame = Create("Frame", {
                    Parent = SectionContent,
                    Size = UDim2.new(1, 0, 0, 40),
                    BackgroundTransparency = 1
                })
                
                local Label = Create("TextLabel", {
                    Parent = DropdownFrame,
                    Size = UDim2.new(1, 0, 0, 20),
                    Text = props.Name or "Dropdown",
                    TextColor3 = Colors.Text,
                    Font = Assets.Font,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1
                })
                
                local DropdownButton = Create("TextButton", {
                    Parent = DropdownFrame,
                    Size = UDim2.new(1, 0, 0, 20),
                    Position = UDim2.new(0, 0, 0, 20),
                    BackgroundColor3 = Colors.Main,
                    Text = Default,
                    TextColor3 = Colors.Text,
                    Font = Assets.Font,
                    TextSize = 14,
                    AutoButtonColor = false
                })
                Create("UICorner", {Parent = DropdownButton, CornerRadius = UDim.new(0, 4)})
                
                local OptionsFrame = Create("Frame", {
                    Parent = DropdownButton,
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 1, 5),
                    BackgroundColor3 = Colors.Secondary,
                    Visible = false,
                    ZIndex = 10
                })
                Create("UICorner", {Parent = OptionsFrame, CornerRadius = UDim.new(0, 4)})
                
                local OptionsLayout = Create("UIListLayout", {
                    Parent = OptionsFrame,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 2)
                })
                
                local expanded = false
                DropdownButton.MouseButton1Click:Connect(function()
                    expanded = not expanded
                    OptionsFrame.Visible = expanded
                    if expanded then
                        Tween(OptionsFrame, {Size = UDim2.new(1, 0, 0, #Options * 22 + 4)})
                    else
                        Tween(OptionsFrame, {Size = UDim2.new(1, 0, 0, 0)})
                    end
                end)
                
                for _, option in ipairs(Options) do
                    local OptionButton = Create("TextButton", {
                        Parent = OptionsFrame,
                        Size = UDim2.new(1, 0, 0, 20),
                        BackgroundColor3 = Colors.Main,
                        Text = option,
                        TextColor3 = Colors.Text,
                        Font = Assets.Font,
                        TextSize = 14,
                        AutoButtonColor = false
                    })
                    Create("UICorner", {Parent = OptionButton, CornerRadius = UDim.new(0, 4)})
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        DropdownButton.Text = option
                        LierisUi.Flags[Flag] = option
                        expanded = false
                        Tween(OptionsFrame, {Size = UDim2.new(1, 0, 0, 0)})
                        task.wait(0.3)
                        OptionsFrame.Visible = false
                        if props.Callback then props.Callback(option) end
                    end)
                    
                    OptionButton.MouseEnter:Connect(function() Tween(OptionButton, {BackgroundColor3 = Colors.Accent1}) end)
                    OptionButton.MouseLeave:Connect(function() Tween(OptionButton, {BackgroundColor3 = Colors.Main}) end)
                end
            end

            -- [ COLOR PICKER ] --
            function Elements:CreateColorPicker(props)
                local Flag = props.Flag or props.Name
                local Default = props.Default or Color3.fromRGB(255, 255, 255)
                LierisUi.Flags[Flag] = Default
                
                local ColorFrame = Create("Frame", {
                    Parent = SectionContent,
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundTransparency = 1
                })
                
                local Label = Create("TextLabel", {
                    Parent = ColorFrame,
                    Size = UDim2.new(1, -40, 1, 0),
                    Text = props.Name or "Color Picker",
                    TextColor3 = Colors.Text,
                    Font = Assets.Font,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1
                })
                
                local ColorDisplay = Create("TextButton", {
                    Parent = ColorFrame,
                    Size = UDim2.new(0, 30, 0, 30),
                    Position = UDim2.new(1, -32, 0, 1),
                    BackgroundColor3 = Default,
                    Text = "",
                    AutoButtonColor = false
                })
                Create("UICorner", {Parent = ColorDisplay, CornerRadius = UDim.new(0, 6)})
                Create("UIStroke", {Parent = ColorDisplay, Color = Colors.Outline, Thickness = 2})
                
                local ColorPickerFrame = Create("Frame", {
                    Parent = ColorDisplay,
                    Size = UDim2.new(0, 200, 0, 200),
                    Position = UDim2.new(1, 5, 0, 0),
                    BackgroundColor3 = Colors.Secondary,
                    Visible = false,
                    ZIndex = 20
                })
                Create("UICorner", {Parent = ColorPickerFrame, CornerRadius = UDim.new(0, 6)})
                
                -- RGB Sliders
                local RSlider, GSlider, BSlider
                local function CreateColorSlider(name, yPos, defaultVal)
                    local SliderLabel = Create("TextLabel", {
                        Parent = ColorPickerFrame,
                        Size = UDim2.new(0, 20, 0, 20),
                        Position = UDim2.new(0, 10, 0, yPos),
                        Text = name,
                        TextColor3 = Colors.Text,
                        Font = Assets.FontBold,
                        TextSize = 14,
                        BackgroundTransparency = 1
                    })
                    
                    local SliderBar = Create("Frame", {
                        Parent = ColorPickerFrame,
                        Size = UDim2.new(0, 150, 0, 6),
                        Position = UDim2.new(0, 35, 0, yPos + 7),
                        BackgroundColor3 = Colors.Main
                    })
                    Create("UICorner", {Parent = SliderBar, CornerRadius = UDim.new(1, 0)})
                    
                    local Fill = Create("Frame", {
                        Parent = SliderBar,
                        Size = UDim2.new(defaultVal / 255, 0, 1, 0),
                        BackgroundColor3 = name == "R" and Color3.fromRGB(255, 0, 0) or (name == "G" and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 0, 255))
                    })
                    Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(1, 0)})
                    
                    local isDragging = false
                    local currentValue = defaultVal
                    
                    local function Update(input)
                        local SizeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                        currentValue = math.floor(SizeX * 255)
                        Tween(Fill, {Size = UDim2.new(SizeX, 0, 1, 0)}, 0.05)
                        
                        local r = RSlider and RSlider() or Default.R * 255
                        local g = GSlider and GSlider() or Default.G * 255
                        local b = BSlider and BSlider() or Default.B * 255
                        local newColor = Color3.fromRGB(r, g, b)
                        
                        ColorDisplay.BackgroundColor3 = newColor
                        LierisUi.Flags[Flag] = newColor
                        if props.Callback then props.Callback(newColor) end
                    end
                    
                    SliderBar.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            isDragging = true
                            Update(input)
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
                    
                    return function() return currentValue end
                end
                
                RSlider = CreateColorSlider("R", 10, Default.R * 255)
                GSlider = CreateColorSlider("G", 40, Default.G * 255)
                BSlider = CreateColorSlider("B", 70, Default.B * 255)
                
                local pickerOpen = false
                ColorDisplay.MouseButton1Click:Connect(function()
                    pickerOpen = not pickerOpen
                    ColorPickerFrame.Visible = pickerOpen
                end)
            end

            -- [ KEYBIND ] --
            function Elements:CreateKeybind(props)
                local Flag = props.Flag or props.Name
                local Default = props.Default or Enum.KeyCode.E
                LierisUi.Flags[Flag] = Default
                
                local KeybindFrame = Create("Frame", {
                    Parent = SectionContent,
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundTransparency = 1
                })
                
                local Label = Create("TextLabel", {
                    Parent = KeybindFrame,
                    Size = UDim2.new(1, -80, 1, 0),
                    Text = props.Name or "Keybind",
                    TextColor3 = Colors.Text,
                    Font = Assets.Font,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1
                })
                
                local KeyButton = Create("TextButton", {
                    Parent = KeybindFrame,
                    Size = UDim2.new(0, 70, 0, 25),
                    Position = UDim2.new(1, -70, 0.5, -12),
                    BackgroundColor3 = Colors.Main,
                    Text = Default.Name,
                    TextColor3 = Colors.Text,
                    Font = Assets.Font,
                    TextSize = 14,
                    AutoButtonColor = false
                })
                Create("UICorner", {Parent = KeyButton, CornerRadius = UDim.new(0, 4)})
                
                local listening = false
                KeyButton.MouseButton1Click:Connect(function()
                    if listening then return end
                    listening = true
                    KeyButton.Text = "..."
                    
                    local connection
                    connection = UserInputService.InputBegan:Connect(function(input, processed)
                        if processed then return end
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            local key = input.KeyCode
                            KeyButton.Text = key.Name
                            LierisUi.Flags[Flag] = key
                            listening = false
                            connection:Disconnect()
                        end
                    end)
                end)
                
                UserInputService.InputBegan:Connect(function(input, processed)
                    if processed or listening then return end
                    if input.KeyCode == LierisUi.Flags[Flag] then
                        if props.Callback then props.Callback() end
                    end
                end)
            end

            return Elements
        end
        return TabObj
    end

    -- Setup Config Manager Tab automatically
    local ConfigTab = WindowObj:CreateTab({Name = "Settings"})
    local ConfigSection = ConfigTab:CreateSection("Configuration")
    
    ConfigSection:CreateInput({
        Name = "Config Name",
        Flag = "ConfigNameInput",
        PlaceholderText = "default",
        Callback = function(text) LierisUi.CurrentConfig = text end
    })
    
    ConfigSection:CreateButton({
        Name = "Save Config",
        Callback = function() LierisUi:SaveConfig(LierisUi.CurrentConfig) end
    })
    
    ConfigSection:CreateButton({
        Name = "Load Config",
        Callback = function() LierisUi:LoadConfig(LierisUi.CurrentConfig) end
    })

    return WindowObj
end

return LierisUi
