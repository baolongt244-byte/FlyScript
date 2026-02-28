-- ==========================================
-- MM2 LITE HUB - SAFE & OPTIMIZED (NO FLY)
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local p = Players.LocalPlayer

-- QUẢN LÝ BỘ NHỚ
if _G.MM2_Connections then
    for _, conn in pairs(_G.MM2_Connections) do conn:Disconnect() end
end
_G.MM2_Connections = {}
_G.MM2_Running = true

if CoreGui:FindFirstChild("MM2_LITE") then 
    CoreGui.MM2_LITE:Destroy() 
end

-- TẠO GIAO DIỆN CHÍNH
local sg = Instance.new("ScreenGui", CoreGui)
sg.Name = "MM2_LITE"
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local bO = Instance.new("TextButton", sg)
bO.Size, bO.Position, bO.Text = UDim2.new(0,55,0,55), UDim2.new(0,15,0,200), "MM2"
bO.BackgroundColor3, bO.TextColor3 = Color3.fromRGB(15,15,15), Color3.new(1,1,1)
bO.Font, bO.TextSize, bO.Active, bO.Draggable = Enum.Font.SourceSansBold, 16, true, true
Instance.new("UICorner", bO).CornerRadius = UDim.new(1,0)

-- Thu nhỏ Frame vì đã bỏ Fly
local f = Instance.new("Frame", sg)
f.Size, f.Position, f.BackgroundColor3, f.Visible = UDim2.new(0,190,0,180), UDim2.new(0,80,0,100), Color3.fromRGB(25,25,25), false
f.Active, f.Draggable = true, true
Instance.new("UICorner", f).CornerRadius = UDim.new(0,8)

bO.MouseButton1Click:Connect(function() f.Visible = not f.Visible end)

local function nb(txt, y, cb)
    local btn = Instance.new("TextButton", f)
    btn.Size, btn.Position, btn.Text = UDim2.new(1,-10,0,32), UDim2.new(0,5,0,y), txt
    btn.BackgroundColor3, btn.TextColor3 = Color3.fromRGB(45,45,45), Color3.new(1,1,1)
    btn.Font, btn.TextSize, btn.ZIndex = Enum.Font.SourceSansBold, 14, 5
    
    local debounce = false
    local function safeCb()
        if debounce then return end
        debounce = true
        cb(btn)
        task.wait(0.2)
        debounce = false
    end
    
    btn.MouseButton1Click:Connect(safeCb)
    btn.TouchTap:Connect(safeCb)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)
    return btn
end

-- 1. ESP
local esp = false
nb("ESP: OFF", 10, function(btn)
    esp = not esp
    btn.Text = "ESP: " .. (esp and "ON" or "OFF")
    btn.BackgroundColor3 = esp and Color3.fromRGB(0,120,0) or Color3.fromRGB(45,45,45)
    
    if not esp then
        for _, v in ipairs(Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("MM2_ESP_HL") then v.Character.MM2_ESP_HL:Destroy() end
        end
    end
end)

task.spawn(function()
    while _G.MM2_Running do
        if esp then
            for _, v in ipairs(Players:GetPlayers()) do
                if v ~= p and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local char = v.Character
                    local bp = v:FindFirstChild("Backpack")
                    local h = char:FindFirstChild("MM2_ESP_HL")
                    
                    if not h then
                        h = Instance.new("Highlight")
                        h.Name = "MM2_ESP_HL"
                        h.Parent = char
                    end
                    
                    if (bp and bp:FindFirstChild("Knife")) or char:FindFirstChild("Knife") then
                        h.FillColor = Color3.new(1,0,0)
                    elseif (bp and bp:FindFirstChild("Gun")) or char:FindFirstChild("Gun") then
                        h.FillColor = Color3.new(0,0,1)
                    else 
                        h.FillColor = Color3.new(0,1,0) 
                    end
                end
            end
        end
        task.wait(1)
    end
end)

-- 2. NHẶT SÚNG (FIXED TRIỆT ĐỂ)
nb("NHẶT SÚNG (AUTO)", 50, function()
    local g = workspace:FindFirstChild("GunDrop")
    local char = p.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if g and g:IsA("BasePart") and hrp then
        -- Cách 1: Dùng hàm ép chạm của Executor (Rất mượt nếu có hỗ trợ)
        if firetouchinterest then
            firetouchinterest(hrp, g, 0)
            task.wait(0.1)
            firetouchinterest(hrp, g, 1)
        else
            -- Cách 2: Ép vị trí liên tục trong 0.5s để server ghi nhận va chạm
            local oldCF = hrp.CFrame
            for i = 1, 5 do
                if hrp and g then
                    hrp.CFrame = g.CFrame
                    task.wait(0.1)
                end
            end
            if hrp then hrp.CFrame = oldCF end
        end
    end
end)

-- 3. NOCLIP
local nc = false
local noclipConn
nb("NOCLIP: OFF", 90, function(btn)
    nc = not nc
    btn.Text = "NOCLIP: " .. (nc and "ON" or "OFF")
    btn.BackgroundColor3 = nc and Color3.fromRGB(0,120,0) or Color3.fromRGB(45,45,45)
    
    if nc then
        noclipConn = RunService.Stepped:Connect(function()
            if p.Character then
                for _, v in ipairs(p.Character:GetChildren()) do 
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)
        table.insert(_G.MM2_Connections, noclipConn)
    else
        if noclipConn then noclipConn:Disconnect() end
        if p.Character then
            for _, v in ipairs(p.Character:GetChildren()) do
                if v:IsA("BasePart") then v.CanCollide = true end
            end
        end
    end
end)

-- 4. CLEANUP
local cl = nb("GỠ SCRIPT HOÀN TOÀN", 135, function()
    _G.MM2_Running = false
    for _, conn in pairs(_G.MM2_Connections) do conn:Disconnect() end
    _G.MM2_Connections = {}
    
    for _, v in ipairs(Players:GetPlayers()) do
        if v.Character and v.Character:FindFirstChild("MM2_ESP_HL") then v.Character.MM2_ESP_HL:Destroy() end
    end
    
    if p.Character then
        for _, v in ipairs(p.Character:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
    end
    sg:Destroy()
end)
cl.BackgroundColor3 = Color3.fromRGB(150,0,0)
