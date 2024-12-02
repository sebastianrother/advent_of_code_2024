local t = require("utils.test")
local f = require("utils.file")
local d = require("utils.debug")
local s = require("utils.string")

local function part_01(input_data)
  local list_1 = {}
  local list_2 = {}

  for key, value in pairs(input_data) do
    local locations = M.split(value, "   ")
    table.insert(list_1, locations[1])
    table.insert(list_2, locations[2])
  end

  table.sort(list_1)
  table.sort(list_2)

  local result = 0
  for Key = 1, #list_1, 1 do
    result = result + math.abs(list_1[Key] - list_2[Key])
  end

  return result
end

local function part_02(input_data)
  local list_1 = {}
  local list_2 = {}

  for key, value in pairs(input_data) do
    local locations = M.split(value, "   ")
    table.insert(list_1, locations[1])
    table.insert(list_2, locations[2])
  end

  local list_2_count = {}
  for key, value in pairs(list_2) do
    if list_2_count[value] == nil then list_2_count[value] = 0 end
    list_2_count[value] = list_2_count[value] + 1
  end

  local result = 0
  for key, value in pairs(list_1) do
    if list_2_count[value] ~= nil then
      result = result + value * list_2_count[value]
    end
  end

  return result
end


local test_data = {
  "3   4",
  "4   3",
  "2   5",
  "1   3",
  "3   9",
  "3   3",
}

t.test("Part 01", function()
  local result = part_01(test_data)
  t.expect_equal(result, 11)
end)

t.test("Part 02", function()
  local result = part_02(test_data)
  t.expect_equal(result, 31)
end)

print("Part 01: " .. part_01(f.get_file_contents('day_01/input.txt')))
print("Part 02: " .. part_02(f.get_file_contents('day_01/input.txt')))
