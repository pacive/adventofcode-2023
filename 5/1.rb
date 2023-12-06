def map(n, mappings)
    mappings.each do |m|
        if (m[1]..(m[1] + m[2] - 1)).include?(n)
            return n - m[1] + m[0]
        end
    end
    n
end

def parse(data)
    seeds = data[0].split(': ')[1].split(' ').map(&:to_i)
    mappings = []

    data[1, data.length].each do |line|
        if line =~ /[\w\s]+:/
            mappings << []
        elsif line == "\n"
            next
        else
            mappings[-1] << line.split(' ').map(&:to_i)
        end
    end
    [seeds, mappings]
end

seeds, mappings = parse(File.readlines('input'))

seeds.map! do |seed|
    s = seed
    mappings.each do |m|
        s = map(s, m)
    end
    s
end

puts seeds.min