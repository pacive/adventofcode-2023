MAX = { red: 12, green: 13, blue: 14 }

def parse_runs(runs)
    runs.split('; ').map do |run|
        run.split(', ').reduce({}) do |collector, colors|
            n, c = colors.split(' ')
            collector.merge(c.to_sym => n.to_i)
        end
    end
end

def possible(line)
    game, runs = line.split(': ')
    parse_runs(runs).each do |run|
        MAX.each do |k, v|
            return 0 if run.has_key?(k) && run[k] > v
        end
    end
    game.split(' ')[1].to_i
end

puts File.readlines('input').map {|line| possible(line) }.sum