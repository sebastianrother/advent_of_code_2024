local f = require('utils.file')
local s = require('utils.string')
local d = require('utils.debug')
local test = require('utils.test')

local input = f.get_file_contents('day_11/input.txt')

local function part_01(input_data)
  return count_all_stone_blinks(s.split(input_data[1], " "), 25)
end

local function part_02(input_data)
  return count_all_stone_blinks(s.split(input_data[1], " "), 75)
end


function simulate_blink(stones)
  local out = {}
  for i = 1, #stones do
    local stone = tonumber(stones[i])

    if stone == 0 then
      table.insert(out, 1)
      goto continue
    end
    if #tostring(stone) % 2 == 0 then
      local stone_str = tostring(stone)
      local split_pos = #stone_str / 2
      local first_num = stone_str:sub(1, split_pos)
      local second_num = stone_str:sub(split_pos + 1, #stone_str)
      table.insert(out, first_num)
      table.insert(out, second_num)
      goto continue
    end
    table.insert(out, stone * 2024)

    ::continue::
  end

  return out
end

function count_all_stone_blinks(stones, depth)
  local result = 0
  for i = 1, #stones do
    result = result + count_stone_blinks(tonumber(stones[i]), depth)
  end
  return result
end

CACHE = {}
function cache(cache_name, fn)
  CACHE[cache_name] = {}
  return function(...)
    local cache_id = join({ ... }, "__")
    if CACHE[cache_name][cache_id] ~= nil then return CACHE[cache_name][cache_id] end
    local result = fn(...)
    CACHE[cache_name][cache_id] = result
    return result
  end
end

count_stone_blinks = cache('count_stone_blinks', function(stone, depth)
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

function time(fn)
  local start_time = os.clock()
  local result = fn()
  print("Elapsed time is: " .. os.clock() - start_time)
  return result
end

function join(input_table, join_str)
  local out = ""
  for i = 1, #input_table do
    local curr_join_str = i < #input_table and join_str or ""
    out = out .. input_table[i] .. curr_join_str
  end

  return out
end

local test_data = {
  "0 1 10 99 999"
}

local test_data_2 = {
  "125 17"
}

test.test("Part 01 - Single Blink", function()
  local result = simulate_blink(s.split(test_data[1], " "))
  test.expect_equal(join(result, " "), "1 2024 1 0 9 9 2021976")
end)

test.test("Part 01 - Multiple Blinks", function()
  local result = s.split(test_data_2[1], " ")
  for i = 1, 6 do
    result = simulate_blink(result)
  end
  test.expect_equal(join(result, " "), "2097446912 14168 4048 2 0 2 4 40 48 2024 40 48 80 96 2 8 6 7 6 0 3 2")
end)

test.test("Part 01 - Result", function()
  local result = part_01(input)
  test.expect_equal(result, 199946)
end)

print(time(function() return part_02(input) end))
