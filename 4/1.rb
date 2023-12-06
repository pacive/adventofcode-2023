def get_points(winning, your)
    points = 0
    your.each do |n|
        if winning.include?(n)
            if points == 0
                points = 1
            else
                points *= 2
            end
        end
    end
    points
end

def parse(card)
    numbers = card.split(': ')[1]
    winning, your = numbers.split(' | ').map { |s| s.split(' ').map(&:to_i) }
    get_points(winning, your)
end

puts File.readlines('input').map { |line| parse(line) }.sum