def parse(data)
    fields = []
    nums = []
    data.each do |line|
        field, num = line.split(' ')
        fields << field
        nums << num.split(',').map(&:to_i)
    end
    [fields, nums]
end

def fit(field, lengths)
    return 0 if field.nil?
    limit = field.length - lengths.sum - lengths.length + 1
    combinations = 0
    pos = 0
    while pos <= limit && !field[...pos].include?('#') do 
        if field[pos, lengths[0]].include?('.')
            pos += 1
            next
        end
        if field[pos + lengths[0]] != '#'
            if lengths.length > 1
                combinations += fit(field[(pos + lengths[0] + 1)..], lengths[1..])
            elsif field[pos + lengths[0]].nil? || !field[(pos + lengths[0] + 1)..].include?('#')
                combinations += 1
            end
        end
        pos += 1
    end
    combinations
end

fields, nums = parse(File.readlines('input'))

sum = 0
fields.length.times do |i|
    sum += fit(fields[i], nums[i])
end
puts sum