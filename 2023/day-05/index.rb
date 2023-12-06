# frozen_string_literal: true

##########
# Part 1 #
##########
file = File.open("#{Dir.pwd}/2023/day-05/input.txt")
almanac = file.readlines.map(&:chomp).map(&:to_s)

# Parse seeds, first line
seed_ranges = almanac.first.split(':')[1].split(' ').map(&:to_i)
seeds = seed_ranges.map.with_index do |seed_start, index|
  next unless index.even?
  (seed_start..(seed_start + seed_ranges[index + 1] - 1)).map(&:to_i)
end.compact.flatten

# Parse mappings
active_array = nil
seed_to_soil = []
soil_to_fertilizer = []
fertilizer_to_water = []
water_to_light = []
light_to_temperature = []
temperature_to_humidity = []
humidity_to_location = []

almanac.each_with_index do |line, index|
  next if index.zero?
  next if index == 1

  case line
  when 'seed-to-soil map:'
    active_array = seed_to_soil
  when 'soil-to-fertilizer map:'
    active_array = soil_to_fertilizer
  when 'fertilizer-to-water map:'
    active_array = fertilizer_to_water
  when 'water-to-light map:'
    active_array = water_to_light
  when 'light-to-temperature map:'
    active_array = light_to_temperature
  when 'temperature-to-humidity map:'
    active_array = temperature_to_humidity
  when 'humidity-to-location map:'
    active_array = humidity_to_location
  when ''
    next
  else
    mappings = line.split(' ').map(&:to_i)
    source_start = mappings[1]
    destination_start = mappings[0]
    range = mappings[2]

    source_end = source_start + range - 1
    destination_end = destination_start + range - 1

    active_array << {
      source_start: source_start,
      source_end: source_end,
      destination_start: destination_start,
      destination_end: destination_end
    }
  end
end

def mapping(array, source)
  entries = array.select do |entry|
    source >= entry[:source_start] && source <= entry[:source_end]
  end
  return source if entries.empty?
  raise('wtf') if entries.count > 1

  entry = entries.first
  difference = source - entry[:source_start]
  entry[:destination_start] + difference
end

locations = seeds.map do |seed|
  soil = mapping(seed_to_soil, seed)
  fertilizer = mapping(soil_to_fertilizer, soil)
  water = mapping(fertilizer_to_water, fertilizer)
  light = mapping(water_to_light, water)
  temperature = mapping(light_to_temperature, light)
  humidity = mapping(temperature_to_humidity, temperature)
  location = mapping(humidity_to_location, humidity)
  location
end

pp locations.min
