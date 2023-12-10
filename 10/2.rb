require 'set'

class Maze

    attr_reader :x, :y, :dir, :loop_length, :loop_tiles, :data

    def initialize(data)
        @data = data
        find_start
    end

    def find_start()
        @x, @y = 0, 0
        until @y = @data[@x].index('S') do
            @x += 1
        end
        if %w(| 7 F).include?(@data[@x - 1][@y])
            @dir = :N
            return
        end
        if %w(- 7 J).include?(@data[@x][@y + 1])
            @dir = :E
            return
        end
        if %w(| J L).include?(@data[@x + 1][@y])
            @dir = :S
            return
        end
    end
        
    def move()
        case @dir
        when :N
            @x -= 1
        when :E
            @y += 1
         when :S
            @x += 1
        when :W
            @y -= 1
        end
    end

    def turn()
        case @dir
        when :N
            @dir = case @data[@x][@y]
                   when '|' then :N
                   when '7' then :W
                   when 'F' then :E
                   else @dir
                   end
        when :E
            @dir = case @data[@x][@y]
                   when '-' then :E
                   when '7' then :S
                   when 'J' then :N
                   else @dir
                   end
         when :S
            @dir = case @data[@x][@y]
                   when '|' then :S
                   when 'J' then :W
                   when 'L' then :E
                   else @dir
                   end
        when :W
            @dir = case @data[@x][@y]
                   when '-' then :W
                   when 'L' then :N
                   when 'F' then :S
                   else @dir
                   end
        end
    end

    def find_loop()
        @loop_length = 1
        @loop_tiles = Set[@x, @y]
        move()
        turn()
        until @data[@x][@y] == 'S'
            @loop_tiles << [@x, @y]
            move()
            turn()
            @loop_length += 1
        end
    end

    def isolate_path
        if @loop_tiles.nil?
            find_loop()
        end
        @data.length.times do |i|
            @data[i].length.times do |j|
                @data[i][j] = '.' unless @loop_tiles.include?([i, j]) || @data[i][j] == "\n" || @data[i][j] == 'S'
            end
        end
        find_start
        move()
        replace_right_hand_symbol('.', ' ')
        turn()
        replace_right_hand_symbol('.', ' ')
        until @data[@x][@y] == 'S'
            move()
            replace_right_hand_symbol('.', ' ')
            turn()
            replace_right_hand_symbol('.', ' ')
        end
        @data.length.times do |i|
            @data[i].length.times do |j|
                if j == 0
                    if @data[i][j] == '.'
                        @data[i][j] = ' '
                    end
                elsif @data[i][j] == '.' && @data[i][j - 1] == ' '
                    @data[i][j] = ' '
                end
            end
        end
    end

    def replace_right_hand_symbol(char, replace)
        x, y = case @dir
        when :N then [@x, @y + 1]
        when :E then [@x + 1, @y]
        when :S then [@x, @y - 1]
        when :W then [@x - 1, @y]
        end
        return if x < 0 || y < 0 || x >= @data.length || y > @data[x].length

        if @data[x][y] == char
            @data[x][y] = replace
        end
    end
end

maze = Maze.new(File.readlines('input'))

maze.find_loop

maze.isolate_path

File.write('cleaned_input', maze.data.join)

puts maze.data.join.count('.')
