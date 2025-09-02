-- imageview.lua: Image viewer that loads from URL
local http = require("http")
local paintutils = require("paintutils")
local term = require("term")
local event = require("event")
local shell = require("shell")

-- 帮助信息函数
local function printHelp()
  print("Usage: imageview <image_url>")
  print("Options:")
  print("  --help, -h    Show this help message")
  print([[
Displays an image from the specified URL.
Press ESC to exit back to shell.
]])
end

-- 下载图片函数
local function downloadImage(url)
  print("Downloading image from: " .. url)
  local response, err = http.get(url, nil, true)
  if not response then
    print("Error downloading image: " .. err)
    return nil
  end

  local data = response.readAll()
  response.close()
  return data
end

-- 主函数
local function main(args)
  -- 处理命令行参数
  if #args == 0 or args[1] == "--help" or args[1] == "-h" then
    printHelp()
    return
  end

  local imageUrl = args[1]

  -- 检查是否是有效的URL
  if not imageUrl:match("^https?://") then
    print("Error: Invalid URL format. Must start with http:// or https://")
    return
  end

  -- 下载图片
  local imageData = downloadImage(imageUrl)
  if not imageData then
    return
  end

  -- 尝试加载图片
  local success, image = pcall(function()
    return paintutils.loadImage(imageData)
  end)

  if not success then
    print("Error loading image: " .. image)
    return
  end

  -- 清除屏幕并显示图片
  term.clear()
  local w, h = term.getSize()

  -- 计算图片居中位置
  local imgW, imgH = #image[1], #image
  local x = math.floor((w - imgW) / 2)
  local y = math.floor((h - imgH) / 2)

  -- 绘制图片
  paintutils.drawImage(image, x, y)

  print("\nImage displayed. Press ESC to exit.")

  -- 监听ESC键
  while true do
    local _, key = event.pull("key")
    if key == 27 then -- ESC键
      term.clear()
      term.setCursorPos(1, 1)
      print("Image viewer closed.")
      return
    end
  end
end

-- 运行主函数
local args = {...}
main(args)