local test = require('utils.test')
local d = require('utils.debug')
local t = require('utils.table')
local f = require('utils.file')

local input = f.get_file_contents('day_13/input.txt')


function parse_game(input_data)
  local _, _, button_a_x, button_a_y = string.find(input_data[1], "Button A%: X%+(%d+), Y%+(%d+)")
  local _, _, button_b_x, button_b_y = string.find(input_data[2], "Button B%: X%+(%d+), Y%+(%d+)")
  local _, _, price_x, price_y = string.find(input_data[3], "Prize%: X%=(%d+), Y%=(%d+)")

  return {
    button_a_x = button_a_x,
    button_a_y = button_a_y,
    button_b_x = button_b_x,
    button_b_y = button_b_y,
    price_x = price_x,
    price_y = price_y
  }
end

function find_optimum(game_data)
  local price_x = game_data.price_x
  local price_y = game_data.price_y
  local button_a_x = game_data.button_a_x
  local button_b_x = game_data.button_b_x
  local button_a_y = game_data.button_a_y
  local button_b_y = game_data.button_b_y

  local max_range_a = math.ceil(math.max(tonumber(price_x) / tonumber(button_a_x),
    tonumber(price_y) / tonumber(button_a_y)))
  local max_range_b = math.ceil(math.max(tonumber(price_x) / tonumber(button_b_x),
    tonumber(price_y) / tonumber(button_b_y)))

  lowest_price = nil
  lowest_price_count = { a = nil, b = nil }
  for count_a = 0, max_range_a, 1 do
    local count_b_1 = (price_x - button_a_x * count_a) / button_b_x
    local count_b_2 = (price_y - button_a_y * count_a) / button_b_y

    if count_b_1 ~= count_b_2 then goto continue end
    local total_price = 3 * count_a + 1 * count_b_1

    if lowest_price ~= nil and total_price >= lowest_price then goto continue end

    lowest_price = tonumber(total_price)
    lowest_price_count.a = tonumber(count_a)
    lowest_price_count.b = tonumber(count_b_1)

    ::continue::
  end

  return {
    lowest_price = lowest_price,
    lowest_a = lowest_price_count.a,
    lowest_b = lowest_price_count.b,
  }
end

function part_01(input_data)
  local games_data = t.split(input_data, "")
  local total_tokens = 0
  for _, raw_game_data in pairs(games_data) do
    local game_data = parse_game(raw_game_data)
    local optimum_game = find_optimum(game_data)
    if optimum_game.lowest_price ~= nil then
      total_tokens = total_tokens + optimum_game.lowest_price
    end
  end

  return total_tokens
end

function part_02(input_data)
  local games_data = t.split(input_data, "")
  local total_tokens = 0
  for _, raw_game_data in pairs(games_data) do
    local game_data = parse_game(raw_game_data)
    game_data.price_x = game_data.price_x + 10000000000000
    game_data.price_y = game_data.price_y + 10000000000000
    local optimum_game = find_optimum(game_data)
    if optimum_game.lowest_price ~= nil then
      total_tokens = total_tokens + optimum_game.lowest_price
    end
  end

  return total_tokens
end

-- 8400 = 94a + 22b -> (8400 - 94a) / 22
-- 5400 = 34a + 67b

local test_data = {
  "Button A: X+94, Y+34",
  "Button B: X+22, Y+67",
  "Prize: X=8400, Y=5400",
  "",
  "Button A: X+26, Y+66",
  "Button B: X+67, Y+21",
  "Prize: X=12748, Y=12176",
  "",
  "Button A: X+17, Y+86",
  "Button B: X+84, Y+37",
  "Prize: X=7870, Y=6450",
  "",
  "Button A: X+69, Y+23",
  "Button B: X+27, Y+71",
  "Prize: X=18641, Y=10279",
}

test.test("Part 01 - Example", function()
  local result = part_01(test_data)
  test.expect_equal(result, 480.0)
end)

test.test("Part 01 - Solution", function()
  local result = part_01(input)
  test.expect_equal(result, 25629.0)
end)

test.test("Part 02 - Example", function()
  local result = part_02(test_data)
  test.expect_equal(result, 480.0)
end)
