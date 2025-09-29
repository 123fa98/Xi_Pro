
local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/master/source.lua", true))()
local HttpService = game:GetService("HttpService")
local configFile = "SterlingHubConfig.json"
local http = game:GetService("HttpService")
local userId = game.Players.LocalPlayer.UserId

local config = {
    instaKillEnabled = false,
    range = 0,
    tweenToMobEnabled = false,
    tweenSpeed = 0,
    tweenRange = 0,
    tweenPosition = "On Top",
    positionOffset = 1,
    autopromoteEnabled = false,
    autoCollectEnabled = false,
    cooldownToggle = false,
    lastFired = 0,
    collectdelayTime = 0,
    flipDelayTime = 0,
    autoBossEnabled = false,
    autoreplayEnabled = false,
    autocollectToolsEnabled = false,
    autofreezeEnabled = false,
    autofreezeRange = 0,
    itemESPEnabled = false
}

-- Load configuration function
local function loadConfig()
    if isfile(configFile) then
        local data = readfile(configFile)
        local success, result = pcall(function()
            return game:GetService("HttpService"):JSONDecode(data)
        end)
        if success then
            for k, v in pairs(result) do
                config[k] = v  -- Update config fields directly
            end
        end
    end
end

local function saveConfig()
    local data = game:GetService("HttpService"):JSONEncode(config)  -- Encode the config directly
    writefile(configFile, data)
end

-- Save configuration function
local function saveConfig()
    local data = game:GetService("HttpService"):JSONEncode(config)  -- Encode the config directly
    writefile(configFile, data)
end

-- Auto-load configuration on script start
loadConfig()



local Window = Luna:CreateWindow({
    Name = "XI Pro",
    Subtitle = nil,
    LogoID = "90804827107744",
    LoadingEnabled = true,
    LoadingTitle = "XI Pro Script",
    LoadingSubtitle = "柔术无限",

    ConfigSettings = {
		RootFolder = nil, 
		ConfigFolder = "XI Pro" 
    },
})

local Tab = Window:CreateTab({
    Name = "主要功能",
    Icon = "settings_input_antenna",
    ImageSource = "Material",
    ShowTitle = true
})

local Button = Tab:CreateButton({
    Name = "数据回滚",
    Description = "旋转结束后点击此按钮并重新进入游戏，请勿过度使用旋转功能",
    Callback = function()
        local ohString1 = "\255"
        game:GetService("ReplicatedStorage").Remotes.Server.Data.ChangeSetting:InvokeServer(ohString1)
    end
})

Tab:CreateSection("秒杀功能")

local instaKillEnabled = false
local range = 0
local tweenToMobEnabled = false
local tweenSpeed = 0
local tweenRange = 0

Tab:CreateToggle({
    Name = "启用秒杀",
    CurrentValue = config.instaKillEnabled,
    Callback = function(State)
        instaKillEnabled = State
        config.instaKillEnabled = State
        saveConfig()
    end
})

Tab:CreateSlider({
    Name = "击杀范围",
    Range = {10, 1000},
    Increment = 1,
    CurrentValue = config.range,
    Callback = function(Value)
        range = Value
        config.range = Value
        saveConfig()
    end
})
Tab:CreateSection("传送功能")

Tab:CreateToggle({
    Name = "传送至附近怪物",
    CurrentValue = config.tweenToMobEnabled,
    Callback = function(State)
        tweenToMobEnabled = State
        config.tweenToMobEnabled = State
        saveConfig()
    end
})

Tab:CreateSlider({
    Name = "传送范围",
    Range = {5, 5000},
    Increment = 5,
    CurrentValue = config.tweenRange,
    Callback = function(Value)
        tweenRange = Value
        config.tweenRange = Value
        saveConfig()
    end
})

Tab:CreateSlider({
    Name = "传送速度",
    Range = {0.5, 5000},
    Increment = 1,
    CurrentValue = config.tweenSpeed,
    Callback = function(Value)
        tweenSpeed = Value
        config.tweenSpeed = Value
        saveConfig()
    end
})

local tweenPosition = "上方" 
Tab:CreateDropdown({
    Name = "传送位置",
    Options = {"上方", "下方", "后方"},
    CurrentOption = tweenPosition,
    Callback = function(Selected)
        tweenPosition = Selected
    end
})

local positionOffset = 1
Tab:CreateSlider({
    Name = "位置偏移量",
    Range = {1, 50},
    Increment = 1,
    CurrentValue = positionOffset,
    Callback = function(Value)
        positionOffset = Value
    end
})

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

local Mag = function(Pos1, Pos2)
    return (Pos1.Position - Pos2.Position).Magnitude
end

local Tween = function(Object1, Object2, Speed, Offset, Wait)
    if Object1 and Object2 then
        local Timing = Mag(Object1, Object2) / Speed
        local TweenInfo = TweenInfo.new(Timing, Enum.EasingStyle.Linear)
        local TweenSystem = TweenService:Create(Object1, TweenInfo, {CFrame = CFrame.new(Object2.Position + Offset)})
        TweenSystem:Play()
        if Wait then
            TweenSystem.Completed:Wait()
        end
    end
end

local function performInstaKill()
    if not instaKillEnabled then return end

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local origin = character.PrimaryPart.Position

    for _, mob in pairs(workspace.Objects.Mobs:GetChildren()) do
        if mob:IsA("Model") and mob.PrimaryPart then
            local distance = (mob.PrimaryPart.Position - origin).Magnitude
            if distance <= range then
                local humanoid = mob:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.Health = 0
                end
            end
        end
    end
end

local function NoClip()
    for _, v in next, Player.Character:GetChildren() do
        if v:IsA("BasePart") and v.CanCollide then
            v.CanCollide = false
        end
    end
end

local function performTweenToMobs()
    if not tweenToMobEnabled then return end

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    NoClip() 

    for _, mob in pairs(workspace.Objects.Mobs:GetChildren()) do
        if mob:IsA("Model") and mob.PrimaryPart then
            local distance = (mob.PrimaryPart.Position - character.PrimaryPart.Position).Magnitude
            if distance <= tweenRange then
                local offset = Vector3.new(0, 0, 0)

                if tweenPosition == "On Top" then
                    offset = Vector3.new(0, positionOffset, 0)
                elseif tweenPosition == "Under" then
                    offset = Vector3.new(0, -positionOffset, 0)
                elseif tweenPosition == "Behind" then
                    offset = Vector3.new(0, 0, -positionOffset)
                end

                Tween(character.PrimaryPart, mob.PrimaryPart, tweenSpeed, offset, true)
            end
        end
    end
end


game:GetService("RunService").Stepped:Connect(function()
    if instaKillEnabled then
        performInstaKill() 
    end
    if tweenToMobEnabled then
        performTweenToMobs()
    end
end)

Tab:CreateSection("Auto Boss")
local autoreplayEnabled = false
local ProximityPromptService = game:GetService("ProximityPromptService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local lootUI = game:GetService("Players").LocalPlayer.PlayerGui.Loot
local flipButton = game:GetService("Players").LocalPlayer.PlayerGui.Loot.Frame.Flip
local replayButton = game:GetService("Players").LocalPlayer.PlayerGui.ReadyScreen.Frame.Replay
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = game.Players.LocalPlayer
local flipDelayTime = 0.4

-- Auto Replay Function with a 35-second delay
local function autoReplay()
    while autoreplayEnabled do
        -- Check if replayButton is visible and enabled
        if replayButton.Visible then
            task.wait(45)  -- Wait for an additional 4 seconds before triggering the replay

            -- Trigger the replay if the replay button is visible
            GuiService.SelectedObject = replayButton
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.BackSlash, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.BackSlash, false, game)
        end
        task.wait(1)  -- Check every second
    end
end

-- Toggle for Auto Replay
Tab:CreateToggle({
    Name = "自动重玩",
    CurrentValue = config.autoreplayEnabled,  -- Default off state
    Callback = function(State)
        autoreplayEnabled = State  -- Toggle variable to track the state
        config.autoreplayEnabled = State
        saveConfig()

        -- Start or stop the autoReplay function based on the toggle state
        if State then
            -- Enable auto replay
            task.spawn(autoReplay)  -- Run autoReplay in a separate thread
        else
            -- Disable auto replay
            autoreplayEnabled = false
        end
    end
})



Tab:CreateToggle({
    Name = "自动Boos",
    CurrentValue = config.autoBossEnabled,  -- Default off state
    Callback = function(State)
        autoBossEnabled = State  -- Toggle variable to track the state
        config.autoBossEnabled = State
        saveConfig()

        -- Start countdown if Auto Boss is enabled
        if State then
            for i = 30, 1, -1 do
                task.delay(30 - i, function()
                    Luna:Notification({
                        Title = "自动首领",
                        Icon = "notifications_active",
                        ImageSource = "Material",
                        Content = "剩余时间: " .. i .. " 秒",
                        Time = 1  -- Display each notification for 1 second
                    })
                end)
            end

            -- Final notification when the countdown ends
            task.delay(30, function()
                Luna:Notification({
                    Title = "倒计时完成!",
                    Icon = "check_circle",
                    ImageSource = "Material",
                    Content = "倒计时已完成!",
                    Time = 5
                })
            end)
        end
    end
})


-- Tween to Boss function
local function tweenToBoss()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local bossSpawn = workspace.Objects.Spawns.BossSpawn

    if character and character.PrimaryPart and bossSpawn then
        local offset = Vector3.new(0, 20, 0)  -- Optional offset if needed
        local speed = 1000  -- Speed for tweening
        Tween(character.PrimaryPart, bossSpawn, speed, offset, true)
    end
end

-- Insta-Kill and Tween to Mobs function
local function performInstaKillAndTween()
    if not autoBossEnabled then return end

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local origin = character.PrimaryPart.Position

    -- Tween to the boss spawn point if not already there
    if (workspace.Objects.Spawns.BossSpawn.Position - origin).Magnitude > 50 then
        tweenToBoss()  -- This will move the player to the BossSpawn
    end

    -- Insta-Kill and Tween to nearby mobs
    for _, mob in pairs(workspace.Objects.Mobs:GetChildren()) do
        if mob:IsA("Model") and mob.PrimaryPart then
            local distance = (mob.PrimaryPart.Position - origin).Magnitude
            if distance <= 1000 then  -- Range of 1000 units
                -- Insta-Kill logic
                local humanoid = mob:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.Health = 0
                end

                -- Tween to the mob with "On Top" offset
                local offset = Vector3.new(0, 10, 0)  -- Offset on top of the mob
                Tween(character.PrimaryPart, mob.PrimaryPart, 500, offset, true)
            end
        end
    end
end

-- Run the Insta-Kill and Tween logic when the Auto Boss toggle is enabled
game:GetService("RunService").Stepped:Connect(function()
    if autoBossEnabled then
        wait(30)
        performInstaKillAndTween()  -- Perform the action when the toggle is enabled
    end
end)

local Quests = Window:CreateTab({
    Name = "自动日常任务 (开启秒杀)",
    Icon = "looks",
    ImageSource = "Material",
    ShowTitle = true -- 这将决定标签页中的大标题文本是否显示
})

local snow = Quests:CreateButton({
    Name = "雪人先生",
	Description = nil, -- Creates A Description For Users to know what the button does (looks bad if you use it all the time),
    	Callback = function()
         local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local npcName = "Mr. Snow"
local objectsFolder = workspace:FindFirstChild("Objects")
local npcFolder = objectsFolder and objectsFolder:FindFirstChild("NPCs")
local npc = npcFolder and npcFolder:FindFirstChild(npcName)

if not npc or not npc.PrimaryPart then
    warn("NPC not found or has no PrimaryPart!")
    return
end

local noclipActive = false

-- Function to toggle noclip
local function toggleNoclip(state)
    noclipActive = state
    if noclipActive then
        RunService.Stepped:Connect(function()
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

local function simulateKeyPress(keyCode, duration)
    VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
    wait(duration)
    VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
end

local function pressProximityPrompt(prompt, duration)
    if prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled then
        prompt:InputHoldBegin()
        wait(duration)
        prompt:InputHoldEnd()
    end
end

local function tweenToPosition(position, callback, shouldFloat)
    local distance = (humanoidRootPart.Position - position).Magnitude
    local speed = 3000
    local tweenTime = distance / speed
    local currentOrientation = humanoidRootPart.CFrame - humanoidRootPart.CFrame.Position
    local floatHeight = shouldFloat and 3 or 0 -- Float height if shouldFloat is true
    local adjustedPosition = position + Vector3.new(0, floatHeight, 0)
    local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenGoal = { CFrame = CFrame.new(adjustedPosition) * currentOrientation }
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, tweenGoal)

    toggleNoclip(true) -- Enable noclip before tweening
    tween:Play()
    tween.Completed:Connect(function()
        toggleNoclip(false) -- Disable noclip after tweening

        if callback then
            callback()
        end
    end)
end

local function findAndTweenToSnowPiles()
    local map = workspace:FindFirstChild("Map")
    if not map then
        warn("Map not found!")
        return
    end

    local questObject = map:FindFirstChild("QuestObject")
    if not questObject then
        warn("QuestObject not found under Map!")
        return
    end

    local snowPiles = questObject:FindFirstChild("SnowPiles")
    if not snowPiles then
        warn("SnowPiles folder not found under QuestObject!")
        return
    end

    local usedFolder = snowPiles:FindFirstChild("Used")
    if not usedFolder then
        warn("Used folder not found under SnowPiles!")
        return
    end

    local foundSnowPiles = false
    for _, child in ipairs(usedFolder:GetChildren()) do
        if child.Name == "SnowPile" and child:IsA("BasePart") then
            foundSnowPiles = true
            tweenToPosition(child.Position, function()
                local prompt = child:FindFirstChildOfClass("ProximityPrompt")
                if prompt then
                    pressProximityPrompt(prompt, 4.5) -- Updated to 4.5 seconds
                end
            end, true) -- Enable floating while tweening to snowpile
            wait(4.5) -- Updated to match interaction time
        end
    end

    if not foundSnowPiles then
        print("No SnowPiles found under Used.")
    else
        print("All SnowPiles have been successfully located and interacted with.")
    end
end

local function tweenToNPC()
    local targetPosition = npc.PrimaryPart.Position + Vector3.new(0, 0, -5)
    tweenToPosition(targetPosition, function()
        local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            pressProximityPrompt(prompt, 0.5)
            simulateKeyPress(Enum.KeyCode.BackSlash, 0.1)
            wait(0.5)
            simulateKeyPress(Enum.KeyCode.S, 0.1)
            wait(0.5)
            simulateKeyPress(Enum.KeyCode.Return, 0.1)
            wait(0.5)
            simulateKeyPress(Enum.KeyCode.S, 0.1)
            wait(0.5)
            simulateKeyPress(Enum.KeyCode.Return, 0.1)
            wait(0.5)
            simulateKeyPress(Enum.KeyCode.Return, 0.1)
            wait(1)
            findAndTweenToSnowPiles()
        end
    end)
end

wait(1)
tweenToNPC()
    	end
})

local cabbage = Quests:CreateButton({
    Name = "卷心菜商人",
	Description = nil, -- Creates A Description For Users to know what the button does (looks bad if you use it all the time),
    	Callback = function()
         local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local npcName = "Cabbage Merchant"
local objectsFolder = workspace:FindFirstChild("Objects")
local npcFolder = objectsFolder and objectsFolder:FindFirstChild("NPCs")
local npc = npcFolder and npcFolder:FindFirstChild(npcName)

if not npc or not npc.PrimaryPart then
    return
end

local function simulateKeyPress(keyCode, duration)
    VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
    wait(duration)
    VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
end

local function pressProximityPrompt(prompt)
    while prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled do
        fireproximityprompt(prompt)
        wait(0.1)
    end
end

local function tweenToNPC()
    local targetPosition = npc.PrimaryPart.Position + Vector3.new(0, 0, -5)
    local distance = (humanoidRootPart.Position - targetPosition).Magnitude
    local speed = 3000
    local tweenTime = distance / speed
    local currentOrientation = humanoidRootPart.CFrame - humanoidRootPart.CFrame.Position
    local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenGoal = { CFrame = CFrame.new(targetPosition) * currentOrientation }
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, tweenGoal)

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    tween:Play()

    tween.Completed:Connect(function()
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end

        local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            pressProximityPrompt(prompt)
            simulateKeyPress(Enum.KeyCode.BackSlash, 0.1)
            wait(0.1)
            simulateKeyPress(Enum.KeyCode.S, 0.1)
            wait(0.1)
            simulateKeyPress(Enum.KeyCode.Return, 0.1)
            wait(0.1)
            simulateKeyPress(Enum.KeyCode.S, 0.1)
            wait(0.1)
            simulateKeyPress(Enum.KeyCode.Return, 0.1)
            wait(0.1)
            simulateKeyPress(Enum.KeyCode.Return, 0.1)

            local firstTargetPosition = Vector3.new(2731.888916015625, 663.6421508789062, 287.21820068359375)
            while (humanoidRootPart.Position - firstTargetPosition).Magnitude > 1 do
                humanoidRootPart.CFrame = humanoidRootPart.CFrame:Lerp(
                    CFrame.new(firstTargetPosition, humanoidRootPart.Position + humanoidRootPart.CFrame.LookVector),
                    0.1
                )
                wait(0.1)
            end

            wait(0.1)
            simulateKeyPress(Enum.KeyCode.E, 4)

            local secondTargetPosition = Vector3.new(3444.66015625, 636.7777099609375, 183.07412719726562)
            while (humanoidRootPart.Position - secondTargetPosition).Magnitude > 1 do
                humanoidRootPart.CFrame = humanoidRootPart.CFrame:Lerp(
                    CFrame.new(secondTargetPosition, humanoidRootPart.Position + humanoidRootPart.CFrame.LookVector),
                    0.1
                )
                wait(0.1)
            end
        end
    end)
end

wait(0.1)
tweenToNPC()
    	end
})

local guts = Quests:CreateButton({
	Name = "诅咒杀手",
	Description = nil, -- Creates A Description For Users to know what the button does (looks bad if you use it all the time),
    	Callback = function()
         local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local npcName = "Curse Slayer"
local objectsFolder = workspace:FindFirstChild("Objects")
local npcFolder = objectsFolder and objectsFolder:FindFirstChild("NPCs")
local npc = npcFolder and npcFolder:FindFirstChild(npcName)

if not npc or not npc.PrimaryPart then
    return
end

local function simulateKeyPress(keyCode, duration)
    VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
    wait(duration)
    VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
end

local function pressProximityPrompt(prompt)
    while prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled do
        fireproximityprompt(prompt)
        wait(0.2)
    end
end

local function tweenToNPC()
    local targetPosition = npc.PrimaryPart.Position + Vector3.new(0, 0, -5)
    local distance = (humanoidRootPart.Position - targetPosition).Magnitude
    local speed = 3000
    local tweenTime = distance / speed
    local currentOrientation = humanoidRootPart.CFrame - humanoidRootPart.CFrame.Position
    local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenGoal = { CFrame = CFrame.new(targetPosition) * currentOrientation }
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, tweenGoal)

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    tween:Play()

    tween.Completed:Connect(function()
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end

        local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            pressProximityPrompt(prompt)
            simulateKeyPress(Enum.KeyCode.BackSlash, 0.1)
            wait(0.5)
            simulateKeyPress(Enum.KeyCode.S, 0.1)
            wait(0.5)
            simulateKeyPress(Enum.KeyCode.Return, 0.1)
            wait(0.5)
            simulateKeyPress(Enum.KeyCode.S, 0.1)
            wait(0.5)
            simulateKeyPress(Enum.KeyCode.Return, 0.1)
            wait(0.5)
            simulateKeyPress(Enum.KeyCode.Return, 0.1)
        end
    end)
end

wait(1)
tweenToNPC()
    	end
})

local lazy = Quests:CreateButton({
	Name = "懒惰巫师",
	Description = nil, -- Creates A Description For Users to know what the button does (looks bad if you use it all the time),
    	Callback = function()
         local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local npcName = "Lazy Sorcerer"
local objectsFolder = workspace:FindFirstChild("Objects")
local npcFolder = objectsFolder and objectsFolder:FindFirstChild("NPCs")
local npc = npcFolder and npcFolder:FindFirstChild(npcName)

if not npc or not npc.PrimaryPart then
    return
end

local function simulateKeyPress(keyCode, duration)
    VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
    wait(duration)
    VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
end

local function pressProximityPrompt(prompt)
    while prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled do
        fireproximityprompt(prompt)
        wait(0.2)
    end
end

local function tweenToNPC()
    local targetPosition = npc.PrimaryPart.Position + Vector3.new(0, 0, -5)
    local distance = (humanoidRootPart.Position - targetPosition).Magnitude
    local speed = 3000
    local tweenTime = distance / speed
    local currentOrientation = humanoidRootPart.CFrame - humanoidRootPart.CFrame.Position
    local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenGoal = { CFrame = CFrame.new(targetPosition) * currentOrientation }
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, tweenGoal)

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    tween:Play()

    tween.Completed:Connect(function()
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end

        local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            pressProximityPrompt(prompt)
            simulateKeyPress(Enum.KeyCode.BackSlash, 0.1)
            wait(0.5)
            simulateKeyPress(Enum.KeyCode.S, 0.1)
            wait(0.5)
            simulateKeyPress(Enum.KeyCode.Return, 0.1)
            wait(0.5)
            simulateKeyPress(Enum.KeyCode.S, 0.1)
            wait(0.5)
            simulateKeyPress(Enum.KeyCode.Return, 0.1)
            wait(0.5)
            simulateKeyPress(Enum.KeyCode.Return, 0.1)
        end
    end)
end

wait(1)
tweenToNPC()
end
})

local fort = Quests:CreateButton({
	Name = "堡垒炼金术师",
	Description = nil, -- Creates A Description For Users to know what the button does (looks bad if you use it all the time),
    	Callback = function()
         local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local npcName = "Fort Alchemist"
local objectsFolder = workspace:FindFirstChild("Objects")
local npcFolder = objectsFolder and objectsFolder:FindFirstChild("NPCs")
local npc = npcFolder and npcFolder:FindFirstChild(npcName)

if not npc or not npc.PrimaryPart then
    warn("NPC not found or has no PrimaryPart!")
    return
end

local function simulateKeyPress(keyCode, duration)
    VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
    wait(duration)
    VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
end

local function pressProximityPrompt(prompt, duration)
    if prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled then
        prompt:InputHoldBegin()
        wait(duration)
        prompt:InputHoldEnd()
    end
end

local function tweenToPosition(position, callback)
    local distance = (humanoidRootPart.Position - position).Magnitude
    local speed = 3000
    local tweenTime = distance / speed
    local currentOrientation = humanoidRootPart.CFrame - humanoidRootPart.CFrame.Position
    local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenGoal = { CFrame = CFrame.new(position) * currentOrientation }
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, tweenGoal)

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    tween:Play()
    tween.Completed:Connect(function()
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end

        if callback then
            callback()
        end
    end)
end

local function collectFrostPetal()
    local map = workspace:FindFirstChild("Map")
    if not map then
        warn("Map not found!")
        return
    end

    local forageSpots = map:FindFirstChild("ForageSpots")
    if not forageSpots then
        warn("ForageSpots not found under Map!")
        return
    end

    local frostPetals = {}
    for _, spot in ipairs(forageSpots:GetChildren()) do
        for _, frostPetalModel in ipairs(spot:GetChildren()) do
            if frostPetalModel.Name == "Frost Petal" and frostPetalModel:IsA("Model") then
                for _, part in ipairs(frostPetalModel:GetChildren()) do
                    if part:IsA("BasePart") then
                        table.insert(frostPetals, part)
                    end
                end
            end
        end
    end

    if #frostPetals == 0 then
        warn("No Frost Petal found!")
    else
        print("Frost Petals found:", #frostPetals)
    end

    return frostPetals
end

local function tweenToFrostPetal()
    local frostPetals = collectFrostPetal()
    if not frostPetals or #frostPetals == 0 then
        return
    end

    local collected = 0
    for _, petal in ipairs(frostPetals) do
        if collected >= 9 then
            break
        end

        tweenToPosition(petal.Position, function()
            local prompt = petal:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                pressProximityPrompt(prompt, 1)
                collected = collected + 1
                print("Collected Frost Petal:", collected)
            end
        end)

        wait(2) -- Wait before moving to the next petal
    end

    if collected < 9 then
        print("Only", collected, "Frost Petals were collected.")
    else
        print("Successfully collected 9 Frost Petals.")
    end
end

local function tweenToNPC()
    local targetPosition = npc.PrimaryPart.Position + Vector3.new(0, 0, -5)
    tweenToPosition(targetPosition, function()
        local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            pressProximityPrompt(prompt, 0.5)
            simulateKeyPress(Enum.KeyCode.BackSlash, 0.1)
            wait(0.5)
            simulateKeyPress(Enum.KeyCode.S, 0.1)
            wait(0.5)
            simulateKeyPress(Enum.KeyCode.Return, 0.1)
            wait(0.5)
            simulateKeyPress(Enum.KeyCode.S, 0.1)
            wait(0.5)
            simulateKeyPress(Enum.KeyCode.Return, 0.1)
            wait(0.5)
            simulateKeyPress(Enum.KeyCode.Return, 0.1)
            wait(1)
            tweenToFrostPetal()
            wait(1)
            simulateKeyPress(Enum.KeyCode.BackSlash, 0.1) -- Final action
            print("Final BackSlash action triggered!")
        end
    end)
end

wait(1)
tweenToNPC()
    	end
})

local digger = Quests:CreateButton({
	Name = "掘墓人",
	Description = nil, -- Creates A Description For Users to know what the button does (looks bad if you use it all the time),
    	Callback = function()
         local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local npcName = "Grave Digger"
local objectsFolder = workspace:FindFirstChild("Objects")
local npcFolder = objectsFolder and objectsFolder:FindFirstChild("NPCs")
local npc = npcFolder and npcFolder:FindFirstChild(npcName)

if not npc or not npc.PrimaryPart then
    return
end

local savedCoordinates = Vector3.new(7282.884765625, 990.78515625, -1070.3953857421875)

local function simulateKeyPress(keyCode, duration)
    VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
    wait(duration)
    VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
end

local function pressProximityPrompt(prompt)
    while prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled do
        fireproximityprompt(prompt)
        wait(0.2)
    end
end

local function tweenToPosition(targetPosition, callback)
    local distance = (humanoidRootPart.Position - targetPosition).Magnitude
    local speed = 3000
    local tweenTime = distance / speed
    local currentOrientation = humanoidRootPart.CFrame - humanoidRootPart.CFrame.Position
    local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenGoal = { CFrame = CFrame.new(targetPosition) * currentOrientation }
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, tweenGoal)

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    tween:Play()

    tween.Completed:Connect(function()
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        if callback then
            callback()
        end
    end)
end

local function interactWithNPC()
    local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
    if prompt then
        pressProximityPrompt(prompt)
        simulateKeyPress(Enum.KeyCode.BackSlash, 0.1)
        wait(0.5)
        simulateKeyPress(Enum.KeyCode.S, 0.1)
        wait(0.5)
        simulateKeyPress(Enum.KeyCode.Return, 0.1)
        wait(0.5)
        simulateKeyPress(Enum.KeyCode.S, 0.1)
        wait(0.5)
        simulateKeyPress(Enum.KeyCode.Return, 0.1)
        wait(0.5)
        simulateKeyPress(Enum.KeyCode.Return, 0.1)

        -- Tween to saved coordinates after interacting
        tweenToPosition(savedCoordinates)
        wait(0.5)
        simulateKeyPress(Enum.KeyCode.BackSlash, 0.1)
    end
end

local function tweenToNPC()
    local targetPosition = npc.PrimaryPart.Position + Vector3.new(0, 0, -5)
    tweenToPosition(targetPosition, interactWithNPC)
end

wait(1)
tweenToNPC()
end
})

local temple = Quests:CreateButton({
	Name = "神殿大师",
	Description = nil, -- Creates A Description For Users to know what the button does (looks bad if you use it all the time),
    	Callback = function()
         local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local npcName = "Temple Master" -- Changed NPC Name
local objectsFolder = workspace:FindFirstChild("Objects")
local npcFolder = objectsFolder and objectsFolder:FindFirstChild("NPCs")
local npc = npcFolder and npcFolder:FindFirstChild(npcName)

if not npc or not npc.PrimaryPart then
    return
end

-- Coordinates provided
local targetCoordinates = Vector3.new(6328.4580078125, 982.6458740234375, -409.1114196777344)

local function simulateKeyPress(keyCode, duration)
    VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
    wait(duration)
    VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
end

local function pressProximityPrompt(prompt)
    while prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled do
        fireproximityprompt(prompt)
        wait(0.2)
    end
end

local function tweenToPosition(targetPosition, callback)
    local distance = (humanoidRootPart.Position - targetPosition).Magnitude
    local speed = 3000
    local tweenTime = distance / speed
    local currentOrientation = humanoidRootPart.CFrame - humanoidRootPart.CFrame.Position
    local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenGoal = { CFrame = CFrame.new(targetPosition) * currentOrientation }
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, tweenGoal)

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    tween:Play()

    tween.Completed:Connect(function()
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        if callback then
            callback()
        end
    end)
end

local function interactWithNPC()
    local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
    if prompt then
        pressProximityPrompt(prompt)
        simulateKeyPress(Enum.KeyCode.BackSlash, 0.1)
        wait(0.5)
        simulateKeyPress(Enum.KeyCode.S, 0.1)
        wait(0.5)
        simulateKeyPress(Enum.KeyCode.Return, 0.1)
        wait(0.5)
        simulateKeyPress(Enum.KeyCode.S, 0.1)
        wait(0.5)
        simulateKeyPress(Enum.KeyCode.Return, 0.1)
        wait(0.5)
        simulateKeyPress(Enum.KeyCode.Return, 0.1)

        -- Tween to provided coordinates
        tweenToPosition(targetCoordinates, function()
            -- Simulate holding 'E' for 4 seconds
            wait(2)
            simulateKeyPress(Enum.KeyCode.E, 4)
            
            -- Simulate pressing backslash
            simulateKeyPress(Enum.KeyCode.BackSlash, 0.1)
        end)
    end
end

local function tweenToNPC()
    local targetPosition = npc.PrimaryPart.Position + Vector3.new(0, 0, -5)
    tweenToPosition(targetPosition, interactWithNPC)
end

wait(1)
tweenToNPC()
    	end
})

local camp = Quests:CreateButton({
	Name = "营地巫师",
	Description = nil, -- Creates A Description For Users to know what the button does (looks bad if you use it all the time),
    	Callback = function()
         local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local npcName = "Camp Sorcerer" -- Updated NPC name
local objectsFolder = workspace:FindFirstChild("Objects")
local npcFolder = objectsFolder and objectsFolder:FindFirstChild("NPCs")
local npc = npcFolder and npcFolder:FindFirstChild(npcName)

if not npc or not npc.PrimaryPart then
    return
end

local targetCoordinates = Vector3.new(8747.899, 772.301, 1569.553) -- New coordinates

local function simulateKeyPress(keyCode, duration)
    VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
    wait(duration)
    VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
end

local function pressProximityPrompt(prompt)
    while prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled do
        fireproximityprompt(prompt)
        wait(0.2) -- Hold prompt for a short interval
    end
end

local function tweenToPosition(targetPosition, callback)
    local distance = (humanoidRootPart.Position - targetPosition).Magnitude
    local speed = 500
    local tweenTime = distance / speed
    local currentOrientation = humanoidRootPart.CFrame - humanoidRootPart.CFrame.Position
    local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenGoal = { CFrame = CFrame.new(targetPosition) * currentOrientation }
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, tweenGoal)

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    tween:Play()

    tween.Completed:Connect(function()
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        if callback then
            callback()
        end
    end)
end

local function interactWithNearbyPrompt()
    local prompt = workspace:FindFirstChildOfClass("ProximityPrompt")
    if prompt then
        pressProximityPrompt(prompt)
    end
end

local function interactWithNPC()
    local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
    if prompt then
        -- Proximity prompt interaction with the NPC
        pressProximityPrompt(prompt)
        simulateKeyPress(Enum.KeyCode.BackSlash, 0.1)
        wait(0.5)
        simulateKeyPress(Enum.KeyCode.S, 0.1)
        wait(0.5)
        simulateKeyPress(Enum.KeyCode.Return, 0.1)
        wait(0.5)
        simulateKeyPress(Enum.KeyCode.S, 0.1)
        wait(0.5)
        simulateKeyPress(Enum.KeyCode.Return, 0.1)
        wait(0.5)
        simulateKeyPress(Enum.KeyCode.Return, 0.1)

        -- Tween to new coordinates after sequence
        tweenToPosition(targetCoordinates, function()
            wait(2)
            -- Wait and press E for 2 secondssw
        simulateKeyPress(Enum.KeyCode.E, 2)
        
            wait(1)
            tweenToPosition(Vector3.new(7538.853516625, 747.5322265625, 987.73436035162))
        simulateKeyPress(Enum.keyCode.BackSlash, 0.1)
        end)
    end
end

local function tweenToNPC()
    local targetPosition = npc.PrimaryPart.Position + Vector3.new(0, 0, -5)
    tweenToPosition(targetPosition, interactWithNPC)
end

wait(1)
tweenToNPC()
    	end
})

local Misc = Window:CreateTab({
    Name = "其他功能",
    Icon = "priority_high",
    ImageSource = "Material",
    ShowTitle = true
})


-- ESP Settings
local ESPEnabled = false
local blacklistedItems = {"Chest"} -- Blacklist
local ESPFolder = Instance.new("Folder", game.CoreGui) -- Store ESP drawings

-- Utility Functions
local function createESP(model)
    -- Get the Root part of the model
    local rootPart = model:FindFirstChild("Root")
    if not rootPart then return end

    -- Create BillboardGui
    local billboard = Instance.new("BillboardGui", ESPFolder)
    billboard.Adornee = rootPart
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.AlwaysOnTop = true

    local textLabel = Instance.new("TextLabel", billboard)
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.TextScaled = true
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.Font = Enum.Font.GothamBold

    -- Update Text and Distance
    spawn(function()
        while ESPEnabled and model.Parent do
            local playerRoot = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if playerRoot then
                local distance = math.floor((playerRoot.Position - rootPart.Position).Magnitude)
                textLabel.Text = string.format("%s\n(%d studs)", model.Name, distance)
            end
            task.wait(0.1)
        end
        billboard:Destroy()
    end)
end

local function toggleESP(enabled)
    ESPEnabled = enabled
    if ESPEnabled then
        for _, model in pairs(workspace.Objects.Drops:GetChildren()) do
            if not table.find(blacklistedItems, model.Name) and model:IsA("Model") then
                createESP(model)
            end
        end
        -- Notify
        Luna:Notification({
            Title = "ESP Enabled",
            Icon = "notifications_active",
            ImageSource = "Material",
            Content = "Item ESP has been enabled."
        })
    else
        -- Clear ESP
        ESPFolder:ClearAllChildren()
        -- Notify
        Luna:Notification({
            Title = "ESP Disabled",
            Icon = "notifications_off",
            ImageSource = "Material",
            Content = "Item ESP has been disabled."
        })
    end
end

-- Watch for New Items
workspace.Objects.Drops.ChildAdded:Connect(function(child)
    if ESPEnabled and not table.find(blacklistedItems, child.Name) and child:IsA("Model") then
        createESP(child)
    end
end)

-- Create Toggle
local Toggle = Misc:CreateToggle({
    Name = "启用物品ESP",
    Description = "切换物品ESP功能以显示物品距离和名称。",
    CurrentValue = config.itemESPEnabled,
    Callback = function(Value)
        config.itemESPEnabled = Value
        toggleESP(Value) 
        saveConfig()
    end
})

Tab:CreateSection("自动冻结")

local autofreezeRange = config.autofreezeRange
local autoFreezeEnabled = config.autoFreezeEnabled

-- Create the Toggle for enabling/disabling auto-freeze
local Toggle = Tab:CreateToggle({
    Name = "启用自动冻结",
    Description = "启用或禁用对附近人形角色的自动冻结功能。",
    CurrentValue = config.autoFreezeEnabled,  -- Use saved value
    Callback = function(Value)
        autoFreezeEnabled = Value
        config.autoFreezeEnabled = Value
        saveConfig()

        if Value then
            print("Auto-Freeze enabled")

            -- Auto-freeze logic
            local replicatedStorage = game:GetService("ReplicatedStorage")
            local freezeRemote = replicatedStorage.Remotes.Server.Combat.Rush

            local player = game.Players.LocalPlayer
            local playerCharacter = player.Character or player.CharacterAdded:Wait()

            local function getDistance(pos1, pos2)
                return (pos1 - pos2).Magnitude
            end

            local allowedFolders = {"Mobs", "Characters"}

            while autoFreezeEnabled do
                for _, folderName in ipairs(allowedFolders) do
                    local folder = workspace.Objects:FindFirstChild(folderName)
                    if folder then
                        for _, model in ipairs(folder:GetDescendants()) do
                            local humanoid = model:FindFirstChildOfClass("Humanoid")
                            if humanoid and humanoid.Parent ~= playerCharacter then
                                local humanoidRootPart = model:FindFirstChild("HumanoidRootPart")
                                local playerRootPart = playerCharacter:FindFirstChild("HumanoidRootPart")

                                if humanoidRootPart and playerRootPart then
                                    local distance = getDistance(playerRootPart.Position, humanoidRootPart.Position)
                                    if distance <= autofreezeRange then
                                        freezeRemote:FireServer(humanoid, false) -- Fire the server with updated parameters
                                    end
                                end
                            end
                        end
                    end
                end
                wait(0.5) -- Adjust the wait time for checking frequency
            end
        else
            print("Auto-Freeze disabled")
        end
    end
})

-- Create the Slider for Range Selection
local Slider = Tab:CreateSlider({
    Name = "选择冻结范围",
    Range = {1, 1000},  -- Minimum and Maximum Range for the Slider
    Increment = 1,      -- The value change per step
    CurrentValue = config.autofreezeRange,
    Callback = function(Value)
        autofreezeRange = Value
        config.autofreezeRange = Value
        saveConfig()
        print("Selected range for auto-freeze:", autofreezeRange)
    end
})


local TweenService = game:GetService("TweenService")
local autocollectToolsEnabled = false
local ProximityPromptService = game:GetService("ProximityPromptService")
local RunService = game:GetService("RunService")

local function Tween(Object1, Object2, Speed, Offset, Wait)
    if Object1 and Object2 then
        local Timing = (Object1.Position - Object2.Position).Magnitude / Speed
        local TweenInfo = TweenInfo.new(Timing, Enum.EasingStyle.Linear)
        local TweenSystem = TweenService:Create(Object1, TweenInfo, {CFrame = Object2.CFrame + Offset})
        TweenSystem:Play()
        if Wait then
            TweenSystem.Completed:Wait()
        end
    end
end

local function TweenAndFireProximityPrompt(character, targetModel, speed, offset)
    local rootPart = targetModel:FindFirstChild("Root")
    local proximityPrompt = targetModel:FindFirstChild("Collect")

    if rootPart and proximityPrompt then
        -- Tween to the root part
        Tween(character.PrimaryPart, rootPart, speed, offset, true)

        -- Simulate proximity prompt activation
        task.wait(0.5) -- Slight delay to ensure proximity
        fireproximityprompt(proximityPrompt) -- Trigger the proximity prompt
        print("Proximity Prompt 'Collect' triggered for:", targetModel.Name)
    else
        print("No 'Collect' Proximity Prompt or 'Root' part found for:", targetModel.Name)
    end
end

local function tweenToLoot()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    if autocollectToolsEnabled and character and character.PrimaryPart then
        for _, model in pairs(workspace.Objects.Drops:GetChildren()) do
            if model:IsA("Model") then
                local offset = Vector3.new(0, 0, 0)
                local speed = 5000
                TweenAndFireProximityPrompt(character, model, speed, offset)

                -- Wait for 0.5 seconds after processing each item
                task.wait(0.5)
            end
        end
    end
end


ProximityPromptService.PromptShown:Connect(function(prompt)
     if autocollectToolsEnabled then
        fireproximityprompt(prompt)

    end
end)

-- Toggle button for Auto Collect Loots
Misc:CreateToggle({
    Name = "自动拾取战利品(勿开启自动任务)",
    CurrentValue = config.autocollectToolsEnabled,
    Callback = function(State)
        autocollectToolsEnabled = State
        config.autocollectToolsEnabled = State
        saveConfig()
            if autocollectToolsEnabled then
                tweenToLoot()
                task.wait(1) -- Adjust delay to prevent performance issues
            end
        end
})

local autopromoteEnabled = false

Misc:CreateToggle({
    Name = "自动晋升",
    CurrentValue = config.autopromoteEnabled,
    Callback = function(Value)
        autopromoteEnabled = Value
        config.autopromoteEnabled = Value
        saveConfig()
    end
})

local function performautopromote()
    if autopromoteEnabled then
        local ohString1 = "Clan Head Jujutsu High"
        local ohString2 = "Promote"
        game:GetService("ReplicatedStorage").Remotes.Server.Dialogue.GetResponse:InvokeServer(ohString1, ohString2)
    end
end

game:GetService("RunService").Heartbeat:Connect(function()
    performautopromote()
end)

-- Setup necessary services and variables
local autoCollectEnabled = false
local ProximityPromptService = game:GetService("ProximityPromptService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local lootUI = game:GetService("Players").LocalPlayer.PlayerGui.Loot
local flipButton = game:GetService("Players").LocalPlayer.PlayerGui.Loot.Frame.Flip
local replayButton = game:GetService("Players").LocalPlayer.PlayerGui.ReadyScreen.Frame.Replay
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = game.Players.LocalPlayer
local flipDelayTime = 0.4

local chestTable = {}
local chestCount = 0
local endFunctions = false  -- Used to track if coroutines are already running

-- Function to update the chest list
local function updateChests()
    local dropsFolder = game.Workspace.Objects.Drops:GetChildren()
    chestTable = {}
    chestCount = 0
    for _, chest in pairs(dropsFolder) do
        if chest:IsA("Model") and chest.Name == "Chest" then
            table.insert(chestTable, chest)
            chestCount = chestCount + 1
        end
    end
end

-- Function to collect a chest
local function collectChest(chest)
    if chest:IsA("Model") and chest.Name == "Chest" then
        local dropsFolder = game.Workspace.Objects.Drops
        local initialChestCount = #dropsFolder:GetChildren()  -- Get the initial chest count
        for _, prompt in pairs(chest:GetChildren()) do
            if prompt:IsA("ProximityPrompt") then
                prompt:InputHoldBegin()
                task.wait(0.06)
                prompt:InputHoldEnd()
                task.wait(1)
            end
        end
        local finalChestCount = #dropsFolder:GetChildren()  -- Get the final chest count
        if finalChestCount < initialChestCount then
            chestCount = finalChestCount
        end
    end
end

-- Function to auto-flip (automate flip button interaction)
local function autoFlip()
    while autoCollectEnabled do
        task.wait()
        if lootUI.Enabled then
            task.wait(flipDelayTime)
            GuiService.SelectedObject = flipButton
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.BackSlash, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.BackSlash, false, game)
        else
            task.wait(1)
        end
    end
end

-- Function to auto-collect chests
local function autoCollectChests()
    while autoCollectEnabled do
        task.wait()
        updateChests()
        if chestCount > 0 then
            for _, chest in pairs(chestTable) do
                collectChest(chest)
                break
            end
        end
    end
end

-- Debug function for chest count
local function debugChestCount()
    while true do
        local dropsFolder = game.Workspace.Objects.Drops
        local finalChestCount = #dropsFolder:GetChildren()
        print("Chests:", finalChestCount)
        task.wait(1)
    end
end

-- Start the debug function in the background
coroutine.wrap(debugChestCount)()

-- Toggle button to enable/disable auto collection
local Toggle = Misc:CreateToggle({
    Name = "自动收集宝箱",
    CurrentValue = config.autoCollectEnabled,
    Callback = function(Value)
        autoCollectEnabled = Value
        config.autoCollectEnabled = Value
        saveConfig()
        if autoCollectEnabled then
            if not endFunctions then
                -- Start the coroutines only when the toggle is enabled for the first time
                endFunctions = true
                coroutine.wrap(autoFlip)()
                coroutine.wrap(autoCollectChests)()
            end
        else
            endFunctions = false  -- Stop the coroutines when the toggle is disabled
            print("Auto collect disabled.")
        end
    end
})


Misc:CreateSection("免费先天槽位，跳过旋转")

local Button = Misc:CreateButton({
    Name = "授予游戏通行证",
    Callback = function()
        Luna:Notification({
            Title = "成功",
            Content = "已授予游戏通行证",
            ImageSource = "Material",
            Icon = "notifications_active",
            Time = 5
        })
        local gamepassIds = {"77102528", "77102481", "77103458", "259500454", "77102969"}
        local player = game:GetService("Players").LocalPlayer
        local replicatedData = player:WaitForChild("ReplicatedData")
        local gamepassesFolder = replicatedData:WaitForChild("gamepasses")

        for _, gamepassId in ipairs(gamepassIds) do
            local gamepassValue = gamepassesFolder:FindFirstChild(gamepassId)

            if not gamepassValue then
              
                gamepassValue = Instance.new("BoolValue")
                gamepassValue.Name = gamepassId
                gamepassValue.Value = true
                gamepassValue.Parent = gamepassesFolder
                print("Inserted BoolValue for game pass with ID:", gamepassId)
            else
                print("BoolValue for game pass with ID already exists:", gamepassId)
            end
        end
    end
})
Misc:CreateSection("Skill Giver(Not Perm)")


local modeSelected = "Innates"
local DropDown = Misc:CreateDropdown({
    Name = "选择模式",
    Options = {"先天技能", "后天技能"},
    CurrentOption = "先天技能",
    Callback = function(value)
        modeSelected = value
    end
})


local skillName
local Input = Misc:CreateInput({
    Name = "输入技能/先天技能",
    CurrentValue = "",
    TextDisappear = false,  
    Callback = function(value)
        print("输入技能: " .. value)
        skillName = value  
    end
})

local keybindSelected = "B"
local DropDown = Misc:CreateDropdown({
    Name = "选择快捷键",
    Options = {"B", "C", "G", "T", "V", "X", "Y", "Z"},
    CurrentOption = "B",
    Callback = function(value)
        keybindSelected = value
    end
})


local Button = Misc:CreateButton({
    Name = "分配技能/先天技能",
    Callback = function()
        if not skillName or skillName == "" then
            Luna:Notification({
                Title = "错误",
                Content = "请输入技能名称。",
                ImageSource = "Material",
                Icon = "notifications_active",
                Time = 5
            })
            return
        end

        local player = game:GetService("Players").LocalPlayer
        local techniques = player:WaitForChild("ReplicatedData"):WaitForChild("techniques")
        local selectedFolder
        if modeSelected == "Innates" then
            selectedFolder = techniques:WaitForChild("innates")
        elseif modeSelected == "Skills" then
            selectedFolder = techniques:WaitForChild("skills")
        end

        if selectedFolder then
            local stringValue = selectedFolder:FindFirstChild(keybindSelected)
            if stringValue and stringValue:IsA("StringValue") then
                stringValue.Value = skillName
                print("Skill assigned: " .. skillName)
            Luna:Notification({
                Title = "技能已分配",
                Content = "技能 '" .. skillName .. "' 已分配到 " .. keybindSelected,
                ImageSource = "Material",
                Icon = "notifications_active",
                Time = 5
            })
        else
            Luna:Notification({
                Title = "错误",
                Content = "在 " .. modeSelected .. " 中未找到 " .. keybindSelected .. " 的StringValue",
                ImageSource = "Material",
                Icon = "notifications_active",
                Time = 5
            })
        end
    else
        Luna:Notification({
            Title = "错误",
            Content = "所选文件夹 (" .. modeSelected .. ") 不存在。",
            ImageSource = "Material",
            Icon = "notifications_active",
            Time = 5
        })
    end
end
})

Misc:CreateSection("武器给予器")

local toolName = ""

-- Create an input box for typing the Tool name
local Input = Misc:CreateInput({
    Name = "输入武器名称",
    PlaceholderText = "在此输入武器名称",
    CurrentValue = "",
    Numeric = false,
    Callback = function(Text)
        toolName = Text
    end,
})
-- Button to create and add the Tool to the Backpack
local Button = Misc:CreateButton({
    Name = "给予武器（非永久）",
    Callback = function()
        if not toolName or toolName == "" then
            print("Error: Please enter a tool name.")
            return
        end

        local player = game:GetService("Players").LocalPlayer
        local backpack = player.Backpack

        -- Check if the tool already exists
        if backpack:FindFirstChild(toolName) then
            print("Cursed Tool Already Exists: A tool with this name is already in your Backpack.")
            return
        end

        -- Create the tool and add it to the backpack
        local tool = Instance.new("Tool")
        tool.Name = toolName
        tool.Parent = backpack
        print("Tool '" .. toolName .. "' added to the Backpack.")
    end,
})


local Tab = Window:CreateTab({
    Name = "移动兑换器",
    Icon = "redeem",
    ImageSource = "Material",
    ShowTitle = true,
})

local moveName = ""

local Input = Tab:CreateInput({
    Name = "移动兑换器(永久需要金钱和熟练度)",
    Description = nil,
    PlaceholderText = "输入内容",
	CurrentValue = "", -- the current text
	Numeric = false, -- When true, the user may only type numbers in the box (Example walkspeed)
	MaxCharacters = nil, -- if a number, the textbox length cannot exceed the number
	Enter = false, -- When true, the callback will only be executed when the user presses enter.
    	Callback = function(Text)
        moveName = Text
    	end
}, "Input")

local Button = Tab:CreateButton({
    Name = "兑换招式",
    Callback = function()
        if moveName and moveName ~= "" then
            game:GetService("ReplicatedStorage").Remotes.Server.Data.UnlockStatNode:InvokeServer(moveName)
            print("已兑换招式:", moveName)
        else
            warn("请输入招式名称！")
        end
    end,
})

