M = {}

function M.split(input_string, seperator)
  local out = {}
  for str in string.gmatch(input_string .. seperator, "(.-)(" .. seperator .. ")") do
    table.insert(out, str)
  end
  return out
end

function M.join(input_table, join_str)
  local out = ""
  for i = 1, #input_table do
    local curr_join_str = i < #input_table and join_str or ""
    out = out .. input_table[i] .. curr_join_str
  end

  return out
end

return M
