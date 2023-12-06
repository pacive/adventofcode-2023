data = File.readlines('input')

part_numbers = []

data.length.times do |li|
    ci = 0
    while ci < data[li].length
        if data[li][ci] =~ /\d/
            num = data[li][ci, data[li].length].to_i
            positions = ((ci > 0 ? ci - 1 : ci)..(ci + num.digits.length))
            lines = ((li > 0 ? li - 1 : li)..(li == data.length - 1 ? li : li + 1))
            lines.each do |l|
                if data[l][positions] =~ /[-*&$@\/#=%+]/
                    part_numbers << num
                    next
                end
            end
            ci += num.digits.length
        end
        ci += 1
    end
end

puts part_numbers.sum
            