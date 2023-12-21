require 'set'

class Node
    attr_reader :x, :y, :neighbors

    def initialize(x, y)
        @x = x
        @y = y
        @neighbors = {}
    end

    def add_neighbor(direction, node)
        @neighbors[direction] = node
    end

    def remove_neighbor(direction)
        @neighbors.delete(direction)
    end

    def neighbor?(direction)
        @neighbors.key?(direction)
    end

    def inspect
        "<Node: (#{x}, #{y}) #{neighbors.keys}>"
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
                graph[x][y] = Node.new(x, y)
                if x > 0 && %w(. S).include?(grid[x - 1][y])
                    graph[x - 1][y].add_neighbor(2, graph[x][y])
                    graph[x][y].add_neighbor(0, graph[x - 1][y])
                end
                if y > 0 && %w(. S).include?(grid[x][y - 1])
                    graph[x][y - 1].add_neighbor(1, graph[x][y])
                    graph[x][y].add_neighbor(3, graph[x][y - 1])
                end
            end
        end
        new(graph)
    end

    def initialize(graph)
        @graph = graph
    end

    def[](x, y)
        @graph[x][y]
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

file = 'input'

grid = File.readlines(file).map(&:strip).map(&:chars)
graph = Graph.construct(grid)

steps = file == 'test' ? 6 : 64
start = [nil, nil]
grid.length.times do |x|
    break unless start == [nil, nil]
    grid[x].length.times do |y|
        if grid[x][y] == 'S'
            start = [x, y]
            break
        end
    end
end

possibilities = Set[graph[*start]]

steps.times do
    p_next = Set.new
    possibilities.each do |node|
        p_next.merge(node.neighbors.values)
    end
    possibilities = p_next
end

puts possibilities.size
