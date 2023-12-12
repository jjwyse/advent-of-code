# frozen_string_literal: true

##########
# Part 1 #
##########
file = File.open("#{Dir.pwd}/2023/day-09/input.txt")
lines = file.readlines.map(&:chomp).map(&:to_s)

histories = lines.map do |line|
  line.split(' ').map(&:to_i)
end

results = {}
histories.each_with_index do |history, index|
  results[index] = [] if results[index].nil?
  results[index] << history

  loop do
    processing = results[index].last
    differences = processing.map.with_index do |cell, index|
      next if index.zero?

      cell - processing[index - 1]
    end.compact

    results[index] << differences
    break if differences.all?(&:zero?)
  end

  # Now need to add values starting at the bottom and moving up
  bucket = results[index].reverse
  bucket.each_with_index do |values, index|
    if index.zero?
      values << 0
      next
    end

    values << bucket[index - 1].last + values.last
  end
end

next_values = results.map do |key, values|
  values[0].last
end
pp next_values.sum