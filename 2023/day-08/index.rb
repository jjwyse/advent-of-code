# frozen_string_literal: true

#
##########
# Part 1 #
##########
file = File.open("#{Dir.pwd}/2023/day-08/input.txt")
lines = file.readlines.map(&:chomp).map(&:to_s)

directions = lines.first.split('')
map = {}
lines.each.with_index do |line, index|
  next if index <= 1

  location = line.split('=')[0].chomp[0..2]
  left = line.split('=').map(&:chomp)[1].split(',')[0][2..-1]
  right = line.split('=').map(&:chomp)[1].split(',')[1][1..-2]
  map[location] = [left, right]
end

# location = 'AAA'
# ending_location = 'ZZZ'
# index = 0
# num_steps = 0
# loop do
#   num_steps += 1
#   direction = directions[index % directions.length]
#   location = direction == 'L' ? map[location][0] : map[location][1]
#   index += 1
#   break if location == ending_location
# end

# pp num_steps
# 21389

location = map.keys.select { |location| location.end_with?('A') }[5]
ending_locations = map.keys.select { |location| location.end_with?('Z') }
index = 0
num_steps = 0

loop do
  direction = directions[index % directions.length]
  # locations = locations.map do |location|
  location = direction == 'L' ? map[location][0] : map[location][1]
  pp "Moving #{direction} to #{location}"
  # end
  num_steps += 1
  index += 1
  break if ending_locations.include?(location)
end

pp num_steps

# 0 = 23147
# 1 = 19631
# 2 = 12599
# 3 = 21389
# 4 = 17873
# 5 = 20803
# least common multiple = 21083806112641 per https://www.calculator.net/lcm-calculator.html?numberinputs=23147%2C19631%2C12599%2C21389%2C17873%2C20803&x=Calculate
