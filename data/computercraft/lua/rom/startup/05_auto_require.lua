-- Load auto_require module to automatically require libraries
local success, err = pcall(require, "auto_require")
if not success then
  print("Failed to load auto_require module: " .. tostring(err))
end