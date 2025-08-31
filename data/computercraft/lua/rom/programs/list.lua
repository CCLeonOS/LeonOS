-- list

local args = {...}

local fs = require("fs")
local shell = require("shell")
local colors = require("colors")
local settings = require("settings")
local textutils = require("textutils")

if #args == 0 then args[1] = shell.dir() end

local show_hidden = settings.get("list.show_hidden")
local show_details = false

-- 检查是否有显示详细信息的参数
for i=1, #args, 1 do
  if args[i] == "-l" then
    show_details = true
    table.remove(args, i)
    break
  end
end

-- 如果没有参数了，默认为当前目录
if #args == 0 then args[1] = shell.dir() end

-- 获取文件大小的格式化函数
local function format_size(size)
  if size < 1024 then
    return size .. " B"
  elseif size < 1024 * 1024 then
    return string.format("%.1f KB", size / 1024)
  else
    return string.format("%.1f MB", size / (1024 * 1024))
  end
end

-- 获取文件类型和对应的颜色
local function get_file_info(filename, full_path)
  local is_dir = fs.isDir(full_path)
  local color, indicator
  
  if is_dir then
    color = colors.green
    indicator = "/"
  else
    -- 根据文件扩展名设置不同颜色
    local ext = filename:match("%.(%w+)$") or ""
    ext = ext:lower()
    
    if ext == "lua" then
      color = colors.cyan
    elseif ext == "txt" or ext == "md" or ext == "hlp" then
      color = colors.white
    elseif ext == "png" or ext == "jpg" or ext == "gif" then
      color = colors.magenta
    else
      color = colors.lightGray
    end
    indicator = ""
  end
  
  return color, indicator
end

local function list_dir(dir)
  if not fs.exists(dir) then
    error("\"" .. dir .. "\" that directory does not exist", 0)
  elseif not fs.isDir(dir) then
    error("\"" .. dir .. "\" is not a directory", 0)
  end

  local raw_files = fs.list(dir)
  local items = {}

  -- 收集文件信息
  for i=1, #raw_files, 1 do
    local name = raw_files[i]
    local full = fs.combine(dir, name)
    
    if name:sub(1,1) ~= "." or show_hidden then
      local color, indicator = get_file_info(name, full)
      local size = ""
      
      if show_details and not fs.isDir(full) then
        local size_bytes = fs.getSize(full)
        size = format_size(size_bytes)
      end
      
      table.insert(items, {
        name = name,
        color = color,
        indicator = indicator,
        size = size,
        is_dir = fs.isDir(full)
      })
    end
  end
  
  -- 先排序目录，再排序文件
  table.sort(items, function(a, b)
    if a.is_dir and not b.is_dir then return true end
    if not a.is_dir and b.is_dir then return false end
    return a.name < b.name
  end)

  -- 显示标题
  local w = term.getSize()
  local title = dir
  textutils.coloredPrint(colors.yellow, string.rep("=", w), colors.white)
  textutils.coloredPrint(colors.yellow, title, colors.white)
  textutils.coloredPrint(colors.yellow, string.rep("=", w), colors.white)
  
  -- 显示文件列表
  local display_items = {}
  local max_name_len = 0
  
  -- 计算最长文件名长度
  for _, item in ipairs(items) do
    local display_name = item.name .. item.indicator
    max_name_len = math.max(max_name_len, #display_name)
  end
  
  -- 创建格式化的显示项
  for _, item in ipairs(items) do
    local display_name = item.name .. item.indicator
    if show_details then
      local padding = string.rep(" ", max_name_len - #display_name + 2)
      display_name = display_name .. padding .. item.size
    end
    table.insert(display_items, {item.color, display_name, colors.white})
  end
  
  -- 使用分页表格显示
  textutils.pagedTabulate(unpack(display_items))
  
  -- 显示统计信息
  textutils.coloredPrint(colors.yellow, "\nTotal: " .. #items .. " items", colors.white)
  
  -- 显示提示
  if not show_details then
    textutils.coloredPrint(colors.lightGray, "Type 'list -l' for detailed information", colors.white)
  end
  textutils.coloredPrint(colors.yellow, string.rep("=", w), colors.white)
end

for i=1, #args, 1 do
  list_dir(args[i])
  if i < #args then
    print() -- 不同目录之间添加空行
  end
end
