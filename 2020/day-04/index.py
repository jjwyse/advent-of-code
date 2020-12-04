REQUIRED_FIELDS = ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid']

# Reads file into each unique passport
def parse_file(file_name):
  passports = []
  with open(file_name, 'r') as file:
    current_passport = ''
    for line in file:
      line = line.strip()
      if not line:
        passports.append(current_passport)
        current_passport = ''
      else:
        current_passport += ' ' + line

    passports.append(current_passport)

  return passports

def count_valid(passports):
  valid_counter = 0
  for passport in passports:
    valid = True
    for field in REQUIRED_FIELDS:
      if field not in passport:
        valid = False
    if valid: valid_counter += 1

  return valid_counter

##########
# Part 1 #
##########

passports = parse_file('test_input.txt')
num_valid = count_valid(passports)
if num_valid != 2: raise Exception('Test failed!', num_valid, 2)

passports = parse_file('input.txt')
num_valid = count_valid(passports)
print(num_valid)

