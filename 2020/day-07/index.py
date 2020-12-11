def parse_input(file_name):
  results = {}
  with open(file_name, 'r') as file:
    for line in file:
      # I tried to regex this and just need to level up there, so I went super yolo. Would much prefer a regex here.
      # First two words are always the outer color bag
      outer_color = ' '.join(line.split()[:2])
      results[outer_color] = {}

      # Remove the first four words from line, split, and combine
      inner_rules = ' '.join(line.split()[4:]).split(',')
      for inner_rule in inner_rules:
        inner_rule = inner_rule.strip()

        # No inner bags
        if inner_rule == 'no other bags.':
          continue

        inner_rule_array = inner_rule.split(' ')
        num = int(inner_rule_array[0])
        inner_color = inner_rule_array[1] + ' ' + inner_rule_array[2]
        results[outer_color][inner_color] = num

    return results


def count_bags_containing(rules, inner_color, num_bags):
  color_results = set()
  for outer_color in rules:
    if can_color_contain(rules, outer_color, inner_color, num_bags):
      color_results.add(outer_color)

  return color_results


def can_color_contain(rules, outer_color, inner_color, num_bags):
  node = rules[outer_color]
  if len(node.keys()) == 0:
    return False
  elif inner_color in node.keys():
    # The node contains the max number of this color it can contain. Make sure that max is >= how many bags we want
    # to carry.
    if node[inner_color] >= num_bags:
      return True
    else:
      return False
  else:
    # If any of these return True
    result = False
    for color in node.keys():
      if result:
        continue
      result = can_color_contain(rules, color, inner_color, num_bags)
    return result


# Test input
inputs = parse_input('test_input.txt')
results = count_bags_containing(inputs, 'shiny gold', 1)
if len(results) != 4: raise Exception('Test failed!', 4, len(results))

# Part 1
inputs = parse_input('input.txt')
results = count_bags_containing(inputs, 'shiny gold', 1)
print(len(results))
