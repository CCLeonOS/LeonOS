-- rc.shell

-- 程序顶部名称栏
local term = require("term")
local colors = require("colors")
local window = require("window")

-- 保存当前颜色设置
local old_fg = term.getTextColor()
local old_bg = term.getBackgroundColor()

-- 设置名称栏颜色并显示
  term.setCursorPos(1, 1)
term.setTextColor(colors.white)
term.setBackgroundColor(colors.cyan)
term.at(1, 1).clearLine()
term.at(1, 1).write("=== LeonOS Shell ===")

-- 恢复颜色设置
term.setTextColor(old_fg)
term.setBackgroundColor(old_bg)
term.at(1, 2)

local rc = require("rc")
local fs = require("fs")
local shell = require("shell")
local thread = require("rc.thread")
local textutils = require("textutils")

if os.version then
  textutils.coloredPrint(colors.yellow, os.version(), colors.white)
else
  textutils.coloredPrint(colors.yellow, rc.version(), colors.white)
end
-- textutils.coloredPrint(colors.yellow, "Welcome using the beta version of LeonOS!"colors.white)

thread.vars().parentShell = thread.id()
shell.init(_ENV)

if not shell.__has_run_startup then
  shell.__has_run_startup = true
  if fs.exists("/startup.lua") then
    local ok, err = pcall(dofile, "/startup.lua")
    if not ok and err then
      io.stderr:write(err, "\n")
    end
  end

  if fs.exists("/startup") and fs.isDir("/startup") then
    local files = fs.list("/startup/")
    table.sort(files)

    for f=1, #files, 1 do
      local ok, err = pcall(dofile, "/startup/"..files[f])
      if not ok and err then
        io.stderr:write(err, "\n")
      end
    end
  end
end

local aliases = {
  background = "bg",
  clr = "clear",
  cp = "copy",
  dir = "list",
  foreground = "fg",
  mv = "move",
  rm = "delete",
  rs = "redstone",
  sh = "shell",
  ps = "threads",
  restart = "reboot",
  version = "ver"
}

for k, v in pairs(aliases) do
  shell.setAlias(k, v)
end

local completions = "/leonos/completions"
for _, prog in ipairs(fs.list(completions)) do
  dofile(fs.combine(completions, prog))
end

local history = {}
while true do
  term.setTextColor(colors.yellow)
  rc.write("$ "..shell.dir().." >>> ")
  term.setTextColor(colors.white)

  local text = term.read(nil, history, shell.complete)
  if #text > 0 then
    history[#history+1] = text
    
    -- 运行命令前先清除控制台内容，但保留顶部应用栏
    local w, h = term.getSize()
    term.setTextColor(colors.white)
    term.setBackgroundColor(colors.black)
    for y=2, h do
      term.at(1, y).clearLine()
    end
    term.at(1, 2)
    
    -- 定义错误处理函数
    local function showErrorWindow(errorMessage, command)
      local w, h = term.getSize()
      local winWidth, winHeight = 50, 12
      local x = math.floor((w - winWidth) / 2)
      local y = math.floor((h - winHeight) / 2)

      -- 创建错误窗口
      local errWindow = window.create(term.native(), x, y, winWidth, winHeight)
      errWindow.setVisible(true)

      -- 绘制窗口边框和标题
      errWindow.setBackgroundColor(colors.red)
      errWindow.setTextColor(colors.white)
      errWindow.at(1, 1).clearLine()
      errWindow.at(1, 1).write("=== 程序错误 ===")

      -- 绘制窗口内容背景
      errWindow.setBackgroundColor(colors.black)
      for line=2, winHeight-1 do
        errWindow.at(1, line).clearLine()
      end

      -- 显示错误信息（自动换行）
      errWindow.setTextColor(colors.red)
      errWindow.at(2, 2).write("错误信息:")
      errWindow.setTextColor(colors.white)

      local lineNum = 3
      local maxLineLength = winWidth - 4
      local messageLines = {}
      local currentLine = ""

      for word in errorMessage:gmatch("[^\s]+") do
        if #currentLine + #word + 1 > maxLineLength then
          table.insert(messageLines, currentLine)
          currentLine = word
        else
          if currentLine == "" then
            currentLine = word
          else
            currentLine = currentLine .. " " .. word
          end
        end
      end
      if currentLine ~= "" then
        table.insert(messageLines, currentLine)
      end

      for _, line in ipairs(messageLines) do
        if lineNum < winHeight - 2 then
          errWindow.at(2, lineNum).write(line)
          lineNum = lineNum + 1
        else
          errWindow.at(2, lineNum).write("...")
          break
        end
      end

      -- 绘制按钮
      errWindow.setBackgroundColor(colors.gray)
      errWindow.setTextColor(colors.white)
      errWindow.at(5, winHeight-1).write("  确认  ")
      errWindow.at(30, winHeight-1).write("  重新运行  ")

      -- 处理用户输入
      while true do
        local event, button, xPos, yPos = os.pullEvent("mouse_click")
        if yPos == winHeight-1 + y - 1 then
          -- 点击确认按钮
          if xPos >= x + 5 and xPos <= x + 12 then
            errWindow.setVisible(false)
            break
          end
          -- 点击重新运行按钮
          if xPos >= x + 30 and xPos <= x + 42 then
            errWindow.setVisible(false)
            return true
          end
        end
      end
      return false
    end

    local ok, err = shell.run(text)
    if not ok and err then
      local shouldRetry = showErrorWindow(err, text)
      if shouldRetry then
        history[#history] = nil -- 移除当前命令，避免历史记录重复
        term.at(1, 2).clearLine()
        goto continue -- 重新运行命令
      end
    end
    ::continue::
  end
end