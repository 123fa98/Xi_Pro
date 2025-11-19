-- 加载WindUI库
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/123fa98/Xi_Pro/refs/heads/main/UI.lua"))()

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(chars, uchar)
    end
    
    local length = #chars
    
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
            math.floor(r * 255), 
            math.floor(g * 255), 
            math.floor(b * 255), 
            chars[i])
    end
    
    return result
end

local Window = WindUI:CreateWindow({
    Title = gradient("Atomic   ", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("在森林中99夜生存", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
    IconThemed = true,
    Folder = "Atomic",
    Size = UDim2.fromOffset(150, 100),
     Transparent = getgenv().TransparencyEnabled,
     Theme = "Dark",
     Resizable = true,
     SideBarWidth = 150,
     BackgroundImageTransparency = 0.8,
     HideSearchBar = true,
     ScrollBarEnabled = true,
     User = {
         Enabled = true,
         Anonymous = false,
         Callback = function()
             currentThemeIndex = currentThemeIndex + 1
             if currentThemeIndex > #themes then
                 currentThemeIndex = 1
             end
             
             local newTheme = themes[currentThemeIndex]
             WindUI:SetTheme(newTheme)
            
             WindUI:Notify({
                 Title = "Theme Changed",
                 Content = "Switched to " .. newTheme .. " theme!",
                 Duration = 2,
                 Icon = "palette"
             })
             print("Switched to " .. newTheme .. " theme")
         end,
     },
 })

    
Window:EditOpenButton({
    Title = "[Atomic]",
    CornerRadius = UDim.new(0,8),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("1E3A8A")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("118AB2")), 
        ColorSequenceKeypoint.new(1, Color3.fromHex("06D6A0")) 
    }),
    Draggable = true,
})

Window:Tag({
    Title = "免费版",
    Radius = 5,
    Color = Color3.fromHex("#42D392"), 
})

Window:SetToggleKey(Enum.KeyCode.F, true)

-- 游戏服务
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- UI主题配置
local themes = {"Dark", "Light", "Ocean", "Midnight", "Cherry", "Cotton Candy"}
local currentThemeIndex = 1


-- 战斗功能变量
local killAuraxipro = false
local chopAuraxipro = false
local auraXXXIIIIPPPRRROOO = 50
local XXXIIIIPPPRRROOO = 0

-- 工具伤害ID映射
local toolsDamageIDs = {
    ["Old Axe"] = "3_7367831688",
    ["Good Axe"] = "112_7367831688",
    ["Strong Axe"] = "116_7367831688",
    ["Chainsaw"] = "647_8992824875",
    ["Spear"] = "196_8999010016"
}

-- 自动功能变量
local autoFeedxipro = false
local ShenChouFood = "Carrot"
local hungerThreshold = 75
local alwaysFeedXXIIPPRROOItems = {}

-- 食物列表
local alimentos = {
    "Apple",
    "Berry",
    "Carrot",
    "Cake",
    "Chili",
    "Cooked Morsel",
    "Cooked Steak"
}

local me = {"Bunny", "Wolf", "Alpha Wolf", "Bear", "Cultist", "Crossbow Cultist", "Alien"}

local campfireFuelItems = {"Log", "Coal", "Fuel Canister", "Oil Barrel", "Biofuel"}
local campfireDropPos = Vector3.new(0, 19, 0)

local autocookItems = {"Morsel", "Steak"}
local autoCookxiproItems = {}
local autoCookxipro = false


local autoFishActive = false


local Constants = {
    BRING_DEFAULT_INTERVAL = 0.05,
}


local Config = {
    Bring = {
        quantity = -1, -- -1代表全部
        interval = Constants.BRING_DEFAULT_INTERVAL
    }
}


local ItemDatabase = {
    items = {
        {name="Carrot", display="胡萝卜"}, {name="Berry", display="浆果"}, {name="Chair", display="椅子"},
        {name="Sheet Metal", display="金属板"}, {name="Bolt", display="螺栓"}, {name="Sapling", display="树苗"},
        {name="Old Rod", display="旧鱼竿"}, {name="Log", display="原木"}, {name="Old Car Engine", display="旧车发动机"},
        {name="Tyre", display="轮胎"}, {name="Broken Microwave", display="坏微波炉"}, {name="Coal", display="煤炭"},
        {name="Crossbow Cultist", display="弩邪教徒"}, {name="Cultist", display="邪教徒"}, {name="Old Radio", display="旧收音机"},
        {name="Old Flashlight", display="旧手电筒"}, {name="Broken Fan", display="坏风扇"}, {name="Coin Stack", display="钱堆"},
        {name="Item Chest", display="宝箱"}, {name="Revolver Ammo", display="左轮子弹"}, {name="Iron Body", display="铁甲"},
        {name="Gem of the Forest Fragment", display="森林宝石碎片"}, {name="Cultist Gem", display="邪教宝石"},
        {name="Cultist Experiment", display="邪教实验品"}, {name="Rifle Ammo", display="步枪子弹"},
        {name="Leather Body", display="皮甲"}, {name="Bandage", display="绷带"}, {name="Cake", display="蛋糕"},
        {name="Rifle", display="步枪"}, {name="Oil Barrel", display="油桶"}, {name="Fuel Canister", display="燃料罐"},
        {name="Alpha Wolf Corpse", display="阿尔法狼尸体"}, {name="Wolf Corpse", display="狼尸体"}, {name="Steak", display="牛排"},
        {name="Stronghold Diamond Chest", display="要塞钻石宝箱"}, {name="Cultist Prototype", display="邪教原型体"},
        {name="Anvil Back", display="铁砧-后部"}, {name="Anvil Front", display="铁砧-前部"}, {name="Anvil Base", display="铁砧-底座"},
        {name="Apple", display="苹果"}, {name="Seed Box", display="种子箱"}, {name="Diamond", display="钻石"},
        {name="Wolf Pelt", display="狼皮"}, {name="MedKit", display="医疗包"}, {name="Washing Machine", display="洗衣机"},
        {name="Basketball", display="篮球"}, {name="Toolbox", display="工具箱"}, {name="Raw Meat", display="生肉"},
        {name="Cooked Meat", display="熟肉"}, {name="Cooked Morsel", display="熟肉块"}, {name="Morsel", display="肉块"},
        {name="Stone", display="石头"}, {name="Nails", display="钉子"}, {name="Scrap", display="废料"},
        {name="Wooden Plank", display="木板"}, {name="Revolver", display="左轮手枪"},
        {name="Good Sack", display="优质袋子"}, {name="Old Sack", display="旧袋子"}, {name="Good Axe", display="优质斧头"},
        {name="Old Axe", display="旧斧头"}, {name="Strong Axe", display="强力斧头"}, {name="Hatchet", display="手斧"},
        {name="Chainsaw", display="电锯"},

        {name="Chili", display="辣椒"},
        {name="Cooked Steak", display="熟牛排"},
        {name="Bunny", display="兔子"},
        {name="Wolf", display="狼"},
        {name="Alpha Wolf", display="阿尔法狼"},
        {name="Bear", display="熊"},
        {name="Alien", display="外星人"},
        {name="Biofuel", display="生物燃料"},
        {name="Spear", display="矛"}
    },
    patterns = {
        Chest = {"chest"},
        Axe = {"axe", "hatchet", "chainsaw"},
        Sack = {"sack"}
    }
}


local function removeDuplicates()
    local seen, cleaned = {}, {}
    for _, item in ipairs(ItemDatabase.items) do
        if not seen[item.name] then
            seen[item.name] = true
            table.insert(cleaned, item)
        end
    end
    ItemDatabase.items = cleaned
end
removeDuplicates()


local NameToDisplay = {}
local DisplayToName = {}

local function buildTranslationMaps()
    for _, item in ipairs(ItemDatabase.items) do
        NameToDisplay[item.name] = item.display
        DisplayToName[item.display] = item.name
    end
end
buildTranslationMaps()

local function translateList(list)
    local translated = {}
    for _, name in ipairs(list) do
        table.insert(translated, NameToDisplay[name] or name)
    end
    return translated
end


local function getCommonItems()
    local npcs = {["Crossbow Cultist"]=true, ["Cultist"]=true}
    local result = {}
    for _, item in ipairs(ItemDatabase.items) do
        if not npcs[item.name] then
            table.insert(result, item)
        end
    end
    return result
end


local itemCategories = {
    { 
        title = "燃料", 
        icon = "fire",
        items = {"Log", "Coal", "Fuel Canister", "Oil Barrel"}
    },
    { 
        title = "材料与废料", 
        icon = "wrench",
        items = {"Sheet Metal", "Bolt", "Old Car Engine", "Tyre", "Broken Microwave", "Old Radio", 
                 "Old Flashlight", "Broken Fan", "Wolf Pelt", "Washing Machine", "Stone", "Nails", 
                 "Scrap", "Wooden Plank", "Sapling"}
    },
    { 
        title = "装备与工具", 
        icon = "tools",
        items = {"Old Rod", "Revolver", "Rifle", "Good Sack", "Old Sack", "Good Axe", "Old Axe", 
                 "Strong Axe", "Hatchet", "Chainsaw", "Iron Body", "Leather Body"}
    },
    { 
        title = "食物与消耗品", 
        icon = "utensils",
        items = {"Carrot", "Berry", "Apple", "Cake", "Steak", "Raw Meat", "Cooked Meat", "Morsel", 
                 "Cooked Morsel", "MedKit", "Bandage", "Revolver Ammo", "Rifle Ammo"}
    },
    { 
        title = "杂项", 
        icon = "box",
        items = {"Chair", "Coin Stack", "Item Chest", "Gem of the Forest Fragment", "Cultist Gem", 
                 "Seed Box", "Diamond", "Basketball", "Toolbox"}
    }
}

local masterItemList = {}
for _, item in ipairs(getCommonItems()) do
    table.insert(masterItemList, item.name)
end
table.sort(masterItemList)


local ie = masterItemList


local Utils = {}

function Utils.notify(title, text, duration)
    WindUI:Notify({
        Title = title,
        Content = text,
        Duration = duration or 3
    })
end

function Utils.getItemFolders()
    local names = {"ltems", "Items", "MapItems", "WorldItems"}
    local result = {}
    for _, name in ipairs(names) do
        local folder = Workspace:FindFirstChild(name)
        if folder then
            table.insert(result, folder)
        end
    end
    return result
end

function Utils.getModelPart(model)
    return model.PrimaryPart or
           model:FindFirstChild("HumanoidRootPart") or
           model:FindFirstChild("Handle") or
           model:FindFirstChildWhichIsA("BasePart")
end

function Utils.matchPatterns(str, patterns)
    local lower = string.lower(str or "")
    for _, pattern in ipairs(patterns) do
        if string.find(lower, pattern, 1, true) then
            return true
        end
    end
    return false
end

function Utils.findByPatterns(patterns)
    local found = {}
    for _, folder in ipairs(Utils.getItemFolders()) do
        for _, item in ipairs(folder:GetDescendants()) do
            if item:IsA("Model") and Utils.matchPatterns(item.Name, patterns) then
                local part = Utils.getModelPart(item)
                if part then
                    table.insert(found, {model = item, part = part})
                end
            end
        end
    end
    return found
end

function Utils.findBringTargets(keyword)
    local targets = {}
    local kwLower = string.lower(tostring(keyword or ""))
    for _, folder in ipairs(Utils.getItemFolders()) do
        for _, inst in ipairs(folder:GetDescendants()) do
            if inst:IsA("Model") then
                if kwLower == "" or string.find(string.lower(inst.Name), kwLower, 1, true) then
                    local part = Utils.getModelPart(inst)
                    if part then
                        table.insert(targets, {model = inst, part = part})
                    end
                end
            end
        end
    end
    return targets
end

local BringModule = {}

function BringModule.moveItemToPosition(itemModel, targetPosition)
    if not (itemModel and itemModel:IsA("Model") and targetPosition) then
        return false
    end
    local part = Utils.getModelPart(itemModel)
    if not part then
        return false
    end
    if not itemModel.PrimaryPart then
        pcall(function()
            itemModel.PrimaryPart = part
        end)
    end
    local success = pcall(function()
        local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
        remoteEvents.RequestStartDraggingItem:FireServer(itemModel)
        task.wait(0.05)
        itemModel:SetPrimaryPartCFrame(CFrame.new(targetPosition))
        task.wait(0.05)
        remoteEvents.StopDraggingItem:FireServer(itemModel)
    end)
    return success
end

function BringModule.bringItemsV1(keyword, displayLabel)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        Utils.notify("错误", "角色未准备好", 2)
        return
    end

    local targets = Utils.findBringTargets(keyword)
    local brought = 0
    local targetPosition = hrp.Position + Vector3.new(0, 6, 0)
    
    for _, target in ipairs(targets) do
        if Config.Bring.quantity ~= -1 and brought >= Config.Bring.quantity then
            break
        end
        if BringModule.moveItemToPosition(target.model, targetPosition) then
            brought = brought + 1
        end
        task.wait(Config.Bring.interval)
    end
    
    local label = displayLabel and displayLabel ~= "" and displayLabel or "物品"
    Utils.notify("收集完成", string.format("已收集%s：%d 个", label, brought), 3)
end

function BringModule.bringGroupV1(patterns, displayLabel)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        Utils.notify("错误", "角色未准备好", 2)
        return
    end
    
    local targets = Utils.findByPatterns(patterns)
    local brought = 0
    local targetPosition = hrp.Position + Vector3.new(0, 6, 0)
    
    for _, target in ipairs(targets) do
        if Config.Bring.quantity ~= -1 and brought >= Config.Bring.quantity then
            break
        end
        if BringModule.moveItemToPosition(target.model, targetPosition) then
            brought = brought + 1
        end
        task.wait(Config.Bring.interval)
    end
    
    Utils.notify("收集完成", string.format("已收集%s：%d 个", displayLabel or "目标", brought), 3)
end

local function openAllChests()
    local openChestEvent = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestOpenItemChest")
    local chests = Utils.findByPatterns(ItemDatabase.patterns.Chest)
    
    if #chests == 0 then
        Utils.notify("提示", "未找到任何宝箱", 3)
        return
    end
    
    local openedCount = 0
    for _, chestData in ipairs(chests) do
        -- 仅尝试打开未被标记为已打开的宝箱
        if not chestData.model:GetAttribute("8721081708Opened") then
            pcall(function()
                openChestEvent:FireServer(chestData.model)
            end)
            openedCount = openedCount + 1
            task.wait(0.1) -- 防止请求过于频繁
        end
    end
    
    if openedCount > 0 then
        Utils.notify("操作完成", string.format("已发送打开 %d 个宝箱的请求", openedCount), 3)
    else
        Utils.notify("提示", "未找到可打开的新宝箱", 3)
    end
end

local godModeActive = false 

local function getAnyToolWithDamageID(isChopAura)
    for toolName, damageID in pairs(toolsDamageIDs) do
        if isChopAura and toolName ~= "Old Axe" and toolName ~= "Good Axe" and toolName ~= "Strong Axe" then
            continue
        end
        local tool = LocalPlayer:FindFirstChild("Inventory") and LocalPlayer.Inventory:FindFirstChild(toolName)
        if tool then
            return tool, damageID
        end
    end
    return nil, nil
end

local function equipTool(tool)
    if tool then
        ReplicatedStorage:WaitForChild("RemoteEvents").EquipItemHandle:FireServer("FireAllClients", tool)
    end
end

local function unequipTool(tool)
    if tool then
        ReplicatedStorage:WaitForChild("RemoteEvents").UnequipItemHandle:FireServer("FireAllClients", tool)
    end
end

local function killAuraXXXXXXIIIIIIPPPPPRRRRROOOOO()
    while killAuraxipro do
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local tool, damageID = getAnyToolWithDamageID(false)
            if tool and damageID then
                equipTool(tool)
                for _, mob in ipairs(Workspace.Characters:GetChildren()) do
                    if mob:IsA("Model") then
                        local part = mob:FindFirstChildWhichIsA("BasePart")
                        if part and (part.Position - hrp.Position).Magnitude <= auraXXXIIIIPPPRRROOO then
                            pcall(function()
                                ReplicatedStorage:WaitForChild("RemoteEvents").ToolDamageObject:InvokeServer(
                                    mob,
                                    tool,
                                    damageID,
                                    CFrame.new(part.Position)
                                )
                            end)
                        end
                    end
                end
                task.wait(0.1)
            else
                task.wait(1)
            end
        else
            task.wait(0.5)
        end
    end
end

local function chopAuraxipro()
    while chopAuraxipro do
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local tool, baseDamageID = getAnyToolWithDamageID(true)
            if tool and baseDamageID then
                equipTool(tool)
                XXXIIIIPPPRRROOO = XXXIIIIPPPRRROOO + 1
                local trees = {}
                local map = Workspace:FindFirstChild("Map")
                if map then
                    if map:FindFirstChild("Foliage") then
                        for _, obj in ipairs(map.Foliage:GetChildren()) do
                            if obj:IsA("Model") and obj.Name == "Small Tree" then
                                table.insert(trees, obj)
                            end
                        end
                    end
                    if map:FindFirstChild("Landmarks") then
                        for _, obj in ipairs(map.Landmarks:GetChildren()) do
                            if obj:IsA("Model") and obj.Name == "Small Tree" then
                                table.insert(trees, obj)
                            end
                        end
                    end
                end
                for _, tree in ipairs(trees) do
                    local trunk = tree:FindFirstChild("Trunk")
                    if trunk and trunk:IsA("BasePart") and (trunk.Position - hrp.Position).Magnitude <= auraXXXIIIIPPPRRROOO then
                        local alreadyammount = false
                        task.spawn(function()
                            while chopAuraxipro and tree and tree.Parent and not alreadyammount do
                                alreadyammount = true
                                XXXIIIIPPPRRROOO = XXXIIIIPPPRRROOO + 1
                                pcall(function()
                                    ReplicatedStorage:WaitForChild("RemoteEvents").ToolDamageObject:InvokeServer(
                                        tree,
                                        tool,
                                        tostring(XXXIIIIPPPRRROOO) .. "_7367831688",
                                        CFrame.new(-2.962610244751, 4.5547881126404, -75.950843811035, 0.89621275663376, -1.3894891459643e-08, 0.44362446665764, -7.994568895775e-10, 1, 3.293635941759e-08, -0.44362446665764, -2.9872644802253e-08, 0.89621275663376)
                                    )
                                end)
                                task.wait(0.5)
                            end
                        end)
                    end
                end
                task.wait(0.1)
            else
                task.wait(1)
            end
        else
            task.wait(0.5)
        end
    end
end

function wiki(nome)
    local c = 0
    for _, i in ipairs(Workspace.Items:GetChildren()) do
        if i.Name == nome then
            c = c + 1
        end
    end
    return c
end

function ghn()
    return math.floor(LocalPlayer.PlayerGui.Interface.StatBars.HungerBar.Bar.Size.X.Scale * 100)
end

function feed(nome)
    for _, item in ipairs(Workspace.Items:GetChildren()) do
        if item.Name == nome then
            ReplicatedStorage.RemoteEvents.RequestConsumeItem:InvokeServer(item)
            break
        end
    end
end

function notifeed(nome) -- nome here is the English internal name
    WindUI:Notify({
        Title = "自动食物停止",
        Content = (NameToDisplay[nome] or nome) .. " 没了", -- Display Chinese name
        Duration = 3
    })
end

local function moveItemToPos(item, position)
    if not item or not item:IsDescendantOf(workspace) then return false end
    if not item:IsA("BasePart") and not item:IsA("Model") then return false end
    
    local part = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart") or item:FindFirstChild("Handle")) or item
    if not part or not part:IsA("BasePart") then return false end

    local success = false
    pcall(function()
        if item:IsA("Model") and not item.PrimaryPart then
            item.PrimaryPart = part
        end

        local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
        remoteEvents.RequestStartDraggingItem:FireServer(item)
        task.wait(0.05)
        
        if item:IsA("Model") then
            item:SetPrimaryPartCFrame(CFrame.new(position))
        else
            part.CFrame = CFrame.new(position)
        end
        
        task.wait(0.05)
        remoteEvents.StopDraggingItem:FireServer(item)
        success = true
    end)
    
    return success
end

local function getChests()
    local chests = {}
    local chestNames = {}
    local index = 1
    for _, item in ipairs(workspace:WaitForChild("Items"):GetChildren()) do
        if item.Name:match("^Item Chest") and not item:GetAttribute("8721081708Opened") then
            table.insert(chests, item)
            table.insert(chestNames, "宝箱 " .. index) -- Translated
            index = index + 1
        end
    end
    return chests, chestNames
end

local currentChests, currentChestNames = getChests()
local ShenChouChest = currentChestNames[1] or nil

local function getMobs()
    local mobs = {}
    local mobNames = {}
    local index = 1
    for _, character in ipairs(workspace:WaitForChild("Characters"):GetChildren()) do
        if character.Name:match("^Lost Child") and character:GetAttribute("Lost") == true then
            table.insert(mobs, character)
            table.insert(mobNames, character.Name)
            index = index + 1
        end
    end
    return mobs, mobNames
end

local currentMobs, currentMobNames = getMobs()
local ShenChouMob = currentMobNames[1] or nil

function tp1()
	(game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart").CFrame =
CFrame.new(0.43132782, 15.77634621, -1.88620758, -0.270917892, 0.102997094, 0.957076371, 0.639657021, 0.762253821, 0.0990355015, -0.719334781, 0.639031112, -0.272391081)
end

local function tp2()
    local targetPart = workspace:FindFirstChild("Map")
        and workspace.Map:FindFirstChild("Landmarks")
        and workspace.Map.Landmarks:FindFirstChild("Stronghold")
        and workspace.Map.Landmarks.Stronghold:FindFirstChild("Functional")
        and workspace.Map.Landmarks.Stronghold.Functional:FindFirstChild("EntryDoors")
        and workspace.Map.Landmarks.Stronghold.Functional.EntryDoors:FindFirstChild("DoorRight")
        and workspace.Map.Landmarks.Stronghold.Functional.EntryDoors.DoorRight:FindFirstChild("Model")
    if targetPart then
        local children = targetPart:GetChildren()
        local destination = children[5]
        if destination and destination:IsA("BasePart") then
            local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = destination.CFrame + Vector3.new(0, 5, 0)
            end
        end
    end
end

local flyToggle = false
local flySpeed = 1
local FLYING = false
local flyKeyDown, flyKeyUp, mfly1, mfly2
local IYMouse = game:GetService("UserInputService")

local function sFLY()
    repeat task.wait() until Players.LocalPlayer and Players.LocalPlayer.Character and Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    repeat task.wait() until IYMouse
    if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect(); flyKeyUp:Disconnect() end

    local T = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local SPEED = flySpeed

    local function FLY()
        FLYING = true
        local BG = Instance.new('BodyGyro')
        local BV = Instance.new('BodyVelocity')
        BG.P = 9e4
        BG.Parent = T
        BV.Parent = T
        BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        BG.CFrame = T.CFrame
        BV.Velocity = Vector3.new(0, 0, 0)
        BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        task.spawn(function()
            while FLYING do
                task.wait()
                if not flyToggle and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
                    Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
                end
                if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
                    SPEED = flySpeed
                elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
                    SPEED = 0
                end
                if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
                    BV.Velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
                    lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
                elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
                    BV.Velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
                else
                    BV.Velocity = Vector3.new(0, 0, 0)
                end
                BG.CFrame = workspace.CurrentCamera.CoordinateFrame
            end
            CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            SPEED = 0
            BG:Destroy()
            BV:Destroy()
            if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
                Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
            end
        end)
    end
    flyKeyDown = IYMouse.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local KEY = input.KeyCode.Name
            if KEY == "W" then
                CONTROL.F = flySpeed
            elseif KEY == "S" then
                CONTROL.B = -flySpeed
            elseif KEY == "A" then
                CONTROL.L = -flySpeed
            elseif KEY == "D" then 
                CONTROL.R = flySpeed
            elseif KEY == "E" then
                CONTROL.Q = flySpeed * 2
            elseif KEY == "Q" then
                CONTROL.E = -flySpeed * 2
            end
            pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
        end
    end)
    flyKeyUp = IYMouse.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local KEY = input.KeyCode.Name
            if KEY == "W" then
                CONTROL.F = 0
            elseif KEY == "S" then
                CONTROL.B = 0
            elseif KEY == "A" then
                CONTROL.L = 0
            elseif KEY == "D" then
                CONTROL.R = 0
            elseif KEY == "E" then
                CONTROL.Q = 0
            elseif KEY == "Q" then
                CONTROL.E = 0
            end
        end
    end)
    FLY()
end

local function NOFLY()
    FLYING = false
    if flyKeyDown then flyKeyDown:Disconnect() end
    if flyKeyUp then flyKeyUp:Disconnect() end
    if mfly1 then mfly1:Disconnect() end
    if mfly2 then mfly2:Disconnect() end
    if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
        Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
    end
    pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end

local function UnMobileFly()
    pcall(function()
        FLYING = false
        local root = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        if root:FindFirstChild("BodyVelocity") then root:FindFirstChild("BodyVelocity"):Destroy() end
        if root:FindFirstChild("BodyGyro") then root:FindFirstChild("BodyGyro"):Destroy() end
        if Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
            Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").PlatformStand = false
        end
        if mfly1 then mfly1:Disconnect() end
        if mfly2 then mfly2:Disconnect() end
    end)
end

local function MobileFly()
    UnMobileFly()
    FLYING = true

    local root = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    local camera = workspace.CurrentCamera
    local v3none = Vector3.new()
    local v3zero = Vector3.new(0, 0, 0)
    local v3inf = Vector3.new(9e9, 9e9, 9e9)

    local controlModule = require(Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
    local bv = Instance.new("BodyVelocity")
    bv.Name = "BodyVelocity"
    bv.Parent = root
    bv.MaxForce = v3zero
    bv.Velocity = v3zero

    local bg = Instance.new("BodyGyro")
    bg.Name = "BodyGyro"
    bg.Parent = root
    bg.MaxTorque = v3inf
    bg.P = 1000
    bg.D = 50

    mfly1 = Players.LocalPlayer.CharacterAdded:Connect(function()
        local newRoot = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        local newBv = Instance.new("BodyVelocity")
        newBv.Name = "BodyVelocity"
        newBv.Parent = newRoot
        newBv.MaxForce = v3zero
        newBv.Velocity = v3zero

        local newBg = Instance.new("BodyGyro")
        newBg.Name = "BodyGyro"
        newBg.Parent = newRoot
        newBg.MaxTorque = v3inf
        newBg.P = 1000
        newBg.D = 50
    end)

    mfly2 = game:GetService("RunService").RenderStepped:Connect(function()
        root = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        camera = workspace.CurrentCamera
        if Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") and root and root:FindFirstChild("BodyVelocity") and root:FindFirstChild("BodyGyro") then
            local humanoid = Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
            local VelocityHandler = root:FindFirstChild("BodyVelocity")
            local GyroHandler = root:FindFirstChild("BodyGyro")

            VelocityHandler.MaxForce = v3inf
            GyroHandler.MaxTorque = v3inf
            humanoid.PlatformStand = true
            GyroHandler.CFrame = camera.CoordinateFrame
            VelocityHandler.Velocity = v3none

            local direction = controlModule:GetMoveVector()
            if direction.X > 0 then
                VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * (flySpeed * 50))
            end
            if direction.X < 0 then
                VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * (flySpeed * 50))
            end
            if direction.Z > 0 then
                VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * (flySpeed * 50))
            end
            if direction.Z < 0 then
                VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * (flySpeed * 50))
            end
        end
    end)
end

local Tabs = {}

Tabs.Combat = Window:Tab({
    Title = "光环功能",
    Icon = "sword",
    Desc = "Stellar"
})
Tabs.Main = Window:Tab({
    Title = "主要功能",
    Icon = "sparkles",
    Desc = "Atomic"
})
Tabs.Auto = Window:Tab({
    Title = "自动功能",
    Icon = "wrench",
    Desc = "Atomic"
})
Tabs.Fishing = Window:Tab({
    Title = "钓鱼功能",
    Icon = "anchor", 
    Desc = "Atomic"
})
Tabs.AutoFarmTab = Window:Tab({
    Title = "种树功能",
    Icon = "flame",
    Desc = "Atomic"
})
Tabs.Collection = Window:Tab({
    Title = "收集功能",
    Icon = "package",
    Desc = "Stellar"
})
Tabs.esp = Window:Tab({
    Title = "透视功能",
    Icon = "eye",
    Desc = "Atomic"
})
Tabs.Tp = Window:Tab({
    Title = "传送功能",
    Icon = "map",
    Desc = "Atomic"
})
Tabs.Fly = Window:Tab({
    Title = "玩家修改",
    Icon = "user",
    Desc = "Atomic"
})

Tabs.More = Window:Tab({
    Title = "刷钻石",
    Icon = "crown",
    Desc = "Atomic"
})


Tabs.NPC = Window:Tab({
    Title = "控制NPC",
    Icon = "crown",
    Desc = "Atomic"
})

Tabs.mutou1 = Window:Tab({
    Title = "视觉效果",
    Icon = "crown",
    Desc = "Atomic"
})

Window:SelectTab(1)

Tabs.Combat:Section({ Title = "光环", Icon = "star" })

local DefaultChopTreeDistance = 20
local DefaultKillAuraDistance = 20

if not DistanceForAutoChopTree then
    DistanceForAutoChopTree = DefaultChopTreeDistance
end
if not DistanceForKillAura then
    DistanceForKillAura = DefaultKillAuraDistance
end

Tabs.Combat:Input({
    Title = "自动砍树范围",
    Value = tostring(DefaultChopTreeDistance),
    Callback = function(value)
        local numValue = tonumber(value)
        if numValue then
            DistanceForAutoChopTree = numValue
        else
            warn("请输入有效的数字！")
        end
    end
})

Tabs.Combat:Toggle({
    Title = "自动砍树",
    Description = "自动砍树",
    Default = false,
    Callback = function(Value)
        ActiveAutoChopTree = Value
        task.spawn(function()
            while ActiveAutoChopTree do
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local hrp = character:WaitForChild("HumanoidRootPart")
                local weapon = (player.Inventory:FindFirstChild("Old Axe") or player.Inventory:FindFirstChild("Good Axe") or player.Inventory:FindFirstChild("Strong Axe") or player.Inventory:FindFirstChild("Chainsaw"))
                
                task.spawn(function()
                    for _, tree in pairs(workspace.Map.Foliage:GetChildren()) do
                        if tree:IsA("Model") and (tree.Name == "Small Tree" or tree.Name == "TreeBig1" or tree.Name == "TreeBig2") and tree.PrimaryPart then
                            local distance = (tree.PrimaryPart.Position - hrp.Position).Magnitude
                            if distance <= DistanceForAutoChopTree then
                                game:GetService("ReplicatedStorage").RemoteEvents.ToolDamageObject:InvokeServer(tree, weapon, 999, hrp.CFrame)
                            end
                        end
                    end
                end)
                
                task.spawn(function()
                    for _, tree in pairs(workspace.Map.Landmarks:GetChildren()) do
                        if tree:IsA("Model") and (tree.Name == "Small Tree" or tree.Name == "TreeBig1" or tree.Name == "TreeBig2") and tree.PrimaryPart then
                            local distance = (tree.PrimaryPart.Position - hrp.Position).Magnitude
                            if distance <= DistanceForAutoChopTree then
                                game:GetService("ReplicatedStorage").RemoteEvents.ToolDamageObject:InvokeServer(tree, weapon, 999, hrp.CFrame)
                            end
                        end
                    end
                end)
                
                task.wait(0.1)
            end
        end)
    end
})

Tabs.Combat:Input({
    Title = "杀戮光环攻击范围",
    Value = tostring(DefaultKillAuraDistance),
    Callback = function(value)
        local numValue = tonumber(value)
        if numValue then
            DistanceForKillAura = numValue
        else
            warn("请输入有效的数字！")
        end
    end
})

Tabs.Combat:Toggle({
    Title = "杀戮光环",
    Description = "杀戮光环",
    Default = false,
    Callback = function(Value)
        ActiveKillAura = Value
        task.spawn(function()
            while ActiveKillAura do
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local hrp = character:WaitForChild("HumanoidRootPart")
                local weapon = (player.Inventory:FindFirstChild("Old Axe") or 
                               player.Inventory:FindFirstChild("Good Axe") or 
                               player.Inventory:FindFirstChild("Strong Axe") or 
                               player.Inventory:FindFirstChild("Chainsaw") or 
                               player.Inventory:FindFirstChild("Morningstar") or 
                               player.Inventory:FindFirstChild("Spear"))
                
                task.spawn(function()
                    for _, enemy in pairs(workspace.Characters:GetChildren()) do
                        if enemy:IsA("Model") and enemy.PrimaryPart then
                            local distance = (enemy.PrimaryPart.Position - hrp.Position).Magnitude
                            if distance <= DistanceForKillAura then
                                game:GetService("ReplicatedStorage").RemoteEvents.ToolDamageObject:InvokeServer(enemy, weapon, 999, hrp.CFrame)
                            end
                        end
                    end
                end)
                
                task.wait(0.1)
            end
        end)
    end
})

Tabs.Main:Section({ Title = "自动吃食物", Icon = "utensils" })
Tabs.Main:Dropdown({
    Title = "选择食物",
    Desc = "自己选择",
    Values = translateList(alimentos),
    Value = NameToDisplay[ShenChouFood],
    Multi = false,
    Callback = function(value)
        ShenChouFood = DisplayToName[value] or value
    end
})

Tabs.Main:Input({
    Title = "进食%",
    Desc = "当饥饿达到多少%时进食",
    Value = tostring(hungerThreshold),
    Placeholder = "例如: 75",
    Numeric = true,
    Callback = function(value)
        local n = tonumber(value)
        if n then
            hungerThreshold = math.clamp(n, 0, 100)
        end
    end
})

Tabs.Main:Toggle({
    Title = "自动进食",
    Value = false,
    Callback = function(state)
        autoFeedxipro = state
        if state then
            task.spawn(function()
                while autoFeedxipro do
                    task.wait(0.075)
                    if wiki(ShenChouFood) == 0 then
                        autoFeedxipro = false
                        notifeed(ShenChouFood)
                        break
                    end
                    if ghn() <= hungerThreshold then
                        feed(ShenChouFood)
                    end
                end
            end)
        end
    end
})

Tabs.Auto:Section({ Title = "营火", Icon = "flame" })

local autoUpgradeCampfireXIPRO = false

Tabs.Auto:Dropdown({
    Title = "升级营火",
    Desc = "选择要使用的物品",
    Values = translateList(campfireFuelItems),
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        local selectedInternalNames = {}
        for _, displayName in ipairs(options) do
            table.insert(selectedInternalNames, DisplayToName[displayName] or displayName)
        end

        for _, itemName in ipairs(campfireFuelItems) do
            alwaysFeedXXIIPPRROOItems[itemName] = table.find(selectedInternalNames, itemName) ~= nil
        end
    end
})

Tabs.Auto:Toggle({
    Title = "自动升级营火",
    Value = false,
    Callback = function(checked)
        autoUpgradeCampfireXIPRO = checked
        if checked then
            task.spawn(function()
                while autoUpgradeCampfireXIPRO do
                    for itemName, enabled in pairs(alwaysFeedXXIIPPRROOItems) do
                        if enabled then
                            for _, item in ipairs(workspace:WaitForChild("Items"):GetChildren()) do
                                if item.Name == itemName then
                                    moveItemToPos(item, campfireDropPos)
                                end
                            end
                        end
                    end
                    task.wait(2)
                end
            end)
        end
    end
})

Tabs.Auto:Section({ Title = "烹饪食物", Icon = "flame" })

Tabs.Auto:Dropdown({
    Title = "选择需要烹饪的食物",
    Values = translateList(autocookItems),
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        local selectedInternalNames = {}
        for _, displayName in ipairs(options) do
            table.insert(selectedInternalNames, DisplayToName[displayName] or displayName)
        end
        for _, itemName in ipairs(autocookItems) do
            autoCookxiproItems[itemName] = table.find(selectedInternalNames, itemName) ~= nil
        end
    end
})
Tabs.Auto:Toggle({
    Title = "自动烹饪食物",
    Value = false,
    Callback = function(state)
        autoCookxipro = state
    end
})

-- 优化自动烹饪循环
local autoCookConnection
task.spawn(function()
    while true do
        if autoCookxipro then
            if not autoCookConnection then
                autoCookConnection = task.spawn(function()
                    while autoCookxipro do
                        for itemName, enabled in pairs(autoCookxiproItems or {}) do
                            if enabled then
                                for _, item in ipairs(Workspace:WaitForChild("Items"):GetChildren()) do
                                    if item.Name == itemName then
                                        moveItemToPos(item, campfireDropPos)
                                        task.wait(0.1) -- 减少等待时间
                                    end
                                end
                            end
                        end
                        task.wait(1) -- 增加主循环等待时间
                    end
                    autoCookConnection = nil
                end)
            end
        else
            if autoCookConnection then
                -- 正确停止协程的方式
                autoCookxipro = false
                autoCookConnection = nil
            end
        end
        task.wait(2) -- 减少检查频率
    end
end)

Tabs.Fishing:Section({ Title = "自动钓鱼", Icon = "settings" })

Tabs.Fishing:Toggle({
    Title = "自动钓鱼",
    Default = false,
    Callback = function(Value)
        getgenv().AutoFishing = Value
        
        if Value then
            -- 启动自动钓鱼
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")

            local player = Players.LocalPlayer
            local playerGui = player:WaitForChild("PlayerGui")

            task.wait(1)

            local fishingCatchFrame = playerGui.Interface.FishingCatchFrame
            local timingBar = fishingCatchFrame.TimingBar
            local successArea = timingBar.SuccessArea
            local bar = timingBar.Bar
            local button = playerGui.MobileButtons.Frame.Button3

            local function checkOverlap(f1, f2)
                local p1 = f1.AbsolutePosition
                local s1 = f1.AbsoluteSize
                local p2 = f2.AbsolutePosition
                local s2 = f2.AbsoluteSize
                
                return not (
                    p1.X + s1.X < p2.X or
                    p2.X + s2.X < p1.X or
                    p1.Y + s1.Y < p2.Y or
                    p2.Y + s2.Y < p1.Y
                )
            end

            local function clickButton()
                for _, connection in pairs(getconnections(button.MouseButton1Down)) do
                    connection:Fire()
                end
            end

            local canClick = true

            -- 保存连接以便可以断开
            if getgenv().FishingConnection then
                getgenv().FishingConnection:Disconnect()
            end

            getgenv().FishingConnection = RunService.Heartbeat:Connect(function()
                if getgenv().AutoFishing and fishingCatchFrame.Visible and timingBar.Visible then
                    if checkOverlap(successArea, bar) and canClick then
                        canClick = false
                        clickButton()
                        task.wait(0.1)  
                        canClick = true
                    end
                else
                    canClick = true
                end
            end)
            
            WindUI:Notify({
                Title = "自动钓鱼",
                Content = "自动钓鱼已开启",
                Duration = 3
            })
        else
            -- 关闭自动钓鱼
            if getgenv().FishingConnection then
                getgenv().FishingConnection:Disconnect()
                getgenv().FishingConnection = nil
            end
            WindUI:Notify({
                Title = "自动钓鱼",
                Content = "自动钓鱼已关闭",
                Duration = 3
            })
        end
    end
})

Tabs.Tp:Section({ Title = "传送", Icon = "map" })

Tabs.Tp:Button({
    Title = "传送到营火",
    Locked = false,
    Callback = function()
        tp1()
    end
})

Tabs.Tp:Button({
    Title = "传送到要塞",
    Locked = false,
    Callback = function()
        tp2()
    end
})


Tabs.Tp:Section({ Title = "孩子", Icon = "eye" })

local MobDropdown = Tabs.Tp:Dropdown({
    Title = "孩子",
    Values = currentMobNames,
    Multi = false,
    AllowNone = true,
    Callback = function(options)
        ShenChouMob = options[#options] or currentMobNames[1] or nil
    end
})

Tabs.Tp:Button({
    Title = "刷新列表",
    Locked = false,
    Callback = function()
        currentMobs, currentMobNames = getMobs()
        if #currentMobNames > 0 then
            ShenChouMob = currentMobNames[1]
            MobDropdown:Refresh(currentMobNames)
        else
            ShenChouMob = nil
            MobDropdown:Refresh({ "没有孩子选择" })
        end
    end
})

Tabs.Tp:Button({
    Title = "传送孩子",
    Locked = false,
    Callback = function()
        if ShenChouMob and currentMobs then
            for i, name in ipairs(currentMobNames) do
                if name == ShenChouMob then
                    local targetMob = currentMobs[i]
                    if targetMob then
                        local part = targetMob.PrimaryPart or targetMob:FindFirstChildWhichIsA("BasePart")
                        if part and game.Players.LocalPlayer.Character then
                            local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                hrp.CFrame = part.CFrame + Vector3.new(0, 5, 0)
                            end
                        end
                    end
                    break
                end
            end
        end
    end
})


Tabs.Tp:Section({ Title = "宝箱", Icon = "box" })

local ChestDropdown = Tabs.Tp:Dropdown({
    Title = "选择宝箱",
    Values = currentChestNames,
    Multi = false,
    AllowNone = true,
    Callback = function(options)
        ShenChouChest = options[#options] or currentChestNames[1] or nil
    end
})

Tabs.Tp:Button({
    Title = "刷新列表",
    Locked = false,
    Callback = function()
        currentChests, currentChestNames = getChests()
        if #currentChestNames > 0 then
            ShenChouChest = currentChestNames[1]
            ChestDropdown:Refresh(currentChestNames)
        else
            ShenChouChest = nil
            ChestDropdown:Refresh({ "没有宝箱选择" })
        end
    end
})

Tabs.Tp:Button({
    Title = "传送到宝箱",
    Locked = false,
    Callback = function()
        if ShenChouChest and currentChests then
            local chestIndex = 1
            for i, name in ipairs(currentChestNames) do
                if name == ShenChouChest then
                    chestIndex = i
                    break
                end
            end
            local targetChest = currentChests[chestIndex]
            if targetChest then
                local part = targetChest.PrimaryPart or targetChest:FindFirstChildWhichIsA("BasePart")
                if part and game.Players.LocalPlayer.Character then
                    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = part.CFrame + Vector3.new(0, 5, 0)
                    end
                end
            end
        end
    end
})


Tabs.Collection:Section({ Title = "全局设置", Icon = "settings" })
Tabs.Collection:Input({
    Title = "收集数量 (-1为全部)",
    Placeholder = "-1",
    Callback = function(text)
        local num = tonumber(text)
        if num then
            Config.Bring.quantity = math.floor(num)
            Utils.notify("设置成功", "收集数量已设为: " .. (Config.Bring.quantity == -1 and "全部" or Config.Bring.quantity), 3)
        else
            Utils.notify("输入错误", "请输入一个有效的数字。", 3)
        end
    end
})

Tabs.Collection:Input({
    Title = "收集间隔 (秒, 建议0.05)",
    Placeholder = "0.05",
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 0 then
            Config.Bring.interval = num
            Utils.notify("设置成功", "收集间隔已设为: " .. Config.Bring.interval .. " 秒", 3)
        else
            Utils.notify("输入错误", "请输入一个有效的非负数。", 3)
        end
    end
})

Tabs.Collection:Section({ Title = "一键收集", Icon = "box-open" })

Tabs.Collection:Button({
    Title = "收集全部物品",
    Callback = function()
        BringModule.bringItemsV1("", "全部物品")
    end
})

-- 用于存储每个分类下选中的物品
local selectedItemsByCategory = {}

-- 动态生成分类收集UI
for _, category in ipairs(itemCategories) do
    Tabs.Collection:Section({ Title = "收集" .. category.title, Icon = category.icon })
    

    selectedItemsByCategory[category.title] = {}
    

    table.sort(category.items)

    Tabs.Collection:Dropdown({
        Title = "选择物品",
        Values = translateList(category.items),
        Multi = true,
        AllowNone = true,
        Callback = function(options)
            local internalNames = {}
            for _, displayName in ipairs(options) do
                table.insert(internalNames, DisplayToName[displayName] or displayName)
            end
            selectedItemsByCategory[category.title] = internalNames
        end
    })

    Tabs.Collection:Button({
        Title = "收集选中的" .. category.title,
        Callback = function()
            local itemsToCollect = selectedItemsByCategory[category.title]
            
            if not itemsToCollect or #itemsToCollect == 0 then
                Utils.notify("提示", "您没有在“" .. category.title .. "”分类下选择任何物品。", 3)
                return
            end

            task.spawn(function()
                Utils.notify("开始收集", "正在收集 " .. #itemsToCollect .. " 种" .. category.title .. "...", 3)
                for _, itemName in ipairs(itemsToCollect) do
                    BringModule.bringItemsV1(itemName, NameToDisplay[itemName] or itemName)
                end
            end)
        end
    })
end



Tabs.Fly:Section({ Title = "主要", Icon = "eye" })

Tabs.Fly:Slider({
    Title = "飞行速度",
    Value = { Min = 1, Max = 20, Default = 1 },
    Callback = function(value)
        flySpeed = value
        if FLYING then
            task.spawn(function()
                while FLYING do
                    task.wait(0.1)
                    if game:GetService("UserInputService").TouchEnabled then
                        local root = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if root and root:FindFirstChild("BodyVelocity") then
                            local bv = root:FindFirstChild("BodyVelocity")
                            bv.Velocity = bv.Velocity.Unit * (flySpeed * 50)
                        end
                    end
                end
            end)
        end
    end
})

Tabs.Fly:Toggle({
    Title = "飞行",
    Value = false,
    Callback = function(state)
        flyToggle = state
        if flyToggle then
            if game:GetService("UserInputService").TouchEnabled then
                MobileFly()
            else
                sFLY()
            end
        else
            NOFLY()
            UnMobileFly()
        end
    end
})

local Players = game:GetService("Players")
local speed = 16

local function setSpeed(val)
    local humanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.WalkSpeed = val end
end


Tabs.Fly:Slider({
    Title = "加速速度",
    Value = { Min = 16, Max = 150, Default = 16 },
    Callback = function(value)
        speed = value
    end
})

Tabs.Fly:Toggle({
    Title = "加速",
    Value = false,
    Callback = function(state)
        setSpeed(state and speed or 16)
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local noclipConnection

Tabs.Fly:Toggle({
    Title = "穿墙",
    Value = false,
    Callback = function(state)
        if state then
            noclipConnection = RunService.Stepped:Connect(function()
                local char = Players.LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
        end
    end
})

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local infJumpConnection

Tabs.Fly:Toggle({
    Title = "无限跳",
    Value = false,
    Callback = function(state)
        if state then
            infJumpConnection = UserInputService.JumpRequest:Connect(function()
                local char = Players.LocalPlayer.Character
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if infJumpConnection then
                infJumpConnection:Disconnect()
                infJumpConnection = nil
            end
        end
    end
})

Tabs.Fly:Section({ Title = "秒杀队友", Icon = "zap" })

local killConfig = {
    enabled = false,
    delay = 0.2,
    maxDistance = 50, -- 最大检测距离
    minDistance = 5   -- 最小检测距离
}

Tabs.Fly:Toggle({
    Title = "自动秒杀队友",
    Desc = "自动在附近队友脚下放置熊陷阱",
    Default = false,
    Callback = function(state)
        killConfig.enabled = state
        if state then
            WindUI:Notify({
                Title = "秒杀已启用",
                Content = "开始自动秒杀附近队友 (距离: " .. killConfig.minDistance .. "-" .. killConfig.maxDistance .. ")",
                Duration = 3
            })
            startAutoKill()
        else
            if autoKillConnection then
                autoKillConnection:Disconnect()
                autoKillConnection = nil
            end
            WindUI:Notify({
                Title = "秒杀已禁用", 
                Content = "停止自动秒杀",
                Duration = 3
            })
        end
    end
})

Tabs.Fly:Button({
    Title = "手动放置陷阱",
    Desc = "在最近的队友脚下放置陷阱",
    Callback = function()
        local target, distance = getNearestPlayer()
        if target and distance then
            local success = placeTrapOnPlayer(target)
            if success then
                WindUI:Notify({
                    Title = "手动放置",
                    Content = "成功在 " .. target.Name .. " 脚下放置陷阱 (距离: " .. math.floor(distance) .. ")",
                    Duration = 3
                })
            else
                WindUI:Notify({
                    Title = "放置失败",
                    Content = "无法放置陷阱，可能没有可用的熊陷阱",
                    Duration = 3
                })
            end
        else
            WindUI:Notify({
                Title = "未找到目标",
                Content = "在有效距离内没有找到队友",
                Duration = 3
            })
        end
    end
})

Tabs.Fly:Slider({
    Title = "最大检测距离",
    Desc = "设置检测队友的最大距离",
    Value = {Min = 10, Max = 100, Default = killConfig.maxDistance},
    Step = 5,
    Callback = function(val)
        killConfig.maxDistance = val
    end
})

Tabs.Fly:Slider({
    Title = "最小检测距离",
    Desc = "设置检测队友的最小距离",
    Value = {Min = 1, Max = 20, Default = killConfig.minDistance},
    Step = 1,
    Callback = function(val)
        killConfig.minDistance = val
    end
})

local function getNearestPlayer()
    local myChar = LocalPlayer.Character
    if not myChar then return nil end
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return nil end

    local nearest, distance = nil, math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and humanoid.Health > 0 and rootPart then
                local dist = (rootPart.Position - myHrp.Position).Magnitude
                
                -- 检查距离是否在有效范围内
                if dist >= killConfig.minDistance and dist <= killConfig.maxDistance and dist < distance then
                    distance, nearest = dist, player
                end
            end
        end
    end
    
    return nearest, distance
end

local function placeTrapOnPlayer(player)
    if not player or not player.Character then return false end
    
    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end

    local success = false
    pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
        local requestStartDrag = remoteEvents:WaitForChild("RequestStartDraggingItem")
        local requestStopDrag = remoteEvents:WaitForChild("StopDraggingItem")
        local requestSetTrap = remoteEvents:WaitForChild("RequestSetTrap")
        
        local workspace = game:GetService("Workspace")
        local itemsFolder = workspace:FindFirstChild("Items")
        if not itemsFolder then return end

        -- 查找可用的熊陷阱
        local availableTrap = nil
        for _, trap in ipairs(itemsFolder:GetChildren()) do
            if trap.Name == "Bear Trap" and trap:IsA("Model") then
                local trapPart = trap:FindFirstChildWhichIsA("BasePart")
                if trapPart and trapPart.CanCollide then
                    availableTrap = trap
                    break
                end
            end
        end

        if availableTrap then
            -- 设置陷阱位置（稍微偏移避免重叠）
            local trapPosition = rootPart.Position + Vector3.new(0, -2, 0)
            
            requestStartDrag:FireServer(availableTrap)
            task.wait(0.05)
            availableTrap:SetPrimaryPartCFrame(CFrame.new(trapPosition))
            task.wait(0.05)
            requestStopDrag:FireServer(availableTrap)
            task.wait(0.05)
            requestSetTrap:FireServer(availableTrap)
            success = true
        end
    end)
    
    return success
end

local autoKillConnection = nil

local function startAutoKill()
    if autoKillConnection then
        autoKillConnection:Disconnect()
        autoKillConnection = nil
    end
    
    autoKillConnection = task.spawn(function()
        while killConfig.enabled do
            pcall(function()
                local target, distance = getNearestPlayer()
                if target and distance then
                    local success = placeTrapOnPlayer(target)
                    if success then
                        WindUI:Notify({
                            Title = "陷阱放置",
                            Content = "成功在 " .. target.Name .. " 脚下放置陷阱",
                            Duration = 2
                        })
                    end
                end
            end)
            task.wait(killConfig.delay)
        end
        autoKillConnection = nil
    end)
end

local hitboxSettings = {
    Wolf = false,
    Bunny = false,
    Cultist = false,
    All = false,
    Show = false,
    Size = 10
}

local function updateHitboxForModel(model)
    local root = model:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local name = model.Name:lower()

    if hitboxSettings.All then
        root.Size = Vector3.new(hitboxSettings.Size, hitboxSettings.Size, hitboxSettings.Size)
        root.Transparency = hitboxSettings.Show and 0.5 or 1
        root.Color = Color3.fromRGB(255, 255, 255)
        root.Material = Enum.Material.Neon
        root.CanCollide = false
        return
    end

    local shouldResize =
        (hitboxSettings.Wolf and (name:find("wolf") or name:find("alpha"))) or
        (hitboxSettings.Bunny and name:find("bunny")) or
        (hitboxSettings.Cultist and (name:find("cultist") or name:find("cross")))

    if shouldResize then
        root.Size = Vector3.new(hitboxSettings.Size, hitboxSettings.Size, hitboxSettings.Size)
        root.Transparency = hitboxSettings.Show and 0.5 or 1
        root.Color = Color3.fromRGB(255, 255, 255)
        root.Material = Enum.Material.Neon
        root.CanCollide = false
    end
end

-- 优化hitbox更新循环
local hitboxConnection
local function startHitboxLoop()
    if hitboxConnection then return end
    
    hitboxConnection = task.spawn(function()
        while true do
            local models = {}
            for _, model in ipairs(workspace:GetDescendants()) do
                if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") then
                    table.insert(models, model)
                end
            end
            
            for _, model in ipairs(models) do
                updateHitboxForModel(model)
            end
            task.wait(3) -- 增加等待时间减少CPU使用
        end
    end)
end

startHitboxLoop()


function createESPText(part, text, color)
    if part:FindFirstChild("ESPTexto") then return end

    local esp = Instance.new("BillboardGui")
    esp.Name = "ESPTexto"
    esp.Adornee = part
    esp.Size = UDim2.new(0, 100, 0, 20)
    esp.StudsOffset = Vector3.new(0, 2.5, 0)
    esp.AlwaysOnTop = true
    esp.MaxDistance = 300

    local label = Instance.new("TextLabel")
    label.Parent = esp
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(255,255,0)
    label.TextStrokeTransparency = 0.2
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold

    esp.Parent = part
end

local function Aesp(nome, tipo)
    local container
    local color
    if tipo == "item" then
        container = workspace:FindFirstChild("Items")
        color = Color3.fromRGB(0, 255, 0)
    elseif tipo == "mob" then
        container = workspace:FindFirstChild("Characters")
        color = Color3.fromRGB(255, 255, 0)
    else
        return
    end
    if not container then return end

    for _, obj in ipairs(container:GetChildren()) do
        if obj.Name == nome then
            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
            if part then
                createESPText(part, NameToDisplay[obj.Name] or obj.Name, color)
            end
        end
    end
end

local function Desp(nome, tipo)
    local container
    if tipo == "item" then
        container = workspace:FindFirstChild("Items")
    elseif tipo == "mob" then
        container = workspace:FindFirstChild("Characters")
    else
        return
    end
    if not container then return end

    for _, obj in ipairs(container:GetChildren()) do
        if obj.Name == nome then
            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
            if part then
                for _, gui in ipairs(part:GetChildren()) do
                    if gui:IsA("BillboardGui") and gui.Name == "ESPTexto" then
                        gui:Destroy()
                    end
                end
            end
        end
    end
end

local ShenChouItems = {}
local ShenChouMobs = {}
local espItemsxipro = false
local espMobsxipro = false
local espConnections = {}

Tabs.esp:Section({ Title = "Esp物品", Icon = "package" })

Tabs.esp:Dropdown({
    Title = "选择Esp物品",
    Values = translateList(ie),
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        local internalNames = {}
        for _, displayName in ipairs(options) do
            table.insert(internalNames, DisplayToName[displayName] or displayName)
        end
        ShenChouItems = internalNames
        
        if espItemsxipro then
            for _, name in ipairs(ie) do
                if table.find(ShenChouItems, name) then
                    Aesp(name, "item")
                else
                    Desp(name, "item")
                end
            end
        else
            for _, name in ipairs(ie) do
                Desp(name, "item")
            end
        end
    end
})

Tabs.esp:Toggle({
    Title = "开启Esp",
    Value = false,
    Callback = function(state)
        espItemsxipro = state
        for _, name in ipairs(ie) do
            if state and table.find(ShenChouItems, name) then
                Aesp(name, "item")
            else
                Desp(name, "item")
            end
        end

        if state then
            if not espConnections["Items"] then
                local container = workspace:FindFirstChild("Items")
                if container then
                    espConnections["Items"] = container.ChildAdded:Connect(function(obj)
                        if table.find(ShenChouItems, obj.Name) then
                            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                            if part then
                                createESPText(part, NameToDisplay[obj.Name] or obj.Name, Color3.fromRGB(0, 255, 0))
                            end
                        end
                    end)
                end
            end
        else
            if espConnections["Items"] then
                espConnections["Items"]:Disconnect()
                espConnections["Items"] = nil
            end
        end
    end
})

Tabs.esp:Section({ Title = "Esp实体", Icon = "user" })

Tabs.esp:Dropdown({
    Title = "选择Esp实体",
    Values = translateList(me),
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        local internalNames = {}
        for _, displayName in ipairs(options) do
            table.insert(internalNames, DisplayToName[displayName] or displayName)
        end
        ShenChouMobs = internalNames

        if espMobsxipro then
            for _, name in ipairs(me) do
                if table.find(ShenChouMobs, name) then
                    Aesp(name, "mob")
                else
                    Desp(name, "mob")
                end
            end
        else
            for _, name in ipairs(me) do
                Desp(name, "mob")
            end
        end
    end
})

Tabs.esp:Toggle({
    Title = "开启Esp",
    Value = false,
    Callback = function(state)
        espMobsxipro = state
        for _, name in ipairs(me) do
            if state and table.find(ShenChouMobs, name) then
                Aesp(name, "mob")
            else
                Desp(name, "mob")
            end
        end

        if state then
            if not espConnections["Mobs"] then
                local container = workspace:FindFirstChild("Characters")
                if container then
                    espConnections["Mobs"] = container.ChildAdded:Connect(function(obj)
                        if table.find(ShenChouMobs, obj.Name) then
                            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                            if part then
                                createESPText(part, NameToDisplay[obj.Name] or obj.Name, Color3.fromRGB(255, 255, 0))
                            end
                        end
                    end)
                end
            end
        else
            if espConnections["Mobs"] then
                espConnections["Mobs"]:Disconnect()
                espConnections["Mobs"] = nil
            end
        end
    end
})

Tabs.Main:Section({ Title = "其他", Icon = "settings" })

local instantInteractxipro = false
local instantInteractConnection
local originalHoldDurations = {}

Tabs.Main:Toggle({
    Title = "秒互动",
    Value = false,
    Callback = function(state)
        instantInteractxipro = state

        if state then
            originalHoldDurations = {}
            instantInteractConnection = task.spawn(function()
                while instantInteractxipro do
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") then
                            if originalHoldDurations[obj] == nil then
                                originalHoldDurations[obj] = obj.HoldDuration
                            end
                            obj.HoldDuration = 0
                        end
                    end
                    task.wait(0.5)
                end
            end)
        else
            if instantInteractConnection then
                instantInteractxipro = false
            end
            for obj, value in pairs(originalHoldDurations) do
                if obj and obj:IsA("ProximityPrompt") then
                    obj.HoldDuration = value
                end
            end
            originalHoldDurations = {}
        end
    end
})

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local torchxipro = nil

Tabs.Main:Toggle({
    Title = "自动眩晕鹿",
    Value = false,
    Callback = function(state)
        if state then
            torchxipro = RunService.RenderStepped:Connect(function()
                pcall(function()
                    local remote = ReplicatedStorage:FindFirstChild("RemoteEvents")
                        and ReplicatedStorage.RemoteEvents:FindFirstChild("DeerHitByTorch")
                    local deer = workspace:FindFirstChild("Characters")
                        and workspace.Characters:FindFirstChild("Deer")
                    if remote and deer then
                        remote:InvokeServer(deer)
                    end
                end)
                task.wait(0.1)
            end)
        else
            if torchxipro then
                torchxipro:Disconnect()
                torchxipro = nil
            end
        end
    end
})

Tabs.Main:Button({
    Title = "打开全部宝箱",
    Callback = function()

        task.spawn(openAllChests)
    end
})

Tabs.Main:Toggle({
    Title = "无敌",
    Description = "无敌了",
    Value = false,
    Callback = function(state)
        godModeActive = state
        if state then
            Utils.notify("锁血", "已开启", 2)
        else
            Utils.notify("锁血", "已关闭", 2)
        end
    end
})

-- 优化无敌模式循环
local godModeConnection
local function startGodModeLoop()
    if godModeConnection then return end
    
    godModeConnection = task.spawn(function()
        while true do
            if godModeActive then
                pcall(function()
                    ReplicatedStorage.RemoteEvents.DamagePlayer:FireServer(-math.huge)
                end)
                task.wait(0.1) -- 减少等待时间提高响应性
            else
                task.wait(1) -- 当未激活时减少检查频率
            end
        end
    end)
end

startGodModeLoop()

Tabs.More:Section({ Title = "自动刷钻石", Icon = "gem" })
Tabs.More:Section({ Title = "自动刷钻石", Icon = "info" })

Tabs.More:Button({
    Title = "自动刷钻石",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/kuy/refs/heads/main/dyhub99night.lua"))()
    end
})

Tabs.mutou1:Section({ Title = "用木头造出帅气的造型", Icon = "info" })

local teleportConfig = {
pattern = "sphere",  
speed = 5,        
radius = 75,       
height = 100       
}

local patternOptions = {
["球形"] = "sphere",
["项链"] = "star",
["流星"] = "meteor"
}

local centerPosition = Vector3.new(0.6491832137107849, teleportConfig.height, -3.8000376224517822)
local rotationAngle = 0
local teleporting = false

local function generatePatternPositions(itemCount)
local positions = {}
rotationAngle = rotationAngle + teleportConfig.speed * 0.01

if teleportConfig.pattern == "sphere" then
for i = 1, itemCount do
local phi = math.acos(-1 + (2 * i - 1) / itemCount)
local theta = math.sqrt(itemCount * math.pi) * phi

local x = teleportConfig.radius * math.cos(theta + rotationAngle) * math.sin(phi)
local y = teleportConfig.radius * math.sin(theta + rotationAngle) * math.sin(phi)
local z = teleportConfig.radius * math.cos(phi)

table.insert(positions, centerPosition + Vector3.new(x, y, z))
end
elseif teleportConfig.pattern == "star" then
local points = 5
for i = 1, itemCount do
local angle = (i / itemCount) * math.pi * 2 * points + rotationAngle
local radius = teleportConfig.radius * (i % 2 == 0 and 0.5 or 1)

local x = radius * math.cos(angle)
local z = radius * math.sin(angle)

table.insert(positions, centerPosition + Vector3.new(x, 0, z))
end
elseif teleportConfig.pattern == "meteor" then
for i = 1, itemCount do
local angle = (i / itemCount) * math.pi * 2 + rotationAngle
local x = teleportConfig.radius * math.cos(angle)
local z = teleportConfig.radius * math.sin(angle)
local y = teleportConfig.radius * 0.5 * math.sin(angle * 2)

table.insert(positions, centerPosition + Vector3.new(x, y, z))
end
end

return positions
end

local function teleportLogs()
if teleporting then return end
teleporting = true

local logs = {}
for _, item in pairs(workspace.Items:GetChildren()) do
if item.Name:lower():find("log") and item:IsA("Model") then
table.insert(logs, item)
end
end

if #logs > 0 then
local positions = generatePatternPositions(#logs)

for i, log in ipairs(logs) do
local main = log:FindFirstChildWhichIsA("BasePart")
if main then
local targetPos = positions[i] or positions[1]
main.CFrame = CFrame.new(targetPos)
main.AssemblyLinearVelocity = Vector3.new(0, 0, 0)  
end
end
end

teleporting = false
end

Tabs.mutou1:Dropdown({
Title = "选择图案",
Values = {"球形", "项链", "流星"},
Value = "球形",
Callback = function(option)
teleportConfig.pattern = patternOptions[option]
end
})

Tabs.mutou1:Input({
Title = "旋转速度",
Desc = "设置旋转速度",
Value = tostring(teleportConfig.speed),
Placeholder = "输入旋转速度",
Callback = function(input)
local num = tonumber(input)
if num and num >= 1 and num <= 10 then
teleportConfig.speed = num
end
end
})

Tabs.mutou1:Input({
Title = "图案大小",
Desc = "设置图案大小",
Value = tostring(teleportConfig.radius),
Placeholder = "输入图案大小",
Callback = function(input)
local num = tonumber(input)
if num and num >= 10 and num <= 50 then
teleportConfig.radius = num
end
end
})

local teleportLoop = nil

Tabs.mutou1:Toggle({
Title = "自动形成图案",
Default = false,
Callback = function(state)
if teleportLoop then
teleportLoop:Disconnect()
teleportLoop = nil
end

if state then
teleportLoop = game:GetService("RunService").Heartbeat:Connect(function()
teleportLogs()
end)
end
end
})
local plantingConfig = {
    shape = "square",  
    size = 80,        
    height = 3,     
    spacing = 1,       
    delay = 1          
}

local shapeOptions = {
    ["正方形"] = "square",
    ["圆形"] = "circle",
    ["原地"] = "original"
}
local function generatePlantPositions()
    local positions = {}
    local halfSize = plantingConfig.size / 2
    local playerPosition = Vector3.new(0.6491832137107849, plantingConfig.height, -3.8000376224517822)
    
    if plantingConfig.shape == "square" then
     
        positions = {}
        
       
        
        for x = -halfSize, halfSize, plantingConfig.spacing do
            table.insert(positions, Vector3.new(playerPosition.X + x, playerPosition.Y, playerPosition.Z + halfSize))
        end
        
      
        for z = halfSize, -halfSize, -plantingConfig.spacing do
            table.insert(positions, Vector3.new(playerPosition.X + halfSize, playerPosition.Y, playerPosition.Z + z))
        end
        
        
        for x = halfSize, -halfSize, -plantingConfig.spacing do
            table.insert(positions, Vector3.new(playerPosition.X + x, playerPosition.Y, playerPosition.Z - halfSize))
        end
        
  
        for z = -halfSize, halfSize, plantingConfig.spacing do
            table.insert(positions, Vector3.new(playerPosition.X - halfSize, playerPosition.Y, playerPosition.Z + z))
        end
    elseif plantingConfig.shape == "circle" then
       
        positions = {}
        
    
        local radius = halfSize
        local circumference = 2 * math.pi * radius
        local pointCount = math.floor(circumference / plantingConfig.spacing)
        
        for i = 1, pointCount do
            local angle = (i / pointCount) * 2 * math.pi
            local x = radius * math.cos(angle)
            local z = radius * math.sin(angle)
            table.insert(positions, Vector3.new(playerPosition.X + x, playerPosition.Y, playerPosition.Z + z))
        end
    else
     
        positions = {}
        
      
        table.insert(positions, Vector3.new(playerPosition.X, playerPosition.Y, playerPosition.Z))
    end
    
    return positions
end

local saplingPositions = generatePlantPositions()
local currentSaplingIndex = 1
local isPlanting = false

local function plantSapling()
    if isPlanting then return false end
    isPlanting = true
    
    local success = false
    local remoteEvents = game:GetService("ReplicatedStorage").RemoteEvents
    local tempStorage = game:GetService("ReplicatedStorage").TempStorage
    
    local sapling = tempStorage:FindFirstChild("Sapling")
    if not sapling then
        sapling = workspace.Items:FindFirstChild("Sapling")
    end
    
    if sapling then
        local plantPosition = saplingPositions[currentSaplingIndex]
        
        pcall(function()
            remoteEvents.StopDraggingItem:FireServer(sapling)
            task.wait(0.1)
            remoteEvents.RequestPlantItem:InvokeServer(sapling, plantPosition)
            success = true
        end)
        
        currentSaplingIndex = currentSaplingIndex + 1
        if currentSaplingIndex > #saplingPositions then
            currentSaplingIndex = 1
        end
    end
    
    isPlanting = false
    return success
end

Tabs.AutoFarmTab:Dropdown({
    Title = "种植形状",
    Values = {"正方形", "圆形", "原地"},
    Value = "正方形",
    Callback = function(option)
        plantingConfig.shape = shapeOptions[option]
        saplingPositions = generatePlantPositions()
        currentSaplingIndex = 1
    end
})

Tabs.AutoFarmTab:Input({
    Title = "种植范围(米)",
    Desc = "设置种植范围大小",
    Value = tostring(plantingConfig.size),
    Placeholder = "输入范围大小",
    Callback = function(input)
        local num = tonumber(input)
        if num and num > 0 then
            plantingConfig.size = num
            saplingPositions = generatePlantPositions()
            currentSaplingIndex = 1
        end
    end
})

Tabs.AutoFarmTab:Input({
    Title = "种植高度",
    Desc = "设置种植高度",
    Value = tostring(plantingConfig.height),
    Placeholder = "输入高度",
    Callback = function(input)
        local num = tonumber(input)
        if num then
            plantingConfig.height = num
            saplingPositions = generatePlantPositions()
            currentSaplingIndex = 1
        end
    end
})

Tabs.AutoFarmTab:Input({
    Title = "树苗间隔(米)",
    Desc = "设置树苗之间的间隔[推荐2.5]",
    Value = tostring(plantingConfig.spacing),
    Placeholder = "输入间隔距离",
    Callback = function(input)
        local num = tonumber(input)
        if num and num > 0 then
            plantingConfig.spacing = num
            saplingPositions = generatePlantPositions()
            currentSaplingIndex = 1
        end
    end
})

Tabs.AutoFarmTab:Input({
    Title = "种植延迟(秒)",
    Desc = "设置每次种植的延迟时间",
    Value = tostring(plantingConfig.delay),
    Placeholder = "输入延迟时间",
    Callback = function(input)
        local num = tonumber(input)
        if num and num > 0 then
            plantingConfig.delay = num
        end
    end
})

local plantLoop = nil

Tabs.AutoFarmTab:Toggle({
    Title = "自动种植",
    Default = false,
    Callback = function(state)
        if plantLoop then
            plantLoop:Disconnect()
            plantLoop = nil
        end
        
        if state then
            plantLoop = game:GetService("RunService").Heartbeat:Connect(function()
                local planted = plantSapling()
                if not planted then
                    task.wait(1)
                else
                    task.wait(plantingConfig.delay)
                end
            end)
        end
    end
})

Tabs.NPC:Section({ Title = "NPC控制", Icon = "info" })

local lighting = game:GetService("Lighting")
local tweenservice = game:GetService("TweenService")
local rs = game:GetService("RunService")
local ws = game:GetService("Workspace")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local mouse = LP:GetMouse()

local currentnpc = nil
local clicknpc = true
local networkvis = false
local punishedNPCs = {}
local punishAuraEnabled = false
local punishAuraPositions = {}

local highlight = Instance.new("Highlight")
highlight.Parent = LP
highlight.FillTransparency = 1
highlight.OutlineTransparency = 1

local function light(adornee, color)
    task.spawn(function()
        highlight.Adornee = adornee
        highlight.OutlineColor = color
        tweenservice:Create(highlight, TweenInfo.new(0.5), {OutlineTransparency = 0}):Play()
        task.wait(0.5)
        tweenservice:Create(highlight, TweenInfo.new(0.5), {OutlineTransparency = 1}):Play()
    end)        
end

local function isnpc(ins)
    if not ins:IsA("Model") then return false end
    local humanoid = ins:FindFirstChildOfClass("Humanoid")
    local player = Players:GetPlayerFromCharacter(ins)
    return humanoid and not player
end

local function partowner(part)
    return part and part:IsA("BasePart") and part.ReceiveAge == 0
end

local function Noti(text)
    -- 使用WindUI通知系统
    WindUI:Notify({
        Title = "通知",
        Content = text,
        Duration = 3
    })
end

-- 创建光环部分
local AuraSection = Tabs.NPC:Section({
    Title = "光环功能",
    Side = "Right"
})

-- 点击选择NPC
Tabs.NPC:Toggle({
    Title = "点击选择NPC",
    Default = false,
    Callback = function(state)
        clicknpc = state
    end
})

-- 显示NetworkOwner
Tabs.NPC:Toggle({
    Title = "显示NetworkOwner",
    Default = false,
    Callback = function(state)
        networkvis = state
        pcall(function()
            settings().Physics.AreOwnersShown = networkvis
        end)
    end
})

-- 杀死NPC按钮
Tabs.NPC:Button({
    Title = "杀死NPC",
    Desc = "立即杀死选中的NPC",
    Callback = function()
        if currentnpc then
            local part = currentnpc:FindFirstChild("HumanoidRootPart")
            if part and partowner(part) then
                local hum = currentnpc:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Dead)
                    light(currentnpc, Color3.fromRGB(0, 255, 0))
                end
            else
                light(currentnpc, Color3.fromRGB(255, 0, 0))
            end
        else
            Noti("没有选中NPC!")
        end
    end
})

-- 传送到NPC
Tabs.NPC:Button({
    Title = "传送到NPC",
    Callback = function()
        if currentnpc then
            local part = currentnpc:FindFirstChild("HumanoidRootPart")
            if part then
                if LP and LP.Character then
                    local char = LP.Character
                    local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        humanoidRootPart.CFrame = part.CFrame
                        light(currentnpc, Color3.fromRGB(0, 255, 255))
                    end
                end
            else
                light(currentnpc, Color3.fromRGB(255, 0, 0))
            end
        else
            Noti("没有选中NPC!")
        end
    end
})

-- 传送NPC到玩家
Tabs.NPC:Button({
    Title = "传送NPC到玩家",
    Callback = function()
        if currentnpc then
            local part = currentnpc:FindFirstChild("HumanoidRootPart")
            if part and partowner(part) then
                if LP and LP.Character then
                    local char = LP.Character
                    local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        part.CFrame = humanoidRootPart.CFrame
                        light(currentnpc, Color3.fromRGB(0, 255, 0))
                    end
                end
            else
                light(currentnpc, Color3.fromRGB(255, 0, 0))
            end
        else
            Noti("没有选中NPC!")
        end
    end
})

-- 控制NPC
local controlConnection
local controlToggle = Tabs.NPC:Toggle({
    Title = "控制NPC",
    Default = false,
    Callback = function(state)
        if state then
            if currentnpc then
                local part = currentnpc:FindFirstChild("HumanoidRootPart")
                if part and partowner(part) then
                    if LP and LP.Character then
                        local originalCharacter = LP.Character
                        LP.Character = currentnpc
                        ws.CurrentCamera.CameraSubject = currentnpc:FindFirstChildOfClass("Humanoid")
                        local move = 0.01
                        controlConnection = rs.PreSimulation:Connect(function()
                            if LP.Character and LP.Character == currentnpc then
                                local hum = currentnpc:FindFirstChildOfClass("Humanoid")
                                local rootPart = currentnpc:FindFirstChild("HumanoidRootPart")
                                if hum and rootPart then
                                    rootPart.CFrame = rootPart.CFrame + Vector3.new(0, move, 0)
                                    move = -move
                                end
                            else
                                if controlConnection then
                                    controlConnection:Disconnect()
                                    controlConnection = nil
                                end
                            end
                        end)
                        light(currentnpc, Color3.fromRGB(0, 255, 0))
                    end
                else
                    light(currentnpc, Color3.fromRGB(255, 0, 0))
                    controlToggle:Set(false)
                end
            else
                Noti("没有选中NPC!")
                controlToggle:Set(false)
            end
        else
            if LP.Character then
                LP.Character = LP.Character
                ws.CurrentCamera.CameraSubject = LP.Character:FindFirstChildOfClass("Humanoid")
                if controlConnection then
                    controlConnection:Disconnect()
                    controlConnection = nil
                end
            end
        end
    end
})

-- 切换坐下状态
Tabs.NPC:Button({
    Title = "切换坐下状态",
    Callback = function()
        if currentnpc then
            local part = currentnpc:FindFirstChild("HumanoidRootPart")
            if part and partowner(part) then
                local hum = currentnpc:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.Sit = not hum.Sit
                    light(currentnpc, Color3.fromRGB(0, 255, 0))
                end
            else
                light(currentnpc, Color3.fromRGB(255, 0, 0))
            end
        else
            Noti("没有选中NPC!")
        end
    end
})

-- NPC跟随玩家
local followConnection
local followToggle = Tabs.NPC:Toggle({
    Title = "NPC跟随玩家",
    Default = false,
    Callback = function(state)
        if state then
            if currentnpc then
                followConnection = rs.RenderStepped:Connect(function()
                    if currentnpc and currentnpc.Parent then
                        local part = currentnpc:FindFirstChild("HumanoidRootPart")
                        if part and partowner(part) then
                            local hum = currentnpc:FindFirstChildOfClass("Humanoid")
                            if hum then
                                local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    hum:MoveTo(hrp.Position + Vector3.new(-4, 0, 0))
                                end
                            end
                        else
                            light(currentnpc, Color3.fromRGB(255, 0, 0))
                            if followConnection then
                                followToggle:Set(false)
                                followConnection:Disconnect()
                                followConnection = nil
                            end
                        end
                    else
                        if followConnection then
                            followToggle:Set(false)
                            followConnection:Disconnect()
                            followConnection = nil
                        end
                    end
                end)
                light(currentnpc, Color3.fromRGB(0, 255, 0))
            else
                Noti("没有选中NPC!")
                followToggle:Set(false)
            end
        else
            if followConnection then
                followConnection:Disconnect()
                followConnection = nil
            end
        end
    end
})

-- 查看NPC视角
local viewToggle = Tabs.NPC:Toggle({
    Title = "查看NPC视角",
    Default = false,
    Callback = function(state)
        if state then
            if currentnpc then
                local part = currentnpc:FindFirstChild("HumanoidRootPart")
                if part then
                    ws.CurrentCamera.CameraSubject = part
                    light(currentnpc, Color3.fromRGB(0, 255, 255))
                else
                    light(currentnpc, Color3.fromRGB(255, 0, 0))
                    viewToggle:Set(false)
                end
            else
                Noti("没有选中NPC!")
                viewToggle:Set(false)
            end
        else
            if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
                ws.CurrentCamera.CameraSubject = LP.Character:FindFirstChildOfClass("Humanoid")
            end
        end
    end
})

-- 冻结NPC
local freezeToggle = Tabs.NPC:Toggle({
    Title = "冻结NPC",
    Default = false,
    Callback = function(state)
        if state then
            if currentnpc then
                local part = currentnpc:FindFirstChild("HumanoidRootPart")
                if part and partowner(part) then
                    part.Anchored = true
                    light(currentnpc, Color3.fromRGB(135, 206, 235))
                else
                    light(currentnpc, Color3.fromRGB(255, 0, 0))
                    freezeToggle:Set(false)
                end
            else
                Noti("没有选中NPC!")
                freezeToggle:Set(false)
            end
        else
            if currentnpc then
                local part = currentnpc:FindFirstChild("HumanoidRootPart")
                if part and partowner(part) then
                    part.Anchored = false
                    light(currentnpc, Color3.fromRGB(0, 255, 0))
                else
                    light(currentnpc, Color3.fromRGB(255, 0, 0))
                end
            end
        end
    end
})

-- 自动杀死NPC光环
local killAuraConnection
local killAuraToggle = AuraSection:Toggle({
    Title = "自动杀死NPC",
    Default = false,
    Callback = function(state)
        if state then
            killAuraConnection = rs.Stepped:Connect(function()
                local hrp1 = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if not hrp1 then return end

                for _, npc in pairs(workspace:GetChildren()) do
                    if isnpc(npc) then
                        local hrp = npc:FindFirstChild("HumanoidRootPart")
                        if hrp and partowner(hrp) and not hrp.Anchored and npc ~= LP.Character then
                            local distance = (hrp1.Position - hrp.Position).Magnitude
                            if distance <= 13 then
                                local hum = npc:FindFirstChildOfClass("Humanoid")
                                if hum then
                                    hum:ChangeState(Enum.HumanoidStateType.Dead)
                                end
                            end
                        end
                    end
                end
            end)
        else
            if killAuraConnection then
                killAuraConnection:Disconnect()
                killAuraConnection = nil
            end
        end
    end
})

-- NPC跳跃按钮
Tabs.NPC:Button({
    Title = "NPC跳跃",
    Callback = function()
        local hrp1 = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not hrp1 then return end

        for _, npc in pairs(workspace:GetChildren()) do
            if isnpc(npc) then
                local hrp = npc:FindFirstChild("HumanoidRootPart")
                if hrp and partowner(hrp) and not hrp.Anchored and npc ~= LP.Character then
                    local distance = (hrp1.Position - hrp.Position).Magnitude
                    if distance <= 13 then
                        local hum = npc:FindFirstChildOfClass("Humanoid")
                        if hum then
                            hum:ChangeState(Enum.HumanoidStateType.Jumping)
                        end
                    end
                end
            end
        end
    end
})

-- NPC冻结光环
local freezeAuraConnection
local freezeAuraToggle = AuraSection:Toggle({
    Title = "NPC冻结光环",
    Default = false,
    Callback = function(state)
        if state then
            freezeAuraConnection = rs.Stepped:Connect(function()
                local hrp1 = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if not hrp1 then return end

                for _, npc in pairs(workspace:GetChildren()) do
                    if isnpc(npc) then
                        local hrp = npc:FindFirstChild("HumanoidRootPart")
                        if hrp and partowner(hrp) and npc ~= LP.Character then
                            local distance = (hrp1.Position - hrp.Position).Magnitude
                            if distance <= 13 then
                                hrp.Anchored = true
                            end
                        end
                    end
                end
            end)
        else
            if freezeAuraConnection then
                freezeAuraConnection:Disconnect()
                freezeAuraConnection = nil
                -- 解冻所有NPC
                for _, npc in pairs(workspace:GetChildren()) do
                    if isnpc(npc) then
                        local hrp = npc:FindFirstChild("HumanoidRootPart")
                        if hrp and partowner(hrp) and npc ~= LP.Character then
                            hrp.Anchored = false
                        end
                    end
                end
            end
        end
    end
})

-- NPC传送到太空
local punishAuraConnection
local punishAuraToggle = AuraSection:Toggle({
    Title = "NPC传送到太空",
    Default = false,
    Callback = function(state)
        if state then
            punishAuraEnabled = true
            punishAuraConnection = rs.Stepped:Connect(function()
                local hrp1 = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if not hrp1 then return end

                for _, npc in pairs(workspace:GetChildren()) do
                    if isnpc(npc) then
                        local hrp = npc:FindFirstChild("HumanoidRootPart")
                        if hrp and partowner(hrp) and npc ~= LP.Character then
                            local distance = (hrp1.Position - hrp.Position).Magnitude
                            if distance <= 13 then
                                if not punishAuraPositions[npc] then
                                    punishAuraPositions[npc] = npc:GetPivot()
                                end
                                npc:PivotTo(CFrame.new(0, 1000, 0))
                            end
                        end
                    end
                end
            end)
        else
            punishAuraEnabled = false
            if punishAuraConnection then
                punishAuraConnection:Disconnect()
                punishAuraConnection = nil
                -- 恢复所有NPC位置
                for npc, originalPosition in pairs(punishAuraPositions) do
                    if npc and npc.Parent then
                        npc:PivotTo(originalPosition)
                    end
                end
                punishAuraPositions = {}
            end
        end
    end
})

-- 模拟半径设置
local simRadius = 150
local simConnection
Tabs.NPC:Slider({
    Title = "模拟半径",
    Desc = "设置模拟半径大小",
    Min = 10,
    Max = 500,
    Default = 150,
    Callback = function(value)
        simRadius = value
    end
})

simConnection = rs.RenderStepped:Connect(function()
    pcall(function()
        if sethiddenproperty then
            sethiddenproperty(LP, "SimulationRadius", simRadius)
        else
            LP.SimulationRadius = simRadius
        end
    end)
end)

-- 鼠标点击选择NPC
local mouseConnection = mouse.Button1Down:Connect(function()
    if clicknpc and mouse.Target then
        local targetModel = mouse.Target.Parent
        if targetModel:IsA("Model") then
            local hrp = targetModel:FindFirstChild("HumanoidRootPart")
            if hrp and not hrp.Anchored then
                if not Players:GetPlayerFromCharacter(targetModel) then
                    if partowner(hrp) then
                        currentnpc = targetModel
                        light(currentnpc, Color3.fromRGB(0, 255, 0))
                        Noti("已选择NPC: " .. currentnpc.Name)
                    else
                        light(targetModel, Color3.fromRGB(255, 0, 0))
                        Noti("NPC没有网络所有权")
                    end
                else
                    Noti("目标是玩家，不是NPC")
                end
            else
                if hrp then
                    light(targetModel, Color3.fromRGB(255, 0, 0))
                    Noti("NPC已锚定")
                end
            end
        end
    end
end)

-- 清理连接
game:GetService("UserInputService").WindowFocusReleased:Connect(function()
    -- 重新连接必要的连接
    if not simConnection or not simConnection.Connected then
        simConnection = rs.RenderStepped:Connect(function()
            pcall(function()
                if sethiddenproperty then
                    sethiddenproperty(LP, "SimulationRadius", simRadius)
                else
                    LP.SimulationRadius = simRadius
                end
            end)
        end)
    end
end)

-- 玩家离开时清理
LP.AncestryChanged:Connect(function()
    if not LP.Parent then
        -- 清理所有连接
        local connections = {
            simConnection, mouseConnection, controlConnection, 
            followConnection, killAuraConnection, freezeAuraConnection, 
            punishAuraConnection
        }
        
        for _, connection in pairs(connections) do
            if connection then
                connection:Disconnect()
            end
        end
    end
end)




