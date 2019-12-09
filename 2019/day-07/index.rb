codes = File.open('input.txt').readlines.first.split(',').map(&:chomp).map(&:to_i)

###################
# Part 1
###################
#
# The first amplifier's input value is 0
#
# Each amplifier will need to run a copy of the program.
#
# When a copy of the program starts running on an amplifier, it will first use an input instruction to ask the amplifier
# for its current phase setting (an integer from 0 to 4). Each phase setting is used exactly once.
#
# GOAL: Find the largest output signal that can be sent to the thrusters

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

def intcode_calculate(codes:, input:, phase_setting:)
  # State machine mutable variables
  is_continue = true
  used_phase_setting = false
  opcode_index = 0
  output = nil

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
      when 99
        is_continue = false
        opcode_index += 4
      else
        raise "Encountered unknown opcode #{opcode}"
    end
  end

  output
end

#max = -1
#
#[0,1,2,3,4].permutation.to_a.each do |phase_settings|
#  next_input = 0
#  phase_result = -1
#
#  # Running all 5 amplifiers
#  phase_settings.each_with_index do |phase_setting, index|
#    # Run intcode calculations
#    result = intcode_calculate(codes: codes, input: next_input, phase_setting: phase_setting)
#    next_input = result
#
#    # Save phase_result if we're on the last amplifier
#    phase_result = result if index == 4
#  end
#
#  if phase_result > max
#    max = phase_result
#  end
#end
#
#pp max

###################
# Part 2
###################

def run_amplifiers(codes:, phase_setting:, next_input: 0)
  amp_1_result = intcode_calculate(codes: codes.dup, input: 0, phase_setting: phase_setting[0])
  amp_2_result = intcode_calculate(codes: codes.dup, input: amp_1_result, phase_setting: phase_setting[1])
  amp_3_result = intcode_calculate(codes: codes.dup, input: amp_2_result, phase_setting: phase_setting[2])
  amp_4_result = intcode_calculate(codes: codes.dup, input: amp_3_result, phase_setting: phase_setting[3])
  amp_5_result = intcode_calculate(codes: codes.dup, input: amp_4_result, phase_setting: phase_setting[4])

  amp_5_result
end

[5, 6, 7, 8, 9].permutation.to_a.each do |phase_setting|
  result = run_amplifiers(codes: codes.dup, phase_setting: phase_setting)
  pp result
end

