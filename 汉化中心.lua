local LoadingSteps, Notice, LoadServer, Developers, List = loadstring(game:HttpGet('https://raw.githubusercontent.com/123fa98/Xi_Pro/refs/heads/main/Setting.lua'))()
local redzlib = loadstring(game:HttpGet("https://pastefy.app/5PiSO8oW/raw"))()
local Window = redzlib:MakeWindow({
    Title = "XI Pro 汉化中心",
    SubTitle = "By Xi.team",
    SaveFolder = "Redz Config"
})

local Tab = Window:MakeTab({
    Title = "主要",
    Icon = "home"
})

for Name, Link in List do
    Tab:AddButton({
        Name = Name, 
        Callback = function()
            loadstring(Link)()
        end
    })
end
