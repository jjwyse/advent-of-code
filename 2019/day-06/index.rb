require 'set'

# Read in orbits
raw_orbits_from_file = File.open('input.txt').readlines.map(&:chomp)
@cache = {}

###################
# Part 1
###################

def find_direct_orbits(orbits:)
  # Returns:
  #
  # {
  #   planet_a: [planets, that, orbit, said, planet]
  #   planet_b: [planets, that, orbit, said, planet]
  # }
  #
  orbits.reduce({}) do |orbit_map, orbit|
    planets = orbit.split(')')

    # ABC)DEF =>
    #  planet = ABC
    #  orbited_by = DEF
    planet = planets[0]
    orbited_by = planets[1]

    # Initialize to empty array if needed
    orbit_map[planet] = [].to_set if orbit_map[planet].nil?
    orbit_map[orbited_by] = [].to_set if orbit_map[orbited_by].nil?

    # Add orbited_by to planet
    orbit_map[planet] << orbited_by

    orbit_map
  end
end

def find_indirect_orbits(planet:, orbits:, current_stack:)
  direct_orbits = orbits[planet]

  indirect_orbits = [].to_set
  direct_orbits.each do |direct_orbit|
    direct_orbits_on_orbits = orbits[direct_orbit]
    indirect_orbits += direct_orbits_on_orbits

    # Try to guard against circular dependency
    if !current_stack.include?(direct_orbit)
      current_stack << direct_orbit
      if @cache[direct_orbit].nil?
        indirect_orbits += find_indirect_orbits(planet: direct_orbit, orbits: orbits, current_stack: current_stack)
      else
        indirect_orbits += @cache[direct_orbit]
      end
    end
  end

  @cache[planet] = indirect_orbits
  indirect_orbits
end

all_orbits = find_direct_orbits(orbits: raw_orbits_from_file)
all_orbits.each do |planet, _|
  all_orbits[planet] += find_indirect_orbits(planet: planet, orbits: all_orbits, current_stack: [].to_set)
end

pp all_orbits.map { |k, v| v.count }.sum

###################
# Part 2
###################

def find_orbits_for_planet(planet:, orbits:)
  orbits.map do |p, o|
    next unless o.include?(planet)
    p
  end.compact
end

def find_distance_from_a_to_x(planet_a:, planet_b:, orbits:)
  return 999_999_999  if planet_a.nil?

  direct_orbits = orbits[planet_a]

  # Went down a trail that didn't include our planet_b, ignore
  return 999_999_999 if direct_orbits.empty?

  # Found base case - don't count from last planet to the planet_b planet
  return 0 if direct_orbits.include?(planet_b)

  # HACK - there are never more than 3 direct orbits of any planet we care about
  path_a = 1 + find_distance_from_a_to_x(planet_a: direct_orbits.to_a[0], planet_b: planet_b, orbits: orbits)
  path_b = 1 + find_distance_from_a_to_x(planet_a: direct_orbits.to_a[1], planet_b: planet_b, orbits: orbits)
  path_c = 1 + find_distance_from_a_to_x(planet_a: direct_orbits.to_a[2], planet_b: planet_b, orbits: orbits)
  [path_a, path_b, path_c].min
end

# Find the common planets that both SAN and YOU orbit
planets_santa_orbits = find_orbits_for_planet(planet: 'SAN', orbits: all_orbits)
planets_you_orbits = find_orbits_for_planet(planet: 'YOU', orbits: all_orbits)
common_planet_orbits = planets_santa_orbits  & planets_you_orbits

# Calculate distances from each common planet to SAN or YOU planet
direct_orbits = find_direct_orbits(orbits: raw_orbits_from_file)

total_distances = {}
common_planet_orbits.each do |planet|
  san_distance = find_distance_from_a_to_x(planet_a: planet, planet_b: 'SAN', orbits: direct_orbits)
  you_distance = find_distance_from_a_to_x(planet_a: planet, planet_b: 'YOU', orbits: direct_orbits)

  total_distances[san_distance + you_distance] = planet
end

pp total_distances.sort.first[0]

