from __future__ import print_function

##########
# PART 1 #
##########
def print_2d_array(array):
  for i in range(len(array)):
    for j in range(len(array[i])):
      print(array[i][j], end = '')
    print()

def traverse(toboggan_map, col_steps, row_steps):
  num_trees = 0

  # Start in top-level corner (0, 0)
  row_num = 0
  col_num = 0
  while row_num < len(toboggan_map):
    # If we hit a tree, increment our tree counter
    if toboggan_map[row_num][col_num] == '#':
      num_trees += 1

    # Increment
    col_num = (col_num + col_steps) % len(toboggan_map[row_num])
    row_num += row_steps

  return num_trees

def build_map(file_name):
  f = open(file_name, 'r')
  inputs = f.read().splitlines()

  toboggan_map = []
  for row, line in enumerate(inputs):
    this_row = []
    toboggan_map.append(this_row)
    for column, char in enumerate(line):
      this_row.append(char)

  return toboggan_map


test_toboggan_map = build_map('test_input.txt')
num_trees_hit = traverse(test_toboggan_map, 3, 1)
if num_trees_hit != 7: raise Exception('Test failed!', num_trees_hit)


# Part 1
toboggan_map = build_map('input.txt')
num_trees_hit = traverse(toboggan_map, 3, 1)
if num_trees_hit != 184: raise Exception('Test failed!', num_trees_hit)

# Part 1
num_trees_hit = traverse(toboggan_map, 1, 1) * traverse(toboggan_map, 3, 1) * traverse(toboggan_map, 5, 1) * traverse(toboggan_map, 7, 1) * traverse(toboggan_map, 1, 2)
print(num_trees_hit)
