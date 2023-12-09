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

location = 'AAA'
ending_location = 'ZZZ'
index = 0
num_steps = 0
loop do
  num_steps += 1
  direction = directions[index % directions.length]
  pp "At #{location} and moving #{direction}"
  location = direction == 'L' ? map[location][0] : map[location][1]
  pp "Next location found was #{location}"
  index += 1
  break if location == ending_location
end

pp num_steps
