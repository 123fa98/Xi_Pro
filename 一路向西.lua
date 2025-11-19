local WindUI  = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local RS      = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunSvc  = game:GetService("RunService")
local UIS     = game:GetService("UserInputService")
local LightingSvc = game:GetService("Lighting")
local LP      = Players.LocalPlayer
local Camera  = workspace.CurrentCamera

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

local Win = WindUI:CreateWindow({
    Title = gradient("Atomic   ", Color3.fromHex("#00DBDE"), Color3.fromHex("#FC00FF")), 
    Author = gradient("一路向西", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")),
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

local Tabs = {
    Combat  = Win:Tab{Title="战斗",     Icon="sword"},
    Visual  = Win:Tab{Title="视觉",     Icon="eye"},
    Gun     = Win:Tab{Title="枪械", Icon="gun"},
    Misc    = Win:Tab{Title="杂项",     Icon="flask"},
    Buy     = Win:Tab{Title="自动购买", Icon="shopping-cart"},
    Theme   = Win:Tab{Title="主题",     Icon="palette"},
}

do
    local Aimbot_HBSize, Aimbot_HBEnable = 30, false
    local aimbot_originalProps = {}
    
    local function applyHitbox(char, enable)
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        if enable then
            if not aimbot_originalProps[root] then aimbot_originalProps[root] = {Size = root.Size, Transparency = root.Transparency, CanCollide = root.CanCollide} end
            root.Size = Vector3.new(Aimbot_HBSize, Aimbot_HBSize, Aimbot_HBSize); root.Transparency = 0.95; root.CanCollide = true;
            pcall(function() root.CollisionGroup = "Default" end)
        elseif aimbot_originalProps[root] then
            root.Size = aimbot_originalProps[root].Size; root.Transparency = aimbot_originalProps[root].Transparency; root.CanCollide = aimbot_originalProps[root].CanCollide;
            aimbot_originalProps[root] = nil
        end
    end

    Tabs.Combat:Input{Title="玩家 HitBox 尺寸", Value=tostring(Aimbot_HBSize), Callback=function(txt) Aimbot_HBSize = math.max(4, tonumber(txt) or Aimbot_HBSize) end}
    Tabs.Combat:Toggle{Title="开启玩家 HitBox", Value=false, Callback=function(flag) Aimbot_HBEnable = flag; if not flag then for _, p in ipairs(Players:GetPlayers()) do if p.Character then applyHitbox(p.Character, false) end end end; WindUI:Notify{Title="玩家 HitBox",Content=flag and "已开启" or "已关闭",Duration=2} end}
    Tabs.Combat:Divider()
    
    local aimbotTeamCheck = true
    local maxAimDistance = 500
    local showFOVCircle = true
    local fovCircleColor = Color3.new(1, 1, 1)
    
    _G.CurrentAimbotTarget = nil
    _G.LockedTarget = nil
    _G.TargetLocked = false
    _G.AimBotEnabled = false

    Tabs.Combat:Toggle{
        Title = "开启自瞄", Value = false,
        Callback = function(state)
            _G.AimBotEnabled = state
            if state then
                local predictionFactor, aimSpeed = 0.042, 10
                local holding = false

                if not _G.FOVCircle then
                    if not (getfenv().Drawing and getfenv().Drawing.new) then
                         WindUI:Notify{Title="错误",Content="Drawing library not found! FOV Circle cannot be created.",Duration=5,Color=Color3.new(1,0,0)}
                         showFOVCircle = false 
                    else
                        _G.FOVCircle = Drawing.new("Circle")
                        _G.FOVCircle.Thickness = 1
                        _G.FOVCircle.Filled = false
                        _G.FOVCircle.Transparency = 0.7
                        _G.FOVCircle.Radius = 200
                    end
                end
                
                if _G.FOVCircle then
                    _G.FOVCircle.Visible = showFOVCircle
                    _G.FOVCircle.Color = fovCircleColor
                end

                local function getClosestPlayer()
                    local closest, minDist = nil, math.huge
                    local currentRadius = _G.FOVCircle and _G.FOVCircle.Radius or 200
                    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    
                    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return nil end
                    
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            if aimbotTeamCheck and player.Team and player.Team == LP.Team then continue end

                            local worldDist = (LP.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            if worldDist > maxAimDistance then continue end

                            local head = player.Character:FindFirstChild("Head")
                            if head then
                                local screenPos, onScreen = Camera:WorldToScreenPoint(head.Position)
                                if onScreen then
                                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                                    if distance <= currentRadius and distance < minDist then
                                        closest, minDist = player, distance
                                    end
                                end
                            end
                        end
                    end
                    return closest
                end

                local function predictHead(target)
                    local head = target.Character.Head
                    local velocity = target.Character.HumanoidRootPart.AssemblyLinearVelocity or Vector3.zero
                    return head.Position + velocity * predictionFactor
                end

                _G.AimbotInputBegan = UIS.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.Touch then holding = true end end)
                _G.AimbotInputEnded = UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.Touch then holding = false; _G.CurrentAimbotTarget = nil; if _G.UpdateLockButtonVisuals then _G.UpdateLockButtonVisuals() end end end)
                
                _G.AimbotRenderStepped = RunSvc.RenderStepped:Connect(function()
                    if not _G.AimBotEnabled then return end
                    if _G.FOVCircle then
                        _G.FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    end

                    if holding then
                        local finalTarget = nil
                        
                        if _G.TargetLocked and _G.LockedTarget then
                            local char = _G.LockedTarget.Character
                            local hum = char and char:FindFirstChildOfClass("Humanoid")
                            if hum and hum.Health > 0 and Players:GetPlayerFromCharacter(char) then
                                finalTarget = _G.LockedTarget
                            else
                                _G.TargetLocked = false
                                _G.LockedTarget = nil
                                if _G.UpdateLockButtonVisuals then _G.UpdateLockButtonVisuals() end
                            end
                        else
                           finalTarget = getClosestPlayer()
                        end
                        
                        _G.CurrentAimbotTarget = finalTarget
                        if _G.UpdateLockButtonVisuals then _G.UpdateLockButtonVisuals() end

                        if finalTarget then
                            local predicted = predictHead(finalTarget)
                            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, predicted), aimSpeed * 0.1)
                        end
                    end
                end)
            else
                if _G.FOVCircle then _G.FOVCircle:Remove(); _G.FOVCircle = nil end
                if _G.AimbotInputBegan then _G.AimbotInputBegan:Disconnect(); _G.AimbotInputBegan = nil end
                if _G.AimbotInputEnded then _G.AimbotInputEnded:Disconnect(); _G.AimbotInputEnded = nil end
                if _G.AimbotRenderStepped then _G.AimbotRenderStepped:Disconnect(); _G.AimbotRenderStepped = nil end
                
                _G.TargetLocked = false; _G.LockedTarget = nil; _G.CurrentAimbotTarget = nil;
                if _G.UpdateLockButtonVisuals then _G.UpdateLockButtonVisuals() end
                if _G.LockGUIVisible then _G.SetLockGUIVisible(false) end
            end
            WindUI:Notify{Title="屏幕中心自瞄",Content=state and "已开启" or "已关闭",Duration=2}
            if _G.SetLockGUIVisible then _G.SetLockGUIVisible(state) end
        end
    }
    
    Tabs.Combat:Toggle{Title="显示FOV圈", Value=showFOVCircle, Callback=function(v) 
        showFOVCircle = v 
        if _G.FOVCircle then _G.FOVCircle.Visible = v end
    end}
    Tabs.Combat:Colorpicker{
        Title="FOV圈颜色", Default = fovCircleColor,
        Callback = function(newColor)
            fovCircleColor = newColor
            if _G.FOVCircle then _G.FOVCircle.Color = newColor end
        end
    }
    Tabs.Combat:Toggle{Title="启用队伍检测", Value=aimbotTeamCheck, Callback=function(v) aimbotTeamCheck=v end}
    Tabs.Combat:Input{Title="最大瞄准距离", Value=tostring(maxAimDistance), Callback=function(t) maxAimDistance = tonumber(t) or maxAimDistance end}
    Tabs.Combat:Input{Title="设置FOV半径", Value="200", Callback=function(txt) if tonumber(txt) and _G.FOVCircle then _G.FOVCircle.Radius = math.clamp(tonumber(txt), 10, 1000) end end}
    
    RunSvc.Heartbeat:Connect(function() 
        if not Aimbot_HBEnable then return end
        for _, p in ipairs(Players:GetPlayers()) do 
            if p ~= LP and p.Character then
                local humanoid = p.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then applyHitbox(p.Character, not humanoid.Sit and humanoid.Health > 0) else applyHitbox(p.Character, false) end
            end 
        end 
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        if _G.LockedTarget == player then
            _G.TargetLocked = false
            _G.LockedTarget = nil
            if _G.UpdateLockButtonVisuals then _G.UpdateLockButtonVisuals() end
        end
    end)
end

do
    local esp_cfg = {HL=true, BB=true, Gun=true, Distance=true, Next=0}
    local esp_color = {outlaw=Color3.fromRGB(255,60,60), cowboy=Color3.fromRGB(255,220,40), civilian=Color3.fromRGB(60,255,60)}
    local esp_track = {}
    local function teamKey(p) local n=(p.Team and p.Team.Name or ""):lower() if n:find("outlaw") then return"outlaw" elseif n:find("cowboy") then return"cowboy" end return"civilian" end
    local function handGun(p) local c=p.Character if c then for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then return t.Name end end end return"无" end
    local function getDistance(p) if not LP.Character or not LP.Character.PrimaryPart or not p.Character or not p.Character.PrimaryPart then return 0 end return math.floor((LP.Character.PrimaryPart.Position - p.Character.PrimaryPart.Position).Magnitude) end
    local function newHL(char,c3) local h=Instance.new("Highlight",char) h.FillColor,h.OutlineColor,h.Name=c3,c3,"espHL" h.FillTransparency,h.OutlineTransparency=.5,0 h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop return h end
    local function newBB(root) local bb=Instance.new("BillboardGui",root) bb.AlwaysOnTop,bb.Size,bb.StudsOffset=true,UDim2.fromOffset(220,60),Vector3.new(0,4,0) bb.Name="espBB" local l=Instance.new("TextLabel",bb) l.Size,l.BackgroundTransparency=UDim2.fromScale(1,1),1 l.Font,l.TextScaled,l.TextWrapped,l.Name=Enum.Font.SourceSansBold,true,true,"txt" l.TextStrokeTransparency,l.TextStrokeColor3=.5,Color3.new(0,0,0) return bb end
    local function clear(p) local d=esp_track[p] if not d then return end if d.hl and d.hl.Parent then d.hl:Destroy() end if d.bb and d.bb.Parent then d.bb:Destroy() end esp_track[p]=nil end
    local function update_esp(p)
        if p==LP then return end
        local humanoid = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
        if not (humanoid and humanoid.Health > 0) then clear(p) return end
        local root=p.Character.PrimaryPart
        if not root then return end
        local c3=esp_color[teamKey(p)]
        local d=esp_track[p] or{}; esp_track[p]=d
        local distance = getDistance(p)
        if esp_cfg.HL then if not d.hl or not d.hl.Parent then d.hl=newHL(p.Character,c3) end elseif d.hl then d.hl:Destroy(); d.hl=nil end
        if esp_cfg.BB then
            if not d.bb or not d.bb.Parent then d.bb=newBB(root) end
            d.bb.txt.TextColor3 = c3; local targetScale = math.clamp(120 / math.max(distance, 20), 0.4, 1.5);
            if not d.currentScale then d.currentScale = targetScale end
            d.currentScale = d.currentScale + (targetScale - d.currentScale) * 0.1
            d.bb.Size = UDim2.fromOffset(220 * d.currentScale, 60 * d.currentScale); d.bb.txt.TextTransparency = 0;
            local txt = p.Name
            if esp_cfg.Gun then txt = txt .. "\n枪:" .. handGun(p) end
            if esp_cfg.Distance then txt = txt .. "\n距离:" .. distance .. "m" end
            d.bb.txt.Text = txt
        elseif d.bb then d.bb:Destroy(); d.bb=nil end
    end
    Tabs.Visual:Toggle{Title="人物高亮", Value=true,Callback=function(v) esp_cfg.HL=v end}
    Tabs.Visual:Toggle{Title="头顶信息", Value=true,Callback=function(v) esp_cfg.BB=v end}
    Tabs.Visual:Toggle{Title="显示手持武器", Value=true,Callback=function(v) esp_cfg.Gun=v end}
    Tabs.Visual:Toggle{Title="显示距离", Value=true,Callback=function(v) esp_cfg.Distance=v end}
    RunSvc.Heartbeat:Connect(function() local t=tick() if t < esp_cfg.Next then return end esp_cfg.Next = t + 0.15 + (#Players:GetPlayers() * 0.01) for _,p in ipairs(Players:GetPlayers()) do update_esp(p) end end)
    Players.PlayerRemoving:Connect(clear)
    Tabs.Visual:Divider()
    local coneColor = Color3.fromRGB(173, 216, 230)
    local coneCreated = false
    local rainbowHatActive = false
    local function findHatHighlight() if LP.Character then local hatPart=LP.Character:FindFirstChild("ChinahatPart") if hatPart then return hatPart:FindFirstChild("ChinahatHighlight") end end return nil end
    local function updateHatColor(newColor) coneColor = newColor; local highlight=findHatHighlight() if highlight then highlight.FillColor=newColor; highlight.OutlineColor=newColor end end
    local function createCone(character)
        if not coneColor then return end
        local head=character:FindFirstChild("Head") if not head then return end
        for _,v in pairs(character:GetChildren()) do if v.Name=="ChinahatPart" then v:Destroy() end end
        local cone=Instance.new("Part", character)
        cone.Name="ChinahatPart"; cone.Size=Vector3.new(1,1,1); cone.BrickColor=BrickColor.new("White"); cone.Transparency=0.3; cone.Anchored=false; cone.CanCollide=false;
        local mesh=Instance.new("SpecialMesh",cone); mesh.MeshType=Enum.MeshType.FileMesh; mesh.MeshId="rbxassetid://1033714"; mesh.Scale=Vector3.new(1.7,1.1,1.7);
        local weld=Instance.new("Weld",cone); weld.Part0=head; weld.Part1=cone; weld.C0=CFrame.new(0,0.9,0);
        local highlight=Instance.new("Highlight",cone); highlight.Name="ChinahatHighlight"; highlight.FillColor=coneColor; highlight.FillTransparency=0.5; highlight.OutlineColor=coneColor; highlight.OutlineTransparency=0;
        coneCreated = true
    end
    LP.CharacterAdded:Connect(function(char) if coneCreated then createCone(char) end end)
    Tabs.Visual:Colorpicker{Title="斗笠颜色",Default=coneColor,Callback=function(color) if not rainbowHatActive then updateHatColor(color) end end}
    Tabs.Visual:Toggle{Title="彩虹斗笠", Value=false, Callback=function(state)
            rainbowHatActive = state
            if state then
                if not coneCreated and LP.Character then createCone(LP.Character) end
                task.spawn(function()
                    local hue=0
                    while rainbowHatActive do
                        hue = (hue + 0.005) % 1
                        updateHatColor(Color3.fromHSV(hue, 0.8, 1))
                        task.wait()
                    end
                end)
            end
            WindUI:Notify{Title="彩虹斗笠",Content=state and "已开启" or "已关闭",Duration=2}
        end
    }
    Tabs.Visual:Divider()
    local fullbrightConnections = {}
    Tabs.Visual:Toggle{Title="高亮",Value=false, Callback=function(state)
            _G.FullbrightOn=state
            if state then
                LightingSvc.Ambient=Color3.new(1,1,1); LightingSvc.Brightness=2; LightingSvc.OutdoorAmbient=Color3.new(1,1,1); LightingSvc.FogEnd=1e10;
                fullbrightConnections.a=LightingSvc:GetPropertyChangedSignal("Ambient"):Connect(function() if _G.FullbrightOn then LightingSvc.Ambient=Color3.new(1,1,1) end end)
                fullbrightConnections.b=LightingSvc:GetPropertyChangedSignal("Brightness"):Connect(function() if _G.FullbrightOn then LightingSvc.Brightness=2 end end)
            else
                for _, conn in pairs(fullbrightConnections) do conn:Disconnect() end; fullbrightConnections={}
                LightingSvc.Ambient=Color3.new(0.7,0.7,0.7); LightingSvc.Brightness=1; LightingSvc.OutdoorAmbient=Color3.new(0.7,0.7,0.7); LightingSvc.FogEnd=100000;
            end
            WindUI:Notify{Title="高亮",Content=state and "已开启" or "已关闭",Duration=2}
        end
    }
    Tabs.Visual:Toggle{Title="动态模糊 (Blur)", Value=false, Callback=function(state)
            if state then loadstring(game:HttpGet("https://raw.githubusercontent.com/ThirdScripts/Blur/refs/heads/main/blur.lua"))()
            else for _,v in ipairs(LightingSvc:GetChildren()) do if v:IsA("BlurEffect") or v:IsA("BloomEffect") then v:Destroy() end end end
            WindUI:Notify{Title="动态模糊",Content=state and "已开启" or "已关闭",Duration=2}
        end
    }
end

do
    local cfg={Max="9999",Prep="0.0001",Spr="0",RS="0.001",RA="0.0001",Shake="100"}
    local fields={{"子弹上限(MaxShots)","Max"},{"射击间隔(prepTime)","Prep"},{"精准度(Spread)","Spr"},{"换弹速度(ReloadSp)","RS"},{"换弹动画(ReloadAn)","RA"},{"后坐力(CamShake)","Shake"}}
    for _,f in ipairs(fields) do Tabs.Gun:Input{Title=f[1],Value=cfg[f[2]],Callback=function(txt) cfg[f[2]]=txt end} end
    Tabs.Gun:Button{Title="应用到全部枪",Callback=function() local cnt=0 for _,gun in pairs(GunStats) do if typeof(gun)=="table" then gun.MaxShots=tonumber(cfg.Max) or gun.MaxShots; gun.prepTime=tonumber(cfg.Prep) or gun.prepTime; gun.ReloadSpeed=tonumber(cfg.RS) or gun.ReloadSpeed; gun.ReloadAnimationSpeed=tonumber(cfg.RA) or gun.ReloadAnimationSpeed; local sp=tonumber(cfg.Spr) if sp then gun.Spread,gun.HipFireAccuracy,gun.ZoomAccuracy=sp,sp,sp end; gun.camShakeResist=tonumber(cfg.Shake) or gun.camShakeResist; cnt+=1 end end WindUI:Notify{Title="枪械属性",Content="应用到 "..cnt.." 把枪",Duration=3} end}
end
do
    local buy=false; local buyGap=0.05; local use=false; local hpThr=80; local brk=false; local brkConn;
    local lblBuy=Tabs.Misc:Paragraph{Title="",Desc="购买状态: 已停止"}; local lblUse=Tabs.Misc:Paragraph{Title="",Desc="使用状态: 已停止"};
    local function s(l,t,c) l.Desc=t; l.Color=c or Color3.new(1,1,1) end
    Tabs.Misc:Input{Title="购买间隔",Value="0.05",Callback=function(t) buyGap=tonumber(t) or buyGap end}
    Tabs.Misc:Button{Title="自动买药水",Callback=function() buy=not buy; WindUI:Notify{Title="买药水",Content=buy and"开启"or"关闭",Duration=2} if buy then s(lblBuy,"购买状态: 运行中",Color3.fromRGB(60,255,60)) task.spawn(function() while buy do RS.GeneralEvents.BuyItem:InvokeServer("Health Potion",true) task.wait(buyGap) end s(lblBuy,"购买状态: 已停止") end) end end}
    Tabs.Misc:Divider()
    Tabs.Misc:Input{Title="喝药阈值(%)",Value="80",Callback=function(t) hpThr=math.clamp(tonumber(t)or hpThr,1,99) end}
    Tabs.Misc:Button{Title="自动喝药水",Callback=function() use=not use; WindUI:Notify{Title="喝药水",Content=use and"开启"or"关闭",Duration=2} if use then s(lblUse,"使用状态: 运行中",Color3.fromRGB(60,255,60)) task.spawn(function() while use do local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if h and h.Health/h.MaxHealth*100<=hpThr then local tool=LP.Backpack:FindFirstChild("Health Potion") or LP.Character:FindFirstChild("Health Potion") if tool and tool:FindFirstChild("DrinkPotion") then tool.DrinkPotion:InvokeServer() end end task.wait(0.2) end s(lblUse,"使用状态: 已停止") end) end end}
    Tabs.Misc:Divider()
    Tabs.Misc:Toggle{Title="自动挣脱绳索",Value=false,Callback=function(f) brk=f; WindUI:Notify{Title="BreakFree",Content=f and"开启"or"关闭",Duration=2} if f and not brkConn then brkConn=RunSvc.Heartbeat:Connect(function() RS.GeneralEvents.LassoEvents:FireServer("BreakFree") end) elseif not f and brkConn then brkConn:Disconnect(); brkConn=nil end end}
    local horseHBEnable=false; local horseHBSize=15; local horseOriginalProps={}
    local function applyHorseHitbox(horse,enable) local root=horse:FindFirstChild("HumanoidRootPart") if not root then return end if enable then if not horseOriginalProps[root] then horseOriginalProps[root]={Size=root.Size,Transparency=root.Transparency,CanCollide=root.CanCollide} end root.Size=Vector3.new(horseHBSize,horseHBSize,horseHBSize); root.Transparency=0.95; root.CanCollide=true; pcall(function() root.CollisionGroup="Default" end) elseif horseOriginalProps[root] then root.Size=horseOriginalProps[root].Size; root.Transparency=horseOriginalProps[root].Transparency; root.CanCollide=horseOriginalProps[root].CanCollide; horseOriginalProps[root]=nil end end
    RunSvc.Heartbeat:Connect(function() if not horseHBEnable then if workspace:FindFirstChild("Horses") then for _,h in ipairs(workspace.Horses:GetChildren()) do if h:IsA("Model") then applyHorseHitbox(h,false) end end end; return end; local hf=workspace:FindFirstChild("Horses") if not hf then return end; for _,h in ipairs(hf:GetChildren()) do if h:IsA("Model") then local hum=h:FindFirstChildOfClass("Humanoid") if hum then applyHorseHitbox(h,hum.Health>0) else applyHorseHitbox(h,false) end end end end)
    Tabs.Misc:Divider()
    Tabs.Misc:Input{Title="马匹HitBox尺寸",Value=tostring(horseHBSize),Callback=function(txt) horseHBSize=math.max(5,tonumber(txt)or horseHBSize) end}
    Tabs.Misc:Toggle{Title="开启马匹HitBox",Value=false,Callback=function(f) horseHBEnable=f; if not f and workspace:FindFirstChild("Horses") then for _,h in ipairs(workspace.Horses:GetChildren()) do if h:IsA("Model") then applyHorseHitbox(h,false) end end end; WindUI:Notify{Title="马匹HitBox",Content=f and"已开启"or"已关闭",Duration=2} end}
end
do
    local items={{"狙击子弹","SniperAmmo"},{"生命药水","Health Potion"},{"大炸药","BIG Dynamite"},{"炸药","Dynamite"},{"霰弹子弹","ShotgunAmmo"},{"步枪子弹","RifleAmmo"},{"手枪子弹","PistolAmmo"}}
    local st,thd={}, {}; local gap=0.2
    Tabs.Buy:Input{Title="全局间隔",Value="0.2",Callback=function(t) gap=math.max(0.05,tonumber(t)or gap) end}
    Tabs.Buy:Divider()
    for _,it in ipairs(items) do local n,id=it[1],it[2]; st[id]=false; Tabs.Buy:Toggle{Title="自动购买："..n,Callback=function(on) st[id]=on; WindUI:Notify{Title="自动购买",Content=n.." "..(on and"开启"or"关闭"),Duration=2} if on then thd[id]=task.spawn(function() while st[id] do RS.GeneralEvents.BuyItem:InvokeServer(id,true) task.wait(gap) end end) elseif thd[id] then task.cancel(thd[id]); thd[id]=nil end end} end
end
do
    local cur=WindUI:GetCurrentTheme(); local lib=WindUI:GetThemes()
    local function safe(c) return typeof(c)=="Color3" and c or Color3.new(1,1,1) end
    Tabs.Theme:Dropdown{Title="切换主题",Values=(function(t) local a={} for k in pairs(t)do table.insert(a,k) end return a end)(lib),Value=cur,Callback=function(n) cur=n; WindUI:SetTheme(n) end}
    Tabs.Theme:Divider()
    Tabs.Theme:Colorpicker{Title="Accent 颜色",Default=safe(lib[cur].Accent),Callback=function(c) lib[cur].Accent=c; WindUI:AddTheme(lib[cur]); WindUI:SetTheme(cur) end}
    Tabs.Theme:Colorpicker{Title="Outline 颜色",Default=safe(lib[cur].Outline),Callback=function(c) lib[cur].Outline=c; WindUI:AddTheme(lib[cur]); WindUI:SetTheme(cur) end}
end

do
    local LockGUI = Instance.new("ScreenGui")
    LockGUI.Name = "LockTargetGUI"
    LockGUI.ZIndexBehavior = Enum.ZIndexBehavior.Global
    LockGUI.ResetOnSpawn = false
    LockGUI.Parent = LP:WaitForChild("PlayerGui")
    
    local LockButton = Instance.new("TextButton")
    LockButton.Name = "LockButton"
    LockButton.Size = UDim2.fromOffset(150, 40)
    LockButton.Position = UDim2.new(1, -160, 1, -50)
    LockButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    LockButton.TextColor3 = Color3.new(1, 1, 1)
    LockButton.Font = Enum.Font.SourceSansBold
    LockButton.TextSize = 16
    LockButton.Text = "锁定目标"
    LockButton.Draggable = true
    LockButton.Active = true
    LockButton.Parent = LockGUI
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = LockButton
    
    _G.LockGUIVisible = false
    LockGUI.Enabled = false

    _G.SetLockGUIVisible = function(visible)
        _G.LockGUIVisible = visible
        LockGUI.Enabled = visible
    end

    _G.UpdateLockButtonVisuals = function()
        if not _G.LockGUIVisible then return end

        if _G.TargetLocked and _G.LockedTarget then
            LockButton.BackgroundColor3 = Color3.fromRGB(40, 180, 80)
            LockButton.Text = "已锁定: " .. _G.LockedTarget.Name
        else
            LockButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
            if _G.CurrentAimbotTarget then
                 LockButton.Text = "锁定: " .. _G.CurrentAimbotTarget.Name
            else
                 LockButton.Text = "锁定目标"
            end
        end
    end
    
    LockButton.MouseButton1Click:Connect(function()
        if not _G.AimBotEnabled then
             WindUI:Notify{Title="提示",Content="请先开启自瞄功能",Duration=2}
            return
        end
        
        if _G.TargetLocked then
            _G.TargetLocked = false
            _G.LockedTarget = nil
            WindUI:Notify{Title="自瞄",Content="目标已解锁",Duration=2}
        else -- 如果未锁定
            if _G.CurrentAimbotTarget then
                _G.TargetLocked = true
                _G.LockedTarget = _G.CurrentAimbotTarget
                 WindUI:Notify{Title="自瞄",Content="已锁定目标: " .. _G.LockedTarget.Name,Duration=2}
            else
                 WindUI:Notify{Title="提示",Content="请瞄准一个目标再锁定",Duration=3}
            end
        end
        
        _G.UpdateLockButtonVisuals()
    end)
end

local opt = WindUI.SetOption
opt("BackdropTransparency", 0.50); opt("UseBlocks", true); opt("BlockShadow", true)
opt("BlockShadowBlur", 8); opt("BlockShadowAlpha", 0.25); opt("BlockCornerRadius", UDim.new(0,6))
opt("BlockOutline", Color3.fromRGB(40,40,50)); opt("BlockSpacing", 8)
