local shell = require("shell")
local completion = require("cc.shell.completion")

shell.setCompletionFunction("storage", completion.build(
  -- storage command doesn't take parameters
))