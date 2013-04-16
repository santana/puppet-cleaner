module Puppet::Cleaner
  class QuotedBooleans
    def part_names
      [:STRING]
    end
  
    def operate(line)
      value = line.current.value
      return if !['true', 'false'].include?(value)
      line.parts.delete_at(line.position)
      line.insert(line.position, [Part.create([:NAME, {:value => value}])])
    end
  end
end
