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
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then obj.TextColor3 = self.CurrentTheme.Accent 
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

function Library:CreateWindow(cfg)
    local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
    ScreenGui.Name = "KirbyLib"; ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 580, 0, 420); MainFrame.Position = UDim2.new(0.5, -290, 0.5, -210)
    table.insert(self.Registry.MainBG, MainFrame); ApplyStyle(MainFrame, 10)

    local Header = Instance.new("Frame", MainFrame)
    Header.Size = UDim2.new(1, -20, 0, 70); Header.Position = UDim2.new(0, 10, 0, 10)
    table.insert(self.Registry.SecBG, Header); ApplyStyle(Header, 8)

    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(1, -100, 1, 0); Title.Position = UDim2.new(0, 20, 0, 0); Title.BackgroundTransparency = 1
    Title.Text = cfg.Name or "Library"; Title.TextXAlignment = "Left"
    PrepareText(Title, 32, true); table.insert(self.Registry.Accent, Title)

    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 130, 1, -105); Sidebar.Position = UDim2.new(0, 10, 0, 95)
    table.insert(self.Registry.SecBG, Sidebar); ApplyStyle(Sidebar, 8)

    local Content = Instance.new("Frame", MainFrame)
    Content.Size = UDim2.new(1, -170, 1, -105); Content.Position = UDim2.new(0, 160, 0, 95)
    table.insert(self.Registry.SecBG, Content); ApplyStyle(Content, 8)

    local WindowActions = {}

    function WindowActions:CreateTab(tName)
        local Page = Instance.new("ScrollingFrame", Content)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 0
        local PageLayout = Instance.new("UIListLayout", Page); PageLayout.Padding = UDim.new(0, 10); PageLayout.HorizontalAlignment = "Center"
        Instance.new("UIPadding", Page).PaddingTop = UDim.new(0, 15)
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Page.CanvasSize = UDim2.new(0,0,0, PageLayout.AbsoluteContentSize.Y + 30) end)

        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(0, 115, 0, 40); TabBtn.Text = tName
        PrepareText(TabBtn, 18, true); table.insert(Library.Registry.MainBG, TabBtn); table.insert(Library.Registry.Accent, TabBtn); ApplyStyle(TabBtn, 6)
        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Content:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
            Page.Visible = true
        end)

        local Elements = {}

        function Elements:CreateButton(bCfg)
            local b = Instance.new("TextButton", Page)
            b.Size = UDim2.new(0.9, 0, 0, 40); b.Text = bCfg.Name
            PrepareText(b, 18, true); table.insert(Library.Registry.MainBG, b); table.insert(Library.Registry.Text, b); ApplyStyle(b, 6)
            b.MouseButton1Click:Connect(bCfg.Callback)
        end

        function Elements:CreateToggle(tCfg)
            local toggled = tCfg.CurrentValue or false
            local tFrame = Instance.new("TextButton", Page)
            tFrame.Size = UDim2.new(0.9, 0, 0, 40); tFrame.Text = tCfg.Name; tFrame.TextXAlignment = "Left"
            Instance.new("UIPadding", tFrame).PaddingLeft = UDim.new(0, 15)
            PrepareText(tFrame, 18, true); table.insert(Library.Registry.MainBG, tFrame); table.insert(Library.Registry.Text, tFrame); ApplyStyle(tFrame, 6)

            local switch = Instance.new("Frame", tFrame)
            switch.Size = UDim2.new(0, 50, 0, 24); switch.Position = UDim2.new(1, -65, 0.5, -12)
            table.insert(Library.Registry.SecBG, switch); ApplyStyle(switch, 12)

            local dot = Instance.new("Frame", switch)
            dot.Size = UDim2.new(0, 18, 0, 18); dot.Position = toggled and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9)
            table.insert(Library.Registry.Accent, dot); ApplyStyle(dot, 10)

            tFrame.MouseButton1Click:Connect(function()
                toggled = not toggled
                dot:TweenPosition(toggled and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9), "Out", "Quad", 0.2, true)
                tCfg.Callback(toggled)
            end)
        end

        function Elements:CreateSlider(sCfg)
            local sFrame = Instance.new("Frame", Page)
            sFrame.Size = UDim2.new(0.9, 0, 0, 55); table.insert(Library.Registry.MainBG, sFrame); ApplyStyle(sFrame, 6)
            local title = Instance.new("TextLabel", sFrame)
            title.Size = UDim2.new(1, -20, 0, 25); title.Position = UDim2.new(0, 10, 0, 5); title.BackgroundTransparency = 1
            title.Text = sCfg.Name; title.TextXAlignment = "Left"; PrepareText(title, 16, true); table.insert(Library.Registry.Text, title)
            local valLabel = Instance.new("TextLabel", sFrame)
            valLabel.Size = UDim2.new(0, 50, 0, 25); valLabel.Position = UDim2.new(1, -60, 0, 5); valLabel.BackgroundTransparency = 1
            valLabel.Text = tostring(sCfg.CurrentValue); PrepareText(valLabel, 16, true); table.insert(Library.Registry.Accent, valLabel)
            local barBg = Instance.new("Frame", sFrame)
            barBg.Size = UDim2.new(1, -20, 0, 8); barBg.Position = UDim2.new(0, 10, 1, -15)
            table.insert(Library.Registry.SecBG, barBg); ApplyStyle(barBg, 4)
            local fill = Instance.new("Frame", barBg)
            fill.Size = UDim2.new((sCfg.CurrentValue - sCfg.Range[1]) / (sCfg.Range[2] - sCfg.Range[1]), 0, 1, 0)
            table.insert(Library.Registry.Accent, fill); ApplyStyle(fill, 4)
            local function update(input)
                local pos = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
                local val = math.floor(sCfg.Range[1] + (sCfg.Range[2] - sCfg.Range[1]) * pos)
                fill.Size = UDim2.new(pos, 0, 1, 0); valLabel.Text = tostring(val); sCfg.Callback(val)
            end
            barBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local move; move = UserInputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end
                    end)
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() end
                    end)
                    update(input)
                end
            end)
        end

        function Elements:CreateDropdown(dCfg)
            local expanded = false
            local dFrame = Instance.new("TextButton", Page)
            dFrame.Size = UDim2.new(0.9, 0, 0, 40); dFrame.Text = dCfg.Name..": "..dCfg.CurrentValue
            table.insert(Library.Registry.MainBG, dFrame); table.insert(Library.Registry.Text, dFrame); ApplyStyle(dFrame, 6); PrepareText(dFrame, 16, true)
            local container = Instance.new("Frame", Page)
            container.Size = UDim2.new(0.9, 0, 0, 0); container.Visible = false; table.insert(Library.Registry.SecBG, container); ApplyStyle(container, 6)
            local list = Instance.new("UIListLayout", container); list.Padding = UDim.new(0, 5)
            for _, opt in pairs(dCfg.Options) do
                local oBtn = Instance.new("TextButton", container)
                oBtn.Size = UDim2.new(1, 0, 0, 30); oBtn.Text = opt; oBtn.BackgroundTransparency = 1; PrepareText(oBtn, 14, false); table.insert(Library.Registry.Text, oBtn)
                oBtn.MouseButton1Click:Connect(function()
                    dFrame.Text = dCfg.Name..": "..opt; expanded = false; container.Visible = false; container.Size = UDim2.new(0.9, 0, 0, 0); dCfg.Callback(opt)
                end)
            end
            dFrame.MouseButton1Click:Connect(function()
                expanded = not expanded; container.Visible = expanded; container.Size = expanded and UDim2.new(0.9, 0, 0, #dCfg.Options * 35) or UDim2.new(0.9, 0, 0, 0)
            end)
        end

        function Elements:CreateThemeSection()
            for n, c in pairs(Presets) do
                self:CreateButton({Name = "Theme: "..n, Callback = function()
                    Library.CurrentTheme.MainBG = Color3.fromHex(c.MainBG)
                    Library.CurrentTheme.SecBG = Color3.fromHex(c.SecBG)
                    Library.CurrentTheme.Accent = Color3.fromHex(c.Accent)
                    Library.CurrentTheme.Text = Color3.fromHex(c.Text)
                    Library:UpdateUI()
                end})
            end
        end

        if #Content:GetChildren() == 1 then Page.Visible = true end
        return Elements
    end

    Library:UpdateUI()
    return WindowActions
end

return Library
