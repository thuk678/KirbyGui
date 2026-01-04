-- Kirby Editor UI Library (Visual Focus Version)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer

local Library = {}
Library.__index = Library

-- Private Utility: Smooth Animations
local function Tween(obj, info, properties)
	TweenService:Create(obj, TweenInfo.new(unpack(info)), properties):Play()
end

-- Private Utility: Hover Effect
local function AddHover(btn, defaultColor, hoverColor)
	btn.MouseEnter:Connect(function()
		Tween(btn, {0.2}, {BackgroundColor3 = hoverColor})
	end)
	btn.MouseLeave:Connect(function()
		Tween(btn, {0.2}, {BackgroundColor3 = defaultColor})
	end)
end

-- Notification System (Animated Toast)
function Library:Notify(title, text, duration)
	duration = duration or 3
	local g = Instance.new("ScreenGui", Player.PlayerGui)
	
	local f = Instance.new("Frame", g)
	f.Size = UDim2.fromOffset(250, 60)
	f.Position = UDim2.new(1, 30, 0.9, 0) -- Start off-screen right
	f.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
	
	local stroke = Instance.new("UIStroke", f)
	stroke.Color = Color3.fromRGB(100, 100, 255)
	stroke.Thickness = 1.5
	
	local t = Instance.new("TextLabel", f)
	t.Size = UDim2.new(1, -20, 0.4, 0)
	t.Position = UDim2.fromOffset(10, 5)
	t.Text = title:upper()
	t.Font = Enum.Font.GothamBold
	t.TextColor3 = Color3.fromRGB(100, 100, 255)
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.BackgroundTransparency = 1
	
	local d = Instance.new("TextLabel", f)
	d.Size = UDim2.new(1, -20, 0.5, 0)
	d.Position = UDim2.fromOffset(10, 25)
	d.Text = text
	d.Font = Enum.Font.Gotham
	d.TextColor3 = Color3.new(0.8, 0.8, 0.8)
	d.TextXAlignment = Enum.TextXAlignment.Left
	d.BackgroundTransparency = 1

	-- Slide In, then Out
	Tween(f, {0.5, Enum.EasingStyle.Back}, {Position = UDim2.new(1, -270, 0.9, 0)})
	task.delay(duration, function()
		Tween(f, {0.5, Enum.EasingStyle.Quart}, {Position = UDim2.new(1, 30, 0.9, 0)})
		task.wait(0.5)
		g:Destroy()
	end)
end

-- Main Window
function Library:CreateWindow(title)
	local gui = Instance.new("ScreenGui", Player.PlayerGui)
	gui.Name = "KirbyPremiumUI"
	gui.ResetOnSpawn = false

	local main = Instance.new("Frame", gui)
	main.Size = UDim2.fromOffset(600, 400)
	main.Position = UDim2.fromScale(.5, .5)
	main.AnchorPoint = Vector2.new(.5, .5)
	main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	main.ClipsDescendants = true
	Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
	
	local mainStroke = Instance.new("UIStroke", main)
	mainStroke.Color = Color3.fromRGB(45, 45, 60)
	mainStroke.Thickness = 2

	-- Topbar Design
	local top = Instance.new("Frame", main)
	top.Size = UDim2.new(1, 0, 0, 50)
	top.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	
	local titleLabel = Instance.new("TextLabel", top)
	titleLabel.Size = UDim2.new(1, -60, 1, 0)
	titleLabel.Position = UDim2.fromOffset(20, 0)
	titleLabel.Text = title
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 20
	titleLabel.TextColor3 = Color3.new(1, 1, 1)
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.BackgroundTransparency = 1

	-- Side Navigation
	local sidebar = Instance.new("Frame", main)
	sidebar.Size = UDim2.new(0, 160, 1, -50)
	sidebar.Position = UDim2.fromOffset(0, 50)
	sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
	
	local navList = Instance.new("ScrollingFrame", sidebar)
	navList.Size = UDim2.fromScale(1, 1)
	navList.BackgroundTransparency = 1
	navList.ScrollBarThickness = 0
	local navLayout = Instance.new("UIListLayout", navList)
	navLayout.Padding = UDim.new(0, 5)
	navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	-- Main Content Area
	local container = Instance.new("Frame", main)
	container.Size = UDim2.new(1, -170, 1, -60)
	container.Position = UDim2.fromOffset(165, 55)
	container.BackgroundTransparency = 1

	local window = { CurrentTab = nil, Buttons = {} }

	function window:CreateTab(name)
		-- Tab Button UI
		local tabBtn = Instance.new("TextButton", navList)
		tabBtn.Size = UDim2.new(0.9, 0, 0, 40)
		tabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
		tabBtn.Text = name
		tabBtn.Font = Enum.Font.GothamMedium
		tabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
		tabBtn.TextSize = 14
		Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
		
		local tabStroke = Instance.new("UIStroke", tabBtn)
		tabStroke.Color = Color3.fromRGB(40, 40, 55)
		tabStroke.Thickness = 1

		-- Content Page UI
		local page = Instance.new("ScrollingFrame", container)
		page.Size = UDim2.fromScale(1, 1)
		page.Visible = false
		page.BackgroundTransparency = 1
		page.ScrollBarThickness = 3
		page.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
		local pageLayout = Instance.new("UIListLayout", page)
		pageLayout.Padding = UDim.new(0, 10)
		
		-- Tab Switch Logic
		tabBtn.MouseButton1Click:Connect(function()
			if window.CurrentTab then
				window.CurrentTab.Page.Visible = false
				Tween(window.CurrentTab.Btn, {0.3}, {TextColor3 = Color3.fromRGB(150, 150, 150), BackgroundColor3 = Color3.fromRGB(25, 25, 35)})
			end
			page.Visible = true
			window.CurrentTab = {Page = page, Btn = tabBtn}
			Tween(tabBtn, {0.3}, {TextColor3 = Color3.new(1, 1, 1), BackgroundColor3 = Color3.fromRGB(100, 100, 255)})
		end)

		if not window.CurrentTab then
			page.Visible = true
			window.CurrentTab = {Page = page, Btn = tabBtn}
			tabBtn.TextColor3 = Color3.new(1, 1, 1)
			tabBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
		end

		local tab = {}

		-- Longest UI Element List:
		
		function tab:Section(text)
			local s = Instance.new("TextLabel", page)
			s.Size = UDim2.new(1, 0, 0, 30)
			s.Text = text:upper()
			s.Font = Enum.Font.GothamBold
			s.TextSize = 12
			s.TextColor3 = Color3.fromRGB(100, 100, 255)
			s.BackgroundTransparency = 1
			s.TextXAlignment = Enum.TextXAlignment.Left
		end

		function tab:Button(text, callback)
			local b = Instance.new("TextButton", page)
			b.Size = UDim2.new(1, -10, 0, 45)
			b.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
			b.Text = "  " .. text
			b.TextColor3 = Color3.new(1, 1, 1)
			b.Font = Enum.Font.Gotham
			b.TextSize = 14
			b.TextXAlignment = Enum.TextXAlignment.Left
			Instance.new("UICorner", b)
			
			local bStroke = Instance.new("UIStroke", b)
			bStroke.Color = Color3.fromRGB(50, 50, 70)
			
			AddHover(b, Color3.fromRGB(30, 30, 45), Color3.fromRGB(40, 40, 65))
			b.MouseButton1Click:Connect(function()
				local circle = Instance.new("Frame", b) -- Ripple effect
				circle.BackgroundColor3 = Color3.new(1, 1, 1)
				circle.BackgroundTransparency = 0.8
				circle.Size = UDim2.fromOffset(0, 0)
				circle.Position = UDim2.fromScale(0.5, 0.5)
				circle.AnchorPoint = Vector2.new(0.5, 0.5)
				Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
				Tween(circle, {0.4}, {Size = UDim2.fromOffset(400, 400), BackgroundTransparency = 1})
				task.delay(0.4, function() circle:Destroy() end)
				callback()
			end)
		end

		function tab:Toggle(text, state, callback)
			local enabled = state
			local tFrame = Instance.new("TextButton", page)
			tFrame.Size = UDim2.new(1, -10, 0, 45)
			tFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
			tFrame.Text = "  " .. text
			tFrame.TextColor3 = Color3.new(1, 1, 1)
			tFrame.Font = Enum.Font.Gotham
			tFrame.TextXAlignment = Enum.TextXAlignment.Left
			Instance.new("UICorner", tFrame)
			
			local indicator = Instance.new("Frame", tFrame)
			indicator.Size = UDim2.fromOffset(40, 20)
			indicator.Position = UDim2.new(1, -50, 0.5, -10)
			indicator.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 50, 50)
			Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

			tFrame.MouseButton1Click:Connect(function()
				enabled = not enabled
				Tween(indicator, {0.3}, {BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(200, 50, 50)})
				callback(enabled)
			end)
		end

		function tab:Slider(text, min, max, default, callback)
			local sFrame = Instance.new("Frame", page)
			sFrame.Size = UDim2.new(1, -10, 0, 60)
			sFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
			Instance.new("UICorner", sFrame)

			local label = Instance.new("TextLabel", sFrame)
			label.Size = UDim2.new(1, -20, 0, 30)
			label.Position = UDim2.fromOffset(10, 5)
			label.Text = text .. ": " .. default
			label.TextColor3 = Color3.new(1, 1, 1)
			label.BackgroundTransparency = 1
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Font = Enum.Font.Gotham

			local bar = Instance.new("Frame", sFrame)
			bar.Size = UDim2.new(0.9, 0, 0, 6)
			bar.Position = UDim2.fromScale(0.05, 0.75)
			bar.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
			Instance.new("UICorner", bar)

			local fill = Instance.new("Frame", bar)
			fill.Size = UDim2.fromScale((default-min)/(max-min), 1)
			fill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
			Instance.new("UICorner", fill)

			-- Logic would go here for dragging...
		end

		return tab
	end

	return window
end

return Library
