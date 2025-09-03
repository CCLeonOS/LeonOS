local shell = require("shell")
local completion = require("cc.shell.completion")

shell.setCompletionFunction("lua", completion.build(
  {completion.dirOrFile, desc = "Script file", optional = true}
))