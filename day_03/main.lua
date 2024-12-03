local t = require('utils.test')
local f = require('utils.file')

local MULTIPLICATION_PATTERN = "mul%((%d+),(%d+)%)"
local function part_01(input_data)
  local result = 0
  for row_num, row in pairs(input_data) do
    for mul_1, mul_2 in string.gmatch(row, MULTIPLICATION_PATTERN) do
      result = result + mul_1 * mul_2
    end
  end

  return result
end

local function part_02(input_data)
  local result = 0
  local mode = 'DO'
  for row_num, row in pairs(input_data) do
    local start_pos = 0
    while true do
      local mul_start, mul_end, mul_1, mul_2 = string.find(row, MULTIPLICATION_PATTERN, start_pos)
      local do_start, do_end = string.find(row, 'do%(%)', start_pos)
      local dont_start, dont_end = string.find(row, 'don%\'t%(%)', start_pos)


      if do_start ~= nil and do_end ~= nil and mul_start~=nil and (do_start< mul_start) then
        mode = 'DO'
        start_pos = do_end
        goto continue
      end

      if dont_start ~= nil and dont_end ~= nil and mul_start~=nil and (dont_start< mul_start) then
        mode = 'DONT'
        start_pos = dont_end
        goto continue
      end

      if mul_end == nil then
        break
      end

      start_pos = mul_end


      if mode == 'DO' then
        result = result + mul_1 * mul_2
      end
        ::continue::
    end
  end

  return result
end

local test_data_01 = { "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))" }
local test_data_02 = { "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))" }

t.test('Part 01', function()
  local result = part_01(test_data_01)
  t.expect_equal(result, 161)
end)

t.test('Part 02', function()
  local result = part_02(test_data_02)
  t.expect_equal(result, 48)
end)

print("Part 01:", part_01(f.get_file_contents('day_03/input.txt')))
print("Part 02:", part_02(f.get_file_contents('day_03/input.txt')))
