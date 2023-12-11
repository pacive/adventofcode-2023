def expanded_rows(data)
    rows = []
    data.length.times do |i|
        if data[i].chars.all? { |c| c == '.' }
            rows << i
        end
    end
    rows
end

def expanded_cols(data)
    cols = []
    data[0].length.times do |i|
        if data.all? { |line| line[i] == '.' }
            cols << i
        end
    end
    cols
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

def get_distances(positions, rows, cols)
    dists = []
    positions.length.times do |i|
        (i + 1).upto(positions.length - 1) do |j|
            vrange = positions[j][0] < positions[i][0] ? (positions[j][0]..positions[i][0]) : (positions[i][0]..positions[j][0])
            hrange = positions[j][1] < positions[i][1] ? (positions[j][1]..positions[i][1]) : (positions[i][1]..positions[j][1])
            row_expansions = rows.select { |r| vrange.include?(r) }.length
            col_expansions = cols.select { |c| hrange.include?(c) }.length
            dist = vrange.size - 1 + hrange.size - 1
            dist += (row_expansions + col_expansions) * 999_999
            dists << dist
        end
    end
    dists
end

data = File.readlines('input').map(&:strip)

rows = expanded_rows(data)
cols = expanded_cols(data)

pos = find_galaxies(data)

dists = get_distances(pos, rows, cols)

puts dists.sum