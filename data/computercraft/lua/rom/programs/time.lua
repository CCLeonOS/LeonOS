-- time.lua: Display current time
local shell = require("shell")

-- 帮助信息函数
local function printHelp()
  print("Usage: time [options]")
  print("Options:")
  print("  --help, -h       Show this help message")
  print("  --format, -f <fmt>  Specify time format string (see below for details)")
  print("
Formats for --format option:")
  print("  %Y: Year (4 digits)")
  print("  %m: Month (01-12)")
  print("  %d: Day (01-31)")
  print("  %H: Hour (00-23)")
  print("  %M: Minute (00-59)")
  print("  %S: Second (00-59)")
  print("  %A: Full weekday name")
  print("  %B: Full month name")
  print("
Examples:")
  print("  time                     # Show current time in default format")
  print("  time --format '%Y-%m-%d %H:%M:%S'  # Show time as YYYY-MM-DD HH:MM:SS")
  print("  time -f '%A, %B %d, %Y'  # Show time as 'Monday, January 01, 2023'")
end

-- 主函数
local function main(args)
  -- 处理命令行参数
  local showHelp = false
  local formatStr = "%Y-%m-%d %H:%M:%S"
  local i = 1

  while i <= #args do
    if args[i] == "--help" or args[i] == "-h" then
      showHelp = true
    elseif args[i] == "--format" or args[i] == "-f" then
      i = i + 1
      if i <= #args then
        formatStr = args[i]
      else
        print("Error: Missing format string for --format option")
        return
      end
    else
      print("Error: Unknown option '" .. args[i] .. "'\n")
      printHelp()
      return
    end
    i = i + 1
  end

  if showHelp then
    printHelp()
    return
  end

  -- 获取并显示当前时间
  local currentTime = os.time()
  local formattedTime = os.date(formatStr, currentTime)
  print(formattedTime)
end

-- 运行主函数
local args = {...}
main(args)