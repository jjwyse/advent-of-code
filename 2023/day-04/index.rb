# frozen_string_literal: true

##########
# Part 1 #
##########
file = File.open("#{Dir.pwd}/2023/day-04/input.txt")
cards = file.readlines.map(&:chomp).map(&:to_s)
card_points = {}
cards.each do |card|
  card_number = card.split(':')[0].split(' ')[1].to_i
  winning_numbers = card.split(':')[1].split('|')[0].split(' ').map(&:to_i)
  numbers_you_have = card.split(':')[1].split('|')[1].split(' ').map(&:to_i)

  numbers_you_have.each do |number_you_have|
    next unless winning_numbers.include?(number_you_have)

    card_points[card_number] = (
      if card_points[card_number].nil?
        1
      else
        card_points[card_number] * 2
      end
    )
  end
end

# pp card_points.values.sum
# 21959

##########
# Part 2 #
##########
card_metadata = []
cards.each do |card|
  card_number = card.split(':')[0].split(' ')[1].to_i
  winning_numbers = card.split(':')[1].split('|')[0].split(' ').map(&:to_i)
  numbers_you_have = card.split(':')[1].split('|')[1].split(' ').map(&:to_i)

  card_metadata << {
    card: card_number,
    count: 1,
    matches: 0
  }

  numbers_you_have.each do |number_you_have|
    next unless winning_numbers.include?(number_you_have)

    metadata = card_metadata.select { |c| c[:card] == card_number }
    metadata.first[:count] = 1
    metadata.first[:matches] = metadata.first[:matches] + 1
  end
end


card_metadata.each do |metadata|
  card = metadata[:card]
  matches = metadata[:matches]

  metadata[:count].times do
    card_metadata.select { |c| ((card + 1)...(card + matches + 1)).include?(c[:card]) }.each do |inner_metadata|
      inner_metadata[:count] = inner_metadata[:count] + 1
    end
  end
end

pp card_metadata.sum { |m| m[:count] }