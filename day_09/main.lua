local f = require('utils.file')
local s = require('utils.string')
local d = require('utils.debug')
local test = require('utils.test')
local input = f.get_file_contents('day_09/input.txt')

function part_01(input_data)
  input_data = input_data[1]
  local memory_layout = parse_memory_to_seq(input_data)

  local i = 1
  local j = #memory_layout

  while i <= #memory_layout do
    if i == j then break end
    local mem = memory_layout[i]
    if mem ~= '.' then
      goto continue
    end

    while j >= 1 do
      local mem_2 = memory_layout[j]
      -- If swap, break
      if mem_2 ~= '.' then
        memory_layout[i] = mem_2
        memory_layout[j] = '.'
        break
      end

      j = j - 1
    end

    ::continue::
    i = i + 1
  end


  local result = 0
  for pos, val in pairs(memory_layout) do
    if val == '.' then break end
    result = result + (pos - 1) * val
  end

  return result
end

function parse_memory_to_seq(input_data)
  local memory_layout = {}
  local fragment_id = 0
  local memory_type = 'DATA' -- DATA or EMPTY

  for i = 1, #input_data do
    local data_fragment_length = input_data:sub(i, i)
    for j = 1, data_fragment_length do
      if memory_type == 'DATA' then table.insert(memory_layout, fragment_id) end
      if memory_type == 'EMPTY' then table.insert(memory_layout, '.') end
    end
    if memory_type == 'DATA' then
      fragment_id = fragment_id + 1
      memory_type = 'EMPTY'
    else
      memory_type = 'DATA'
    end
  end

  return memory_layout
end

function parse_memory_to_chunks(input_data)
  local memory_layout = {}
  local fragment_id = 0
  local memory_type = 'DATA' -- DATA or EMPTY

  for i = 1, #input_data do
    local data_fragment_length = input_data:sub(i, i)
    local type_id = memory_type == 'DATA' and fragment_id or '.'
    table.insert(memory_layout, { type_id, data_fragment_length })

    if memory_type == 'DATA' then
      fragment_id = fragment_id + 1
      memory_type = 'EMPTY'
    else
      memory_type = 'DATA'
    end
  end

  return memory_layout
end

function part_02(input_data)
  input_data = input_data[1]
  local memory_layout = parse_memory_to_chunks(input_data)

  local i = #memory_layout

  while i >= 1 do
    local j = 1
    local mem = memory_layout[i][1]
    local mem_len = memory_layout[i][2]

    if mem == '.' then goto continue end
    if mem_len == 0 then goto continue end

    while j < i do
      local mem_2 = memory_layout[j][1]
      local mem_2_len = memory_layout[j][2]
      -- print('MEMORY: ' .. mem, 'TARGET: ' .. mem_2, 'FREE: ' .. mem_2_len, 'NEEDED: ', mem_len)
      if mem_2 == '.' and tonumber(mem_2_len) >= tonumber(mem_len) then
        memory_layout[j][2] = mem_2_len - mem_len
        table.insert(memory_layout, j, memory_layout[i])
        table.remove(memory_layout, i + 1)
        table.insert(memory_layout, i, { '.', mem_len })
        break
      end

      j = j + 1
    end

    ::continue::
    i = i - 1
  end


  local seq = memory_chunks_to_seq(memory_layout)

  local result = 0
  for pos, val in pairs(seq) do
    if val ~= '.' then
      result = result + (pos - 1) * val
    end
  end

  return result
end

function memory_chunks_to_seq(memory_layout)
  local result = {}
  for pos, mem in pairs(memory_layout) do
    local i = 1
    while i <= tonumber(mem[2]) do
      table.insert(result, mem[1])
      i = i + 1
    end
  end

  return result
end

function join(input_table, join_str)
  local out = ''
  join_str = join_str or ''
  for i = 1, #input_table do
    local curr_join = i < #input_table and join_str or ''
    out = out .. input_table[i] .. curr_join
  end

  return out
end

local test_data = {
  "2333133121414131402"
}

test.test("Part 01 - Memory Parser", function()
  local result = parse_memory_to_seq(test_data[1])
  test.expect_equal(join(result), "00...111...2...333.44.5555.6666.777.888899")
end)

test.test("Part 01", function()
  local result = part_01(test_data)
  test.expect_equal(result, 1928)
end)

test.test("Part 01 - Result", function()
  local result = part_01(input)
  test.expect_equal(result, 6283170117911)
end)

test.test("Part 02", function()
  local result = part_02(test_data)
  test.expect_equal(result, 2858)
end)

test.test("Part 02 - Result", function()
  local result = part_02(test_data)
  test.expect_equal(result, 6307653242596)
end)
