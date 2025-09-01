-- pkg command completion
local shell = require("shell")
local completion = require("cc.shell.completion")

-- 定义pkg命令的补全函数
local function pkg_completion(shell, index, text, previous)
  -- 子命令补全
  if index == 1 then
    return completion.choice(text, {"install", "update", "remove", "list", "search", "info", "help"})
  end

  -- 选项补全 (--force, --local)
  if text:sub(1, 2) == "--" then
    return completion.choice(text, {"--force", "--local"})
  end

  -- 命令特定补全
  local command = previous[1]
  if command == "install" or command == "update" or command == "remove" or command == "info" then
    -- 这里可以添加包名补全逻辑
    -- 目前返回空列表
    return {}
  elseif command == "search" then
    -- 搜索查询不需要特定补全
    return {}
  end

  return {}
end

shell.setCompletionFunction("pkg", pkg_completion)