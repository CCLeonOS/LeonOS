local shell = require("shell")
local completion = require("cc.shell.completion")

shell.setCompletionFunction("programs", completion.build(
  -- programs command doesn't take parameters
))