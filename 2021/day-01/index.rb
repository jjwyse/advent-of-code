########
# Part 1
########
file = File.open('input.txt')
readings = file.readlines.map(&:chomp).map(&:to_i)

def count_increases(readings:)
  readings.map.each_with_index do |reading, index|
    next if index == 0
    reading > readings[index-1]
  end
  .select { |increased| increased }
  .count
end

part_1_count = count_increases(readings: readings)
pp part_1_count
raise 'fail!' if part_1_count != 1301

########
# Part 2
########

file = File.open('input.txt')
readings = file.readlines.map(&:chomp).map(&:to_i)
three_msmt_readings = readings.map.each_with_index do |reading, index|
  # We will skip the last 2 readings
  next if index == readings.length - 2 || index == readings.length - 1
  reading + readings[index + 1] + readings[index + 2]
end
.compact

part_2_count = count_increases(readings: three_msmt_readings)
pp part_2_count
raise 'fail!' if part_1_count != 1346
