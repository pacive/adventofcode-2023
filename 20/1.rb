class MsgQueue
    attr_reader :counter
    def initialize
        @queue = []
        @counter = { high: 0, low: 0 }
    end

    def event()
        pulse = @queue.pop
        puts "Sending #{pulse.type} from #{pulse.src.name} to #{pulse.dst.name}"
        @counter[pulse.type] += 1
        pulse.dst.receive_pulse(pulse)
    end

    def put(pulse)
        @queue.unshift(pulse)
    end

    def start()
        until @queue.empty? do
            event()
        end
    end
end


class Pulse
    attr_reader :src, :dst, :type

    def initialize(src, dst, type)
        @src = src
        @dst = dst
        @type = type
    end
end

class Node
    attr_reader :name

    def initialize(name, queue)
        @name = name
        @outputs = []
        @queue = queue
    end

    def send_pulse(dst, type)
        @queue.put(Pulse.new(self, dst, type))
    end

    def receive_pulse(pulse)
    end

    def add_output(node)
        @outputs << node
    end

    def inspect
        "#{self.class}: #{@name} #{@outputs.map(&:name)}"
    end
end

class Button < Node
    def push()
        @outputs.each do |node|
            send_pulse(node, :low)
        end
    end
end

class Broadcaster < Node
    def receive_pulse(pulse)
        @outputs.each do |node|
            send_pulse(node, :low)
        end
    end
end

class FlipFlop < Node
    def initialize(name, queue)
        @state = false
        super
    end

    def receive_pulse(pulse)
        if pulse.type == :low
            @state = !@state
            @outputs.each do |node|
                send_pulse(node, @state ? :high : :low)
            end
        end
    end
end

class Conjunction < Node
    def initialize(name, queue)
        @states = {}
        super
    end

    def add_input(node)
        @states[node] = false
    end
    
    def receive_pulse(pulse)
        @states[pulse.src] = pulse.type == :high ? true : false
        type = @states.values.all? ? :low : :high
        @outputs.each do |node|
            send_pulse(node, type)
        end
    end
end

class Output < Node
end

def parse(input, queue)
    nodes = {}
    outputs = {}
    input.each do |line|
        name, out = line.strip.split(' -> ')
        if name == 'broadcaster'
            nodes[name] = Broadcaster.new(name, queue)
        elsif name.start_with?('%')
            name = name[1..]
            nodes[name] = FlipFlop.new(name, queue)
        elsif name.start_with?('&')
            name = name[1..]
            nodes[name] = Conjunction.new(name, queue)
        end
        outputs[name] = out.split(', ')
    end
    button = Button.new('button', queue)
    button.add_output(nodes['broadcaster'])
    nodes['button'] = button
    outputs.each do |name, out|
        out.each do |o|
            src = nodes[name]
            dst = nodes[o]
            if dst.nil?
                dst = Output.new(o, queue)
                nodes[o] = dst
            end
            src.add_output(dst)
            if dst.is_a?(Conjunction)
                dst.add_input(src)
            end
        end
    end
    nodes
end

queue = MsgQueue.new
nodes = parse(File.readlines('input'), queue)

1000.times do
    nodes['button'].push
    queue.start
end

puts queue.counter
puts queue.counter[:high] * queue.counter[:low]