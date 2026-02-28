-- MM2 ULTRA HUB - MOBILE OPTIMIZED (XNEO FLY & PIVOT GRAB)
local p = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local core = game:GetService("CoreGui")

-- Xóa bản cũ nếu đang chạy
if core:FindFirstChild("MM2_ULTRA") then core.MM2_ULTRA:Destroy() end

local sg = Instance.new("ScreenGui", core)
sg.Name = "MM2_ULTRA"
sg.ResetOnSpawn = false

-- 1. NÚT TRÒN MỞ MENU (KÉO THẢ ĐƯỢC)
local bO = Instance.new("TextButton", sg)
bO.Size, bO.Position, bO.Text = UDim2.new(0,55,0,55), UDim2.new(0,15,0,200), "MM2"
bO.BackgroundColor3, bO.TextColor3 = Color3.new(0,0,0), Color3.new(1,1,1)
bO.Font, bO.TextSize = Enum.Font.SourceSansBold, 18
bO.Active, bO.Draggable = true, true
local corner = Instance.new("UICorner", bO)
corner.CornerRadius = UDim.new(1,0)

-- 2. KHUNG MENU CHÍNH
local f = Instance.new("Frame", sg)
f.Size, f.Position, f.BackgroundColor3, f.Visible = UDim2.new(0,190,0,390), UDim2.new(0,80,0,100), Color3.fromRGB(15,15,15), false
f.Active, f.Draggable = true, true
f.BorderSizePixel = 0
Instance.new("UICorner", f).CornerRadius = UDim.new(0,10)

bO.MouseButton1Click:Connect(function() f.Visible = not f.Visible end)

-- HÀM TẠO NÚT
local function nb(t, y, c)
    local b = Instance.new("TextButton", f)
    b.Size, b.Position, b.Text = UDim2.new(1,-10,0,35), UDim2.new(0,5,0,y), t
    b.BackgroundColor3, b.TextColor3 = Color3.fromRGB(35,35,35), Color3.new(1,1,1)
    b.Font, b.TextSize = Enum.Font.SourceSansBold, 14
    b.MouseButton1Click:Connect(c)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    return b
end

-- 3. CHỨC NĂNG ESP (NHÌN XUYÊN VAI TRÒ)
local esp = false
local eB = nb("ESP: OFF", 10, function()
    esp = not esp
    f.eb.Text = "ESP: " .. (esp and "ON" or "OFF")
    f.eb.BackgroundColor3 = esp and Color3.fromRGB(0,120,0) or Color3.fromRGB(35,35,35)
end)
f.eb = eB

task.spawn(function()
    while true do
        if esp then
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= p and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local h = v.Character:FindFirstChild("Highlight") or Instance.new("Highlight", v.Character)
                    if v.Backpack:FindFirstChild("Knife") or v.Character:FindFirstChild("Knife") then h.FillColor = Color3.new(1,0,0)
                    elseif v.Backpack:FindFirstChild("Gun") or v.Character:FindFirstChild("Gun") then h.FillColor = Color3.new(0,0,1)
                    else h.FillColor = Color3.new(0,1,0) end
                end
            end
        else
            for _, v in pairs(game.Players:GetPlayers()) do if v.Character and v.Character:FindFirstChild("Highlight") then v.Character.Highlight:Destroy() end end
        end
        task.wait(1)
    end
end)

-- 4. CHỨC NĂNG NHẶT SÚNG (TP & BACK - FIXED)
nb("NHẶT SÚNG (TELEPORT)", 50, function()
    local gun = workspace:FindFirstChild("GunDrop")
    if gun and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        local oldCF = p.Character.HumanoidRootPart.CFrame
        p.Character:PivotTo(gun.CFrame * CFrame.new(0,1,0)) -- Dùng PivotTo cưỡng chế vị trí
        task.wait(0.3)
        p.Character:PivotTo(oldCF)
    end
end)

-- 5. CHỨC NĂNG NOCLIP
local nc = false
local nB = nb("NOCLIP: OFF", 90, function()
    nc = not nc
    f.nb.Text = "NOCLIP: " .. (nc and "ON" or "OFF")
    f.nb.BackgroundColor3 = nc and Color3.fromRGB(0,120,0) or Color3.fromRGB(35,35,35)
end)
f.nb = nB
rs.Stepped:Connect(function()
    if nc and p.Character then
        for _, v in pairs(p.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)

-- 6. CHỨC NĂNG FLY (XNEO STYLE - MOBILE)
local flying = false
local fSpd = 1
local fBtn = nb("FLY: OFF", 130, function()
    flying = not flying
    fBtn.Text = "FLY: " .. (flying and "ON" or "OFF")
    fBtn.BackgroundColor3 = flying and Color3.fromRGB(0,120,0) or Color3.fromRGB(35,35,35)
    
    local h = p.Character:FindFirstChildWhichIsA("Humanoid")
    if flying then
        h.PlatformStand = true
        task.spawn(function()
            while flying and rs.Heartbeat:Wait() do
                if h.MoveDirection.Magnitude > 0 then
                    for i = 1, fSpd do
                        p.Character:TranslateBy(h.MoveDirection)
                    end
                end
            end
            h.PlatformStand = false
        end)
    end
end)

-- NÚT BAY LÊN/XUỐNG CHO ĐIỆN THOẠI
nb("BAY LÊN (^)", 170, function() p.Character:TranslateBy(Vector3.new(0,3,0)) end)
nb("BAY XUỐNG (v)", 210, function() p.Character:TranslateBy(Vector3.new(0,-3,0)) end)

-- ĐIỀU CHỈNH TỐC ĐỘ FLY
local sL = Instance.new("TextLabel", f)
sL.Size, sL.Position, sL.Text = UDim2.new(1,0,0,25), UDim2.new(0,0,0,255), "Speed Fly: 1", Color3.new(1,1,1)
sL.BackgroundTransparency = 1

nb("TĂNG TỐC (+)", 285, function() fSpd = fSpd + 1 sL.Text = "Speed Fly: "..fSpd end)
nb("GIẢM TỐC (-)", 325, function() fSpd = math.max(1, fSpd - 1) sL.Text = "Speed Fly: "..fSpd end)

-- NÚT GỠ HACK
local cl = nb("GỠ SCRIPT", 360, function() sg:Destroy() flying = false esp = false end)
cl.BackgroundColor3 = Color3.fromRGB(120,0,0)
