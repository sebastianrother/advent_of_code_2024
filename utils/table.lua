local M = {}

function M.find(haystack_table, needle)
  for key, value in pairs(haystack_table) do
    if value == needle then
      return true
    end
  end
  return false
end

function M.split(haystack_table, needle)
  local result = {}
  local split_index = 1
  for _key, value in pairs(haystack_table) do
    if result[split_index] == nil then
      result[split_index] = {}
    end

    if value == needle then
      split_index = split_index + 1
      goto continue
    end

    table.insert(result[split_index], value)

    ::continue::
  end

  return result
end

return M
