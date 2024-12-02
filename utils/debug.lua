M = {}

function M.dump(data)
  if type(data) ~= 'table' then return tostring(data) end

  local prefix = '{\n'
  local suffix = '} '
  local result = ''
  for key, value in pairs(data) do
    if type(key) ~= 'number' then key = '"' .. key .. '"' end -- If key is not a number, put it in quotes
    result = result .. '[' .. key .. '] = "' .. M.dump(value) .. '",\n'
  end
  return prefix .. result .. suffix
end

return M
