-- example command completion

local shell = require('shell')
local completion = require('completion')

-- 为example命令设置补全
shell.setCompletionFunction('example', completion.build({
  -- 这里可以添加example命令的补全逻辑
  completion.choice{'--help', '-h'}
}))