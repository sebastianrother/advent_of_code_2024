local f = require('utils.file')
local t = require('utils.test')
local d = require('utils.debug')
local s = require('utils.string')

local WORD = 'XMAS'
local function part_01(input_data)
  result = 0
  for row_index = 1, #input_data, 1 do
    local row = input_data[row_index]
    for char_index = 1, #row, 1 do
      found_words = find_word(input_data, row_index, char_index)
      result = result + found_words
    end
  end

  return result 
end

DIRECTIONS = {
  { 0,  1 },
  { 0,  -1 },
  { 1,  -1 },
  { 1,  0 },
  { 1,  1 },
  { -1, -1 },
  { -1, 0 },
  { -1, 1 }
}
function find_word(input_data, row_pos, char_pos)
  found_words = {}
  for i, direction in pairs(DIRECTIONS) do
    curr_word = ''
    for word_index = 0, #WORD - 1, 1 do
      local curr_row_pos = row_pos + direction[1] * word_index
      local curr_char_pos = char_pos + direction[2] * word_index
      if curr_row_pos < 1 or curr_row_pos > #input_data then goto next_direction end
      if curr_char_pos < 1 or curr_char_pos > #input_data[row_pos] then goto next_direction end

      local char = input_data[curr_row_pos]:sub(curr_char_pos, curr_char_pos)
      if char ~= WORD:sub(word_index + 1, word_index + 1) then
        goto next_direction
      end
      curr_word = curr_word .. char
    end
    table.insert(found_words, curr_word)
    ::next_direction::
  end
  return #found_words
end

local function part_02(input_data)
  local starting_points = {}
  for row_index = 1, #input_data, 1 do
    local row = input_data[row_index]
    for char_index = 1, #row, 1 do
      if row:sub(char_index, char_index) == 'A' then table.insert(starting_points, {row_index, char_index}) end
    end
  end

  local result = 0
  for i, starting_point in pairs(starting_points) do
    local is_xmas = check_is_xmas(input_data, starting_point[1], starting_point[2])
    if is_xmas then result = result + 1 end
  end

  return result
end

function check_is_xmas(input_data, row_pos, char_pos)
  local ltr = get_char(input_data, row_pos - 1, char_pos - 1) .. 'A' .. get_char(input_data, row_pos + 1, char_pos + 1)
  local rtl = get_char(input_data, row_pos - 1, char_pos + 1) .. 'A' .. get_char(input_data, row_pos + 1, char_pos - 1)

  if not (ltr == 'MAS' or ltr == 'SAM') then return false end
  if not (rtl == 'MAS' or rtl == 'SAM') then return false end
  return true
end

function get_char(input_data, row_pos, char_pos)
    if row_pos < 1 or row_pos > #input_data then return '' end
    if char_pos < 1 or char_pos > #input_data[row_pos] then return '' end
    return input_data[row_pos]:sub(char_pos, char_pos)
end

local test_data = {
  "MMMSXXMASM",
  "MSAMXMSMSA",
  "AMXSXMAAMM",
  "MSAMASMSMX",
  "XMASAMXAMM",
  "XXAMMXXAMA",
  "SMSMSASXSS",
  "SAXAMASAAA",
  "MAMMMXMMMM",
  "MXMXAXMASX",
}

t.test("Part 01", function()
  local result = part_01(test_data)
  t.expect_equal(result, 18)
end)

t.test("Part 02", function()
  local result = part_02(test_data)
  t.expect_equal(result, 9)
end)

print("Part 01:", part_01(f.get_file_contents('day_04/input.txt')))
print("Part 02:", part_02(f.get_file_contents('day_04/input.txt')))
