require 'set'

class Hand
    CARDS = %w(2 3 4 5 6 7 8 9 T J Q K A)

    HANDS = %i(high pair two three house four five)

    attr_reader :hand, :bid

    def initialize(hand, bid)
        @hand = hand.chars
        @bid = bid.to_i
    end

    def type
        combined = :high
        Set.new(@hand).each do |c|
            case @hand.count(c)
            when 5
                return :five
            when 4
                return :four
            when 3
                if combined == :pair
                    return :house
                end
                combined = :three
            when 2
                if combined == :three
                    return :house
                elsif combined == :pair
                    return :two
                end
                combined = :pair
            end
        end
        combined
    end

    def <=>(other)
        ts, to = HANDS.index(type), HANDS.index(other.type)
        return ts <=> to unless ts == to

        5.times do |i|
            cs, co = CARDS.index(@hand[i]), CARDS.index(other.hand[i])
            return cs <=> co unless cs == co
        end
        return 0
    end

    def to_s
        "#{@hand.join} #{@bid}"
    end
end

hands = File.readlines('input').map { |line| Hand.new(*line.split(' ')) }.sort

total = 0

hands.each_with_index do |h, i|
    total += h.bid * (i + 1)
end

puts total
