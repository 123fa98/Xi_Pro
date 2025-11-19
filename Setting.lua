local Notice = {
    {date = "2025-11-19", desc = "添加通用\n添加战斗勇士\n添加Blox Fruit\n添加一路向西\n添加战争大亨"},
    {date = "2025-11-19", desc = "Atomic免费版正式开始发布使用！"},
}
local LoadServer = {
    "通用脚本",
    "战争大亨",
    "一路向西",
    "Blox Fruit",
    "战斗勇士",
    "内脏与黑火药",
    "终极战场",
    "在森林中的99夜",
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
    {text = "中国最佳脚本！", progress = 100}
}
local Developers = {
    {name = "神仇", role = "主作者", desc = "项目负责人 · 核心架构", color = Color3.fromRGB(255, 100, 100)},
    {name = "麥克丰", role = "副作者", desc = "功能开发 · 代码优化", color = Color3.fromRGB(100, 255, 100)},
}

return LoadingSteps, Notice, LoadServer, Developers
