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
