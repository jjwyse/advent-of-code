def is_valid_password(min, max, character, password):
  counter = 0

  for char in password:
    if char == character:
      counter += 1

  if (counter >= min and counter <= max):
    return True

  return False

def valid_password_count(file_name):
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

    if is_valid_password(min, max, character, password):
      num_valid_passwords += 1

  return num_valid_passwords

# test_input.txt should have 2 valid passwords
num = valid_password_count('test_input.txt')
if num != 2:
  raise Exception('Test 1 failed!', 2, num_valid_passwords)

# input.txt should have 422 valid passwords
num = valid_password_count('input.txt')
if num != 422:
  raise Exception('Test 2 failed!', 422, num_valid_passwords)
