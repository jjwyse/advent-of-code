# frozen_string_literal: true

##########
# Part 1 #
##########
calibration_document = File.open('input.txt')
readings = calibration_document.readlines.map(&:chomp).map(&:to_s)
calibration_values = readings.map do |reading|
  ints = reading.split('').map do |char|
    char =~ /[0-9]/ ? char.to_i : nil
  end.compact

  "#{ints.first}#{ints.last}".to_i
end

# 54,877
calibration_values.sum

##########
# Part 2 #
##########
num_strings = {
  'one': 1,
  'two': 2,
  'three': 3,
  'four': 4,
  'five': 5,
  'six': 6,
  'seven': 7,
  'eight': 8,
  'nine': 9
}

def indices_of_matches(string:, search:)
  sz = search.size
  (0..string.size - sz).select { |i| string[i, sz] == search }
end

calibration_document = File.open('input.txt')
readings = calibration_document.readlines.map(&:chomp).map(&:to_s)
calibration_values = readings.map do |reading|
  # Save the indexes of each number in string format (if any)
  string_indexes = []
  num_strings.each_key do |num_string|
    indexes = indices_of_matches(string: reading, search: num_string.to_s)
    next if indexes.empty?

    indexes.each do |index|
      string_indexes << [index, num_strings[num_string]]
    end
  end

  num_indexes = reading.split('').map.with_index do |char, index|
    char =~ /[0-9]/ ? [index, char.to_i] : nil
  end.compact

  indexes = (string_indexes + num_indexes).sort_by { |index, _| index }

  "#{indexes.first.last}#{indexes.last.last}".to_i
end

pp calibration_values
pp calibration_values.sum
