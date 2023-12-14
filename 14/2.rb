require 'set'

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

def roll_west(field)
    field.length.times do |i|
        1.upto(field[i].length - 1) do |j|
            if field[i][j] == 'O'
                k = j - 1
                while k >= 0 && field[i][k] == '.'
                    field[i][k] = 'O'
                    field[i][k + 1] = '.'
                    k -= 1
                end
            end
        end
    end
end

def roll_south(field)
    (field.length - 2).downto(0) do |i|
        field[i].length.times do |j|
            if field[i][j] == 'O'
                k = i + 1
                while k < field.length && field[k][j] == '.'
                    field[k][j] = 'O'
                    field[k - 1][j] = '.'
                    k += 1
                end
            end
        end
    end
end

def roll_east(field)
    field.length.times do |i|
        (field[i].length - 2).downto(0) do |j|
            if field[i][j] == 'O'
                k = j + 1
                while k < field[i].length && field[i][k] == '.'
                    field[i][k] = 'O'
                    field[i][k - 1] = '.'
                    k += 1
                end
            end
        end
    end
end

def cycle(field)
    roll_north(field)
    roll_west(field)
    roll_south(field)
    roll_east(field)
end

def calc_weight(field)
    weight = 0
    field.length.times do |i|
        weight += field[i].count('O') * (field.length - i)
    end
    weight
end

def find_loop(seq, limit = 1000)
    sample = []
    loop_length = nil
    loop_start = nil
    limit.times do |i|
        cycle(seq)
        weight = calc_weight(seq)
        sample << weight
        loop_start = sample[...i].rindex(weight)
        if loop_start.nil? || loop_start > i - 2
            loop_start = nil
            loop_length = nil
            next
        end
        loop_length = i - loop_start
        loop_length.times do |j|
            if sample[i - j - loop_length] != sample[i - j]
                loop_start = nil
                loop_length = nil
                break
            end
        end
        return [loop_start + 1, sample[loop_start, loop_length]] if loop_start && loop_length
    end
end

field = File.readlines('input')

offset, sample = find_loop(field)

puts sample[(1_000_000_000 - offset) % sample.length]
