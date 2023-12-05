# frozen_string_literal: true

require 'set'

##########
# Part 1 #
##########
file = File.open("#{Dir.pwd}/2023/day-03/input.txt")
schematic = file.readlines.map(&:chomp).map(&:to_s)

schematic_2d_array = Array.new(schematic[0].size) do
  Array.new(schematic.size) do
    0
  end
end

schematic.each_with_index do |schematic_row, row_index|
  schematic_row.split('').each_with_index do |char, col_index|
    schematic_2d_array[row_index][col_index] = char
  end
end

def symbol?(array, row_index, col_index)
  if row_index.negative? || col_index.negative?
    false
  elsif row_index >= array[0].size || col_index >= array.size
    false
  elsif array[row_index][col_index] =~ /[0-9]/
    false
  else
    array[row_index][col_index] != '.'
  end
end

numbers_with_symbols = []
is_symbol = false
current_number_indices = []
schematic_2d_array.each_with_index do |schematic_row, row_index|
  # If we detected a number at the end of the line, handle here
  if is_symbol && !current_number_indices.empty?
    number = current_number_indices.map { |indices| schematic_2d_array[indices[0]][indices[1]] }
    numbers_with_symbols << number.join.to_i
  end

  # Reset
  is_symbol = false
  current_number_indices = []

  schematic_row.each_with_index do |char, col_index|
    case char
    when /[0-9]/
      current_number_indices << [row_index, col_index]

      # Is there a symbol...

      # Above
      is_symbol ||= symbol?(schematic_2d_array, row_index - 1, col_index)

      # Below
      is_symbol ||= symbol?(schematic_2d_array, row_index + 1, col_index)

      # Left
      is_symbol ||= symbol?(schematic_2d_array, row_index, col_index - 1)

      # Right
      is_symbol ||= symbol?(schematic_2d_array, row_index, col_index + 1)

      # Upper left
      is_symbol ||= symbol?(schematic_2d_array, row_index - 1, col_index - 1)

      # Upper right
      is_symbol ||= symbol?(schematic_2d_array, row_index - 1, col_index + 1)

      # Lower left
      is_symbol ||= symbol?(schematic_2d_array, row_index + 1, col_index - 1)

      # Lower right
      is_symbol ||= symbol?(schematic_2d_array, row_index + 1, col_index + 1)
    else
      if is_symbol && !current_number_indices.empty?
        number = current_number_indices.map { |indices| schematic_2d_array[indices[0]][indices[1]] }
        numbers_with_symbols << number.join.to_i
      end

      is_symbol = false
      current_number_indices = []
    end
  end
end

# pp numbers_with_symbols.sum
# 498559

##########
# Part 2 #
##########

@star_indices = {}
schematic_2d_array.each_with_index do |schematic_row, row_index|
  schematic_row.each_with_index do |char, col_index|
    if char =~ /\*/
      @star_indices[row_index] = {} if @star_indices[row_index].nil?
      @star_indices[row_index][col_index] = Set.new if @star_indices[row_index][col_index].nil?
    end
  end
end

def star?(array, row_index, col_index)
  is_symbol = symbol?(array, row_index, col_index)
  is_symbol && array[row_index][col_index] =~ /\*/
end

def add_number_to_star(array, number, row_index, col_index)
  @star_indices[row_index - 1][col_index] << number if star?(array, row_index - 1, col_index)
  @star_indices[row_index + 1][col_index] << number if star?(array, row_index + 1, col_index)
  @star_indices[row_index][col_index - 1] << number if star?(array, row_index, col_index - 1)
  @star_indices[row_index][col_index + 1] << number if star?(array, row_index, col_index + 1)
  @star_indices[row_index - 1][col_index - 1] << number if star?(array, row_index - 1, col_index - 1)
  @star_indices[row_index - 1][col_index + 1] << number if star?(array, row_index - 1, col_index + 1)
  @star_indices[row_index + 1][col_index - 1] << number if star?(array, row_index + 1, col_index - 1)
  @star_indices[row_index + 1][col_index + 1] << number if star?(array, row_index + 1, col_index + 1)
end

# Go back through and see if any of our numbers hit one of the star locations
schematic_2d_array.each_with_index do |schematic_row, row_index|
  schematic_row.each_with_index do |char, col_index|
    case char
    when /[0-9]/
      current_number_indices << [row_index, col_index]
    else
      unless current_number_indices.empty?
        number = current_number_indices.map { |indices| schematic_2d_array[indices[0]][indices[1]] }.join.to_i
        current_number_indices.each do |indices|
          add_number_to_star(schematic_2d_array, number, indices[0], indices[1])
        end
      end

      current_number_indices = []
    end
  end
end

multiplied = @star_indices.values.map do |array|
  array.map do |inner|
    if inner[1].size == 2
      inner[1].to_a[0] * inner[1].to_a[1]
    end
  end.compact
end.compact.flatten

pp multiplied
pp multiplied.sum
# 72246648
