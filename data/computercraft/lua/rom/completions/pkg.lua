local shell = require("shell")
local completion = require("cc.shell.completion")

shell.setCompletionFunction("pkg", completion.build(
  completion.choice{"install", "update", "remove", "list", "search", "info", "help"},
))
