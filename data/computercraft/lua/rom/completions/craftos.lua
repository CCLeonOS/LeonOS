local shell = require("shell")
local completion = require("cc.shell.completion")

shell.setCompletionFunction("craftos", completion.build(
  -- craftos command doesn't take parameters
))