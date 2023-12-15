def h(str)
    str.bytes.reduce(0) { |acc, v| ((acc + v) * 17) % 256 }
end

boxes = []
256.times do
    boxes << [{}, []]
end

ops = File.read('input').strip.split(',').map do |str|
    op = str.include?('=') ? '=' : '-'
    label, f = str.split(op)
    [h(label), label, op, f.nil? ? nil : f.to_i]
end

ops.each do |b, l, o, f|
    box = boxes[b]
    if o == '='
        if box[0].key?(l)
            box[1][box[0][l]] = f
        else
            box[0][l] = box[1].length
            box[1] << f
        end
    else
        pos = box[0].delete(l)
        unless pos.nil?
            box[1].delete_at(pos)
            box[0].transform_values! { |v| v > pos ? v - 1 : v }
        end
    end
end

boxes.map! { |b| b[1] }

sum = 0
boxes.length.times do |i|
    boxes[i].length.times do |j|
        sum += (i + 1) * (j + 1) * boxes[i][j]
    end
end
puts sum