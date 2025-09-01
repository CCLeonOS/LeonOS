-- auto_require.lua: Automatically require libraries when accessed

local original_ENV = _ENV

-- List of common libraries to auto-require
local common_libs = {
  "rc", "fs", "term", "colors", "textutils", "window",
  "keys", "peripheral", "redstone", "rs", "monitor",
  "modem", "http", "json", "image", "paint", "sound"
}

-- Pre-load common libraries into a cache
local lib_cache = {}
for _, lib_name in ipairs(common_libs) do
  local success, lib = pcall(require, lib_name)
  if success then
    lib_cache[lib_name] = lib
  end
end

-- Create a new environment with auto-require functionality
local auto_env = setmetatable({}, {
  __index = function(_, key)
    -- Check if the key exists in the original environment
    local val = original_ENV[key]
    if val ~= nil then
      return val
    end

    -- Check if the key is in our pre-loaded cache
    if lib_cache[key] then
      return lib_cache[key]
    end

    -- Try to require the module
    local success, lib = pcall(require, key)
    if success then
      lib_cache[key] = lib
      return lib
    end

    -- If all else fails, return nil
    return nil
  end
})

-- Replace the global environment with our auto-require environment
setmetatable(_G, {
  __index = auto_env
})

return {}