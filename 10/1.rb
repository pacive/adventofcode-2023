class Maze

    attr_reader :x, :y, :dir, :loop_length

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
            @dir = case @data[@x][@y]
                   when '|' then :N
                   when '7' then :W
                   when 'F' then :E
                   end
        when :E
            @y += 1
            @dir = case @data[@x][@y]
                   when '-' then :E
                   when '7' then :S
                   when 'J' then :N
                   end
         when :S
            @x += 1
            @dir = case @data[@x][@y]
                   when '|' then :S
                   when 'J' then :W
                   when 'L' then :E
                   end
        when :W
            @y -= 1
            @dir = case @data[@x][@y]
                   when '-' then :W
                   when 'L' then :N
                   when 'F' then :S
                   end
        end
    end


    def find_loop()
        @loop_length = 1
        move()
        until @data[@x][@y] == 'S'
            move()
            @loop_length += 1
        end
    end
end

maze = Maze.new(File.readlines('input'))

maze.find_loop

puts maze.loop_length / 2
