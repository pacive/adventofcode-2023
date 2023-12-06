def parse_runs(runs)
    runs.split('; ').map do |run|
        run.split(', ').reduce({}) do |collector, colors|
            n, c = colors.split(' ')
            collector.merge(c.to_sym => n.to_i)
        end
    end
end

def power(line)
    parse_runs(line.split(': ')[1]).reduce({red: 0, green: 0, blue: 0}) do |min, h|
        min.merge(h) do |k, l, r|
            r > l ? r : l
        end
    end.values.reduce(:*)
end

puts File.readlines('input').map {|line| power(line) }.sum
