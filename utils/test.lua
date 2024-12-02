local M = {}

function M.test(test_name, fn)
  io.write("Running test: " .. test_name .. " ... ")
  local status, error = pcall(fn)
  if not status then
    return print(error)
  end
  io.write("OK\n")
end

function M.expect_equal(value, expected)
  if value == nil then value = "" end
  return assert(value == expected, "\nReceived: " .. value .. '\nExpected: ' .. expected)
end

return M
