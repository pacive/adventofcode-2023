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
        @rules.each do |rule|
            if input[rule[0]].send(rule[1], rule[2])
                return rule[3]
            end
        end
        @default
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

accepted = []
parts.each do |part|
    result = rules['in'].execute(part)
    while !['A', 'R'].include?(result)
        result = rules[result].execute(part)
    end
    if result == 'A'
        accepted << part
    end
end

puts accepted.reduce(0) { |sum, part| sum += part.values.sum }

