M = {}

function M.split(input_string, seperator)
  local result = {}
  for str in string.gmatch(input_string .. seperator, "(.-)(" .. seperator .. ")") do
    table.insert(result, str)
  end
  return result
end

return M
