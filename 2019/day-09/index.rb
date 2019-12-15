codes = File.open('input.txt').readlines[0].chomp.split(',').map(&:to_i)

###################
# Part 1
###################
# TODO
#  - [ ] Handle new parameter mode, called "relative" mode.  This mode is defined with a 2.  Same as position mode, except
#        the address position is found by doing relative_base_mode + relative_position_value.
#  - [ ] Opcode 9 adjusts the relative base by the value of its only parameter. For example, if the relative base is 2000,
#        then after the instruction 109,19, the relative base would be 2019.
#  - [ ] Add support for the computer's available to be much larger than the initial program. (I think already supported.)

OPCODE_INDEX = 0..1
PARAMETER_1_INDEX = 2
PARAMETER_2_INDEX = 3
PARAMETER_3_INDEX = 4

POSITION_MODE = 0
IMMEDIATE_MODE = 1
RELATIVE_MODE = 2

def get_parameter(mode:, index:, base_index:, codes:)
  case mode
    when POSITION_MODE
      codes[codes[index]]
    when IMMEDIATE_MODE
      codes[index]
    when RELATIVE_MODE
      codes[codes[index] + base_index]
    else
      raise "Encountered unknown parameter mode #{mode}"
  end
end

def get_write_parameter(mode:, index:, base_index:, codes:)
  case mode
    when RELATIVE_MODE
      codes[index] + base_index
    else
      codes[index]
  end
end

def intcode_calculate(codes:, input:)
  # State machine mutable variables
  opcode_index = 0
  base_index = 0
  outputs = []

  while opcode_index < codes.length
    # Get instruction for next code
    #
    # ABCDE
    #  1002
    #
    #DE - two-digit opcode,      02 == opcode 2
    # C - mode of 1st parameter,  0 == position mode
    # B - mode of 2nd parameter,  1 == immediate mode
    # A - mode of 3rd parameter,  0 == position mode,

    # eg: 1002
    instruction = codes[opcode_index]

    # eg: [2, 0, 0, 1]
    instruction_digits = instruction.digits

    opcode = instruction_digits[OPCODE_INDEX].reverse.join.to_i

    p1_mode = instruction_digits[PARAMETER_1_INDEX] || 0
    p2_mode = instruction_digits[PARAMETER_2_INDEX] || 0
    p3_mode = instruction_digits[PARAMETER_3_INDEX] || 0

    p1 = get_parameter(mode: p1_mode, index: opcode_index + 1, base_index: base_index, codes: codes).to_i
    p2 = get_parameter(mode: p2_mode, index: opcode_index + 2, base_index: base_index, codes: codes).to_i
    p3 = get_write_parameter(mode: p3_mode, index: opcode_index + 3, base_index: base_index, codes: codes)

    case opcode
      when 1
        codes[p3] = p1 + p2
        opcode_index += 4
      when 2
        codes[p3] = p1 * p2
        opcode_index += 4
      when 3
        # Only place where we write to a place that is *not* p3
        idx = get_write_parameter(mode: p1_mode, index: opcode_index + 1, base_index: base_index, codes: codes)
        codes[idx] = input
        opcode_index += 2
      when 4
        outputs << p1
        opcode_index += 2
      when 5
        if p1 != 0
          opcode_index = p2
        else
          opcode_index += 3
        end
      when 6
        if p1 == 0
          opcode_index = p2
        else
          opcode_index += 3
        end
      when 7
        if p1 < p2
          codes[p3] = 1
        else
          codes[p3] = 0
        end
        opcode_index += 4
      when 8
        if p1 == p2
          codes[p3] = 1
        else
          codes[p3] = 0
        end
        opcode_index += 4
      when 9
        base_index += p1
        opcode_index += 2
      when 99
        pp "Halting!"
        return outputs
      else
        raise "Encountered unknown opcode #{opcode}"
    end
  end
end

pp intcode_calculate(codes: codes.dup, input: 1)

