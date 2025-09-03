local shell = require("shell")
local completion = require("cc.shell.completion")

shell.setCompletionFunction("peripherals", completion.build(
  -- peripherals command doesn't take parameters
))