local shell = require("shell")
local completion = require("cc.shell.completion")

shell.setCompletionFunction("about", completion.build(
  -- about command doesn't take parameters
))