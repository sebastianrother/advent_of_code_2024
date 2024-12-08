local t = require('utils.test')
local d = require('utils.debug')
local f = require('utils.file')
local s = require('utils.string')
local input = f.get_file_contents('day_08/input.txt')


local function part_01(input_data)
  local min_x = 1
  local min_y = 1
  local max_y = #input_data
  local max_x = #input_data[1]

  local antennas = parse_antennas(input_data)

  local antinodes = {}
  for antenna_key, locations in pairs(antennas) do
    for i, location_a in pairs(locations) do
      for j, location_b in pairs(locations) do
        if i == j then goto continue end
        local delta_x = location_a[1] - location_b[1]
        local delta_y = location_a[2] - location_b[2]

        local antinode_a = { location_a[1] + delta_x, location_a[2] + delta_y }
        local antinode_b = { location_b[1] - delta_x, location_b[2] - delta_y }

        antinodes[antinode_a[1] .. "__" .. antinode_a[2]] = antinode_a
        antinodes[antinode_b[1] .. "__" .. antinode_b[2]] = antinode_b

        ::continue::
      end
    end
  end

  antinodes = filter(antinodes, function(location)
    if location[1] > max_x or location[1] < min_x then return false end
    if location[2] > max_y or location[2] < min_y then return false end
    return true
  end)

  return #antinodes
end

local function part_02(input_data)
  local min_x = 1
  local min_y = 1
  local max_y = #input_data
  local max_x = #input_data[1]

  local antennas = parse_antennas(input_data)

  antinodes = {}
  for antenna_key, locations in pairs(antennas) do
    for i, location_a in pairs(locations) do
      for j, location_b in pairs(locations) do
        if i == j then goto continue end

        local delta_x = location_a[1] - location_b[1]
        local delta_y = location_a[2] - location_b[2]

        -- Positive nodes
        for k = 1, 1000, 1 do
          local antinode = { location_a[1] + delta_x * k, location_a[2] + delta_y * k }
          if antinode[1] > max_x or antinode[1] < min_x then break end
          if antinode[2] > max_y or antinode[2] < min_y then break end

          antinodes[antinode[1] .. "__" .. antinode[2]] = antinode
        end

        -- Negative nodes
        for k = -1, -1000, -1 do
          local antinode = { location_a[1] + delta_x * k, location_a[2] + delta_y * k }
          if antinode[1] > max_x or antinode[1] < min_x then break end
          if antinode[2] > max_y or antinode[2] < min_y then break end

          antinodes[antinode[1] .. "__" .. antinode[2]] = antinode
        end

        ::continue::
      end
    end
  end
  antinodes = filter(antinodes, function() return true end)

  return #antinodes
end

function parse_antennas(input_data)
  local antennas = {}
  for y, row in pairs(input_data) do
    for x = 1, #row do
      local char = row:sub(x, x)
      if char == '.' then
        goto continue
      end
      if antennas[char] == nil then
        antennas[char] = {}
      end
      table.insert(antennas[char], { x, y })

      ::continue::
    end
  end

  return antennas
end




function filter(input_table, filter_fn)
  local filter_table = {}

  for _, v in pairs(input_table) do
    if filter_fn(v) then
      table.insert(filter_table, v)
    end
  end

  return filter_table
end

local test_data = {
  "............",
  "........0...",
  ".....0......",
  ".......0....",
  "....0.......",
  "......A.....",
  "............",
  "............",
  "........A...",
  ".........A..",
  "............",
  "............",
}

local test_data_02 = {
  "..........",
  "..........",
  "..........",
  "....a.....",
  "........a.",
  ".....a....",
  "..........",
  "......A...",
  "..........",
  "..........",
}

local test_data_03 = {
  "T.........",
  "...T......",
  ".T........",
  "..........",
  "..........",
  "..........",
  "..........",
  "..........",
  "..........",
  "..........",
}

t.test('Part 01', function()
  local result = part_01(test_data)
  t.expect_equal(result, 14)
end)

t.test('Part 01 - Example #2', function()
  local result = part_01(test_data_02)
  t.expect_equal(result, 4)
end)

t.test('Part 01 - Result', function()
  local result = part_01(input)
  t.expect_equal(result, 398)
end)

t.test('Part 02', function()
  local result = part_02(test_data)
  t.expect_equal(result, 34)
end)

t.test('Part 02 - Example #2', function()
  local result = part_02(test_data_03)
  t.expect_equal(result, 9)
end)

t.test('Part 02 - Result', function()
  local result = part_02(input)
  t.expect_equal(result, 1333)
end)

print("Part 01:", part_01(input))
print("Part 02:", part_02(input))
