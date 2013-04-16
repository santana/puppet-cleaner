module Puppet::Cleaner
  class UnneededQuotes < Worker
    def part_names
      [:VARIABLE]
    end
  
    def operate(line)
      return unless line.prev.name == :DQPRE && line.next.name == :DQPOST
      return unless line.prev.value.empty? && line.next.value.empty?
      pos = line.position
      line.remove(pos + 1)
      line.remove(pos - 1)
      line.back!
    end
  end
end
