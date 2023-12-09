def extrapolate(seq)
    diffs = [seq]
    until diffs[-1].all?(&:zero?) do
        diffs << []
        1.upto(diffs[-2].length - 1) do |i|
            diffs[-1] << diffs[-2][i] - diffs[-2][i - 1]
        end
    end
    (diffs.length - 1).downto(1) do |i|
        diffs[i - 1] << diffs[i - 1][-1] + diffs[i][-1]
    end
    return diffs[0][-1]
end

puts File.readlines('input').map { |line| extrapolate(line.split(' ').map(&:to_i)) }.sum