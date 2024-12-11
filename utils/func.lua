local s = require('utils.string')
local M = {}

local _CACHE = {}
function M.cache(cache_name, fn)
  _CACHE[cache_name] = {}
  return function(...)
    local cache_id = s.join({ ... }, "__")
    if _CACHE[cache_name][cache_id] ~= nil then return _CACHE[cache_name][cache_id] end
    local result = fn(...)
    _CACHE[cache_name][cache_id] = result
    return result
  end
end

return M
