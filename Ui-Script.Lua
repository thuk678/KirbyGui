-- Custom UI Library - Similar to Rayfield UI
-- Window Size: 350x350 with exit button
-- Components: Toggle Buttons, Buttons, Tabs, and more

local CustomUI = {}
CustomUI.__index = CustomUI

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Theme Configuration
local Theme = {
    Background = Color3.fromRGB(25, 25, 35),
    Primary = Color3.fromRGB(100, 150, 255),
    Secondary = Color3.fromRGB(80, 80, 90),
    Text = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(255, 100, 100),
    Success = Color3.fromRGB(100, 255, 100),
    Warning = Color3.fromRGB(255, 200, 100),
    Error = Color3.fromRGB(255, 100, 100)
}

-- Utility Functions
local function Create(instanceType, properties)
    local instance = Instance.new(instanceType)
    for property, value in pairs(properties or {}) do
        instance[property] = value
    end
    return instance
end

local function Round(number, decimalPlaces)
    return math.floor(number * (10 ^ decimalPlaces) + 0.5) / (10 ^ decimalPlaces)
end

-- Main UI Library
function CustomUI.new(title)
    local self = setmetatable({}, CustomUI)
    
    -- Create ScreenGui
    self.ScreenGui = Create("ScreenGui", {
        Name = "CustomUI_" .. tick(),
        Parent = game:GetService("CoreGui"),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    -- Create Main Frame (350x350)
    self.MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = self.ScreenGui,
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -175, 0.5, -175),
        Size = UDim2.new(0, 350, 0, 350),
        Visible = false
    })
    
    -- Add corner rounding
    Create("UICorner", {
        Parent = self.MainFrame,
        CornerRadius = UDim.new(0, 8)
    })
    
    -- Add shadow
    Create("ImageLabel", {
        Name = "Shadow",
        Parent = self.MainFrame,
        BackgroundTransparency = 1,
        Image = "rbxassetid://6031629981",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        Position = UDim2.new(0, -5, 0, -5),
        ScaleType = Enum.ScaleType.Slice,
        Size = UDim2.new(1, 10, 1, 10),
        SliceCenter = Rect.new(10, 10, 118, 118),
        ZIndex = -1
    })
    
    -- Create Title Bar
    self.TitleBar = Create("Frame", {
        Name = "TitleBar",
        Parent = self.MainFrame,
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 30)
    })
    
    Create("UICorner", {
        Parent = self.TitleBar,
        CornerRadius = UDim.new(0, 8)
    })
    
    -- Title Label
    self.TitleLabel = Create("TextLabel", {
        Name = "TitleLabel",
        Parent = self.TitleBar,
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = title or "Custom UI",
        TextColor3 = Theme.Text,
        TextSize = 14,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -40, 1, 0)
    })
    
    -- Exit Button
    self.ExitButton = Create("TextButton", {
        Name = "ExitButton",
        Parent = self.TitleBar,
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Font = Enum.Font.Gotham,
        Text = "×",
        TextColor3 = Theme.Text,
        TextSize = 16,
        Position = UDim2.new(1, -30, 0, 5),
        Size = UDim2.new(0, 25, 0, 20)
    })
    
    Create("UICorner", {
        Parent = self.ExitButton,
        CornerRadius = UDim.new(0, 4)
    })
    
    -- Content Area
    self.ContentArea = Create("ScrollingFrame", {
        Name = "ContentArea",
        Parent = self.MainFrame,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 40),
        Size = UDim2.new(1, -20, 1, -50),
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    
    Create("UIPadding", {
        Parent = self.ContentArea,
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5)
    })
    
    -- Component Storage
    self.Components = {}
    self.Tabs = {}
    self.CurrentTab = nil
    self.IsDragging = false
    self.DragStart = nil
    self.StartPosition = nil
    
    -- Setup drag functionality
    self:SetupDrag()
    self:SetupExitButton()
    
    -- Show UI
    self:Show()
    
    return self
end

-- Drag functionality
function CustomUI:SetupDrag()
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.IsDragging = true
            self.DragStart = input.Position
            self.StartPosition = self.MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if self.IsDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - self.DragStart
            self.MainFrame.Position = UDim2.new(
                self.StartPosition.X.Scale,
                self.StartPosition.X.Offset + delta.X,
                self.StartPosition.Y.Scale,
                self.StartPosition.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.IsDragging = false
        end
    end)
end

-- Exit button functionality
function CustomUI:SetupExitButton()
    self.ExitButton.MouseEnter:Connect(function()
        TweenService:Create(self.ExitButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 150, 150)
        }):Play()
    end)
    
    self.ExitButton.MouseLeave:Connect(function()
        TweenService:Create(self.ExitButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Theme.Accent
        }):Play()
    end)
    
    self.ExitButton.MouseButton1Click:Connect(function()
        self:Hide()
    end)
end

-- Show/Hide functions
function CustomUI:Show()
    self.MainFrame.Visible = true
    self.MainFrame:TweenPosition(
        UDim2.new(0.5, -175, 0.5, -175),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quart,
        0.3,
        true
    )
end

function CustomUI:Hide()
    self.MainFrame:TweenPosition(
        UDim2.new(0.5, -175, 1, 100),
        Enum.EasingDirection.In,
        Enum.EasingStyle.Quart,
        0.3,
        true,
        function()
            self.MainFrame.Visible = false
        end
    )
end

-- Button Component
function CustomUI:CreateButton(text, callback)
    local button = Create("TextButton", {
        Name = "Button_" .. #self.Components,
        Parent = self.ContentArea,
        BackgroundColor3 = Theme.Primary,
        BorderSizePixel = 0,
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = Theme.Text,
        TextSize = 14,
        Position = UDim2.new(0, 0, 0, #self.Components * 35),
        Size = UDim2.new(1, 0, 0, 30)
    })
    
    Create("UICorner", {
        Parent = button,
        CornerRadius = UDim.new(0, 4)
    })
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(120, 170, 255)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Theme.Primary
        }):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    table.insert(self.Components, button)
    self:UpdateCanvasSize()
    return button
end

-- Toggle Button Component
function CustomUI:CreateToggle(text, defaultState, callback)
    local toggle = Create("Frame", {
        Name = "Toggle_" .. #self.Components,
        Parent = self.ContentArea,
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, #self.Components * 35),
        Size = UDim2.new(1, 0, 0, 30)
    })
    
    Create("UICorner", {
        Parent = toggle,
        CornerRadius = UDim.new(0, 4)
    })
    
    local label = Create("TextLabel", {
        Name = "Label",
        Parent = toggle,
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = Theme.Text,
        TextSize = 14,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -50, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local toggleButton = Create("Frame", {
        Name = "ToggleButton",
        Parent = toggle,
        BackgroundColor3 = defaultState and Theme.Success or Theme.Error,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -40, 0, 5),
        Size = UDim2.new(0, 30, 0, 20)
    })
    
    Create("UICorner", {
        Parent = toggleButton,
        CornerRadius = UDim.new(0, 10)
    })
    
    local state = defaultState or false
    
    toggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {
                BackgroundColor3 = state and Theme.Success or Theme.Error
            }):Play()
            if callback then callback(state) end
        end
    end)
    
    table.insert(self.Components, toggle)
    self:UpdateCanvasSize()
    return toggle
end

-- Tab Component
function CustomUI:CreateTab(name)
    local tab = {
        Name = name,
        Content = Create("Frame", {
            Name = "Tab_" .. name,
            Parent = self.ContentArea,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false
        }),
        Components = {}
    }
    
    table.insert(self.Tabs, tab)
    
    if #self.Tabs == 1 then
        self.CurrentTab = tab
        tab.Content.Visible = true
    end
    
    self:UpdateTabButtons()
    return tab
end

function CustomUI:UpdateTabButtons()
    -- Remove existing tab buttons
    for _, child in pairs(self.ContentArea:GetChildren()) do
        if child.Name:match("TabButton_") then
            child:Destroy()
        end
    end
    
    -- Create tab buttons
    local xOffset = 0
    for i, tab in ipairs(self.Tabs) do
        local tabButton = Create("TextButton", {
            Name = "TabButton_" .. tab.Name,
            Parent = self.ContentArea,
            BackgroundColor3 = self.CurrentTab == tab and Theme.Primary or Theme.Secondary,
            BorderSizePixel = 0,
            Font = Enum.Font.Gotham,
            Text = tab.Name,
            TextColor3 = Theme.Text,
            TextSize = 12,
            Position = UDim2.new(0, xOffset, 0, 0),
            Size = UDim2.new(0, 80, 0, 25)
        })
        
        Create("UICorner", {
            Parent = tabButton,
            CornerRadius = UDim.new(0, 4)
        })
        
        tabButton.MouseButton1Click:Connect(function()
            self:SwitchToTab(tab)
        end)
        
        xOffset = xOffset + 85
    end
    
    -- Reposition tab content
    local yOffset = 30
    for _, tab in ipairs(self.Tabs) do
        tab.Content.Position = UDim2.new(0, 0, 0, yOffset)
        yOffset = yOffset + 200
    end
end

function CustomUI:SwitchToTab(tab)
    if self.CurrentTab then
        self.CurrentTab.Content.Visible = false
    end
    
    self.CurrentTab = tab
    tab.Content.Visible = true
    self:UpdateTabButtons()
end

-- Label Component
function CustomUI:CreateLabel(text)
    local label = Create("TextLabel", {
        Name = "Label_" .. #self.Components,
        Parent = self.ContentArea,
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0,
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = Theme.Text,
        TextSize = 14,
        Position = UDim2.new(0, 0, 0, #self.Components * 35),
        Size = UDim2.new(1, 0, 0, 25),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    Create("UICorner", {
        Parent = label,
        CornerRadius = UDim.new(0, 4)
    })
    
    Create("UIPadding", {
        Parent = label,
        PaddingLeft = UDim.new(0, 10)
    })
    
    table.insert(self.Components, label)
    self:UpdateCanvasSize()
    return label
end

-- Slider Component
function CustomUI:CreateSlider(text, minValue, maxValue, defaultValue, callback)
    local slider = Create("Frame", {
        Name = "Slider_" .. #self.Components,
        Parent = self.ContentArea,
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, #self.Components * 35),
        Size = UDim2.new(1, 0, 0, 50)
    })
    
    Create("UICorner", {
        Parent = slider,
        CornerRadius = UDim.new(0, 4)
    })
    
    local label = Create("TextLabel", {
        Name = "Label",
        Parent = slider,
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = text .. ": " .. Round(defaultValue, 1),
        TextColor3 = Theme.Text,
        TextSize = 14,
        Position = UDim2.new(0, 10, 0, 5),
        Size = UDim2.new(1, -20, 0, 20),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local sliderBar = Create("Frame", {
        Name = "SliderBar",
        Parent = slider,
        BackgroundColor3 = Theme.Primary,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 30),
        Size = UDim2.new(1, -20, 0, 4)
    })
    
    Create("UICorner", {
        Parent = sliderBar,
        CornerRadius = UDim.new(0, 2)
    })
    
    local sliderButton = Create("Frame", {
        Name = "SliderButton",
        Parent = sliderBar,
        BackgroundColor3 = Theme.Text,
        BorderSizePixel = 0,
        Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -6, 0, -4),
        Size = UDim2.new(0, 12, 0, 12)
    })
    
    Create("UICorner", {
        Parent = sliderButton,
        CornerRadius = UDim.new(0, 6)
    })
    
    local isDragging = false
    local value = defaultValue
    
    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = math.clamp((mouse.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
            value = minValue + (maxValue - minValue) * relativeX
            
            sliderButton.Position = UDim2.new(relativeX, -6, 0, -4)
            label.Text = text .. ": " .. Round(value, 1)
            
            if callback then callback(value) end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    table.insert(self.Components, slider)
    self:UpdateCanvasSize()
    return slider
end

-- TextBox Component
function CustomUI:CreateTextBox(text, placeholderText, callback)
    local textBox = Create("Frame", {
        Name = "TextBox_" .. #self.Components,
        Parent = self.ContentArea,
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, #self.Components * 35),
        Size = UDim2.new(1, 0, 0, 35)
    })
    
    Create("UICorner", {
        Parent = textBox,
        CornerRadius = UDim.new(0, 4)
    })
    
    local label = Create("TextLabel", {
        Name = "Label",
        Parent = textBox,
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = Theme.Text,
        TextSize = 12,
        Position = UDim2.new(0, 10, 0, 2),
        Size = UDim2.new(1, -20, 0, 15),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local inputBox = Create("TextBox", {
        Name = "InputBox",
        Parent = textBox,
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Font = Enum.Font.Gotham,
        Text = "",
        PlaceholderText = placeholderText,
        TextColor3 = Theme.Text,
        PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
        TextSize = 14,
        Position = UDim2.new(0, 10, 0, 18),
        Size = UDim2.new(1, -20, 0, 15)
    })
    
    Create("UICorner", {
        Parent = inputBox,
        CornerRadius = UDim.new(0, 2)
    })
    
    inputBox.FocusLost:Connect(function(enterPressed)
        if callback then callback(inputBox.Text, enterPressed) end
    end)
    
    table.insert(self.Components, textBox)
    self:UpdateCanvasSize()
    return textBox
end

-- Update canvas size
function CustomUI:UpdateCanvasSize()
    local totalHeight = 0
    for _, component in pairs(self.Components) do
        if component:IsDescendantOf(self.ContentArea) then
            totalHeight = totalHeight + component.Size.Y.Offset + 5
        end
    end
    
    self.ContentArea.CanvasSize = UDim2.new(0, 0, 0, math.max(totalHeight, self.ContentArea.AbsoluteSize.Y))
end

-- Example Usage
local function CreateExampleUI()
    local ui = CustomUI.new("Example UI Library")
    
    -- Create tabs
    local mainTab = ui:CreateTab("Main")
    local settingsTab = ui:CreateTab("Settings")
    local aboutTab = ui:CreateTab("About")
    
    -- Switch to main tab
    ui:SwitchToTab(mainTab)
    
    -- Add components to main tab
    ui:CreateLabel("Welcome to Custom UI!")
    ui:CreateButton("Click Me!", function()
        print("Button clicked!")
    end)
    
    ui:CreateToggle("Enable Feature", false, function(state)
        print("Toggle state:", state)
    end)
    
    ui:CreateSlider("Volume", 0, 100, 50, function(value)
        print("Volume:", value)
    end)
    
    ui:CreateTextBox("Enter Name", "Type here...", function(text, enterPressed)
        print("Input:", text, "Enter pressed:", enterPressed)
    end)
    
    return ui
end

-- Auto-create example if run directly
if game:GetService("RunService"):IsStudio() then
    CreateExampleUI()
end

return CustomUI
