local Notice = {
    {date = "2025-08-05", desc = "脚本用不了就受着呗\n玩Xi Pro就要学会受着"},
}
local LoadServer = {
    "最强战场",
    "Blox Fruit",
    "疯狂之城",
    "忍者传奇",
    "俄亥俄州",
    "刀刃球",
    "战争大亨",
    "Fisch",
    "Doors",
}
local LoadingSteps = {
    {text = "正在初始化系统...", progress = 0},
    {text = "检测运行环境...", progress = 8},
    {text = "加载核心模块...", progress = 18},
    {text = "初始化用户界面...", progress = 30},
    {text = "连接远程服务器...", progress = 45},
    {text = "验证用户权限...", progress = 60},
    {text = "下载游戏数据...", progress = 75},
    {text = "解析配置文件...", progress = 85},
    {text = "准备游戏列表...", progress = 95},
    {text = "神仇死妈！", progress = 100}
}
local Developers = {
    {name = "神仇", role = "主作者", desc = "项目负责人 · 核心架构", color = Color3.fromRGB(255, 100, 100)},
    {name = "123fa98", role = "副作者", desc = "功能开发 · 代码优化", color = Color3.fromRGB(100, 255, 100)},
    {name = "泡芙", role = "UI制作者", desc = "界面设计 · 用户体验", color = Color3.fromRGB(255, 200, 100)},
    {name = "Irena", role = "剪辑师", desc = "视频制作 · 宣传内容", color = Color3.fromRGB(255, 100, 255)},
    {name = "du8", role = "备用作者", desc = "代码维护 · 功能补充", color = Color3.fromRGB(100, 200, 255)},
    {name = "qumu", role = "白名单制作者", desc = "安全系统 · 权限管理", color = Color3.fromRGB(200, 255, 100)},
    {name = "小天", role = "黑客", desc = "技术研究 · 安全测试", color = Color3.fromRGB(255, 150, 200)}
}
return LoadingSteps, Notice, LoadServer, Developers
