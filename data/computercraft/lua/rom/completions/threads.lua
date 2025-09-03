local shell = require("shell")
local completion = require("cc.shell.completion")

shell.setCompletionFunction("threads", completion.build(
  -- threads command doesn't take parameters
))