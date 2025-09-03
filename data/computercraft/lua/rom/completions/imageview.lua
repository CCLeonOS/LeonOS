local shell = require("shell")
local completion = require("cc.shell.completion")

shell.setCompletionFunction("imageview", completion.build(
  completion.anything
))