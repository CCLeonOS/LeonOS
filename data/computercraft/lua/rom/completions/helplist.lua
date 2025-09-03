local shell = require("shell")
local completion = require("cc.shell.completion")

shell.setCompletionFunction("helplist", completion.build(
  -- helplist command doesn't take parameters
))