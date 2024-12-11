local f = require('utils.file')
local s = require('utils.string')
local test = require('utils.test')
local func = require('utils.func')

local input = f.get_file_contents('day_11/input.txt')

local function part_01(input_data)
  return count_all_stone_blinks(s.split(input_data[1], " "), 25)
end

local function part_02(input_data)
  return count_all_stone_blinks(s.split(input_data[1], " "), 75)
end

function count_all_stone_blinks(stones, depth)
  local result = 0
  for i = 1, #stones do
    result = result + count_stone_blinks(tonumber(stones[i]), depth)
  end
  return result
end

count_stone_blinks = func.cache('count_stone_blinks', function(stone, depth)
  local l_stone, r_stone = blink_stone(stone)

  if depth == 1 then
    if r_stone ~= nil then return 2 end
    return 1
  end

  local output = 0
  output = output + count_stone_blinks(l_stone, depth - 1)
  if r_stone ~= nil then
    output = output + count_stone_blinks(r_stone, depth - 1)
  end

  return output
end)

function blink_stone(value)
  local str = tostring(value)
  if value == 0 then return 1, nil end
  if #str % 2 == 0 then return tonumber(str:sub(1, #str / 2)), tonumber(str:sub(#str / 2 + 1, #str)) end
  return value * 2024, nil
end

test.test("Part 01 - Result", function()
  local result = part_01(input)
  test.expect_equal(result, 199946)
end)

test.test("Part 02 - Result", function()
  local result = part_02(input)
  test.expect_equal(result, 237994815702032)
end)
