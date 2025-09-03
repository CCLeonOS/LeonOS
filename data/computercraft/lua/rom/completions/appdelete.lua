local shell = require("shell")
local completion = require("cc.shell.completion")

shell.setCompletionFunction("appdelete", completion.build(
  {completion.anything, desc = "App name"}
))