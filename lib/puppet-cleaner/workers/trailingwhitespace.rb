module Puppet::Cleaner
  class TrailingWhitespace < Worker
    def part_names
      [:BLANK]
    end
  
    def operate(line)
      line.remove(line.position) if line.next.name == :RETURN
    end
  end
end
