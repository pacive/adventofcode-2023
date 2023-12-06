def parse(data)
    times = data[0].split(/:\s+/)[1].gsub(/\s+/, '').to_i
    dists = data[1].split(/:\s+/)[1].gsub(/\s+/, '').to_i
    [times, dists]
end

time, dist = parse(File.readlines('input'))

d = Math.sqrt(time **  2 / 4.0 - (dist + 0.1))
if time.even?
    puts d.floor * 2 + 1
else
    puts d.round * 2
end
