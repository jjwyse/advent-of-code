# frozen_string_literal: true

##########
# Part 1 #
##########
file = File.open("#{Dir.pwd}/2023/day-02/input.txt")
games = file.readlines.map(&:chomp).map(&:to_s)
game_summaries = games.map do |game|
  game_sets = game.split(':')
  {
    game: game_sets[0].chomp.split(' ')[1].to_i,
    sets: game_sets[1].split(';').map(&:chomp).map do |set|
      set.split(',').map do |count_color|
        {
          count: count_color.chomp.split(' ')[0].chomp.to_i,
          color: count_color.chomp.split(' ')[1].chomp
        }
      end
    end.flatten
  }
end

valid_game_numbers = game_summaries.map do |summary|
  if summary[:sets].any? do |set|
    (set[:color] == 'red' && set[:count] > 12) ||
    (set[:color] == 'green' && set[:count] > 13) ||
    (set[:color] == 'blue' && set[:count] > 14)
  end
    nil
  else
    summary[:game]
  end
end.compact

# pp valid_game_numbers.sum
# 2105

##########
# Part 2 #
##########
file = File.open("#{Dir.pwd}/2023/day-02/input.txt")
games = file.readlines.map(&:chomp).map(&:to_s)
game_summaries = games.map do |game|
  game_sets = game.split(':')
  {
    game: game_sets[0].chomp.split(' ')[1].to_i,
    sets: game_sets[1].split(';').map(&:chomp).map do |set|
      set.split(',').map do |count_color|
        {
          count: count_color.chomp.split(' ')[0].chomp.to_i,
          color: count_color.chomp.split(' ')[1].chomp
        }
      end
    end.flatten
  }
end

powers = game_summaries.map do |summary|
  red_max = summary[:sets].select { |set| set[:color] == 'red' }.map { |red_sets| red_sets[:count] }.max
  green_max = summary[:sets].select { |set| set[:color] == 'green' }.map { |red_sets| red_sets[:count] }.max
  blue_max = summary[:sets].select { |set| set[:color] == 'blue' }.map { |red_sets| red_sets[:count] }.max
  red_max * green_max * blue_max
end

# pp powers.sum
# 72422