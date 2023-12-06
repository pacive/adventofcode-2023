def parse(data)
    times = data[0].split(/:\s+/)[1].gsub(/\s+/, '').to_i
    dists = data[1].split(/:\s+/)[1].gsub(/\s+/, '').to_i
    [times, dists]
end

times, dists = parse(File.readlines('input'))

total = []

c = times / 2
wins = times.even? ? -1 : 0
while c * (times - c) > dists
    wins += 2
    c -= 1
end
puts wins
