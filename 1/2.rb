data = File.readlines('data1.txt')

NUMBERS = { 'one' => 1,
            'two' => 2,
            'three' => 3,
            'four' => 4,
            'five' => 5,
            'six' => 6,
            'seven' => 7,
            'eight'=> 8,
            'nine' => 9 }

def get_number(str)
    first = last = 0
    str.length.times do |i|
        i_inv = -(i + 1)
        NUMBERS.each do |w, n|
            if first.zero? && str[i, w.length] == w
                first = n
            end
            if last.zero? && str[i_inv, w.length] == w
                last = n
            end
        end
        if first.zero? && ('0'..'9').include?(str[i])
            first = str[i].to_i
        end
        if last.zero? && ('0'..'9').include?(str[i_inv])
            last = str[i_inv].to_i
        end
        break if first > 0 && last > 0
    end
    first * 10 + last
end

puts data.map {|line| get_number(line)}.sum