def parse(data)
    segments = [[]]
    data.each do |line|
        if line == "\n"
            segments << []
            next
        end
        segments[-1] << line.strip.split('')
    end
    segments
end

def find_mirror(segment, transposed = false)
    breakpoint = 1
    found = false
    while breakpoint < segment.length
        offset = 0
        while breakpoint - offset - 1 >= 0 && breakpoint + offset < segment.length
            if segment[breakpoint - offset - 1] != segment[breakpoint + offset]
                found = false
                break
            end
            found = true
            offset += 1
        end
        return (transposed ? breakpoint : breakpoint * 100) if found
        breakpoint += 1
    end
    find_mirror(segment.transpose, true)
end

data = parse(File.readlines('input'))

puts data.map { |segment| find_mirror(segment) }.sum