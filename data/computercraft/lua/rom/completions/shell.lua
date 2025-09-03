local shell = require("shell")
local completion = require("cc.shell.completion")

shell.setCompletionFunction("shell", completion.build(
  {completion.anything, desc = "Command", optional = true}
))