def h(str)
    str.bytes.reduce(0) { |acc, v| ((acc + v) * 17) % 256 }
end

puts File.read('input').strip.split(',').reduce(0) { |acc, str| acc + h(str) }