###################
# Part 1
###################
# Password notes:
#  - It is a six-digit number.
#  - The value is within the range given in your puzzle input.
#  - Two adjacent digits are the same (like 22 in 122345).
#  - Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).

def find_possible_passwords(range:)
  min = range.split('-')[0].to_i
  max = range.split('-')[1].to_i

  valid_passwords = (min..max).map do |possible_password|
    # eg 103_080 => [1, 0, 3, 0, 8, 0]
    digits_array = possible_password.to_s.split('').map(&:to_i)

    # Six-digit numbers only
    next if digits_array.length != 6

    # Must be in ascending order
    next if digits_array.sort != digits_array

    # Special filtering specific to each part of the puzzle
    next if !yield(digits_array)

    # Found one!
    possible_password
  end.compact

  valid_passwords
end

part_one_possible_passwords = find_possible_passwords(range: '284639-748759') do |digits_array|
  has_equal_adjacent_digits = false

  digits_array.each_with_index do |digit, index|
    # At the end, we're done
    next if index == digits_array.length - 1

    if digit == digits_array[index + 1]
      has_equal_adjacent_digits = true
    end
  end

  # Has to have at least one group of adjacent digits that are equivalent
  has_equal_adjacent_digits
end

pp part_one_possible_passwords.count

###################
# Part 2
###################
# Password additional notes:
#  - the two adjacent matching digits are not part of a larger group of matching digits

part_two_possible_passwords = find_possible_passwords(range: '284639-748759') do |digits_array|
  has_group_of_two = false

  digits_array_grouped_by_digit = digits_array.group_by(&:itself)

  digits_array.each_with_index do |digit, index|
    # At the end, we're done
    next if index == digits_array.length - 1

    if digit == digits_array[index + 1]
      # Make sure the number of these digits is %2 == 0.  Only need *1* pair for this password to be legit
      has_group_of_two = has_group_of_two || digits_array_grouped_by_digit[digit].length == 2
    end
  end

  # ALL repeated digits must be in groups of 2
  has_group_of_two
end

pp part_two_possible_passwords.count
