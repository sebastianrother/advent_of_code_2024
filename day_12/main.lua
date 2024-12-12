local f = require('utils.file')
local d = require('utils.debug')
local test = require('utils.test')
local input = f.get_file_contents('day_12/input.txt')

DIRECTIONS = {
  { -1, 0 },
  { 1,  0 },
  { 0,  -1 },
  { 0,  1 }
}

-- BRAINDUMP:
-- Price is dependent on the number of connected fields: Recursion?
-- Go through all the fields in the map. If already used, skip. Otherwise iterate and add to crop
function part_01(input_data)
  local landscape = {}
  for y, row in pairs(input_data) do
    landscape[y] = {}
    for x, char in chars(row) do
      landscape[y][x] = char
    end
  end

  for y, row in pairs(landscape) do
    for x, char in pairs(row) do
      print(y, x)
      find_cluster(landscape, { y = y, x = x }, char, y .. '__' .. x)
    end
  end

  total_price = 0
  for id, plots in pairs(VISITED) do
    if length(plots) == 0 then goto continue end
    character = nil
    area = length(plots)

    perimeter = 0
    for _, plot in pairs(plots) do
      perimeter = perimeter + (4 - plot.n)
      character = plot.c
    end

    -- print(character, area, perimeter)
    total_price = total_price + area * perimeter

    ::continue::
  end
  VISITED = {}

  return total_price
end

function length(tab)
  local count = 0
  for _ in pairs(tab) do count = count + 1 end
  return count
end

VISITED = {}
function find_cluster(map, location, character, cluster_id)
  if VISITED[cluster_id] == nil then VISITED[cluster_id] = {} end

  for _, cluster in pairs(VISITED) do
    for id, plot in pairs(cluster) do
      if id == location.y .. "__" .. location.x then return plot.c end
    end
  end

  if map[location.y][location.x] ~= character then return nil end

  VISITED[cluster_id][location.y .. "__" .. location.x] = { c = character }

  local neighbours = {}
  for _, direction in pairs(DIRECTIONS) do
    -- Check if out of bounds
    local curr_y = location.y + direction[1]
    local curr_x = location.x + direction[2]


    if curr_y > #map or curr_y < 1 then goto continue end
    if curr_x > #map[curr_y] or curr_x < 1 then goto continue end

    neighbour = find_cluster(map, { y = curr_y, x = curr_x }, character, cluster_id)
    if neighbour == character then table.insert(neighbours, character) end
    ::continue::
  end

  VISITED[cluster_id][location.y .. "__" .. location.x] = { c = character, n = #neighbours }

  return character
end

function chars(str)
  local i = 0

  return function()
    i = i + 1
    if i > #str then return nil end
    return i, str:sub(i, i)
  end
end

local test_data = {
  "AAAA",
  "BBCD",
  "BBCC",
  "EEEC",
}

local test_data_2 = {
  "OOOOO",
  "OXOXO",
  "OOOOO",
  "OXOXO",
  "OOOOO",
}
local test_data_3 = {
  "RRRRIICCFF",
  "RRRRIICCCF",
  "VVRRRCCFFF",
  "VVRCCCJFFF",
  "VVVVCJJCFE",
  "VVIVCCJJEE",
  "VVIIICJJEE",
  "MIIIIIJJEE",
  "MIIISIJEEE",
  "MMMISSJEEE",
}

test.test("Part 01 - Example #1", function()
  local result = part_01(test_data)
  test.expect_equal(result, 140)
end)

test.test("Part 01 - Example #2", function()
  local result = part_01(test_data_2)
  test.expect_equal(result, 772)
end)

test.test("Part 01 - Example #3", function()
  local result = part_01(test_data_3)
  test.expect_equal(result, 1930)
end)

test.test("Part 01 - Result", function()
  -- Very slow computation (should optimise)
  -- local result = part_01(test_data_3)
  -- test.expect_equal(result,1489582)
end)
