def parse(data)
    times = data[0].split(/:\s+/)[1].split(/\s+/).map(&:to_i)
    dists = data[1].split(/:\s+/)[1].split(/\s+/).map(&:to_i)
    [times, dists]
end

times, dists = parse(File.readlines('input'))

total = []

times.length.times do |i|
    d = Math.sqrt(times[i] **  2 / 4.0 - (dists[i] + 0.1))
    if times[i].even?
        total << d.floor * 2 + 1
    else
        total << d.round * 2
    end
end

puts total.reduce(&:*)