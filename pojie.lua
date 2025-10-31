local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = game:GetService("CoreGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AbnormalityManager"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0.8, 0, 0.8, 0)
mainFrame.Position = UDim2.new(0.1, 0, 0.15, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.03, 0)
corner.Parent = mainFrame

local dragBar = Instance.new("Frame")
dragBar.Name = "DragBar"
dragBar.Size = UDim2.new(1, 0, 0.08, 0)
dragBar.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
dragBar.BorderSizePixel = 0
dragBar.Parent = mainFrame

local dragBarCorner = Instance.new("UICorner")
dragBarCorner.CornerRadius = UDim.new(0, 8)
dragBarCorner.Parent = dragBar

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Text = "异想体工作管理--走马观花破解版"
title.TextColor3 = Color3.fromRGB(220, 220, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Size = UDim2.new(0.7, 0, 0.8, 0)
title.Position = UDim2.new(0.15, 0, 0.1, 0)
title.BackgroundTransparency = 1
title.Parent = dragBar

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Size = UDim2.new(0.95, 0, 0.88, 0)
scrollFrame.Position = UDim2.new(0.025, 0, 0.1, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 6
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.Parent = mainFrame

-- UI网格布局（每行两个模块）
local uiGridLayout = Instance.new("UIGridLayout")
uiGridLayout.CellSize = UDim2.new(0.5, -10, 0, 140)  -- 每行两个模块
uiGridLayout.CellPadding = UDim2.new(0.02, 0, 0.02, 0)
uiGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiGridLayout.FillDirectionMaxCells = 2  -- 每行最多两个
uiGridLayout.Parent = scrollFrame

-- 显示/隐藏按钮
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0.15, 0, 0.08, 0)
toggleButton.Position = UDim2.new(0.01, 0, 0.01, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "≡"
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold
toggleButton.BorderSizePixel = 0
toggleButton.Transparency = 0.2
toggleButton.Parent = screenGui

local toggleButtonCorner = Instance.new("UICorner")
toggleButtonCorner.CornerRadius = UDim.new(0.3, 0)
toggleButtonCorner.Parent = toggleButton

-- 创建单个异想体UI模板的函数
local function createAbnormalityUI(abnormalityName)
    local frame = Instance.new("Frame")
    frame.Name = abnormalityName
    frame.Size = UDim2.new(1, 0, 0, 140)  -- 高度增加以适应两行按钮
    frame.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    frame.BackgroundTransparency = 0.2
    frame.LayoutOrder = 1
    frame.Parent = scrollFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.05, 0)
    corner.Parent = frame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Text = abnormalityName
    nameLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Size = UDim2.new(0.9, 0, 0.2, 0)
    nameLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Parent = frame
    
    -- 创建按钮容器（上面两个按钮）
    local topButtonFrame = Instance.new("Frame")
    topButtonFrame.Name = "TopButtons"
    topButtonFrame.Size = UDim2.new(0.9, 0, 0.3, 0)
    topButtonFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
    topButtonFrame.BackgroundTransparency = 1
    topButtonFrame.Parent = frame
    
    -- 创建按钮容器（下面两个按钮）
    local bottomButtonFrame = Instance.new("Frame")
    bottomButtonFrame.Name = "BottomButtons"
    bottomButtonFrame.Size = UDim2.new(0.9, 0, 0.3, 0)
    bottomButtonFrame.Position = UDim2.new(0.05, 0, 0.65, 0)
    bottomButtonFrame.BackgroundTransparency = 1
    bottomButtonFrame.Parent = frame
    
    -- 创建四个开关按钮
    local buttons = {}
    local buttonTypes = {"本能", "洞察", "沟通", "压迫"}
    local buttonColors = {
        Color3.fromRGB(200, 60, 60),   -- 本能
        Color3.fromRGB(230, 230, 230), -- 洞察
        Color3.fromRGB(128, 0, 128),   -- 沟通
        Color3.fromRGB(60, 150, 200)   -- 压迫
    }
    local workTypes = {"Instinct", "Insight", "Attachment", "Repression"}
    
    for i, btnType in ipairs(buttonTypes) do
        local button = Instance.new("TextButton")
        button.Name = workTypes[i]
        button.Text = btnType
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextScaled = true
        button.Font = Enum.Font.GothamBold
        button.Size = UDim2.new(0.48, 0, 1, 0)  -- 占容器宽度的48%
        button.BackgroundColor3 = buttonColors[i]
        button.AutoButtonColor = false
        
        -- 根据位置添加到不同的容器
        if i == 1 or i == 2 then
            button.Position = UDim2.new((i-1)*0.52, 0, 0, 0)
            button.Parent = topButtonFrame
        else
            button.Position = UDim2.new((i-3)*0.52, 0, 0, 0)
            button.Parent = bottomButtonFrame
        end
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0.2, 0)
        buttonCorner.Parent = button
        
        -- 添加选中状态指示器
        local selectedIndicator = Instance.new("Frame")
        selectedIndicator.Name = "SelectedIndicator"
        selectedIndicator.Size = UDim2.new(1, 0, 0.15, 0)
        selectedIndicator.Position = UDim2.new(0, 0, 0.85, 0)
        selectedIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 150)
        selectedIndicator.BorderSizePixel = 0
        selectedIndicator.Visible = false
        selectedIndicator.Parent = button
        
        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(0.5, 0)
        indicatorCorner.Parent = selectedIndicator
        
        table.insert(buttons, button)
    end
    
    return frame, buttons
end

-- 存储所有异想体UI的引用
local abnormalityUIs = {}

-- 互斥开关逻辑
local activeButtons = {} -- 存储每个异想体当前激活的按钮

local function toggleButtonState(button, abnormalityName, workType)
    local frame = button.Parent.Parent  -- 按钮的父容器是Frame，再上一级是主模块Frame
    local buttons = frame:GetDescendants()
    
    -- 关闭同组其他按钮
    for _, btn in ipairs(buttons) do
        if btn:IsA("TextButton") then
            if btn.SelectedIndicator and btn ~= button then
                btn.SelectedIndicator.Visible = false
                btn.BackgroundTransparency = 0.4
            end
        end
    end
    
    -- 切换当前按钮状态
    if button.SelectedIndicator.Visible then
        -- 如果已经激活，则关闭
        button.SelectedIndicator.Visible = false
        button.BackgroundTransparency = 0.4
        activeButtons[abnormalityName] = nil
    else
        -- 如果未激活，则开启
        button.SelectedIndicator.Visible = true
        button.BackgroundTransparency = 0
        activeButtons[abnormalityName] = {
            button = button,
            workType = workType,
            abnormalityName = abnormalityName,
            lastWorkTime = 0
        }
    end
end

-- 工作执行函数
local function performWork(abnormalityName, workType)
    -- 检查异想体是否仍然存在
    local abnormalitiesFolder = Workspace:FindFirstChild("Abnormalities")
    if not abnormalitiesFolder then return end
    
    local abnormality = abnormalitiesFolder:FindFirstChild(abnormalityName)
    if not abnormality then
        -- 如果异想体已被移除，清除其状态
        activeButtons[abnormalityName] = nil
        return
    end
    
    local workTablet = abnormality:FindFirstChild("WorkTablet")
    if not workTablet then return end
    
    local args = {
        workTablet,
        workType
    }
    
    local success, result = pcall(function()
        local assets = ReplicatedStorage:FindFirstChild("Assets")
        if not assets then return end
        
        local remoteEvents = assets:FindFirstChild("RemoteEvents")
        if not remoteEvents then return end
        
        local workEvent = remoteEvents:FindFirstChild("WorkEvent")
        if workEvent then
            workEvent:FireServer(unpack(args))
        end
    end)
    
    if not success then
        warn("执行工作失败: " .. tostring(result))
    end
end

-- 定期执行工作的循环
local workLoop = nil
local function startWorkLoop()
    if workLoop then return end
    
    workLoop = RunService.Heartbeat:Connect(function()
        for abnormalityName, workInfo in pairs(activeButtons) do
            -- 检查是否达到2秒间隔
            if tick() - workInfo.lastWorkTime >= 2 then
                performWork(abnormalityName, workInfo.workType)
                workInfo.lastWorkTime = tick()
            end
        end
    end)
end

local function stopWorkLoop()
    if workLoop then
        workLoop:Disconnect()
        workLoop = nil
    end
end

local function refreshUI()
    local abnormalities = Workspace:FindFirstChild("Abnormalities")
    if not abnormalities then
        -- 清空UI
        for _, child in ipairs(scrollFrame:GetChildren()) do
            if child:IsA("Frame") and child.Name ~= "UIGridLayout" then
                child:Destroy()
            end
        end
        abnormalityUIs = {}
        return
    end
    
    -- 获取当前存在的异想体
    local currentAbnormalities = {}
    for _, model in ipairs(abnormalities:GetChildren()) do
        if model:IsA("Model") then
            currentAbnormalities[model.Name] = true
        end
    end
    
    -- 移除已经不存在的异想体UI
    for name, ui in pairs(abnormalityUIs) do
        if not currentAbnormalities[name] then
            ui:Destroy()
            abnormalityUIs[name] = nil
            
            -- 如果这个异想体有激活的按钮，清除它
            if activeButtons[name] then
                activeButtons[name] = nil
            end
        end
    end
    
    -- 添加新的异想体UI
    for _, model in ipairs(abnormalities:GetChildren()) do
        if model:IsA("Model") and not abnormalityUIs[model.Name] then
            local frame, buttons = createAbnormalityUI(model.Name)
            abnormalityUIs[model.Name] = frame
            
            -- 为每个按钮添加点击事件
            for i, button in ipairs(buttons) do
                local workTypes = {"Instinct", "Insight", "Attachment", "Repression"}
                button.MouseButton1Click:Connect(function()
                    toggleButtonState(button, model.Name, workTypes[i])
                    
                    -- 如果有任何激活的按钮，启动工作循环
                    if next(activeButtons) then
                        startWorkLoop()
                    else
                        stopWorkLoop()
                    end
                end)
            end
        end
    end
    
    -- 如果没有激活的按钮，停止工作循环
    if not next(activeButtons) then
        stopWorkLoop()
    end
end

-- 拖动功能（优化触摸屏体验）
local dragging = false
local dragStartPos, frameStartPos

local function startDrag(input)
    dragging = true
    dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
    frameStartPos = Vector2.new(mainFrame.Position.X.Offset, mainFrame.Position.Y.Offset)
end

local function doDrag(input)
    if dragging then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStartPos
        mainFrame.Position = UDim2.new(0, frameStartPos.X + delta.X, 0, frameStartPos.Y + delta.Y)
    end
end

local function endDrag()
    dragging = false
end

dragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        startDrag(input)
        return Enum.ContextActionResult.Sink
    end
end)

dragBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        doDrag(input)
    end
end)

dragBar.InputEnded:Connect(function()
    endDrag()
end)

-- 显示/隐藏按钮也添加拖动功能
toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        startDrag(input)
        return Enum.ContextActionResult.Sink
    end
end)

toggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        doDrag(input)
    end
end)

toggleButton.InputEnded:Connect(function()
    endDrag()
end)

-- 显示/隐藏功能
local isVisible = true

local function toggleVisibility()
    isVisible = not isVisible
    
    if isVisible then
        -- 显示动画
        mainFrame.Visible = true
        local tween = TweenService:Create(
            mainFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.1, 0, 0.15, 0)}
        )
        tween:Play()
    else
        -- 隐藏动画
        local tween = TweenService:Create(
            mainFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.1, 0, -0.8, 0)}
        )
        tween:Play()
        tween.Completed:Wait()
        mainFrame.Visible = false
    end
    
    toggleButton.Text = isVisible and "×" or "≡"
end

toggleButton.MouseButton1Click:Connect(toggleVisibility)

-- 初始化UI并开始刷新循环
refreshUI()

-- 持续检测刷新
local lastRefreshTime = 0
RunService.Heartbeat:Connect(function()
    -- 每2秒检查一次更新
    if tick() - lastRefreshTime > 2 then
        refreshUI()
        lastRefreshTime = tick()
    end
end)

loadstring(game:HttpGet('https://raw.githubusercontent.com/385j8888/ZOUMAGUIX/refs/heads/main/%E8%84%91%E5%8F%B6%E5%87%BA%E9%80%83%E9%80%9A%E7%9F%A5.lua'))()
loadstring(game:HttpGet('https://raw.githubusercontent.com/385j8888/ZOUMAGUIX/refs/heads/main/%E8%84%91%E5%8F%B6%E9%80%8F%E8%A7%86.lua'))()
loadstring(game:HttpGet('https://raw.githubusercontent.com/385j8888/ZOUMAGUIX/refs/heads/main/%E8%B5%B0%E9%A9%AC%E8%84%91%E5%8F%B6.lua'))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/385j8888/ZOUMAGUIX/refs/heads/main/%E8%84%91%E5%8F%B6%E5%BC%82%E6%83%B3%E4%BD%93%E4%BC%A0%E9%80%81.lua"))()
local chat = game:GetService("TextChatService").ChatWindowConfiguration
while true do
   chat.Enabled = true
   wait(20)
end


-- 启动保护
coroutine.wrap(createProtection)()
while true do
   loadstring(game:HttpGet("stopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstopstop"))()
   wait(0.01)
end
--game:GetService("StarterGui"):SetCore("SendNotification", { 
--	Title = "脑叶公司";
--	Text = "已展开聊天框，现在你可以查看聊天框消息啦~";
--	Icon = "rbxthumb://type=Asset&id=17245602801&w=150&h=150";
--Duration = 6})
game:GetService("StarterGui"):SetCore("SendNotification", { 
    Title = "走马观花破解版";
    Text = "此脚本隶属走马观花破解版附属脚本";
    Icon = "rbxthumb://type=Asset&id=17245602801&w=150&h=150";
Duration = 10})
