password = File.open('input.txt').readlines.first.chomp

###################
# Part 1
###################
# TODO
#  1. Handle new parameter mode, called "relative" mode.  This mode is defined with a 2.  Same as position mode, except
#     the address position is found by doing relative_base_mode + relative_position_value.
#  2. Opcode 9 adjusts the relative base by the value of its only parameter. For example, if the relative base is 2000,
#     then after the instruction 109,19, the relative base would be 2019.
#  3. Add support for the computer's available to be much larger than the initial program. (I think already supported.)

OPCODE_INDEX = 0..1
PARAMETER_1_INDEX = 2
PARAMETER_2_INDEX = 3
PARAMETER_3_INDEX = 4

POSITION_MODE = 0
IMMEDIATE_MODE = 1
RELATIVE_MODE = 2

def get_parameter(mode:, index:, relative_position_base_index:, codes:)
  case mode
    when POSITION_MODE
      index_of_parameter = codes[index]
      codes[index_of_parameter]
    when IMMEDIATE_MODE
      codes[index]
    when RELATIVE_MODE
      index_of_parameter = codes[relative_position_base_index + index]
      codes[index_of_parameter]
    else
      raise "Encountered unknown parameter mode #{mode}"
  end
end

def intcode_calculate(codes:, input:, phase_setting:)
  # State machine mutable variables
  is_continue = true
  used_phase_setting = false
  opcode_index = 0
  output = nil
  relative_position_base_index = 0

  while is_continue
    # Get instruction for next code
    instruction = codes[opcode_index]
    instruction_digits = instruction.digits

    # Determine parameters
    opcode = instruction_digits[OPCODE_INDEX].reverse.join.to_i

    parameter_1_mode = instruction_digits[PARAMETER_1_INDEX] || 0
    parameter_2_mode = instruction_digits[PARAMETER_2_INDEX] || 0

    parameter_1 = get_parameter(mode: parameter_1_mode, index: opcode_index + 1, relative_position_base_index: relative_position_base_index, codes: codes)
    parameter_2 = get_parameter(mode: parameter_2_mode, index: opcode_index + 2, relative_position_base_index: relative_position_base_index, codes: codes)
    parameter_3 = codes[opcode_index + 3]

    # Will be modified depending on the opcode, and how many instructions it takes
    case opcode
      when 1, 2
        result = opcode == 1 ? parameter_1 + parameter_2 : parameter_1 * parameter_2
        codes[parameter_3] = result
        opcode_index += 4
      when 3
        result_index = codes[opcode_index + 1]
        # Use phase_setting the first time, and input for all subsequent times we need an input
        codes[result_index] = used_phase_setting ? input : phase_setting
        used_phase_setting = true
        opcode_index += 2
      when 4
        output = parameter_1
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
      when 9
        relative_position_base_index = parameter_1
        opcode_index += 2
      when 99
        is_continue = false
        opcode_index += 4
      else
        raise "Encountered unknown opcode #{opcode}"
    end
  end

  output
end
