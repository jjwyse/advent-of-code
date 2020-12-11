import copy

################
# INSTRUCTIONS #
################

#######
# acc #
#######
# increases or decreases a single global value called the accumulator by the value given in the argument.
# For example, acc +7 would increase the accumulator by 7. The accumulator starts at 0. After an acc instruction,
# the instruction immediately below it is executed next.

#######
# jmp #
#######
# jumps to a new instruction relative to itself. The next instruction to execute is found using the argument as an
# offset from the jmp instruction; for example, jmp +2 would skip the next instruction, jmp +1 would continue to the
# instruction immediately below it, and jmp -20 would cause the instruction 20 lines above to be executed next.

#######
# nop #
#######
# stands for No OPeration - it does nothing. The instruction immediately below it is executed next.

def parse_input(file_name):
  instructions = []
  with open(file_name, 'r') as file:
    for line in file.readlines():
      line = line.strip()
      split = line.split(' ')
      instructions.append({
        'operation': split[0],
        'argument': int(split[1][1:]) if split[1].startswith('+') else -1 * int(split[1][1:]),
      })

  return instructions


def run_boot_code(instructions):
  # Global variables for this function
  accumulator = 0
  current_instruction_index = 0
  visited_instruction_indexes = []

  while True:
    if current_instruction_index in visited_instruction_indexes:
      break

    instruction = instructions[current_instruction_index]

    # These are the two values that exist in the instruction dict
    operation = instruction['operation']
    argument = instruction['argument']

    # If we hit an instruction more than once, we hit the infinite loop and should bail!
    visited_instruction_indexes.append(current_instruction_index)

    if operation == 'nop':
      # Just skips to run the next instruction
      current_instruction_index += 1
    elif operation == 'acc':
      # Increments accumulator by the argument to acc, then runs the next instruction
      accumulator += argument
      current_instruction_index += 1
    elif operation == 'jmp':
      current_instruction_index += argument
    else:
      raise Exception('Not exhaustive!')

  return accumulator


def run_boot_code_part_2(instructions):
  # Global variables for this function
  accumulator = 0
  current_instruction_index = 0
  visited_instruction_indexes = []

  while True:
    if current_instruction_index == len(instructions):
      return accumulator

    if current_instruction_index in visited_instruction_indexes:
      return -1

    instruction = instructions[current_instruction_index]

    # These are the two values that exist in the instruction dict
    operation = instruction['operation']
    argument = instruction['argument']

    # If we hit an instruction more than once, we hit the infinite loop and should bail!
    visited_instruction_indexes.append(current_instruction_index)

    if operation == 'nop':
      # Just skips to run the next instruction
      current_instruction_index += 1
    elif operation == 'acc':
      # Increments accumulator by the argument to acc, then runs the next instruction
      accumulator += argument
      current_instruction_index += 1
    elif operation == 'jmp':
      current_instruction_index += argument
    else:
      raise Exception('Not exhaustive!')


def brute_force_me(instructions):
  index = -1
  while True:
    index += 1
    instructions_copy = copy.deepcopy(instructions)

    if index >= len(instructions_copy):
      raise Exception('Failure.')

    if instructions_copy[index]['operation'] == 'nop':
      instructions_copy[index]['operation'] = 'jmp'
    elif instructions_copy[index]['operation'] == 'jmp':
      instructions_copy[index]['operation'] = 'nop'
    else:
      continue

    r = run_boot_code_part_2(instructions_copy)
    if r > 0:
      return r


# Part 1 - test input
inputs = parse_input('test_input.txt')
result = run_boot_code(inputs)
if result != 5: raise Exception('Test failed!', 5, result)

# Part 1
inputs = parse_input('input.txt')
result = run_boot_code(inputs)
if result != 1744: raise Exception('Test failed!', 1744, result)

# Part 2 - test input
inputs = parse_input('test_input.txt')
result = brute_force_me(inputs)
if result != 8: raise Exception('Test failed!', 8, result)

# Part 2
inputs = parse_input('input.txt')
result = brute_force_me(inputs)
if result != 1174: raise Exception('Test failed!', 1174, result)
