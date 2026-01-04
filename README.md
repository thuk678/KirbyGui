-- Kirby Editor UI Library (Expanded Version)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer

local Library = {}
Library.__index = Library

-- Helper for smooth transitions
local function ApplyHover(obj, color1, color2)
	obj.MouseEnter:Connect(function()
		TweenService:Create(obj, TweenInfo.new(0.2), {BackgroundColor3 = color2}):Play()
	end)
	obj.MouseLeave:Connect(function()
		TweenService:Create(obj, TweenInfo.new(0.2), {BackgroundColor3 = color1}):Play()
	end)
end

-- Notification System
function Library:Notify(text, duration)
	duration = duration or 3
	local g = Instance.new("ScreenGui", Player.PlayerGui)
	local f = Instance.new("Frame", g)
	f.Size = UDim2.fromScale(.25, .08)
	f.Position = UDim2.fromScale(0.375, 1.1) -- Starts off-screen
	f.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
	f.BorderSizePixel = 0
	Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
	
	local l = Instance.new("TextLabel", f)
	l.Size = UDim2.fromScale(1, 1)
	l.BackgroundTransparency = 1
	l.Text = text
	l.Font = Enum.Font.GothamMedium
	l.TextSize = 14
	l.TextColor3 = Color3.new(1, 1, 1)

	-- Animation Sequence
	f:TweenPosition(UDim2.fromScale(0.375, 0.88), "Out", "Back", 0.4, true)
	task.delay(duration, function()
		f:TweenPosition(UDim2.fromScale(0.375, 1.1), "In", "Quad", 0.3, true)
		task.wait(0.3)
		g:Destroy()
	end)
end

-- Main Window Creation
function Library:CreateWindow(title)
	local gui = Instance.new("ScreenGui", Player.PlayerGui)
	gui.Name = "KirbyUI_v2"
	gui.ResetOnSpawn = false

	local main = Instance.new("Frame", gui)
	main.Size = UDim2.fromOffset(550, 350)
	main.Position = UDim2.fromScale(.5, .5)
	main.AnchorPoint = Vector2.new(.5, .5)
	main.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
	main.Active = true
	main.Draggable = true -- Legacy dragging
	Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

	-- Topbar
	local top = Instance.new("Frame", main)
	top.Size = UDim2.new(1, 0, 0, 45)
	top.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
	local tc = Instance.new("UICorner", top)
	tc.CornerRadius = UDim.new(0, 10)
	
	-- Cover the bottom corners of the topbar
	local cover = Instance.new("Frame", top)
	cover.Size = UDim2.new(1, 0, 0, 10)
	cover.Position = UDim2.new(0, 0, 1, -10)
	cover.BackgroundColor3 = top.BackgroundColor3
	cover.BorderSizePixel = 0

	local t = Instance.new("TextLabel", top)
	t.Size = UDim2.new(1, -50, 1, 0)
	t.Position = UDim2.new(0, 15, 0, 0)
	t.Text = title:upper()
	t.Font = Enum.Font.GothamBold
	t.TextSize = 16
	t.TextColor3 = Color3.new(1, 1, 1)
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.BackgroundTransparency = 1

	-- Close Button
	local close = Instance.new("TextButton", top)
	close.Size = UDim2.new(0, 30, 0, 30)
	close.Position = UDim2.new(1, -38, 0, 7)
	close.Text = "×"
	close.TextSize = 20
	close.Font = Enum.Font.GothamBold
	close.TextColor3 = Color3.new(1, 1, 1)
	close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	Instance.new("UICorner", close).CornerRadius = UDim.new(1, 0)
	close.MouseButton1Click:Connect(function() gui:Destroy() end)

	-- Sidebar & Content
	local tabs = Instance.new("ScrollingFrame", main)
	tabs.Size = UDim2.new(0, 150, 1, -45)
	tabs.Position = UDim2.new(0, 0, 0, 45)
	tabs.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
	tabs.BorderSizePixel = 0
	tabs.ScrollBarThickness = 2
	local tabLayout = Instance.new("UIListLayout", tabs)
	tabLayout.Padding = UDim.new(0, 5)

	local pages = Instance.new("Frame", main)
	pages.Size = UDim2.new(1, -160, 1, -55)
	pages.Position = UDim2.new(0, 155, 0, 50)
	pages.BackgroundTransparency = 1

	-- Toggle Visibility with Key
	UIS.InputBegan:Connect(function(input, processed)
		if not processed and input.KeyCode == Enum.KeyCode.RightShift then
			main.Visible = not main.Visible
		end
	end)

	local window = { CurrentTab = nil }

	function window:CreateTab(name)
		local b = Instance.new("TextButton", tabs)
		b.Size = UDim2.new(1, -10, 0, 35)
		b.Text = "  " .. name
		b.Font = Enum.Font.Gotham
		b.TextSize = 13
		b.TextColor3 = Color3.fromRGB(180, 180, 180)
		b.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
		b.TextXAlignment = Enum.TextXAlignment.Left
		Instance.new("UICorner", b)
		ApplyHover(b, Color3.fromRGB(30, 30, 45), Color3.fromRGB(45, 45, 65))

		local p = Instance.new("ScrollingFrame", pages)
		p.Size = UDim2.fromScale(1, 1)
		p.BackgroundTransparency = 1
		p.Visible = false
		p.ScrollBarThickness = 4
		p.CanvasSize = UDim2.new(0, 0, 0, 0)
		local pLayout = Instance.new("UIListLayout", p)
		pLayout.Padding = UDim.new(0, 10)
		pLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		
		-- Auto-resize scroll canvas
		pLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			p.CanvasSize = UDim2.new(0, 0, 0, pLayout.AbsoluteContentSize.Y + 20)
		end)

		b.MouseButton1Click:Connect(function()
			if window.CurrentTab then window.CurrentTab.Visible = false end
			p.Visible = true
			window.CurrentTab = p
		end)

		if not window.CurrentTab then
			p.Visible = true
			window.CurrentTab = p
		end

		local tab = {}

		function tab:Section(text)
			local l = Instance.new("TextLabel", p)
			l.Size = UDim2.new(0.95, 0, 0, 25)
			l.Text = text:upper()
			l.Font = Enum.Font.GothamBold
			l.TextSize = 12
			l.TextColor3 = Color3.fromRGB(100, 100, 255)
			l.BackgroundTransparency = 1
			l.TextXAlignment = Enum.TextXAlignment.Left
		end

		function tab:Button(text, callback)
			local btn = Instance.new("TextButton", p)
			btn.Size = UDim2.new(0.95, 0, 0, 38)
			btn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
			btn.Text = text
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 14
			Instance.new("UICorner", btn)
			ApplyHover(btn, Color3.fromRGB(35, 35, 55), Color3.fromRGB(50, 50, 80))
			btn.MouseButton1Click:Connect(function() pcall(callback) end)
		end

		function tab:Toggle(text, default, callback)
			local state = default
			local btn = Instance.new("TextButton", p)
			btn.Size = UDim2.new(0.95, 0, 0, 38)
			btn.BackgroundColor3 = state and Color3.fromRGB(45, 80, 45) or Color3.fromRGB(55, 35, 35)
			btn.Text = text .. " : " .. (state and "ON" or "OFF")
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.Font = Enum.Font.Gotham
			Instance.new("UICorner", btn)

			btn.MouseButton1Click:Connect(function()
				state = not state
				btn.Text = text .. " : " .. (state and "ON" or "OFF")
				local color = state and Color3.fromRGB(45, 80, 45) or Color3.fromRGB(55, 35, 35)
				TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = color}):Play()
				pcall(callback, state)
			end)
		end

		function tab:Textbox(placeholder, callback)
			local box = Instance.new("TextBox", p)
			box.Size = UDim2.new(0.95, 0, 0, 38)
			box.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
			box.PlaceholderText = placeholder
			box.Text = ""
			box.TextColor3 = Color3.new(1, 1, 1)
			box.Font = Enum.Font.Gotham
			Instance.new("UICorner", box)
			box.FocusLost:Connect(function(enter)
				if enter then pcall(callback, box.Text) end
			end)
		end

		return tab
	end

	return window
end

return Library
