data = File.readlines('input')

gear_ratios = []

def find_number(line, pos)
    return nil unless line[pos].match?(/\d/)

    i = pos
    while line[i].match?(/\d/)
        i -= 1
    end
    i += 1
    line[i].to_i
end

def get_part_numbers(input, line, pos)
    part_numbers = []
    lines = ((li > 0 ? li - 1 : li)..(li == input.length - 1 ? li : li + 1))
    start_check = pos > 0 ? pos - 1 : pos

end

data.length.times do |li|
    ci = 0
    while ci < data[li].length
        if data[li][ci] == '*'
            adj = []
            debug = true
            start_check = (ci > 0 ? ci - 1 : ci)
            lines = ((li > 0 ? li - 1 : li)..(li == data.length - 1 ? li : li + 1))
            if debug
                puts "--#{li}:#{start_check}--"
                lines.each {|l| puts "  #{data[l][start_check, 3]}" }
            end
            lines.each do |l|
                #debug = lines == (0..2)
                i = start_check
                #puts "--#{l}:#{start_check}-- #{data[l][i, 3]}" if debug
                while i < start_check + 3
                    digit = data[l][i].match?(/\d/)
                    while data[l][i].match?(/\d/)
                        i -= 1
                    end
                    i += 1 if digit
                    #puts "#{l}:#{i} - #{data[l][i, 3]} #{digit}" if debug
                    num = data[l][i, data[l].length].to_i
                    adj << num unless num.zero?
                    i += num.digits.length
                end
            end
            print adj.inspect if debug
            if adj.length == 2
                mul = adj[0] * adj[1]
                puts " = #{mul}"
                gear_ratios << mul
            else
                puts
            end
        end
        ci += 1
    end
end

puts gear_ratios.sum
