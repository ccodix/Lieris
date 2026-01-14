-- Lieris UI Library
-- Main module for Roblox exploit UI with sections, animations, and config support.
-- Uses only core Roblox services; file I/O is optional and depends on exploit APIs.

local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Library = {}
Library.__index = Library

local defaults = {
    name = "Lieris UI",
    size = Vector2.new(640, 460),
    theme = {
        background = Color3.fromRGB(10, 10, 14),
        surface = Color3.fromRGB(16, 16, 24),
        accent = Color3.fromRGB(80, 120, 255),
        accentAlt = Color3.fromRGB(142, 92, 255),
        text = Color3.fromRGB(230, 235, 255),
        subtleText = Color3.fromRGB(160, 168, 190),
        stroke = Color3.fromRGB(40, 44, 60),
        glow = Color3.fromRGB(90, 110, 255),
    },
    assets = {
        backgroundImage = "rbxassetid://120912477451723",
        logoImage = "rbxassetid://93564507432615",
        closeImage = "rbxassetid://75618206104636",
        minimizeImage = "rbxassetid://95966901348174",
    },
    cornerRadius = 10,
}

local function deepCopy(tbl)
    local copy = {}
    for k, v in pairs(tbl) do
        copy[k] = type(v) == "table" and deepCopy(v) or v
    end
    return copy
end

local function deepMerge(base, override)
    local merged = deepCopy(base)
    if type(override) ~= "table" then
        return merged
    end
    for k, v in pairs(override) do
        if type(v) == "table" and type(merged[k]) == "table" then
            merged[k] = deepMerge(merged[k], v)
        else
            merged[k] = v
        end
    end
    return merged
end

local function protectGui(gui)
    if syn and syn.protect_gui then
        syn.protect_gui(gui)
        return gui
    end
    if gethui then
        local ok, container = pcall(gethui)
        if ok and container then
            gui.Parent = container
            return gui
        end
    end
    return gui
end

local function getParent()
    if RunService:IsStudio() then
        return CoreGui
    end
    if gethui then
        local ok, container = pcall(gethui)
        if ok and container then
            return container
        end
    end
    return CoreGui
end

local function tween(instance, time, props, style, direction)
    local info = TweenInfo.new(time, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
    TweenService:Create(instance, info, props):Play()
end

local function addCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = instance
    return corner
end

local function addStroke(instance, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = instance
    return stroke
end

local function addShadow(parent)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 8)
    shadow.Size = UDim2.new(1, 24, 1, 24)
    shadow.ZIndex = 0
    shadow.Parent = parent
    return shadow
end

local function makeDraggable(frame, dragHandle)
    dragHandle = dragHandle or frame
    local dragging = false
    local dragStart, startPos

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function() -- stops drag on release
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function serializeColor(c3)
    return {c3.R, c3.G, c3.B}
end

local function deserializeColor(tbl)
    if type(tbl) == "table" and #tbl == 3 then
        return Color3.new(tbl[1], tbl[2], tbl[3])
    end
    return defaults.theme.accent
end

local function safeJsonEncode(value)
    local ok, result = pcall(function()
        return HttpService:JSONEncode(value)
    end)
    return ok and result or nil
end

local function safeJsonDecode(value)
    local ok, result = pcall(function()
        return HttpService:JSONDecode(value)
    end)
    return ok and result or nil
end

local File = {}
File.supported = (isfile ~= nil and writefile ~= nil and readfile ~= nil)

function File:ensureFolder(path)
    if not self.supported then
        return false
    end
    if isfolder and not isfolder(path) and makefolder then
        pcall(makefolder, path)
    end
    return true
end

function File:write(path, content)
    if not self.supported then
        return false
    end
    local ok = pcall(writefile, path, content)
    return ok
end

function File:read(path)
    if not self.supported then
        return nil
    end
    local ok, data = pcall(readfile, path)
    return ok and data or nil
end

function File:list(path)
    if not self.supported or not listfiles then
        return {}
    end
    local ok, files = pcall(listfiles, path)
    if ok and files then
        return files
    end
    return {}
end

local Component = {}
Component.__index = Component

function Component:new(kind, flag, window, setter)
    local self = setmetatable({}, Component)
    self.kind = kind
    self.flag = flag
    self.window = window
    self.setter = setter
    return self
end

function Component:Set(value)
    if self.setter then
        self.setter(value)
    end
end

local function buildSlider(window, container, theme, options)
    local min = options.min or 0
    local max = options.max or 100
    local step = options.step or 1
    local default = options.default or min
    local callback = options.callback or function() end

    local holder = Instance.new("Frame")
    holder.Name = "Slider"
    holder.Size = UDim2.new(1, 0, 0, 56)
    holder.BackgroundTransparency = 1
    holder.Parent = container

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextColor3 = theme.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = options.title or "Slider"
    label.Parent = holder

    local valueLabel = Instance.new("TextLabel")
    valueLabel.BackgroundTransparency = 1
    valueLabel.Size = UDim2.new(0, 80, 0, 20)
    valueLabel.Position = UDim2.new(1, -80, 0, 0)
    valueLabel.Font = Enum.Font.GothamSemibold
    valueLabel.TextSize = 14
    valueLabel.TextColor3 = theme.accent
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Text = tostring(default)
    valueLabel.Parent = holder

    local bar = Instance.new("Frame")
    bar.BackgroundColor3 = theme.stroke
    bar.Size = UDim2.new(1, 0, 0, 10)
    bar.Position = UDim2.new(0, 0, 0, 30)
    bar.BorderSizePixel = 0
    bar.Parent = holder
    addCorner(bar, 6)

    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = theme.accent
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BorderSizePixel = 0
    fill.Parent = bar
    addCorner(fill, 6)

    local glow = Instance.new("UIGradient")
    glow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, theme.accent),
        ColorSequenceKeypoint.new(1, theme.accentAlt),
    })
    glow.Rotation = 90
    glow.Parent = fill

    local dragging = false
    local value = default

    local function setValue(v, fromInput)
        v = math.clamp(v, min, max)
        v = math.floor(v / step + 0.5) * step
        value = v
        local alpha = (v - min) / (max - min)
        tween(fill, fromInput and 0 or 0.12, {Size = UDim2.new(alpha, 0, 1, 0)})
        valueLabel.Text = tostring(v)
        if options.flag then
            window:_setFlag(options.flag, v, true)
        end
        if not fromInput then
            callback(v)
        end
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local rel = (input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
            setValue(min + (max - min) * rel, true)
            callback(value)
        end
    end)

    bar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local rel = (input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
            setValue(min + (max - min) * rel, true)
            callback(value)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    setValue(default, false)

    local component = Component:new("slider", options.flag, window, setValue)
    component.Get = function()
        return value
    end
    return component
end

local function buildToggle(window, container, theme, options)
    local state = options.default or false
    local callback = options.callback or function() end

    local holder = Instance.new("Frame")
    holder.Name = "Toggle"
    holder.Size = UDim2.new(1, 0, 0, 36)
    holder.BackgroundTransparency = 1
    holder.Parent = container

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -52, 1, 0)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextColor3 = theme.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = options.title or "Toggle"
    label.Parent = holder

    local switch = Instance.new("Frame")
    switch.Size = UDim2.new(0, 42, 0, 22)
    switch.Position = UDim2.new(1, -42, 0.5, -11)
    switch.BackgroundColor3 = theme.stroke
    switch.BorderSizePixel = 0
    switch.Parent = holder
    addCorner(switch, 11)
    addStroke(switch, theme.stroke, 1, 0.25)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0, 2, 0.5, -9)
    knob.BackgroundColor3 = theme.text
    knob.BorderSizePixel = 0
    knob.Parent = switch
    addCorner(knob, 9)

    local function render(newState, animate)
        state = newState
        local target = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        if animate then
            tween(knob, 0.16, {Position = target})
            tween(switch, 0.16, {BackgroundColor3 = state and theme.accent or theme.stroke})
        else
            knob.Position = target
            switch.BackgroundColor3 = state and theme.accent or theme.stroke
        end
        if options.flag then
            window:_setFlag(options.flag, state, true)
        end
    end

    local function toggle()
        render(not state, true)
        callback(state)
    end

    holder.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggle()
        end
    end)

    switch.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggle()
        end
    end)

    render(state, false)

    local component = Component:new("toggle", options.flag, window, function(v)
        render(v, true)
        callback(v)
    end)
    component.Get = function()
        return state
    end
    return component
end

local function buildButton(window, container, theme, options)
    local callback = options.callback or function() end

    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, 0, 0, 34)
    button.BackgroundColor3 = theme.surface
    button.BorderSizePixel = 0
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 14
    button.TextColor3 = theme.text
    button.Text = options.title or "Button"
    button.AutoButtonColor = false
    button.Parent = container
    addCorner(button, 8)
    addStroke(button, theme.stroke, 1, 0.35)

    button.MouseEnter:Connect(function()
        tween(button, 0.15, {BackgroundColor3 = theme.stroke})
    end)
    button.MouseLeave:Connect(function()
        tween(button, 0.2, {BackgroundColor3 = theme.surface})
    end)
    button.MouseButton1Click:Connect(function()
        tween(button, 0.08, {BackgroundColor3 = theme.accent})
        task.delay(0.08, function()
            tween(button, 0.18, {BackgroundColor3 = theme.stroke})
        end)
        callback()
    end)

    local component = Component:new("button", options.flag, window, function() end)
    component.Click = callback
    return component
end

local function buildTextbox(window, container, theme, options)
    local callback = options.callback or function() end
    local default = options.default or ""

    local frame = Instance.new("Frame")
    frame.Name = "Textbox"
    frame.Size = UDim2.new(1, 0, 0, 44)
    frame.BackgroundColor3 = theme.surface
    frame.BorderSizePixel = 0
    frame.Parent = container
    addCorner(frame, 8)
    addStroke(frame, theme.stroke, 1, 0.35)

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, 18)
    label.Position = UDim2.new(0, 8, 0, 4)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextColor3 = theme.subtleText
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = options.title or "Input"
    label.Parent = frame

    local box = Instance.new("TextBox")
    box.BackgroundTransparency = 1
    box.Size = UDim2.new(1, -16, 0, 20)
    box.Position = UDim2.new(0, 8, 0, 22)
    box.Font = Enum.Font.GothamSemibold
    box.TextSize = 14
    box.TextColor3 = theme.text
    box.ClearTextOnFocus = false
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.PlaceholderColor3 = theme.subtleText
    box.PlaceholderText = options.placeholder or "Type here"
    box.Text = default
    box.Parent = frame

    box.FocusLost:Connect(function(enterPressed)
        local text = box.Text
        if options.flag then
            window:_setFlag(options.flag, text, true)
        end
        if enterPressed then
            callback(text)
        end
    end)

    local component = Component:new("textbox", options.flag, window, function(v)
        box.Text = tostring(v)
    end)
    component.Get = function()
        return box.Text
    end
    return component
end

local function buildDropdown(window, container, theme, options)
    local values = options.values or {}
    local current = options.default or (values[1] or "")
    local callback = options.callback or function() end
    local open = false

    local holder = Instance.new("Frame")
    holder.Name = "Dropdown"
    holder.Size = UDim2.new(1, 0, 0, 40)
    holder.BackgroundColor3 = theme.surface
    holder.BorderSizePixel = 0
    holder.Parent = container
    addCorner(holder, 8)
    addStroke(holder, theme.stroke, 1, 0.35)

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -30, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 14
    label.TextColor3 = theme.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = current
    label.Parent = holder

    local arrow = Instance.new("TextLabel")
    arrow.BackgroundTransparency = 1
    arrow.Size = UDim2.new(0, 24, 1, 0)
    arrow.Position = UDim2.new(1, -26, 0, 0)
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 18
    arrow.TextColor3 = theme.subtleText
    arrow.Text = "▾"
    arrow.Parent = holder

    local listFrame = Instance.new("Frame")
    listFrame.Visible = false
    listFrame.Size = UDim2.new(1, 0, 0, 0)
    listFrame.Position = UDim2.new(0, 0, 1, 6)
    listFrame.BackgroundColor3 = theme.surface
    listFrame.BorderSizePixel = 0
    listFrame.ZIndex = 5
    listFrame.Parent = holder
    addCorner(listFrame, 8)
    addStroke(listFrame, theme.stroke, 1, 0.35)

    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection = Enum.FillDirection.Vertical
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 2)
    listLayout.Parent = listFrame

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 6)
    padding.PaddingBottom = UDim.new(0, 6)
    padding.PaddingLeft = UDim.new(0, 6)
    padding.PaddingRight = UDim.new(0, 6)
    padding.Parent = listFrame

    local buttons = {}

    local function closeDropdown()
        open = false
        tween(listFrame, 0.18, {Size = UDim2.new(1, 0, 0, 0)})
        task.delay(0.18, function()
            listFrame.Visible = false
        end)
        arrow.Text = "▾"
    end

    local function openDropdown()
        open = true
        listFrame.Visible = true
        listFrame.Size = UDim2.new(1, 0, 0, 0)
        local target = math.clamp(#values * 28 + 12, 48, 180)
        tween(listFrame, 0.2, {Size = UDim2.new(1, 0, 0, target)})
        arrow.Text = "▴"
    end

    local function setValue(v, animate)
        current = v
        label.Text = v
        if options.flag then
            window:_setFlag(options.flag, v, true)
        end
        callback(v)
        if animate and open then
            closeDropdown()
        end
    end

    local function rebuild()
        for _, btn in ipairs(buttons) do
            btn:Destroy()
        end
        table.clear(buttons)
        for i, v in ipairs(values) do
            local btn = Instance.new("TextButton")
            btn.Name = "Option" .. i
            btn.Size = UDim2.new(1, -8, 0, 26)
            btn.BackgroundColor3 = theme.background
            btn.BorderSizePixel = 0
            btn.AutoButtonColor = false
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 14
            btn.TextColor3 = theme.text
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Text = tostring(v)
            btn.Parent = listFrame
            addCorner(btn, 6)
            btn.MouseEnter:Connect(function()
                tween(btn, 0.12, {BackgroundColor3 = theme.stroke})
            end)
            btn.MouseLeave:Connect(function()
                tween(btn, 0.16, {BackgroundColor3 = theme.background})
            end)
            btn.MouseButton1Click:Connect(function()
                setValue(v, true)
            end)
            buttons[#buttons + 1] = btn
        end
    end

    holder.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if open then
                closeDropdown()
            else
                openDropdown()
            end
        end
    end)

    rebuild()
    setValue(current, false)

    local component = Component:new("dropdown", options.flag, window, function(v)
        if table.find(values, v) then
            setValue(v, false)
        end
    end)
    component.Get = function()
        return current
    end
    component.SetValues = function(newValues)
        values = newValues
        rebuild()
    end
    return component
end

local function buildLabel(window, container, theme, options)
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, options.height or 20)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextColor3 = theme.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.Text = options.text or "Label"
    label.Parent = container

    local component = Component:new("label", options.flag, window, function(v)
        label.Text = tostring(v)
    end)
    component.Get = function()
        return label.Text
    end
    return component
end

local function buildColorPicker(window, container, theme, options)
    local color = options.default or theme.accent
    local callback = options.callback or function() end

    local frame = Instance.new("Frame")
    frame.Name = "ColorPicker"
    frame.Size = UDim2.new(1, 0, 0, 54)
    frame.BackgroundColor3 = theme.surface
    frame.BorderSizePixel = 0
    frame.Parent = container
    addCorner(frame, 8)
    addStroke(frame, theme.stroke, 1, 0.35)

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextColor3 = theme.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = options.title or "Color"
    label.Parent = frame

    local swatch = Instance.new("Frame")
    swatch.Size = UDim2.new(0, 40, 0, 26)
    swatch.Position = UDim2.new(1, -48, 0.5, -13)
    swatch.BackgroundColor3 = color
    swatch.BorderSizePixel = 0
    swatch.Parent = frame
    addCorner(swatch, 6)
    addStroke(swatch, theme.stroke, 1, 0.2)

    local hueBar = Instance.new("Frame")
    hueBar.Size = UDim2.new(1, -20, 0, 8)
    hueBar.Position = UDim2.new(0, 10, 1, -14)
    hueBar.BackgroundColor3 = theme.stroke
    hueBar.BorderSizePixel = 0
    hueBar.Parent = frame
    addCorner(hueBar, 5)

    local hueFill = Instance.new("Frame")
    hueFill.BackgroundColor3 = color
    hueFill.Size = UDim2.new(0, 0, 1, 0)
    hueFill.BorderSizePixel = 0
    hueFill.Parent = hueBar
    addCorner(hueFill, 5)

    local function setColor(c, animate)
        color = c
        swatch.BackgroundColor3 = c
        hueFill.BackgroundColor3 = c
        if options.flag then
            window:_setFlag(options.flag, serializeColor(c), true)
        end
        callback(c)
    end

    local dragging = false
    hueBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local rel = math.clamp((input.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
            local newColor = Color3.fromHSV(rel, 0.65, 1)
            tween(hueFill, 0.08, {Size = UDim2.new(rel, 0, 1, 0)})
            setColor(newColor, true)
        end
    end)

    setColor(color, false)

    local component = Component:new("colorpicker", options.flag, window, function(v)
        if typeof(v) == "Color3" then
            setColor(v, false)
        elseif type(v) == "table" then
            setColor(deserializeColor(v), false)
        end
    end)
    component.Get = function()
        return color
    end
    return component
end

local function buildKeybind(window, container, theme, options)
    local key = options.default or Enum.KeyCode.RightControl
    local listening = false
    local callback = options.callback or function() end

    local frame = Instance.new("Frame")
    frame.Name = "Keybind"
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = theme.surface
    frame.BorderSizePixel = 0
    frame.Parent = container
    addCorner(frame, 8)
    addStroke(frame, theme.stroke, 1, 0.35)

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -100, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextColor3 = theme.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = options.title or "Keybind"
    label.Parent = frame

    local keyLabel = Instance.new("TextButton")
    keyLabel.BackgroundTransparency = 1
    keyLabel.Size = UDim2.new(0, 90, 1, 0)
    keyLabel.Position = UDim2.new(1, -94, 0, 0)
    keyLabel.Font = Enum.Font.GothamSemibold
    keyLabel.TextSize = 14
    keyLabel.TextColor3 = theme.accent
    keyLabel.TextXAlignment = Enum.TextXAlignment.Right
    keyLabel.Text = key.Name
    keyLabel.AutoButtonColor = false
    keyLabel.Parent = frame

    local function setKey(newKey)
        key = newKey
        keyLabel.Text = key.Name
        if options.flag then
            window:_setFlag(options.flag, key.Name, true)
        end
        callback(key)
    end

    keyLabel.MouseButton1Click:Connect(function()
        if listening then
            return
        end
        listening = true
        keyLabel.Text = "Press a key"
        local conn
        conn = UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then
                return
            end
            if input.KeyCode ~= Enum.KeyCode.Unknown then
                setKey(input.KeyCode)
            end
            listening = false
            keyLabel.Text = key.Name
            conn:Disconnect()
        end)
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then
            return
        end
        if input.KeyCode == key then
            callback(key)
        end
    end)

    setKey(key)

    local component = Component:new("keybind", options.flag, window, function(v)
        if typeof(v) == "EnumItem" then
            setKey(v)
        elseif type(v) == "string" and Enum.KeyCode[v] then
            setKey(Enum.KeyCode[v])
        end
    end)
    component.Get = function()
        return key
    end
    return component
end

local function buildSection(window, title)
    local section = {}
    section.title = title

    local tabButton = Instance.new("TextButton")
    tabButton.Name = "TabButton"
    tabButton.Size = UDim2.new(1, 0, 0, 36)
    tabButton.BackgroundColor3 = window.theme.surface
    tabButton.BorderSizePixel = 0
    tabButton.Font = Enum.Font.GothamSemibold
    tabButton.TextSize = 14
    tabButton.TextColor3 = window.theme.subtleText
    tabButton.TextXAlignment = Enum.TextXAlignment.Left
    tabButton.Text = title
    tabButton.AutoButtonColor = false
    tabButton.Parent = window.tabList
    addCorner(tabButton, 8)
    addStroke(tabButton, window.theme.stroke, 1, 0.35)

    local container = Instance.new("ScrollingFrame")
    container.Name = "SectionPage"
    container.Size = UDim2.new(1, 0, 1, 0)
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
    container.ScrollBarThickness = 4
    container.ScrollBarImageColor3 = window.theme.stroke
    container.BackgroundTransparency = 1
    container.Visible = false
    container.Parent = window.pageContainer

    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection = Enum.FillDirection.Vertical
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 8)
    listLayout.Parent = container

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.PaddingBottom = UDim.new(0, 10)
    pad.Parent = container

    local function updateCanvas()
        container.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
    end
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

    local function select()
        for _, btn in ipairs(window.tabs) do
            btn.Selected.Value = false
        end
        tabButton.Selected.Value = true
        for _, page in ipairs(window.pages) do
            page.Visible = false
        end
        container.Visible = true
        tween(tabButton, 0.18, {BackgroundColor3 = window.theme.stroke, TextColor3 = window.theme.text})
    end

    tabButton.Selected = Instance.new("BoolValue")
    tabButton.Selected.Value = false

    tabButton.MouseEnter:Connect(function()
        if not tabButton.Selected.Value then
            tween(tabButton, 0.12, {BackgroundColor3 = window.theme.background})
        end
    end)
    tabButton.MouseLeave:Connect(function()
        if not tabButton.Selected.Value then
            tween(tabButton, 0.16, {BackgroundColor3 = window.theme.surface})
        end
    end)
    tabButton.MouseButton1Click:Connect(select)

    window.tabs[#window.tabs + 1] = tabButton
    window.pages[#window.pages + 1] = container

    local api = {}
    api.Label = function(opts)
        return buildLabel(window, container, window.theme, opts or {})
    end
    api.Button = function(opts)
        opts = opts or {}
        return buildButton(window, container, window.theme, opts)
    end
    api.Toggle = function(opts)
        opts = opts or {}
        return buildToggle(window, container, window.theme, opts)
    end
    api.Slider = function(opts)
        opts = opts or {}
        return buildSlider(window, container, window.theme, opts)
    end
    api.Textbox = function(opts)
        opts = opts or {}
        return buildTextbox(window, container, window.theme, opts)
    end
    api.Dropdown = function(opts)
        opts = opts or {}
        return buildDropdown(window, container, window.theme, opts)
    end
    api.ColorPicker = function(opts)
        opts = opts or {}
        return buildColorPicker(window, container, window.theme, opts)
    end
    api.Keybind = function(opts)
        opts = opts or {}
        return buildKeybind(window, container, window.theme, opts)
    end

    api.Divider = function()
        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, 0, 0, 1)
        line.BackgroundColor3 = window.theme.stroke
        line.BorderSizePixel = 0
        line.Parent = container
        return line
    end

    api.Blank = function(height)
        local spacer = Instance.new("Frame")
        spacer.Size = UDim2.new(1, 0, 0, height or 8)
        spacer.BackgroundTransparency = 1
        spacer.Parent = container
        return spacer
    end

    api.Container = container
    api.Select = select

    return api, select
end

function Library:_setFlag(flag, value, silent)
    if not flag then
        return
    end
    self.flags[flag] = value
    if not silent and self.config.autoSave then
        self:Save(self.config.autoSaveName or "autosave")
    end
end

function Library:Save(name)
    name = name or "config"
    if not File.supported then
        return false
    end
    File:ensureFolder(self.config.folder)
    local path = string.format("%s/%s.json", self.config.folder, name)
    local payload = {
        flags = self.flags,
        theme = self.theme,
    }
    local json = safeJsonEncode(payload)
    if not json then
        return false
    end
    return File:write(path, json)
end

function Library:Load(name)
    name = name or "config"
    if not File.supported then
        return false
    end
    local path = string.format("%s/%s.json", self.config.folder, name)
    local data = File:read(path)
    if not data then
        return false
    end
    local decoded = safeJsonDecode(data)
    if not decoded or not decoded.flags then
        return false
    end
    for flag, value in pairs(decoded.flags) do
        if self.registry[flag] then
            local setter = self.registry[flag]
            setter(value)
            self.flags[flag] = value
        end
    end
    if decoded.theme then
        self.theme = deepMerge(self.theme, decoded.theme)
    end
    return true
end

function Library:ListConfigs()
    if not File.supported then
        return {}
    end
    File:ensureFolder(self.config.folder)
    local files = File:list(self.config.folder)
    local result = {}
    for _, path in ipairs(files) do
        local name = string.match(path, "([^/\\]+)%.json$")
        if name then
            table.insert(result, name)
        end
    end
    return result
end

function Library:SetAutoSave(enabled, name)
    self.config.autoSave = enabled
    self.config.autoSaveName = name
end

function Library.new(options)
    options = options or {}
    local self = setmetatable({}, Library)
    self.flags = {}
    self.registry = {}
    self.tabs = {}
    self.pages = {}
    self.config = {
        folder = options.configFolder or "LierisUIConfigs",
        autoSave = options.autoSave or false,
        autoSaveName = options.autoSaveName or "autosave",
    }

    self.theme = deepMerge(defaults.theme, options.theme or {})
    self.assets = deepMerge(defaults.assets, options.assets or {})
    local size = options.size or defaults.size

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = options.name or defaults.name
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = protectGui(getParent())
    self.gui = screenGui

    local root = Instance.new("Frame")
    root.Name = "LierisRoot"
    root.Size = UDim2.new(0, size.X, 0, size.Y)
    root.Position = UDim2.new(0.5, -size.X / 2, 0.5, -size.Y / 2)
    root.BackgroundColor3 = self.theme.background
    root.BorderSizePixel = 0
    root.Parent = screenGui
    addCorner(root, defaults.cornerRadius)
    addShadow(root)

    local bg = Instance.new("ImageLabel")
    bg.Name = "Background"
    bg.BackgroundTransparency = 1
    bg.Image = self.assets.backgroundImage
    bg.ImageTransparency = 0.82
    bg.ScaleType = Enum.ScaleType.Crop
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.ZIndex = 0
    bg.Parent = root

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 14)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 28)),
    })
    gradient.Rotation = 45
    gradient.Parent = root

    local topbar = Instance.new("Frame")
    topbar.Name = "Topbar"
    topbar.Size = UDim2.new(1, 0, 0, 42)
    topbar.BackgroundColor3 = self.theme.surface
    topbar.BorderSizePixel = 0
    topbar.Parent = root
    addCorner(topbar, defaults.cornerRadius)
    addStroke(topbar, self.theme.stroke, 1, 0.25)

    local logo = Instance.new("ImageLabel")
    logo.Name = "Logo"
    logo.Size = UDim2.new(0, 30, 0, 30)
    logo.Position = UDim2.new(0, 8, 0.5, -15)
    logo.BackgroundTransparency = 1
    logo.Image = self.assets.logoImage
    logo.Parent = topbar

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 46, 0, 0)
    title.Size = UDim2.new(1, -160, 1, 0)
    title.Font = Enum.Font.GothamSemibold
    title.TextSize = 16
    title.TextColor3 = self.theme.text
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = options.title or defaults.name
    title.Parent = topbar

    local closeBtn = Instance.new("ImageButton")
    closeBtn.Name = "Close"
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(1, -34, 0.5, -13)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Image = self.assets.closeImage
    closeBtn.Parent = topbar

    local minimizeBtn = Instance.new("ImageButton")
    minimizeBtn.Name = "Minimize"
    minimizeBtn.Size = UDim2.new(0, 26, 0, 26)
    minimizeBtn.Position = UDim2.new(1, -68, 0.5, -13)
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.Image = self.assets.minimizeImage
    minimizeBtn.Parent = topbar

    local body = Instance.new("Frame")
    body.Name = "Body"
    body.Size = UDim2.new(1, -16, 1, -56)
    body.Position = UDim2.new(0, 8, 0, 48)
    body.BackgroundColor3 = self.theme.surface
    body.BorderSizePixel = 0
    body.Parent = root
    addCorner(body, defaults.cornerRadius)
    addStroke(body, self.theme.stroke, 1, 0.25)

    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 170, 1, 0)
    sidebar.BackgroundTransparency = 1
    sidebar.Parent = body

    local tabList = Instance.new("Frame")
    tabList.Name = "TabList"
    tabList.Size = UDim2.new(1, -12, 1, -12)
    tabList.Position = UDim2.new(0, 6, 0, 6)
    tabList.BackgroundTransparency = 1
    tabList.Parent = sidebar

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Vertical
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 8)
    tabLayout.Parent = tabList

    local tabPad = Instance.new("UIPadding")
    tabPad.PaddingTop = UDim.new(0, 6)
    tabPad.PaddingBottom = UDim.new(0, 6)
    tabPad.PaddingLeft = UDim.new(0, 2)
    tabPad.PaddingRight = UDim.new(0, 2)
    tabPad.Parent = tabList

    local pageContainer = Instance.new("Frame")
    pageContainer.Name = "Pages"
    pageContainer.Size = UDim2.new(1, -184, 1, 0)
    pageContainer.Position = UDim2.new(0, 178, 0, 0)
    pageContainer.BackgroundTransparency = 1
    pageContainer.ClipsDescendants = true
    pageContainer.Parent = body

    self.tabList = tabList
    self.pageContainer = pageContainer

    local function closeAllTabs()
        for _, btn in ipairs(self.tabs) do
            btn.Selected.Value = false
            tween(btn, 0.16, {BackgroundColor3 = self.theme.surface, TextColor3 = self.theme.subtleText})
        end
        for _, page in ipairs(self.pages) do
            page.Visible = false
        end
    end

    self.AddSection = function(_, sectionTitle)
        local sectionApi, select = buildSection(self, sectionTitle or "Section")
        if #self.tabs == 1 then
            select()
        end
        return sectionApi
    end

    closeBtn.MouseButton1Click:Connect(function()
        tween(root, 0.18, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1})
        task.delay(0.18, function()
            screenGui:Destroy()
        end)
    end)

    local minimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            tween(body, 0.2, {Size = UDim2.new(1, -16, 0, 0)})
            tween(root, 0.2, {Size = UDim2.new(0, size.X, 0, 56)})
        else
            tween(body, 0.2, {Size = UDim2.new(1, -16, 1, -56)})
            tween(root, 0.2, {Size = UDim2.new(0, size.X, 0, size.Y)})
        end
    end)

    makeDraggable(root, topbar)

    -- register flag setter helper
    self:RegisterFlag = function(_, flag, setter)
        if not flag then
            return
        end
        self.registry[flag] = setter
    end

    -- create Config Manager section by default
    local cfgSection = self:AddSection("Config")
    cfgSection.Label({text = "Config Manager"})
    cfgSection.Label({text = "Storage: " .. self.config.folder})
    cfgSection.Textbox({title = "Config Name", placeholder = "myConfig", flag = "cfg_name", default = "default"})
    cfgSection.Button({title = "Save", callback = function()
        local name = self.flags["cfg_name"] or "default"
        self:Save(name)
    end})
    cfgSection.Button({title = "Load", callback = function()
        local name = self.flags["cfg_name"] or "default"
        self:Load(name)
    end})

    cfgSection.Toggle({title = "Auto Save", flag = "cfg_autosave", callback = function(state)
        self:SetAutoSave(state, self.flags["cfg_name"] or "autosave")
    end})

    return self
end

return Library
