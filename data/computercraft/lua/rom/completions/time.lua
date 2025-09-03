local shell = require("shell")
local completion = require("cc.shell.completion")

shell.setCompletionFunction("time", completion.build(
  -- time command doesn't take parameters
))