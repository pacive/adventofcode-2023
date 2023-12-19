class Point
    attr_reader :x, :y

    def initialize(x, y)
        @x = x
        @y = y
    end

    def <=>(other)
        @x + @y <=> other.x + other.y
    end

    def -(other)
        raise if @x != other.x && @y != other.y
        @x == other.x ? @y - other.y : @x - other.x
    end
end

class Polygon
    def initialize(corners = [])
        @corners = corners
    end

    def closed?
        @corners[0] == @corners[-1]
    end

    def length
        sum = 0
        (@corners.length - 1).times do |i|
            sum += (@corners[i + 1] - @corners[i]).abs
        end
        sum
    end

    def area
        sum = 0
        (@corners.length - 1).times do |i|
            sum += (@corners[i].x * @corners[i + 1].y - @corners[i + 1].x * @corners[i].y)
        end
        sum.abs / 2
    end

    def contains?(point)
       @corners.partition { |p| p.x < point.x }.map { |part| part.partition { |p| p.y < point.y }}
    end
end

def parse(input)
    input.map do |line|
        direction, count, hex = line.strip.split(' ')
        [direction, count.to_i, hex.delete_prefix('(').delete_suffix(')')]
    end
end

def turn(prev, curr)
    case prev
    when 'U'
        return curr == 'R' ? :right : :left
    when 'R'
        return curr == 'D' ? :right : :left
    when 'D'
        return curr == 'L' ? :right : :left
    when 'L'
        return curr == 'U' ? :right : :left
    end
end

data = parse(File.readlines('input'))

x, y = 0, 0
points = [Point.new(x, y)]

last_turn = nil
next_turn = nil

data.length.times do |i|
    last_turn = turn(data[i - 1][0], data[i][0])
    next_turn = turn(data[i][0], i + 1 < data.length ? data[i + 1][0] : data[0][0])
    mod = 0
    if last_turn == :right && next_turn == :right
        mod = 1
    elsif last_turn == :left && next_turn == :left
        mod = -1
    end
    case data[i][0]
    when 'U'
        x -= data[i][1] + mod
    when 'D'
        x += data[i][1] + mod
    when 'R'
        y += data[i][1] + mod
    when 'L'
        y -= data[i][1] + mod
    end
    points << Point.new(x, y)
end

poly = Polygon.new(points)

puts poly.area
