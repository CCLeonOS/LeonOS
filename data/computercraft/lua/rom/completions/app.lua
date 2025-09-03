local shell = require("shell")
local completion = require("cc.shell.completion")

shell.setCompletionFunction("app", completion.build(
  {completion.choice, choices = {"install", "update", "remove", "list"}, desc = "Command"},
  {completion.anything, desc = "App name", optional = true}
))