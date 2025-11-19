
-- 等待游戏加载
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer.Character

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

Player.CharacterAdded:Connect(function(char)
    Character = char
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)

-- 配置
_G.BondFarmEnabled = false
_G.BondCount = 0

-- 移除旧的GUI
if CoreGui:FindFirstChild("BondFarmGUI") then
    CoreGui:FindFirstChild("BondFarmGUI"):Destroy()
end

-- 创建GUI
local SG = Instance.new("ScreenGui", CoreGui)
SG.Name = "laws hub"
SG.ResetOnSpawn = false

-- 主框架
local MF = Instance.new("Frame", SG)
MF.Size = UDim2.new(0, 360, 0, 275)
MF.Position = UDim2.new(0.5, -180, 0.5, -137.5)
MF.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MF.BackgroundTransparency = 0.2
MF.BorderSizePixel = 0
MF.Active = true
MF.Draggable = true

Instance.new("UICorner", MF).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", MF)
stroke.Color = Color3.fromRGB(220, 220, 220)
stroke.Thickness = 0.5

-- 顶部栏
local TB = Instance.new("Frame", MF)
TB.Size = UDim2.new(1, 0, 0, 45)
TB.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TB.BackgroundTransparency = 0.3
TB.BorderSizePixel = 0

Instance.new("UICorner", TB).CornerRadius = UDim.new(0, 10)

-- 图标
local Logo = Instance.new("ImageLabel", TB)
Logo.Size = UDim2.new(0, 30, 0, 30)
Logo.Position = UDim2.new(0, 8, 0, 7.5)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://18374456807"
Logo.ScaleType = Enum.ScaleType.Fit

Instance.new("UICorner", Logo).CornerRadius = UDim.new(0.2, 0)

-- 标题
local Title = Instance.new("TextLabel", TB)
Title.Size = UDim2.new(0, 240, 1, 0)
Title.Position = UDim2.new(0, 45, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Atomic"
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.TextSize = 15
Title.Font = Enum.Font.SourceSans
Title.TextXAlignment = Enum.TextXAlignment.Left

-- 关闭按钮
local CB = Instance.new("TextButton", TB)
CB.Size = UDim2.new(0, 24, 0, 24)
CB.Position = UDim2.new(1, -30, 0, 10)
CB.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CB.BackgroundTransparency = 1
CB.Text = ""
CB.BorderSizePixel = 0

-- 关闭图标 - 使用两条线组成X
local CloseIcon1 = Instance.new("Frame", CB)
CloseIcon1.Size = UDim2.new(0, 14, 0, 1.5)
CloseIcon1.Position = UDim2.new(0.5, -7, 0.5, -0.75)
CloseIcon1.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
CloseIcon1.BorderSizePixel = 0
CloseIcon1.Rotation = 45
CloseIcon1.AnchorPoint = Vector2.new(0, 0)

local CloseIcon2 = Instance.new("Frame", CB)
CloseIcon2.Size = UDim2.new(0, 14, 0, 1.5)
CloseIcon2.Position = UDim2.new(0.5, -7, 0.5, -0.75)
CloseIcon2.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
CloseIcon2.BorderSizePixel = 0
CloseIcon2.Rotation = -45
CloseIcon2.AnchorPoint = Vector2.new(0, 0)

-- 悬停效果
CB.MouseEnter:Connect(function()
    CloseIcon1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CloseIcon2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
end)

CB.MouseLeave:Connect(function()
    CloseIcon1.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    CloseIcon2.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
end)

CB.MouseButton1Click:Connect(function()
    _G.BondFarmEnabled = false
    SG:Destroy()
end)

-- 计数器显示
local CF = Instance.new("Frame", MF)
CF.Size = UDim2.new(1, -20, 0, 70)
CF.Position = UDim2.new(0, 10, 0, 55)
CF.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CF.BackgroundTransparency = 0.3
CF.BorderSizePixel = 0

Instance.new("UICorner", CF).CornerRadius = UDim.new(0, 8)
local counterStroke = Instance.new("UIStroke", CF)
counterStroke.Color = Color3.fromRGB(220, 220, 220)
counterStroke.Thickness = 0.5

local CL = Instance.new("TextLabel", CF)
CL.Size = UDim2.new(1, 0, 0, 25)
CL.Position = UDim2.new(0, 0, 0, 8)
CL.BackgroundTransparency = 1
CL.Text = "已收集卷轴"
CL.TextColor3 = Color3.fromRGB(200, 200, 200)
CL.TextSize = 12
CL.Font = Enum.Font.SourceSans

local CV = Instance.new("TextLabel", CF)
CV.Size = UDim2.new(1, 0, 0, 30)
CV.Position = UDim2.new(0, 0, 0, 35)
CV.BackgroundTransparency = 1
CV.Text = "0"
CV.TextColor3 = Color3.fromRGB(240, 240, 240)
CV.TextSize = 36
CV.Font = Enum.Font.SourceSansLight

-- 状态
local ST = Instance.new("TextLabel", MF)
ST.Size = UDim2.new(1, -20, 0, 25)
ST.Position = UDim2.new(0, 10, 0, 135)
ST.BackgroundTransparency = 1
ST.Text = "状态: 空闲"
ST.TextColor3 = Color3.fromRGB(200, 200, 200)
ST.TextSize = 11
ST.Font = Enum.Font.SourceSans
ST.TextXAlignment = Enum.TextXAlignment.Left

-- 开始按钮
local SB = Instance.new("TextButton", MF)
SB.Size = UDim2.new(1, -20, 0, 40)
SB.Position = UDim2.new(0, 10, 0, 170)
SB.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
SB.BackgroundTransparency = 0.1
SB.Text = "开始"
SB.TextColor3 = Color3.fromRGB(0, 0, 0)
SB.TextSize = 13
SB.Font = Enum.Font.SourceSans
SB.BorderSizePixel = 0

Instance.new("UICorner", SB).CornerRadius = UDim.new(0, 8)

-- 停止按钮
local STB = Instance.new("TextButton", MF)
STB.Size = UDim2.new(1, -20, 0, 40)
STB.Position = UDim2.new(0, 10, 0, 220)
STB.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
STB.BackgroundTransparency = 0.3
STB.Text = "停止"
STB.TextColor3 = Color3.fromRGB(240, 240, 240)
STB.TextSize = 13
STB.Font = Enum.Font.SourceSans
STB.BorderSizePixel = 0

Instance.new("UICorner", STB).CornerRadius = UDim.new(0, 8)
local stopStroke = Instance.new("UIStroke", STB)
stopStroke.Color = Color3.fromRGB(220, 220, 220)
stopStroke.Thickness = 0.5

-- 角落追踪器
local TF = Instance.new("Frame", SG)
TF.Size = UDim2.new(0, 120, 0, 38)
TF.Position = UDim2.new(0, 10, 0, 60)
TF.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TF.BackgroundTransparency = 0.2
TF.BorderSizePixel = 0
TF.Active = true
TF.Draggable = true

Instance.new("UICorner", TF).CornerRadius = UDim.new(0, 8)
local trackerStroke = Instance.new("UIStroke", TF)
trackerStroke.Color = Color3.fromRGB(220, 220, 220)
trackerStroke.Thickness = 0.5

local TT = Instance.new("TextLabel", TF)
TT.Size = UDim2.new(1, 0, 1, 0)
TT.BackgroundTransparency = 1
TT.Text = "卷轴: 0"
TT.TextColor3 = Color3.fromRGB(240, 240, 240)
TT.TextSize = 13
TT.Font = Enum.Font.SourceSans

-- 更新函数
local function UpdateCount()
    CV.Text = tostring(_G.BondCount)
    TT.Text = "卷轴: " .. tostring(_G.BondCount)
end

-- 追踪卷轴
Workspace.RuntimeItems.ChildAdded:Connect(function(v)
    if v.Name:find("Bond") and v:FindFirstChild("Part") then
        v.Destroying:Connect(function()
            _G.BondCount += 1
            UpdateCount()
        end)
    end
end)

-- 状态函数
local function SetStatus(txt, clr)
    ST.Text = "状态: " .. txt
    ST.TextColor3 = clr or Color3.fromRGB(200, 200, 200)
end

-- 主刷卷轴函数（优化版 - 提速3倍）
local function Farm()
    _G.BondFarmEnabled = true
    SetStatus("启动中...", Color3.fromRGB(220, 220, 220))
    
    wait(0.3)  -- 优化：从1秒减少到0.3秒
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("EndDecision"):FireServer(false)
    
    if Player.Character:FindFirstChild("Humanoid") then
        Workspace.CurrentCamera.CameraSubject = Player.Character:FindFirstChild("Humanoid")
    end
    Player.CameraMode = "Classic"
    Player.CameraMaxZoomDistance = math.huge
    Player.CameraMinZoomDistance = 30
    
    HumanoidRootPart.Anchored = true
    wait(0.2)  -- 优化：从0.5秒减少到0.2秒
    
    SetStatus("传送中...", Color3.fromRGB(220, 220, 220))
    
    repeat 
        if not _G.BondFarmEnabled then return end
        HumanoidRootPart.Anchored = true
        wait(0.2)  -- 优化：从0.5秒减少到0.2秒
        HumanoidRootPart.CFrame = CFrame.new(80, 3, -9000)
        repeat task.wait() until Workspace.RuntimeItems:FindFirstChild("MaximGun") or not _G.BondFarmEnabled
        wait(0.1)  -- 优化：从0.3秒减少到0.1秒
        
        SetStatus("寻找机枪中...", Color3.fromRGB(220, 220, 220))
        
        for i, v in pairs(Workspace.RuntimeItems:GetChildren()) do
            if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") then
                v.VehicleSeat.Disabled = false
                v.VehicleSeat:SetAttribute("Disabled", false)
                v.VehicleSeat:Sit(Player.Character:FindFirstChild("Humanoid"))
            end
        end
        
        wait(0.2)  -- 优化：从0.5秒减少到0.2秒
        for i, v in pairs(Workspace.RuntimeItems:GetChildren()) do
            if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") and (HumanoidRootPart.Position - v.VehicleSeat.Position).Magnitude < 400 then
                HumanoidRootPart.CFrame = v.VehicleSeat.CFrame
            end
        end
        
        wait(0.3)  -- 优化：从1秒减少到0.3秒
        HumanoidRootPart.Anchored = false
    until Player.Character:FindFirstChild("Humanoid").Sit == true or not _G.BondFarmEnabled
    
    if not _G.BondFarmEnabled then return end
    
    wait(0.2)  -- 优化：从0.5秒减少到0.2秒
    Player.Character:FindFirstChild("Humanoid").Sit = false
    wait(0.2)  -- 优化：从0.5秒减少到0.2秒
    
    repeat task.wait()
        if not _G.BondFarmEnabled then return end
        for i, v in pairs(Workspace.RuntimeItems:GetChildren()) do
            if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") and (HumanoidRootPart.Position - v.VehicleSeat.Position).Magnitude < 400 then
                HumanoidRootPart.CFrame = v.VehicleSeat.CFrame
            end
        end
    until Player.Character:FindFirstChild("Humanoid").Sit == true or not _G.BondFarmEnabled
    
    if not _G.BondFarmEnabled then return end
    
    wait(0.3)  -- 优化：从0.9秒减少到0.3秒
    
    SetStatus("寻找火车中...", Color3.fromRGB(220, 220, 220))
    
    for i, v in pairs(Workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("RequiredComponents") then
            if v.RequiredComponents:FindFirstChild("Controls") and v.RequiredComponents.Controls:FindFirstChild("ConductorSeat") and v.RequiredComponents.Controls.ConductorSeat:FindFirstChild("VehicleSeat") then
                -- 优化：从25秒减少到8秒，使用Linear以获得最快速度
                local tp = TweenService:Create(HumanoidRootPart, TweenInfo.new(8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {CFrame = v.RequiredComponents.Controls.ConductorSeat:FindFirstChild("VehicleSeat").CFrame * CFrame.new(0, 20, 0)})
                tp:Play()
                
                if HumanoidRootPart:FindFirstChild("VelocityHandler") == nil then
                    local bv = Instance.new("BodyVelocity", HumanoidRootPart)
                    bv.Name = "VelocityHandler"
                    bv.MaxForce = Vector3.new(100000, 100000, 100000)
                    bv.Velocity = Vector3.new(0, 0, 0)
                end
                tp.Completed:Wait()
            end
        end
    end
    
    wait(0.3)  -- 优化：从1秒减少到0.3秒
    
    SetStatus("刷卷轴中！", Color3.fromRGB(240, 240, 240))
    
    while _G.BondFarmEnabled do
        if Player.Character:FindFirstChild("Humanoid").Sit == true then
            -- 优化：从17秒减少到6秒，使用Linear以获得最快速度
            local tp2 = TweenService:Create(HumanoidRootPart, TweenInfo.new(6, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {CFrame = CFrame.new(0.5, -78, -49429)})
            tp2:Play()
            
            if HumanoidRootPart:FindFirstChild("VelocityHandler") == nil then
                local bv = Instance.new("BodyVelocity", HumanoidRootPart)
                bv.Name = "VelocityHandler"
                bv.MaxForce = Vector3.new(100000, 100000, 100000)
                bv.Velocity = Vector3.new(0, 0, 0)
            end
            
            repeat task.wait() until Workspace.RuntimeItems:FindFirstChild("Bond") or not _G.BondFarmEnabled
            
            if not _G.BondFarmEnabled then break end
            
            tp2:Cancel()
            
            for i, v in pairs(Workspace.RuntimeItems:GetChildren()) do
                if not _G.BondFarmEnabled then break end
                if v.Name:find("Bond") and v:FindFirstChild("Part") then
                    repeat task.wait()
                        if not _G.BondFarmEnabled then break end
                        if v:FindFirstChild("Part") then
                            HumanoidRootPart.CFrame = v:FindFirstChild("Part").CFrame
                            ReplicatedStorage.Shared.Network.RemotePromise.Remotes.C_ActivateObject:FireServer(v)
                        end
                    until v:FindFirstChild("Part") == nil or not _G.BondFarmEnabled
                end
            end
        end
        task.wait()
    end
    
    SetStatus("已停止", Color3.fromRGB(180, 180, 180))
end

-- 按钮
SB.MouseButton1Click:Connect(function()
    if not _G.BondFarmEnabled then
        spawn(Farm)
    end
end)

STB.MouseButton1Click:Connect(function()
    _G.BondFarmEnabled = false
    SetStatus("已停止", Color3.fromRGB(180, 180, 180))
    if HumanoidRootPart:FindFirstChild("VelocityHandler") then
        HumanoidRootPart:FindFirstChild("VelocityHandler"):Destroy()
    end
end)

-- 防挂机
Player.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

