local shell = require("shell")
local completion = require("cc.shell.completion")

shell.setCompletionFunction("clear", completion.build(
  -- clear command doesn't take parameters
))