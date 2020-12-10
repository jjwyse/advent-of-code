def parse_input(file_name):
  all_group_answers = []
  with open(file_name, 'r') as file:
    current_group_answer = {}
    for line in file:
      line = line.strip()
      if not line:
        all_group_answers.append(current_group_answer)
        current_group_answer = {}
      else:
        for char in line:
          current_group_answer[char] = True

    all_group_answers.append(current_group_answer)

  return all_group_answers


def parse_input_part_2(file_name):
  num_group_members = 0
  all_group_answers = []
  with open(file_name, 'r') as file:
    current_group_answer = {}
    for line in file:
      line = line.strip()

      if not line:
        # Only keep keys where value == num_group_members
        unanimous_group_answer = {}
        for key in current_group_answer:
          if current_group_answer[key] == num_group_members:
            unanimous_group_answer[key] = True

        # Save
        all_group_answers.append(unanimous_group_answer)
        current_group_answer = {}
        num_group_members = 0
      else:
        # Keep track of how many members are in this group, and save to hash at end
        num_group_members += 1

        for char in line:
          if char not in current_group_answer:
            current_group_answer[char] = 1
          else:
            current_group_answer[char] += 1

    # Last group
    unanimous_group_answer = {}
    for key in current_group_answer:
      if current_group_answer[key] == num_group_members:
        unanimous_group_answer[key] = True
      all_group_answers.append(unanimous_group_answer)

  return all_group_answers


def count_unique_answers(answers):
  results = []
  for answer in answers:
    results.append(len(answer.keys()))

  return sum(results)


# Unit tests
inputs = parse_input('test_input.txt')
result = count_unique_answers(inputs)
if result != 11: raise Exception('Test failed!', 11, result)

# Part 1
inputs = parse_input('input.txt')
result = count_unique_answers(inputs)
if result != 7110: raise Exception('Test failed!', 7110, result)

# Part 2 - test input
inputs = parse_input_part_2('test_input.txt')
result = count_unique_answers(inputs)
if result != 6: raise Exception('Test failed!', 6, result)

# Part 2
inputs = parse_input_part_2('input.txt')
result = count_unique_answers(inputs)
print(result)
