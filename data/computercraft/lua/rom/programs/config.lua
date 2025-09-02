-- config: System configuration manager for LeonOS

local term = require("term")
local colors = require("colors")
local settings = require("settings")
local textutils = require("textutils")
local shell = require("shell")

-- 保存当前颜色设置
local old_fg = term.getTextColor()
local old_bg = term.getBackgroundColor()

-- 设置名称栏颜色并显示
term.setTextColor(colors.white)
term.setBackgroundColor(colors.cyan)
term.at(1, 1).clearLine()
term.at(1, 1).write("=== LeonOS Configuration Manager ===")

-- 恢复颜色设置
term.setTextColor(old_fg)
term.setBackgroundColor(old_bg)
term.at(1, 2)

-- 显示帮助信息
local function show_help()
  print("Usage: config <command> [options] [setting] [value]")
  print("")
  print("Commands:")
  print("  list                   List all available settings")
  print("  get <setting>          Get the value of a specific setting")
  print("  set <setting> <value>  Set the value of a specific setting")
  print("  default <setting>      Reset a setting to its default value")
  print("  save                   Save current settings to file")
  print("  help                   Show this help message")
  print("")
  print("Options:")
  print("  --details, -d          Show detailed information when listing settings")
  print("")
  print("Examples:")
  print("  config list                           # List all settings")
  print("  config list --details                 # List all settings with details")
  print("  config get list.show_hidden           # Get the value of list.show_hidden")
  print("  config set list.show_hidden true      # Set list.show_hidden to true")
  print("  config default list.show_hidden       # Reset list.show_hidden to default")
  print("  config save                           # Save current settings")
end

-- 列出所有设置
local function list_settings(detailed)
  local setting_names = settings.getNames()
  if #setting_names == 0 then
    print("No settings defined.")
    return
  end

  print("Available settings:")
  print("====================")

  for _, name in ipairs(setting_names) do
    local details = settings.getDetails(name)
    if details then
      term.setTextColor(colors.yellow)
      print(name)
      term.setTextColor(colors.white)

      if detailed then
        print("  Description: " .. (details.description or "No description"))
        print("  Type: " .. (details.type or "unknown"))
        print("  Default: " .. tostring(details.default))
        print("  Current: " .. tostring(details.value))
      else
        print("  Current: " .. tostring(details.value) .. ", Default: " .. tostring(details.default))
      end
      print("----------------")
    end
  end
end

-- 获取设置值
local function get_setting(name)
  local details = settings.getDetails(name)
  if not details then
    io.stderr:write("Error: Setting '" .. name .. "' not found.\n")
    return false
  end

  print("Setting: " .. name)
  print("Description: " .. (details.description or "No description"))
  print("Type: " .. (details.type or "unknown"))
  print("Default: " .. tostring(details.default))
  term.setTextColor(colors.yellow)
  print("Current: " .. tostring(details.value))
  term.setTextColor(colors.white)
  return true
end

-- 设置新值
local function set_setting(name, value)
  local details = settings.getDetails(name)
  if not details then
    io.stderr:write("Error: Setting '" .. name .. "' not found.\n")
    return false
  end

  -- 转换值类型
  if details.type == "boolean" then
    value = value:lower()
    if value == "true" or value == "1" then
      value = true
    elseif value == "false" or value == "0" then
      value = false
    else
      io.stderr:write("Error: Invalid boolean value. Use 'true' or 'false'.\n")
      return false
    end
  elseif details.type == "number" then
    local num = tonumber(value)
    if not num then
      io.stderr:write("Error: Invalid number value.\n")
      return false
    end
    value = num
  end

  -- 设置值
  settings.set(name, value)
  print("Set '" .. name .. "' to '" .. tostring(value) .. "'")
  print("Run 'config save' to save this change.")
  return true
end

-- 重置为默认值
local function default_setting(name)
  local details = settings.getDetails(name)
  if not details then
    io.stderr:write("Error: Setting '" .. name .. "' not found.\n")
    return false
  end

  settings.unset(name)
  print("Reset '" .. name .. "' to default value: '" .. tostring(details.default) .. "'")
  print("Run 'config save' to save this change.")
  return true
end

-- 保存设置
local function save_settings()
  if settings.save() then
    print("Settings saved successfully.")
    return true
  else
    io.stderr:write("Error: Failed to save settings.\n")
    return false
  end
end

-- 主函数
local function main(args)
  if #args == 0 then
    show_help()
    return
  end

  local command = args[1]
  local detailed = false

  -- 检查是否有--details或-d选项
  for i, arg in ipairs(args) do
    if arg == "--details" or arg == "-d" then
      detailed = true
      table.remove(args, i)
      break
    end
  end

  if command == "list" then
    list_settings(detailed)
  elseif command == "get" and #args >= 2 then
    get_setting(args[2])
  elseif command == "set" and #args >= 3 then
    set_setting(args[2], args[3])
  elseif command == "default" and #args >= 2 then
    default_setting(args[2])
  elseif command == "save" then
    save_settings()
  elseif command == "help" or command == "--help" or command == "-h" then
    show_help()
  else
    io.stderr:write("Error: Unknown command '" .. command .. "'\n")
    show_help()
  end
end

-- 解析命令行参数
local args = {...}
main(args)