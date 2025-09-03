local shell = require("shell")
local completion = require("cc.shell.completion")

shell.setCompletionFunction("config", completion.build(
  {completion.anything, desc = "Config key"},
  {completion.anything, desc = "Config value", optional = true}
))