-- appgui API for LeonOS
-- Provides simple topbar and downbar drawing functions

local term = require("term")
local colors = require("colors")
local expect = require("cc.expect").expect

local appgui = {}

--- Draws a top bar with the specified text centered
--- @param text string The text to display in the top bar
--- @param fgColor number Optional foreground color (default: white)
--- @param bgColor number Optional background color (default: blue)
function appgui.topbar(text, fgColor, bgColor)
  expect(1, text, "string")
  expect(2, fgColor, "number", "nil")
  expect(3, bgColor, "number", "nil")
  
  -- Default colors
  fgColor = fgColor or colors.white
  bgColor = bgColor or colors.blue
  
  -- Save current colors
  local oldFg = term.getTextColor()
  local oldBg = term.getBackgroundColor()
  
  -- Get terminal size
  local w, h = term.getSize()
  
  -- Set colors and position
  term.setTextColor(fgColor)
  term.setBackgroundColor(bgColor)
  term.setCursorPos(1, 1)
  
  -- Clear the top line
  term.clearLine()
  
  -- Calculate padding for centered text
  local padding = math.floor((w - #text) / 2)
  
  -- Draw the top bar with centered text
  term.write(string.rep(" ", padding) .. text .. string.rep(" ", padding))
  
  -- Restore original colors
  term.setTextColor(oldFg)
  term.setBackgroundColor(oldBg)
  
  -- Move cursor below the top bar
  term.setCursorPos(1, 2)
end

--- Draws a bottom bar with the specified text centered
--- @param text string The text to display in the bottom bar
--- @param fgColor number Optional foreground color (default: white)
--- @param bgColor number Optional background color (default: blue)
function appgui.downbar(text, fgColor, bgColor)
  expect(1, text, "string")
  expect(2, fgColor, "number", "nil")
  expect(3, bgColor, "number", "nil")
  
  -- Default colors
  fgColor = fgColor or colors.white
  bgColor = bgColor or colors.blue
  
  -- Save current colors
  local oldFg = term.getTextColor()
  local oldBg = term.getBackgroundColor()
  
  -- Get terminal size
  local w, h = term.getSize()
  
  -- Set colors and position
  term.setTextColor(fgColor)
  term.setBackgroundColor(bgColor)
  term.setCursorPos(1, h)
  
  -- Clear the bottom line
  term.clearLine()
  
  -- Calculate padding for centered text
  local padding = math.floor((w - #text) / 2)
  
  -- Draw the bottom bar with centered text
  term.write(string.rep(" ", padding) .. text .. string.rep(" ", padding))
  
  -- Restore original colors
  term.setTextColor(oldFg)
  term.setBackgroundColor(oldBg)
  
  -- Move cursor to a safe position
  term.setCursorPos(1, 1)
end

return appgui