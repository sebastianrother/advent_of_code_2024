local f = require('utils.file')
local t = require('utils.test')
local d = require('utils.debug')
local s = require('utils.string')

function part_01(input_data)
  rules, order = parse_input(input_data)
  print(d.dump(rules))
  local valid_orders = {}
  for i, order_seq in pairs(order) do
    print(order_seq)
    local printed_pages = {}
    local is_valid = true
    for j, order_page in pairs(s.split(order_seq, ',')) do
      local applicable_rules = rules[order_page]
      print("\nChecking page:" .. order_page)
      if applicable_rules == nil then
        table.insert(printed_pages, order_page)
        goto continue
      end

      for k, rule in pairs(applicable_rules) do
        print("Checking rule: " .. rule)
      end

      ::continue::
    end
  end
end

function parse_input(input_data)
  local parsed_input = split(input_data, "")

  -- Lookup: If index is reached, value should have been defined before
  local rules = {}
  for i, rule in pairs(parsed_input[1]) do
    local split_rule = s.split(rule, '|')
    if rules[split_rule[2]] == nil then rules[split_rule[2]] = {} end

    table.insert(rules[split_rule[2]], split_rule[1])
  end
  return rules, parsed_input[2]
end

function find(haystack_table, needle)
  for key, value in pairs(haystack_table) do
    if value == needle then
      return true
    end
  end
  return false
end

function split(haystack_table, needle)
  result = {}
  split_index = 1
  for key, value in pairs(haystack_table) do
    if result[split_index] == nil then
      result[split_index] = {}
    end

    if value == needle then
      split_index = split_index + 1
      goto continue
    end

    table.insert(result[split_index], value)

    ::continue::
  end

  return result
end

function part_02(input_data)
end

test_data = {
  "47|53",
  "97|13",
  "97|61",
  "97|47",
  "75|29",
  "61|13",
  "75|53",
  "29|13",
  "97|29",
  "53|29",
  "61|53",
  "97|53",
  "61|29",
  "47|13",
  "75|47",
  "97|75",
  "47|61",
  "75|61",
  "47|29",
  "75|13",
  "53|13",
  "",
  "75,47,61,53,29",
  "97,61,53,29,13",
  "75,29,13",
  "75,97,47,61,53",
  "61,13,29",
  "97,13,75,29,47",
}

t.test('Part 01', function()
  result = part_01(test_data)
  t.expect_equal(result, 143)
end)
