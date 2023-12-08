# frozen_string_literal: true

require('set')

# Hand strengths:
# 1. Five of a kind, where all five cards have the same label: AAAAA
# 2. Four of a kind, where four cards have the same label and one card has a different label: AA8AA
# 3. Full house, where three cards have the same label, and the remaining two cards share a different label: 23332
# 4. Three of a kind, where three cards have the same label, and the remaining two cards are each different from any other card in the hand: TTT98
# 5. Two pair, where two cards share one label, two other cards share a second label, and the remaining card has a third label: 23432
# 6. One pair, where two cards share one label, and the other three cards have a different label from the pair and each other: A23A4
# 7. High card, where all cards' labels are distinct: 23456

##########
# Part 1 #
##########
file = File.open("#{Dir.pwd}/2023/day-07/input.txt")
games = file.readlines.map(&:chomp).map(&:to_s)

class Hand
  attr_reader :cards, :bid, :type, :type_score

  TYPES = {
    FIVE_OF_A_KIND: 7,
    FOUR_OF_A_KIND: 6,
    FULL_HOUSE: 5,
    THREE_OF_A_KIND: 4,
    TWO_PAIR: 3,
    ONE_PAIR: 2,
    HIGH_CARD: 1
  }.freeze

  CARDS = {
    'A': 14,
    'K': 13,
    'Q': 12,
    'J': 1,
    'T': 10,
    '9': 9,
    '8': 8,
    '7': 7,
    '6': 6,
    '5': 5,
    '4': 4,
    '3': 3,
    '2': 2
  }.freeze

  def initialize(cards:, bid:)
    @cards = cards
    @bid = bid
    @type = find_type
    @type_score = TYPES[type]
  end

  def <=>(other)
    if type_score != other.type_score
      other.type_score <=> type_score
    else
      # Same type of hand, sort by highest card up front
      result = CARDS[other.cards[0].to_sym] <=> CARDS[cards[0].to_sym]
      return result if result != 0

      result = CARDS[other.cards[1].to_sym] <=> CARDS[cards[1].to_sym]
      return result if result != 0

      result = CARDS[other.cards[2].to_sym] <=> CARDS[cards[2].to_sym]
      return result if result != 0

      result = CARDS[other.cards[3].to_sym] <=> CARDS[cards[3].to_sym]
      return result if result != 0

      CARDS[other.cards[4].to_sym] <=> CARDS[cards[4].to_sym]
    end
  end

  private

  def find_type
    tally = cards.tally
    unless tally['J'].nil?
      if tally.keys.count == 1
        # All wild Jacks! This is just five of a kind
        return :FIVE_OF_A_KIND
      end

      key = tally.reject { |card| card == 'J' }.sort_by { |card, _count| -CARDS[card.to_sym] }.sort_by { |_card, count| -count }.first[0]
      tally[key] = tally[key] + tally['J']
      tally.delete('J')
    end

    case tally.keys.count
    when 1
      :FIVE_OF_A_KIND
    when 2
      if tally.any? { |_card, count| count == 4 }
        :FOUR_OF_A_KIND
      else
        :FULL_HOUSE
      end
    when 3
      if tally.any? { |_card, count| count == 3 }
        :THREE_OF_A_KIND
      else
        :TWO_PAIR
      end
    when 4
      :ONE_PAIR
    else
      :HIGH_CARD
    end
  end
end

hands = games.map do |game|
  Hand.new(
    cards: game.split(' ')[0].split('').map(&:chomp).map(&:to_s),
    bid: game.split(' ')[1].chomp.to_i
  )
end.sort

result = hands.reverse.map.with_index do |hand, index|
  pp "Hand: #{hand.cards.join(',')} is a #{hand.type} ranked: #{index + 1}"
  hand.bid * (index + 1)
end

pp result.sum
# 248256639