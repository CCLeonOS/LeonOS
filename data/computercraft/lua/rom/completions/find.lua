local shell = require("shell")
local completion = require("cc.shell.completion")

shell.setCompletionFunction("find", completion.build(
  {completion.anything, desc = "Search pattern"},
  {completion.dir, desc = "Directory", optional = true}
))