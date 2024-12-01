local function part_01(input_data)
  local list_1 = {}
  local list_2 = {}

  for key, value in pairs(input_data) do
    local locations = split(value, "   ")
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
    local locations = split(value, "   ")
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

local function test(test_name, fn)
  print("Running test: " .. test_name)
  local status, error = pcall(fn)
  if not status then
    print(error)
  end
end


function dump(data)
  if type(data) ~= 'table' then return tostring(data) end

  local prefix = '{\n'
  local suffix = '} '
  local result = ''
  for key, value in pairs(data) do
    if type(key) ~= 'number' then key = '"' .. key .. '"' end -- If key is not a number, put it in quotes
    result = result .. '[' .. key .. '] = "' .. dump(value) .. '",\n'
  end
  return prefix .. result .. suffix
end

function split(input_string, seperator)
  local result = {}
  for str in string.gmatch(input_string .. seperator, "(.-)(" .. seperator .. ")") do
    table.insert(result, str)
  end
  return result
end

function file_exists(file_path)
  local file = io.open(file_path, "rb")
  if file then file:close() end
  return file ~= nil
end

function get_file_contents(file_path)
  if not file_exists(file_path) then return {} end
  local lines = {}
  for line in io.lines(file_path) do
    lines[#lines + 1] = line
  end
  return lines
end

function expect_equal(value, expected)
  if value == nil then value = "" end
  return assert(value == expected, "\nReceived: " .. value .. '\nExpected: ' .. expected)
end

local test_data = {
  "3   4",
  "4   3",
  "2   5",
  "1   3",
  "3   9",
  "3   3",
}

test("Part 01", function()
  local result = part_01(test_data)
  expect_equal(result, 11)
end)

test("Part 02", function()
  local result = part_02(test_data)
  expect_equal(result, 31)
end)

print("Part 01: " .. part_01(get_file_contents('input.txt')))
print("Part 02: " .. part_02(get_file_contents('input.txt')))
