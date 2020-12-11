def parse_input(file_name):
  results = []
  with open(file_name, 'r') as file:
    for line in file.readlines():
      results.append(int(line))

  return results


def find_faulty_number(numbers, preamble_count, previous_count):
  index = preamble_count
  while True:
    number = numbers[index]
    found_match = False
    for i in range(index - previous_count, index):
      # Ew
      if found_match:
        continue

      for j in range(index - previous_count, index):
        if i == j:
          continue

        i_value = numbers[i]
        j_value = numbers[j]
        if i_value + j_value == number:
          found_match = True
          index += 1

    if not found_match:
      return number


def sum_numbers_in_range(numbers, min_index, max_index):
  summation = 0
  for i in range(min_index, max_index):
    summation += numbers[i]
  return summation


def find_faulty_number_part_2(numbers, magic_number):
  min_index = 0
  max_index = 1
  while True:
    if sum_numbers_in_range(numbers, min_index, max_index) == magic_number:
      results = []
      for i in range(min_index, max_index):
        results.append(numbers[i])
      results.sort()
      return results[0] + results[-1]
    else:
      if max_index >= len(numbers):
        min_index += 1
        max_index = min_index + 1
      else:
        max_index += 1


# Part 1 - test
inputs = parse_input('test_input.txt')
answer = find_faulty_number(inputs, 5, 5)
if answer != 127: raise Exception('Test failed!', 127, answer)

# Part 1
inputs = parse_input('input.txt')
answer = find_faulty_number(inputs, 25, 25)
if answer != 22477624: raise Exception('Test failed!', 22477624, answer)

# Part 2 - test
inputs = parse_input('test_input.txt')
answer = find_faulty_number_part_2(inputs, 127)
if answer != 62: raise Exception('Test failed!', 62, answer)

# Part 2
inputs = parse_input('input.txt')
answer = find_faulty_number_part_2(inputs, 22477624)
if answer != 2980044: raise Exception('Test failed!', 2980044, answer)
