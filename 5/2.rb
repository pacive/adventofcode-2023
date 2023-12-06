require 'set'

def equivalence_classes(range, mappings)
    r = range
    classes = Set.new
    mappings.each do |m|
        if m[0].cover?(r)
            classes.add(r)
            break
        end

        if m[0].cover?(r.end)
            classes.merge([(r.begin...m[0].begin), (m[0].begin...r.end)])
            break
        end

        if m[0].cover?(r.begin)
            classes << (r.begin...m[0].end)
            r = (m[0].end...r.end)
        end

    end
    classes
end
        
def map(r, mappings)
    mappings.each do |m|
        if (m[0]).cover?(r)
            return ((m[1] + r.begin - m[0].begin)...(m[1] + r.end - m[0].begin))
        end
    end
    r
end

def parse_seeds(line)
    seeds = []
    s = line.split(': ')[1].split(' ').map(&:to_i)
    i = 0
    while i < s.length do
        seeds << Set[(s[i]...s[i] + s[i + 1])]
        i += 2
    end
    seeds.to_set
end

def parse_mapping(lines)
    mappings = lines.map do |line|
        nums = line.split(' ').map(&:to_i)
        [(nums[1]...(nums[1] + nums[2])), nums[0]]
    end.sort { |a, b| a[0].begin <=> b[0].begin }
    m_new = []
    0.upto(mappings.length - 2) do |i|
        m_new << mappings[i]
        if mappings[i][0].end < mappings[i + 1][0].begin
            m_new << [(mappings[i][0].end...mappings[i + 1][0].begin), mappings[i][0].end]
        end
    end
    m_new << mappings[-1]
    m_new
end

def parse(data)
    seeds = parse_seeds(data[0])
    
    mappings = []

    mapping_lines = []
    data[2, data.length].each do |line|
        if line =~ /[\w\s]+:/
            mapping_lines = []
        elsif line == "\n"
            mappings << parse_mapping(mapping_lines)
        else
            mapping_lines << line
        end
    end
    mappings << parse_mapping(mapping_lines)
    [seeds, mappings]
end

seeds, mappings = parse(File.readlines('input'))

seeds.map! do |seed_set|
    s = seed_set
    mappings.each do |mapping|
        s.map! do |sr|
            equivalence_classes(sr, mapping).map { |c| map(c, mapping) }.to_set
        end
        s.flatten!
    end
    s
end

puts seeds.map { |s| s.map {|r| r.begin }.min }.min