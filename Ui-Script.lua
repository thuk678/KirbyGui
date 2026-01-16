local KirbyLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/thuk678/KirbyGui/refs/heads/main/Ui-Script.lua"))()

local Window = KirbyLib:CreateWindow({
    Name = "Kirby Hub"
})

local MainTab = Window:CreateTab("Main")

-- 1. Toggle
MainTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = false,
    Callback = function(Value)
        print("Auto Farm is now:", Value)
    end
})

-- 2. Slider
MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 200},
    CurrentValue = 16,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

-- 3. Dropdown
MainTab:CreateDropdown({
    Name = "Teleport To",
    Options = {"Spawn", "Shop", "Boss Area", "Void"},
    CurrentValue = "Spawn",
    Callback = function(Option)
        print("Teleporting to:", Option)
    end
})

local SettingsTab = Window:CreateTab("Settings")
SettingsTab:CreateThemeSection()
