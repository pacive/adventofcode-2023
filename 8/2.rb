require 'set'

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

nodeset = nodes.keys.select { |k| k.end_with?('A') }
cycles = []

nodeset.each do |node|
    path = []
    path_set = Set.new
    steps_to_z = 0
    steps = 0
    i = 0
    directions.cycle do |d|
        path << [node, i]
        path_set << [node, i]
        steps += 1
        i = steps % directions.length
        node = nodes[node][d]
        steps_to_z = steps if node.end_with?('Z')
        break if path_set.include?([node, i])
    end
    cycles << [path.index([node, i]), steps, steps_to_z]
end

# Turns out this is always true
if cycles.all? { |c| c[2] == c[1] - c[0] }
    puts cycles.map { |c| c[2] }.reduce(:lcm)
end