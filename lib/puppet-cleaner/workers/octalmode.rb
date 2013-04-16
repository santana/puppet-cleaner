module Puppet::Cleaner
  class OctalMode < Worker
    def part_names
      [:FARROW]
    end
  
    def operate(line)
      prev = line.prev.name == :BLANK ? line.prev(2) : line.prev
      return if prev.value != "mode"
      pos = line.next.name == :BLANK ? line.position + 2 : line.position + 1
      mode = line.parts[pos]
  
      if mode.value =~ /^0?[0-7]{1,4}$/
        line.parts[pos] = Part.create([:STRING, {:value => mode.value.rjust(4, "0")}])
      end
    end
  end
end
