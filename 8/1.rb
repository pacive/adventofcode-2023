def parse(data)
    directions = data[0].strip.split('')
    nodes = {}
    data[2, data.length].each do |line|
        node, dir = line.strip.split(' = ')
        left, right = dir.gsub(/[)(]/, '').split(', ')
        nodes[node] = { 'L' => left, 'R' => right }
    end
    [directions, nodes]
end

directions, nodes = parse(File.readlines('input'))


node = 'AAA'
steps = 0
directions.cycle do |d|
    steps += 1
    node = nodes[node][d]
    break if node == 'ZZZ'
end

puts steps