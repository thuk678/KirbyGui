-- Kirby Editor UI Library

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer

local Library = {}
Library.__index = Library

-- Notification
function Library:Notify(text, t)
	t = t or 3
	local g = Instance.new("ScreenGui", Player.PlayerGui)
	local f = Instance.new("Frame", g)
	f.Size = UDim2.fromScale(.3,.07)
	f.Position = UDim2.fromScale(.35,1)
	f.BackgroundColor3 = Color3.fromRGB(30,30,45)
	Instance.new("UICorner",f).CornerRadius=UDim.new(0,10)

	local l = Instance.new("TextLabel",f)
	l.Size = UDim2.fromScale(1,1)
	l.BackgroundTransparency=1
	l.Text=text
	l.Font=Enum.Font.Gotham
	l.TextSize=14
	l.TextColor3=Color3.new(1,1,1)

	TweenService:Create(f,TweenInfo.new(.3),{Position=UDim2.fromScale(.35,.9)}):Play()
	task.delay(t,function()
		g:Destroy()
	end)
end

-- Window
function Library:CreateWindow(title)
	local gui = Instance.new("ScreenGui", Player.PlayerGui)
	gui.Name = "KirbyUI"
	gui.ResetOnSpawn=false

	local main = Instance.new("Frame", gui)
	main.Size = UDim2.fromScale(.6,.6)
	main.Position = UDim2.fromScale(.5,.5)
	main.AnchorPoint=Vector2.new(.5,.5)
	main.BackgroundColor3=Color3.fromRGB(20,20,30)
	main.Active=true
	main.Draggable=true
	Instance.new("UICorner",main).CornerRadius=UDim.new(0,14)

	-- Topbar
	local top = Instance.new("Frame",main)
	top.Size=UDim2.new(1,0,0,40)
	top.BackgroundTransparency=1

	local t = Instance.new("TextLabel",top)
	t.Size=UDim2.new(1,-40,1,0)
	t.Text=title
	t.Font=Enum.Font.GothamBold
	t.TextSize=18
	t.TextColor3=Color3.new(1,1,1)
	t.BackgroundTransparency=1

	-- Exit button (AUTO)
	local close = Instance.new("TextButton",top)
	close.Size=UDim2.new(0,30,0,30)
	close.Position=UDim2.new(1,-35,0,5)
	close.Text="✕"
	close.Font=Enum.Font.GothamBold
	close.TextColor3=Color3.new(1,1,1)
	close.BackgroundColor3=Color3.fromRGB(40,40,60)
	Instance.new("UICorner",close)

	close.MouseButton1Click:Connect(function()
		gui:Destroy()
	end)

	-- Hide key (RightShift)
	UIS.InputBegan:Connect(function(i,g)
		if not g and i.KeyCode==Enum.KeyCode.RightShift then
			main.Visible=not main.Visible
		end
	end)

	-- Tabs
	local tabs = Instance.new("Frame",main)
	tabs.Size=UDim2.new(0,140,1,-40)
	tabs.Position=UDim2.new(0,0,0,40)
	tabs.BackgroundColor3=Color3.fromRGB(18,18,26)

	local pages = Instance.new("Frame",main)
	pages.Size=UDim2.new(1,-140,1,-40)
	pages.Position=UDim2.new(0,140,0,40)
	pages.BackgroundTransparency=1

	local window={}
	local current

	function window:CreateTab(name)
		local b = Instance.new("TextButton",tabs)
		b.Size=UDim2.new(1,0,0,40)
		b.Text=name
		b.Font=Enum.Font.Gotham
		b.TextSize=14
		b.TextColor3=Color3.new(1,1,1)
		b.BackgroundColor3=Color3.fromRGB(25,25,40)

		local p = Instance.new("ScrollingFrame",pages)
		p.Size=UDim2.fromScale(1,1)
		p.CanvasSize=UDim2.new(0,0,0,0)
		p.ScrollBarImageTransparency=1
		p.Visible=false

		local layout = Instance.new("UIListLayout",p)
		layout.Padding=UDim.new(0,8)

		b.MouseButton1Click:Connect(function()
			if current then current.Visible=false end
			p.Visible=true
			current=p
		end)

		if not current then
			p.Visible=true
			current=p
		end

		local tab={}

		function tab:Section(text)
			local l=Instance.new("TextLabel",p)
			l.Size=UDim2.new(1,-10,0,30)
			l.Text=text
			l.TextXAlignment=Left
			l.Font=Enum.Font.GothamBold
			l.TextSize=14
			l.TextColor3=Color3.fromRGB(160,160,255)
			l.BackgroundTransparency=1
		end

		function tab:Divider()
			local d=Instance.new("Frame",p)
			d.Size=UDim2.new(1,-20,0,1)
			d.BackgroundColor3=Color3.fromRGB(60,60,80)
		end

		function tab:Button(text,cb)
			local b=Instance.new("TextButton",p)
			b.Size=UDim2.new(1,-10,0,40)
			b.Text=text
			b.Font=Enum.Font.Gotham
			b.TextSize=14
			b.TextColor3=Color3.new(1,1,1)
			b.BackgroundColor3=Color3.fromRGB(35,35,55)
			Instance.new("UICorner",b)
			b.MouseButton1Click:Connect(function()
				pcall(cb)
			end)
		end

		function tab:Toggle(text,def,cb)
			local v=def
			tab:Button(text.." : OFF",function()
				v=not v
				cb(v)
			end)
		end

		function tab:Textbox(text,cb)
			local box=Instance.new("TextBox",p)
			box.Size=UDim2.new(1,-10,0,40)
			box.PlaceholderText=text
			box.Font=Enum.Font.Gotham
			box.TextSize=14
			box.TextColor3=Color3.new(1,1,1)
			box.BackgroundColor3=Color3.fromRGB(35,35,55)
			box.FocusLost:Connect(function()
				cb(box.Text)
			end)
		end

		function tab:Label(text)
			local l=Instance.new("TextLabel",p)
			l.Size=UDim2.new(1,-10,0,30)
			l.Text=text
			l.Font=Enum.Font.Gotham
			l.TextSize=13
			l.TextColor3=Color3.fromRGB(200,200,200)
			l.BackgroundTransparency=1
		end

		function tab:Paragraph(text)
			tab:Label(text)
		end

		return tab
	end

	function window:Destroy()
		gui:Destroy()
	end

	return window
end

return Library
