local Notice = {
    {date = "2025-08-07", desc = "添加99夜服务器\n添加驾驶帝国服务器\n添加压力服务器\n战争大亨添加一些功能并且修复所有bug 更新功能 RPG全图轰炸\n最强战场再更新一些美化并且修复已知bug\n修复Ohio不能加载问题\n忍者传奇加一点功能\n加载UI更新 并且添加更新公告"},
    {date = "2025-08-05", desc = "脚本用不了就受着呗\n玩Xi Pro就要学会受着"},
}
local LoadServer = {
    "汉化中心",
    "被遗弃",
    "Blox Fruit",
    "Fisch",
    "Doors",
    "最强战场",
    "疯狂之城",
    "忍者传奇",
    "俄亥俄州",
    "OHiO自动挂机换服",
    "战争大亨",
    "驾驶帝国",
    "种植花园",
    "刀刃球",
    "压力",
    "在森林生存99夜",
    "在超市生活一周",
    "死铁轨",
    "汽车经销大亨",
    "生存七天",
    "柔术无限",
    "力量传奇",
    "极速传奇",
    "Da hood",
    "一路向西",
    "nico的机器人",
    "恐鬼症",
    "僵尸起义",
    "彩虹朋友2",
    "格蕾丝",
    "跳跃对决",
    "暴力区",
    "猎杀僵尸",
    "ST封锁战线",
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
    {text = "XI中国最强！", progress = 100}
}
local Developers = {
    {name = "神仇", role = "主作者", desc = "项目负责人 · 核心架构", color = Color3.fromRGB(255, 100, 100)},
    {name = "123fa98", role = "副作者", desc = "功能开发 · 代码优化", color = Color3.fromRGB(100, 255, 100)},
    {name = "Irena", role = "剪辑师", desc = "视频制作 · 宣传内容", color = Color3.fromRGB(255, 100, 255)},
    {name = "du8", role = "备用作者", desc = "代码维护 · 功能补充", color = Color3.fromRGB(100, 200, 255)},
    {name = "qumu", role = "白名单制作者", desc = "安全系统 · 权限管理", color = Color3.fromRGB(200, 255, 100)},
    {name = "小天", role = "黑客", desc = "技术研究 · 安全测试", color = Color3.fromRGB(255, 150, 200)}
}
local List = {
    ["自动翻译"] = "https://raw.githubusercontent.com/123fa98/Xi_Pro/refs/heads/main/自动翻译.lua",
    ["力量传奇-Muscle Legends"] = "https://raw.githubusercontent.com/123fa98/Xi_Pro/refs/heads/main/力量传奇-Muscle Legends.lua",
    
}
return LoadingSteps, Notice, LoadServer, Developers, List 
