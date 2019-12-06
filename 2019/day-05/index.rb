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
      when 5
        if parameter_1 != 0
          opcode_index = parameter_2
        else
          opcode_index += 3
        end
      when 6
        if parameter_1 == 0
          opcode_index = parameter_2
        else
          opcode_index += 3
        end
      when 7
        if parameter_1 < parameter_2
          codes[parameter_3] = 1
        else
          codes[parameter_3] = 0
        end
        opcode_index += 4
      when 8
        if parameter_1 == parameter_2
          codes[parameter_3] = 1
        else
          codes[parameter_3] = 0
        end
        opcode_index += 4
      when 99
        is_continue = false
      else
        raise "Encountered unknown opcode #{opcode}"
    end
  end

  codes
end

#codes= [3,9,8,9,10,9,4,9,99,-1,8] # 8:1, else 0
#codes = [3,9,7,9,10,9,4,9,99,-1,8] # <8:1 else 0
#codes = [3,3,1108,-1,8,3,4,3,99] # 8:1, else 0
#codes = [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9] # < 8:1 else 0
#codes = [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9]
#codes = [3,3,1105,-1,9,1101,0,0,12,4,12,99,1]
#codes = [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31, 1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104, 999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99]

intcode_calculate(codes: codes, input: 5)
