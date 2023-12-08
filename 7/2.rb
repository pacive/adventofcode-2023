require 'set'

class Hand
    CARDS = %w(J 2 3 4 5 6 7 8 9 T Q K A)

    HANDS = %i(high pair two three house four five)

    attr_reader :hand, :bid

    def initialize(hand, bid)
        @hand = hand.chars
        @bid = bid.to_i
    end

    def type
        return :five if @hand.count('J') == 5

        sorted = @hand.sort do |a, b|
            ac, bc = @hand.count(a), hand.count(b)
            if ac == bc
                CARDS.index(b) <=> CARDS.index(a)
            else
                bc <=> ac
            end
        end

        combined = :high
        joker_used = false
        (Set.new(sorted) - Set['J']).each do |c|
            case @hand.count(c) + (joker_used ? 0 : @hand.count('J'))
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
            joker_used = true
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
        "#{@hand.join} (#{type}) #{@bid}"
    end
end

hands = File.readlines('input').map { |line| Hand.new(*line.split(' ')) }.sort

total = 0

hands.each_with_index do |h, i|
    total += h.bid * (i + 1)
end

puts total
