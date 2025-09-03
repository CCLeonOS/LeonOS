local shell = require("shell")
local completion = require("cc.shell.completion")

shell.setCompletionFunction("applist", completion.build(
  -- applist command doesn't take parameters
))