if game.GameId ~= 1390601379 then return end

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local task_wait, getgc, type, rawget
    = task.wait, getgc, type, rawget

local getconnections = getconnections or get_signal_cons

if not (getgc and (require or getconnections)) then
    game:GetService("Players").LocalPlayer:Kick("[CW] 您的注入器不支持使用此脚本")
    return
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NetworkRemote     = ReplicatedStorage:WaitForChild("")

local function PostAntiCheatBypass()
    local LocalPlayer = game:GetService("Players").LocalPlayer

    if getconnections then
        task.spawn(function(getconnections, debug_info, string_find, task_wait)
            task.spawn(function(CharacterAdded, getconnections, debug_info, task_wait, xpcall, getupvalues, type, pcall, string_find)
                local BypassStart = os.clock()
                local Retries     = 0

                local IgnoredFunctions = {}

                while true do
                    for _, Connection in getconnections(CharacterAdded) do
                        local Function
                        pcall(function()
                            Function = Connection.Function
                        end)

                        if not Function or IgnoredFunctions[Function] then continue end

                        local Source = debug_info(Function, "s")

                        if Source and string_find(Source, "CharacterUtil") then
                            if getupvalues then
                                for _, Upvalue in getupvalues(Function) do
                                    if type(Upvalue) == "function" and debug_info(Upvalue, "s") == "ReplicatedStorage.Client.Source.AntiCheat.AntiCheatHandlerClient" then
                                        Connection:Disconnect()
                                        print(`[CW] 成功禁用反作弊监控，共重试 {Retries} 次，耗时：{(os.clock() - BypassStart) * 1000} ms`)
                                        return
                                    end
                                end
                            else
                                local IsFromAntiCheatHandler = false

                                xpcall(Function, function()
                                    IsFromAntiCheatHandler = debug_info(2, "s") == "ReplicatedStorage.Client.Source.AntiCheat.AntiCheatHandlerClient"
                                end)

                                if IsFromAntiCheatHandler then
                                    Connection:Disconnect()
                                    print(`[CW] 成功禁用反作弊监控，共重试 {Retries} 次，耗时：{(os.clock() - BypassStart) * 1000} ms`)
                                    return
                                else
                                    IgnoredFunctions[Function] = true
                                end
                            end
                        end
                    end

                    Retries += 1
                    task_wait()
                end
            end, LocalPlayer.CharacterAdded, getconnections, debug_info, task_wait, xpcall, debug.getupvalues, type, pcall, string_find)

            local Character = LocalPlayer.Character
            if Character then
                local BypassStart = os.clock()
                local Retries     = 0

                local Humanoid = Character:WaitForChild("Humanoid")

                local DisallowedSignals = {
                    Character.DescendantAdded,
                    Humanoid.StateChanged,
                    Humanoid:GetPropertyChangedSignal("WalkSpeed"),
                    Humanoid:GetPropertyChangedSignal("Velocity")
                }

                while true do
                    for Index, Signal in DisallowedSignals do
                        for _, Connection in getconnections(Signal) do
                            local Function = Connection.Function
                            local Source   = Function and debug_info(Function, "s")

                            if Source and string_find(Source, "Anti") then
                                Connection:Disconnect()
                                DisallowedSignals[Index] = nil
                                break
                            end
                        end
                    end

                    if #DisallowedSignals < 1 then
                        print(`[CW] 成功禁用反作弊运行中监控，共重试 {Retries} 次，耗时：{(os.clock() - BypassStart) * 1000} ms`)
                        return
                    end

                    Retries += 1
                    task_wait()
                end
            end
        end, getconnections, debug.info, string.find, task_wait)
    end

    if require then
        task.spawn(function(pcall, task_wait, string_find)
            local BypassStart = os.clock()
            local Retries     = 0

            local Globals = (require)(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Source"):WaitForChild("Globals"))

            while not pcall(function()
                local Environment = Globals.getEnvVariables()

                local ShouldReturnFakeValues = {}

                for Key in Environment do
                    if string_find(Key, "acCode") then
                        Environment[Key] = nil
                        ShouldReturnFakeValues[Key] = true
                    end
                end

                setmetatable(Environment, {
                    __index = function(_, Key)
                        if ShouldReturnFakeValues[Key] then
                            return false
                        end
                        return nil
                    end
                })
            end) do
                Retries += 1
                task_wait()
            end

            print(`[CW] 成功禁用反作弊，共重试 {Retries} 次，耗时：{(os.clock() - BypassStart) * 1000} ms`)
        end, pcall, task_wait, string.find)
    end

    LocalPlayer:WaitForChild("DataLoaded")
end

local BypassStart = os.clock()
local Retries     = 0

while true do
    for _, Garbage in getgc(true) do
        if type(Garbage) == "table" and rawget(Garbage, "generateChecksum") and rawget(Garbage, "network") == NetworkRemote then
            local OldLock = Garbage.lock
            Garbage.lock = function(...)
                Garbage.lock = error
                return OldLock(...)
            end

            print(`[CW] 成功绕过反作弊，共重试 {Retries} 次，耗时：{(os.clock() - BypassStart) * 1000} ms`)
            PostAntiCheatBypass()
            return
        end
    end

    Retries += 1

    print(`[CW] 无法匹配反作弊绕过方式，在 1 秒后重试`)
    task_wait(1)
end
