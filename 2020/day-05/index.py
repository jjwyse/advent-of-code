import math


# 0-based
ROWS_ON_PLANE = 127
COLUMNS_ON_PLANE = 7


def parse_input(file_name):
  with open(file_name, 'r') as file:
    return file.read().splitlines()


def read_boarding_passes(boarding_passes):
  results = []
  for boarding_pass in boarding_passes:
    min_row = 0
    max_row = ROWS_ON_PLANE

    min_column = 0
    max_column = COLUMNS_ON_PLANE
    for char in boarding_pass:
      if char == 'F':
        max_row = min_row + math.floor((max_row - min_row) / 2)
      elif char == 'B':
        min_row = max_row - math.floor((max_row - min_row) / 2)
      elif char == 'L':
        max_column = min_column + math.floor((max_column - min_column) / 2)
      elif char == 'R':
        min_column = max_column - math.floor((max_column- min_column) / 2)

    # At this point, these should have found an answer. If they didn't, explicitly error
    if min_row != max_row: raise Exception('Did not find row!')
    if min_column != max_column: raise Exception('Did not find column!')

    # Nice, found a match - add to our results
    results.append(min_row * 8 + min_column)

  return results


# Yolo unit tests for #read_boarding_passes
inputs = parse_input('small_test_input.txt')
seats = read_boarding_passes(inputs)
if len(seats) != 1: raise Exception('Test failed!', 1, len(seats))
if seats[0] != 357: raise Exception('Test failed!', 357, seats[0])

# More unit tests
inputs = parse_input('test_input.txt')
seats = read_boarding_passes(inputs)
if max(seats) != 820: raise Exception('Test failed!', 820, max(seats))

# Part 1
inputs = parse_input('input.txt')
seats = read_boarding_passes(inputs)
if max(seats) != 978: raise Exception('Test failed!', 978, max(seats))
