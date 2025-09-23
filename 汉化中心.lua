local List = List
local redzlib = loadstring(game:HttpGet("https://pastefy.app/5PiSO8oW/raw"))()
local Window = redzlib:MakeWindow({
    Title = "XI Pro 汉化中心",
    SubTitle = "SubTitle",
    SaveFolder = "Redz Config"
})

local Tab = Window:MakeTab({
    Title = "主要",
    Icon = "home"
})

for Name, Link in List do
  print(Name, Link)
end
