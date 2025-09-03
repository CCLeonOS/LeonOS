local shell = require("shell")
local completion = require("cc.shell.completion")

shell.setCompletionFunction("commands", completion.build(
  -- commands command doesn't take parameters
))