-- appgui_demo.lua
-- Demonstration of the appgui API for drawing top and bottom bars

local appgui = require("appgui")
local term = require("term")
local colors = require("colors")

-- Clear the screen before starting
term.clear()

-- Draw the top bar with default colors (white text on blue background)
appgui.topbar("LeonOS App GUI Demo")

-- Add some content in the middle
print()
print("This is a demonstration of the appgui API.")
print()
print("The top bar shows the application title.")
print("The bottom bar shows the status information.")
print()
print("Press any key to see custom colors...")

-- Wait for a key press using a safe event pulling function
local pullEventFunc = os.pullEvent or os.pullEventRaw
if not pullEventFunc then
  error("No valid event pulling function found")
end
local event, key = table.unpack({pullEventFunc("key")})

-- Clear the screen and redraw with custom colors
term.clear()
appgui.topbar("Custom Colored Top Bar", colors.yellow, colors.red)

-- Add some content
print()
print("Now with custom colors!")
print()
print("Top bar: Yellow text on Red background")
print()
print("Press any key to continue...")

-- Wait for a key press using a safe event pulling function
local pullEventFunc = os.pullEvent or os.pullEventRaw
if not pullEventFunc then
  error("No valid event pulling function found")
end
local event, key = table.unpack({pullEventFunc("key")})

-- Clear the screen and draw both top and bottom bars
term.clear()
appgui.topbar("Complete GUI Demo")
appgui.downbar("Status: Running - Press Q to quit")

-- Add some content in the middle
print()
print("Now you can see both top and bottom bars.")
print()
print("Try resizing the terminal window to see how the text stays centered.")
print()
print("Press Q to exit this demo.")

-- Main loop to handle key presses
while true do
  -- Use a safe event pulling function
  local pullEventFunc = os.pullEvent or os.pullEventRaw
  if not pullEventFunc then
    error("No valid event pulling function found")
  end
  local event, key = table.unpack({pullEventFunc("key")})
  if key == 16 then -- Q key
    break
  end
end

-- Clear the screen before exiting
term.clear()
print("AppGUI Demo has ended.")