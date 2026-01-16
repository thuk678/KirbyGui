local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Library = {
    Registry = { MainBG = {}, SecBG = {}, Accent = {}, Text = {} },
    CurrentTheme = {
        MainBG = Color3.fromHex("222831"),
        SecBG = Color3.fromHex("393E46"),
        Accent = Color3.fromHex("00ADB5"),
        Text = Color3.fromHex("EEEEEE")
    }
}

local Presets = {
    ["Modern"] = {MainBG = "222831", SecBG = "393E46", Accent = "00ADB5", Text = "EEEEEE"},
    ["Ocean Blue"] = {MainBG = "142850", SecBG = "27496D", Accent = "0C7B93", Text = "00A8CC"},
    ["Forest Green"] = {MainBG = "3C6255", SecBG = "61876E", Accent = "A6BB8D", Text = "EAE7B1"}
}

function Library:UpdateUI()
    for _, obj in pairs(self.Registry.MainBG) do obj.BackgroundColor3 = self.CurrentTheme.MainBG end
    for _, obj in pairs(self.Registry.SecBG) do obj.BackgroundColor3 = self.CurrentTheme.SecBG end
    for _, obj in pairs(self.Registry.Accent) do 
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then obj.TextColor3 = self.CurrentTheme.Accent 
        else obj.BackgroundColor3 = self.CurrentTheme.Accent end
    end
    for _, obj in pairs(self.Registry.Text) do obj.TextColor3 = self.CurrentTheme.Text end
end

local function ApplyStyle(obj, radius)
    Instance.new("UICorner", obj).CornerRadius = UDim.new(0, radius)
    local s = Instance.new("UIStroke", obj)
    s.Thickness = 2; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Color = Color3.new(0,0,0)
end

local function PrepareText(obj, size, isBold)
    obj.Font = isBold and Enum.Font.GothamBold or Enum.Font.GothamMedium
    obj.TextScaled = true; obj.RichText = true
    Instance.new("UITextSizeConstraint", obj).MaxTextSize = size
    local ts = Instance.new("UIStroke", obj)
    ts.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    ts.Thickness = 1.5; ts.Color = Color3.new(0,0,0); ts.Transparency = 0.2
end

local function MakeDraggable(handle, main)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = main.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Library:CreateWindow(cfg)
    local titleText = cfg.Name or "Library"
    local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
    ScreenGui.Name = "CustomLib"
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 580, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -290, 0.5, -200)
    table.insert(self.Registry.MainBG, MainFrame); ApplyStyle(MainFrame, 10)

    local Header = Instance.new("Frame", MainFrame)
    Header.Size = UDim2.new(1, -20, 0, 70); Header.Position = UDim2.new(0, 10, 0, 10)
    table.insert(self.Registry.SecBG, Header); ApplyStyle(Header, 8)
    MakeDraggable(Header, MainFrame)

    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(1, -100, 1, 0); Title.Position = UDim2.new(0, 20, 0, 0); Title.BackgroundTransparency = 1
    Title.Text = titleText; Title.TextXAlignment = "Left"
    PrepareText(Title, 32, true); table.insert(self.Registry.Accent, Title)

    local Exit = Instance.new("TextButton", Header)
    Exit.Size = UDim2.new(0, 40, 0, 40); Exit.Position = UDim2.new(1, -50, 0.5, -20)
    Exit.Text = "X"; PrepareText(Exit, 22, true); table.insert(self.Registry.Accent, Exit); ApplyStyle(Exit, 8)
    Exit.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 130, 1, -105); Sidebar.Position = UDim2.new(0, 10, 0, 95)
    table.insert(self.Registry.SecBG, Sidebar); ApplyStyle(Sidebar, 8)

    local Content = Instance.new("Frame", MainFrame)
    Content.Size = UDim2.new(1, -170, 1, -105); Content.Position = UDim2.new(0, 160, 0, 95)
    table.insert(self.Registry.SecBG, Content); ApplyStyle(Content, 8)

    local SidebarLayout = Instance.new("UIListLayout", Sidebar)
    SidebarLayout.Padding = UDim.new(0, 8); SidebarLayout.HorizontalAlignment = "Center"
    Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 15)

    local WindowFunctions = {}

    function WindowFunctions:CreateTab(tabName)
        local Page = Instance.new("ScrollingFrame", Content)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 0
        local PageLayout = Instance.new("UIListLayout", Page); PageLayout.Padding = UDim.new(0, 10); PageLayout.HorizontalAlignment = "Center"
        Instance.new("UIPadding", Page).PaddingTop = UDim.new(0, 15)
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Page.CanvasSize = UDim2.new(0,0,0, PageLayout.AbsoluteContentSize.Y + 30) end)

        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(0, 115, 0, 40); TabBtn.Text = tabName
        PrepareText(TabBtn, 18, true); table.insert(Library.Registry.MainBG, TabBtn); table.insert(Library.Registry.Accent, TabBtn); ApplyStyle(TabBtn, 6)
        
        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Content:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
            Page.Visible = true
        end)

        local TabFunctions = {}

        function TabFunctions:CreateButton(btnCfg)
            local b = Instance.new("TextButton", Page)
            b.Size = UDim2.new(0.9, 0, 0, 45); b.Text = btnCfg.Name or "Button"
            PrepareText(b, 20, true); table.insert(Library.Registry.MainBG, b); table.insert(Library.Registry.Text, b)
            ApplyStyle(b, 6)
            b.MouseButton1Click:Connect(function() btnCfg.Callback() end)
        end
        
        -- Add Theme Button automatically to a specific tab if needed, 
        -- but here we return functions to let the user add them.
        function TabFunctions:CreateThemeButtons()
            for name, colors in pairs(Presets) do
                self:CreateButton({
                    Name = "Theme: "..name,
                    Callback = function()
                        Library.CurrentTheme.MainBG = Color3.fromHex(colors.MainBG)
                        Library.CurrentTheme.SecBG = Color3.fromHex(colors.SecBG)
                        Library.CurrentTheme.Accent = Color3.fromHex(colors.Accent)
                        Library.CurrentTheme.Text = Color3.fromHex(colors.Text)
                        Library:UpdateUI()
                    end
                })
            end
        end

        if #Content:GetChildren() == 1 then Page.Visible = true end
        return TabFunctions
    end

    Library:UpdateUI()
    return WindowFunctions
end

return Library
