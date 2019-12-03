codes = File.open('input.txt').readlines.first.chomp.split(',').map(&:to_i)

###################
# Part 1
###################

# "Before begins, replace position 1 with the value 12 and replace position 2 with the value 2"

def intcode_calculate(codes:, address_one_value:, address_two_value:)
  codes[1] = address_one_value
  codes[2] = address_two_value

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

  codes[0]
end

pp intcode_calculate(codes: codes, address_one_value: 12, address_two_value: 2)

###################
# Part 2
###################

magic_result = 19_690_720
(0..99).each do |noun|
  (0..99).each do |verb|
    immutable_codes = File.open('input.txt').readlines.first.chomp.split(',').map(&:to_i)
    next unless intcode_calculate(codes: immutable_codes, address_one_value: noun, address_two_value: verb) == magic_result
    pp "noun: #{noun}"
    pp "verb: #{verb}"
    pp 100 * noun + verb
  end
end
