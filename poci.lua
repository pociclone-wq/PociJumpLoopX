-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Icon
local icon = Instance.new("TextButton")
icon.Parent = gui
icon.Size = UDim2.new(0,45,0,45)
icon.Position = UDim2.new(0,20,0,100)
icon.Text = "poci\n+"
icon.TextWrapped = true
icon.BackgroundColor3 = Color3.fromRGB(255,0,0)
icon.TextColor3 = Color3.fromRGB(255,255,255)
icon.Font = Enum.Font.SourceSansBold
icon.TextSize = 14
Instance.new("UICorner", icon).CornerRadius = UDim.new(0,10)

-- Menu kanan
local menu = Instance.new("Frame")
menu.Parent = gui
menu.Size = UDim2.new(0,260,0,340)
menu.Position = UDim2.new(1,-270,0.5,-170)
menu.BackgroundColor3 = Color3.fromRGB(50,50,50)
menu.Visible = false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0,10)

icon.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

-- Data lokasi
local savedLocations = {}
local spots = {"LokA","LokB","LokC","LokD"}
local currentIndex = 1
local globalTime = 600
local running = false

-- Judul
local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1,0,0,30)
title.Position = UDim2.new(0,0,0,5)
title.BackgroundTransparency = 1
title.Text = "POCI JUMP LOOP"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

-- Input waktu global
local label = Instance.new("TextLabel", menu)
label.Size = UDim2.new(1,0,0,25)
label.Position = UDim2.new(0,0,0,40)
label.BackgroundTransparency = 1
label.Text = "Set Global Countdown (detik):"
label.TextColor3 = Color3.fromRGB(255,255,255)
label.Font = Enum.Font.SourceSans
label.TextSize = 14

local input = Instance.new("TextBox", menu)
input.Size = UDim2.new(1,-20,0,30)
input.Position = UDim2.new(0,10,0,65)
input.BackgroundColor3 = Color3.fromRGB(80,80,80)
input.TextColor3 = Color3.fromRGB(255,255,255)
input.Font = Enum.Font.SourceSans
input.TextSize = 14
input.Text = tostring(globalTime)
Instance.new("UICorner", input).CornerRadius = UDim.new(0,6)

input.FocusLost:Connect(function()
    local val = tonumber(input.Text)
    if val and val > 0 then
        globalTime = val
    else
        input.Text = tostring(globalTime)
    end
end)

-- Label countdown
local countdownLabel = Instance.new("TextLabel", menu)
countdownLabel.Size = UDim2.new(1,0,0,30)
countdownLabel.Position = UDim2.new(0,0,0,100)
countdownLabel.BackgroundTransparency = 1
countdownLabel.Text = "Waktu: "..globalTime.."s"
countdownLabel.TextColor3 = Color3.fromRGB(255,255,255)
countdownLabel.Font = Enum.Font.SourceSansBold
countdownLabel.TextSize = 16

-- Tombol Save lokasi (2 kolom, abu-abu netral)
for i,spot in ipairs(spots) do
    local btnSave = Instance.new("TextButton", menu)
    btnSave.Size = UDim2.new(0,115,0,30)
    local row = math.floor((i-1)/2)
    local col = (i-1)%2
    local xOffset = 10 + col*125
    btnSave.Position = UDim2.new(0,xOffset,0,140 + row*35)
    btnSave.Text = "Save "..spot
    btnSave.BackgroundColor3 = Color3.fromRGB(100,100,100) -- abu-abu
    btnSave.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", btnSave).CornerRadius = UDim.new(0,6)

    btnSave.MouseButton1Click:Connect(function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            savedLocations[spot] = char.HumanoidRootPart.Position
        end
    end)
end

-- Tombol Reset semua lokasi (abu-abu netral)
local btnResetAll = Instance.new("TextButton", menu)
btnResetAll.Size = UDim2.new(1,-20,0,30)
btnResetAll.Position = UDim2.new(0,10,0,220)
btnResetAll.Text = "Reset Semua Lokasi"
btnResetAll.BackgroundColor3 = Color3.fromRGB(100,100,100) -- abu-abu
btnResetAll.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", btnResetAll).CornerRadius = UDim.new(0,6)

-- Tombol Run (biru)
local btnRun = Instance.new("TextButton", menu)
btnRun.Size = UDim2.new(1,-20,0,30)
btnRun.Position = UDim2.new(0,10,0,260)
btnRun.Text = "Run Global Loop"
btnRun.BackgroundColor3 = Color3.fromRGB(0,120,255) -- biru
btnRun.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", btnRun).CornerRadius = UDim.new(0,6)

-- Tombol Stop (merah)
local btnStop = Instance.new("TextButton", menu)
btnStop.Size = UDim2.new(1,-20,0,30)
btnStop.Position = UDim2.new(0,10,0,300)
btnStop.Text = "Stop Loop"
btnStop.BackgroundColor3 = Color3.fromRGB(200,0,0) -- merah
btnStop.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", btnStop).CornerRadius = UDim.new(0,6)

-- Fungsi Run
btnRun.MouseButton1Click:Connect(function()
    if running then return end
    running = true
    spawn(function()
        while running do
            for i=globalTime,1,-1 do
                countdownLabel.Text = "Waktu: "..i.."s"
                wait(1)
                if not running then break end
            end
            if not running then break end
            local spot = spots[currentIndex]
            if savedLocations[spot] then
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = CFrame.new(savedLocations[spot])
                end
            end
            currentIndex = currentIndex % #spots + 1
        end
    end)
end)

-- Fungsi Stop
btnStop.MouseButton1Click:Connect(function()
    running = false
    countdownLabel.Text = "Stopped"
end)

-- Fungsi Reset semua lokasi
btnResetAll.MouseButton1Click:Connect(function()
    savedLocations = {}
    countdownLabel.Text = "Lokasi direset"
end)

-- Fungsi drag
local function makeDraggable(obj)
    local dragging = false
    local dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and dragging then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                     startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(icon)
makeDraggable(menu)
