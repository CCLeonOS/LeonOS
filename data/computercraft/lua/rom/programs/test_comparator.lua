-- Simple comparator test program
local peripheral = require("peripheral")
local term = require("term")
local colors = require("colors")

print(colors.green .. "=== Comparator Test ===" .. colors.white)

-- 查找比较器
local comparator = peripheral.find("comparator")
if not comparator then
  print(colors.red .. "No comparator detected!" .. colors.white)

  -- 列出所有连接的外围设备
  local peripherals = peripheral.getNames()
  if #peripherals > 0 then
    print(colors.yellow .. "Connected peripherals:" .. colors.white)
    for _, name in ipairs(peripherals) do
      local p_type = peripheral.getType(name)
      print("- " .. name .. " (Type: " .. p_type .. ")")
    end
  else
    print(colors.red .. "No peripherals detected at all." .. colors.white)
  end
else
  print(colors.green .. "Comparator detected!" .. colors.white)
  print("Comparator type: " .. peripheral.getType(peripheral.find("comparator")))
  print("Output signal level: " .. comparator.getOutputSignal())
end

print(colors.blue .. "Test completed." .. colors.white)