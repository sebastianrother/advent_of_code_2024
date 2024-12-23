local f = require('utils.file')
local s = require('utils.string')
local d = require('utils.debug')
local test = require('utils.test')
local input = f.get_file_contents('day_10/input.txt')

function part_01(input_data)
  local map = parse_input_to_map(input_data)

  -- Getting all the starting points
  local starting_points = {}
  for y, row in pairs(map) do
    for x, height in pairs(row) do
      if height == 0 then
        table.insert(starting_points, {y, x})
      end
    end
  end

  -- Recurse through all the paths
  for _, starting_point in pairs(starting_points) do
    check_paths(map, {{y = starting_point[2], x = starting_point[1], height = 0}})
  end
end

DIRECTIONS = {
  {-1, 0},
  {1, 0},
  {0, -1},
  {0, 1}
}

-- current path {x, y, height}[]
function check_paths(map, current_path)
  local last_pos = current_path[#current_path]
  print(d.dump(last_pos))
  local last_x = last_pos.x
  local last_y = last_pos.y
  local last_height = last_pos.height

  for _, direction in pairs(DIRECTIONS) do
  end
end

function parse_input_to_map(input_data)
  local map = {}

  for y, row in pairs(input_data) do
    map[y] = {}
    for x = 1, #row do
      local height = row:sub(x, x)
      map[y][x] = tonumber(height)
    end
  end

  return map
end

local test_data_01 = {
  "0123",
  "1234",
  "8765",
  "9876",
}

local test_data_02 = {
  "...0...",
  "...1...",
  "...2...",
  "6543456",
  "7.....7",
  "8.....8",
  "9.....9",
}

local test_data_03 = {
  "..90..9",
  "...1.98",
  "...2..7",
  "6543456",
  "765.987",
  "876....",
  "987....",
}

local test_data_04 = {
  "10..9..",
  "2...8..",
  "3...7..",
  "4567654",
  "...8..3",
  "...9..2",
  ".....01",
}

local test_data_05 = {
  "89010123",
  "78121874",
  "87430965",
  "96549874",
  "45678903",
  "32019012",
  "01329801",
  "10456732",
}

test.test('Part 01 - Example #1', function()
  local result = part_01(test_data_01)
  test.expect_equal(result, 1)
end)

test.test('Part 01 - Example #2', function()
  local result = part_01(test_data_02)
  test.expect_equal(result, 2)
end)

test.test('Part 01 - Example #3', function()
  local result = part_01(test_data_03)
  test.expect_equal(result, 4)
end)

test.test('Part 01 - Example #4', function()
  local result = part_01(test_data_04)
  test.expect_equal(result, 3)
end)

test.test('Part 01 - Example #5', function()
  local result = part_01(test_data_05)
  test.expect_equal(result, 36)
end)
