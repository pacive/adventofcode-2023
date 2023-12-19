class Ruleset
    def self.parse(str)
        rules = str.delete_prefix('{').delete_suffix('}').split(',')
        parsed = rules.map do |rule|
                    if rule.include?(':')
                        comp, target = rule.split(':')
                        param = comp[0]
                        comparator = comp[1].to_sym
                        value = comp[2..].to_i
                        [param, comparator, value, target]
                    else
                        [rule]
                    end
                end
        new(parsed)
    end

    def initialize(rules = [])
        @rules = rules
        @default = @rules.pop[0]
    end

    def execute(input)
        partitions = []
        @rules.each do |rule|
            parts = partition(input[rule[0]], rule[1], rule[2])
            partitions << [rule[3], input.merge({rule[0] => parts[0]})]
            input = input.merge({rule[0] => parts[1]})
        end
        partitions << [@default,  input]
        partitions
    end

    def partition(range, op, value)
        case op
        when :>
            return [((value + 1)..range.end), (range.begin..value)]
        when :<
            return [(range.begin..(value - 1)), (value..range.end)]
        end
    end
end

def parse(input)
    rules = {}
    parts = []
    target = :rules
    input.each do |line|
        if line == "\n"
            target = :parts
        elsif target == :rules
            id, rule = line.strip.split('{')
            rules[id] = Ruleset.parse(rule)
        else
            part = {}
            line.strip.delete_prefix('{').delete_suffix('}').split(',').each do |attribute|
                param, value = attribute.split('=')
                part[param] = value.to_i
            end
            parts << part
        end
    end
    [rules, parts]
end

rules, parts = parse(File.readlines('input'))

data = {'x' => (1..4000), 'm' => (1..4000), 'a' => (1..4000), 's' => (1..4000) }

sum_accepted = 0

result = rules['in'].execute(data)
until result.empty?
    result.reject! { |a| a[0] == 'R' }
    accepted, result = result.partition { |a| a[0] == 'A' }
    sum_accepted += accepted.reduce(0) { |sum, a| sum += a[1].values.map(&:size).reduce(:*) }
    result = result.map { |a| rules[a[0]].execute(a[1]) }.flatten(1)
end


puts sum_accepted
