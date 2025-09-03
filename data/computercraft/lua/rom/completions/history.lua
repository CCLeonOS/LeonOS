local shell = require("shell")
local completion = require("cc.shell.completion")

shell.setCompletionFunction("history", completion.build(
  {completion.number, desc = "Number of entries", optional = true}
))