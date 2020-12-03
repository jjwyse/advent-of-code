##########
# PART 1 #
##########

def password_counter(file_name, is_valid_password_fn):
  f = open(file_name, "r")
  inputs = f.read().splitlines()

  # Counter
  num_valid_passwords = 0

  for input in inputs:
    # eg - ['1-3', 'a:', 'abcde']
    split_input = input.split(' ')

    # Parse the min, max
    min = int(split_input[0].split('-')[0])
    max = int(split_input[0].split('-')[1])

    # Parse the character (trimming off the ':')
    character = split_input[1][0]

    # Parse the password
    password = split_input[2]

    if is_valid_password_fn(min, max, character, password):
      num_valid_passwords += 1

  return num_valid_passwords

def is_valid_password_part_1(min, max, character, password):
  counter = 0

  for char in password:
    if char == character:
      counter += 1

  if (counter >= min and counter <= max):
    return True

  return False

#########
# TESTS #
#########

# test_input.txt should have 2 valid passwords
num = password_counter('test_input.txt', is_valid_password_part_1)
if num != 2:
  raise Exception('Test 1 failed!', 2, num_valid_passwords)

# input.txt should have 422 valid passwords
num = password_counter('input.txt', is_valid_password_part_1)
if num != 422:
  raise Exception('Test 2 failed!', 422, num_valid_passwords)

##########
# PART 2 #
##########

def is_valid_password_part_2(index_one, index_two, character, password):
  # xor
  if (password[index_one - 1] == character) != (password[index_two - 1] == character):
    return True

  return False

#########
# TESTS #
#########
num = password_counter('test_input.txt', is_valid_password_part_2)
if num != 1:
  raise Exception('Test 3 failed!', 1, num)

num = password_counter('input.txt', is_valid_password_part_2)
if num != 451:
  raise Exception('Test 3 failed!', 451, num)
