local t = require("utils.test")
local d = require("utils.debug")
local f = require("utils.file")
local s = require("utils.string")

local function part_01(input)
  local result = {}

  for line_number, line in pairs(input) do
    local levels = s.split(line, ' ')
    local direction = nil

    for level_number = 2, #levels, 1 do
      local prev_score = levels[level_number - 1]
      local curr_score = levels[level_number]
      local diff = prev_score - curr_score
      local curr_dir = diff == 0 and 'NONE' or diff > 0 and 'DESC' or 'ASC' -- Inline ternary

      if math.abs(diff) > 3 then
        result[line_number] = 'FAIL'
        break
      end

      if curr_dir == 'NONE' then
        result[line_number] = 'FAIL'
        break
      end

      if direction == nil then
        direction = curr_dir
        goto continue
      end

      if direction ~= curr_dir then
        result[line_number] = 'FAIL'
        break
      end


      result[line_number] = 'SAFE'
      ::continue::
    end
  end

  local score = 0
  for _, status in pairs(result) do
    if status == 'SAFE' then
      score = score + 1
    end
  end

  return score
end

local function part_02(input)
  local result = {}

  for line_number, line in pairs(input) do
    local levels = s.split(line, ' ')
    local permutations = {}
    table.insert(permutations, levels)
    for i = 1, #levels, 1 do
      local levels_copy = { table.unpack(levels) }
      table.remove(levels_copy, i)
      table.insert(permutations, levels_copy)
    end


    local permutation_results = {}
    for permutation_number, permutation in pairs(permutations) do
      permutation_results[permutation_number] = {}
      local direction = nil
      for level_number = 2, #permutation, 1 do
        local prev_score = permutation[level_number - 1]
        local curr_score = permutation[level_number]
        local diff = prev_score - curr_score
        local curr_dir = diff == 0 and 'NONE' or diff > 0 and 'DESC' or 'ASC' -- Inline ternary
        local level_result = {
          difference_to_large = math.abs(diff) > 3,
          no_direction = curr_dir == 'NONE',
          direction_mismatch = direction ~= nil and curr_dir ~= 'NONE' and curr_dir ~= direction or false
        }

        if direction == nil and curr_dir ~= 'NONE' then
          direction = curr_dir
        end

        local failure_count = count(level_result, true)
        permutation_results[permutation_number][level_number] = failure_count > 0 and 'FAIL' or 'CLEAR'
      end
    end

    result[line_number] = 'FAIL'
    for permutation_number, permutation_result in pairs(permutation_results) do
      if count(permutation_result, 'CLEAR') >= #permutations[permutation_number] - 1 then
        result[line_number] = 'CLEAR'
      end
    end

  end

  return count(result, 'CLEAR')
end

function count(haystack_table, needle)
  local counter = 0
  for key, value in pairs(haystack_table) do
    if value == needle then counter = counter + 1 end
  end
  return counter
end

local test_input = {
  "7 6 4 2 1",
  "1 2 7 8 9",
  "9 7 6 2 1",
  "1 3 2 4 5",
  "8 6 4 4 1",
  "1 3 6 7 9",
}

t.test("Part 01", function()
  local result = part_01(test_input)
  t.expect_equal(result, 2)
end)

t.test("Part 02", function()
  local result = part_02(test_input)
  t.expect_equal(result, 4)
end)

print('Result Part 01', part_01(f.get_file_contents('day_02/input.txt')))
print('Result Part 02', part_02(f.get_file_contents('day_02/input.txt')))
