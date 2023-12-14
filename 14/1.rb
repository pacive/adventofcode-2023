def roll_north(field)
    1.upto(field.length - 1) do |i|
        field[i].length.times do |j|
            if field[i][j] == 'O'
                k = i - 1
                while k >= 0 && field[k][j] == '.'
                    field[k][j] = 'O'
                    field[k + 1][j] = '.'
                    k -= 1
                end
            end
        end
    end
end

def calc_weight(field)
    weight = 0
    field.length.times do |i|
        weight += field[i].count('O') * (field.length - i)
    end
    weight
end


field = File.readlines('input')

roll_north(field)

puts calc_weight(field)