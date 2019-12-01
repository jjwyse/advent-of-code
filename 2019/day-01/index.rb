file = File.open('input.txt')
masses = file.readlines.map(&:chomp).map(&:to_i)

###################
# Part 1
###################

def calculate_fuel(mass:)
  (mass / 3).round(half: :down) - 2
end

part_1_answer = masses.map { |mass| calculate_fuel(mass: mass) }.reduce(:+)
pp part_1_answer

###################
# Part 2
###################

def calculate_fuels(mass:)
  fuel = calculate_fuel(mass: mass)
  return 0 if fuel <= 0
  fuel + calculate_fuels(mass: fuel)
end

part_2_answer = masses.map { |mass| calculate_fuels(mass: mass) }.reduce(:+)
pp part_2_answer
