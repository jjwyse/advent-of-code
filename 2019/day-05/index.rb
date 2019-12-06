# Read in codes
codes = File.open('input.txt').readlines.first.chomp.split(',').map(&:to_i)

OPCODE_INDEX = 0..1
PARAMETER_1_INDEX = 2
PARAMETER_2_INDEX = 3
PARAMETER_3_INDEX = 4

POSITION_MODE = 0
IMMEDIATE_MODE = 1

###################
# Part 1
###################

def get_parameter(mode:, index:, codes:)
  result = nil
  if mode == POSITION_MODE
    index_of_parameter = codes[index]
    result = codes[index_of_parameter] if !index_of_parameter.nil?
  elsif mode == IMMEDIATE_MODE
    result = codes[index]
  end
  result
end

def intcode_calculate(codes:, input:)
  # State machine mutable variables
  is_continue = true
  opcode_index = 0

  while is_continue
    # Get instruction for next code
    instruction = codes[opcode_index]
    instruction_digits = instruction.digits

    # Determine parameters
    opcode = instruction_digits[OPCODE_INDEX].reverse.join.to_i

    parameter_1_mode = instruction_digits[PARAMETER_1_INDEX] || 0
    parameter_2_mode = instruction_digits[PARAMETER_2_INDEX] || 0

    parameter_1 = get_parameter(mode: parameter_1_mode, index: opcode_index + 1, codes: codes)
    parameter_2 = get_parameter(mode: parameter_2_mode, index: opcode_index + 2, codes: codes)
    parameter_3 = codes[opcode_index + 3]

    # Will be modified depending on the opcode, and how many instructions it takes

    case opcode
      when 1, 2
        result = opcode == 1 ? parameter_1 + parameter_2 : parameter_1 * parameter_2
        codes[parameter_3] = result
        opcode_index += 4
      when 3
        result_index = codes[opcode_index + 1]
        codes[result_index] = input

        opcode_index += 2
      when 4
        pp "Output value at index: #{opcode_index + 1} is #{parameter_1}"
        opcode_index += 2
      when 99
        is_continue = false
      else
        raise "Encountered unknown opcode #{opcode}"
    end
  end

  codes
end

intcode_calculate(codes: codes, input: 1)
