##########
# PART 1 #
##########

readings = File.open('input.txt').readlines.map(&:chomp)

def part_one(readings:)
  x = 0
  y = 0

  readings.each do |reading|
    if reading.start_with?('forward')
      x += reading.split(' ')[1].to_i
    elsif reading.start_with?('down')
      y += reading.split(' ')[1].to_i
    elsif reading.start_with?('up')
      y -= reading.split(' ')[1].to_i
    else
      raise('Not exhaustive!')
    end
  end

  x * y
end

raise if part_one(readings: readings) != 1459206

##########
# PART 2 #
##########

readings = File.open('input.txt').readlines.map(&:chomp)

aim = 0
x = 0
y = 0

readings.each do |reading|
  if reading.start_with?('forward')
    x += reading.split(' ')[1].to_i
    y += aim * reading.split(' ')[1].to_i
  elsif reading.start_with?('down')
    aim += reading.split(' ')[1].to_i
  elsif reading.start_with?('up')
    aim -= reading.split(' ')[1].to_i
  else
    raise('Not exhaustive!')
  end
end

pp [x, y]
pp x * y

