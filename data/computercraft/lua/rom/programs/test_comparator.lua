-- Improved comparator test program
local peripheral = require("peripheral")
local term = require("term")
local colors = require("colors")
local string = require("string")

print(colors.green .. "=== Improved Comparator Test ===" .. colors.white)

-- 尝试通过不同方式查找比较器
local comparator = nil
local peripherals = peripheral.getNames()
local comparator_found = false

print(colors.blue .. "Searching for comparator..." .. colors.white)

-- 方法1: 检查所有外围设备的类型
for _, name in ipairs(peripherals) do
  local p_type = peripheral.getType(name)
  print("Checking peripheral: " .. name .. " (Type: " .. p_type .. ")")
  
  -- 检查类型是否包含'comparator'或'redstone'关键字
  if string.find(p_type, "comparator") or string.find(p_type, "redstone") then
    comparator = peripheral.wrap(name)
    print(colors.green .. "Found potential comparator: " .. name .. " (Type: " .. p_type .. ")" .. colors.white)
    comparator_found = true
    break
  end
end

-- 方法2: 如果上述方法失败，尝试直接使用peripheral.find
if not comparator_found then
  print(colors.yellow .. "Method 1 failed. Trying peripheral.find..." .. colors.white)
  comparator = peripheral.find("comparator")
  if comparator then
    print(colors.green .. "Comparator detected using peripheral.find!" .. colors.white)
    comparator_found = true
  end
end

-- 显示结果
if comparator_found then
  print(colors.green .. "=== Comparator Test Results ===" .. colors.white)
  print("Comparator found: YES")
  
  -- 尝试获取比较器信号
  local signal = comparator.getOutputSignal()
  print("Output signal level: " .. signal)
  
  if signal > 0 then
    print(colors.blue .. "Comparator is detecting items in connected chests." .. colors.white)
  else
    print(colors.yellow .. "Comparator is not detecting any items. Try adding items to a chest." .. colors.white)
  end
else
  print(colors.red .. "=== Comparator Test Results ===" .. colors.white)
  print("Comparator found: NO")
  
  if #peripherals > 0 then
    print(colors.yellow .. "Connected peripherals:" .. colors.white)
    for _, name in ipairs(peripherals) do
      local p_type = peripheral.getType(name)
      print("- " .. name .. " (Type: " .. p_type .. ")")
    end
  else
    print(colors.red .. "No peripherals detected at all." .. colors.white)
  end
end

print(colors.blue .. "Test completed." .. colors.white)