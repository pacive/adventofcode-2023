def parse(data)
    times = data[0].split(/:\s+/)[1].split(/\s+/).map(&:to_i)
    dists = data[1].split(/:\s+/)[1].split(/\s+/).map(&:to_i)
    [times, dists]
end

times, dists = parse(File.readlines('input'))

total = []

times.length.times do |i|
    c = times[i] / 2
    wins = times[i].even? ? -1 : 0
    while c * (times[i] - c) > dists[i]
        wins += 2
        c -= 1
    end
    total << wins
end

puts total.reduce(&:*)