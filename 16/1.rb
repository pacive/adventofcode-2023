require 'matrix'
require 'set'

class Grid
    attr_reader :grid, :energized

    def initialize(grid)
        @grid = grid
        @energized = Matrix.zero(grid.length, grid[0].length)
    end

    def energize(x, y)
        @energized[x, y] = 1
    end

    def[](x, y)
        grid[x][y]
    end

    def width
        @grid[0].length
    end

    def height
        @grid.length
    end

    def to_s
        str = ''
        height.times do |i|
            @energized.row(i) do |n|
                str << (n.zero? ? '.' : '#')
            end
            str << "\n"
        end
        str
    end
end

class Beam
    def initialize(grid, x = 0, y = 0, direction = :right, path = Set.new)
        @grid = grid
        @x = x
        @y = y
        @direction = direction
        @path = path
        @grid.energize(@x, @y)
    end

    def move()
        case @direction
        when :right
            @y += 1
        when :down
            @x += 1
        when :left
            @y -= 1
        when :up
            @x -= 1
        end
    end

    def turn()
        case @grid[@x, @y]
        when '/'
            case @direction
            when :right
                @direction = :up
            when :down
                @direction = :left
            when :left
                @direction = :down
            when :up
                @direction = :right
            end
        when '\\'
            case @direction
            when :right
                @direction = :down
            when :down
                @direction = :right
            when :left
                @direction = :up
            when :up
                @direction = :left
            end
        end
    end

    def split()
        case @grid[@x, @y]
        when '-'
            if %i(up down).include?(@direction)
                Beam.new(@grid, @x, @y, :left, @path).trace
                Beam.new(@grid, @x, @y, :right, @path).trace
                true
            else
                false
            end
        when '|'
            if %i(left right).include?(@direction)
                Beam.new(@grid, @x, @y, :up, @path).trace
                Beam.new(@grid, @x, @y, :down, @path).trace
                true
            else
                false
            end
        end
    end

    def trace()
        loop do
            @grid.energize(@x, @y)
            @path << [@x, @y, @direction]
            if %w[/ \\].include?(@grid[@x, @y])
                turn
            elsif %w[- |].include?(@grid[@x, @y])
                break if split
            end
            move
            break if @x < 0 || @y < 0 || @x >= @grid.height ||
                     @y >= @grid.width || @path.include?([@x, @y, @direction])
        end
    end
end

grid = Grid.new(File.readlines('input').map(&:strip))

Beam.new(grid).trace

puts grid.energized.sum