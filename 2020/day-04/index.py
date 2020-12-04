import re

# Super yolo
def hgt_validator(value):
  try:
    if 'cm' in value:
      return int(value[:3]) >= 150 and int(value[:3]) <= 193
    elif 'in' in value:
      return int(value[:2]) >= 59 and int(value[:2]) <= 76
    else:
       return False
  except ValueError:
    return False

HCL_REGEX = re.compile('^#[a-f0-9]{6}$')
ECL_LIST = ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth']
PID_REGEX = re.compile('^[0-9]{9}$')
REQUIRED_FIELDS = {
  'byr': lambda value: int(value) >= 1920 and int(value) <= 2002,
  'iyr': lambda value: int(value) >= 2010 and int(value) <= 2020,
  'eyr': lambda value: int(value) >= 2020 and int(value) <= 2030,
  'hgt': hgt_validator,
  'hcl': lambda value: HCL_REGEX.match(value),
  'ecl': lambda value: value in ECL_LIST,
  'pid': lambda value: PID_REGEX.match(value)
}

# Reads file into each unique passport
def parse_file(file_name):
  passports = []
  with open(file_name, 'r') as file:
    current_passport = {}
    for line in file:
      line = line.strip()
      if not line:
        passports.append(current_passport)
        current_passport = {}
      else:
        fields = line.split(' ')
        for field in fields:
          field = field.strip()
          key = field.split(':')[0]
          value = field.split(':')[1]
          current_passport[key] = value


    passports.append(current_passport)

  return passports

def count_valid(passports):
  valid_counter = 0
  for passport in passports:
    valid = True

    for field in REQUIRED_FIELDS.keys():
      if field not in passport:
        valid = False

    if valid: valid_counter += 1

  return valid_counter

def count_valid_part_2(passports):
  valid_counter = 0
  for passport in passports:
    valid = True

    for field in REQUIRED_FIELDS.keys():
      if field not in passport:
        valid = False
      else:
        # Call our callback function to determine if valid
        is_valid_fn = REQUIRED_FIELDS[field]
        if not is_valid_fn(passport[field]):
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
if num_valid != 182: raise Exception('Test failed!', num_valid, 182)

##########
# Part 2 #
##########

passports = parse_file('input.txt')
num_valid = count_valid_part_2(passports)
if num_valid != 109: raise Exception('Test failed!', num_valid, 109)
