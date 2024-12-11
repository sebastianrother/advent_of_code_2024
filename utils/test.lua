local M = {}

function M.test(test_name, fn)
  io.write("Running test: " .. test_name .. " ... ")
  local status, error = pcall(fn)
  if not status then
    io.write("FAIL\n")
    return print(error.."\n")
  end
  io.write("OK\n")
end

function M.expect_equal(value, expected)
  if value == nil then value = "" end
  if value ~= expected then
     error("Received: " .. value .. '\nExpected: ' .. expected, 0)
  end
end

return M
