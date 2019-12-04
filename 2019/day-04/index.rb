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

    has_equal_adjacent_digits = false
    digits_array.each_with_index do |digit, index|
      # At the end, we're done
      next if index == digits_array.length - 1
      if digit == digits_array[index + 1]
        has_equal_adjacent_digits = true
      end
    end

    # Has to have at least one group of adjacent digits that are equivalent
    next if !has_equal_adjacent_digits

    # Found one!
    possible_password
  end.compact

  valid_passwords
end

range = '284639-748759'
possible_passwords = find_possible_passwords(range: range)
pp possible_passwords.count
