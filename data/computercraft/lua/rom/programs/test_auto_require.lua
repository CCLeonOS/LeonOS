-- Test auto_require functionality
-- This program doesn't explicitly require 'textutils'

-- Try to use textutils without requiring it first
textutils.coloredPrint(colors.green, "Auto-require test successful!", colors.white)
textutils.printTable({test = "This should work without require"})

-- Try another library
term.setTextColor(colors.yellow)
print("Using term library without require:")
term.at(1, 3).write("Cursor moved using term library")

-- Test a library that might not be pre-loaded
game = fs.open("/test.txt", "w")
if game then
  game.write("Testing fs library")
  game.close()
  print("File written successfully")
else
  print("Failed to open file")
end