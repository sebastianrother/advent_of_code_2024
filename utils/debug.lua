M = {}

function dump(data)
  if type(data) ~= 'table' then return tostring(data) end

  local prefix = '{\n'
  local suffix = '} '
  local result = ''
  for key, value in pairs(data) do
    if type(key) ~= 'number' then key = '"' .. key .. '"' end -- If key is not a number, put it in quotes
    v = type(value) == 'table' and " " .. dump(value) or ' "' .. dump(value) .. '"'
    result = result .. '\t[' .. key .. ']:' .. v .. ',\n'
  end
  return prefix .. result .. suffix
end

M.dump = dump

function M.time(fn)
  local start_time = os.clock()
  local result = fn()
  print("Elapsed time is: " .. os.clock() - start_time)
  return result
end

return M
