# frozen_string_literal: true

##########
# Part 1 #
##########
file = File.open("#{Dir.pwd}/2023/day-06/input.txt")
lines = file.readlines.map(&:chomp).map(&:to_s)
times = lines[0].split(':')[1].chomp.split(' ').map(&:chomp).map(&:to_i)
distances = lines[1].split(':')[1].chomp.split(' ').map(&:chomp).map(&:to_i)

races = times.map.with_index do |time, index|
  {
    race: index + 1,
    time: time,
    record_distance: distances[index]
  }
end

winning_distances = races.map do |race|
  (1..(race[:time] - 1)).map do |charging_time|
    time_left = race[:time] - charging_time
    speed = charging_time
    distance = speed * time_left

    distance > race[:record_distance] ? distance : nil
  end.compact
end

pp winning_distances.map(&:count).inject(:*)
# 1312850
