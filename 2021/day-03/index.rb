# Borrowed from: https://www.jakeworth.com/binary-to-decimal-conversion-in-ruby/
class Binary
  def self.to_decimal(binary)
    raise ArgumentError if binary.match?(/[^01]/)

    binary.reverse.chars.map.with_index do |digit, index|
      digit.to_i * 2**index
    end.sum
  end
end

##########
# PART 1 #
##########

readings = File.open('input.txt').readlines.map(&:chomp)

def part_one(readings:)
  gamma_rate = ''
  epsilon_rate = ''

  # Assumes all binaries are the same size
  num_chars = readings.first.size - 1

  (0..num_chars).each do |i|
    num_zeroes = 0
    num_ones = 0
    readings.each do |reading|
      if reading[i] == '0'
        num_zeroes += 1
      elsif reading[i] == '1'
        num_ones += 1
      else
        raise('Not exhaustive!')
      end
    end

    if num_ones > num_zeroes
      gamma_rate << '1'
      epsilon_rate << '0'
    elsif num_ones < num_zeroes
      gamma_rate << '0'
      epsilon_rate << '1'
    else
      raise('wtf')
    end
  end

  Binary.to_decimal(gamma_rate) * Binary.to_decimal(epsilon_rate)
end

raise if part_one(readings: readings) != 845186;