module Puppet::Cleaner
  class TrailingWhitespaceInComments < Worker
    def part_names
      [:COMMENT]
    end
  
    def operate(line)
      line.current.value.rstrip!
    end
  end
end
