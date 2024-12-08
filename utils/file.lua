M = {}

local function _file_exists(file_path)
  local file = io.open(file_path, "rb")
  if file then file:close() end
  return file ~= nil
end

---Reads file contents and returns table of lines
---@param file_path string
---@return string[]
function M.get_file_contents(file_path)
  if not _file_exists(file_path) then return {} end
  local lines = {}
  for line in io.lines(file_path) do
    lines[#lines + 1] = line
  end
  return lines
end

return M
