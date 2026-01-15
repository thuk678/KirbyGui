local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Colors from your React Design
local Theme = {
    MainBG = Color3.fromHex("#EAE0CF"),
    Accent = Color3.fromHex("#94B4C1"),
    Dark = Color3.fromHex("#213448"),
    Text = Color3.fromHex("#EAE0CF"),
    Black = Color3.fromHex("#000000")
}

function Library:CreateWindow(Config)
    local WindowName = Config.Name or "Kirby Hub"
    
    -- 1. STARTUP LOADING SCREEN
    local LoadingGui = Instance.new("ScreenGui")
    LoadingGui.Name = "KirbyLoading"
    LoadingGui.Parent = CoreGui
    
    local LMain = Instance.new("Frame")
    LMain.Size = UDim2.new(0, 350, 0, 350)
    LMain.Position = UDim2.new(0.5, -175, 0.5, -175)
    LMain.BackgroundColor3 = Theme.MainBG
    LMain.BorderSizePixel = 2
    LMain.BorderColor3 = Theme.Black
    LMain.Parent = LoadingGui

    local LText = Instance.new("TextLabel")
    LText.Size = UDim2.new(1, 0, 1, 0)
    LText.Text = "KIRBY GUI LOADING..."
    LText.Font = Enum.Font.GothamBold -- Fixed font
    LText.TextSize = 20
    LText.TextColor3 = Theme.Dark
    LText.BackgroundTransparency = 1
    LText.Parent = LMain
    
    task.wait(2)
    LoadingGui:Destroy()

    -- 2. MAIN INTERFACE
    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "Kirby_Lib"
    MainGui.Parent = CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 350, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -175, 0.5, -175)
    MainFrame.BackgroundColor3 = Theme.MainBG
    MainFrame.BorderSizePixel = 2
    MainFrame.BorderColor3 = Theme.Black
    MainFrame.Parent = MainGui

    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 45)
    TopBar.BackgroundColor3 = Theme.Accent
    TopBar.BorderSizePixel = 2
    TopBar.BorderColor3 = Theme.Black
    TopBar.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Text = WindowName
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.TextColor3 = Theme.Text
    Title.Font = Enum.Font.Gotham -- Fixed font
    Title.TextSize = 18
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    -- Exit Button
    local ExitBtn = Instance.new("TextButton")
    ExitBtn.Size = UDim2.new(0, 30, 0, 30)
    ExitBtn.Position = UDim2.new(1, -37, 0, 7)
    ExitBtn.BackgroundColor3 = Theme.Dark
    ExitBtn.Text = "X"
    ExitBtn.TextColor3 = Theme.Text
    ExitBtn.Font = Enum.Font.GothamBold -- Fixed font
    ExitBtn.Parent = TopBar
    ExitBtn.MouseButton1Click:Connect(function() MainGui:Destroy() end)

    -- Sidebar
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Size = UDim2.new(0, 90, 1, -45)
    Sidebar.Position = UDim2.new(0, 0, 0, 45)
    Sidebar.BackgroundColor3 = Theme.Accent
    Sidebar.BorderSizePixel = 2
    Sidebar.BorderColor3 = Theme.Black
    Sidebar.ScrollBarThickness = 0
    Sidebar.Parent = MainFrame

    local SideLayout = Instance.new("UIListLayout")
    SideLayout.Parent = Sidebar
    SideLayout.Padding = UDim.new(0, 2)
    SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- Container
    local Container = Instance.new("ScrollingFrame")
    Container.Size = UDim2.new(1, -100, 1, -55)
    Container.Position = UDim2.new(0, 95, 0, 50)
    Container.BackgroundColor3 = Theme.Accent
    Container.BorderSizePixel = 2
    Container.BorderColor3 = Theme.Black
    Container.ScrollBarThickness = 4
    Container.Parent = MainFrame

    local ContainerLayout = Instance.new("UIListLayout")
    ContainerLayout.Parent = Container
    ContainerLayout.Padding = UDim.new(0, 5)
    ContainerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- Dragging
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    local WindowMethods = {}

    function WindowMethods:CreateTab(TabName)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, -4, 0, 35)
        TabBtn.BackgroundColor3 = Theme.Dark
        TabBtn.Text = TabName
        TabBtn.TextColor3 = Theme.Text
        TabBtn.Font = Enum.Font.Gotham -- Fixed font
        TabBtn.Parent = Sidebar

        local TabMethods = {}

        function TabMethods:CreateButton(BtnName, Callback)
            local NewBtn = Instance.new("TextButton")
            NewBtn.Size = UDim2.new(1, -10, 0, 35)
            NewBtn.BackgroundColor3 = Theme.Dark
            NewBtn.Text = BtnName
            NewBtn.TextColor3 = Theme.Text
            NewBtn.Font = Enum.Font.Gotham -- Fixed font
            NewBtn.Parent = Container
            
            NewBtn.MouseButton1Click:Connect(function()
                Callback()
                NewBtn.BackgroundColor3 = Color3.new(1,1,1)
                task.wait(0.1)
                NewBtn.BackgroundColor3 = Theme.Dark
            end)
        end
        
        return TabMethods
    end

    return WindowMethods
end

return Library
