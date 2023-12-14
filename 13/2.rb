require 'set'

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

def off_by_1?(r1, r2)
    diffs = 0
    r1.length.times do |i|
        if r1[i] != r2[i]
            diffs += 1
        end
        return false if diffs > 1
    end
    true
end

def find_mirror(segment, transposed = false)
    breakpoint = 1
    found = false
    smudge_fixed = false
    while breakpoint < segment.length
        offset = 0
        while breakpoint - offset - 1 >= 0 && breakpoint + offset < segment.length
            if segment[breakpoint - offset - 1] != segment[breakpoint + offset]
                if !smudge_fixed && off_by_1?(segment[breakpoint - offset - 1], segment[breakpoint + offset])
                    smudge_fixed = true
                    offset += 1
                    found = true
                    next
                end
                found = false
                smudge_fixed = false
                break
            end
            found = true
            offset += 1
        end
        return (transposed ? breakpoint : breakpoint * 100) if found && smudge_fixed
        breakpoint += 1
    end
    find_mirror(segment.transpose, true)
end

data = parse(File.readlines('input'))

puts data.map { |segment| find_mirror(segment) }.sum
