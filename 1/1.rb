data = File.readlines('data1.txt')

def get_number(str)
    first = last = 0
    str.length.times do |i|
        i_inv = -(i + 1)
        if first.zero? && ('0'..'9').include?(str[i])
            first = str[i].to_i
        end
        if last.zero? && ('0'..'9').include?(str[i_inv])
            last = str[i_inv].to_i
        end
    end
    first * 10 + last
end

puts data.map {|line| get_number(line)}.sum