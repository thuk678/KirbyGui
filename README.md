-- EditorStyle UI Library

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer

local Library = {}
Library.__index = Library

-- Notification
function Library:Notify(text, time)
	time = time or 3
	local n = Instance.new("ScreenGui", Player.PlayerGui)
	n.Name = "Notification"

	local f = Instance.new("Frame", n)
	f.Size = UDim2.fromScale(0.3,0.08)
	f.Position = UDim2.fromScale(0.35,1)
	f.BackgroundColor3 = Color3.fromRGB(30,30,40)
	Instance.new("UICorner", f).CornerRadius = UDim.new(0,10)

	local l = Instance.new("TextLabel", f)
	l.Size = UDim2.fromScale(1,1)
	l.BackgroundTransparency = 1
	l.Text = text
	l.Font = Enum.Font.Gotham
	l.TextSize = 14
	l.TextColor3 = Color3.new(1,1,1)

	TweenService:Create(f,TweenInfo.new(.3),{Position=UDim2.fromScale(0.35,0.88)}):Play()
	task.delay(time,function()
		TweenService:Create(f,TweenInfo.new(.3),{Position=UDim2.fromScale(0.35,1)}):Play()
		task.wait(.3)
		n:Destroy()
	end)
end

-- Window
function Library:CreateWindow(title)
	local gui = Instance.new("ScreenGui", Player.PlayerGui)
	gui.Name = "EditorUI"
	gui.ResetOnSpawn = false

	local main = Instance.new("Frame", gui)
	main.Size = UDim2.fromScale(0.6,0.6)
	main.Position = UDim2.fromScale(0.5,0.5)
	main.AnchorPoint = Vector2.new(0.5,0.5)
	main.BackgroundColor3 = Color3.fromRGB(20,20,30)
	main.Active = true
	main.Draggable = true
	Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

	local top = Instance.new("TextLabel", main)
	top.Size = UDim2.new(1,0,0,40)
	top.BackgroundTransparency = 1
	top.Text = title
	top.Font = Enum.Font.GothamBold
	top.TextSize = 18
	top.TextColor3 = Color3.new(1,1,1)

	local tabs = Instance.new("Frame", main)
	tabs.Size = UDim2.new(0,140,1,-40)
	tabs.Position = UDim2.new(0,0,0,40)
	tabs.BackgroundColor3 = Color3.fromRGB(18,18,25)

	local pages = Instance.new("Frame", main)
	pages.Size = UDim2.new(1,-140,1,-40)
	pages.Position = UDim2.new(0,140,0,40)
	pages.BackgroundTransparency = 1

	local window = {}
	local current

	-- Tab
	function window:CreateTab(name)
		local b = Instance.new("TextButton", tabs)
		b.Size = UDim2.new(1,0,0,40)
		b.Text = name
		b.Font = Enum.Font.Gotham
		b.TextSize = 14
		b.TextColor3 = Color3.new(1,1,1)
		b.BackgroundColor3 = Color3.fromRGB(25,25,35)

		local p = Instance.new("ScrollingFrame", pages)
		p.Size = UDim2.fromScale(1,1)
		p.CanvasSize = UDim2.new(0,0,0,0)
		p.ScrollBarImageTransparency = 1
		p.Visible = false

		local layout = Instance.new("UIListLayout", p)
		layout.Padding = UDim.new(0,8)

		b.MouseButton1Click:Connect(function()
			if current then current.Visible = false end
			p.Visible = true
			current = p
		end)

		if not current then
			p.Visible = true
			current = p
		end

		local tab = {}

		-- Section
		function tab:Section(text)
			local l = Instance.new("TextLabel", p)
			l.Size = UDim2.new(1,-10,0,30)
			l.Text = text
			l.TextXAlignment = Left
			l.Font = Enum.Font.GothamBold
			l.TextSize = 14
			l.TextColor3 = Color3.fromRGB(170,170,255)
			l.BackgroundTransparency = 1
		end

		-- Divider
		function tab:Divider()
			local d = Instance.new("Frame", p)
			d.Size = UDim2.new(1,-20,0,1)
			d.BackgroundColor3 = Color3.fromRGB(60,60,80)
		end

		-- Button
		function tab:Button(text, cb)
			local b = Instance.new("TextButton", p)
			b.Size = UDim2.new(1,-10,0,40)
			b.Text = text
			b.Font = Enum.Font.Gotham
			b.TextSize = 14
			b.TextColor3 = Color3.new(1,1,1)
			b.BackgroundColor3 = Color3.fromRGB(35,35,50)
			Instance.new("UICorner", b)
			b.MouseButton1Click:Connect(function() pcall(cb) end)
		end

		-- Toggle
		function tab:Toggle(text, def, cb)
			local v = def
			tab:Button(text.." : OFF", function()
				v = not v
				cb(v)
			end)
		end

		-- Slider
		function tab:Slider(text,min,max,cb)
			local s = Instance.new("TextLabel", p)
			s.Size = UDim2.new(1,-10,0,40)
			s.Text = text.." ("..min..")"
			s.Font = Enum.Font.Gotham
			s.TextSize = 14
			s.TextColor3 = Color3.new(1,1,1)
			s.BackgroundColor3 = Color3.fromRGB(35,35,50)
		end

		-- Dropdown
		function tab:Dropdown(text,list,cb)
			tab:Button(text,function()
				cb(list[1])
			end)
		end

		-- Keybind
		function tab:Keybind(text, key, cb)
			UIS.InputBegan:Connect(function(i,g)
				if not g and i.KeyCode == key then cb() end
			end)
		end

		-- Input / Textbox
		function tab:Textbox(text,cb)
			local box = Instance.new("TextBox", p)
			box.Size = UDim2.new(1,-10,0,40)
			box.PlaceholderText = text
			box.Font = Enum.Font.Gotham
			box.TextSize = 14
			box.TextColor3 = Color3.new(1,1,1)
			box.BackgroundColor3 = Color3.fromRGB(35,35,50)
			box.FocusLost:Connect(function()
				cb(box.Text)
			end)
		end

		-- ColorPicker (simple)
		function tab:ColorPicker(text,cb)
			tab:Button(text,function()
				cb(Color3.new(1,0,0))
			end)
		end

		-- Label
		function tab:Label(text)
			local l = Instance.new("TextLabel", p)
			l.Size = UDim2.new(1,-10,0,30)
			l.Text = text
			l.Font = Enum.Font.Gotham
			l.TextSize = 13
			l.TextColor3 = Color3.fromRGB(200,200,200)
			l.BackgroundTransparency = 1
		end

		-- Paragraph
		function tab:Paragraph(text)
			tab:Label(text)
		end

		return tab
	end

	function window:Visibility(state)
		main.Visible = state
	end

	function window:Destroy()
		gui:Destroy()
	end

	return window
end

return Library
