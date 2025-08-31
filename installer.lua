-- LeonOS GUI Installer

local DEFAULT_ROM_DIR = "/rc"
local json, tu
local w, h
local mainWindow, progressBar, statusText

-- 确保中文字符正常显示
term.setEncoding("utf-8")

-- 下载函数
local function dl(f)
  local hand, err = http.get(f, nil, true)
  if not hand then
    error(err, 0)
  end

  local data = hand.readAll()
  hand.close()

  return data
end

-- 加载GitHub上的文件
local function ghload(f, c)
  return assert(load(dl("https://gh.catmak.name/https://raw.githubusercontent.com/"..f),
    "="..(c or f), "t", _G))()
end

-- 加载LeonOS的文件
local function rcload(f)
  return ghload(
    "Leonmmcoset/LeonOS/refs/heads/main/data/computercraft/lua/rom/"..f, f)
end

-- 初始化函数
local function init()
  -- 加载必要的库
  updateStatus("加载必要的库...")
  json = ghload("rxi/json.lua/master/json.lua", "ghload(json)")
  tu = rcload("apis/textutils.lua")
  updateStatus("库加载完成")

  -- 设置term.at函数
  function term.at(x, y)
    term.setCursorPos(x, y)
    return term
  end

  -- 获取屏幕大小
  w, h = term.getSize()

  -- 创建主窗口
  mainWindow = window.create(term.native(), 1, 1, w, h)
  mainWindow.setVisible(true)

  -- 绘制标题
  mainWindow.setTextColor(colors.yellow)
  mainWindow.setBackgroundColor(colors.black)
  mainWindow.at(2, 2).write("===== LeonOS 安装程序 ======")

  -- 创建状态文本区域
  statusText = window.create(mainWindow, 2, 4, w-2, 10)
  statusText.setTextColor(colors.white)
  statusText.setBackgroundColor(colors.black)
  statusText.clear()
  statusText.at(1, 1).write("欢迎使用LeonOS安装程序")
  statusText.at(1, 2).write("该程序将安装LeonOS到您的计算机")
  statusText.at(1, 3).write("安装过程会覆盖目标目录中的现有文件")

  -- 创建进度条
  progressBar = window.create(mainWindow, 2, h-4, w-2, 3)
  progressBar.setTextColor(colors.white)
  progressBar.setBackgroundColor(colors.gray)
  progressBar.clear()
  progressBar.at(1, 1).write("进度: ")

  -- 创建按钮
  local buttonWidth = 15
  local yesButton = window.create(mainWindow, w/2 - buttonWidth - 2, h-8, buttonWidth, 3)
  yesButton.setTextColor(colors.white)
  yesButton.setBackgroundColor(colors.green)
  yesButton.at(3, 2).write("确定")

  local noButton = window.create(mainWindow, w/2 + 2, h-8, buttonWidth, 3)
  noButton.setTextColor(colors.white)
  noButton.setBackgroundColor(colors.red)
  noButton.at(3, 2).write("取消")

  return yesButton, noButton
end

-- 更新进度条
local function updateProgress(current, total)
  progressBar.clear()
  local percentage = math.floor((current / total) * 100)
  local barWidth = w - 10
  local filledWidth = math.floor((current / total) * barWidth)

  progressBar.at(1, 1).write("进度: " .. percentage .. "%")
  progressBar.at(1, 2).setBackgroundColor(colors.gray)
  progressBar.at(1, 2).write(string.rep(" ", barWidth))
  progressBar.at(1, 2).setBackgroundColor(colors.green)
  progressBar.at(1, 2).write(string.rep(" ", filledWidth))
end

-- 更新状态文本
local function updateStatus(text)
  statusText.clear()
  local lines = {}
  for line in text:gmatch("[^
]+") do
    table.insert(lines, line)
  end
  for i, line in ipairs(lines) do
    if i <= statusText.getSize() then
      statusText.at(1, i).write(line)
    end
  end
end

-- 目录选择对话框
local function selectDirDialog(defaultDir)
  local dialogWindow = window.create(term.native(), w/4, h/4, w/2, 8)
  dialogWindow.setTextColor(colors.white)
  dialogWindow.setBackgroundColor(colors.black)
  dialogWindow.clear()
  dialogWindow.at(2, 2).write("选择安装目录")
  dialogWindow.at(2, 4).write("目录: ")
  dialogWindow.at(9, 4).write(defaultDir)

  local confirmButton = window.create(dialogWindow, dialogWindow.getSize() - 15, 6, 10, 2)
  confirmButton.setTextColor(colors.white)
  confirmButton.setBackgroundColor(colors.green)
  confirmButton.at(2, 1).write("确认")

  local dirInput = defaultDir
  local editing = true

  while editing do
    local event = table.pack(os.pullEvent())
    if event[1] == "mouse_click" then
      local x, y = event[3], event[4]
      -- 检查是否点击确认按钮
      if x >= dialogWindow.getX() + dialogWindow.getSize() - 15 and
         x <= dialogWindow.getX() + dialogWindow.getSize() - 5 and
         y >= dialogWindow.getY() + 6 and
         y <= dialogWindow.getY() + 7 then
        editing = false
      end
    elseif event[1] == "key" then
      if event[2] == keys.enter then
        editing = false
      elseif event[2] == keys.backspace then
        dirInput = dirInput:sub(1, -2)
      end
    elseif event[1] == "char" then
      dirInput = dirInput .. event[2]
    end

    dialogWindow.at(9, 4).write(string.rep(" ", 30))
    dialogWindow.at(9, 4).write(dirInput)
  end

  dialogWindow.setVisible(false)
  return dirInput
end

-- 主安装函数
local function install(romDir)
  updateStatus("正在获取仓库文件列表...\n请稍候...")

  -- 获取仓库文件列表
  local repodata = dl("https://api.github.com/repos/Leonmmcoset/LeonOS/git/trees/main?recursive=1")
  repodata = json.decode(repodata)
  updateProgress(1, 5)

  updateStatus("正在筛选文件...\n请稍候...")
  -- 筛选文件
  local look = "data/computercraft/lua/"
  local to_dl = {}
  for _, v in pairs(repodata.tree) do
    if v.path and v.path:sub(1, #look) == look then
      v.path = v.path:sub(#look + 1)
      v.real_path = v.path:gsub("^/?rom", romDir)
      to_dl[#to_dl + 1] = v
    end
  end
  updateProgress(2, 5)

  updateStatus("正在创建目录...\n请稍候...")
  -- 创建目录
  for i = #to_dl, 1, -1 do
    local v = to_dl[i]
    if v.type == "tree" then
      fs.makeDir(fs.combine(v.real_path))
      table.remove(to_dl, i)
    end
  end
  updateProgress(3, 5)

  updateStatus("正在下载文件...\n这可能需要一些时间...")
  -- 下载文件
  local done = 0
  local parallels = {}

  for i = 1, #to_dl, 1 do
    local v = to_dl[i]
    if v.type == "blob" then
      parallels[#parallels + 1] = function()
        local data = dl("https://gh.catmak.name/https://raw.githubusercontent.com/Leonmmcoset/LeonOS/refs/heads/main/data/computercraft/lua/" .. v.path)
        assert(io.open(v.real_path, "w")):write(data):close()
        done = done + 1
        updateProgress(3 + (done / #to_dl), 5)
      end
    end
  end

  parallel.waitForAll(table.unpack(parallels))
  updateProgress(4, 5)

  updateStatus("正在设置启动文件...\n请稍候...")
  -- 设置启动文件
  assert(io.open(
    fs.exists("/startup.lua") and "/unbios-rc.lua" or "/startup.lua", "w"))
    :write(dl(
      "https://gh.catmak.name/https://raw.githubusercontent.com/Leonmmcoset/LeonOS/refs/heads/main/unbios.lua"
    )):close()
  updateProgress(5, 5)

  updateStatus("安装完成!\n计算机将在3秒后重启...")
  -- 重启倒计时
  for i = 3, 1, -1 do
    statusText.at(1, 3).write("计算机将在 " .. i .. " 秒后重启...")
    os.sleep(1)
  end

  os.reboot()
end

-- 主函数
local function main()
  term.clear()
  local yesButton, noButton = init()

  while true do
    local event = table.pack(os.pullEvent())
    if event[1] == "mouse_click" then
      local x, y = event[3], event[4]

      -- 检查是否点击"确定"按钮
      if x >= yesButton.getX() and x <= yesButton.getX() + yesButton.getSize() and
         y >= yesButton.getY() and y <= yesButton.getY() + 2 then
        mainWindow.setVisible(false)
        local romDir = selectDirDialog(DEFAULT_ROM_DIR)
        if #romDir == 0 then romDir = DEFAULT_ROM_DIR end
        romDir = "/" .. shell.resolve(romDir)
        settings.set("LeonOS.rom_dir", romDir)
        settings.save()
        mainWindow.setVisible(true)
        updateStatus("开始安装LeonOS到目录: " .. romDir .. "\n请稍候...")
        install(romDir)
        break
      end

      -- 检查是否点击"取消"按钮
      if x >= noButton.getX() and x <= noButton.getX() + noButton.getSize() and
         y >= noButton.getY() and y <= noButton.getY() + 2 then
        mainWindow.setVisible(false)
        term.clear()
        print("安装已取消")
        break
      end
    end
  end
end

-- 启动程序
main()
