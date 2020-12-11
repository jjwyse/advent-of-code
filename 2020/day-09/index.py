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

  return False


# Part 1 - test
inputs = parse_input('test_input.txt')
answer = find_faulty_number(inputs, 5, 5)
if answer != 127: raise Exception('Test failed!', 127, answer)

# Part 1
inputs = parse_input('input.txt')
answer = find_faulty_number(inputs, 25, 25)
if answer != 22477624: raise Exception('Test failed!', 22477624, answer)
