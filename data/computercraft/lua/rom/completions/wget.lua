local shell = require("shell")
local completion = require("cc.shell.completion")

shell.setCompletionFunction("wget", completion.build(
  {completion.anything, desc = "URL"},
  {completion.dirOrFile, desc = "Output file", optional = true}
))