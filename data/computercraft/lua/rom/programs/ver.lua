-- LeonOS version command
local rc = require("rc")
local textutils = require("textutils")

-- Display LeonOS version
textutils.coloredPrint(colors.yellow, rc.version(), colors.white)
