def expand(data)
    i = 0
    width = data[0].length
    while i < data.length do
        if data[i].chars.all? { |c| c == '.' }
            data.insert(i, '.' * width)
            i += 1
        end
        i += 1
    end
    i = 0
    while i < data[0].length do
        if data.all? { |line| line[i] == '.' }
            data.each { |line| line.insert(i, '.') }
            i += 1
        end
        i += 1
    end
    data
end

def find_galaxies(data)
    positions = []
    data.length.times do |x|
        data[x].length.times do |y|
            if data[x][y] == '#'
                positions << [x, y]
            end
        end
    end
    positions
end

def get_distances(positions)
    dists = []
    positions.length.times do |i|
        (i + 1).upto(positions.length - 1) do |j|
            dists << (positions[j][0] - positions[i][0]).abs + (positions[j][1] - positions[i][1]).abs
        end
    end
    dists
end

data = expand(File.readlines('input').map(&:strip))

pos = find_galaxies(data)

dists = get_distances(pos)

puts dists.sum