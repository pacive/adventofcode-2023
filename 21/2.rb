require 'set'

class Point
    attr_reader :x, :y
    def initialize(x, y)
        @x = x
        @y = y
    end

    def ==(other)
        @x == other.x && y == other.y
    end

    alias :eql? :==

    def inspect
        "(#{@x}, #{@y})"
    end

    def +(other)
        Point.new(@x + other.x, @y + other.y)
    end

    def hash()
         [@x, @y].hash
    end

    alias :to_s :inspect
end

class Node
    attr_reader :coords

    def initialize(point)
        @coords = point
        @neighbors = Array.new(4)
    end

    def add_neighbor(direction, point)
        @neighbors[direction] = point
    end

    def remove_neighbor(direction)
        @neighbors[direction] = nil
    end

    def neighbor?(direction)
        !@neighbors[direction].nil?
    end

    def neighbors
        @neighbors.reject(&:nil?)
    end

    def inspect
        "<Node: #{@coords} #{@neighbors}>"
    end

    alias :to_s :inspect
end

class Graph
    attr_reader :graph

    def self.construct(grid)
        graph = []
        grid.length.times do |x|
            graph << []
            grid[x].length.times do |y|
                graph[x] << nil
                next if grid[x][y] == '#'
                graph[x][y] = Node.new(Point.new(x, y))
                if x > 0 && %w(. S).include?(grid[x - 1][y])
                    graph[x - 1][y].add_neighbor(2, Point.new(1, 0))
                    graph[x][y].add_neighbor(0, Point.new(-1, 0))
                end
                if y > 0 && %w(. S).include?(grid[x][y - 1])
                    graph[x][y - 1].add_neighbor(1, Point.new(0, 1))
                    graph[x][y].add_neighbor(3, Point.new(0, -1))
                end
            end
        end
        new(graph)
    end

    def initialize(graph)
        @graph = graph
    end

    def [](point)
        x = point.x % @graph.length
        y = point.y % @graph[x].length
        @graph[x][y]
    end

    def wrap!()
        @graph.length.times do |x|
            unless @graph[x][0].nil? || @graph[x][-1].nil?
                @graph[x][0].add_neighbor(3, Point.new(0, -1))
                @graph[x][-1].add_neighbor(1, Point.new(0, 1))
            end
        end
        @graph[0].length.times do |y|
            unless @graph[0][y].nil? || @graph[-1][y].nil?
                @graph[0][y].add_neighbor(0, Point.new(-1, 0))
                @graph[-1][y].add_neighbor(2, Point.new(1, 0))
            end
        end
    end

    def to_s
        out = []
        x = 0
        while x < @graph.length
            out << '' << ''
            @graph[x].length.times do |y|
                node = @graph[x][y]
                if node.nil?
                    out[x * 2] << '# '
                    out[x * 2 + 1] << '  '
                else
                    out[x * 2] << '.'
                    if node.neighbor?(1)
                        out[x * 2] << '-'
                    else
                        out[x * 2] << ' '
                    end
                    if node.neighbor?(2)
                        out[x * 2 + 1] << '| '
                    else
                        out[x * 2 + 1] << '  '
                    end
                end
            end
            x += 1
        end
        out[..-2].join("\n")
    end
end

grid = File.readlines('input').map(&:strip).map(&:chars)
graph = Graph.construct(grid)
graph.wrap!

period = grid.length.lcm(grid[0].length) * 2
target = 26501365
steps = period * 6

start = nil
grid.length.times do |x|
    break unless start.nil?
    grid[x].length.times do |y|
        if grid[x][y] == 'S'
            start = Point.new(x, y)
            break
        end
    end
end

possibilities = Set[start]
visited = [Set.new, Set.new]
num = []
steps.times do |i|
    p_next = Set.new
    visited[i % 2].merge(possibilities)
    possibilities.each do |point|
        node = graph[point]
        p_next.merge(node.neighbors.map { |n| n + point}.reject { |n| visited[(i + 1) % 2].include?(n) })
    end
    possibilities = p_next
    num << possibilities.size + visited[(i + 1) % 2].size
end

offset = (target - 1) % period
periods = target / period

diff1 = num[offset + period * 1] - num[offset + period * 0]
diff2 = num[offset + period * 2] - num[offset + period * 1]
diff3 = num[offset + period * 3] - num[offset + period * 2]
until diff2 - diff1 == diff3 - diff2 do
    offset += period
    periods -= 1
    diff1 = num[offset + period * 1] - num[offset + period * 0]
    diff2 = num[offset + period * 2] - num[offset + period * 1]
    diff3 = num[offset + period * 3] - num[offset + period * 2]
end

increase = diff2 - diff1

puts num[offset] + ((periods) * (num[offset + period] - num[offset])) + increase * ((periods) * (periods - 1) / 2) 
