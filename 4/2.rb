require 'set'

class Card
    attr_reader :winning, :your

    def self.parse(str)
        numbers = str.split(': ')[1]
        winning, your = numbers.split(' | ').map { |s| s.split(' ').map(&:to_i) }
        new(winning, your)
    end

    def initialize(winning, your)
        @winning = winning.to_set
        @your = your
    end

    def wins
        points = 0
        @your.each do |n|
            if @winning.include?(n)
                points += 1
            end
        end
        points
    end
end

def recurse(card_list, start = 0)
    num_cards = card_list[start].wins
    #puts "#{start}: #{wins} (#{num_cards})"
    num_cards.times do |i|
        num_cards += recurse(card_list, start + i + 1)
    end
    num_cards
end

cards = File.readlines('input').map { |line| Card.parse(line) }

total = cards.length
cards.length.times do |i|
    total += recurse(cards, i)
end
puts total