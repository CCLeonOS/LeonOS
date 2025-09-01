-- auto_require.lua: Automatically require libraries when accessed

-- Save the original require function
local original_require = require

-- List of common libraries to auto-require
local common_libs = {
  "rc", "fs", "term", "colors", "textutils", "window",
  "keys", "peripheral", "redstone", "rs", "monitor",
  "modem", "http", "json", "image", "paint", "sound"
}

-- Pre-load common libraries into a cache
local lib_cache = {}
for _, lib_name in ipairs(common_libs) do
  local success, lib = pcall(original_require, lib_name)
  if success then
    lib_cache[lib_name] = lib
  end
end

-- Create a new environment with auto-require functionality
local auto_env = setmetatable({}, {
  __index = function(_, key) 
    -- Check if the key exists in the global environment
    local val = rawget(_G, key)
    if val ~= nil then
      return val
    end

    -- Check if the key is in our pre-loaded cache
    if lib_cache[key] then
      return lib_cache[key]
    end

    -- Try to require the module using the original require function
    local success, lib = pcall(original_require, key)
    if success then
      lib_cache[key] = lib
      return lib
    end

    -- If all else fails, return nil
    return nil
  end
})

-- Create a proxy function for require that uses the original require
_G.require = function(modname)
  return original_require(modname)
end

-- Add the auto-require environment to the global metatable
local old_mt = getmetatable(_G) or {}
local old_index = old_mt.__index
old_mt.__index = function(t, key)
  -- Try the original index first
  if old_index then
    local val = old_index(t, key)
    if val ~= nil then
      return val
    end
  end
  -- Then try our auto-require environment
  return auto_env[key]
end
setmetatable(_G, old_mt)

return {}