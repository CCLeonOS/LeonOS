-- 示例包程序
local colors = require('colors')

function drawTopBar()
  local w, h = term.getSize()
  term.setBackgroundColor(colors.cyan)
  term.setTextColor(colors.white)
  term.setCursorPos(1, 1)
  term.clearLine()
  local title = "Example Package v1.0.0"
  local pos = math.floor((w - #title) / 2) + 1
  term.setCursorPos(pos, 1)
  term.write(title)
  term.setBackgroundColor(colors.black)
  term.setTextColor(colors.white)
  term.setCursorPos(1, 3)
end

drawTopBar()
print("\n这是一个示例包，展示了LeonOS包管理器的功能。")
print("\n使用方法:")
print("  pkg install example-pkg  - 安装此包")
print("  pkg remove example-pkg   - 卸载此包")
print("  pkg list                 - 列出已安装的包")
print("\n按任意键退出...")
os.pullEvent("key")
term.clear()
term.setCursorPos(1, 1)