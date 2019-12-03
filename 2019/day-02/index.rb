file = File.open('input.txt')
codes = file.readlines.first.chomp.split(',').map(&:to_i)

###################
# Part 1
###################

# "Before begins, replace position 1 with the value 12 and replace position 2 with the value 2"
codes[1] = 12
codes[2] = 2

is_continue = true
opcode_index = 0
while is_continue
  opcode = codes[opcode_index]
  case opcode
  when 1
    input_one_index = codes[opcode_index + 1]
    input_two_index = codes[opcode_index + 2]
    sum_index = codes[opcode_index + 3]

    sum = codes[input_one_index] + codes[input_two_index]
    codes[sum_index] = sum
  when 2
    product_one_index = codes[opcode_index + 1]
    product_two_index = codes[opcode_index + 2]
    product_index = codes[opcode_index + 3]

    product = codes[product_one_index] * codes[product_two_index]
    codes[product_index] = product
  when 99
    is_continue = false
  else
    raise "Encountered unknown opcode #{opcode}"
  end

  # Always move opcode_index by 4 positions
  opcode_index += 4
end

pp codes[0]

###################
# Part 2
###################
